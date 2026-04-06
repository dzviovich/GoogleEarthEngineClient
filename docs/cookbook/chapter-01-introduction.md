# Chapter 1: Introduction and Getting Started

Google Earth Engine puts petabytes of Earth observation data at your
fingertips -- and this paclet lets you access it from a Mathematica notebook.
This chapter explains what the GoogleEarthEngineClient paclet provides,
walks through installation and authentication, and demonstrates five
practical queries that showcase the breadth of the paclet. By the end, you
will understand how expression trees work, which functions trigger
server-side computation, and the conventions used throughout this book.

---

## 1.1 What Is Google Earth Engine?

Google Earth Engine (GEE) is a planetary-scale geospatial analysis platform
that hosts over 80 petabytes of satellite imagery, climate records, terrain
models, land-cover classifications, and vector datasets. Unlike a simple tile
server, GEE provides a full computation engine: you describe an analysis as
an expression tree, and the platform evaluates it across its distributed
infrastructure. Only the final result travels over the network.

The GEE REST API v1 exposes this computation engine through standard HTTP
endpoints. You can:

- **Retrieve pixels** for any region of any raster dataset, with server-side
  filtering, compositing, and visualization applied before download.
- **Query point values** at arbitrary coordinates without downloading an
  entire scene.
- **Query vector features** from tables such as administrative boundaries,
  protected areas, and census geographies.
- **Compute statistics** by reducing images over regions -- mean elevation
  across a watershed, total forest area in a country, or median reflectance
  over a growing season.
- **Build complex pipelines** that chain filtering, band math, masking,
  compositing, and reduction -- all evaluated server-side.

### Why Access GEE from Mathematica?

Mathematica already has strong geospatial capabilities: `GeoGraphics`,
`GeoImage`, `GeoElevationData`, `TimeSeries`, advanced image processing,
and a rich visualization system. What it lacks is direct access to GEE's
petabyte catalog and its server-side processing.

The GoogleEarthEngineClient paclet bridges this gap. You get the best of both
worlds:

- **GEE's catalog and compute** -- 80+ petabytes of analysis-ready data,
  server-side filtering and compositing, no need to download raw scenes.
- **Wolfram Language's analysis toolkit** -- symbolic computation, built-in
  machine learning, publication-quality graphics, notebook-based workflows.

A typical workflow looks like this: use GEE expression builders to define a
cloud-filtered, spectrally indexed satellite composite; retrieve the result
as an `Image`; then analyze, classify, or visualize it with Wolfram Language
functions. The heavy lifting happens on Google's infrastructure; the creative
analysis happens in your notebook.

---

## 1.2 The GoogleEarthEngineClient Paclet

The paclet provides approximately 95 public functions organized into eight
categories:

| Category              | Key Functions                                              | Count |
| --------------------- | ---------------------------------------------------------- | ----- |
| Authentication        | `GEEConnect`, `$GEEConnection`                             | 2     |
| Asset Metadata        | `GEEGetAssetInfo`, `GEEListAssets`                         | 2     |
| Image Retrieval       | `GEEComputePixels`, `GEEImage`, `GEEGetTile`              | 3     |
| Point Queries         | `GEEIdentify`, `GEEGetSamples`                             | 2     |
| Feature Queries       | `GEEComputeFeatures`                                       | 1     |
| Computation           | `GEECompute`                                               | 1     |
| Visualization         | `GEEGeoGraphics`                                           | 1     |
| Expression Builders   | `GEECollection`, `GEEFilterDate`, `GEEMedian`, ~70 others  | ~80   |

### Architecture

The paclet communicates with GEE through its REST API v1. The workflow has
three layers:

1. **Expression builders** (`GEECollection`, `GEEFilterDate`,
   `GEESelectBands`, `GEEMedian`, etc.) construct an Association-based
   expression tree. No network calls happen at this stage.

2. **Terminal functions** (`GEEComputePixels`, `GEEImage`, `GEEIdentify`,
   `GEECompute`, etc.) serialize the expression tree to JSON, send it to the
   GEE REST API, and return the result as a Wolfram Language object -- an
   `Image`, an `Association`, a number, or a list of features.

