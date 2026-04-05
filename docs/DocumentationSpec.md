# GoogleEarthEngineClient Documentation Specification

Content specification for creating paclet documentation notebooks using the
Documentation Tools palette. Each section maps directly to a palette-created
notebook in `Documentation/English/`.

---

## Guide Page: GoogleEarthEngineClient

**Notebook:** `Documentation/English/Guides/GoogleEarthEngineClient.nb`

### Guide Abstract

Tools for authenticating with Google Earth Engine, retrieving satellite imagery,
querying pixel and feature data, and rendering geographic visualizations using
the GEE REST API v1.

### Function Listings

**Authentication**

| Format | Function         | Description                                  |
| ------ | ---------------- | -------------------------------------------- |
| 1-Line | `GEEConnect`     | authenticate with a service account key file |
| 1-Line | `$GEEConnection` | current authentication state                 |

**Asset Metadata**

| Format | Function          | Description                                             |
| ------ | ----------------- | ------------------------------------------------------- |
| 1-Line | `GEEGetAssetInfo` | fetch metadata for an image, collection, or table asset |
| 1-Line | `GEEListAssets`   | list assets in a folder or collection                   |

**Image Retrieval**

| Format | Function           | Description                            |
| ------ | ------------------ | -------------------------------------- |
| 1-Line | `GEEComputePixels` | compute raw pixels over a bounding box |
| 1-Line | `GEEImage`         | return a geo-tagged image of a region  |
| 1-Line | `GEEGetTile`       | fetch a rendered Web Mercator map tile |

**Point Queries**

| Format | Function        | Description                               |
| ------ | --------------- | ----------------------------------------- |
| 1-Line | `GEEIdentify`   | identify pixel values at a single point   |
| 1-Line | `GEEGetSamples` | batch pixel extraction at multiple points |

**Feature Queries**

| Format | Function             | Description                             |
| ------ | -------------------- | --------------------------------------- |
| 1-Line | `GEEComputeFeatures` | query features from a FeatureCollection |

**Computation**

| Format | Function     | Description                               |
| ------ | ------------ | ----------------------------------------- |
| 1-Line | `GEECompute` | evaluate an arbitrary GEE expression tree |

**Visualization**

| Format | Function         | Description                                   |
| ------ | ---------------- | --------------------------------------------- |
| 1-Line | `GEEGeoGraphics` | render geo primitives on a GEE background map |

**Expression Builders** -- composable pipeline operators for filtering, transforming, and aggregating collections

| Format | Function               | Description                                        |
| ------ | ---------------------- | -------------------------------------------------- |
| 1-Line | `GEECollection`        | load an ImageCollection asset                      |
| 1-Line | `GEELoadImage`         | load a single Image asset                          |
| 1-Line | `GEEFeatureCollection` | load a FeatureCollection (table) asset             |
| 1-Line | `GEEFilterDate`        | filter collection by date range                    |
| 1-Line | `GEEFilterBounds`      | filter collection by spatial bounding box          |
| 1-Line | `GEEFilterProperty`    | filter collection by metadata property             |
| 1-Line | `GEESelectBands`       | select specific bands from an image or collection  |
| 1-Line | `GEEMosaic`            | mosaic collection into a single image              |
| 1-Line | `GEEMedian`            | per-pixel median composite                         |
| 1-Line | `GEEMean`              | per-pixel mean composite                           |
| 1-Line | `GEESort`              | sort collection by a metadata property             |
| 1-Line | `GEELimit`             | limit collection to at most n images               |
| 1-Line | `GEEFirst`             | get the first image from a collection              |
| 1-Line | `GEEVisualize`         | apply server-side visualization to an image        |
| 1-Line | `GEEGeometry`          | create a GEE point or rectangle geometry           |
| 1-Line | `GEEReduceRegion`      | compute a statistic over a region                  |
| 1-Line | `GEENormalizedDifference` | compute (b1-b2)/(b1+b2) server-side              |
| 1-Line | `GEEClip`              | clip an image to a geometry                        |
| 1-Line | `GEEUpdateMask`        | update the pixel mask of an image                  |
| 1-Line | `GEEUnmask`            | replace masked pixels with a fill value            |
| 1-Line | `GEESelfMask`          | mask pixels where value is 0 or masked             |
| 1-Line | `GEEAddBands`          | add bands from another image                       |
| 1-Line | `GEERename`            | rename bands of an image                           |
| 1-Line | `GEEAdd`               | per-pixel addition (image or constant)             |
| 1-Line | `GEESubtract`          | per-pixel subtraction                              |
| 1-Line | `GEEMultiply`          | per-pixel multiplication                           |
| 1-Line | `GEEDivide`            | per-pixel division                                 |
| 1-Line | `GEEExpression`        | evaluate a math expression with band bindings      |
| 1-Line | `GEEGreaterThan`       | per-pixel greater than comparison (0/1)            |
| 1-Line | `GEELessThan`          | per-pixel less than comparison (0/1)               |
| 1-Line | `GEEEquals`            | per-pixel equality comparison (0/1)                |
| 1-Line | `GEENotEquals`         | per-pixel inequality comparison (0/1)              |
| 1-Line | `GEEAnd`               | logical AND of two images                          |
| 1-Line | `GEEOr`                | logical OR of two images                           |
| 1-Line | `GEENot`               | logical NOT of an image                            |
| 1-Line | `GEEWhere`             | conditional pixel replacement                      |
| 1-Line | `GEECollectionMap`     | apply a function to each image in a collection     |
| 1-Line | `GEEQualityMosaic`     | mosaic using a quality band (best-pixel)           |
| 1-Line | `GEEMerge`             | merge two collections                              |
| 1-Line | `GEECollectionMax`     | pixel-wise max composite                           |
| 1-Line | `GEECollectionMin`     | pixel-wise min composite                           |
| 1-Line | `GEECollectionSum`     | pixel-wise sum composite                           |
| 1-Line | `GEEToBands`           | stack collection into multi-band image             |
| 1-Line | `GEEReduceStdDev`      | per-pixel standard deviation                       |
| 1-Line | `GEEReduceCount`       | per-pixel count of non-masked values               |
| 1-Line | `GEEReducePercentile`  | reduce to specified percentiles                    |

