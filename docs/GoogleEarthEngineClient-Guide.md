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
| `GEEGetAssetInfo` | Fetch metadata for a GEE asset (image, collection, table). Falls back to STAC catalog for missing fields. |
| `GEEListAssets` | List assets in a folder or collection |

### Image Retrieval

| Function | Description |
|----------|-------------|
| `GEEComputePixels` | Low-level pixel computation for a bounding box (supports IMAGE and IMAGE_COLLECTION assets, auto-filters collections by region and date) |
| `GEEImage` | High-level geo-tagged image retrieval (auto-filters and mosaics collections, auto-rescales for display) |
| `GEEGetTile` | Fetch a rendered Web Mercator map tile (supports IMAGE and IMAGE_COLLECTION assets, auto-filters collections by tile extent and date) |

### Point Queries

| Function | Description |
|----------|-------------|
| `GEEIdentify` | Get pixel values at a single point (supports IMAGE and IMAGE_COLLECTION assets, auto-filters collections by region and date) |
| `GEEGetSamples` | Batch pixel value extraction at multiple points |

### Feature Queries

| Function | Description |
|----------|-------------|
| `GEEComputeFeatures` | Query features from a TABLE asset with optional spatial and expression filters |

### Computation

| Function | Description |
|----------|-------------|
| `GEECompute` | Evaluate an arbitrary GEE expression tree (reduceRegion, geometry operations, collection counts, constants) |

### Visualization

| Function | Description |
|----------|-------------|
| `GEEGeoGraphics` | Render geo primitives (markers, paths, polygons, disks, circles) on a GEE background map with styling support |

## Quick Examples

```wolfram
(* Authenticate *)
GEEConnect["my-key.json"]

(* Get SRTM elevation at a point *)
GEEIdentify[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003"]

(* Fetch a geo-tagged image *)
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[10, "Kilometers"]]

(* Fetch from an ImageCollection (auto-mosaicked) *)
img = GEEImage[GeoPosition[{0, 20}], "MODIS/061/MCD12Q1",
  GeoRange -> Quantity[2000, "Kilometers"],
  "Bands" -> {"LC_Type1"},
  "VisParams" -> <|"min" -> 0, "max" -> 17|>]

(* Query protected areas near Austin, TX *)
GEEComputeFeatures["WCMC/WDPA/current/polygons", "",
  "GeoBounds" -> {-97.8, 30.2, -97.7, 30.3},
  "MaxFeatures" -> 10]
```

## See Also

`GEEConnect`, `GEEGetAssetInfo`, `GEEListAssets`, `GEEComputePixels`, `GEEImage`, `GEEGetTile`, `GEEIdentify`, `GEEGetSamples`, `GEEComputeFeatures`, `GEECompute`, `GEEGeoGraphics`