3. **Authentication** is handled by `GEEConnect`, which creates a JWT from
   your service account key, exchanges it for an OAuth2 access token, and
   stores the token in `$GEEConnection`. Tokens are automatically refreshed
   when they expire.

### Key Concept: Server-Side Evaluation

When you write:

```wolfram
GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[{2.2, 48.8, 2.5, 48.9}] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian
```

...no data moves. The result is a nested `Association` that describes a
computation. Only when you pass this to a terminal function like
`GEEComputePixels` or `GEEImage` does the paclet send the expression to
Google's servers for evaluation. This means you can build, inspect, and
modify pipelines freely before executing them.

---

## 1.3 Installation and Authentication

### Installing the Paclet

If the paclet is distributed as a `.paclet` file:

```wolfram
PacletInstall["GoogleEarthEngineClient-1.0.0.paclet"]
```

Once installed, load it in any notebook or script:

```wolfram
Needs["GoogleEarthEngineClient`"]
```

### Setting Up a GCP Service Account

Before you can authenticate, you need a Google Cloud Platform service account
with the Earth Engine API enabled. Here is the short version:

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a project (or select an existing one).
3. Enable the **Earth Engine API** in the API Library.
4. Go to **IAM & Admin > Service Accounts** and create a new service account.
5. Grant the service account the **Earth Engine Resource Viewer** role.
6. Create a JSON key for the service account and download it.

The downloaded file will look something like this:

```json
{
  "type": "service_account",
  "project_id": "my-gee-project",
  "private_key_id": "abc123...",
  "private_key": "-----BEGIN RSA PRIVATE KEY-----\n...",
  "client_email": "gee-reader@my-gee-project.iam.gserviceaccount.com",
  ...
}
```

Store this file securely. It is the only credential you need.

### Connecting to Earth Engine

```wolfram
conn = GEEConnect["/path/to/service-account-key.json"]
```

On success, `GEEConnect` returns a status Association and stores the full
connection state in `$GEEConnection`:

```wolfram
conn
(* <|"Project" -> "my-gee-project",
     "Status" -> "Connected",
     "Expiry" -> DateObject[...]|> *)
```

The access token has a one-hour lifetime and is automatically refreshed by
subsequent API calls. You only need to call `GEEConnect` once per session.

### Checking Connection State

```wolfram
$GEEConnection
(* <|"AccessToken" -> "ya29...",
     "Expiry" -> 1743868200,
     "Project" -> "my-gee-project",
     "KeyFile" -> "/path/to/service-account-key.json",
     "KeyData" -> <|...|>|> *)
```

You can inspect individual fields:

```wolfram
$GEEConnection["Project"]
(* "my-gee-project" *)

$GEEConnection["Expiry"]
(* 1743868200 -- Unix timestamp; use FromUnixTime to convert *)

FromUnixTime[$GEEConnection["Expiry"]]
(* DateObject[{2026, 4, 5, 15, 30, 0}, "Instant", "Gregorian", "UTC"] *)
```

### Overriding the Project

If your service account has access to multiple GCP projects, you can specify
which project to use:

```wolfram
GEEConnect["key.json", "Project" -> "my-other-project"]
```

### Common Authentication Issues

**"JWT signing failed"** -- `GEEConnect` uses `GenerateDigitalSignature` for
RS256 JWT signing, which requires Wolfram Language 14.0 or later. Upgrade if
you are running an older version.

**"Earth Engine API not enabled"** -- The Earth Engine API must be explicitly
enabled in your GCP project. Go to the API Library in the Cloud Console and
enable it.

**"Permission denied"** -- Your service account needs the
**Earth Engine Resource Viewer** IAM role. Without it, authentication
succeeds but all data requests fail.

**"File not found"** -- The key file path must be an absolute path or
relative to the current working directory. Use `FindFile` to verify:

```wolfram
FindFile["/path/to/key.json"]
```

---

## 1.4 Your First Queries

The following examples assume you have already called `GEEConnect`
successfully. Each example demonstrates a different category of the paclet's
functionality. If the `//` pipe syntax is unfamiliar, see Section 1.5 for
how expression trees work.

### Example 1: Point Query -- Elevation at a Location

The simplest thing you can do with GEE is ask "what is the value of this
dataset at this point?" `GEEIdentify` answers that question.

