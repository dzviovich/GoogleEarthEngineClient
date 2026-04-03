# GEEGetTile

Fetch a rendered map tile from a Google Earth Engine asset.

## Usage

```wolfram
GEEGetTile[assetId, z, x, y]
GEEGetTile[assetId, point, z]
GEEGetTile[assetId, z, x, y, opts]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"Bands"` | `Automatic` | Band selection |
| `"VisParams"` | `<\|\|>` | Visualization parameters |
| `"Project"` | `Automatic` | GCP project ID |

- `z` is the zoom level, `x` and `y` are tile coordinates (Web Mercator tiling scheme).
- The `point` overload accepts a `GeoPosition` and computes tile coordinates automatically.
- `assetId` can refer to an `IMAGE` or `IMAGE_COLLECTION` asset. Collections are automatically filtered to the tile's bounding box and the most recent 3 years of data, then mosaicked into a single image. This handles collections with heterogeneous band structures (e.g., Sentinel-2).
- Internally creates a map ID via `maps:create`, then fetches the tile.
- Returns an Image (typically 256x256 PNG).

## Examples

### By Tile Coordinates

```wolfram
tile = GEEGetTile["USGS/SRTMGL1_003", 5, 7, 14]
```

### By GeoPosition

```wolfram
tile = GEEGetTile["USGS/SRTMGL1_003", GeoPosition[{30.25, -97.75}], 10]
```

### With Visualization Parameters

```wolfram
tile = GEEGetTile["USGS/SRTMGL1_003", 10, 237, 409,
  "VisParams" -> <|"min" -> 0, "max" -> 4000,
    "palette" -> {"green", "yellow", "brown", "white"}|>]
```

### ImageCollection (Sentinel-2 RGB)

```wolfram
tile = GEEGetTile["COPERNICUS/S2_SR_HARMONIZED",
  GeoPosition[{40.4, -3.7}], 10,
  "Bands" -> {"B4", "B3", "B2"},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Band Selection

```wolfram
tile = GEEGetTile["NASA/ASTER_GED/AG100_003", 6, 14, 25,
  "Bands" -> {"emissivity_band10"}]
```

## Possible Issues

- For `IMAGE_COLLECTION` assets, the collection is filtered by the tile's geographic extent and the last 3 years before mosaicking. This prevents errors from heterogeneous band orderings in older images.

## See Also

`GEEComputePixels`, `GEEImage`
