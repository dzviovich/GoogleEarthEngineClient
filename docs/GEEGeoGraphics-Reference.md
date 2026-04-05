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

### Basic

Mark a summit on a color-mapped elevation background:

```wolfram
GEEGeoGraphics[
  GeoMarker[GeoPosition[{46.8523, -121.7603}]],
  "USGS/SRTMGL1_003",
  GeoRange -> Quantity[40, "Kilometers"],
  "VisParams" -> <|"min" -> 300, "max" -> 4400,
    "palette" -> {"#1a9850", "#91cf60", "#d9ef8b",
      "#fee08b", "#fc8d59", "#d73027", "#ffffff"}|>]
```

### GeoProjection: Equirectangular for High Latitudes

The default `"Mercator"` projection distorts areas at high latitudes. Use `"Equirectangular"` (EPSG:4326) for more proportional rendering. Supported values: `"Mercator"`, `"Equirectangular"`, or any EPSG code string. Note: SRTM only covers up to 60°N — use `"USGS/GMTED2010"` for higher latitudes:

```wolfram
(* Northern Canada — GMTED2010 covers up to 84°N *)
GEEGeoGraphics[
  {Red, PointSize[0.02],
   GeoMarker[GeoPosition[{63.75, -68.52}]],
   GeoMarker[GeoPosition[{62.45, -114.37}]]},
  "USGS/GMTED2010",
  "Bands" -> {"be75"},
  GeoProjection -> "Equirectangular",
  GeoRange -> {{60.0, 67.0}, {-120.0, -60.0}},
  RasterSize -> {600, 400}]
(* Iqaluit and Yellowknife — Equirectangular avoids Mercator's severe
   east-west stretching at these latitudes *)
```

### GeoRange: Distance Radius

Set the map extent as a distance around the primitives. Useful when you want a consistent scale regardless of how the primitives are spread:

```wolfram
GEEGeoGraphics[
  {Red, GeoMarker[GeoPosition[{-8.34, 115.51}]],
   FaceForm[RGBColor[1, 0, 0, 0.15]], EdgeForm[{Red, Thick}],
   GeoDisk[GeoPosition[{-8.34, 115.51}], Quantity[10, "Kilometers"]]},
  "USGS/SRTMGL1_003",
  GeoRange -> Quantity[30, "Kilometers"],
  "VisParams" -> <|"min" -> 0, "max" -> 3100,
    "palette" -> {"#006633", "#66cc33", "#ffff00",
      "#cc6600", "#993300"}|>]
(* Mount Agung, Bali — marker + 10 km exclusion zone *)
```

### GeoRange: Explicit Lat/Lon Bounds

Set the map extent as explicit `{{south, north}, {west, east}}` bounds. Useful for fixed-frame maps that always cover the same area:

```wolfram
stations = {
  GeoPosition[{35.68, 139.69}],  (* Tokyo *)
  GeoPosition[{35.45, 139.64}],  (* Yokohama *)
  GeoPosition[{35.76, 140.39}]   (* Chiba *)
};
GEEGeoGraphics[
  {Red, PointSize[0.02], GeoMarker /@ stations},
  "NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG",
  "Bands" -> {"avg_rad"},
  GeoRange -> {{35.0, 36.2}, {139.2, 140.8}},
  RasterSize -> {600, 400}]
```

### GeoCenter: Shift Viewport Away from Primitives

Override the map center independently of the primitives. The bounding box still covers the primitives, but the viewport shifts to emphasize a different area — here, shifting south to show the coastline below a mountain marker:

```wolfram
GEEGeoGraphics[
  {Red, GeoMarker[GeoPosition[{43.35, 5.37}]]},
  "USGS/SRTMGL1_003",
  GeoRange -> Quantity[40, "Kilometers"],
  GeoCenter -> GeoPosition[{43.20, 5.45}],
  "VisParams" -> <|"min" -> 0, "max" -> 1100,
    "palette" -> {"#0064C8", "#1a9850", "#91cf60",
      "#fee08b", "#993300"}|>]
(* Marseille region — marker on the hills, center shifted to show the coast *)
```

### GeoRangePadding: Add Margin Around a Trail

Control how much extra space surrounds the primitives. Default is `Scaled[0.1]` (10%). Use `Quantity` for absolute padding or `None` for a tight crop:

