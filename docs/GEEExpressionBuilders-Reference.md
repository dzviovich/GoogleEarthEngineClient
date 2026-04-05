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
GEEFilterBounds[collection, region]
GEEFilterBounds[region]                    (* operator form *)
```

Filter a collection to images that intersect a geographic region. The region can be:

- A bounding box `{west, south, east, north}` in EPSG:4326 coordinates
- Any geo primitive accepted by `GeoBoundingBox`: `GeoPosition`, `Polygon`, `GeoPolygon`, `GeoDisk`, `GeoCircle`, `Rectangle`, `Entity`, `GeoPath`, `Line`, `GeoMarker`, etc.
- A list of geo primitives — the bounding box is computed to cover all of them

```wolfram
(* Bounding box coordinates *)
filtered = coll // GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}]

(* Country entity *)
filtered = coll // GEEFilterBounds[Entity["Country", "Switzerland"]]

(* Geo primitive *)
filtered = coll // GEEFilterBounds[
  GeoDisk[GeoPosition[{40.4, -3.7}], Quantity[20, "Kilometers"]]]

(* List of primitives — bbox covers all *)
filtered = coll // GEEFilterBounds[{
  Polygon[{GeoPosition[{30.2, -97.8}], GeoPosition[{30.3, -97.7}],
    GeoPosition[{30.3, -97.8}]}],
  GeoDisk[GeoPosition[{29.5, -95.0}], Quantity[10, "Kilometers"]]}]
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

### Comparison Operators

These functions compare two images (or an image and a constant) per-pixel and return a binary 0/1 image. Use them to build masks for conditional processing.

#### GEEGreaterThan

```wolfram
GEEGreaterThan[image, other]
GEEGreaterThan[other]                      (* operator form *)
```

Per-pixel greater than comparison. Returns 1 where `image > other`, 0 otherwise. `other` can be an image or a number.

```wolfram
(* Pixels where NDVI > 0.3 *)
vegMask = ndvi // GEEGreaterThan[0.3]
```

#### GEELessThan

```wolfram
GEELessThan[image, other]
GEELessThan[other]                         (* operator form *)
```

Per-pixel less than comparison.

```wolfram
(* Pixels where elevation < 500 meters *)
lowland = dem // GEELessThan[500]
```

#### GEEEquals

```wolfram
GEEEquals[image, other]
GEEEquals[other]                           (* operator form *)
```

Per-pixel equality comparison.

```wolfram
(* Pixels classified as water (class 6) in ESA WorldCover *)
waterMask = landCover // GEEEquals[80]
```

#### GEENotEquals

```wolfram
GEENotEquals[image, other]
GEENotEquals[other]                        (* operator form *)
```

Per-pixel inequality comparison.

```wolfram
(* Pixels that are NOT cloud shadow (SCL class 3) *)
notShadow = scl // GEENotEquals[3]
```

### Logical Operators

#### GEEAnd

```wolfram
GEEAnd[image, other]
GEEAnd[other]                              (* operator form *)
```

Logical AND of two images. Returns 1 where both inputs are non-zero.

```wolfram
(* Combine two masks: not cloud AND not shadow *)
clearMask = notCloud // GEEAnd[notShadow]
```

#### GEEOr

```wolfram
GEEOr[image, other]
GEEOr[other]                               (* operator form *)
```

Logical OR of two images. Returns 1 where either input is non-zero.

```wolfram
(* Either water OR wetland *)
wetMask = waterMask // GEEOr[wetlandMask]
```

#### GEENot

```wolfram
GEENot[image]
```

Logical NOT. Returns 1 where input is 0, and 0 where input is non-zero.

```wolfram
(* Invert a mask *)
notWater = waterMask // GEENot
```

### Conditional

#### GEEWhere

```wolfram
GEEWhere[image, test, value]
GEEWhere[test, value]                      (* operator form *)
```

Replace pixels in `image` where `test` is non-zero with `value`. `value` can be a number or an image expression. Pixels where `test` is zero keep their original value.

```wolfram
(* Replace cloudy pixels with 0 *)
cleaned = img // GEEWhere[cloudMask, 0]
```

### Collection Transforms

#### GEECollectionMap

```wolfram
GEECollectionMap[collection, func]
GEECollectionMap[func]                     (* operator form *)
```

Apply a function to each image in a collection. `func` receives an image expression (Association) and must return an image expression. This is the general-purpose per-image transform — use it when no specialized helper exists.

```wolfram
(* Compute NDVI for every image in a collection *)
ndviCollection = coll // GEECollectionMap[
  Function[img, GEENormalizedDifference[img, {"B8", "B4"}]]]
```

#### GEEQualityMosaic

```wolfram
GEEQualityMosaic[collection, qualityBand]
GEEQualityMosaic[qualityBand]              (* operator form *)
```

Mosaic a collection using a quality band. For each pixel, selects the value from the image with the highest quality band value. Use this for best-pixel compositing.

```wolfram
(* Best-pixel composite using NDVI as quality *)
best = collectionWithNDVI // GEEQualityMosaic["NDVI"]
```

#### GEEMerge

```wolfram
GEEMerge[collection1, collection2]
GEEMerge[collection2]                      (* operator form *)
```

Merge two collections into one. The result contains all images from both collections.

```wolfram
(* Combine Sentinel-2A and Sentinel-2B collections *)
merged = collA // GEEMerge[collB]
```

### Collection Reducers

#### GEECollectionMax

```wolfram
GEECollectionMax[collection]
```

Pixel-wise maximum across all images in the collection. Band names receive a `_max` suffix.

```wolfram
maxTemp = tempCollection // GEECollectionMax
```

#### GEECollectionMin

```wolfram
GEECollectionMin[collection]
```

Pixel-wise minimum across all images. Band names receive a `_min` suffix.

```wolfram
minTemp = tempCollection // GEECollectionMin
```

#### GEECollectionSum

