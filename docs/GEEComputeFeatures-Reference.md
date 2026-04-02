# GEEComputeFeatures

Query features from a Google Earth Engine FeatureCollection.

## Usage

```wolfram
GEEComputeFeatures[assetId, filter]
GEEComputeFeatures[assetId]
GEEComputeFeatures[assetId, filter, opts]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"Properties"` | `All` | Property names to include |
| `"MaxFeatures"` | `1000` | Maximum features to return (API max: 1001) |
| `"GeoBounds"` | `None` | Spatial filter `{west, south, east, north}` |
| `"Project"` | `Automatic` | GCP project ID |

- `filter` is a filter expression string. Use `""` for no filter.
- Returns a list of Associations with keys `"Properties"` and `"Geometry"`.
- Supports spatial filtering via `"GeoBounds"`.

## Examples

### Basic Query

```wolfram
features = GEEComputeFeatures["WCMC/WDPA/current/polygons", "",
  "MaxFeatures" -> 10]
```

### Spatial Filter

```wolfram
features = GEEComputeFeatures["WCMC/WDPA/current/polygons", "",
  "GeoBounds" -> {-97.8, 30.2, -97.7, 30.3},
  "MaxFeatures" -> 10]
```

### No Filter (all features)

```wolfram
features = GEEComputeFeatures["WCMC/WDPA/current/polygons"]
```

## Possible Issues

- The API returns at most 1001 features per request.
- Large queries may be slow or hit compute limits.

## See Also

`GEEGetAssetInfo`, `GEECompute`