### Related Tech Notes

(none yet)

### Related Guides

- Wolfram Language GeoGraphics Guide (built-in)

### Related Links

- Google Earth Engine Data Catalog: https://developers.google.com/earth-engine/datasets
- GEE REST API Reference: https://developers.google.com/earth-engine/reference/rest

### Keywords

google earth engine, gee, satellite imagery, remote sensing, geospatial,
elevation, srtm, landsat, sentinel, raster, earth observation

---

## Symbol Page: GEEConnect

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEEConnect.nb`

### Usage

| Pattern                     | Description                                                                                                             |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `GEEConnect[keyFile]`       | Authenticate with Google Earth Engine using a service account JSON key file and store the connection in $GEEConnection. |
| `GEEConnect[keyFile, opts]` | Authenticate with the specified options.                                                                                |

### Details and Options

- `keyFile` must be a path to a valid service account JSON key file containing `"client_email"`, `"private_key"`, and `"project_id"` fields.
- On success, stores the connection in `$GEEConnection` and returns a status Association with keys `"Project"`, `"Status"`, and `"Expiry"`.
- The access token is automatically refreshed when it expires (1-hour lifetime).
- All other `GEE*` functions require `GEEConnect` to be called first.
- JWT signing requires Wolfram Language 14.0+ (`GenerateDigitalSignature`).

| Option      | Default     | Description                                                |
| ----------- | ----------- | ---------------------------------------------------------- |
| `"Project"` | `Automatic` | GCP project ID; auto-detected from key file when Automatic |

### Examples

#### Basic Examples

Authenticate with a service account key file:

```wolfram
conn = GEEConnect["/path/to/service-account-key.json"]
```

Specify an explicit project ID:

```wolfram
conn = GEEConnect["key.json", "Project" -> "my-other-project"]
```

#### Possible Issues

The service account must have the "Earth Engine Resource Viewer" IAM role and the Earth Engine API must be enabled in the GCP project.

### See Also

`$GEEConnection`, `GEEGetAssetInfo`, `GEEImage`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, authentication, service account, connect, oauth, jwt

---

## Symbol Page: $GEEConnection

**Notebook:** `Documentation/English/ReferencePages/Symbols/$GEEConnection.nb`

### Usage

| Pattern          | Description                                                |
| ---------------- | ---------------------------------------------------------- |
| `$GEEConnection` | Return the current authentication state as an Association. |

### Details and Options

- `$GEEConnection` holds an Association with keys `"Project"`, `"AccessToken"`, `"Expiry"`, and `"KeyFile"`.
- Set by `GEEConnect`; initially `Null` before authentication.
- The access token is automatically refreshed when it expires.

### Examples

#### Basic Examples

Check the current connection state:

```wolfram
$GEEConnection
```

Access individual fields:

```wolfram
$GEEConnection["Project"]
$GEEConnection["Expiry"]
```

### See Also

`GEEConnect`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, connection, authentication state

---

## Symbol Page: GEEGetAssetInfo

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEEGetAssetInfo.nb`

### Usage

| Pattern                          | Description                                                               |
| -------------------------------- | ------------------------------------------------------------------------- |
| `GEEGetAssetInfo[assetId]`       | Fetch metadata for a Google Earth Engine asset and return an Association. |
| `GEEGetAssetInfo[assetId, opts]` | Fetch metadata with the specified options.                                |

### Details and Options

- `assetId` is a string such as `"USGS/SRTMGL1_003"` or `"COPERNICUS/S2_SR_HARMONIZED"`.
- Returns an Association with keys `"Type"`, `"Name"`, `"Title"`, `"Description"`, `"Provider"`, `"ProviderURL"`, `"StartTime"`, `"EndTime"`, `"Geometry"`, `"Bands"`, `"Properties"`, and `"SizeBytes"`.
- Asset types include `"IMAGE"`, `"IMAGE_COLLECTION"`, `"TABLE"`, and `"FOLDER"`.
- `"Title"` returns the human-readable dataset title (e.g., "USGS Landsat 8 Level 2, Collection 2, Tier 1").
- `"Description"` returns the dataset description as plain text (HTML tags are stripped).
- `"Provider"` and `"ProviderURL"` identify the data provider.
- `"Bands"` is a list of Associations, each with keys `"Name"`, `"DataType"`, and `"Grid"`. For `IMAGE_COLLECTION` assets, band names are fetched from the first image in the collection. `TABLE` assets have no bands.
- When the GEE REST API does not return `"Title"`, `"Description"`, `"Provider"`, or `"ProviderURL"` (common for `IMAGE_COLLECTION` and `TABLE` assets), these fields are automatically fetched from the public GEE STAC catalog as a fallback.

| Option      | Default     | Description    |
| ----------- | ----------- | -------------- |
| `"Project"` | `Automatic` | GCP project ID |

### Examples

#### Basic Examples

Fetch metadata for the SRTM elevation dataset:

```wolfram
info = GEEGetAssetInfo["USGS/SRTMGL1_003"]
info["Type"]         (* "IMAGE" *)
info["Title"]        (* "NASA SRTM Digital Elevation 30m" *)
info["Provider"]     (* "NASA / USGS / JPL-Caltech" *)
info["Description"]  (* plain text, HTML stripped *)
info["Bands"]        (* {<|"Name" -> "elevation", ...|>} *)
```

Fetch metadata for a Landsat 8 image collection (band names fetched from first image):

```wolfram
info = GEEGetAssetInfo["LANDSAT/LC08/C02/T1_L2"]
info["Type"]                  (* "IMAGE_COLLECTION" *)
info["Title"]                 (* "USGS Landsat 8 Level 2, Collection 2, Tier 1" *)
info["Bands"][[All, "Name"]]  (* {"SR_B1", "SR_B2", ..., "QA_RADSAT"} *)
```

Query a table asset:

```wolfram
info = GEEGetAssetInfo["TIGER/2018/States"]
info["Type"]    (* "TABLE" *)
info["Bands"]   (* {} — tables have no bands *)
```