```wolfram
GEECollectionSum[collection]
```

Pixel-wise sum across all images. Band names receive a `_sum` suffix.

```wolfram
totalPrecip = precipCollection // GEECollectionSum
```

#### GEEToBands

```wolfram
GEEToBands[collection]
```

Stack all images in a collection into a single multi-band image. Each image contributes its bands, prefixed with a sequence number.

```wolfram
(* Stack monthly composites into one image for time series analysis *)
stacked = monthlyCollection // GEEToBands
```

#### GEEReduceStdDev

```wolfram
GEEReduceStdDev[collection]
```

Per-pixel standard deviation across all images. Band names receive a `_stdDev` suffix.

```wolfram
variability = tempCollection // GEEReduceStdDev
```

#### GEEReduceCount

```wolfram
GEEReduceCount[collection]
```

Per-pixel count of non-masked values across all images. Band names receive a `_count` suffix. Useful for assessing data coverage.

```wolfram
coverage = coll // GEEReduceCount
```

#### GEEReducePercentile

```wolfram
GEEReducePercentile[collection, percentiles]
GEEReducePercentile[percentiles]           (* operator form *)
```

Reduce a collection to specified percentiles. `percentiles` is a list of numbers (0--100). Creates one band per input band per percentile.

```wolfram
(* Get 10th and 90th percentile of NDVI *)
pctls = ndviCollection // GEEReducePercentile[{10, 90}]
```

### Terrain, Projection & Resampling

#### GEETerrain

```wolfram
GEETerrain[image]
```

Compute slope, aspect, and hillshade from a DEM image using `Algorithms.Terrain`. The output is a multi-band image with bands `"slope"`, `"aspect"`, and `"hillshade"`.

```wolfram
(* Compute terrain from SRTM *)
terrain = GEELoadImage["USGS/SRTMGL1_003"] // GEETerrain
```

#### GEEReproject

```wolfram
GEEReproject[image, crs, scale]
GEEReproject[crs, scale]                   (* operator form *)
```

Force an image to a specific projection and pixel scale (in meters). `crs` is an EPSG code string.

```wolfram
(* Reproject to UTM zone 33N at 30m resolution *)
reprojected = img // GEEReproject["EPSG:32633", 30]
```

#### GEEResample

```wolfram
GEEResample[image, method]
GEEResample[method]                        (* operator form *)
```

Set the resampling method for an image. `method` is `"bilinear"` or `"bicubic"`.

```wolfram
(* Smooth resampling for visualization *)
smooth = dem // GEEResample["bilinear"]
```

### Focal Operations

Focal operations compute statistics within a neighborhood around each pixel. The `radius` parameter specifies the kernel radius in meters.

#### GEEFocalMean

```wolfram
GEEFocalMean[image, radius]
GEEFocalMean[radius]                       (* operator form *)
```

Apply a focal mean (smoothing) filter.

```wolfram
(* Smooth NDVI with a 500m radius *)
smoothed = ndvi // GEEFocalMean[500]
```

#### GEEFocalMax

```wolfram
GEEFocalMax[image, radius]
GEEFocalMax[radius]                        (* operator form *)
```

Focal maximum — the maximum value within the neighborhood.

```wolfram
localMax = dem // GEEFocalMax[1000]
```

#### GEEFocalMin

```wolfram
GEEFocalMin[image, radius]
GEEFocalMin[radius]                        (* operator form *)
```

Focal minimum — the minimum value within the neighborhood.

```wolfram
localMin = dem // GEEFocalMin[1000]
```

#### GEEFocalMedian

```wolfram
GEEFocalMedian[image, radius]
GEEFocalMedian[radius]                     (* operator form *)
```

Focal median — robust to outliers.

```wolfram
denoised = img // GEEFocalMedian[300]
```

### Convolution & Analysis

#### GEEConvolve

```wolfram
GEEConvolve[image, kernel]
GEEConvolve[kernel]                        (* operator form *)
```

Convolve an image with a kernel expression. The kernel must be a GEE kernel expression tree (e.g., from a `Kernel.*` function invocation).

```wolfram
(* Convolve with a custom kernel expression *)
convolved = img // GEEConvolve[kernelExpr]
```

#### GEEGradient

```wolfram
GEEGradient[image]
```

Compute the x and y gradient of an image. Returns a two-band image with bands `"x"` and `"y"` representing the horizontal and vertical gradients.

```wolfram
(* Compute gradient of a DEM *)
grad = dem // GEEGradient
```

#### GEEEntropy

```wolfram
GEEEntropy[image, radius]
GEEEntropy[radius]                         (* operator form *)
```

Compute entropy within a neighborhood of the given radius in meters. Higher entropy indicates more texture/heterogeneity.

```wolfram
(* Texture analysis: high entropy = complex land cover *)
texture = landcover // GEEEntropy[500]
```

### Pixel Utilities

#### GEEPixelArea

```wolfram
GEEPixelArea[]
```

Create an image where each pixel value is its area in square meters. Pixel area varies with latitude in geographic projections. No input image required.

```wolfram
area = GEEPixelArea[]
```

#### GEEPixelLonLat

```wolfram
GEEPixelLonLat[]
```

Create an image with two bands: `"longitude"` and `"latitude"`, containing the geographic coordinates of each pixel center. No input image required.

```wolfram
coords = GEEPixelLonLat[]
```

#### GEEConstant

```wolfram
GEEConstant[value]
```

Create a constant-value image. Useful for initializing masks, thresholds, or fill values.

```wolfram
(* Create a constant image with value 1 *)
ones = GEEConstant[1]

(* Create a zero-fill image *)
zeros = GEEConstant[0]
```

### Advanced Queries

#### GEEReduceRegions

```wolfram
GEEReduceRegions[image, featureCollection, reducer, scale]
GEEReduceRegions[featureCollection, reducer, scale]  (* operator form *)
```

