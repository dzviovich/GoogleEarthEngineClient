# GEEComputePixels

Compute pixels for a GEE image asset over a bounding box.

## Usage

```wolfram
GEEComputePixels[assetId, bbox]
GEEComputePixels[assetId, bbox, opts]
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
- Maximum uncompressed output is 48MB per request.
- Returns an Image object.

## Examples

### Basic

```wolfram
img = GEEComputePixels["USGS/SRTMGL1_003",
  {-97.8, 30.2, -97.7, 30.3}]
```

### Custom Size and Format

```wolfram
img = GEEComputePixels["USGS/SRTMGL1_003",
  {-97.8, 30.2, -97.7, 30.3},
  "ImageSize" -> {1024, 1024},
  "FileFormat" -> "GEO_TIFF"]
```

### With Visualization

```wolfram
img = GEEComputePixels["USGS/SRTMGL1_003",
  {-97.8, 30.2, -97.7, 30.3},
  "VisParams" -> <|"min" -> 0, "max" -> 3000,
    "palette" -> {"green", "yellow", "brown"}|>]
```

## Possible Issues

- Requests exceeding 48MB uncompressed will fail.
- Band names must match those in the asset.

## See Also

`GEEImage`, `GEEGetTile`, `GEEIdentify`