### See Also

`GEEListAssets`, `GEEConnect`, `GEEImage`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, asset, metadata, bands, image collection

---

## Symbol Page: GEEListAssets

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEEListAssets.nb`

### Usage

| Pattern                       | Description                                                |
| ----------------------------- | ---------------------------------------------------------- |
| `GEEListAssets[parent]`       | List assets in a Google Earth Engine folder or collection. |
| `GEEListAssets[parent, opts]` | List assets with the specified options.                    |

### Details and Options

- `parent` is a folder or collection asset ID such as `"USGS"` or `"COPERNICUS"`.
- Returns a list of Associations, each with the same keys as `GEEGetAssetInfo`.

| Option         | Default     | Description                        |
| -------------- | ----------- | ---------------------------------- |
| `"MaxResults"` | `100`       | maximum number of assets to return |
| `"Filter"`     | `None`      | filter expression string           |
| `"Project"`    | `Automatic` | GCP project ID                     |

### Examples

#### Basic Examples

List assets in the USGS folder:

```wolfram
assets = GEEListAssets["USGS"]
Length[assets]
```

List at most 5 assets:

```wolfram
assets = GEEListAssets["USGS", "MaxResults" -> 5]
```

### See Also

`GEEGetAssetInfo`, `GEEConnect`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, list, assets, folder, collection, catalog

---

## Symbol Page: GEEComputePixels

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEEComputePixels.nb`

### Usage

| Pattern                                 | Description                                                                                                |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `GEEComputePixels[bbox, assetId]`       | Compute pixels for a GEE image asset over the bounding box {west, south, east, north} and return an Image. |
| `GEEComputePixels[region, assetId]`     | Compute pixels over the bounding box of a geographic primitive (GeoPosition, Polygon, Entity, etc.).       |
| `GEEComputePixels[bbox, assetId, opts]` | Compute pixels with the specified options.                                                                 |

### Details and Options

- `bbox` is `{west, south, east, north}` in EPSG:4326 coordinates.
- `assetId` can be a string asset ID or a pre-built GEE expression Association from the expression builder functions (`GEECollection`, `GEEFilterDate`, etc.). When a string is provided for an `IMAGE_COLLECTION` asset, the collection is automatically filtered to the bounding box and the most recent 3 years of data, then mosaicked. Expression Associations give full control over filtering, band selection, and aggregation.
- Returns an Image object.
- Maximum uncompressed output is 48 MB per request.
- When `"Bands"` is `Automatic` and the format is PNG or JPEG, assets with more than 3 bands are automatically trimmed to the first 3 bands (RGB). Single-band assets are returned as grayscale.
- When no `"VisParams"` are provided, pixel data is fetched as GeoTIFF internally and auto-rescaled (2nd–98th percentile) for display. This correctly handles nodata values and signed integer data.
- When `"VisParams"` are provided, the GEE server applies the visualization and returns the requested format directly.

| Option         | Default       | Description                                                                                         |
| -------------- | ------------- | --------------------------------------------------------------------------------------------------- |
| `"ImageSize"`  | `{512, 512}`  | output image dimensions {width, height}                                                             |
| `"FileFormat"` | `"PNG"`       | output format: "PNG", "JPEG", or "GEO_TIFF"                                                         |
| `"Bands"`      | `Automatic`   | list of band names, or Automatic for all; auto-selects first 3 for PNG/JPEG when asset has >3 bands |
| `"CRS"`        | `"EPSG:4326"` | coordinate reference system                                                                         |
| `"VisParams"`  | `<\|\|>`      | visualization parameters: "min", "max", "palette", "bands", "gamma"                                 |
| `"Project"`    | `Automatic`   | GCP project ID                                                                                      |

### Examples

#### Basic Examples

Fetch SRTM elevation pixels for a bounding box near Austin, TX:

```wolfram
img = GEEComputePixels[{-97.8, 30.2, -97.7, 30.3},
  "USGS/SRTMGL1_003"]
```

Specify custom image size and format:

```wolfram
img = GEEComputePixels[{-97.8, 30.2, -97.7, 30.3},
  "USGS/SRTMGL1_003",
  "ImageSize" -> {1024, 1024},
  "FileFormat" -> "GEO_TIFF"]
```

#### Applications

Apply visualization parameters to create a color-mapped elevation image:

```wolfram
img = GEEComputePixels[{-97.8, 30.2, -97.7, 30.3},
  "USGS/SRTMGL1_003",
  "VisParams" -> <|"min" -> 0, "max" -> 3000,
    "palette" -> {"green", "yellow", "brown"}|>]
```

Fetch Sentinel-2 true color RGB from an ImageCollection:

```wolfram
img = GEEComputePixels[{-3.8, 40.3, -3.6, 40.5},
  "COPERNICUS/S2_SR_HARMONIZED",
  "Bands" -> {"B4", "B3", "B2"},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>,
  "ImageSize" -> {512, 512}]
```

Fetch Landsat 8 true color:

```wolfram
img = GEEComputePixels[{-122.5, 37.5, -122.0, 38.0},
  "LANDSAT/LC08/C02/T1_L2",
  "Bands" -> {"SR_B4", "SR_B3", "SR_B2"},
  "VisParams" -> <|"min" -> 7000, "max" -> 12000|>,
  "ImageSize" -> {512, 512}]
```

Build a cloud-filtered Sentinel-2 median composite using expression builders:

```wolfram
img = GEEComputePixels[{-3.8, 40.3, -3.6, 40.5},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

#### Possible Issues

Requests exceeding 48 MB uncompressed will fail. Band names must match those in the asset. PNG and JPEG formats require 1 or 3 bands; if an asset has more bands and no explicit selection is provided, the first 3 bands are auto-selected. The `GEEComputePixels::apierr` message surfaces the actual GEE API error when a request fails. The `"CRS"` option controls the output projection metadata but the bounding box is always specified in EPSG:4326 (lat/lon) coordinates. For `IMAGE_COLLECTION` assets, the collection is filtered by spatial bounds and the last 3 years before mosaicking, to avoid errors from heterogeneous band orderings in older images.

### See Also

`GEEImage`, `GEEGetTile`, `GEEIdentify`, `GEECollection`, `GEEFilterDate`, `GEEFilterBounds`, `GEEFilterProperty`, `GEESelectBands`, `GEEMosaic`, `GEEMedian`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, pixels, image, raster, bounding box, compute, expression, pipeline, filter

---

## Symbol Page: GEEImage

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEEImage.nb`

