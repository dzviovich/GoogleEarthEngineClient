# GEEGetTile

Fetch a rendered map tile from a Google Earth Engine asset.

## Usage

```wolfram
GEEGetTile[assetId, z, x, y]
GEEGetTile[assetId, point, z]
GEEGetTile[assetId, z, x, y, opts]
```

## Details and Options

| Option        | Default     | Description              |
| ------------- | ----------- | ------------------------ |
| `"Bands"`     | `Automatic` | Band selection           |
| `"VisParams"` | `<\|\|>`    | Visualization parameters |
| `"Project"`   | `Automatic` | GCP project ID           |

- `z` is the zoom level (integer 0--20), `x` and `y` are tile coordinates in the Web Mercator tiling scheme. Higher zoom levels show more detail over a smaller area.
- The `point` overload accepts a `GeoPosition` or a geographic `Entity` (e.g., `Entity["City", ...]`, `Entity["Mountain", ...]`) and computes tile coordinates automatically. This is the easiest way to get a tile for a known location.
- `assetId` can be a string (e.g., `"USGS/SRTMGL1_003"`) or an expression builder Association (e.g., from `GEECollection[...] // GEEMedian`).
- For `IMAGE_COLLECTION` assets (string form), the collection is automatically filtered to the tile's bounding box and the most recent 3 years of data, then mosaicked into a single image. This handles collections with heterogeneous band structures (e.g., Sentinel-2).
- Internally creates a map ID via the `maps:create` endpoint, then fetches the rendered tile.
- Returns an Image, typically 256x256 PNG.
- Unlike `GEEImage` and `GEEComputePixels`, tiles are rendered entirely server-side. Without `"VisParams"`, single-band assets (e.g., SRTM elevation) render as flat gray. Always provide `"VisParams"` with `"min"`, `"max"`, and optionally `"palette"` for meaningful visualization.
- Zoom level reference: z=5 (~5000 km wide), z=8 (~600 km), z=10 (~150 km), z=12 (~40 km), z=14 (~10 km), z=16 (~2.5 km).

## Examples

### Basic: GeoPosition Lookup

Fetch the SRTM elevation tile containing Mount Fuji at zoom level 10 (~150 km tile):

```wolfram
tile = GEEGetTile["USGS/SRTMGL1_003",
  GeoPosition[{35.36, 138.73}], 10,
  "VisParams" -> <|"min" -> 0, "max" -> 3776,
    "palette" -> {"#000033", "#006600", "#339933",
      "#996633", "#CC9966", "#FFFFFF"}|>]
```

### Using a Geographic Entity

Fetch a tile using a geographic entity instead of coordinates:

```wolfram
tile = GEEGetTile["USGS/SRTMGL1_003",
  Entity["Mountain", "MountKilimanjaro"], 10,
  "VisParams" -> <|"min" -> 0, "max" -> 5895,
    "palette" -> {"darkgreen", "green", "yellow", "brown", "white"}|>]
```

### Basic: Explicit Tile Coordinates

Fetch tile 8/189/107 which covers the Everest region of the Himalayas (~86°E, 28°N):

```wolfram
tile = GEEGetTile["USGS/SRTMGL1_003", 8, 189, 107,
  "VisParams" -> <|"min" -> 0, "max" -> 8500,
    "palette" -> {"#006600", "#339933", "#996633",
      "#CC9966", "#FFFFFF"}|>]
```

### Zoom Level Comparison

Compare the same location at different zoom levels to see increasing detail. Lower zoom shows a continental overview; higher zoom resolves individual valleys:

```wolfram
(* Grand Canyon at three zoom levels *)
vis = <|"min" -> 500, "max" -> 2800,
  "palette" -> {"#2b1a0e", "#8B4513", "#D2691E", "#F5DEB3"}|>;
tiles = Table[
  GEEGetTile["USGS/SRTMGL1_003",
    GeoPosition[{36.10, -112.11}], z,
    "VisParams" -> vis],
  {z, {6, 10, 14}}
]
```

### Color-Mapped Elevation

Apply a palette to visualize elevation around the Alps:

```wolfram
tile = GEEGetTile["USGS/SRTMGL1_003",
  GeoPosition[{46.85, 8.23}], 8,
  "VisParams" -> <|"min" -> 200, "max" -> 4500,
    "palette" -> {"#1a9850", "#91cf60", "#d9ef8b",
      "#fee08b", "#fc8d59", "#d73027", "#ffffff"}|>]
```

### Satellite Imagery (Sentinel-2 RGB)

Cloud-filtered true-color Sentinel-2 imagery of the Nile Delta:

