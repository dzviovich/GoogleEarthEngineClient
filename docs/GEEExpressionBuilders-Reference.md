# GEE Expression Builders

Build composable GEE processing pipelines using Wolfram Language's `//` (postfix) operator.

## Overview

When you pass a plain asset ID string (e.g., `"USGS/SRTMGL1_003"`) to functions like `GEEComputePixels`, the package automatically handles loading, filtering, and mosaicking behind the scenes. Expression builders give you **full control** over the processing pipeline: which date range to use, how to filter by metadata, which bands to select, and how to aggregate.

Every expression builder returns an Association representing a GEE expression tree. This Association can be passed directly to `GEEComputePixels`, `GEEImage`, `GEEGetTile`, `GEEIdentify`, `GEEGetSamples`, `GEEComputeFeatures`, `GEECompute`, and `GEEGeoGraphics` in place of an asset ID string.

## The Pipe Operator (`//`)

Most expression builders support an **operator form** (curried form) that lets you chain operations with `//`:

```wolfram
(* Operator form: returns a function that takes a collection *)
GEEFilterDate["2023-01-01", "2024-01-01"]

(* Direct form: takes a collection explicitly *)
GEEFilterDate[collection, "2023-01-01", "2024-01-01"]
```

Both forms produce the same result. The operator form enables clean pipeline syntax:

```wolfram
GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-01-01", "2024-01-01"] //
  GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}] //
  GEEMosaic
```

The `//` operator applies each function left to right: the result of `GEECollection` flows into `GEEFilterDate`, then into `GEEFilterBounds`, then into `GEEMosaic`.

## Pipeline Order

Filters can be applied in any order, but the following conventions are recommended:

1. **Load** the collection (`GEECollection`)
2. **Filter** by date, bounds, and/or metadata properties (`GEEFilterDate`, `GEEFilterBounds`, `GEEFilterProperty`) -- these reduce the number of images before any per-image operations, which improves performance and avoids errors from heterogeneous band structures in older images
3. **Select bands** (`GEESelectBands`) -- must come before aggregation when operating on collections with many bands, as some collections have inconsistent band structures across their history
4. **Sort and limit** (`GEESort`, `GEELimit`, `GEEFirst`) -- if you need a specific image rather than an aggregate
5. **Aggregate** into a single image (`GEEMosaic`, `GEEMedian`, `GEEMean`) -- the final step must produce a single image for functions like `GEEComputePixels`

The **aggregation step** (`GEEMosaic`, `GEEMedian`, or `GEEMean`) must come **last** in the pipeline before passing to a rendering function. It converts the collection into a single image. Functions like `GEEComputePixels` and `GEEImage` require a single image, not a collection.

## Function Reference

### Loading

#### GEECollection

```wolfram
GEECollection[assetId]
```

Create a GEE expression for an ImageCollection asset.

```wolfram
coll = GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
```

#### GEELoadImage

```wolfram
GEELoadImage[assetId]
```

Create a GEE expression for a single Image asset. Use this for `IMAGE` type assets (not collections).

```wolfram
img = GEELoadImage["USGS/SRTMGL1_003"]
```

#### GEEFeatureCollection

```wolfram
GEEFeatureCollection[assetId]
```

Create a GEE expression for a FeatureCollection (table) asset.

```wolfram
fc = GEEFeatureCollection["TIGER/2018/States"]
```

### Filtering

#### GEEFilterDate

```wolfram
GEEFilterDate[collection, start, end]
GEEFilterDate[start, end]                  (* operator form *)
```

Filter a collection by date range. `start` and `end` are ISO 8601 date strings (`"YYYY-MM-DD"`). The range is inclusive of `start` and exclusive of `end`.

```wolfram
(* Direct form *)
filtered = GEEFilterDate[coll, "2023-06-01", "2023-09-01"]

(* Operator form *)
filtered = coll // GEEFilterDate["2023-06-01", "2023-09-01"]
```

#### GEEFilterBounds

