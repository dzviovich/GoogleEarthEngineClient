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

### RasterSize

Control the pixel dimensions of the fetched raster. Higher values yield more detail but larger downloads. `RasterSize` takes precedence over `GeoResolution` and `GeoZoomLevel`.

```wolfram
(* High-resolution 2048x2048 elevation raster of Mount Fuji *)
img = GEEImage[GeoPosition[{35.36, 138.73}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[30, "Kilometers"],
  RasterSize -> {2048, 2048}]
```

### FileFormat

Choose the output format: `"PNG"` (default), `"JPEG"`, or `"GEO_TIFF"`. GeoTIFF preserves full numeric precision and is useful for analysis; PNG/JPEG are display-oriented.

```wolfram
(* Fetch a GeoTIFF for quantitative analysis of nighttime lights *)
img = GEEImage[GeoPosition[{51.51, -0.13}], "NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG",
  GeoRange -> Quantity[50, "Kilometers"],
  "Bands" -> {"avg_rad"},
  "FileFormat" -> "GEO_TIFF"]
```

### GeoRangePadding

Add padding around the region's bounding box. Accepts `Quantity` or `Scaled` values. Default is `None`.

```wolfram
(* Elevation around Yosemite Valley with 20 km padding on all sides *)
img = GEEImage[
  GeoPosition[{37.75, -119.59}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[10, "Kilometers"],
  GeoRangePadding -> Quantity[20, "Kilometers"]]
```

### GeoRange

Set the geographic extent explicitly, either as a distance radius or as explicit lat/lon bounds `{{south, north}, {west, east}}`.

```wolfram
(* Fixed lat/lon range covering the Nile Delta *)
img = GEEImage[GeoPosition[{30.9, 31.2}], "USGS/SRTMGL1_003",
  GeoRange -> {{30.0, 31.6}, {29.5, 32.5}}]
```

```wolfram
(* Distance-based range: 150 km around Kilimanjaro *)
img = GEEImage[GeoPosition[{-3.07, 37.35}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[150, "Kilometers"],
  "VisParams" -> <|"min" -> 500, "max" -> 5895,
    "palette" -> {"darkgreen", "green", "yellow", "brown", "white"}|>]
```

### GeoCenter

Override the map center independently of the region. Useful when the region defines the extent but you want to shift the viewport.

```wolfram
(* Region from a polygon, but center shifted to highlight the coast *)
img = GEEImage[
  GeoPosition[{43.30, 5.37}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[40, "Kilometers"],
  GeoCenter -> GeoPosition[{43.25, 5.50}]]
```

### GeoResolution

Set the output resolution in meters per pixel. The raster size is computed automatically to cover the geographic extent at this resolution.

```wolfram
(* 10 m/pixel Sentinel-2 imagery of the Grand Canyon *)
img = GEEImage[GeoPosition[{36.10, -112.11}],
  "COPERNICUS/S2_SR_HARMONIZED",
  GeoRange -> Quantity[5, "Kilometers"],
  GeoResolution -> Quantity[10, "Meters"],
  "Bands" -> {"B4", "B3", "B2"},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### GeoZoomLevel

Set the resolution using a Web Mercator zoom level (integer 0--20). Higher zoom = more detail. This is an alternative to `GeoResolution`.

```wolfram
(* Zoom level 12 (~38 m/pixel) elevation around Lake Geneva *)
img = GEEImage[GeoPosition[{46.45, 6.58}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[30, "Kilometers"],
  GeoZoomLevel -> 12]
```

### GeoProjection

Set the output map projection. Supported values: `"Mercator"` (default, EPSG:3857), `"Equirectangular"` (EPSG:4326), or any EPSG code string.

```wolfram
(* Equirectangular projection for Scandinavia — less distortion at high latitudes *)
img = GEEImage[GeoPosition[{60.0, 10.0}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[300, "Kilometers"],
  GeoProjection -> "Equirectangular",
  RasterSize -> {512, 512}]
```

### Bands

Select specific bands from the asset. When `Automatic` (default), PNG/JPEG output auto-selects the first 3 bands for RGB or 1 band for grayscale.

```wolfram
(* Near-infrared false color (B8=NIR, B4=Red, B3=Green) *)
img = GEEImage[GeoPosition[{-22.91, -43.17}],
  "COPERNICUS/S2_SR_HARMONIZED",
  GeoRange -> Quantity[25, "Kilometers"],
  "Bands" -> {"B8", "B4", "B3"},
  "VisParams" -> <|"min" -> 0, "max" -> 4000|>]
```

### VisParams

Apply server-side visualization. Keys: `"min"`, `"max"`, `"palette"` (for single-band), `"bands"`, `"gamma"`. Note: `"gamma"` and `"palette"` are mutually exclusive -- GEE does not allow both. Without `"VisParams"`, data is auto-rescaled (2nd--98th percentile).

```wolfram
(* Color-mapped elevation of the Andes near Machu Picchu *)
img = GEEImage[GeoPosition[{-13.16, -72.55}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[80, "Kilometers"],
  "VisParams" -> <|"min" -> 1000, "max" -> 6200,
    "palette" -> {"#0000FF", "#00FF00", "#FFFF00", "#FF8800", "#FF0000", "#FFFFFF"}|>]
```

```wolfram
(* Gamma correction on multi-band RGB -- no palette *)
img = GEEImage[GeoPosition[{-22.91, -43.17}],
  "COPERNICUS/S2_SR_HARMONIZED",
  GeoRange -> Quantity[25, "Kilometers"],
  "Bands" -> {"B4", "B3", "B2"},
  "VisParams" -> <|"min" -> 0, "max" -> 3000, "gamma" -> 1.4|>]
```

### ImageSize

Set the display size of the returned Image object (in screen pixels). This does not affect the raster resolution -- use `RasterSize` for that. `ImageSize` controls how large the image appears when displayed.

```wolfram
(* Fetch at 512x512 raster but display at 300 pixels wide *)
img = GEEImage[GeoPosition[{48.86, 2.35}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[25, "Kilometers"],
  RasterSize -> {512, 512},
  ImageSize -> 300]
```

### ColorSpace

Convert the returned image to a specific color space. Useful for analysis workflows that require grayscale or specific color models.

```wolfram
(* Convert SRTM elevation to grayscale *)
img = GEEImage[GeoPosition[{35.68, 139.69}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[30, "Kilometers"],
  ColorSpace -> "Grayscale"]
```

```wolfram
(* Cloud-filtered Sentinel-2 RGB to grayscale for edge detection *)
img = GEEImage[GeoPosition[{35.68, 139.69}],
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-04-01", "2023-10-01"] //
    GEEFilterBounds[{139.5, 35.5, 139.9, 35.9}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  GeoRange -> Quantity[15, "Kilometers"],
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>,
  ColorSpace -> "Grayscale"]
```

### Accessing Metadata

```wolfram
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003"];
Options[img, MetaInformation][[1, 2]]["GeoMetaInformation"]["LonLatBox"]
```

### Expression Builder Pipeline

Use expression builders for full control over collection filtering:

```wolfram
img = GEEImage[
  Entity["City", {"Paris", "IleDeFrance", "France"}],
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-05-01", "2023-09-01"] //
    GEEFilterBounds[{2.2, 48.8, 2.5, 48.9}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>,
  RasterSize -> {1024, 1024}]
```

## See Also

`GEEComputePixels`, `GEEGeoGraphics`, `GEEGetTile`, `GEECollection`, `GEEFilterDate`, `GEEFilterProperty`