Reduce an image over multiple geometries at once. `featureCollection` is a GEE FeatureCollection expression, `reducer` is a reducer name (e.g., `"mean"`, `"sum"`), and `scale` is the pixel resolution in meters.

```wolfram
(* Compute mean elevation across all US states *)
states = GEEFeatureCollection["TIGER/2018/States"];
result = GEELoadImage["USGS/SRTMGL1_003"] //
  GEEReduceRegions[states, "mean", 1000]
```

#### GEESample

```wolfram
GEESample[image, region, scale]
GEESample[region, scale]                   (* operator form *)
```

Sample pixel values from an image within a region at the specified scale in meters. Returns a FeatureCollection of point samples.

```wolfram
(* Sample NDVI values across a region *)
samples = ndviImage //
  GEESample[GEEGeometry[{-97.8, 30.2, -97.7, 30.3}], 30]
```

#### GEEReduceToVectors

```wolfram
GEEReduceToVectors[image, geometry, scale]
GEEReduceToVectors[geometry, scale]        (* operator form *)
```

Vectorize an image within a geometry. Converts contiguous regions of equal pixel values into polygon features.

```wolfram
(* Vectorize a classified image *)
vectors = classification //
  GEEReduceToVectors[GEEGeometry[{-97.8, 30.2, -97.7, 30.3}], 30]
```

### Additional Image Math

#### GEEPow

```wolfram
GEEPow[image, other]
GEEPow[other]                             (* operator form *)
```

Per-pixel exponentiation. `other` can be an image or a number.

```wolfram
(* Square pixel values *)
squared = img // GEEPow[2]
```

#### GEEMod

```wolfram
GEEMod[image, other]
GEEMod[other]                             (* operator form *)
```

Per-pixel modulo.

```wolfram
(* Modulo 360 for aspect values *)
wrapped = aspect // GEEMod[360]
```

#### GEEAbs

```wolfram
GEEAbs[image]
```

Per-pixel absolute value.

```wolfram
(* Absolute value of a difference image *)
absDiff = changeImage // GEEAbs
```

#### GEESqrt

```wolfram
GEESqrt[image]
```

Per-pixel square root.

```wolfram
sqrtImg = img // GEESqrt
```

#### GEELog

```wolfram
GEELog[image]
```

Per-pixel natural logarithm.

```wolfram
logImg = img // GEELog
```

#### GEELog10

```wolfram
GEELog10[image]
```

Per-pixel base-10 logarithm.

```wolfram
(* Convert radar backscatter to dB *)
dB = sigma0 // GEELog10 // GEEMultiply[10]
```

#### GEEExp

```wolfram
GEEExp[image]
```

Per-pixel exponential (e^x).

```wolfram
expImg = img // GEEExp
```

### Geometry Builders

#### GEEPolygon

```wolfram
GEEPolygon[coordinates]
```

Create a GEE polygon geometry from a list of `{lon, lat}` coordinate pairs. The polygon is automatically closed (no need to repeat the first point).

```wolfram
(* Triangle over central London *)
poly = GEEPolygon[{
  {-0.13, 51.50}, {-0.08, 51.53}, {-0.03, 51.50}
}]
```

#### GEELineString

```wolfram
GEELineString[coordinates]
```

Create a GEE line geometry from a list of `{lon, lat}` coordinate pairs.

```wolfram
(* A transect line *)
line = GEELineString[{
  {-122.4, 37.78}, {-122.3, 37.78}
}]
```

#### GEEBuffer

```wolfram
GEEBuffer[geometry, distance]
GEEBuffer[distance]                        (* operator form *)
```

Buffer a geometry by a distance in meters. Positive distance expands, negative distance shrinks.

```wolfram
(* Buffer a point to create a 5km circle *)
circle = GEEGeometry[{-122.4, 37.78}] // GEEBuffer[5000]
```

#### GEECentroid

```wolfram
GEECentroid[geometry]
```

Compute the centroid of a geometry.

```wolfram
center = GEEGeometry[{-105.3, 39.6, -105.1, 39.8}] // GEECentroid
```

#### GEEBounds

```wolfram
GEEBounds[geometry]
```

Compute the bounding box of a geometry. Returns a rectangle geometry.

```wolfram
bbox = complexPolygon // GEEBounds
```

#### GEEArea

```wolfram
GEEArea[geometry]
```

Compute the area of a geometry in square meters.

```wolfram
(* Area of a bounding box *)
areaM2 = GEECompute[GEEGeometry[{-73.0, 40.7, -72.0, 41.1}] // GEEArea]
```

### Property & Metadata

#### GEEGet

```wolfram
GEEGet[image, property]
GEEGet[property]                           (* operator form *)
```

Get a metadata property value from an image.

```wolfram
(* Get cloud cover percentage *)
cloudPct = img // GEEGet["CLOUDY_PIXEL_PERCENTAGE"]
```

#### GEESet

```wolfram
GEESet[image, properties]
GEESet[properties]                         (* operator form *)
```

Set metadata properties on an image. `properties` is an Association mapping property names to values.

```wolfram
(* Tag an image with custom metadata *)
tagged = img // GEESet[<|"source" -> "composite", "version" -> 2|>]
```

#### GEEDate

```wolfram
GEEDate[image]
```

Get the acquisition date of an image.

```wolfram
date = img // GEEDate
```

#### GEECast

```wolfram
GEECast[image, bandTypes]
GEECast[bandTypes]                         (* operator form *)
```

Cast band types. `bandTypes` is an Association mapping band names to type strings (e.g., `"float"`, `"int32"`, `"byte"`).

```wolfram
(* Cast specific bands to float *)
casted = img // GEECast[<|"B4" -> "float", "B3" -> "float"|>]
```

#### GEEToFloat

```wolfram
GEEToFloat[image]
```

Convert all bands to float type.

```wolfram
floatImg = img // GEEToFloat
```

#### GEEToInt

