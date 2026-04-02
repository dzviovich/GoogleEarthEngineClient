# GEEGeoGraphics

Render geographic primitives on a background map from a GEE asset.

## Usage

```wolfram
GEEGeoGraphics[primitives, assetId]
GEEGeoGraphics[primitives, assetId, opts]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `GeoProjection` | `"Mercator"` | Map projection |
| `GeoRange` | `Automatic` | Geographic range |
| `GeoCenter` | `Automatic` | Map center |
| `GeoRangePadding` | `Scaled[0.1]` | Padding around primitives |
| `RasterSize` | `{512, 512}` | Background image pixel dimensions |
| `GeoResolution` | `Automatic` | Meters per pixel |
| `GeoZoomLevel` | `Automatic` | Web map zoom level |
| `"FileFormat"` | `"PNG"` | Background image format |
| `"Bands"` | `Automatic` | Band selection for background |
| `"VisParams"` | `<\|\|>` | Visualization parameters for background |
| `ImageSize` | `Automatic` | Display size |
| `GeoBackground` | `Automatic` | Set to `None` to disable background map |
| `ColorSpace` | `Automatic` | Color space conversion |
| `"Project"` | `Automatic` | GCP project ID |

- `primitives` can include `GeoMarker`, `GeoPath`, `GeoPolygon`, `GeoDisk`, `GeoCircle`, and standard Graphics `Point`/`Line`/`Polygon` with `GeoPosition`.
- Supports Graphics directives: `Red`, `Blue`, `PointSize`, `Thickness`, `Opacity`, `EdgeForm`, etc.
- Returns a `Graphics` object.

## Examples

### Marker on Elevation Map

```wolfram
GEEGeoGraphics[
  GeoMarker[GeoPosition[{30.25, -97.75}]],
  "USGS/SRTMGL1_003"]
```

### Path with Styling

```wolfram
GEEGeoGraphics[
  {Red, Thick,
   GeoPath[{GeoPosition[{30.2, -97.8}], GeoPosition[{30.3, -97.7}]}]},
  "USGS/SRTMGL1_003",
  "VisParams" -> <|"min" -> 100, "max" -> 400|>]
```

### Multiple Primitives

```wolfram
GEEGeoGraphics[
  {Blue, GeoMarker[GeoPosition[{30.25, -97.75}]],
   Red, Opacity[0.3],
   GeoDisk[GeoPosition[{30.25, -97.75}], Quantity[5, "Kilometers"]]},
  "USGS/SRTMGL1_003",
  GeoRange -> Quantity[20, "Kilometers"]]
```

## See Also

`GEEImage`, `GEEComputePixels`