**Dataset:** `USGS/SRTMGL1_003` -- NASA Shuttle Radar Topography Mission,
30-meter resolution global elevation.

```wolfram
result = GEEIdentify[
  GeoPosition[{27.9881, 86.9250}],  (* Mount Everest *)
  "USGS/SRTMGL1_003"
]
```

**Expected output:**

```wolfram
<|"Position" -> GeoPosition[{27.9881, 86.925}],
  "Values" -> {8752},
  "Bands" -> {"elevation"}|>
```

The returned value is the SRTM elevation in meters at 30-meter resolution.
The SRTM value for Everest (8752 m) differs slightly from the surveyed peak
(8849 m) because the radar beam reflects off ice and snow, and the 30-meter
pixel averages the terrain around the summit.

You can extract just the elevation value:

```wolfram
result["Values"] // First
(* 8752 *)
```

**Why this matters:** Point queries are the fastest way to extract data. No
image download is needed -- GEE evaluates a single pixel server-side and
returns just the number. This makes it practical to query hundreds of
locations in a loop.

#### Comparing Elevations Across Cities

```wolfram
cities = <|
  "Mexico City" -> GeoPosition[{19.43, -99.13}],
  "Denver" -> GeoPosition[{39.74, -104.99}],
  "Nairobi" -> GeoPosition[{-1.29, 36.82}],
  "Bogota" -> GeoPosition[{4.71, -74.07}],
  "Kathmandu" -> GeoPosition[{27.70, 85.32}]
|>;

elevations = Association @ Map[
  # -> GEEIdentify[cities[#], "USGS/SRTMGL1_003"]["Values"][[1]] &,
  Keys[cities]
];

BarChart[elevations,
  ChartLabels -> Keys[elevations],
  AxesLabel -> {None, "Elevation (m)"},
  PlotLabel -> "Capital City Elevations from SRTM"]
```

**Expected output:** A bar chart with Bogota highest (~2556 m), followed by
Mexico City (~2240 m), Nairobi (~1661 m), Denver (~1609 m), and Kathmandu
(~1296 m).

---

### Example 2: Image Retrieval -- Geo-Tagged Satellite Image

`GEEImage` returns a geo-tagged `Image` object with embedded metadata about
its geographic extent, projection, and source asset. This is the
high-level image retrieval function -- it handles coordinate conversion,
padding, and auto-rescaling.

**Dataset:** `USGS/SRTMGL1_003` -- SRTM elevation (same dataset, now
visualized as an image).

```wolfram
img = GEEImage[
  GeoPosition[{36.57, -118.29}],  (* Sierra Nevada, CA *)
  "USGS/SRTMGL1_003",
  GeoRange -> Quantity[50, "Kilometers"],
  "VisParams" -> <|
    "min" -> 500, "max" -> 4400,
    "palette" -> {"#1a9850", "#91cf60", "#d9ef8b",
                  "#fee08b", "#fc8d59", "#d73027", "#FFFFFF"}
  |>
]
```

**Expected output:** A 512x512 color-mapped elevation image of the Sierra
Nevada, with greens in the valleys, yellows and oranges at mid-elevations,
reds at high elevations, and white at the peaks (Mount Whitney, 4421 m).

The image carries geo-metadata that you can access:

```wolfram
meta = Options[img, MetaInformation][[1, 2]]["GeoMetaInformation"];
meta["LonLatBox"]
(* {west, south, east, north} bounding box *)

meta["GEEAsset"]
(* "USGS/SRTMGL1_003" *)
```

#### Sentinel-2 True Color

Switching to optical satellite imagery is just a matter of changing the asset
ID and specifying the appropriate bands:

```wolfram
img = GEEImage[
  GeoPosition[{40.4168, -3.7038}],  (* Madrid, Spain *)
  "COPERNICUS/S2_SR_HARMONIZED",
  GeoRange -> Quantity[20, "Kilometers"],
  "Bands" -> {"B4", "B3", "B2"},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>
]
```