```wolfram
GEEToInt[image]
```

Convert all bands to integer type.

```wolfram
intImg = img // GEEToInt
```

### Joins

Joins combine two collections based on a filter condition. The condition is typically a time or spatial filter expression built as a raw expression tree.

#### GEEJoinSimple

```wolfram
GEEJoinSimple[primary, secondary, condition]
```

Simple join — returns features from `primary` that have at least one match in `secondary` according to the `condition`.

#### GEEJoinInner

```wolfram
GEEJoinInner[primary, secondary, condition]
```

Inner join — returns pairs of matching features from both collections.

#### GEEJoinSaveBest

```wolfram
GEEJoinSaveBest[primary, secondary, condition, propertyName]
GEEJoinSaveBest[secondary, condition, propertyName]  (* operator form *)
```

Join and save the best (closest) match from `secondary` as a property named `propertyName` on each `primary` feature.

```wolfram
(* Find the closest-in-time Landsat image for each Sentinel-2 image *)
joined = s2Collection //
  GEEJoinSaveBest[landsatCollection, timeFilter, "closest_landsat"]
```

#### GEEJoinSaveAll

```wolfram
GEEJoinSaveAll[primary, secondary, condition, propertyName]
GEEJoinSaveAll[secondary, condition, propertyName]  (* operator form *)
```

Join and save all matches from `secondary` as a list property named `propertyName` on each `primary` feature.

```wolfram
(* Save all matching secondary images within a time window *)
joined = primaryColl //
  GEEJoinSaveAll[secondaryColl, timeFilter, "matches"]
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

### SCL Cloud Masking with Comparison Operators

Build a cloud mask from the Sentinel-2 Scene Classification Layer using comparison and logical operators, then apply with `GEEUpdateMask`:

```wolfram
bbox = {12.4, 41.8, 12.6, 42.0};  (* Rome *)
pipeline = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-04-01", "2023-10-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 30] //
  GEESelectBands[{"B4", "B3", "B2", "SCL"}] //
  GEEMedian;
