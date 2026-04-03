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
- Supports Graphics directives: `Red`, `Blue`, `PointSize`, `Thickness`, `Opacity`, `EdgeForm`, `FaceForm`, etc.
- `assetId` can refer to an `IMAGE` or `IMAGE_COLLECTION` asset. Collections are handled via `GEEComputePixels` (auto-filtered by region and date).
- Returns a `Graphics` object with the background map as an `Inset` and projected primitives overlaid.
- The bounding box is computed automatically from the primitives, with padding controlled by `GeoRangePadding`.
- If the background map fails to load (e.g., invalid asset), primitives are still rendered without a background (graceful degradation).

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
  "VisParams" -> <|"min" -> 100, "max" -> 400,
    "palette" -> {"green", "yellow", "brown"}|>]
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

### Polygon with EdgeForm

```wolfram
GEEGeoGraphics[
  {FaceForm[RGBColor[1, 0, 0, 0.3]], EdgeForm[{Black, Thick}],
   GeoPolygon[{GeoPosition[{30.2, -97.8}],
               GeoPosition[{30.3, -97.75}],
               GeoPosition[{30.2, -97.7}]}]},
  "USGS/SRTMGL1_003"]
```

### ImageCollection Background (MODIS)

```wolfram
GEEGeoGraphics[
  GeoMarker[GeoPosition[{30.25, -97.75}]],
  "MODIS/061/MCD12Q1",
  "Bands" -> {"LC_Type1"},
  "VisParams" -> <|"min" -> 0, "max" -> 17|>,
  GeoRange -> Quantity[200, "Kilometers"]]
```

### No Background Map

```wolfram
GEEGeoGraphics[
  {Red, GeoMarker[GeoPosition[{30.25, -97.75}]]},
  "USGS/SRTMGL1_003",
  GeoBackground -> None]
```

## Possible Issues

- If the background asset fails to load, the function still returns a `Graphics` with the primitives rendered but no background map.
- `GeoRange` must be specified or inferable from the primitives. Passing an empty list `{}` with no `GeoRange` returns `$Failed`.

## See Also

`GEEImage`, `GEEComputePixels`