```wolfram
GEEFilterBounds[collection, bbox]
GEEFilterBounds[bbox]                      (* operator form *)
```

Filter a collection to images that intersect the bounding box `{west, south, east, north}` in EPSG:4326 coordinates.

```wolfram
(* Filter to images covering Madrid, Spain *)
filtered = coll // GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}]
```

#### GEEFilterProperty

```wolfram
GEEFilterProperty[collection, property, op, value]
GEEFilterProperty[property, op, value]     (* operator form *)
```

Filter a collection by a metadata property. The comparison operator `op` is one of:

| Operator | Description |
|----------|-------------|
| `"LessThan"` | Strictly less than |
| `"LessThanOrEquals"` | Less than or equal |
| `"GreaterThan"` | Strictly greater than |
| `"GreaterThanOrEquals"` | Greater than or equal |
| `"Equals"` | Equal to |
| `"NotEquals"` | Not equal to |

```wolfram
(* Keep only images with less than 20% cloud cover *)
filtered = coll // GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20]

(* Keep images from a specific spacecraft *)
filtered = coll // GEEFilterProperty["SPACECRAFT_NAME", "Equals", "Sentinel-2A"]
```

Common metadata properties by dataset:

| Dataset | Property | Description |
|---------|----------|-------------|
| Sentinel-2 (`COPERNICUS/S2_SR_HARMONIZED`) | `"CLOUDY_PIXEL_PERCENTAGE"` | Cloud cover percentage (0--100) |
| Landsat 8/9 (`LANDSAT/LC08/C02/T1_L2`) | `"CLOUD_COVER"` | Cloud cover percentage (0--100) |
| MODIS (`MODIS/061/MOD13A2`) | `"CLOUD_COVER"` | Cloud cover percentage |
| Sentinel-1 (`COPERNICUS/S1_GRD`) | `"orbitProperties_pass"` | `"ASCENDING"` or `"DESCENDING"` |

Use `GEEGetAssetInfo` to discover available metadata properties for any dataset.

### Band Selection

#### GEESelectBands

```wolfram
GEESelectBands[expr, bands]
GEESelectBands[bands]                      (* operator form *)
```

Select specific bands from an image or collection. When applied to a collection, the band selection is mapped over each image in the collection automatically.

```wolfram
(* Select RGB bands from Sentinel-2 *)
rgb = coll // GEESelectBands[{"B4", "B3", "B2"}]

(* Select a single band *)
nir = coll // GEESelectBands[{"B8"}]
```

### Aggregation

These functions reduce a collection of images into a single image. Exactly one aggregation function should appear at the end of a collection pipeline.

#### GEEMosaic

```wolfram
GEEMosaic[collection]
```

Mosaic (overlay) all images in the collection into a single image. Where images overlap, the last image in the collection takes precedence. Band names are preserved.

```wolfram
img = coll // GEEMosaic
```

#### GEEMedian

```wolfram
GEEMedian[collection]
```

Compute the per-pixel median across all images in the collection. This is useful for removing clouds and transient artifacts. Uses `ImageCollection.reduce` with `Reducer.median` internally; band names receive a `_median` suffix (e.g., `"B4"` becomes `"B4_median"`).

```wolfram
img = coll // GEEMedian
```

#### GEEMean

```wolfram
GEEMean[collection]
```

Compute the per-pixel mean across all images in the collection. Uses `ImageCollection.reduce` with `Reducer.mean` internally; band names receive a `_mean` suffix.

```wolfram
img = coll // GEEMean
```

### Sorting and Limiting

#### GEESort

```wolfram
GEESort[collection, property]
GEESort[collection, property, ascending]
GEESort[property]                          (* operator form, ascending *)
GEESort[property, ascending]               (* operator form *)
```

Sort a collection by a metadata property. `ascending` defaults to `True`.

```wolfram
(* Sort by cloud cover, least cloudy first *)
sorted = coll // GEESort["CLOUDY_PIXEL_PERCENTAGE"]

(* Sort by date, most recent first *)
sorted = coll // GEESort["system:time_start", False]
```