```wolfram
tile = GEEGetTile[
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-04-01", "2024-09-01"] //
    GEEFilterBounds[{30.5, 30.5, 31.9, 31.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  GeoPosition[{30.9, 31.2}], 9,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### False-Color Vegetation (NIR)

Near-infrared false color (B8=NIR, B4=Red, B3=Green) highlights vegetation in bright red. Amazon rainforest near Manaus:

```wolfram
tile = GEEGetTile[
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-10-01"] //
    GEEFilterBounds[{-60.5, -3.5, -59.5, -2.7}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEESelectBands[{"B8", "B4", "B3"}] //
    GEEMedian,
  GeoPosition[{-3.12, -60.02}], 10,
  "VisParams" -> <|"min" -> 0, "max" -> 4000|>]
```

### Nighttime Lights

VIIRS nighttime radiance over Tokyo:

```wolfram
tile = GEEGetTile["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG",
  GeoPosition[{35.68, 139.69}], 8,
  "Bands" -> {"avg_rad"},
  "VisParams" -> <|"min" -> 0, "max" -> 60|>]
```

### Land Cover Classification

ESA WorldCover land classification around Lake Victoria. The collection only contains 2021 data, so an explicit date filter is required.

GEE's `"palette"` maps colors linearly between `"min"` and `"max"`. For classification data with discrete class IDs (10, 20, 30, ..., 95), set `"min"` and `"max"` to the first and last class value. GEE interpolates the palette evenly across that range, so the number of palette entries should match the number of discrete steps. The ESA WorldCover classes and their standard colors are:

| Value | Class              | Color                  |
| ----- | ------------------ | ---------------------- |
| 10    | Tree cover         | `#006400` (dark green) |
| 20    | Shrubland          | `#FFBB22` (orange)     |
| 30    | Grassland          | `#FFFF4C` (yellow)     |
| 40    | Cropland           | `#F096FF` (pink)       |
| 50    | Built-up           | `#FA0000` (red)        |
| 60    | Bare / sparse      | `#B4B4B4` (gray)       |
| 70    | Snow and ice       | `#F0F0F0` (white)      |
| 80    | Permanent water    | `#0064C8` (blue)       |
| 90    | Herbaceous wetland | `#0096A0` (teal)       |
| 95    | Mangroves          | `#00CF75` (green)      |
| 100   | Moss and lichen    | `#FAE6A0` (tan)        |

```wolfram
tile = GEEGetTile[
  GEECollection["ESA/WorldCover/v200"] //
    GEEFilterDate["2021-01-01", "2022-01-01"] //
    GEESelectBands[{"Map"}] //
    GEEMosaic,
  GeoPosition[{-1.0, 33.0}], 7,
  "VisParams" -> <|"min" -> 10, "max" -> 100,
    "palette" -> {"#006400", "#FFBB22", "#FFFF4C", "#F096FF",
      "#FA0000", "#B4B4B4", "#F0F0F0", "#0064C8",
      "#0096A0", "#00CF75", "#FAE6A0"}|>]
```

### Single-Band Selection

Select emissivity band 10 from the ASTER Global Emissivity Dataset over the Sahara. Values are scaled by 1000 (e.g., 950 = 0.95 emissivity). Low emissivity (bare sand/rock) appears warm; high emissivity (vegetation/water) appears cool:

```wolfram
tile = GEEGetTile["NASA/ASTER_GED/AG100_003",
  GeoPosition[{25.0, 10.0}], 6,
  "Bands" -> {"emissivity_band10"},
  "VisParams" -> <|"min" -> 850, "max" -> 990,
    "palette" -> {"#d73027", "#fc8d59", "#fee08b",
      "#d9ef8b", "#91cf60", "#1a9850"}|>]
```

### Expression Builder Pipeline

Use expression builders for full control over collection filtering. Cloud-filtered Sentinel-2 median composite of Barcelona:

```wolfram
tile = GEEGetTile[
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-09-01"] //
    GEEFilterBounds[{2.0, 41.3, 2.3, 41.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  GeoPosition[{41.39, 2.17}], 11,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Building a Tile Grid

Fetch a 3x3 grid of adjacent tiles and assemble them into a larger image. The center tile for the Swiss Alps near the Matterhorn at z=10 is x=533, y=364 (use the `GeoPosition` overload to find tile coordinates for other locations):

```wolfram
(* 3x3 grid of Swiss Alps at z=10, centered on tile (533, 364) *)
vis = <|"min" -> 200, "max" -> 4500,
  "palette" -> {"#1a9850", "#91cf60", "#d9ef8b",
    "#fee08b", "#fc8d59", "#d73027", "#ffffff"}|>;
tiles = Table[
  GEEGetTile["USGS/SRTMGL1_003", 10, 533 + dx, 364 + dy,
    "VisParams" -> vis],
  {dy, -1, 1}, {dx, -1, 1}
];
ImageAssemble[tiles]
```

## Possible Issues

- Without `"VisParams"`, single-band assets render as flat gray. Tiles are rendered server-side with no client-side auto-rescaling. Always provide `"min"`, `"max"`, and optionally `"palette"` for single-band data.
- Tile coordinates (`x`, `y`) depend on the zoom level. Use the `GeoPosition` overload to avoid computing them manually.
- For `IMAGE_COLLECTION` assets passed as strings, the collection is filtered by the tile's geographic extent and the last 3 years before mosaicking. Use expression builders for finer control over date range, cloud filtering, or aggregation method.
- Tiles are always 256x256 pixels. For higher resolution, use `GEEImage` or `GEEComputePixels` with `RasterSize`.
- `"gamma"` and `"palette"` in `"VisParams"` are mutually exclusive -- GEE does not allow both.

## See Also

`GEEComputePixels`, `GEEImage`, `GEEGeoGraphics`, `GEECollection`, `GEEFilterDate`, `GEEFilterProperty`
