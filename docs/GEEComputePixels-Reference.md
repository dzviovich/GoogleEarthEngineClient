# GEEComputePixels

Compute pixels for a GEE image asset over a bounding box.

## Usage

```wolfram
GEEComputePixels[bbox, assetId]
GEEComputePixels[region, assetId]
GEEComputePixels[bbox, assetId, opts]
GEEComputePixels[region, assetId, opts]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"ImageSize"` | `{512, 512}` | Output image dimensions `{width, height}` |
| `"FileFormat"` | `"PNG"` | Output format: `"PNG"`, `"JPEG"`, `"GEO_TIFF"` |
| `"Bands"` | `Automatic` | List of band names to include, or `Automatic` for all |
| `"CRS"` | `"EPSG:4326"` | Coordinate reference system |
| `"VisParams"` | `<\|\|>` | Visualization parameters: `"min"`, `"max"`, `"palette"`, `"bands"`, `"gamma"` |
| `"Project"` | `Automatic` | GCP project ID |

- `bbox` is `{west, south, east, north}` in EPSG:4326 coordinates.
- `region` can be any geographic primitive accepted by `GeoBoundingBox`: `GeoPosition`, `Polygon`, `GeoPolygon`, `GeoPath`, `Line`, `GeoDisk`, `GeoCircle`, `Entity` (e.g., `Entity["Country", "France"]`), or a list of such primitives. The bounding box is computed automatically from the region.
- For point regions (`GeoPosition`), a 1 km padding is applied automatically to produce a non-degenerate bounding box.
- `assetId` can refer to an `IMAGE` or `IMAGE_COLLECTION` asset. Collections are automatically filtered to the bounding box and the most recent 3 years of data, then mosaicked into a single image. The spatial and temporal filtering ensures compatibility with collections that have heterogeneous band structures across their history (e.g., Sentinel-2).
- Maximum uncompressed output is 48MB per request.
- Returns an Image object.
- When `"Bands"` is `Automatic` and the format is PNG or JPEG, assets with more than 3 bands are automatically trimmed to the first 3 bands (RGB). Single-band assets are returned as grayscale.
- When no `"VisParams"` are provided, pixel data is fetched as GeoTIFF internally and auto-rescaled (2nd–98th percentile) for display. This correctly handles nodata values (e.g., -9999) and signed integer data.
- When `"VisParams"` are provided, the GEE server applies the visualization and returns the requested format directly.

## Examples

### Basic

Elevation around Austin, TX with default settings (512x512, auto-rescaled):

```wolfram
img = GEEComputePixels[{-97.8, 30.2, -97.7, 30.3},
  "USGS/SRTMGL1_003"]
```

### ImageSize: Print-Quality Export

Fetch a high-resolution 2048x2048 elevation raster of the Grand Canyon for print or detailed analysis. Larger sizes capture finer terrain features but increase download time:

```wolfram
img = GEEComputePixels[{-112.3, 36.0, -111.9, 36.2},
  "USGS/SRTMGL1_003",
  "ImageSize" -> {2048, 2048}]
Export["grand_canyon_elevation.png", img]
```

### ImageSize: Side-by-Side Resolution Comparison

Compare how different image sizes affect detail. The same Himalayan region at 256, 512, and 1024 pixels:

```wolfram
sizes = {256, 512, 1024};
imgs = Table[
  GEEComputePixels[{86.8, 27.8, 87.1, 28.1},
    "USGS/SRTMGL1_003",
    "ImageSize" -> {s, s}],
  {s, sizes}
];
Row[MapThread[Labeled[#1, Row[{#2, "x", #2}]] &, {imgs, sizes}],
  Spacer[10]]
```

### FileFormat: GeoTIFF for Quantitative Analysis

Fetch raw elevation data as GeoTIFF to preserve full numeric precision. GeoTIFF pixel values are actual data values (e.g., meters for SRTM), not display-scaled — the image will appear gray when displayed because values like 2000--4000 fall outside the 0--1 display range. Use `ImageData` to extract the raw matrix for computation, and `Rescale` if you need a displayable image:

```wolfram
img = GEEComputePixels[{-105.3, 39.6, -105.1, 39.8},
  "USGS/SRTMGL1_003",
  "FileFormat" -> "GEO_TIFF",
  "ImageSize" -> {512, 512}]

(* Extract raw pixel matrix — values are meters *)
data = ImageData[img, "Real32"];
{Min[data], Mean[Flatten[data]], Max[data]}
(* e.g., {2450., 3180., 4340.} — Rocky Mountain Front Range *)

(* Rescale to 0-1 for display *)
Image[Rescale[data]]
```

### FileFormat: JPEG for Lightweight Sharing

Fetch a compressed JPEG for web or email. JPEG is lossy but much smaller than PNG — good for quick previews. Requires `"VisParams"` since JPEG output is server-rendered:

```wolfram
img = GEEComputePixels[{-73.0, -13.6, -72.3, -13.1},
  "USGS/SRTMGL1_003",
  "FileFormat" -> "JPEG",
  "VisParams" -> <|"min" -> 2000, "max" -> 6200,
    "palette" -> {"#1a9850", "#91cf60", "#fee08b",
      "#fc8d59", "#d73027", "#ffffff"}|>,
  "ImageSize" -> {800, 600}]
Export["andes_preview.jpg", img]
```

### Bands: Near-Infrared False Color for Vegetation

Select NIR-Red-Green bands (B8, B4, B3) from Sentinel-2 to highlight vegetation in bright red. Healthy vegetation reflects strongly in NIR, making forests and crops stand out from bare soil and water:

```wolfram
img = GEEComputePixels[{-60.2, -3.3, -59.8, -2.9},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-10-01"] //
    GEEFilterBounds[{-60.2, -3.3, -59.8, -2.9}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEESelectBands[{"B8", "B4", "B3"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 4000|>,
  "ImageSize" -> {512, 512}]
```

### Bands: Single-Band Nighttime Radiance

Extract the `avg_rad` band from VIIRS nighttime lights to visualize urban extent. Without band selection, VIIRS returns multiple bands (radiance, cloud mask, etc.) that don't form a meaningful RGB image:

```wolfram
img = GEEComputePixels[{-74.3, 40.5, -73.7, 40.9},
  "NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG",
  "Bands" -> {"avg_rad"},
  "ImageSize" -> {512, 512}]
(* Bright = urban (Manhattan, Newark), dark = water/parks *)
```

### Bands: SWIR for Burn Scar Detection

Short-wave infrared (B12) and NIR (B8A) from Sentinel-2 reveal burn scars. Burned areas appear dark in NIR but bright in SWIR:

```wolfram
img = GEEComputePixels[{-121.8, 39.5, -121.2, 40.0},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-08-01", "2024-11-01"] //
    GEEFilterBounds[{-121.8, 39.5, -121.2, 40.0}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEESelectBands[{"B12", "B8A", "B4"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 4000|>,
  "ImageSize" -> {512, 512}]
```

### CRS: EPSG:4326 (Default)

The default CRS is EPSG:4326 (WGS84 lat/lon). This is appropriate for most use cases and ensures the output aligns with standard geographic coordinates:

```wolfram
img = GEEComputePixels[{5.9, 45.8, 7.9, 47.0},
  "USGS/SRTMGL1_003",
  "CRS" -> "EPSG:4326",
  "ImageSize" -> {512, 512}]
```

### VisParams: Color-Mapped Elevation

Apply a palette to map elevation values to colors. `"min"` and `"max"` define the data range; `"palette"` assigns colors evenly across that range. Values below `"min"` get the first color, above `"max"` get the last:

```wolfram
img = GEEComputePixels[{86.6, 27.6, 87.2, 28.2},
  "USGS/SRTMGL1_003",
  "VisParams" -> <|"min" -> 200, "max" -> 8500,
    "palette" -> {"#006633", "#66cc33", "#ffff00",
      "#cc6600", "#993300", "#ffffff"}|>,
  "ImageSize" -> {512, 512}]
(* Green=lowland, yellow=hills, brown=mountains, white=Everest *)
```

### VisParams: Gamma Correction for Dark Imagery

Sentinel-2 RGB images often appear dark because most surface reflectance values cluster at the low end of the range. `"gamma"` < 1 brightens midtones without clipping highlights. Note: `"gamma"` and `"palette"` are mutually exclusive:

```wolfram
img = GEEComputePixels[{12.3, 41.8, 12.6, 42.0},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-04-01", "2024-09-01"] //
    GEEFilterBounds[{12.3, 41.8, 12.6, 42.0}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000, "gamma" -> 0.8|>,
  "ImageSize" -> {512, 512}]
(* Brightened true-color view of Rome *)
```

### VisParams: Land Cover Classification

For classification data with discrete class IDs, set `"min"` and `"max"` to span the class range and provide one palette color per class. GEE interpolates linearly, so the number of colors should match the number of discrete steps:

```wolfram
img = GEEComputePixels[{-5.0, 35.5, 3.0, 42.5},
  GEECollection["ESA/WorldCover/v200"] //
    GEEFilterDate["2021-01-01", "2022-01-01"] //
    GEESelectBands[{"Map"}] //
    GEEMosaic,
  "VisParams" -> <|"min" -> 10, "max" -> 100,
    "palette" -> {"#006400", "#FFBB22", "#FFFF4C", "#F096FF",
      "#FA0000", "#B4B4B4", "#F0F0F0", "#0064C8",
      "#0096A0", "#00CF75", "#FAE6A0"}|>,
  "ImageSize" -> {600, 500}]
(* Land cover of southern France and northern Spain *)
```

### Region as GeoPosition

A single GeoPosition is auto-padded to 1 km:

```wolfram
img = GEEComputePixels[GeoPosition[{30.27, -97.74}],
  "USGS/SRTMGL1_003"]
```

### Region as Entity

Use a Wolfram Language Entity as the region. The bounding box is computed automatically:

```wolfram
img = GEEComputePixels[
  Entity["City", {"Austin", "Texas", "UnitedStates"}],
  "USGS/SRTMGL1_003",
  "ImageSize" -> {1024, 1024}]
```

## Possible Issues

- Requests exceeding 48MB uncompressed will fail.
- Band names must match those in the asset.
- PNG and JPEG formats require 1 or 3 bands. If an asset has more bands and no explicit `"Bands"` selection is provided, the first 3 bands are auto-selected.
- The `GEEComputePixels::apierr` message surfaces the actual GEE API error when a request fails.
- The `"CRS"` option controls the output projection metadata but the bounding box is always specified in EPSG:4326 (lat/lon) coordinates.
- For `IMAGE_COLLECTION` assets, the collection is filtered by `Filter.intersects` (spatial) and `Filter.dateRangeContains` (last 3 years) before mosaicking. This prevents errors from heterogeneous band orderings in older images.

### Expression Builder Pipeline

Build a cloud-filtered Sentinel-2 median composite using the `//` pipe operator:

```wolfram
img = GEEComputePixels[{-3.8, 40.3, -3.6, 40.5},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

See `GEEExpressionBuilders` for the full reference on pipeline construction.

## See Also

`GEEImage`, `GEEGetTile`, `GEEIdentify`, `GEECollection`, `GEEFilterDate`, `GEEFilterBounds`, `GEEFilterProperty`, `GEESelectBands`, `GEEMosaic`, `GEEMedian`