#### GEELimit

```wolfram
GEELimit[collection, n]
GEELimit[n]                                (* operator form *)
```

Limit a collection to at most `n` images.

```wolfram
limited = coll // GEELimit[10]
```

#### GEEFirst

```wolfram
GEEFirst[collection]
```

Get the first image from a collection. Returns a single image expression. This is useful after sorting to pick the best image.

```wolfram
(* Get the least cloudy image *)
best = coll //
  GEESort["CLOUDY_PIXEL_PERCENTAGE"] //
  GEEFirst
```

### Visualization

#### GEEVisualize

```wolfram
GEEVisualize[image, visParams]
GEEVisualize[visParams]                    (* operator form *)
```

Apply server-side visualization to an image expression. `visParams` is an Association with any of the following keys:

| Key | Description |
|-----|-------------|
| `"min"` | Minimum value for scaling |
| `"max"` | Maximum value for scaling |
| `"bands"` | List of band names to display |
| `"palette"` | List of hex colors or color names for single-band images |
| `"gamma"` | Gamma correction value |

```wolfram
vis = img // GEEVisualize[<|"min" -> 0, "max" -> 3000,
  "palette" -> {"blue", "green", "red"}|>]
```

### Geometry

#### GEEGeometry

```wolfram
GEEGeometry[{lat, lon}]
GEEGeometry[{west, south, east, north}]
```

Create a GEE geometry expression. A 2-element list creates a point; a 4-element list creates a rectangle.

```wolfram
point = GEEGeometry[{30.25, -97.75}]
rect = GEEGeometry[{-97.8, 30.2, -97.7, 30.3}]
```

### Statistics

#### GEEReduceRegion

```wolfram
GEEReduceRegion[image, geometry, reducer, scale]
GEEReduceRegion[geometry, reducer, scale]  (* operator form *)
```

Compute a statistic over a region. `reducer` is one of: `"mean"`, `"min"`, `"max"`, `"sum"`, `"first"`, `"median"`.

```wolfram
(* Mean elevation in a bounding box *)
GEECompute[
  GEELoadImage["USGS/SRTMGL1_003"] //
    GEEReduceRegion[GEEGeometry[{-97.8, 30.2, -97.7, 30.3}], "mean", 30]
]
```

### Image Math

#### GEEAdd

```wolfram
GEEAdd[image, other]
GEEAdd[other]                              (* operator form *)
```

Per-pixel addition. `other` can be another image expression or a number.

```wolfram
(* Add a constant offset to shift reflectance values *)
shifted = img // GEEAdd[1000]

(* Add two images together *)
combined = GEEAdd[image1, image2]
```

#### GEESubtract

```wolfram
GEESubtract[image, other]
GEESubtract[other]                         (* operator form *)
```

Per-pixel subtraction.

```wolfram
(* Compute difference between two time periods *)
change = GEESubtract[afterImage, beforeImage]
```

#### GEEMultiply

```wolfram
GEEMultiply[image, other]
GEEMultiply[other]                         (* operator form *)
```

Per-pixel multiplication.

```wolfram
(* Apply a scale factor to convert raw DN to reflectance *)
reflectance = img // GEEMultiply[0.0001]
```

#### GEEDivide

```wolfram
GEEDivide[image, other]
GEEDivide[other]                           (* operator form *)
```

Per-pixel division.

```wolfram
(* Compute a band ratio *)
ratio = GEEDivide[nirBand, redBand]
```

### Spectral Indices

#### GEENormalizedDifference

```wolfram
GEENormalizedDifference[image, {band1, band2}]
GEENormalizedDifference[{band1, band2}]    (* operator form *)
```

Compute `(band1 - band2) / (band1 + band2)` server-side. The result is a single-band image with values in the range `[-1, 1]`. This is the standard formula for vegetation indices (NDVI), water indices (NDWI), and built-up indices (NDBI).

Common band combinations:

| Index | Band 1 (Sentinel-2) | Band 2 (Sentinel-2) | Highlights |
|-------|----------------------|----------------------|------------|
| NDVI  | B8 (NIR)            | B4 (Red)             | Vegetation health |
| NDWI  | B3 (Green)           | B8 (NIR)             | Water bodies |
| NDBI  | B11 (SWIR)           | B8 (NIR)             | Built-up areas |

```wolfram
(* NDVI from a Sentinel-2 median composite *)
ndvi = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
  GEESelectBands[{"B8", "B4"}] //
  GEEMedian //
  GEENormalizedDifference[{"B8_median", "B4_median"}]
```

### Masking

#### GEEUpdateMask

```wolfram
GEEUpdateMask[image, mask]
GEEUpdateMask[mask]                        (* operator form *)
```

Update the pixel mask of an image. Pixels where `mask` is zero or masked become masked in the output. Use this for cloud masking, water masking, or any conditional pixel removal.

```wolfram
(* Mask out cloudy pixels using a cloud probability band *)
cloudFree = img // GEEUpdateMask[cloudMask]
```

#### GEEUnmask

```wolfram
GEEUnmask[image, value]
GEEUnmask[value]                           (* operator form *)
GEEUnmask[image]                           (* replace masked pixels with 0 *)
```

Replace masked (nodata) pixels with a fill value. The one-argument form defaults to 0.

```wolfram
(* Fill nodata gaps with zero *)
filled = img // GEEUnmask[0]

(* Fill with a sentinel value *)
filled = img // GEEUnmask[-9999]
```

#### GEESelfMask

```wolfram
GEESelfMask[image]
```

Mask pixels where the value is 0 or already masked. Useful after a comparison operation to remove false pixels from a binary mask.

```wolfram
(* Keep only pixels where NDVI > 0.3 *)
vegetated = ndviThreshold // GEESelfMask
```

### Spatial Clipping

#### GEEClip

```wolfram
GEEClip[image, geometry]
GEEClip[geometry]                          (* operator form *)
```

Clip an image to a geometry. Pixels outside the geometry become masked. The geometry can be any GEE geometry expression (point, rectangle, polygon).

```wolfram
(* Clip to a bounding box *)
clipped = img // GEEClip[GEEGeometry[{-105.3, 39.6, -105.1, 39.8}]]
```

### Band Manipulation

#### GEEAddBands

```wolfram
GEEAddBands[image, other]
GEEAddBands[other]                         (* operator form *)
```

Add all bands from `other` to `image`. The result has all bands from both images. Use this to composite derived bands (like NDVI) back onto the original image.

```wolfram
(* Add an NDVI band to the original image *)
withNDVI = originalImage // GEEAddBands[ndviBand]
```

#### GEERename

```wolfram
GEERename[image, names]
GEERename[names]                           (* operator form *)
```

Rename the bands of an image. `names` is a list of strings matching the number of bands. The names are assigned in order.

```wolfram
(* Rename Sentinel-2 bands for clarity *)
renamed = img // GEERename[{"Red", "Green", "Blue"}]
```

### Math Expressions

#### GEEExpression

```wolfram
GEEExpression[image, expr, bindings]
GEEExpression[expr, bindings]              (* operator form *)
```

Evaluate a text math expression with band variable bindings. `expr` is a string using standard math operators (`+`, `-`, `*`, `/`, `**`, `%`) and comparison operators (`>`, `<`, `>=`, `<=`, `==`, `!=`). Ternary conditionals (`condition ? trueVal : falseVal`) are also supported.

`bindings` is an Association mapping variable names in the expression to band names in the image.

```wolfram
(* Enhanced Vegetation Index (EVI) *)
evi = img // GEEExpression[
  "2.5 * ((nir - red) / (nir + 6 * red - 7.5 * blue + 1))",
  <|"nir" -> "B8", "red" -> "B4", "blue" -> "B2"|>]
```

## Complete Examples

### Sentinel-2 True Color RGB (Cloud-Filtered Median)

The most common use case: fetch a clean, cloud-free satellite image by filtering a Sentinel-2 collection by date, location, and cloud cover, then taking the per-pixel median.

