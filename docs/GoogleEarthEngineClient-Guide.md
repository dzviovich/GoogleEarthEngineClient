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

| Function     | Description                                  |
| ------------ | -------------------------------------------- |
| `GEEConnect` | Authenticate with a service account key file |

### Asset Metadata

| Function          | Description                                               |
| ----------------- | --------------------------------------------------------- |
| `GEEGetAssetInfo` | Fetch metadata for a GEE asset (image, collection, table) |
| `GEEListAssets`   | List assets in a folder or collection                     |

### Image Retrieval

| Function           | Description                                    |
| ------------------ | ---------------------------------------------- |
| `GEEComputePixels` | Low-level pixel computation for a bounding box |
| `GEEImage`         | High-level geo-tagged image retrieval          |
| `GEEGetTile`       | Fetch a rendered map tile                      |

### Point Queries

| Function        | Description                                     |
| --------------- | ----------------------------------------------- |
| `GEEIdentify`   | Get pixel values at a single point              |
| `GEEGetSamples` | Batch pixel value extraction at multiple points |

### Feature Queries

| Function             | Description                             |
| -------------------- | --------------------------------------- |
| `GEEComputeFeatures` | Query features from a FeatureCollection |

### Computation

| Function     | Description                               |
| ------------ | ----------------------------------------- |
| `GEECompute` | Evaluate an arbitrary GEE expression tree |

### Visualization

| Function         | Description                                   |
| ---------------- | --------------------------------------------- |
| `GEEGeoGraphics` | Render geo primitives on a GEE background map |

### Expression Builders

Build composable GEE processing pipelines using Wolfram Language's `//` (postfix) operator. Pass the result to any function that accepts an asset ID.

**Loading**

| Function               | Description                                        |
| ---------------------- | -------------------------------------------------- |
| `GEECollection`        | Load an ImageCollection asset                      |
| `GEELoadImage`         | Load a single Image asset                          |
| `GEEFeatureCollection` | Load a FeatureCollection (table) asset             |

**Filtering**

| Function             | Description                                          |
| -------------------- | ---------------------------------------------------- |
| `GEEFilterDate`      | Filter collection by date range (ISO 8601 strings)   |
| `GEEFilterBounds`    | Filter collection by spatial region (bbox, geo primitives, or list) |
| `GEEFilterProperty`  | Filter collection by metadata property comparison    |

**Band Selection**

| Function          | Description                                            |
| ----------------- | ------------------------------------------------------ |
| `GEESelectBands`  | Select specific bands from an image or collection      |

**Aggregation**

| Function     | Description                                        |
| ------------ | -------------------------------------------------- |
| `GEEMosaic`  | Mosaic collection into a single image (last wins)  |
| `GEEMedian`  | Per-pixel median composite                         |
| `GEEMean`    | Per-pixel mean composite                           |

**Sorting and Limiting**

| Function    | Description                                      |
| ----------- | ------------------------------------------------ |
| `GEESort`   | Sort collection by a metadata property           |
| `GEELimit`  | Limit collection to at most n images             |
| `GEEFirst`  | Get the first image from a collection            |

**Visualization and Geometry**

| Function          | Description                                             |
| ----------------- | ------------------------------------------------------- |
| `GEEVisualize`    | Apply server-side visualization to an image             |
| `GEEGeometry`     | Create a GEE point or rectangle geometry                |
| `GEEReduceRegion` | Compute a statistic (mean, median, etc.) over a region  |

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

(* Cloud-filtered Sentinel-2 RGB using expression builders *)
img = GEEComputePixels[{-3.8, 40.3, -3.6, 40.5},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

## See Also

`GEEConnect`, `GEEGetAssetInfo`, `GEEListAssets`, `GEEComputePixels`, `GEEImage`, `GEEGetTile`, `GEEIdentify`, `GEEGetSamples`, `GEEComputeFeatures`, `GEECompute`, `GEEGeoGraphics`, `GEECollection`, `GEEFilterDate`, `GEEFilterBounds`, `GEEFilterProperty`, `GEESelectBands`, `GEEMosaic`, `GEEMedian`, `GEEMean`