```wolfram
trail = GeoPath[{
  GeoPosition[{-13.325, -72.480}],
  GeoPosition[{-13.290, -72.500}],
  GeoPosition[{-13.230, -72.530}],
  GeoPosition[{-13.163, -72.545}]
}];
GEEGeoGraphics[
  {Red, Thickness[0.005], trail,
   Blue, GeoMarker[GeoPosition[{-13.163, -72.545}]]},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-05-01", "2024-09-01"] //
    GEEFilterBounds[{-72.7, -13.4, -72.3, -13.1}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>,
  GeoRangePadding -> Quantity[5, "Kilometers"],
  RasterSize -> {1024, 1024}]
(* Inca Trail to Machu Picchu with 5 km padding *)
```

### RasterSize: High-Resolution Background for Export

`RasterSize` controls the pixel dimensions of the background raster fetched from GEE. Higher values yield sharper backgrounds but slower downloads. This does not affect the display size — use `ImageSize` for that:

```wolfram
g = GEEGeoGraphics[
  {White, Thick,
   GeoPath[{GeoPosition[{27.99, 86.93}],
            GeoPosition[{28.00, 86.85}]}]},
  "USGS/SRTMGL1_003",
  GeoRange -> Quantity[15, "Kilometers"],
  RasterSize -> {2048, 2048},
  "VisParams" -> <|"min" -> 4500, "max" -> 8500,
    "palette" -> {"#993300", "#CC9966", "#FFFFFF"}|>,
  ImageSize -> 600];
Export["everest_route.png", g, ImageResolution -> 300]
```

### GeoResolution: Control Meters Per Pixel

Set the background resolution in meters per pixel. The raster size is computed automatically to cover the geographic extent at this resolution. Alternative to setting `RasterSize` directly:

```wolfram
GEEGeoGraphics[
  {Red, GeoMarker[GeoPosition[{36.10, -112.11}]]},
  "USGS/SRTMGL1_003",
  GeoRange -> Quantity[20, "Kilometers"],
  GeoResolution -> Quantity[15, "Meters"],
  "VisParams" -> <|"min" -> 500, "max" -> 2800,
    "palette" -> {"#2b1a0e", "#8B4513", "#D2691E", "#F5DEB3"}|>]
(* Grand Canyon at 15 m/pixel — fine enough to resolve side canyons *)
```

### GeoZoomLevel: Use Web Map Zoom Level

Set the background resolution using a Web Mercator zoom level (0--20). Higher zoom = finer detail. This is a convenient alternative when you think in terms of web map tiles. Zoom reference: z=10 ~150 m/pixel, z=12 ~38 m/pixel, z=14 ~10 m/pixel:

```wolfram
GEEGeoGraphics[
  {Red, GeoMarker[GeoPosition[{46.85, 8.23}]]},
  "USGS/SRTMGL1_003",
  GeoRange -> Quantity[50, "Kilometers"],
  GeoZoomLevel -> 11,
  "VisParams" -> <|"min" -> 200, "max" -> 4500,
    "palette" -> {"#1a9850", "#91cf60", "#d9ef8b",
      "#fee08b", "#fc8d59", "#d73027", "#ffffff"}|>]
(* Swiss Alps at zoom 11 — ~75 m/pixel *)
```

### FileFormat: JPEG for Smaller Files

Use `"JPEG"` for smaller file sizes when the background doesn't need transparency. Requires `"VisParams"` since JPEG output is server-rendered. Default is `"PNG"`:

```wolfram
g = GEEGeoGraphics[
  {Yellow, Thick,
   GeoPath[{GeoPosition[{30.05, 31.23}], GeoPosition[{30.85, 31.30}]}]},
  "USGS/SRTMGL1_003",
  GeoRange -> {{29.8, 31.2}, {30.5, 32.0}},
  "FileFormat" -> "JPEG",
  "VisParams" -> <|"min" -> 0, "max" -> 300,
    "palette" -> {"#f7e8aa", "#c4a44e", "#006633"}|>];
Export["nile_delta.jpg", g]
```

### Bands: Single-Band Selection

Select a specific band from a multi-band asset. Without `"Bands"`, the first 3 bands are auto-selected for RGB — which may not be meaningful for all datasets:

```wolfram
GEEGeoGraphics[
  {Red, GeoMarker[GeoPosition[{35.68, 139.69}]]},
  "NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG",
  "Bands" -> {"avg_rad"},
  GeoRange -> Quantity[60, "Kilometers"],
  RasterSize -> {512, 512}]
(* Tokyo nighttime radiance — single avg_rad band as grayscale *)
```

### VisParams: Color Palette for Elevation

Apply server-side visualization with `"min"`, `"max"`, and `"palette"`. Without `"VisParams"`, data is auto-rescaled client-side (2nd--98th percentile), which works well for most cases. Use `"VisParams"` when you need precise control over the color mapping:

```wolfram
watershed = GeoPolygon[{
  GeoPosition[{39.6, -105.8}], GeoPosition[{39.9, -105.8}],
  GeoPosition[{39.9, -105.4}], GeoPosition[{39.6, -105.4}]
}];
GEEGeoGraphics[
  {FaceForm[RGBColor[0, 0.5, 1, 0.2]], EdgeForm[{White, Thick}],
   watershed},
  "USGS/SRTMGL1_003",
  "VisParams" -> <|"min" -> 2000, "max" -> 4300,
    "palette" -> {"#006633", "#66cc33", "#ffff00",
      "#cc6600", "#993300", "#ffffff"}|>,
  GeoRangePadding -> Quantity[10, "Kilometers"]]
(* Colorado Rockies watershed study area *)
```

### VisParams: Gamma Correction for Satellite RGB

Sentinel-2 RGB images often appear dark. `"gamma"` < 1 brightens midtones. Note: `"gamma"` and `"palette"` are mutually exclusive:

```wolfram
cities = {
  GeoPosition[{51.51, -0.13}],
  GeoPosition[{51.45, -0.97}],
  GeoPosition[{51.75, -1.26}]
};
GEEGeoGraphics[
  {Red, PointSize[0.015], GeoMarker /@ cities},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-05-01", "2024-09-01"] //
    GEEFilterBounds[{-1.6, 51.2, 0.3, 52.0}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000, "gamma" -> 0.8|>,
  GeoRange -> {{51.2, 52.0}, {-1.6, 0.3}},
  RasterSize -> {800, 500}]
(* Brightened true-color Sentinel-2 of London/Oxford region *)
```

### ImageSize: Control Display Size

`ImageSize` sets how large the `Graphics` object appears on screen (in points). It does not affect the background raster resolution — use `RasterSize` for that. Useful for side-by-side comparisons or fitting into a layout:

```wolfram
vis = <|"min" -> 0, "max" -> 3000,
  "palette" -> {"#006633", "#66cc33", "#ffff00",
    "#cc6600", "#993300", "#ffffff"}|>;
nile = GEEGeoGraphics[
  {Blue, Thick,
   GeoPath[{GeoPosition[{30.05, 31.23}], GeoPosition[{30.85, 31.30}]}]},
  "USGS/SRTMGL1_003",
  GeoRange -> {{29.8, 31.2}, {30.5, 32.0}},
  "VisParams" -> vis, ImageSize -> 300];
alps = GEEGeoGraphics[
  {Red, GeoMarker[GeoPosition[{45.83, 6.86}]]},
  "USGS/SRTMGL1_003",
  GeoRange -> {{45.5, 46.3}, {6.2, 7.5}},
  "VisParams" -> vis, ImageSize -> 300];
Row[{Labeled[nile, "Nile Delta"], Spacer[20],
     Labeled[alps, "Mont Blanc"]}, Alignment -> Top]
```

### GeoBackground: Disable Background Map

Set `GeoBackground -> None` to render only the primitives with no background image. Useful for overlaying GEE-derived annotations on your own base map or for lightweight vector-only output:

```wolfram
GEEGeoGraphics[
  {Red, Thick,
   GeoPolygon[{GeoPosition[{39.6, -105.8}],
               GeoPosition[{39.9, -105.8}],
               GeoPosition[{39.9, -105.4}],
               GeoPosition[{39.6, -105.4}]}],
   Blue, PointSize[0.02],
   GeoMarker[GeoPosition[{39.75, -105.6}]]},
  "USGS/SRTMGL1_003",
  GeoBackground -> None,
  GeoRangePadding -> Quantity[5, "Kilometers"]]
(* Only primitives rendered — no GEE API call for background *)
```