**Expected output:** A true-color satellite image of Madrid and its
surroundings. The `"Bands"` option selects the red (B4), green (B3), and
blue (B2) surface reflectance bands. The `"VisParams"` stretch the
reflectance values (typically 0-10000) to a visible range. Because
`COPERNICUS/S2_SR_HARMONIZED` is an `IMAGE_COLLECTION`, the paclet
automatically filters to the most recent cloud-free images, mosaics them,
and returns a composite.

---

### Example 3: Expression Pipeline -- Cloud-Filtered Sentinel-2 Composite

When you need full control over how a collection is filtered and composited,
use the expression builders with Wolfram Language's `//` pipe operator.

**Dataset:** `COPERNICUS/S2_SR_HARMONIZED` -- Sentinel-2 Level-2A surface
reflectance, 10-meter resolution, 5-day revisit.

**Goal:** Create a cloud-free RGB median composite of Barcelona for summer
2024.

```wolfram
bbox = {2.05, 41.30, 2.30, 41.50};

composite = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian;

img = GEEComputePixels[bbox, composite,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>,
  "ImageSize" -> {1024, 1024}]
```

**Expected output:** A crisp, cloud-free true-color image of Barcelona at
1024x1024 pixels. The Mediterranean appears dark blue, the city is a gray
patchwork, and the surrounding hills show green vegetation.

Let us break down what each step does:

| Step                   | Purpose                                                      |
| ---------------------- | ------------------------------------------------------------ |
| `GEECollection[...]`   | Load the Sentinel-2 ImageCollection (no data fetched yet)    |
| `GEEFilterDate[...]`   | Keep only images from June-August 2024                       |
| `GEEFilterBounds[...]` | Keep only images that intersect the Barcelona bounding box   |
| `GEEFilterProperty[...]` | Discard images with more than 10% cloud cover              |
| `GEESelectBands[...]`  | Select only the red, green, and blue bands                   |
| `GEEMedian`            | Compute the per-pixel median across all remaining images     |
| `GEEComputePixels[...]`| Send the expression to GEE and retrieve the rendered pixels  |

The per-pixel median is the standard approach for creating cloud-free
composites. Because clouds are bright outliers, the median naturally rejects
them without explicit cloud masking. For most applications over 3+ months of
data, this produces clean results.

---

### Example 4: Feature Query -- Protected Areas

`GEEComputeFeatures` queries vector (table) datasets. GEE hosts hundreds
of vector datasets including administrative boundaries, protected areas,
roads, and hydrological features.

**Dataset:** `WCMC/WDPA/current/polygons` -- World Database on Protected
Areas, maintained by UNEP-WCMC.

**Goal:** Find protected areas near Yellowstone National Park.

```wolfram
features = GEEComputeFeatures[
  "WCMC/WDPA/current/polygons", "",
  "GeoBounds" -> {-111.5, 44.0, -109.5, 45.5},
  "Properties" -> {"NAME", "DESIG", "REP_AREA", "STATUS_YR"},
  "MaxFeatures" -> 30
]
```

**Expected output:** A list of Associations, each representing a protected
area polygon:

```wolfram
{
  <|"Properties" -> <|
      "NAME" -> "Yellowstone",
      "DESIG" -> "National Park",
      "REP_AREA" -> 8983.2,
      "STATUS_YR" -> 1872
    |>,
    "Geometry" -> <|"type" -> "MultiPolygon", ...|>
  |>,
  <|"Properties" -> <|
      "NAME" -> "Absaroka-Beartooth",
      "DESIG" -> "Wilderness Area",
      ...
    |>, ...
  |>,
  ...
}
```

You can convert the results into a `Dataset` for analysis:

```wolfram
Dataset[
  Map[
    <|"Name" -> #["Properties"]["NAME"],
      "Designation" -> #["Properties"]["DESIG"],
      "Area (km^2)" -> Round[#["Properties"]["REP_AREA"], 0.1],
      "Year" -> #["Properties"]["STATUS_YR"]|> &,
    features
  ]
]
```

**Why this matters:** Vector queries let you combine GEE's tabular data with
Wolfram Language's data analysis. You could, for example, query all protected
areas in a country, compute their total area, and overlay them on a satellite
image.

---

### Example 5: Server-Side Computation -- Mean Elevation of a Region

`GEECompute` evaluates an arbitrary expression tree server-side and returns
the result. Combined with `GEEReduceRegion`, you can compute statistics
over arbitrary geometries without downloading any pixel data.

