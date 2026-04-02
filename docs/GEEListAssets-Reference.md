# GEEListAssets

List assets in a Google Earth Engine folder or collection.

## Usage

```wolfram
GEEListAssets[parent]
GEEListAssets[parent, opts]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"MaxResults"` | `100` | Maximum number of assets to return |
| `"Filter"` | `None` | Filter expression string |
| `"Project"` | `Automatic` | GCP project ID |

- `parent` is a folder or collection asset ID (e.g., `"USGS"`, `"COPERNICUS"`).
- Returns a list of Associations, each with the same keys as `GEEGetAssetInfo`.

## Examples

### Basic

```wolfram
assets = GEEListAssets["USGS"]
Length[assets]
```

### Limited Results

```wolfram
assets = GEEListAssets["USGS", "MaxResults" -> 5]
```

## See Also

`GEEGetAssetInfo`, `GEEConnect`
