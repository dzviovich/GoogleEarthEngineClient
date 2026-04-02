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
- The returned Image carries `MetaInformation` with `"GeoMetaInformation"` containing `"LonLatBox"`, `"GeoRange"`, `"GeoProjection"`, `"CRS"`, `"GEEAsset"`, and `"RasterSize"`.
- Point regions are auto-padded to 10 km.
- `RasterSize` takes precedence over `GeoResolution` and `GeoZoomLevel`.

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

### Accessing Metadata

```wolfram
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003"];
MetaInformation[img]["GeoMetaInformation"]["LonLatBox"]
```

## See Also

`GEEComputePixels`, `GEEGeoGraphics`, `GEEGetTile`