**Dataset:** `USGS/SRTMGL1_003` -- SRTM elevation.

**Goal:** Compute the mean elevation of the Everest region.

```wolfram
result = GEECompute[
  GEELoadImage["USGS/SRTMGL1_003"] //
    GEEReduceRegion[
      GEEGeometry[{86.8, 27.8, 87.2, 28.2}],
      "mean",
      30
    ]
]
```

**Expected output:**

```wolfram
<|"elevation" -> 4892.37|>
```

The result is an Association mapping each band name to its reduced value.
Here, the single band `"elevation"` has a mean of approximately 4892 meters
across the specified bounding box.

Let us unpack the expression:

- `GEELoadImage["USGS/SRTMGL1_003"]` creates an expression node for a
  single `IMAGE` asset.
- `GEEGeometry[{86.8, 27.8, 87.2, 28.2}]` creates a rectangle geometry
  from `{west, south, east, north}` coordinates.
- `GEEReduceRegion[geometry, "mean", 30]` reduces the image over the
  geometry using a mean reducer at 30-meter scale.
- `GEECompute[...]` sends the entire expression to GEE and returns the
  numeric result.

#### Comparing Elevation Statistics Across Mountain Ranges

You can use the same pattern to build comparative analyses:

```wolfram
ranges = <|
  "Alps" -> {6.5, 45.8, 8.5, 47.0},
  "Rockies" -> {-107.0, 38.5, -105.0, 40.0},
  "Andes" -> {-70.0, -34.0, -69.0, -32.5},
  "Himalayas" -> {86.0, 27.5, 88.0, 28.5}
|>;

stats = Association @ Map[
  Module[{img, geom, avg},
    img = GEELoadImage["USGS/SRTMGL1_003"];
    geom = GEEGeometry[ranges[#]];
    avg = GEECompute[img // GEEReduceRegion[geom, "mean", 30]];
    # -> Round[avg["elevation"]]
  ] &,
  Keys[ranges]
];

BarChart[stats,
  ChartLabels -> Keys[stats],
  AxesLabel -> {None, "Mean Elevation (m)"},
  PlotLabel -> "Mean Elevation by Mountain Range"]
```

**Expected output:** A bar chart showing the Himalayas with the highest
mean elevation, followed by the Andes, the Rockies, and the Alps.

---

## 1.5 Understanding Expression Trees

The expression builder system is central to how the paclet works. This
section explains the mechanics so you can build, inspect, and debug
pipelines confidently.

### What an Expression Builder Returns

Every expression builder function returns a plain Wolfram Language
`Association`. For example:

```wolfram
expr = GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
```

returns something like:

```wolfram
<|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.load",
    "arguments" -> <|
      "id" -> <|"constantValue" -> "COPERNICUS/S2_SR_HARMONIZED"|>
    |>
  |>
|>
```

This is not a Wolfram Language symbolic expression in the traditional sense.
It is a data structure -- an Association tree -- that mirrors the JSON
structure expected by the GEE REST API.

### How the `//` Pipe Builds Nested Trees

When you chain expression builders with `//`, each step wraps the previous
expression inside a new `Association` node:

```wolfram
expr = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-01-01", "2024-06-01"] //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian;
```

After evaluation, `expr` is a nested Association with this logical structure:

```
GEEMedian
  |
  GEESelectBands[{"B4", "B3", "B2"}]
    |
    GEEFilterDate["2024-01-01", "2024-06-01"]
      |
      GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
```

The innermost node is the collection load. Each subsequent operation wraps
it in a new `functionInvocationValue` node. The final tree, when serialized
to JSON, tells the GEE server exactly how to process the data.

### Inspecting an Expression Tree

You can look at any expression directly:

```wolfram
expr // TreeForm
```

Or examine the top-level function name:

```wolfram
expr["functionInvocationValue"]["functionName"]
(* "ImageCollection.reduce" -- because GEEMedian was the last step *)
```

For more detailed inspection:

```wolfram
expr // Dataset
```

This renders the nested Association as a browsable `Dataset`, which is
useful for verifying that your pipeline is structured correctly.

### No Data Moves Until You Call a Terminal Function

