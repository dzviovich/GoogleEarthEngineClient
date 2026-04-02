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

## See Also

`GEEComputePixels`, `GEEImage`