### Usage

| Pattern                           | Description                                                             |
| --------------------------------- | ----------------------------------------------------------------------- |
| `GEEImage[region, assetId]`       | Return a geo-tagged Image of region from the Google Earth Engine asset. |
| `GEEImage[region, assetId, opts]` | Return a geo-tagged Image with the specified options.                   |

### Details and Options

- `region` can be a `GeoPosition`, `GeoPath`, `GeoPolygon`, or list of geo elements.
- `assetId` can refer to an `IMAGE` or `IMAGE_COLLECTION` asset. Collections are automatically filtered to the requested region and the most recent 3 years of data, then mosaicked into a single image. This handles collections with heterogeneous band structures (e.g., Sentinel-2).
- Point regions are auto-padded to 10 km.
- The returned Image carries `MetaInformation` with `"GeoMetaInformation"` containing `"LonLatBox"`, `"GeoRange"`, `"GeoProjection"`, `"CRS"`, `"GEEAsset"`, and `"RasterSize"`.
- `RasterSize` takes precedence over `GeoResolution` and `GeoZoomLevel`.
- For PNG or JPEG output, assets with more than 3 bands are automatically trimmed to the first 3 bands when `"Bands"` is `Automatic`.
- When no `"VisParams"` are provided, pixel data is fetched as GeoTIFF internally and auto-rescaled (2nd–98th percentile) for display. This handles nodata values and provides good contrast across different data ranges.
- When `"VisParams"` are provided, the GEE server applies the visualization and returns the requested format directly.

| Option            | Default      | Description                                     |
| ----------------- | ------------ | ----------------------------------------------- |
| `RasterSize`      | `Automatic`  | output pixel dimensions {w, h}; default 512x512 |
| `"FileFormat"`    | `"PNG"`      | image format                                    |
| `GeoRangePadding` | `None`       | padding around the region                       |
| `GeoRange`        | `Automatic`  | explicit geographic range                       |
| `GeoCenter`       | `Automatic`  | center override                                 |
| `GeoResolution`   | `Automatic`  | meters per pixel (Quantity)                     |
| `GeoZoomLevel`    | `Automatic`  | Web map zoom level (integer)                    |
| `GeoProjection`   | `"Mercator"` | output projection                               |
| `"Bands"`         | `Automatic`  | band selection                                  |
| `"VisParams"`     | `<\|\|>`     | visualization parameters                        |
| `ImageSize`       | `Automatic`  | display size                                    |
| `ColorSpace`      | `Automatic`  | color space conversion                          |
| `"Project"`       | `Automatic`  | GCP project ID                                  |

### Examples

#### Basic Examples

Fetch an elevation image centered on Austin, TX:

```wolfram
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003"]
```

Specify range and resolution:

```wolfram
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[20, "Kilometers"],
  GeoResolution -> Quantity[30, "Meters"]]
```

#### Scope

Use an explicit latitude/longitude range:

```wolfram
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003",
  GeoRange -> {{30.0, 30.5}, {-98.0, -97.5}}]
```

Apply visualization parameters with a color palette:

```wolfram
img = GEEImage[GeoPosition[{36.57, -118.29}], "USGS/SRTMGL1_003",
  GeoRange -> Quantity[50, "Kilometers"],
  "VisParams" -> <|"min" -> 0, "max" -> 4000,
    "palette" -> {"green", "yellow", "brown", "white"}|>]
```

Use an ImageCollection asset (automatically mosaicked):

```wolfram
img = GEEImage[GeoPosition[{0, 20}], "MODIS/061/MCD12Q1",
  GeoRange -> Quantity[2000, "Kilometers"],
  "Bands" -> {"LC_Type1"},
  "VisParams" -> <|"min" -> 0, "max" -> 17|>]
```

Sentinel-2 true color RGB:

```wolfram
img = GEEImage[GeoPosition[{40.4, -3.7}], "COPERNICUS/S2_SR_HARMONIZED",
  GeoRange -> Quantity[20, "Kilometers"],
  "Bands" -> {"B4", "B3", "B2"},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

Fetch a multi-band asset (first 3 bands auto-selected):

```wolfram
img = GEEImage[GeoPosition[{34.08, -117.45}], "NASA/ASTER_GED/AG100_003",
  GeoRange -> Quantity[100, "Kilometers"]]
