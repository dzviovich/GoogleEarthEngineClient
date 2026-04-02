# GEEGetAssetInfo

Fetch metadata for a Google Earth Engine asset.

## Usage

```wolfram
GEEGetAssetInfo[assetId]
GEEGetAssetInfo[assetId, "Project" -> projectId]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"Project"` | `Automatic` | GCP project ID |

- `assetId` is a string like `"USGS/SRTMGL1_003"` or `"COPERNICUS/S2_SR_HARMONIZED"`.
- Returns an Association with keys: `"Type"`, `"Name"`, `"Title"`, `"Description"`, `"StartTime"`, `"EndTime"`, `"Geometry"`, `"Bands"`, `"Properties"`, `"SizeBytes"`.
- Asset types include `"IMAGE"`, `"IMAGE_COLLECTION"`, `"TABLE"`, `"FOLDER"`.
- `"Bands"` is a list of Associations with `"Name"`, `"DataType"`, and `"Grid"`.

## Examples

### Basic

```wolfram
info = GEEGetAssetInfo["USGS/SRTMGL1_003"]
info["Type"]    (* "IMAGE" *)
info["Bands"]   (* {<|"Name" -> "elevation", ...|>} *)
```

### Image Collection

```wolfram
info = GEEGetAssetInfo["COPERNICUS/S2_SR_HARMONIZED"]
info["Type"]    (* "IMAGE_COLLECTION" *)
```

## See Also

`GEEListAssets`, `GEEConnect`