```wolfram
GEEComputePixels[{-3.8, 40.3, -3.6, 40.5},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Landsat 8 True Color with Cloud Filtering

```wolfram
GEEComputePixels[{-122.5, 37.7, -122.3, 37.85},
  GEECollection["LANDSAT/LC08/C02/T1_L2"] //
    GEEFilterDate["2022-06-01", "2022-10-01"] //
    GEEFilterBounds[{-122.5, 37.7, -122.3, 37.85}] //
    GEEFilterProperty["CLOUD_COVER", "LessThan", 10] //
    GEESelectBands[{"SR_B4", "SR_B3", "SR_B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 7000, "max" -> 12000|>,
  "ImageSize" -> {1024, 1024}]
```

### Sentinel-2 False Color Infrared

Use near-infrared (B8), red (B4), and green (B3) bands to highlight vegetation in red:

```wolfram
GEEComputePixels[{-97.8, 30.2, -97.7, 30.3},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-04-01", "2023-10-01"] //
    GEEFilterBounds[{-97.8, 30.2, -97.7, 30.3}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEESelectBands[{"B8", "B4", "B3"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 4000|>]
```

### NDVI Approximation (Band Ratio via Mean)

Fetch near-infrared and red bands from Sentinel-2 to compute NDVI-like imagery:

```wolfram
nir = GEEComputePixels[{-97.8, 30.2, -97.7, 30.3},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-06-01", "2023-09-01"] //
    GEEFilterBounds[{-97.8, 30.2, -97.7, 30.3}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B8"}] //
    GEEMean,
  "FileFormat" -> "GEO_TIFF"]
```

### Least Cloudy Single Image

Instead of compositing, retrieve the single least cloudy image:

```wolfram
GEEComputePixels[{-3.8, 40.3, -3.6, 40.5},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-06-01", "2023-09-01"] //
    GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEESort["CLOUDY_PIXEL_PERCENTAGE"] //
    GEEFirst,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Mosaic (Last-Pixel-Wins)

When you want a quick composite without statistical reduction:

```wolfram
GEEComputePixels[{-74.1, 40.6, -73.9, 40.8},
  GEECollection["LANDSAT/LC08/C02/T1_L2"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFilterBounds[{-74.1, 40.6, -73.9, 40.8}] //
    GEEFilterProperty["CLOUD_COVER", "LessThan", 5] //
    GEESelectBands[{"SR_B4", "SR_B3", "SR_B2"}] //
    GEEMosaic,
  "VisParams" -> <|"min" -> 7000, "max" -> 12000|>]
```

### SRTM Elevation with Color Palette (Single Image)

For single `IMAGE` assets, use `GEELoadImage` -- no filtering or aggregation needed:

```wolfram
GEEComputePixels[{-105.4, 39.6, -105.1, 39.8},
  GEELoadImage["USGS/SRTMGL1_003"] //
    GEEVisualize[<|"min" -> 1500, "max" -> 4000,
      "palette" -> {"green", "yellow", "brown", "white"}|>]]
```

### Using with GEEImage (Geo-Tagged Output)

Expression builders work with `GEEImage` for geo-tagged output with `MetaInformation`:

```wolfram
img = GEEImage[
  Entity["City", {"Austin", "Texas", "UnitedStates"}],
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFilterBounds[{-97.9, 30.1, -97.5, 30.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>,
  RasterSize -> {512, 512}]
```

### Using with GEEIdentify (Point Query)

Query pixel values from a processed pipeline at a specific point:

```wolfram
GEEIdentify[GeoPosition[{30.25, -97.75}],
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-06-01", "2023-09-01"] //
    GEEFilterBounds[{-97.8, 30.2, -97.7, 30.3}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian]
```

### Using with GEECompute (Statistics)

Compute mean elevation over a region using the expression builder pipeline:

```wolfram
GEECompute[
  GEELoadImage["USGS/SRTMGL1_003"] //
    GEEReduceRegion[GEEGeometry[{-97.8, 30.2, -97.7, 30.3}], "mean", 30]
]
(* <|"elevation" -> 213.5...|> *)
```

### Multiple Property Filters

Chain multiple property filters to narrow results further:

```wolfram
GEEComputePixels[{-3.8, 40.3, -3.6, 40.5},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-06-01", "2023-09-01"] //
    GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEFilterProperty["MEAN_SOLAR_ZENITH_ANGLE", "LessThan", 40] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Geographic Region with Entity

Use a geographic `Entity` as the bounding box while piping a processed collection:

```wolfram
GEEComputePixels[
  Entity["Country", "Switzerland"],
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-06-01", "2023-09-01"] //
    GEEFilterBounds[{5.9, 45.8, 10.5, 47.8}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>,
  "ImageSize" -> {1024, 1024}]
```

### Limiting Collection Size

Limit the number of images before aggregation for faster processing:

```wolfram
GEEComputePixels[{-3.8, 40.3, -3.6, 40.5},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-06-01", "2023-09-01"] //
    GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESort["CLOUDY_PIXEL_PERCENTAGE"] //
    GEELimit[5] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Server-Side NDVI Visualization

Compute NDVI entirely on the server and visualize with a vegetation color palette. No client-side math needed:

```wolfram
bbox = {11.8, 43.2, 12.4, 43.6};  (* Tuscany, Italy *)
ndvi = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
  GEESelectBands[{"B8", "B4"}] //
  GEEMedian //
  GEENormalizedDifference[{"B8_median", "B4_median"}];
GEEComputePixels[bbox, ndvi,
  "VisParams" -> <|"min" -> -0.1, "max" -> 0.9,
    "palette" -> {"brown", "yellow", "green", "darkgreen"}|>,
  "ImageSize" -> {1024, 1024}]
```

### Cloud Masking with UpdateMask

Use the Sentinel-2 Scene Classification Layer (SCL) to mask clouds, then render a clean RGB image:

```wolfram
bbox = {23.6, 37.9, 23.8, 38.1};  (* Athens, Greece *)
pipeline = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-04-01", "2023-10-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 30] //
  GEESelectBands[{"B4", "B3", "B2", "SCL"}] //
  GEEMedian;
(* Extract the SCL band and create a cloud-free mask:
   SCL values 3=cloud shadow, 8=cloud medium, 9=cloud high *)
scl = pipeline // GEESelectBands[{"SCL_median"}];
(* Apply mask: keep only clear pixels *)
cleanRGB = pipeline //
  GEESelectBands[{"B4_median", "B3_median", "B2_median"}] //
  GEEUpdateMask[scl];
GEEComputePixels[bbox, cleanRGB,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Scale Factor Conversion with Multiply

MODIS Land Surface Temperature stores values as raw integers that need a scale factor (0.02) and offset (subtract 273.15 for Celsius). Use `GEEMultiply` and `GEEAdd` to convert server-side:

```wolfram
bbox = {-5.0, 35.5, -3.5, 37.0};  (* Southern Spain *)
lstKelvin = GEECollection["MODIS/061/MOD11A2"] //
  GEEFilterDate["2023-07-01", "2023-08-01"] //
  GEEFilterBounds[bbox] //
  GEESelectBands[{"LST_Day_1km"}] //
  GEEMedian //
  GEEMultiply[0.02];
(* Visualize in Kelvin — typical summer range 290-320 K *)
GEEComputePixels[bbox, lstKelvin,
  "VisParams" -> <|"min" -> 290, "max" -> 320,
    "palette" -> {"blue", "yellow", "red"}|>]
```

### EVI with GEEExpression

The Enhanced Vegetation Index (EVI) requires a multi-band math expression. `GEEExpression` evaluates it server-side in a single call:

```wolfram
bbox = {-48.6, -1.5, -48.2, -1.1};  (* Belém, Brazil — Amazon edge *)
img = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-07-01", "2023-10-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
  GEESelectBands[{"B8", "B4", "B2"}] //
  GEEMedian;
evi = img // GEEExpression[
  "2.5 * ((nir - red) / (nir + 6 * red - 7.5 * blue + 1))",
  <|"nir" -> "B8_median", "red" -> "B4_median",
    "blue" -> "B2_median"|>];
GEEComputePixels[bbox, evi,
  "VisParams" -> <|"min" -> 0, "max" -> 0.6,
    "palette" -> {"white", "green", "darkgreen"}|>]
```

### Compositing Derived Bands with AddBands

Add an NDVI band to a Sentinel-2 RGB image so that both layers are available in a single expression tree:

```wolfram
bbox = {-121.8, 38.3, -121.4, 38.7};  (* Sacramento Valley *)
base = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B8", "B4", "B3", "B2"}] //
  GEEMedian;
ndvi = base //
  GEENormalizedDifference[{"B8_median", "B4_median"}] //
  GEERename[{"NDVI"}];
composite = base // GEEAddBands[ndvi];
(* Now query any point and get both reflectance + NDVI *)
GEEIdentify[GeoPosition[{38.55, -121.6}], composite]
```

### Clipping to a Region of Interest

Clip a global DEM to a specific bounding box so that pixels outside the area of interest are masked:

```wolfram
roi = GEEGeometry[{6.5, 45.8, 8.5, 47.0}];  (* Swiss Alps *)
dem = GEELoadImage["USGS/SRTMGL1_003"] // GEEClip[roi];
GEEComputePixels[{6.5, 45.8, 8.5, 47.0}, dem,
  "VisParams" -> <|"min" -> 200, "max" -> 4500,
    "palette" -> {"green", "yellow", "brown", "white"}|>,
  "ImageSize" -> {1024, 1024}]
```

### Water Body Detection with SelfMask

Use NDWI (Normalized Difference Water Index) to detect water bodies. `GEESelfMask` removes zero-value pixels (non-water) so only water pixels remain:

```wolfram
bbox = {31.0, 29.9, 31.4, 30.2};  (* Cairo / Nile Delta *)
ndwi = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-01-01", "2023-12-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B3", "B8"}] //
  GEEMedian //
  GEENormalizedDifference[{"B3_median", "B8_median"}];
(* Threshold: NDWI > 0 indicates water. Multiply by boolean to zero out
   non-water, then selfMask to remove those zeros *)
waterMask = ndwi // GEEMultiply[ndwi] // GEESelfMask;
GEEComputePixels[bbox, waterMask,
  "VisParams" -> <|"min" -> 0, "max" -> 0.5,
    "palette" -> {"lightblue", "blue", "darkblue"}|>]
```

### Filling Nodata Gaps with Unmask

Replace masked (nodata) pixels in a Sentinel-2 composite with zero to ensure a complete image for export:

```wolfram
bbox = {13.2, 52.4, 13.6, 52.6};  (* Berlin *)
img = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian //
  GEEUnmask[0];
GEEComputePixels[bbox, img,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>,
  "FileFormat" -> "GEO_TIFF",
  "ImageSize" -> {1024, 1024}]
```

### Change Detection: Before vs. After Subtraction

Compute the difference in NDVI between two seasons to detect vegetation loss or gain:

```wolfram
bbox = {-120.5, 37.5, -119.5, 38.0};  (* Sierra Nevada foothills *)
buildNDVI[start_, end_] :=
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate[start, end] //
    GEEFilterBounds[bbox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEESelectBands[{"B8", "B4"}] //
    GEEMedian //
    GEENormalizedDifference[{"B8_median", "B4_median"}];
spring = buildNDVI["2023-04-01", "2023-06-01"];
fall = buildNDVI["2023-09-01", "2023-11-01"];
change = GEESubtract[fall, spring];
(* Negative = vegetation loss (brown), Positive = growth (green) *)
GEEComputePixels[bbox, change,
  "VisParams" -> <|"min" -> -0.3, "max" -> 0.3,
    "palette" -> {"red", "white", "green"}|>,
  "ImageSize" -> {1024, 1024}]
```

## String vs. Expression: When to Use Each

| Approach | Syntax | Best For |
|----------|--------|----------|
| **String asset ID** | `GEEComputePixels[bbox, "USGS/SRTMGL1_003"]` | Quick retrieval with default filtering. The package auto-filters IMAGE_COLLECTION assets by bounds and the most recent 3 years, then mosaics. |
| **Expression pipeline** | `GEEComputePixels[bbox, GEECollection[...] // ... // GEEMedian]` | Full control over date range, cloud filtering, band selection, and aggregation method. Required for metadata-based filtering (e.g., cloud cover). |

## Possible Issues

- **Aggregation required for collections**: `GEEComputePixels`, `GEEImage`, and similar functions require a single image. A collection pipeline must end with `GEEMosaic`, `GEEMedian`, `GEEMean`, or `GEEFirst` to produce a single image.
- **Band name suffixes with GEEMedian/GEEMean**: The `ImageCollection.reduce` operation used by `GEEMedian` and `GEEMean` appends `_median` or `_mean` to band names (e.g., `"B4"` becomes `"B4_median"`). This generally does not affect rendering but may matter if subsequent operations reference bands by name.
- **Band names with GEEMosaic**: `GEEMosaic` preserves original band names. Prefer `GEEMosaic` when band name preservation is important.
- **Heterogeneous band structures**: Some collections (e.g., Sentinel-2) changed their band structure over time. Always filter by date and optionally by bounds before selecting bands to avoid errors from mismatched bands across images.
- **Filter order for performance**: While filters can technically be applied in any order, applying date and spatial filters first reduces the number of images that subsequent operations must process. This improves performance and avoids timeouts on large collections.
- **GEESelectBands on collections**: `GEESelectBands` automatically detects whether the input is a collection or a single image and uses the appropriate API call (`Collection.map` with `Image.select` for collections, or `Image.select` directly for images).
- **GEEFilterBounds bbox must match**: When using `GEEFilterBounds` with `GEEComputePixels`, the filter bounding box should cover at least the same area as the `GEEComputePixels` bounding box, otherwise the result may contain gaps.
- **Common metadata properties**: Use `GEEGetAssetInfo` to discover available metadata properties for any asset. Properties vary by dataset -- `"CLOUDY_PIXEL_PERCENTAGE"` is Sentinel-2 specific while `"CLOUD_COVER"` is used by Landsat.
- **Band name suffixes with NormalizedDifference**: After `GEEMedian` or `GEEMean`, band names are suffixed (e.g., `"B8"` becomes `"B8_median"`). When chaining `GEENormalizedDifference` after an aggregation, use the suffixed band names: `GEENormalizedDifference[{"B8_median", "B4_median"}]`.
- **GEEAdd/Subtract/Multiply/Divide with numbers**: When passing a numeric constant as the second argument, it is automatically wrapped as a `constantValue`. When passing an image expression, it is used directly. Both forms work with the `//` operator.
- **GEEExpression binding names**: Variable names in the expression string must exactly match the keys in the bindings Association. Each binding maps to a single band selected from the input image. Multi-band expressions require one binding per band.
- **GEEClip geometry**: The geometry argument must be a GEE geometry expression (from `GEEGeometry` or a geometry builder), not a raw list of coordinates. Use `GEEGeometry[{west, south, east, north}]` to create a rectangle.
- **GEEUnmask default**: `GEEUnmask[image]` with no value argument defaults to replacing masked pixels with 0. Use `GEEUnmask[image, value]` for a custom fill value.

## See Also

`GEEComputePixels`, `GEEImage`, `GEECompute`, `GEEGetAssetInfo`, `GEEIdentify`, `GEENormalizedDifference`, `GEEClip`, `GEEUpdateMask`, `GEEUnmask`, `GEESelfMask`, `GEEAddBands`, `GEERename`, `GEEAdd`, `GEESubtract`, `GEEMultiply`, `GEEDivide`, `GEEExpression`