```

#### Properties & Relations

Access geo-metadata from the returned image:

```wolfram
img = GEEImage[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003"];
Options[img, MetaInformation][[1, 2]]["GeoMetaInformation"]["LonLatBox"]
```

### See Also

`GEEComputePixels`, `GEEGeoGraphics`, `GEEGetTile`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, image, geo-tagged, satellite, raster, region

---

## Symbol Page: GEEGetTile

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEEGetTile.nb`

### Usage

| Pattern                              | Description                                                                                  |
| ------------------------------------ | -------------------------------------------------------------------------------------------- |
| `GEEGetTile[assetId, z, x, y]`       | Fetch a map tile at zoom level z, tile coordinates x, y for a GEE asset and return an Image. |
| `GEEGetTile[assetId, point, z]`      | Fetch the tile containing the GeoPosition point at zoom level z.                             |
| `GEEGetTile[assetId, z, x, y, opts]` | Fetch a map tile with the specified options.                                                 |

### Details and Options

- `z` is the zoom level, `x` and `y` are tile coordinates in the Web Mercator tiling scheme.
- The `point` overload accepts a `GeoPosition` and computes tile coordinates automatically.
- `assetId` can refer to an `IMAGE` or `IMAGE_COLLECTION` asset. Collections are automatically filtered to the tile's bounding box and the most recent 3 years of data, then mosaicked into a single image. This handles collections with heterogeneous band structures (e.g., Sentinel-2).
- Internally creates a map ID via the `maps:create` endpoint, then fetches the tile.
- Returns an Image, typically 256x256 PNG.

| Option        | Default     | Description              |
| ------------- | ----------- | ------------------------ |
| `"Bands"`     | `Automatic` | band selection           |
| `"VisParams"` | `<\|\|>`    | visualization parameters |
| `"Project"`   | `Automatic` | GCP project ID           |

### Examples

#### Basic Examples

Fetch the SRTM elevation tile containing Mount Fuji at zoom level 10:

```wolfram
tile = GEEGetTile["USGS/SRTMGL1_003",
  GeoPosition[{35.36, 138.73}], 10,
  "VisParams" -> <|"min" -> 0, "max" -> 3776,
    "palette" -> {"#000033", "#006600", "#339933",
      "#996633", "#CC9966", "#FFFFFF"}|>]
```

Fetch tile 8/189/107 covering the Everest region of the Himalayas:

```wolfram
tile = GEEGetTile["USGS/SRTMGL1_003", 8, 189, 107,
  "VisParams" -> <|"min" -> 0, "max" -> 8500,
    "palette" -> {"#006600", "#339933", "#996633",
      "#CC9966", "#FFFFFF"}|>]
```

#### Scope

Compare zoom levels -- the same location at increasing detail:

```wolfram
vis = <|"min" -> 500, "max" -> 2800,
  "palette" -> {"#2b1a0e", "#8B4513", "#D2691E", "#F5DEB3"}|>;
tiles = Table[
  GEEGetTile["USGS/SRTMGL1_003",
    GeoPosition[{36.10, -112.11}], z,
    "VisParams" -> vis],
  {z, {6, 10, 14}}
]
```

Color-mapped elevation of the Alps:

```wolfram
tile = GEEGetTile["USGS/SRTMGL1_003",
  GeoPosition[{46.85, 8.23}], 8,
  "VisParams" -> <|"min" -> 200, "max" -> 4500,
    "palette" -> {"#1a9850", "#91cf60", "#d9ef8b",
      "#fee08b", "#fc8d59", "#d73027", "#ffffff"}|>]
```

Cloud-filtered true-color Sentinel-2 imagery of the Nile Delta:

```wolfram
tile = GEEGetTile[
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-04-01", "2024-09-01"] //
    GEEFilterBounds[{30.5, 30.5, 31.9, 31.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  GeoPosition[{30.9, 31.2}], 9,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

Near-infrared false color (vegetation in red) over the Amazon:

```wolfram
tile = GEEGetTile[
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-10-01"] //
    GEEFilterBounds[{-60.5, -3.5, -59.5, -2.7}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEESelectBands[{"B8", "B4", "B3"}] //
    GEEMedian,
  GeoPosition[{-3.12, -60.02}], 10,
  "VisParams" -> <|"min" -> 0, "max" -> 4000|>]
```

VIIRS nighttime radiance over Tokyo:

```wolfram
tile = GEEGetTile["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG",
  GeoPosition[{35.68, 139.69}], 8,
  "Bands" -> {"avg_rad"},
  "VisParams" -> <|"min" -> 0, "max" -> 60|>]
```

Cloud-filtered Sentinel-2 composite using expression builders:

```wolfram
tile = GEEGetTile[
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-09-01"] //
    GEEFilterBounds[{2.0, 41.3, 2.3, 41.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  GeoPosition[{41.39, 2.17}], 11,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### See Also

`GEEComputePixels`, `GEEImage`, `GEEGeoGraphics`, `GEECollection`, `GEEFilterDate`, `GEEFilterProperty`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, tile, map, web mercator, zoom, slippy map

---

## Symbol Page: GEEIdentify

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEEIdentify.nb`

### Usage

| Pattern                             | Description                                                                    |
| ----------------------------------- | ------------------------------------------------------------------------------ |
| `GEEIdentify[point, assetId]`       | Identify pixel values at a GeoPosition from a Google Earth Engine image asset. |
| `GEEIdentify[point, assetId, opts]` | Identify pixel values with the specified options.                              |

### Details and Options

- `point` must be a `GeoPosition`.
- `assetId` can refer to an `IMAGE` or `IMAGE_COLLECTION` asset. Collections are automatically filtered to a small region around the query point and the most recent 3 years of data, then mosaicked into a single image.
- Returns an Association with keys `"Position"`, `"Values"`, and `"Bands"`.
- `"Values"` is a list of numeric pixel values, one per band. Nodata pixels return `Null`.
- `"Bands"` is a list of band name strings. Band order is determined by the server (alphabetical), not by the order specified in the `"Bands"` option.
- Internally uses `value:compute` with an `Image.reduceRegion` expression.

| Option      | Default     | Description                              |
| ----------- | ----------- | ---------------------------------------- |
| `"Bands"`   | `Automatic` | list of band names, or Automatic for all |
| `"Project"` | `Automatic` | GCP project ID                           |

### Examples

#### Basic Examples

Get SRTM elevation at a point:

```wolfram
result = GEEIdentify[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003"]
result["Values"]
result["Bands"]
```

Request specific bands from a multi-band asset:

```wolfram
result = GEEIdentify[GeoPosition[{34.08, -117.45}],
  "NASA/ASTER_GED/AG100_003",
  "Bands" -> {"emissivity_band10", "emissivity_band11"}]
```

#### Scope

Query pixel values from an ImageCollection (auto-mosaicked):

```wolfram
result = GEEIdentify[GeoPosition[{40.4, -3.7}],
  "COPERNICUS/S2_SR_HARMONIZED",
  "Bands" -> {"B4", "B3", "B2"}]
```

Query Landsat 8 surface reflectance bands:

```wolfram
result = GEEIdentify[GeoPosition[{37.77, -122.42}],
  "LANDSAT/LC08/C02/T1_L2",
  "Bands" -> {"SR_B4", "SR_B3", "SR_B2"}]
```

### See Also

`GEEGetSamples`, `GEEComputePixels`, `GEEImage`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, identify, pixel, point query, elevation, sample

---

## Symbol Page: GEEGetSamples

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEEGetSamples.nb`

### Usage

| Pattern                                | Description                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------- |
| `GEEGetSamples[points, assetId]`       | Extract pixel values at a list of GeoPosition points from a GEE image asset. |
| `GEEGetSamples[points, assetId, opts]` | Extract pixel values with the specified options.                             |

### Details and Options

- `points` is a list of `GeoPosition` objects.
- Returns a list of Associations, each with keys `"Position"` and `"Values"`.
- Delegates to `GEEIdentify` for each point.

| Option      | Default     | Description                              |
| ----------- | ----------- | ---------------------------------------- |
| `"Bands"`   | `Automatic` | list of band names, or Automatic for all |
| `"Project"` | `Automatic` | GCP project ID                           |

### Examples

#### Basic Examples

Sample SRTM elevation at two points:

```wolfram
results = GEEGetSamples[
  {GeoPosition[{30.25, -97.75}], GeoPosition[{40.71, -74.01}]},
  "USGS/SRTMGL1_003"]
results[[1]]["Values"]
results[[2]]["Values"]
```

#### Scope

Request specific bands:

```wolfram
results = GEEGetSamples[
  {GeoPosition[{30.25, -97.75}], GeoPosition[{40.71, -74.01}]},
  "COPERNICUS/S2_SR_HARMONIZED",
  "Bands" -> {"B4", "B3", "B2"}]
```

### See Also

`GEEIdentify`, `GEEComputePixels`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, samples, batch, multi-point, pixel extraction

---

## Symbol Page: GEEComputeFeatures

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEEComputeFeatures.nb`

### Usage

| Pattern                                     | Description                                                                |
| ------------------------------------------- | -------------------------------------------------------------------------- |
| `GEEComputeFeatures[assetId, filter]`       | Query features from a Google Earth Engine table asset matching the filter. |
| `GEEComputeFeatures[assetId, filter, opts]` | Query features with the specified options.                                 |

### Details and Options

- `assetId` must refer to a `TABLE` asset (e.g., `"TIGER/2018/States"`, `"WCMC/WDPA/current/polygons"`).
- `filter` is a filter expression string. Use `""` for no filter.
- Returns a list of Associations with keys `"Properties"` and `"Geometry"`.
- `"Properties"` is an Association of property name-value pairs.
- `"Geometry"` is an Association with a `"type"` key (e.g., `"Polygon"`, `"MultiPolygon"`) and coordinate data.
- Supports spatial filtering via the `"GeoBounds"` option.
- The no-filter overload `GEEComputeFeatures[assetId, opts]` is equivalent to passing `""` as the filter.

| Option          | Default     | Description                                |
| --------------- | ----------- | ------------------------------------------ |
| `"Properties"`  | `All`       | property names to include                  |
| `"MaxFeatures"` | `1000`      | maximum features to return (API max: 1001) |
| `"GeoBounds"`   | `None`      | spatial filter {west, south, east, north}  |
| `"Project"`     | `Automatic` | GCP project ID                             |

### Examples

#### Basic Examples

Query features from a table asset:

```wolfram
features = GEEComputeFeatures["TIGER/2018/States", "",
  "MaxFeatures" -> 5]
features[[1]]["Properties"]["NAME"]
```

#### Applications

Query protected areas within a geographic region:

```wolfram
features = GEEComputeFeatures["WCMC/WDPA/current/polygons", "",
  "GeoBounds" -> {-97.8, 30.2, -97.7, 30.3},
  "MaxFeatures" -> 10]
```

Query county boundaries near Austin, TX:

```wolfram
features = GEEComputeFeatures["TIGER/2018/Counties", "",
  "GeoBounds" -> {-97.9, 30.1, -97.5, 30.5},
  "MaxFeatures" -> 10]
```

Query watershed boundaries:

```wolfram
features = GEEComputeFeatures["USGS/WBD/2017/HUC06", "",
  "GeoBounds" -> {-98.0, 30.0, -97.0, 31.0},
  "MaxFeatures" -> 10]
```

#### Possible Issues

- The API returns at most 1001 features per request. Large queries without spatial bounds may be slow or hit server-side compute limits.
- Passing an `IMAGE` or `IMAGE_COLLECTION` asset instead of a `TABLE` asset will fail.

### See Also

`GEEGetAssetInfo`, `GEECompute`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, features, vector, table, query, filter, spatial

---

## Symbol Page: GEECompute

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEECompute.nb`

### Usage

| Pattern                        | Description                                                                                  |
| ------------------------------ | -------------------------------------------------------------------------------------------- |
| `GEECompute[expression]`       | Compute an arbitrary value from a Google Earth Engine expression tree and return the result. |
| `GEECompute[expression, opts]` | Compute with the specified options.                                                          |

### Details and Options

- `expression` is an Association representing a GEE v1 expression tree.
- Expression nodes use `"functionInvocationValue"` for function calls and `"constantValue"` for constants.
- Returns the computed result: a number, string, list, or Association depending on the expression.
- Constant expressions (`"constantValue"`) are evaluated and returned as-is.

| Option      | Default     | Description    |
| ----------- | ----------- | -------------- |
| `"Project"` | `Automatic` | GCP project ID |

### Examples

#### Basic Examples

Compute mean elevation over a bounding box:

```wolfram
expr = <|"functionInvocationValue" -> <|
  "functionName" -> "Image.reduceRegion",
  "arguments" -> <|
    "image" -> <|"functionInvocationValue" -> <|
      "functionName" -> "Image.load",
      "arguments" -> <|"id" -> <|"constantValue" -> "USGS/SRTMGL1_003"|>|>
    |>|>,
    "reducer" -> <|"functionInvocationValue" -> <|
      "functionName" -> "Reducer.mean",
      "arguments" -> <||>
    |>|>,
    "geometry" -> <|"functionInvocationValue" -> <|
      "functionName" -> "GeometryConstructors.Rectangle",
      "arguments" -> <|
        "coordinates" -> <|"constantValue" -> {-97.8, 30.2, -97.7, 30.3}|>
      |>
    |>|>,
    "scale" -> <|"constantValue" -> 30|>,
    "bestEffort" -> <|"constantValue" -> True|>
  |>
|>|>;
GEECompute[expr]
```

#### Scope

Compute the area of a geometry (in square meters):

```wolfram
expr = <|"functionInvocationValue" -> <|
  "functionName" -> "Geometry.area",
  "arguments" -> <|
    "geometry" -> <|"functionInvocationValue" -> <|
      "functionName" -> "GeometryConstructors.Rectangle",
      "arguments" -> <|
        "coordinates" -> <|"constantValue" -> {-97.8, 30.2, -97.7, 30.3}|>
      |>
    |>|>
  |>
|>|>;
GEECompute[expr]
```

Count the number of images in a collection:

```wolfram
expr = <|"functionInvocationValue" -> <|
  "functionName" -> "Collection.size",
  "arguments" -> <|
    "collection" -> <|"functionInvocationValue" -> <|
      "functionName" -> "ImageCollection.load",
      "arguments" -> <|"id" -> <|"constantValue" -> "MODIS/061/MCD12Q1"|>|>
    |>|>
  |>
|>|>;
GEECompute[expr]
```

#### Possible Issues

- The `GEECompute::apierr` message surfaces the actual GEE API error when an expression is invalid.
- Geometry functions that accept `maxError` require an `ErrorMargin` function invocation, not a plain number (omit `maxError` to use the default).

### See Also

`GEEIdentify`, `GEEComputeFeatures`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, compute, expression, reduce, aggregate, custom

---

## Symbol Page: GEEGeoGraphics

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEEGeoGraphics.nb`

### Usage

| Pattern                                     | Description                                                                                     |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `GEEGeoGraphics[primitives, assetId]`       | Render geographic primitives on a background map from a GEE asset and return a Graphics object. |
| `GEEGeoGraphics[primitives, assetId, opts]` | Render with the specified options.                                                              |

### Details and Options

- `primitives` can include `GeoMarker`, `GeoPath`, `GeoPolygon`, `GeoDisk`, `GeoCircle`, and standard Graphics `Point`/`Line`/`Polygon` with `GeoPosition`.
- Supports Graphics directives: `Red`, `Blue`, `PointSize`, `Thickness`, `Opacity`, `EdgeForm`, `FaceForm`, etc.
- `assetId` can refer to an `IMAGE` or `IMAGE_COLLECTION` asset. Collections are handled via `GEEComputePixels` (auto-filtered by region and date).
- Returns a `Graphics` object with the background map as an `Inset` and projected primitives overlaid.
- The bounding box is computed automatically from the primitives, with padding controlled by `GeoRangePadding`.
- If the background map fails to load, primitives are still rendered without a background (graceful degradation).

| Option            | Default       | Description                             |
| ----------------- | ------------- | --------------------------------------- |
| `GeoProjection`   | `"Mercator"`  | map projection                          |
| `GeoRange`        | `Automatic`   | geographic range                        |
| `GeoCenter`       | `Automatic`   | map center                              |
| `GeoRangePadding` | `Scaled[0.1]` | padding around primitives               |
| `RasterSize`      | `{512, 512}`  | background image pixel dimensions       |
| `GeoResolution`   | `Automatic`   | meters per pixel                        |
| `GeoZoomLevel`    | `Automatic`   | Web map zoom level                      |
| `"FileFormat"`    | `"PNG"`       | background image format                 |
| `"Bands"`         | `Automatic`   | band selection for background           |
| `"VisParams"`     | `<\|\|>`      | visualization parameters for background |
| `ImageSize`       | `Automatic`   | display size                            |
| `GeoBackground`   | `Automatic`   | set to None to disable background map   |
| `ColorSpace`      | `Automatic`   | color space conversion                  |
| `"Project"`       | `Automatic`   | GCP project ID                          |

### Examples

#### Basic Examples

Place a marker on an elevation map:

```wolfram
GEEGeoGraphics[
  GeoMarker[GeoPosition[{30.25, -97.75}]],
  "USGS/SRTMGL1_003"]
```

Draw a styled path:

```wolfram
GEEGeoGraphics[
  {Red, Thick,
   GeoPath[{GeoPosition[{30.2, -97.8}], GeoPosition[{30.3, -97.7}]}]},
  "USGS/SRTMGL1_003",
  "VisParams" -> <|"min" -> 100, "max" -> 400,
    "palette" -> {"green", "yellow", "brown"}|>]
```

#### Scope

Combine multiple primitives with styling:

```wolfram
GEEGeoGraphics[
  {Blue, GeoMarker[GeoPosition[{30.25, -97.75}]],
   Red, Opacity[0.3],
   GeoDisk[GeoPosition[{30.25, -97.75}], Quantity[5, "Kilometers"]]},
  "USGS/SRTMGL1_003",
  GeoRange -> Quantity[20, "Kilometers"]]
```

Use an ImageCollection as the background:

```wolfram
GEEGeoGraphics[
  GeoMarker[GeoPosition[{30.25, -97.75}]],
  "MODIS/061/MCD12Q1",
  "Bands" -> {"LC_Type1"},
  "VisParams" -> <|"min" -> 0, "max" -> 17|>,
  GeoRange -> Quantity[200, "Kilometers"]]
```

Render primitives without a background map:

```wolfram
GEEGeoGraphics[
  {Red, GeoMarker[GeoPosition[{30.25, -97.75}]]},
  "USGS/SRTMGL1_003",
  GeoBackground -> None]
```

#### Possible Issues

- If the background asset fails to load, the function still returns a `Graphics` with primitives rendered but no background map.
- `GeoRange` must be specified or inferable from the primitives. Passing an empty primitive list with no `GeoRange` returns `$Failed`.

### See Also

`GEEImage`, `GEEComputePixels`, `GEEGetTile`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, geographics, map, overlay, marker, visualization

---

## Symbol Pages: Expression Builders

The expression builder functions share a common pattern and are documented together as a group. Each function has a direct form and (where applicable) an operator form for use with `//`.

**Notebook:** `Documentation/English/ReferencePages/Symbols/GEECollection.nb` (and individual pages per symbol)

### Usage

| Pattern | Description |
| --- | --- |
| `GEECollection[assetId]` | Create a GEE expression for an ImageCollection asset. |
| `GEELoadImage[assetId]` | Create a GEE expression for a single Image asset. |
| `GEEFeatureCollection[assetId]` | Create a GEE expression for a FeatureCollection (table) asset. |
| `GEEFilterDate[collection, start, end]` | Filter a collection by date range (ISO 8601 strings). |
| `GEEFilterDate[start, end]` | Operator form for use with `//`. |
| `GEEFilterBounds[collection, bbox]` | Filter a collection by spatial bounding box `{west, south, east, north}`. |
| `GEEFilterBounds[bbox]` | Operator form for use with `//`. |
| `GEEFilterProperty[collection, property, op, value]` | Filter a collection by metadata property comparison. |
| `GEEFilterProperty[property, op, value]` | Operator form for use with `//`. |
| `GEESelectBands[expr, bands]` | Select specific bands from an image or collection. |
| `GEESelectBands[bands]` | Operator form for use with `//`. |
| `GEEMosaic[collection]` | Mosaic a collection into a single image (last-pixel-wins). |
| `GEEMedian[collection]` | Per-pixel median composite of a collection. |
| `GEEMean[collection]` | Per-pixel mean composite of a collection. |
| `GEESort[collection, property]` | Sort a collection by a metadata property (ascending). |
| `GEESort[collection, property, ascending]` | Sort with explicit direction. |
| `GEESort[property]` | Operator form for use with `//`. |
| `GEEFirst[collection]` | Get the first image from a collection. |
| `GEELimit[collection, n]` | Limit a collection to at most n images. |
| `GEELimit[n]` | Operator form for use with `//`. |
| `GEEVisualize[image, visParams]` | Apply server-side visualization to an image. |
| `GEEVisualize[visParams]` | Operator form for use with `//`. |
| `GEEGeometry[{lat, lon}]` | Create a GEE point geometry expression. |
| `GEEGeometry[{west, south, east, north}]` | Create a GEE rectangle geometry expression. |
| `GEEReduceRegion[image, geometry, reducer, scale]` | Compute a statistic over a region. |
| `GEEReduceRegion[geometry, reducer, scale]` | Operator form for use with `//`. |

### Details and Options

- All expression builders return an Association representing a GEE expression tree. This Association can be passed to `GEEComputePixels`, `GEEImage`, `GEEGetTile`, `GEEIdentify`, `GEEGetSamples`, `GEEComputeFeatures`, `GEECompute`, and `GEEGeoGraphics` in place of an asset ID string.
- **Operator forms** return a `Function` that takes a collection/image as its argument, enabling `//` piping: `coll // GEEFilterDate["2023-01-01", "2024-01-01"]`.
- **Pipeline order**: Load -> Filter (date, bounds, properties) -> Select bands -> Sort/Limit -> Aggregate (mosaic/median/mean). Filters can be applied in any order, but date and spatial filters should come first for performance.
- **Aggregation is required** before passing a collection to rendering functions (`GEEComputePixels`, `GEEImage`, etc.). Use `GEEMosaic`, `GEEMedian`, `GEEMean`, or `GEEFirst`.
- `GEEFilterProperty` `op` values: `"LessThan"`, `"GreaterThan"`, `"Equals"`, `"LessThanOrEquals"`, `"GreaterThanOrEquals"`, `"NotEquals"`.
- `GEEMedian` and `GEEMean` use `ImageCollection.reduce` internally, which appends `_median` or `_mean` to band names. `GEEMosaic` preserves original band names.
- `GEESelectBands` automatically detects whether its input is a collection or a single image and uses the appropriate API call.
- `GEEReduceRegion` `reducer` values: `"mean"`, `"min"`, `"max"`, `"sum"`, `"first"`, `"median"`.

### Examples

#### Basic Examples

Cloud-filtered Sentinel-2 true color RGB:

```wolfram
img = GEEComputePixels[{-3.8, 40.3, -3.6, 40.5},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

Least cloudy single Sentinel-2 image:

```wolfram
img = GEEComputePixels[{-3.8, 40.3, -3.6, 40.5},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2023-06-01", "2023-09-01"] //
    GEEFilterBounds[{-3.8, 40.3, -3.6, 40.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEESort["CLOUDY_PIXEL_PERCENTAGE"] //
    GEEFirst,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

SRTM elevation with color palette (single Image asset):

```wolfram
img = GEEComputePixels[{-105.4, 39.6, -105.1, 39.8},
  GEELoadImage["USGS/SRTMGL1_003"] //
    GEEVisualize[<|"min" -> 1500, "max" -> 4000,
      "palette" -> {"green", "yellow", "brown", "white"}|>]]
```

Compute mean elevation with GEECompute:

```wolfram
GEECompute[
  GEELoadImage["USGS/SRTMGL1_003"] //
    GEEReduceRegion[GEEGeometry[{-97.8, 30.2, -97.7, 30.3}], "mean", 30]
]
```

#### Possible Issues

- A collection pipeline must end with `GEEMosaic`, `GEEMedian`, `GEEMean`, or `GEEFirst` before passing to `GEEComputePixels` or `GEEImage`.
- `GEEMedian` and `GEEMean` append suffixes to band names (`_median`, `_mean`). This does not affect rendering but may matter for downstream band references.
- Always filter by date and bounds before `GEESelectBands` to avoid errors from collections with heterogeneous band structures across their history (e.g., Sentinel-2).
- Common metadata properties vary by dataset: Sentinel-2 uses `"CLOUDY_PIXEL_PERCENTAGE"`, Landsat uses `"CLOUD_COVER"`. Use `GEEGetAssetInfo` to discover available properties.

### See Also

`GEEComputePixels`, `GEEImage`, `GEECompute`, `GEEGetAssetInfo`

### Related Guides

GoogleEarthEngineClient

### Keywords

google earth engine, expression builder, pipeline, filter, collection, mosaic, median, bands, cloud filter, pipe operator
