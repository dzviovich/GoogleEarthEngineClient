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
- Returns an Association with keys: `"Type"`, `"Name"`, `"Title"`, `"Description"`, `"Provider"`, `"ProviderURL"`, `"StartTime"`, `"EndTime"`, `"Geometry"`, `"Bands"`, `"Properties"`, `"SizeBytes"`.
- Asset types include `"IMAGE"`, `"IMAGE_COLLECTION"`, `"TABLE"`, `"FOLDER"`.
- `"Title"` returns the human-readable dataset title (e.g., "USGS Landsat 8 Level 2, Collection 2, Tier 1").
- `"Description"` returns the dataset description as plain text (HTML tags are stripped).
- `"Provider"` and `"ProviderURL"` identify the data provider.
- `"Bands"` is a list of Associations with `"Name"`, `"DataType"`, and `"Grid"`. For `IMAGE` assets, band details include data type and grid info. For `IMAGE_COLLECTION` assets, band names are fetched from the first image in the collection. `TABLE` assets have no bands.
- When the GEE REST API does not return `"Title"`, `"Description"`, `"Provider"`, or `"ProviderURL"` (common for `IMAGE_COLLECTION` and `TABLE` assets), these fields are automatically fetched from the public [GEE STAC catalog](https://storage.googleapis.com/earthengine-stac/catalog/) as a fallback. No authentication is required for STAC lookups.

## Examples

### Basic

```wolfram
info = GEEGetAssetInfo["USGS/SRTMGL1_003"]
info["Type"]         (* "IMAGE" *)
info["Title"]        (* "NASA SRTM Digital Elevation 30m" *)
info["Provider"]     (* "NASA / USGS / JPL-Caltech" *)
info["Description"]  (* "The Shuttle Radar Topography Mission ..." *)
info["Bands"]        (* {<|"Name" -> "elevation", ...|>} *)
```

### Image Collection

```wolfram
info = GEEGetAssetInfo["LANDSAT/LC08/C02/T1_L2"]
info["Type"]                  (* "IMAGE_COLLECTION" *)
info["Title"]                 (* "USGS Landsat 8 Level 2, Collection 2, Tier 1" *)
info["Bands"][[All, "Name"]]  (* {"SR_B1", "SR_B2", ..., "QA_RADSAT"} *)
```

### Sentinel-2

```wolfram
info = GEEGetAssetInfo["COPERNICUS/S2_SR_HARMONIZED"]
info["Provider"]              (* "European Union/ESA/Copernicus" *)
Length[info["Bands"]]         (* 26 *)
```

### Table Asset

```wolfram
info = GEEGetAssetInfo["TIGER/2018/States"]
info["Type"]    (* "TABLE" *)
info["Bands"]   (* {} *)
```

## See Also

`GEEListAssets`, `GEEConnect`, `GEEImage`