This is the most important principle to understand. Expression builders are
purely local operations that construct data structures. No HTTP request is
made, no pixels are transferred, and no computation happens on GEE's servers
until you call one of these terminal functions:

| Terminal Function       | Returns                                        |
| ----------------------- | ---------------------------------------------- |
| `GEEComputePixels`      | `Image` -- raw or visualized pixels            |
| `GEEImage`              | `Image` -- geo-tagged with metadata            |
| `GEEGetTile`            | `Image` -- 256x256 map tile                    |
| `GEEIdentify`           | `Association` -- pixel values at a point       |
| `GEEGetSamples`         | `List` of Associations -- values at N points   |
| `GEEComputeFeatures`    | `List` of Associations -- vector features      |
| `GEECompute`            | Number, String, List, or Association            |
| `GEEGeoGraphics`        | `Graphics` -- geo primitives on a GEE basemap  |

Each terminal function accepts either a plain asset ID string or a pre-built
expression Association. When you pass a string for an `IMAGE_COLLECTION`
asset, the terminal function applies sensible defaults (filter to the
requested region, recent 3 years, mosaic). When you pass an expression, you
have full control.

### Example: Same Pipeline, Different Terminal Functions

A single expression can be reused with different terminal functions:

```wolfram
(* Build the expression once *)
pipeline = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[{2.05, 41.30, 2.30, 41.50}] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian;

(* Use it for pixel retrieval *)
img = GEEComputePixels[{2.05, 41.30, 2.30, 41.50}, pipeline,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>];

(* Use it for a point query *)
val = GEEIdentify[GeoPosition[{41.39, 2.17}], pipeline];

(* Use it for a tile *)
tile = GEEGetTile[pipeline, GeoPosition[{41.39, 2.17}], 12,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>];
```

This composability is one of the paclet's strengths. Define the processing
once; consume the result in whatever form you need.

### Operator Forms and the `//` Idiom

Most expression builders support an "operator form" that makes the `//`
syntax work. For example, `GEEFilterDate` has two calling conventions:

```wolfram
(* Direct form: pass the collection explicitly *)
GEEFilterDate[collection, "2024-01-01", "2024-06-01"]

(* Operator form: returns a Function that accepts the collection *)
GEEFilterDate["2024-01-01", "2024-06-01"]
(* evaluates to Function[collection, ...] *)
```

When you write `collection // GEEFilterDate["2024-01-01", "2024-06-01"]`,
Mathematica evaluates the operator form first (producing a `Function`), then
applies it to `collection`. This is the same mechanism that powers built-in
functions like `Map`, `Select`, and `SortBy` in their operator forms.

---

## 1.6 Discovering Datasets

Before you can query a dataset, you need to know what it contains. The
paclet provides two functions for exploring the GEE data catalog.

### Asset Metadata

`GEEGetAssetInfo` returns a comprehensive Association describing any GEE
asset:

```wolfram
info = GEEGetAssetInfo["USGS/SRTMGL1_003"]
```

```wolfram
info["Type"]         (* "IMAGE" *)
info["Title"]        (* "NASA SRTM Digital Elevation 30m" *)
info["Provider"]     (* "NASA / USGS / JPL-Caltech" *)
info["Description"]  (* Plain text description, HTML stripped *)
info["Bands"]
(* {<|"Name" -> "elevation", "DataType" -> ..., "Grid" -> ...|>} *)
```

For `IMAGE_COLLECTION` assets, the band list is fetched from the first image
in the collection:

```wolfram
info = GEEGetAssetInfo["COPERNICUS/S2_SR_HARMONIZED"]
info["Type"]
(* "IMAGE_COLLECTION" *)

info["Bands"][[All, "Name"]]
(* {"B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8",
    "B8A", "B9", "B11", "B12", "AOT", "WVP", "SCL",
    "TCI_R", "TCI_G", "TCI_B", ...} *)
```

Knowing the band names is essential for selecting the right bands in your
pipelines.

### Listing Assets in a Folder

`GEEListAssets` lists the contents of a GEE folder or collection:

```wolfram
assets = GEEListAssets["COPERNICUS", "MaxResults" -> 10]
```

