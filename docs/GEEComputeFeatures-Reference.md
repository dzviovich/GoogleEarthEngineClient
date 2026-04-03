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

- `assetId` must refer to a `TABLE` asset (e.g., `"TIGER/2018/States"`, `"WCMC/WDPA/current/polygons"`).
- `filter` is a filter expression string. Use `""` for no filter.
- Returns a list of Associations with keys `"Properties"` and `"Geometry"`.
- `"Properties"` is an Association of property name-value pairs.
- `"Geometry"` is an Association with a `"type"` key (e.g., `"Polygon"`, `"MultiPolygon"`) and coordinate data.
- Supports spatial filtering via `"GeoBounds"`.
- The no-filter overload `GEEComputeFeatures[assetId, opts]` is equivalent to passing `""` as the filter.

## Examples

### Basic Query

```wolfram
features = GEEComputeFeatures["TIGER/2018/States", "",
  "MaxFeatures" -> 5]
features[[1]]["Properties"]["NAME"]
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

### County Boundaries

```wolfram
features = GEEComputeFeatures["TIGER/2018/Counties", "",
  "GeoBounds" -> {-97.9, 30.1, -97.5, 30.5},
  "MaxFeatures" -> 10]
```

### Global Admin Boundaries

```wolfram
features = GEEComputeFeatures["FAO/GAUL/2015/level1", "",
  "GeoBounds" -> {2.2, 48.8, 2.5, 48.9},
  "MaxFeatures" -> 10]
```

### Watershed Boundaries

```wolfram
features = GEEComputeFeatures["USGS/WBD/2017/HUC06", "",
  "GeoBounds" -> {-98.0, 30.0, -97.0, 31.0},
  "MaxFeatures" -> 10]
```

## Possible Issues

- The API returns at most 1001 features per request.
- Large queries without spatial bounds may be slow or hit server-side compute limits.
- The `GEEComputeFeatures::apierr` message surfaces the actual GEE API error when a request fails (e.g., invalid asset name).
- Passing an `IMAGE` or `IMAGE_COLLECTION` asset instead of a `TABLE` asset will fail.

## See Also

`GEEGetAssetInfo`, `GEECompute`
