# GoogleEarthEngineClient

Wolfram Language client for the Google Earth Engine REST API v1.

## Setup

```wolfram
Needs["GoogleEarthEngineClient`"]
GEEConnect["/path/to/service-account-key.json"]
```

Requires a Google Cloud service account with the Earth Engine API enabled and the "Earth Engine Resource Viewer" IAM role.

## Functions by Category

### Authentication

| Function | Description |
|----------|-------------|
| `GEEConnect` | Authenticate with a service account key file |

### Asset Metadata

| Function | Description |
|----------|-------------|
| `GEEGetAssetInfo` | Fetch metadata for a GEE asset (image, collection, table) |
| `GEEListAssets` | List assets in a folder or collection |

### Image Retrieval

| Function | Description |
|----------|-------------|
| `GEEComputePixels` | Low-level pixel computation for a bounding box |
| `GEEImage` | High-level geo-tagged image retrieval |
| `GEEGetTile` | Fetch a rendered map tile |

### Point Queries

| Function | Description |
|----------|-------------|
| `GEEIdentify` | Get pixel values at a single point |
| `GEEGetSamples` | Batch pixel value extraction at multiple points |

### Feature Queries

| Function | Description |
|----------|-------------|
| `GEEComputeFeatures` | Query features from a FeatureCollection |

### Computation

| Function | Description |
|----------|-------------|
| `GEECompute` | Evaluate an arbitrary GEE expression tree |

### Visualization

| Function | Description |
|----------|-------------|
| `GEEGeoGraphics` | Render geo primitives on a GEE background map |

## Quick Examples

```wolfram
(* Authenticate *)
GEEConnect["my-key.json"]

(* Get SRTM elevation at a point *)
GEEIdentify[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003"]

(* Fetch a geo-tagged image *)
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[10, "Kilometers"]]

(* Query protected areas near Austin, TX *)
GEEComputeFeatures["WCMC/WDPA/current/polygons", "",
  "GeoBounds" -> {-97.8, 30.2, -97.7, 30.3},
  "MaxFeatures" -> 10]
```

## See Also

`GEEConnect`, `GEEGetAssetInfo`, `GEEListAssets`, `GEEComputePixels`, `GEEImage`, `GEEGetTile`, `GEEIdentify`, `GEEGetSamples`, `GEEComputeFeatures`, `GEECompute`, `GEEGeoGraphics`