Each element in the returned list is an Association with the same keys as
`GEEGetAssetInfo`.

---

## 1.7 Conventions Used in This Book

The following conventions are used throughout all chapters of this cookbook.

### Bounding Boxes

Bounding boxes are specified as `{west, south, east, north}` in decimal
degrees (EPSG:4326). West and south are the minimum longitude and latitude;
east and north are the maximum.

```wolfram
(* Barcelona metropolitan area *)
bbox = {2.05, 41.30, 2.30, 41.50}
```

### Points

Point locations use `GeoPosition[{latitude, longitude}]`, following the
Wolfram Language convention (latitude first):

```wolfram
everest = GeoPosition[{27.9881, 86.9250}]
```

### Date Strings

Dates use ISO 8601 format: `"YYYY-MM-DD"`. All dates are interpreted as
UTC.

```wolfram
GEEFilterDate["2024-06-01", "2024-09-01"]
```

### Band Names

Band names vary by dataset. Common examples:

| Dataset                        | RGB Bands                 | Notes                      |
| ------------------------------ | ------------------------- | -------------------------- |
| `COPERNICUS/S2_SR_HARMONIZED`  | `{"B4", "B3", "B2"}`     | 10 m resolution            |
| `LANDSAT/LC08/C02/T1_L2`      | `{"SR_B4", "SR_B3", "SR_B2"}` | 30 m resolution       |
| `LANDSAT/LC09/C02/T1_L2`      | `{"SR_B4", "SR_B3", "SR_B2"}` | 30 m resolution       |
| `MODIS/061/MOD09GA`           | `{"sur_refl_b01", "sur_refl_b04", "sur_refl_b03"}` | 500 m |
| `USGS/SRTMGL1_003`            | `{"elevation"}`           | Single band, 30 m          |

Always use `GEEGetAssetInfo` to discover band names for unfamiliar datasets:

```wolfram
GEEGetAssetInfo["LANDSAT/LC08/C02/T1_L2"]["Bands"][[All, "Name"]]
```

### Visualization Parameters

Visualization parameters (`"VisParams"`) control how server-side rendering
maps raw pixel values to display colors:

```wolfram
<|"min" -> 0, "max" -> 3000|>
```

Common keys:

| Key         | Type              | Description                                     |
| ----------- | ----------------- | ----------------------------------------------- |
| `"min"`     | Number            | Value mapped to black (or palette start)         |
| `"max"`     | Number            | Value mapped to white (or palette end)           |
| `"palette"` | List of Strings   | Color ramp, e.g., `{"blue", "green", "red"}`    |
| `"bands"`   | List of Strings   | Band names for RGB channels                      |
| `"gamma"`   | Number            | Gamma correction factor                          |

When you omit `"VisParams"`, the paclet fetches raw pixel data and
auto-rescales using the 2nd-98th percentile, which handles most datasets
well. Providing explicit `"VisParams"` gives you precise control and is
recommended for reproducible visualizations.

### GeoGraphics Integration

`GEEGeoGraphics` renders Wolfram Language geographic primitives on top of a
GEE basemap, producing standard `Graphics` output that integrates with
`Show`, `Export`, and the rest of the graphics system:

```wolfram
GEEGeoGraphics[
  {Red, PointSize[0.02], Point[GeoPosition[{41.39, 2.17}]]},
  "COPERNICUS/S2_SR_HARMONIZED",
  GeoRange -> Quantity[10, "Kilometers"],
  "Bands" -> {"B4", "B3", "B2"},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>
]
```

### Function Naming Conventions

All paclet functions start with `GEE`. The naming follows a consistent
pattern:

| Prefix / Pattern   | Meaning                                                   |
| ------------------- | --------------------------------------------------------- |
| `GEEGet*`           | Retrieve data from GEE (metadata, tiles, samples)         |
| `GEECompute*`       | Compute something server-side (pixels, features, values)  |
| `GEEFilter*`        | Filter a collection (expression builder)                  |
| `GEEReduce*`        | Reduce/aggregate (expression builder)                     |
| `GEECollection*`    | Operations on collections (map, max, min, sum)            |
| `GEELoad*`          | Load an asset into an expression tree                     |
| `GEESelect*`        | Select bands or properties                                |