(* SCL values: 3=cloud shadow, 8=cloud medium prob, 9=cloud high prob *)
scl = pipeline // GEESelectBands[{"SCL_median"}];
mask = scl // GEENotEquals[3] //
  GEEAnd[scl // GEENotEquals[8]] //
  GEEAnd[scl // GEENotEquals[9]];
cleanRGB = pipeline //
  GEESelectBands[{"B4_median", "B3_median", "B2_median"}] //
  GEEUpdateMask[mask];
GEEComputePixels[bbox, cleanRGB,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Urban Heat Island with GEEWhere

Classify land surface temperature into hot and cool zones using `GEEWhere` and `GEEGreaterThan`:

```wolfram
bbox = {-74.1, 40.6, -73.8, 40.85};  (* New York City *)
lst = GEECollection["MODIS/061/MOD11A2"] //
  GEEFilterDate["2023-07-01", "2023-08-01"] //
  GEEFilterBounds[bbox] //
  GEESelectBands[{"LST_Day_1km"}] //
  GEEMedian //
  GEEMultiply[0.02];
(* Highlight hot zones: replace pixels above 310 K with red (high value),
   keep others unchanged *)
hotMask = lst // GEEGreaterThan[310];
(* Visualize: hot spots stand out *)
GEEComputePixels[bbox, lst,
  "VisParams" -> <|"min" -> 295, "max" -> 320,
    "palette" -> {"blue", "cyan", "yellow", "red"}|>]
```

### NDVI Variability with GEEReduceStdDev

Map the standard deviation of NDVI across a growing season to identify areas with unstable vegetation (drought stress, harvest cycles):

```wolfram
bbox = {-100.0, 40.0, -99.0, 41.0};  (* Nebraska farmland *)
ndviColl = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-04-01", "2023-10-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
  GEESelectBands[{"B8", "B4"}] //
  GEECollectionMap[
    Function[img, GEENormalizedDifference[img, {"B8", "B4"}]]];
stddev = ndviColl // GEEReduceStdDev;
GEEComputePixels[bbox, stddev,
  "VisParams" -> <|"min" -> 0, "max" -> 0.2,
    "palette" -> {"green", "yellow", "red"}|>,
  "ImageSize" -> {1024, 1024}]
(* Green = stable vegetation, Red = high variability (e.g., crop harvest) *)
```

### Data Coverage Assessment with GEEReduceCount

Count how many cloud-free Sentinel-2 observations exist per pixel over a region to assess data availability:

```wolfram
bbox = {-5.0, 35.5, -3.5, 37.0};  (* Southern Spain *)
coverage = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-01-01", "2024-01-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
  GEESelectBands[{"B4"}] //
  GEEReduceCount;
GEEComputePixels[bbox, coverage,
  "VisParams" -> <|"min" -> 0, "max" -> 60,
    "palette" -> {"red", "yellow", "green"}|>]
(* Red = few observations, Green = many — helps plan analysis windows *)
```

### Percentile Compositing for Robust Baselines

Use the 10th and 90th percentiles to create robust min/max baselines that are less sensitive to outliers than CollectionMin/CollectionMax:

```wolfram
bbox = {-122.5, 37.7, -122.3, 37.85};  (* San Francisco *)
coll = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-01-01", "2024-01-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B8", "B4"}] //
  GEECollectionMap[
    Function[img, GEENormalizedDifference[img, {"B8", "B4"}]]];
pctls = coll // GEEReducePercentile[{10, 90}];
(* Returns bands like nd_p10, nd_p90 — the range shows seasonal dynamics *)
GEEComputePixels[bbox, pctls // GEESelectBands[{"nd_p90"}],
  "VisParams" -> <|"min" -> 0, "max" -> 0.8,
    "palette" -> {"brown", "yellow", "green", "darkgreen"}|>]
```

### Merging Two Satellite Collections

Merge Sentinel-2A and 2B orbit collections filtered to different months for a wider temporal baseline:

```wolfram
bbox = {-9.5, 38.6, -9.0, 38.85};  (* Lisbon *)
spring = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-03-01", "2023-05-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
  GEESelectBands[{"B4", "B3", "B2"}];
autumn = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-09-01", "2023-11-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
  GEESelectBands[{"B4", "B3", "B2"}];
merged = spring // GEEMerge[autumn] // GEEMedian;
GEEComputePixels[bbox, merged,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Max Temperature Composite

Compute the maximum land surface temperature over a summer to identify heat hotspots:

```wolfram
bbox = {2.0, 48.7, 2.6, 49.0};  (* Paris *)
maxLST = GEECollection["MODIS/061/MOD11A2"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[bbox] //
  GEESelectBands[{"LST_Day_1km"}] //
  GEECollectionMax //
  GEEMultiply[0.02];
GEEComputePixels[bbox, maxLST,
  "VisParams" -> <|"min" -> 290, "max" -> 325,
    "palette" -> {"blue", "white", "red"}|>]
```

### Hillshade Visualization from DEM

Use `GEETerrain` to compute slope, aspect, and hillshade from SRTM, then visualize the hillshade band:

```wolfram
bbox = {6.5, 45.8, 8.5, 47.0};  (* Swiss Alps *)
hillshade = GEELoadImage["USGS/SRTMGL1_003"] //
  GEETerrain //
  GEESelectBands[{"hillshade"}];
GEEComputePixels[bbox, hillshade,
  "VisParams" -> <|"min" -> 0, "max" -> 255|>,
  "ImageSize" -> {1024, 1024}]
```

### Slope Map for Terrain Analysis

Extract the slope band from terrain analysis and visualize steep vs. flat areas:

```wolfram
bbox = {-112.3, 36.0, -111.7, 36.5};  (* Grand Canyon *)
slope = GEELoadImage["USGS/SRTMGL1_003"] //
  GEETerrain //
  GEESelectBands[{"slope"}];
GEEComputePixels[bbox, slope,
  "VisParams" -> <|"min" -> 0, "max" -> 60,
    "palette" -> {"green", "yellow", "red", "purple"}|>,
  "ImageSize" -> {1024, 1024}]
(* Green = flat, Purple = near-vertical cliffs *)
```

### Smoothed Elevation with Focal Mean

Apply a focal mean filter to smooth a DEM, reducing noise while preserving large-scale terrain features:

```wolfram
bbox = {-112.3, 36.0, -111.7, 36.5};  (* Grand Canyon *)
smoothDEM = GEELoadImage["USGS/SRTMGL1_003"] //
  GEEFocalMean[1000];
GEEComputePixels[bbox, smoothDEM,
  "VisParams" -> <|"min" -> 700, "max" -> 2500,
    "palette" -> {"green", "yellow", "brown", "white"}|>]
```

### Local Relief with Focal Max/Min

Compute local relief (the elevation range within a neighborhood) by subtracting the focal minimum from the focal maximum:

```wolfram
bbox = {-105.5, 39.5, -105.0, 40.0};  (* Colorado Front Range *)
dem = GEELoadImage["USGS/SRTMGL1_003"];
localRelief = GEESubtract[
  dem // GEEFocalMax[2000],
  dem // GEEFocalMin[2000]];
GEEComputePixels[bbox, localRelief,
  "VisParams" -> <|"min" -> 0, "max" -> 1000,
    "palette" -> {"white", "yellow", "orange", "red"}|>,
  "ImageSize" -> {1024, 1024}]
(* White = flat plains, Red = high local relief (canyons, ridgelines) *)
```

### Terrain Gradient for Edge Detection

Use `GEEGradient` to compute x/y gradients of a DEM, then combine into gradient magnitude to highlight ridges and valleys:

```wolfram
bbox = {138.6, 35.2, 138.9, 35.45};  (* Mount Fuji *)
grad = GEELoadImage["USGS/SRTMGL1_003"] // GEEGradient;
(* The gradient x and y bands show the rate of elevation change *)
GEEComputePixels[bbox, grad // GEESelectBands[{"x"}],
  "VisParams" -> <|"min" -> -0.05, "max" -> 0.05,
    "palette" -> {"blue", "white", "red"}|>]
(* Blue = falling westward, Red = rising eastward *)
```

### Logarithmic Nightlight Visualization

Nighttime radiance values span several orders of magnitude. Use `GEELog10` to compress the dynamic range for better visualization:

```wolfram
bbox = {139.5, 35.5, 140.0, 35.85};  (* Tokyo *)
radiance = GEECollection["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG"] //
  GEEFilterDate["2024-01-01", "2024-07-01"] //
  GEEFilterBounds[bbox] //
  GEESelectBands[{"avg_rad"}] //
  GEEMedian;
(* Log10 compression: turns 0.1–1000 range into -1 to 3 *)
logRadiance = radiance // GEELog10;
GEEComputePixels[bbox, logRadiance,
  "VisParams" -> <|"min" -> -1, "max" -> 3,
    "palette" -> {"black", "blue", "yellow", "white"}|>,
  "ImageSize" -> {1024, 1024}]
```

### Radar Backscatter in Decibels

Convert Sentinel-1 SAR backscatter from linear power to decibels using `GEELog10`:

```wolfram
bbox = {-4.0, 40.3, -3.6, 40.55};  (* Madrid *)
sar = GEECollection["COPERNICUS/S1_GRD"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["instrumentMode", "Equals", "IW"] //
  GEESelectBands[{"VV"}] //
  GEEMedian;
dB = sar // GEELog10 // GEEMultiply[10];
GEEComputePixels[bbox, dB,
  "VisParams" -> <|"min" -> -25, "max" -> 0,
    "palette" -> {"black", "gray", "white"}|>]
(* Dark = smooth surfaces (water), Bright = rough surfaces (buildings) *)
```

### Power-Law Contrast Enhancement

Use `GEEPow` with a fractional exponent to enhance low-value contrast in nightlight data (gamma correction):

```wolfram
bbox = {55.0, 25.0, 55.5, 25.35};  (* Dubai *)
radiance = GEECollection["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG"] //
  GEEFilterDate["2024-01-01", "2024-07-01"] //
  GEEFilterBounds[bbox] //
  GEESelectBands[{"avg_rad"}] //
  GEEMedian;
(* Gamma < 1 brightens dark areas, revealing dim suburban lights *)
enhanced = radiance // GEEDivide[100] // GEEPow[0.4] // GEEMultiply[100];
GEEComputePixels[bbox, enhanced,
  "VisParams" -> <|"min" -> 0, "max" -> 100,
    "palette" -> {"black", "purple", "yellow", "white"}|>]
```

### Absolute NDVI Change Detection

Use `GEEAbs` to compute the absolute magnitude of vegetation change, regardless of direction:

```wolfram
bbox = {-122.0, 37.0, -121.5, 37.5};  (* San Jose / Santa Cruz *)
buildNDVI[start_, end_] :=
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate[start, end] //
    GEEFilterBounds[bbox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEESelectBands[{"B8", "B4"}] //
    GEEMedian //
    GEENormalizedDifference[{"B8_median", "B4_median"}];
absChange = GEESubtract[
  buildNDVI["2023-09-01", "2023-11-01"],
  buildNDVI["2023-03-01", "2023-05-01"]] // GEEAbs;
GEEComputePixels[bbox, absChange,
  "VisParams" -> <|"min" -> 0, "max" -> 0.4,
    "palette" -> {"white", "yellow", "orange", "red"}|>,
  "ImageSize" -> {1024, 1024}]
(* White = stable, Red = large change (gain or loss) *)
```

### Custom Polygon Clipping

Clip a satellite image to a custom polygon boundary instead of a rectangle:

```wolfram
(* Polygon around Lake Como, Italy *)
lakePoly = GEEPolygon[{
  {9.20, 45.98}, {9.28, 46.17}, {9.35, 46.20},
  {9.42, 46.17}, {9.40, 46.00}, {9.30, 45.95}
}];
img = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[{9.15, 45.90, 9.50, 46.25}] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian //
  GEEClip[lakePoly];
GEEComputePixels[{9.15, 45.90, 9.50, 46.25}, img,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Buffered Point Analysis

Create a circular region around a point by buffering, then compute mean elevation:

```wolfram
(* 10km buffer around Mount Rainier summit *)
summit = GEEGeometry[{-121.7603, 46.8523}];
buffer = summit // GEEBuffer[10000];
result = GEECompute[
  GEELoadImage["USGS/SRTMGL1_003"] //
    GEEReduceRegion[buffer, "mean", 30]
]
(* Mean elevation within 10km of Mount Rainier summit *)
```

### Geometry Area Computation

Compute the area of a bounding box in square kilometers using `GEEArea`:

```wolfram
geom = GEEGeometry[{-73.0, 40.7, -72.0, 41.1}];
areaM2 = GEECompute[geom // GEEArea];
areaKm2 = areaM2 / 10^6
(* Area in km² of a rectangle over Long Island, NY *)
```

### Centroid and Bounds of Complex Geometry

Compute the centroid and bounding box of a polygon:

```wolfram
poly = GEEPolygon[{
  {12.45, 41.88}, {12.50, 41.92}, {12.55, 41.88}, {12.50, 41.84}
}];
centroid = GEECompute[poly // GEECentroid]
bounds = GEECompute[poly // GEEBounds]
```

### Reprojected Image at Fixed Scale

Force a consistent projection and resolution for multi-source comparison:

```wolfram
bbox = {13.2, 52.4, 13.6, 52.6};  (* Berlin *)
dem = GEELoadImage["USGS/SRTMGL1_003"] //
  GEEReproject["EPSG:32633", 30];
GEEComputePixels[bbox, dem,
  "VisParams" -> <|"min" -> 20, "max" -> 120,
    "palette" -> {"green", "yellow", "brown"}|>]
```

### Bilinear Resampling for Smooth Visualization

Apply bilinear resampling to a coarse MODIS product for smoother rendering:

```wolfram
bbox = {-5.0, 35.5, -3.5, 37.0};  (* Southern Spain *)
lst = GEECollection["MODIS/061/MOD11A2"] //
  GEEFilterDate["2023-07-01", "2023-08-01"] //
  GEEFilterBounds[bbox] //
  GEESelectBands[{"LST_Day_1km"}] //
  GEEMedian //
  GEEMultiply[0.02] //
  GEEResample["bilinear"];
GEEComputePixels[bbox, lst,
  "VisParams" -> <|"min" -> 290, "max" -> 320,
    "palette" -> {"blue", "yellow", "red"}|>]
```

### Pixel Area for Weighted Statistics

Use `GEEPixelArea` with `GEEMultiply` to compute area-weighted sums. This accounts for pixel area distortion in geographic projections:

```wolfram
bbox = {-62.0, -4.0, -60.0, -2.0};  (* Amazon rainforest *)
ndvi = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-07-01", "2023-10-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
  GEESelectBands[{"B8", "B4"}] //
  GEEMedian //
  GEENormalizedDifference[{"B8_median", "B4_median"}];
(* Mask to vegetation: NDVI > 0.5 *)
vegMask = ndvi // GEEGreaterThan[0.5];
(* Multiply pixel area by mask to get vegetated area per pixel *)
vegArea = GEEPixelArea[] // GEEMultiply[vegMask];
(* Sum the vegetated area in square meters *)
totalVegM2 = GEECompute[
  vegArea // GEEReduceRegion[GEEGeometry[bbox], "sum", 10]
]
```

### Constant Image for Threshold Masking

Use `GEEConstant` to create a fill value for replacing masked pixels:

```wolfram
(* Replace masked areas with a constant background value *)
filled = cloudMaskedImage // GEEUnmask[0] //
  GEEWhere[cloudMask, GEEConstant[-9999]]
```

### Type Casting for Export

Convert bands to float before performing division to avoid integer truncation:

```wolfram
bbox = {-3.8, 40.3, -3.6, 40.5};  (* Madrid *)
img = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian //
  GEEToFloat //
  GEEDivide[10000];  (* Scale to 0-1 reflectance *)
GEEComputePixels[bbox, img,
  "VisParams" -> <|"min" -> 0, "max" -> 0.3|>]
```

### Convert to Integer for Compact Export

Round and cast to integer for smaller file sizes when precision is not critical:

```wolfram
bbox = {-3.8, 40.3, -3.6, 40.5};
ndvi = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B8", "B4"}] //
  GEEMedian //
  GEENormalizedDifference[{"B8_median", "B4_median"}] //
  GEEMultiply[10000] //
  GEEToInt;  (* NDVI scaled to -10000..10000 as integer *)
GEEComputePixels[bbox, ndvi, "FileFormat" -> "GEO_TIFF"]
```

### Entropy Texture Map

Compute spatial entropy to distinguish between homogeneous areas (farmland, water) and heterogeneous areas (urban, forests):

```wolfram
bbox = {113.8, 22.2, 114.3, 22.5};  (* Hong Kong *)
img = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-01-01", "2023-12-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B4"}] //
  GEEMedian;
texture = img // GEEEntropy[300];
GEEComputePixels[bbox, texture,
  "VisParams" -> <|"min" -> 0, "max" -> 4,
    "palette" -> {"blue", "white", "red"}|>]
(* Blue = uniform (water, bare land), Red = high texture (urban, mixed land) *)
```

### Multi-Region Statistics with ReduceRegions

Compute mean elevation across multiple US states in a single call:

```wolfram
states = GEEFeatureCollection["TIGER/2018/States"];
dem = GEELoadImage["USGS/SRTMGL1_003"];
result = GEECompute[
  dem // GEEReduceRegions[states, "mean", 1000]
]
(* Returns a FeatureCollection with mean elevation per state *)
```

### Focal Median for Salt-and-Pepper Noise Removal

Remove isolated noisy pixels from a classified image using focal median:

```wolfram
bbox = {12.4, 41.8, 12.6, 42.0};  (* Rome *)
classified = GEELoadImage["ESA/WorldCover/v200"] //
  GEESelectBands[{"Map"}];
(* 100m radius median filter removes isolated misclassified pixels *)
cleaned = classified // GEEFocalMedian[100];
GEEComputePixels[bbox, cleaned,
  "VisParams" -> <|"min" -> 10, "max" -> 100,
    "palette" -> {"green", "yellow", "red", "blue", "gray"}|>]
```

### Setting Metadata Properties

Tag a derived image with custom metadata for downstream identification:

```wolfram
ndvi = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[{-97.8, 30.2, -97.7, 30.3}] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B8", "B4"}] //
  GEEMedian //
  GEENormalizedDifference[{"B8_median", "B4_median"}] //
  GEESet[<|"index" -> "NDVI", "season" -> "summer_2023"|>];
```

### Line Transect for Elevation Profile

Create a line geometry for sampling elevation along a transect:

```wolfram
(* Transect across a mountain pass *)
transect = GEELineString[{
  {6.85, 46.10}, {7.05, 46.05}, {7.20, 46.10}
}];
(* Sample elevation every 100m along the transect *)
samples = GEELoadImage["USGS/SRTMGL1_003"] //
  GEESample[transect, 100];
GEECompute[samples]
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
- **GEEFilterBounds region must cover the output area**: When using `GEEFilterBounds` with `GEEComputePixels`, the filter region should cover at least the same area as the `GEEComputePixels` bounding box, otherwise the result may contain gaps. `GEEFilterBounds` accepts a bounding box `{west, south, east, north}`, any geo primitive (`Entity`, `GeoDisk`, `Polygon`, `GeoPosition`, etc.), or a list of primitives — the bounding box is computed automatically via `GeoBoundingBox`.
- **Common metadata properties**: Use `GEEGetAssetInfo` to discover available metadata properties for any asset. Properties vary by dataset -- `"CLOUDY_PIXEL_PERCENTAGE"` is Sentinel-2 specific while `"CLOUD_COVER"` is used by Landsat.
- **Band name suffixes with NormalizedDifference**: After `GEEMedian` or `GEEMean`, band names are suffixed (e.g., `"B8"` becomes `"B8_median"`). When chaining `GEENormalizedDifference` after an aggregation, use the suffixed band names: `GEENormalizedDifference[{"B8_median", "B4_median"}]`.
- **GEEAdd/Subtract/Multiply/Divide with numbers**: When passing a numeric constant as the second argument, it is automatically wrapped as a `constantValue`. When passing an image expression, it is used directly. Both forms work with the `//` operator.
- **GEEExpression binding names**: Variable names in the expression string must exactly match the keys in the bindings Association. Each binding maps to a single band selected from the input image. Multi-band expressions require one binding per band.
- **GEEClip geometry**: The geometry argument must be a GEE geometry expression (from `GEEGeometry` or a geometry builder), not a raw list of coordinates. Use `GEEGeometry[{west, south, east, north}]` to create a rectangle.
- **GEEUnmask default**: `GEEUnmask[image]` with no value argument defaults to replacing masked pixels with 0. Use `GEEUnmask[image, value]` for a custom fill value.
- **Reducer band name suffixes**: `GEECollectionMax`, `GEECollectionMin`, `GEECollectionSum`, `GEEReduceStdDev`, and `GEEReduceCount` use `ImageCollection.reduce` internally and append suffixes (`_max`, `_min`, `_sum`, `_stdDev`, `_count`) to band names. Use the suffixed names when referencing bands downstream.
- **GEEReducePercentile band names**: Percentile reduction creates bands named `{bandName}_p{percentile}` (e.g., `"B4_p10"`, `"B4_p90"`). The exact suffix depends on the percentile values passed.
- **GEECollectionMap function argument**: The function passed to `GEECollectionMap` receives an expression tree node (Association), not raw pixel data. It must return an expression tree. Use existing helpers (e.g., `GEENormalizedDifference`, `GEESelectBands`) inside the function body.
- **GEEWhere replaces only where test is true**: `GEEWhere[image, test, value]` keeps original pixel values where `test` is 0 and replaces with `value` where `test` is non-zero. This is different from `GEEUpdateMask`, which masks (removes) pixels rather than replacing them.
- **GEEMerge band structure**: Both collections passed to `GEEMerge` should have the same band structure. Merging collections with different bands may cause errors during aggregation.
- **GEETerrain output bands**: `GEETerrain` produces a multi-band image with bands `"slope"` (degrees), `"aspect"` (degrees from north), and `"hillshade"` (0--255). Use `GEESelectBands` to extract the band you need.
- **Focal operation radius units**: All focal operations (`GEEFocalMean`, `GEEFocalMax`, `GEEFocalMin`, `GEEFocalMedian`) use meters as the radius unit. The actual kernel size depends on the image's pixel resolution.
- **GEEReproject caution**: Reprojecting forces computation at a specific scale and can cause performance issues if the scale is much finer than the source data. Use sparingly and only when projection consistency is required.
- **GEEResample must precede reprojection**: `GEEResample` sets the resampling method for the *next* reprojection. Apply it before `GEEReproject` or before a function that triggers reprojection.
- **GEEPixelArea and GEEPixelLonLat take no arguments**: These are zero-argument constructors that create synthetic images. They are not applied to an existing image — use `GEEAddBands` to combine them with other data.
- **GEEConstant creates a global image**: `GEEConstant[value]` creates an image covering the entire globe. Clip or mask it before using with `GEEComputePixels` to avoid processing unnecessary area.
- **GEELog and GEELog10 domain**: Logarithm functions produce `NaN` for zero or negative pixel values. Ensure the input image has positive values, or mask non-positive pixels first.
- **GEEPow/GEEMod with numbers**: Like other binary image math, the second argument is automatically wrapped as a `constantValue` if numeric. Both image-image and image-number forms are supported.
- **GEEPolygon coordinate order**: Coordinates are `{lon, lat}` pairs (GeoJSON order), not `{lat, lon}`. The polygon is automatically closed — do not repeat the first coordinate.
- **GEEBuffer distance sign**: Positive distance expands the geometry, negative distance shrinks it. A point buffered by a positive distance produces a circle.
- **GEEArea returns square meters**: Divide by `10^6` for square kilometers or by `4047` for acres.
- **GEECast type strings**: Valid type strings include `"float"`, `"double"`, `"int8"`, `"int16"`, `"int32"`, `"int64"`, `"byte"`, `"uint8"`, `"uint16"`, `"uint32"`.
- **GEEToFloat/GEEToInt affect all bands**: These convenience functions convert every band. Use `GEECast` for selective band type conversion.
- **Join condition expressions**: `GEEJoinSimple`, `GEEJoinInner`, `GEEJoinSaveBest`, and `GEEJoinSaveAll` require a filter condition as a raw GEE expression tree (Association). There are no built-in helpers for join filters yet — construct them manually using `"functionInvocationValue"` with `"Filter.maxDifference"` or similar.
- **GEEReduceRegions scale**: The `scale` parameter determines the resolution at which pixels are sampled. A larger scale is faster but less precise. Match the scale to your data's native resolution when possible.
- **GEEGradient output**: Returns a two-band image with bands `"x"` (horizontal gradient) and `"y"` (vertical gradient). To compute gradient magnitude, use `GEEExpression` or combine `GEEPow` and `GEESqrt`.
- **GEEEntropy input**: Works best on integer-valued or classified images. For continuous data, consider binning values first (e.g., with `GEEMultiply` and `GEEToInt`).

## See Also

`GEEComputePixels`, `GEEImage`, `GEECompute`, `GEEGetAssetInfo`, `GEEIdentify`, `GEENormalizedDifference`, `GEEClip`, `GEEUpdateMask`, `GEEUnmask`, `GEESelfMask`, `GEEAddBands`, `GEERename`, `GEEAdd`, `GEESubtract`, `GEEMultiply`, `GEEDivide`, `GEEExpression`, `GEEGreaterThan`, `GEELessThan`, `GEEEquals`, `GEENotEquals`, `GEEAnd`, `GEEOr`, `GEENot`, `GEEWhere`, `GEECollectionMap`, `GEEQualityMosaic`, `GEEMerge`, `GEECollectionMax`, `GEECollectionMin`, `GEECollectionSum`, `GEEToBands`, `GEEReduceStdDev`, `GEEReduceCount`, `GEEReducePercentile`, `GEETerrain`, `GEEReproject`, `GEEResample`, `GEEFocalMean`, `GEEFocalMax`, `GEEFocalMin`, `GEEFocalMedian`, `GEEConvolve`, `GEEGradient`, `GEEEntropy`, `GEEPixelArea`, `GEEPixelLonLat`, `GEEConstant`, `GEEReduceRegions`, `GEESample`, `GEEReduceToVectors`, `GEEPow`, `GEEMod`, `GEEAbs`, `GEESqrt`, `GEELog`, `GEELog10`, `GEEExp`, `GEEPolygon`, `GEELineString`, `GEEBuffer`, `GEECentroid`, `GEEBounds`, `GEEArea`, `GEEGet`, `GEESet`, `GEEDate`, `GEECast`, `GEEToFloat`, `GEEToInt`, `GEEJoinSimple`, `GEEJoinInner`, `GEEJoinSaveBest`, `GEEJoinSaveAll`
