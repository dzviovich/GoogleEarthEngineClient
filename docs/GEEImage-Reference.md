# GEEImage

Return a geo-tagged Image of a region from a Google Earth Engine asset.

## Usage

```wolfram
GEEImage[region, assetId]
GEEImage[region, assetId, opts]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `RasterSize` | `Automatic` | Output pixel dimensions `{w, h}`. Default 512x512. |
| `"FileFormat"` | `"PNG"` | Image format |
| `GeoRangePadding` | `None` | Padding around the region |
| `GeoRange` | `Automatic` | Explicit geographic range |
| `GeoCenter` | `Automatic` | Center override |
| `GeoResolution` | `Automatic` | Meters per pixel (Quantity) |
| `GeoZoomLevel` | `Automatic` | Web map zoom level (integer) |
| `GeoProjection` | `"Mercator"` | Output projection |
| `"Bands"` | `Automatic` | Band selection |
| `"VisParams"` | `<\|\|>` | Visualization parameters |
| `ImageSize` | `Automatic` | Display size |
| `ColorSpace` | `Automatic` | Color space conversion |
| `"Project"` | `Automatic` | GCP project ID |

- `region` can be a `GeoPosition`, `GeoPath`, `GeoPolygon`, or list of geo elements.
- `assetId` can refer to an `IMAGE` or `IMAGE_COLLECTION` asset. Collections are automatically filtered to the requested region and the most recent 3 years of data, then mosaicked into a single image. This handles collections with heterogeneous band structures (e.g., Sentinel-2).
- The returned Image carries `MetaInformation` with `"GeoMetaInformation"` containing `"LonLatBox"`, `"GeoRange"`, `"GeoProjection"`, `"CRS"`, `"GEEAsset"`, and `"RasterSize"`.
- Point regions are auto-padded to 10 km.
- `RasterSize` takes precedence over `GeoResolution` and `GeoZoomLevel`.
- For PNG or JPEG output, assets with more than 3 bands are automatically trimmed to the first 3 bands when `"Bands"` is `Automatic`.
- When no `"VisParams"` are provided, pixel data is fetched as GeoTIFF internally and auto-rescaled (2nd–98th percentile) for display. This handles nodata values and provides good contrast across different data ranges.
- When `"VisParams"` are provided, the GEE server applies the visualization and returns the requested format directly.

## Examples

### Basic

```wolfram
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003"]
```

### With Range and Resolution

```wolfram
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[20, "Kilometers"],
  GeoResolution -> Quantity[30, "Meters"]]
```

### Explicit Lat/Lon Range

```wolfram
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003",
  GeoRange -> {{30.0, 30.5}, {-98.0, -97.5}}]
```

### With Visualization Parameters

```wolfram
img = GEEImage[GeoPosition[{36.57, -118.29}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[50, "Kilometers"],
  "VisParams" -> <|"min" -> 0, "max" -> 4000,
    "palette" -> {"green", "yellow", "brown", "white"}|>]
```

### ImageCollection Asset (auto-mosaicked)

```wolfram
img = GEEImage[GeoPosition[{0, 20}], "MODIS/061/MCD12Q1",
  GeoRange -> Quantity[2000, "Kilometers"],
  "Bands" -> {"LC_Type1"},
  "VisParams" -> <|"min" -> 0, "max" -> 17|>]
```

### Sentinel-2 RGB

```wolfram
img = GEEImage[GeoPosition[{40.4, -3.7}], "COPERNICUS/S2_SR_HARMONIZED",
  GeoRange -> Quantity[20, "Kilometers"],
  "Bands" -> {"B4", "B3", "B2"},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Multi-Band Asset (auto-selected)

```wolfram
img = GEEImage[GeoPosition[{34.08, -117.45}], "NASA/ASTER_GED/AG100_003",
  GeoRange -> Quantity[100, "Kilometers"]]
```

### Accessing Metadata

```wolfram
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003"];
MetaInformation[img]["GeoMetaInformation"]["LonLatBox"]
```

## See Also

`GEEComputePixels`, `GEEGeoGraphics`, `GEEGetTile`