### A Note on Error Messages

When an API call fails, the paclet issues a Wolfram Language message and
returns `$Failed`. For example:

```wolfram
GEEComputePixels::apierr  (* Surfaces the actual GEE API error *)
GEEIdentify::apierr       (* Same pattern for point queries *)
```

Check the message text for the specific GEE error. Common causes include
invalid band names, excessively large requests (>48 MB uncompressed),
expired authentication, and invalid asset IDs.

---

## 1.8 Quick Reference Card

Here is a one-page summary of the most commonly used functions, organized
by workflow stage.

### Load and Connect

```wolfram
Needs["GoogleEarthEngineClient`"]
GEEConnect["/path/to/key.json"]
```

### Explore

```wolfram
GEEGetAssetInfo["USGS/SRTMGL1_003"]
GEEListAssets["COPERNICUS", "MaxResults" -> 10]
```

### Build a Pipeline

```wolfram
pipeline = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[{west, south, east, north}] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian;
```

### Retrieve Results

```wolfram
(* Pixels *)
img = GEEComputePixels[bbox, pipeline,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]

(* Geo-tagged image *)
img = GEEImage[GeoPosition[{lat, lon}], assetId,
  GeoRange -> Quantity[20, "Kilometers"]]

(* Map tile *)
tile = GEEGetTile[assetId, GeoPosition[{lat, lon}], zoomLevel,
  "VisParams" -> visParams]

(* Point value *)
val = GEEIdentify[GeoPosition[{lat, lon}], assetId]

(* Multiple points *)
vals = GEEGetSamples[{GeoPosition[...], GeoPosition[...]}, assetId]

(* Vector features *)
features = GEEComputeFeatures[tableAssetId, "",
  "GeoBounds" -> bbox, "MaxFeatures" -> 100]

(* Computed statistic *)
result = GEECompute[
  GEELoadImage[assetId] //
    GEEReduceRegion[GEEGeometry[bbox], "mean", 30]]

(* GeoGraphics overlay *)
GEEGeoGraphics[primitives, assetId, opts]
```

---

## 1.9 What Comes Next

With authentication working and a basic understanding of the paclet's
architecture, you are ready to tackle real analysis workflows. The remaining
chapters of this cookbook build on the foundations laid here:

- **Chapter 2: Satellite Imagery Fundamentals** -- Landsat, Sentinel-2,
  MODIS, and NAIP workflows; band combinations; cloud masking with SCL;
  temporal compositing; and visualization techniques.

- **Chapter 3: Climate and Weather Analysis** -- surface temperature,
  precipitation, evapotranspiration, atmospheric data, solar radiation,
  and multi-variable climate dashboards using ERA5, CHIRPS, and MODIS.

- **Chapter 4: Terrain and Geophysical Analysis** -- DEMs, slope, aspect,
  hillshade, land cover classification, soil properties, texture analysis,
  and 3D visualization with SRTM and ALOS data.

- **Chapter 5: Vegetation, Agriculture & Precision Farming** -- NDVI, EVI,
  LAI, crop phenology, yield estimation, variable rate application maps,
  and ground sensor integration.

- **Chapter 6: Water Resources and Hydrology** -- water body detection,
  reservoir monitoring, flood mapping with SAR, snow and ice, precipitation
  analysis, water quality, and watershed-scale budgets.

- **Chapter 7: Urban and Population Analysis** -- nighttime lights,
  urban heat islands, impervious surfaces, change detection, population
  density, air quality, and multi-city comparative dashboards.

- **Chapter 8: Advanced Techniques and Wolfram Language Integration** --
  machine learning classification, time series analysis, image processing
  pipelines, geographic visualization, data import/export, and parallel
  batch processing.

- **Chapter 9: Appendices** -- function quick reference, dataset catalog,
  common pipeline patterns, Wolfram Language integration cheat sheet,
  troubleshooting guide, and glossary.

Each chapter follows the same pattern: explain the scientific context, show
the GEE dataset, build the pipeline step by step, and analyze the result
with Wolfram Language tools. The code is designed to be copied, adapted, and
extended for your own research.

---

*Next: [Chapter 2: Satellite Imagery Fundamentals](chapter-02-satellite-imagery.md)*
