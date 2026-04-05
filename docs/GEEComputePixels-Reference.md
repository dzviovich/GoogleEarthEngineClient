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

```wolfram
img = GEEComputePixels[{-97.8, 30.2, -97.7, 30.3},
  "USGS/SRTMGL1_003"]
```

### Custom Size and Format

```wolfram
img = GEEComputePixels[{-97.8, 30.2, -97.7, 30.3},
  "USGS/SRTMGL1_003",
  "ImageSize" -> {1024, 1024},
  "FileFormat" -> "GEO_TIFF"]
```

### With Visualization

```wolfram
img = GEEComputePixels[{-97.8, 30.2, -97.7, 30.3},
  "USGS/SRTMGL1_003",
  "VisParams" -> <|"min" -> 0, "max" -> 3000,
    "palette" -> {"green", "yellow", "brown"}|>]
```

### ImageCollection with Band Selection

```wolfram
img = GEEComputePixels[{-122.5, 37.5, -122.0, 38.0},
  "LANDSAT/LC08/C02/T1_L2",
  "Bands" -> {"SR_B4", "SR_B3", "SR_B2"},
  "VisParams" -> <|"min" -> 7000, "max" -> 12000|>,
  "ImageSize" -> {512, 512}]
```

### Sentinel-2 RGB

```wolfram
img = GEEComputePixels[{-3.8, 40.3, -3.6, 40.5},
  "COPERNICUS/S2_SR_HARMONIZED",
  "Bands" -> {"B4", "B3", "B2"},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>,
  "ImageSize" -> {512, 512}]
```

### Region as GeoPosition

```wolfram
img = GEEComputePixels[GeoPosition[{30.27, -97.74}],
  "USGS/SRTMGL1_003"]
```

### Region as Polygon

```wolfram
img = GEEComputePixels[
  Polygon[{GeoPosition[{30.2, -97.8}], GeoPosition[{30.3, -97.8}],
    GeoPosition[{30.3, -97.7}], GeoPosition[{30.2, -97.7}]}],
  "USGS/SRTMGL1_003"]
```

### Region as Entity

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