### ColorSpace: Convert Background to Grayscale

Convert the background map to a specific color space. Useful when overlaying colorful primitives on top — a grayscale background avoids visual clutter:

```wolfram
GEEGeoGraphics[
  {Red, Thick,
   GeoPath[{GeoPosition[{36.10, -112.30}],
            GeoPosition[{36.05, -111.90}]}],
   Blue, PointSize[0.02],
   GeoMarker[GeoPosition[{36.06, -112.11}]]},
  "USGS/SRTMGL1_003",
  GeoRange -> Quantity[25, "Kilometers"],
  ColorSpace -> "Grayscale",
  RasterSize -> {512, 512}]
(* Grand Canyon — grayscale elevation makes the red trail stand out *)
```

### Indonesian Volcanic Hazard Map

Plot active volcanoes along Java and Bali with color-coded hazard zones on elevation terrain. Each volcano gets a marker and a `GeoDisk` exclusion radius — red for high-risk stratovolcanoes, orange for lower-risk. The elevation palette reveals how volcanic peaks dominate the island chain:

```wolfram
volcanoes = {
  {"Merapi", GeoPosition[{-7.54, 110.45}], 10},
  {"Semeru", GeoPosition[{-8.11, 112.92}], 12},
  {"Bromo", GeoPosition[{-7.94, 112.95}], 8},
  {"Agung", GeoPosition[{-8.34, 115.51}], 10},
  {"Rinjani", GeoPosition[{-8.41, 116.46}], 10}
};
prims = Flatten[Map[
  {FaceForm[RGBColor[1, 0.2, 0, 0.15]], EdgeForm[{Red, Thick}],
   GeoDisk[#[[2]], Quantity[#[[3]], "Kilometers"]],
   White, PointSize[0.012], GeoMarker[#[[2]]]} &,
  volcanoes
]];
GEEGeoGraphics[prims,
  "USGS/SRTMGL1_003",
  GeoRange -> {{-9.0, -7.0}, {109.5, 117.5}},
  "VisParams" -> <|"min" -> 0, "max" -> 3700,
    "palette" -> {"#0064C8", "#004d00", "#006633",
      "#66cc33", "#ffff00", "#cc6600", "#993300"}|>,
  RasterSize -> {1024, 400},
  ImageSize -> 700]
```

### US East Coast Megalopolis on Nighttime Lights

Trace the Northeast Corridor — the most densely urbanized stretch in the Americas — as a glowing path over VIIRS nighttime radiance. Markers highlight major cities from Washington DC to Boston. The background reveals how the urban light footprint extends far beyond city centers:

```wolfram
corridor = GeoPath[{
  GeoPosition[{38.91, -77.04}],   (* Washington DC *)
  GeoPosition[{39.29, -76.61}],   (* Baltimore *)
  GeoPosition[{39.95, -75.17}],   (* Philadelphia *)
  GeoPosition[{40.71, -74.01}],   (* New York *)
  GeoPosition[{41.31, -72.92}],   (* New Haven *)
  GeoPosition[{41.82, -71.41}],   (* Providence *)
  GeoPosition[{42.36, -71.06}]    (* Boston *)
}];
markers = Map[GeoMarker, {
  GeoPosition[{38.91, -77.04}], GeoPosition[{40.71, -74.01}],
  GeoPosition[{42.36, -71.06}]
}];
GEEGeoGraphics[
  {Cyan, Thickness[0.004], corridor,
   Yellow, PointSize[0.015], markers},
  "NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG",
  "Bands" -> {"avg_rad"},
  GeoRange -> {{38.2, 42.8}, {-78.0, -70.0}},
  RasterSize -> {800, 600},
  ImageSize -> 600]
```

## Possible Issues

- If the background asset fails to load, the function still returns a `Graphics` with the primitives rendered but no background map.
- `GeoRange` must be specified or inferable from the primitives. Passing an empty list `{}` with no `GeoRange` returns `$Failed`.

## See Also

`GEEImage`, `GEEComputePixels`, `GEEGetTile`, `GEECollection`, `GEEFilterDate`, `GEEFilterProperty`
