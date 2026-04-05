# Google Earth Engine Client Cookbook
## A Practical Guide for Wolfram Language Users

---

### Table of Contents

- [Chapter 1: Introduction and Getting Started](#chapter-1-introduction-and-getting-started)
  - [1.1 What Is Google Earth Engine?](#11-what-is-google-earth-engine)
  - [1.2 The GoogleEarthEngineClient Paclet](#12-the-googleearthengineclient-paclet)
  - [1.3 Installation and Authentication](#13-installation-and-authentication)
  - [1.4 Your First Queries](#14-your-first-queries)
  - [1.5 Understanding Expression Trees](#15-understanding-expression-trees)
  - [1.6 Discovering Datasets](#16-discovering-datasets)
  - [1.7 Conventions Used in This Book](#17-conventions-used-in-this-book)
  - [1.8 Quick Reference Card](#18-quick-reference-card)
  - [1.9 What Comes Next](#19-what-comes-next)
- [Chapter 2: Satellite Imagery Fundamentals](#chapter-2-satellite-imagery-fundamentals)
  - [2.1 Understanding Satellite Data in GEE](#21-understanding-satellite-data-in-gee)
  - [2.2 Landsat Imagery](#22-landsat-imagery)
  - [2.3 Sentinel-2 Imagery](#23-sentinel-2-imagery)
  - [2.4 MODIS Imagery](#24-modis-imagery)
  - [2.5 High-Resolution and Commercial Imagery](#25-high-resolution-and-commercial-imagery)
  - [2.6 Visualization Techniques](#26-visualization-techniques)
  - [2.7 Temporal Compositing](#27-temporal-compositing)
- [Chapter 3: Climate and Weather Analysis](#chapter-3-climate-and-weather-analysis)
  - [3.1 Surface Temperature](#31-surface-temperature)
  - [3.2 Precipitation and Rainfall](#32-precipitation-and-rainfall)
  - [3.3 Atmospheric Data](#33-atmospheric-data)
  - [3.4 Evapotranspiration](#34-evapotranspiration)
  - [3.5 Multi-Year Climate Analysis](#35-multi-year-climate-analysis)
  - [3.6 Solar Radiation](#36-solar-radiation)
  - [3.7 Putting It All Together: Multi-Variable Climate Dashboard](#37-putting-it-all-together-multi-variable-climate-dashboard)
- [Chapter 4: Terrain and Geophysical Analysis](#chapter-4-terrain-and-geophysical-analysis)
  - [4.1 Digital Elevation Models](#41-digital-elevation-models)
  - [4.2 Terrain Derivatives with GEETerrain](#42-terrain-derivatives-with-geeterrain)
  - [4.3 Advanced Terrain Analysis](#43-advanced-terrain-analysis)
  - [4.4 Hydrological Terrain Analysis](#44-hydrological-terrain-analysis)
  - [4.5 Land Cover and Land Use](#45-land-cover-and-land-use)
  - [4.6 Soil Properties](#46-soil-properties)
  - [4.7 Geophysical Texture Analysis](#47-geophysical-texture-analysis)
  - [4.8 3D Visualization with Wolfram Language](#48-3d-visualization-with-wolfram-language)
- [Chapter 5: Vegetation, Agriculture & Precision Farming](#chapter-5-vegetation-agriculture--precision-farming)
  - [5.1 Vegetation Indices](#51-vegetation-indices)
  - [5.2 Crop Monitoring Workflows](#52-crop-monitoring-workflows)
  - [5.3 Crop Classification](#53-crop-classification)
  - [5.4 Soil Moisture and Water Management](#54-soil-moisture-and-water-management)
  - [5.5 Yield Estimation and Variable Rate Application](#55-yield-estimation-and-variable-rate-application)
  - [5.6 Precision Agriculture Sensor Integration](#56-precision-agriculture-sensor-integration)
- [Chapter 6: Water Resources and Hydrology](#chapter-6-water-resources-and-hydrology)
  - [6.1 Water Body Detection](#61-water-body-detection)
  - [6.2 Reservoir and Lake Monitoring](#62-reservoir-and-lake-monitoring)
  - [6.3 Flood Mapping](#63-flood-mapping)
  - [6.4 Snow and Ice](#64-snow-and-ice)
  - [6.5 Precipitation and Runoff](#65-precipitation-and-runoff)
  - [6.6 Water Quality Indicators](#66-water-quality-indicators)
  - [6.7 Wetland Mapping](#67-wetland-mapping)
  - [6.8 Watershed-Scale Analysis](#68-watershed-scale-analysis)
- [Chapter 7: Urban and Population Analysis](#chapter-7-urban-and-population-analysis)
  - [7.1 Nighttime Lights](#71-nighttime-lights)
  - [7.2 Urban Heat Island Effect](#72-urban-heat-island-effect)
  - [7.3 Built-Up Area and Impervious Surface](#73-built-up-area-and-impervious-surface)
  - [7.4 Urban Sprawl and Change Detection](#74-urban-sprawl-and-change-detection)
  - [7.5 Population and Demographics](#75-population-and-demographics)
  - [7.6 Air Quality and Pollution](#76-air-quality-and-pollution)
  - [7.7 Infrastructure and Transportation](#77-infrastructure-and-transportation)
  - [7.8 Multi-City Comparative Analysis](#78-multi-city-comparative-analysis)
- [Chapter 8: Advanced Techniques and Wolfram Language Integration](#chapter-8-advanced-techniques-and-wolfram-language-integration)
  - [8.1 Machine Learning with GEE Data](#81-machine-learning-with-gee-data)
  - [8.2 Time Series Analysis](#82-time-series-analysis)
  - [8.3 Image Processing Pipeline](#83-image-processing-pipeline)
  - [8.4 Geographic Visualization](#84-geographic-visualization)
  - [8.5 Data Import/Export and Interoperability](#85-data-importexport-and-interoperability)
  - [8.6 Physical Units and Quantities](#86-physical-units-and-quantities)
  - [8.7 Parallel and Batch Processing](#87-parallel-and-batch-processing)
  - [8.8 Reproducible Research Workflows](#88-reproducible-research-workflows)
- [Chapter 9: Appendices](#chapter-9-appendices)
  - [Appendix A: Function Quick Reference](#appendix-a-function-quick-reference)
  - [Appendix B: GEE Dataset Catalog Quick Reference](#appendix-b-gee-dataset-catalog-quick-reference)
  - [Appendix C: Common Pipeline Patterns](#appendix-c-common-pipeline-patterns)
  - [Appendix D: Wolfram Language Integration Cheat Sheet](#appendix-d-wolfram-language-integration-cheat-sheet)
  - [Appendix E: Troubleshooting](#appendix-e-troubleshooting)
  - [Appendix F: Glossary](#appendix-f-glossary)

---



---

# Chapter 1: Introduction and Getting Started

This chapter introduces Google Earth Engine, explains what the
GoogleEarthEngineClient paclet provides, walks through installation and
authentication, and demonstrates five practical queries that showcase the
breadth of the paclet. By the end, you will understand how expression trees
work, which functions trigger server-side computation, and the conventions
used throughout this book.

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

The paclet provides approximately 95 public functions organized into seven
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
(* <|"Project" -> "my-gee-project",
     "AccessToken" -> "ya29...",
     "Expiry" -> DateObject[...],
     "KeyFile" -> "/path/to/service-account-key.json"|> *)
```

You can inspect individual fields:

```wolfram
$GEEConnection["Project"]
(* "my-gee-project" *)

$GEEConnection["Expiry"]
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
functionality.

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

**Expected output:** A bar chart with Kathmandu highest (~1296 m), followed
by Bogota (~2556 m), Mexico City (~2240 m), Denver (~1609 m), and Nairobi
(~1661 m).

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


---

# Chapter 2: Satellite Imagery Fundamentals

Working with satellite imagery is the core use case of Google Earth Engine. This
chapter covers the major satellite data sources available through GEE, how to
load and filter them using GoogleEarthEngineClient expression builders, and how
to transform raw sensor data into scientifically meaningful images using both
server-side GEE operations and client-side Wolfram Language processing.

Every example in this chapter assumes you have already authenticated:

```wolfram
Needs["GoogleEarthEngineClient`"]
GEEConnect["/path/to/service-account-key.json"]
```

---

## 2.1 Understanding Satellite Data in GEE

### IMAGE vs IMAGE_COLLECTION

Google Earth Engine organizes raster data into two fundamental types:

- **IMAGE** -- A single raster layer. Examples include the SRTM digital
  elevation model (`"USGS/SRTMGL1_003"`) or a single derived product like
  global forest cover (`"UMD/hansen/global_forest_change_2023_v1_11"`). These
  are static datasets that do not change over time.

- **IMAGE_COLLECTION** -- A time series of images. Examples include Landsat
  scenes, Sentinel-2 tiles, and MODIS daily composites. Each image in the
  collection has a timestamp, spatial footprint, and metadata properties like
  cloud cover percentage.

The distinction determines which loading function you use:

```wolfram
(* Single image -- use GEELoadImage *)
srtm = GEELoadImage["USGS/SRTMGL1_003"]

(* Image collection -- use GEECollection *)
sentinel = GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
```

When you pass a plain asset ID string to `GEEComputePixels` or `GEEImage`, the
package auto-detects the type and handles it appropriately. But when you build
explicit pipelines with expression builders, you must choose the correct loader.
Using `GEECollection` on an IMAGE asset or `GEELoadImage` on an
IMAGE_COLLECTION asset will produce an error from the GEE server.

### Inspecting Assets with GEEGetAssetInfo

Before writing a pipeline, inspect the asset to understand its structure:

```wolfram
info = GEEGetAssetInfo["COPERNICUS/S2_SR_HARMONIZED"]
```

This returns an Association with keys including `"Type"`, `"Bands"`,
`"StartTime"`, `"EndTime"`, and `"Properties"`. Key things to check:

- **Type** -- Confirms whether this is `"IMAGE"` or `"IMAGE_COLLECTION"`.
- **Bands** -- Lists every band name, data type, and resolution. This tells you
  which band names to use in `GEESelectBands` and what scale factors apply.
- **StartTime / EndTime** -- The temporal range of the collection. Use these to
  set sensible date filters.

```wolfram
(* Check the bands available in Landsat 9 *)
landsatInfo = GEEGetAssetInfo["LANDSAT/LC09/C02/T1_L2"]
landsatInfo["Bands"] // Dataset
```

### Band Naming Conventions

Different sensors use different naming schemes. The table below summarizes the
most common ones you will encounter in this chapter:

| Sensor       | Blue   | Green  | Red    | NIR    | SWIR1  | SWIR2  | Thermal |
|------------- |--------|--------|--------|--------|--------|--------|---------|
| Landsat 8/9  | SR_B2  | SR_B3  | SR_B4  | SR_B5  | SR_B6  | SR_B7  | ST_B10  |
| Sentinel-2   | B2     | B3     | B4     | B8     | B11    | B12    | --      |
| MODIS (MOD09)| sur_refl_b03 | sur_refl_b04 | sur_refl_b01 | sur_refl_b02 | sur_refl_b06 | sur_refl_b07 | -- |
| NAIP         | R      | G      | B      | N      | --     | --     | --      |

Knowing these mappings is essential for constructing correct band composites.
A "true-color" composite always maps Red, Green, Blue sensor bands to the
display's R, G, B channels -- but the band *names* differ across sensors.

---

## 2.2 Landsat Imagery

The Landsat program, jointly managed by NASA and the USGS, provides the longest
continuous record of satellite Earth observation, stretching back to 1972.
Landsat 8 (launched 2013) and Landsat 9 (launched 2021) carry the OLI-2 and
TIRS-2 sensors, delivering 30-meter multispectral imagery with a 16-day revisit
cycle. Together they provide 8-day effective coverage.

### Collection 2 Level-2 Surface Reflectance

The recommended datasets for scientific analysis are the Collection 2, Tier 1,
Level-2 products:

- `"LANDSAT/LC08/C02/T1_L2"` -- Landsat 8
- `"LANDSAT/LC09/C02/T1_L2"` -- Landsat 9

These contain atmospherically corrected surface reflectance (SR) and surface
temperature (ST) bands. The "T1" designation means Tier 1, the highest
geometric quality.

### Scale Factors

Raw pixel values in Landsat Collection 2 are stored as scaled integers, not
physical reflectance values. You must apply scale factors for quantitative work:

- **Surface reflectance bands** (SR_B1 through SR_B7): multiply by `0.0000275`,
  then add `-0.2`. Valid reflectance range after scaling is approximately 0 to 1.
- **Surface temperature** (ST_B10): multiply by `0.00341802`, then add `149.0`.
  Result is in Kelvin.

For visualization-only workflows (using `"VisParams"`), you can skip the scaling
and work directly with the raw DN values. For quantitative analysis (computing
indices, thresholds, statistics), always apply the scale factors.

### Example: True-Color Composite over San Francisco

A true-color composite maps the red, green, and blue spectral bands to the
corresponding display channels, producing an image that approximates what the
human eye would see.

```wolfram
(* Define the area of interest: San Francisco Bay Area *)
sfBbox = {-122.55, 37.65, -122.30, 37.85};

(* Build a cloud-filtered Landsat 9 true-color composite *)
sfTrueColor = GEECollection["LANDSAT/LC09/C02/T1_L2"] //
  GEEFilterDate["2024-04-01", "2024-10-01"] //
  GEEFilterBounds[sfBbox] //
  GEEFilterProperty["CLOUD_COVER", "LessThan", 10] //
  GEESelectBands[{"SR_B4", "SR_B3", "SR_B2"}] //
  GEEMedian;

(* Render with VisParams tuned for Landsat Collection 2 raw DN range *)
img = GEEComputePixels[sfBbox, sfTrueColor,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|"min" -> 7000, "max" -> 12000|>]
```

The `"min"` and `"max"` values in `"VisParams"` correspond to the raw DN range
for Landsat Collection 2 surface reflectance. Values around 7000-12000 typically
produce a well-balanced true-color image. Adjust these based on your scene --
bright desert scenes may need a higher max, while dark forested regions may need
a lower min.

### Example: False-Color (NIR-Red-Green) for Vegetation

False-color composites assign non-visible bands to display channels, revealing
features invisible in natural color. The classic NIR-Red-Green composite makes
vegetation appear bright red because healthy plants strongly reflect
near-infrared radiation.

```wolfram
(* NIR-Red-Green false color over agricultural land in Iowa *)
iowaBbox = {-93.8, 41.9, -93.4, 42.2};

iowaFalseColor = GEECollection["LANDSAT/LC09/C02/T1_L2"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[iowaBbox] //
  GEEFilterProperty["CLOUD_COVER", "LessThan", 10] //
  GEESelectBands[{"SR_B5", "SR_B4", "SR_B3"}] //
  GEEMedian;

img = GEEComputePixels[iowaBbox, iowaFalseColor,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|"min" -> 7000, "max" -> 20000|>]
```

In the resulting image, bright red areas indicate dense, healthy vegetation.
Urban areas appear gray-blue. Water appears dark. This composite is a standard
tool for agricultural monitoring and land cover classification.

### Example: Thermal Band for Urban Heat Islands

Landsat's thermal infrared band (ST_B10) measures land surface temperature,
making it ideal for studying urban heat island effects -- the phenomenon where
cities are significantly warmer than surrounding rural areas.

```wolfram
(* Phoenix, AZ -- a classic urban heat island case study *)
phoenixBbox = {-112.2, 33.3, -111.8, 33.6};

(* Build a summer thermal composite *)
thermalExpr = GEECollection["LANDSAT/LC09/C02/T1_L2"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[phoenixBbox] //
  GEEFilterProperty["CLOUD_COVER", "LessThan", 10] //
  GEESelectBands[{"ST_B10"}] //
  GEEMedian //
  GEEMultiply[0.00341802] //
  GEEAdd[149.0];

(* Visualize with a thermal palette: blue (cool) to red (hot) *)
thermalImg = GEEComputePixels[phoenixBbox, thermalExpr,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|
    "min" -> 300, "max" -> 325,
    "palette" -> {"blue", "cyan", "green", "yellow", "orange", "red"}
  |>]
```

After scaling, pixel values are in Kelvin. The range 300-325 K corresponds to
approximately 27-52 degrees Celsius, typical for a Phoenix summer. Urban
core areas (asphalt, concrete, rooftops) will appear red, while parks and
irrigated areas appear cooler.

### Post-Processing Landsat with Wolfram Language

Once you have retrieved an image, Wolfram Language's image processing functions
let you enhance and analyze it further:

```wolfram
(* Retrieve the raw image *)
rawImg = GEEComputePixels[sfBbox, sfTrueColor,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|"min" -> 7000, "max" -> 12000|>];

(* Enhance contrast and color balance *)
enhanced = rawImg //
  ImageAdjust[#, {0.1, 0.05}] & //
  Sharpen[#, 1] &;

(* Compare original and enhanced side by side *)
GraphicsRow[{
  Labeled[rawImg, "Original", Top],
  Labeled[enhanced, "Enhanced", Top]
}]
```

---

## 2.3 Sentinel-2 Imagery

The European Space Agency's Sentinel-2 mission provides the highest-resolution
freely available multispectral imagery, with 10-meter spatial resolution in the
visible and NIR bands and a 5-day revisit cycle (using both Sentinel-2A and
Sentinel-2B). This makes it the go-to sensor for detailed land surface analysis.

### Dataset and Band Structure

Use the harmonized surface reflectance collection:

```wolfram
s2 = GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
```

Sentinel-2 has 13 spectral bands at three spatial resolutions:

| Resolution | Bands                     | Use                             |
|-----------|---------------------------|---------------------------------|
| 10 m      | B2, B3, B4, B8            | Visible RGB + NIR               |
| 20 m      | B5, B6, B7, B8A, B11, B12 | Red edge, SWIR                 |
| 60 m      | B1, B9, B10               | Aerosol, water vapor, cirrus    |

The collection also includes a **Scene Classification Layer** (SCL) at 20 m,
which classifies each pixel into categories like cloud, cloud shadow, water,
vegetation, and bare soil. This band is the key to building cloud masks.

### Cloud Masking with SCL

Clouds and their shadows are the primary obstacle to optical satellite imagery.
The SCL band provides per-pixel classification that we can use to mask unwanted
pixels before compositing. A compact reusable version of this cloud-masking
pattern appears in Appendix C, Pattern 4.

The SCL values to exclude are:
- **3** -- Cloud shadow
- **8** -- Medium-probability cloud
- **9** -- High-probability cloud
- **10** -- Thin cirrus (optional, depending on your tolerance)

```wolfram
(* Define a cloud-masked Sentinel-2 pipeline for Madrid, Spain *)
madridBbox = {-3.8, 40.35, -3.6, 40.50};

(* Step 1: Build the base composite *)
composite = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-04-01", "2024-10-01"] //
  GEEFilterBounds[madridBbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 30] //
  GEESelectBands[{"B4", "B3", "B2", "SCL"}] //
  GEEMedian;

(* Step 2: Build the cloud mask from SCL *)
scl = composite // GEESelectBands[{"SCL"}];

mask = scl //
  GEENotEquals[3] //
  GEEAnd[scl // GEENotEquals[8]] //
  GEEAnd[scl // GEENotEquals[9]] //
  GEEAnd[scl // GEENotEquals[10]];

(* Step 3: Apply the mask to the RGB bands *)
clean = composite //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEUpdateMask[mask];

(* Step 4: Render *)
img = GEEComputePixels[madridBbox, clean,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

The mask is constructed by combining multiple `GEENotEquals` tests with
`GEEAnd`. Each `GEENotEquals` produces a binary (0/1) image, and `GEEAnd`
combines them so that only pixels passing ALL tests (not cloud shadow, not
medium cloud, not high cloud, not cirrus) retain a value of 1. Applying
this mask with `GEEUpdateMask` sets the rejected pixels to transparent,
so they are excluded from any subsequent compositing.

### Example: High-Resolution RGB of a Landmark

Sentinel-2's 10-meter resolution is sufficient to resolve individual city blocks,
bridges, and large buildings.

```wolfram
(* The Colosseum and surrounding Rome *)
romeBbox = {12.47, 41.88, 12.51, 41.90};

romeRgb = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-05-01", "2024-09-01"] //
  GEEFilterBounds[romeBbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 5] //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian;

img = GEEComputePixels[romeBbox, romeRgb,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

### Example: Vegetation-Focused False Color (B8-B4-B3)

Mapping NIR (B8) to red, Red (B4) to green, and Green (B3) to blue produces
the classic infrared false color composite used extensively in agriculture and
forestry.

```wolfram
(* Amazon rainforest region near Manaus, Brazil *)
amazonBbox = {-60.2, -3.2, -59.8, -2.8};

vegFalseColor = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-06-01", "2024-11-01"] //
  GEEFilterBounds[amazonBbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
  GEESelectBands[{"B8", "B4", "B3"}] //
  GEEMedian;

img = GEEComputePixels[amazonBbox, vegFalseColor,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 5000|>]
```

In this composite, dense tropical forest appears as deep red. Cleared or burned
areas appear cyan or blue-green. River water appears dark. This is the standard
way to visually distinguish between intact forest, degraded areas, and
deforested land.

### Example: SWIR Composite for Geology and Burn Scars

Short-wave infrared (SWIR) bands penetrate haze and are sensitive to soil
moisture, mineral content, and burned vegetation. The B12-B8A-B4 composite
is widely used in geological mapping and wildfire assessment.

```wolfram
(* Death Valley, CA -- rich geological features *)
deathValleyBbox = {-117.1, 36.1, -116.7, 36.5};

swirComposite = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-03-01", "2024-06-01"] //
  GEEFilterBounds[deathValleyBbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEESelectBands[{"B12", "B8A", "B4"}] //
  GEEMedian;

img = GEEComputePixels[deathValleyBbox, swirComposite,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 5000|>]
```

In this composite, different rock types and mineral deposits appear as distinct
colors. Vegetation appears green. Dry, exposed rock appears in shades of red
and brown. This is particularly useful in arid regions where vegetation does
not obscure the geology.

---

## 2.4 MODIS Imagery

The Moderate Resolution Imaging Spectroradiometer (MODIS) flies on NASA's Terra
and Aqua satellites, providing daily global coverage at 250 m to 1 km
resolution. While coarser than Landsat or Sentinel-2, MODIS is unmatched for
large-scale, high-frequency monitoring.

### Key Datasets

| Asset ID                  | Product            | Resolution | Temporal  |
|---------------------------|--------------------|-----------|-----------|
| `MODIS/061/MOD09GA`       | Daily surface reflectance | 500 m | Daily |
| `MODIS/061/MOD13A2`       | Vegetation indices (NDVI/EVI) | 1 km | 16-day |
| `MODIS/061/MOD11A1`       | Land surface temperature | 1 km | Daily |
| `MODIS/061/MCD43A4`       | BRDF-corrected reflectance | 500 m | Daily |

### Example: Global NDVI Map with MODIS

The MOD13A2 product provides pre-computed NDVI (Normalized Difference Vegetation
Index) values at 1 km resolution every 16 days. This is the standard dataset
for monitoring global vegetation health.

```wolfram
(* Continental US bounding box *)
conusBbox = {-125, 24, -66, 50};

(* 16-day NDVI composite for summer 2024 *)
modisNdvi = GEECollection["MODIS/061/MOD13A2"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[conusBbox] //
  GEESelectBands[{"NDVI"}] //
  GEEMedian;

(* MODIS NDVI is scaled by 10000, so valid range is roughly 0-9000 *)
ndviImg = GEEComputePixels[conusBbox, modisNdvi,
  "ImageSize" -> {1024, 512},
  "VisParams" -> <|
    "min" -> 0, "max" -> 9000,
    "palette" -> {"brown", "yellow", "green", "darkgreen"}
  |>]
```

The resulting map shows vegetation density across the continental US. The Great
Plains agricultural belt and eastern forests appear dark green, while the
western deserts appear brown. This type of continental-scale overview is where
MODIS excels.

### Example: Compare MODIS and Sentinel-2 for the Same Region

Understanding the trade-off between spatial resolution and temporal coverage is
fundamental. This example retrieves the same area at both MODIS (500 m) and
Sentinel-2 (10 m) resolution.

```wolfram
(* Nile Delta, Egypt -- strong agricultural signal *)
nileBbox = {31.0, 30.8, 31.6, 31.3};

(* MODIS daily reflectance *)
modisRgb = GEECollection["MODIS/061/MCD43A4"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[nileBbox] //
  GEESelectBands[{
    "Nadir_Reflectance_Band1",
    "Nadir_Reflectance_Band4",
    "Nadir_Reflectance_Band3"
  }] //
  GEEMedian;

modisImg = GEEComputePixels[nileBbox, modisRgb,
  "ImageSize" -> {512, 512},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>];

(* Sentinel-2 at 10 m *)
s2Rgb = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[nileBbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian;

s2Img = GEEComputePixels[nileBbox, s2Rgb,
  "ImageSize" -> {512, 512},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>];

(* Side-by-side comparison *)
GraphicsRow[{
  Labeled[modisImg, "MODIS (500 m)", Top],
  Labeled[s2Img, "Sentinel-2 (10 m)", Top]
}, ImageSize -> 900]
```

MODIS provides a smooth, generalized view ideal for regional trends. Sentinel-2
reveals individual field boundaries and irrigation patterns. Choose based on
whether your analysis requires spatial detail or temporal frequency.

---

## 2.5 High-Resolution and Commercial Imagery

### NAIP: 1-Meter Aerial Imagery of the US

The National Agriculture Imagery Program (NAIP) provides 1-meter resolution
aerial photography covering the contiguous United States. The imagery includes
4 bands: Red, Green, Blue, and Near-Infrared.

```wolfram
(* Central Park, New York City *)
centralParkBbox = {-73.975, 40.765, -73.955, 40.785};

naipRgb = GEECollection["USDA/NAIP/DOQQ"] //
  GEEFilterDate["2021-01-01", "2023-12-31"] //
  GEEFilterBounds[centralParkBbox] //
  GEESelectBands[{"R", "G", "B"}] //
  GEEMosaic;

img = GEEComputePixels[centralParkBbox, naipRgb,
  "ImageSize" -> {1024, 1024}]
```

At 1-meter resolution, you can distinguish individual trees, building
footprints, roads, and even parked vehicles. NAIP is updated on a roughly
2-3 year cycle, so check the available date range for your state.

### Example: NAIP 4-Band False Color

Adding the NIR band to NAIP data turns aerial photography into a powerful
vegetation analysis tool:

```wolfram
(* Agricultural fields near Salinas Valley, CA *)
salinasBbox = {-121.7, 36.6, -121.5, 36.75};

naipFalseColor = GEECollection["USDA/NAIP/DOQQ"] //
  GEEFilterDate["2020-01-01", "2023-12-31"] //
  GEEFilterBounds[salinasBbox] //
  GEESelectBands[{"N", "R", "G"}] //
  GEEMosaic;

img = GEEComputePixels[salinasBbox, naipFalseColor,
  "ImageSize" -> {1024, 1024}]
```

In this NIR-Red-Green false color, irrigated crop fields appear as vivid red,
fallow fields appear gray-brown, and greenhouses or plastic-covered areas
appear white or light blue.

### Sentinel-1 SAR: Radar Imagery Through Clouds

Synthetic Aperture Radar (SAR) operates at microwave wavelengths that penetrate
clouds, smoke, and darkness. Sentinel-1 provides C-band SAR data globally,
making it invaluable for monitoring tropical regions where persistent cloud
cover renders optical sensors useless for much of the year.

```wolfram
(* Mekong Delta, Vietnam -- frequent cloud cover region *)
mekongBbox = {105.8, 9.8, 106.4, 10.3};

(* Filter for ascending orbit, VV polarization *)
sarExpr = GEECollection["COPERNICUS/S1_GRD"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[mekongBbox] //
  GEEFilterProperty["orbitProperties_pass", "Equals", "ASCENDING"] //
  GEESelectBands[{"VV"}] //
  GEEMedian;

sarImg = GEEComputePixels[mekongBbox, sarExpr,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|"min" -> -25, "max" -> 0|>]
```

SAR backscatter values are in decibels (dB). Smooth water surfaces produce very
low backscatter (appearing dark), while rough urban surfaces produce high
backscatter (appearing bright). Flooded rice paddies alternate between low
and high backscatter as they are flooded and then grow vegetation -- this
temporal signature is the basis for SAR-based crop mapping.

### Example: Dual-Polarization SAR Composite

Using both VV and VH polarizations reveals different surface properties.
A common visualization maps VV to red, VH to green, and VV/VH to blue:

```wolfram
(* Dual-pol SAR over the Mekong Delta *)
sarDualPol = GEECollection["COPERNICUS/S1_GRD"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[mekongBbox] //
  GEEFilterProperty["orbitProperties_pass", "Equals", "ASCENDING"] //
  GEESelectBands[{"VV", "VH"}] //
  GEEMedian;

sarDualImg = GEEComputePixels[mekongBbox, sarDualPol,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|
    "bands" -> {"VV", "VH", "VV"},
    "min" -> {-25, -30, -25},
    "max" -> {0, -5, 0}
  |>]
```

In this composite, urban areas appear white (high in both polarizations), water
appears dark, and vegetated areas appear green (higher VH cross-polarization
due to volume scattering from leaves and branches).

---

## 2.6 Visualization Techniques

GoogleEarthEngineClient provides multiple ways to visualize satellite data,
from server-side rendering with custom palettes to client-side enhancement
using Wolfram Language's rich image processing toolkit.

### Server-Side Visualization with GEEVisualize

`GEEVisualize` applies visualization parameters on the GEE server before pixel
transfer. This is useful when you want to apply a color palette to a
single-band image (like NDVI or elevation) or set specific min/max stretch
values.

```wolfram
(* Apply a terrain palette to SRTM elevation *)
elevVis = GEELoadImage["USGS/SRTMGL1_003"] //
  GEEVisualize[<|
    "min" -> 0, "max" -> 4000,
    "palette" -> {"006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"}
  |>];

swissAlpsBbox = {7.5, 46.3, 8.5, 47.0};
img = GEEComputePixels[swissAlpsBbox, elevVis,
  "ImageSize" -> {1024, 768}]
```

The `"palette"` key accepts a list of hex color strings. GEE linearly
interpolates between them across the min-to-max range. This produces
a hypsometric tint: green lowlands, tan hills, brown mountains, and
white snow-covered peaks.

### Using VisParams in GEEComputePixels

You can also pass `"VisParams"` directly to `GEEComputePixels` without a
separate `GEEVisualize` step. Both approaches produce the same result --
`"VisParams"` is simply a convenience shortcut:

```wolfram
(* These two approaches are equivalent *)

(* Approach 1: GEEVisualize in the pipeline *)
expr1 = GEELoadImage["USGS/SRTMGL1_003"] //
  GEEVisualize[<|"min" -> 0, "max" -> 4000|>];
img1 = GEEComputePixels[bbox, expr1];

(* Approach 2: VisParams as option *)
expr2 = GEELoadImage["USGS/SRTMGL1_003"];
img2 = GEEComputePixels[bbox, expr2,
  "VisParams" -> <|"min" -> 0, "max" -> 4000|>];
```

Use `GEEVisualize` when you want the visualization to be part of the reusable
expression. Use `"VisParams"` when you want to experiment with different
stretches without rebuilding the pipeline.

### Wolfram Post-Processing

Once an image is on the client side, the full power of Wolfram Language image
processing is available:

```wolfram
(* Retrieve a Sentinel-2 scene *)
bbox = {12.47, 41.88, 12.51, 41.90};
raw = GEEComputePixels[bbox,
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-05-01", "2024-09-01"] //
    GEEFilterBounds[bbox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 5] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>];

(* Apply a range of enhancements *)
adjusted = ImageAdjust[raw, {0.15, 0.1}];
sharpened = Sharpen[adjusted, 2];
boosted = ColorConvert[
  ColorConvert[sharpened, "HSB"] //
    ImageApply[{#1, Min[#2 * 1.3, 1], #3} &, #] &,
  "RGB"];

GraphicsRow[{
  Labeled[raw, "Original", Top],
  Labeled[adjusted, "Adjusted", Top],
  Labeled[sharpened, "Sharpened", Top],
  Labeled[boosted, "Saturation Boost", Top]
}, ImageSize -> 1100]
```

### Overlay Geo Primitives with GEEGeoGraphics

`GEEGeoGraphics` renders Wolfram geographic primitives on top of a GEE imagery
background. This is ideal for annotating satellite images with boundaries,
points of interest, or measurement lines.

```wolfram
(* Overlay city boundary markers on a Sentinel-2 background *)
GEEGeoGraphics[
  {
    EdgeForm[{Red, Thick}], FaceForm[None],
    Polygon[{
      GeoPosition[{41.88, 12.47}],
      GeoPosition[{41.88, 12.51}],
      GeoPosition[{41.90, 12.51}],
      GeoPosition[{41.90, 12.47}]
    }],
    Red, PointSize[Large],
    Point[GeoPosition[{41.8902, 12.4922}]]
  },
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-05-01", "2024-09-01"] //
    GEEFilterBounds[{12.45, 41.87, 12.53, 41.91}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 5] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian,
  GeoRange -> {{41.87, 41.91}, {12.45, 12.53}},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>,
  ImageSize -> 800
]
```

### Using Wolfram ColorData Palettes

Wolfram Language ships with hundreds of color schemes through `ColorData`.
You can extract hex color lists from these for use in GEE palettes:

```wolfram
(* Convert a Wolfram color scheme to a GEE-compatible hex palette *)
toHexPalette[scheme_String, n_Integer: 8] :=
  Table[
    StringJoin[
      IntegerString[Round[255 #], 16, 2] & /@
        (ColorData[scheme][x] // Apply[List] // Most)
    ],
    {x, 0, 1, 1/(n - 1)}
  ]

(* Apply "TemperatureMap" to a thermal image *)
tempPalette = toHexPalette["TemperatureMap", 10];

thermalVis = GEECollection["LANDSAT/LC09/C02/T1_L2"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[phoenixBbox] //
  GEEFilterProperty["CLOUD_COVER", "LessThan", 10] //
  GEESelectBands[{"ST_B10"}] //
  GEEMedian //
  GEEMultiply[0.00341802] //
  GEEAdd[149.0] //
  GEEVisualize[<|"min" -> 300, "max" -> 325, "palette" -> tempPalette|>];

img = GEEComputePixels[phoenixBbox, thermalVis,
  "ImageSize" -> {1024, 1024}]
```

### Example: Side-by-Side True Color vs False Color

A common analysis pattern is to compare the same scene in different band
combinations to highlight features not visible in natural color:

```wolfram
bbox = {-121.7, 36.6, -121.5, 36.75};
dateRange = {"2024-05-01", "2024-09-01"};

basePipeline = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate[dateRange[[1]], dateRange[[2]]] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10];

trueColor = basePipeline //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian;

falseColor = basePipeline //
  GEESelectBands[{"B8", "B4", "B3"}] //
  GEEMedian;

opts = Sequence[
  "ImageSize" -> {512, 512},
  "VisParams" -> <|"min" -> 0, "max" -> 4000|>
];

imgTrue = GEEComputePixels[bbox, trueColor, opts];
imgFalse = GEEComputePixels[bbox, falseColor, opts];

GraphicsRow[{
  Labeled[imgTrue, "True Color (B4-B3-B2)", Top],
  Labeled[imgFalse, "False Color (B8-B4-B3)", Top]
}, ImageSize -> 900]
```

This pattern of sharing a base pipeline and branching into different band
selections is efficient -- GEE only evaluates the shared filters once on the
server side.

---

## 2.7 Temporal Compositing

Temporal compositing combines multiple satellite images from a time window into
a single cloud-free, gap-free image. This is one of the most important
techniques in remote sensing, because no single satellite pass provides a
perfect view of the ground.

### Why Compositing Matters

- **Clouds** -- Any single optical image likely has partial cloud cover. By
  combining many images, cloudy pixels in one image are replaced by clear pixels
  from another date.
- **Gaps** -- Landsat has a 16-day revisit cycle, so any given location is only
  imaged every 16 days. Compositing fills spatial gaps from the swath pattern.
- **Noise** -- Atmospheric haze, sensor artifacts, and bidirectional reflectance
  effects introduce noise in single images. Aggregating reduces these effects.
- **Seasonal variation** -- A 3-month composite captures the average conditions
  during that season, which is more representative than a single snapshot.

### Choosing an Aggregation Method

GoogleEarthEngineClient provides several aggregation functions, each suited to
different analytical goals:

| Function              | Behavior                         | Best For                         |
|-----------------------|----------------------------------|----------------------------------|
| `GEEMedian`           | Per-pixel median value           | General-purpose cloud removal    |
| `GEEMean`             | Per-pixel arithmetic mean        | Smooth, averaged representations |
| `GEEMosaic`           | Last image on top (painter's algorithm) | Quick preview, single-date look |
| `GEECollectionMax`    | Per-pixel maximum                | Peak vegetation, max temperature |
| `GEECollectionMin`    | Per-pixel minimum                | Minimum reflectance, min temp    |
| `GEECollectionSum`    | Per-pixel sum                    | Accumulated rainfall, fire counts|
| `GEEQualityMosaic`    | Best pixel by quality band       | Best-pixel based on metadata     |

**GEEMedian** is the default choice for most applications. The median is robust
to outliers (clouds that escape masking appear as extreme values and get
rejected). It produces visually clean results without the blurring that `GEEMean`
can introduce.

**GEEMean** produces smoother results but is sensitive to outliers. A single
unmasked cloud pixel pulls the mean toward white. Use only when you have
confidence in your cloud masking or when you actually want a smoothed average.

**GEEMosaic** simply stacks images and takes the last value. It does not reduce
noise or remove clouds. Its primary use is for datasets that are already
pre-composited (like NAIP tiles) or when you want the most recent image on top.

### Example: Seasonal Composites

Creating composites for each season reveals how the landscape changes through
the year. This is fundamental for agricultural monitoring, phenology studies,
and land cover classification.

```wolfram
bbox = {-89.5, 43.0, -89.0, 43.3};  (* Southern Wisconsin *)

seasonalComposite[startMonth_, endMonth_] :=
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate[
      "2024-" <> IntegerString[startMonth, 10, 2] <> "-01",
      "2024-" <> IntegerString[endMonth, 10, 2] <> "-28"
    ] //
    GEEFilterBounds[bbox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian;

seasons = {
  {"Winter", seasonalComposite[1, 3]},
  {"Spring", seasonalComposite[4, 6]},
  {"Summer", seasonalComposite[7, 9]},
  {"Autumn", seasonalComposite[10, 12]}
};

imgs = Table[
  Labeled[
    GEEComputePixels[bbox, s[[2]],
      "ImageSize" -> {512, 512},
      "VisParams" -> <|"min" -> 0, "max" -> 3000|>],
    s[[1]], Top],
  {s, seasons}
];

GraphicsGrid[Partition[imgs, 2], ImageSize -> 900]
```

The seasonal progression is dramatic in temperate latitudes. Winter composites
show bare brown fields and possibly snow. Spring shows early green-up. Summer
shows peak vegetation. Autumn shows senescence and harvest.

### Example: Annual Median for Change Detection Baseline

Change detection requires a stable baseline. An annual median composite
suppresses transient features (clouds, shadows, temporary construction) and
represents the "typical" state of the landscape for that year.

```wolfram
(* Build annual baselines for two consecutive years *)
annualComposite[year_Integer] :=
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate[ToString[year] <> "-01-01", ToString[year + 1] <> "-01-01"] //
    GEEFilterBounds[bbox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian;

bbox = {116.3, 39.8, 116.5, 40.0};  (* Beijing suburbs *)

baseline2022 = annualComposite[2022];
baseline2024 = annualComposite[2024];

img2022 = GEEComputePixels[bbox, baseline2022,
  "ImageSize" -> {512, 512},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>];

img2024 = GEEComputePixels[bbox, baseline2024,
  "ImageSize" -> {512, 512},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>];

GraphicsRow[{
  Labeled[img2022, "2022 Baseline", Top],
  Labeled[img2024, "2024 Baseline", Top]
}, ImageSize -> 900]
```

Differences between the two baselines reveal construction, deforestation,
agricultural changes, and other landscape transformations. Chapter 5 will
cover quantitative change detection methods that build on these baselines.

### GEEQualityMosaic: Best-Pixel Compositing

Sometimes the median is not the right approach. For example, when you want the
greenest pixel (highest NDVI) across the season, `GEEQualityMosaic` selects the
pixel from whichever image has the highest value in a designated quality band.

```wolfram
(* Best-NDVI composite: select the greenest observation per pixel *)
bbox = {-89.5, 43.0, -89.0, 43.3};

(* Build a collection with an NDVI quality band *)
s2WithNdvi = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
  GEECollectionMap[
    GEEAddBands[
      GEENormalizedDifference[{"B8", "B4"}] // GEERename[{"NDVI"}]
    ]
  ];

(* Select best pixel by NDVI, keep RGB bands for display *)
bestPixel = s2WithNdvi //
  GEESelectBands[{"NDVI", "B4", "B3", "B2"}] //
  GEEQualityMosaic["NDVI"] //
  GEESelectBands[{"B4", "B3", "B2"}];

img = GEEComputePixels[bbox, bestPixel,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

The `GEECollectionMap` step adds an NDVI band to every image in the collection.
`GEEQualityMosaic["NDVI"]` then selects, for each pixel, the observation where
NDVI was highest. The result is a composite showing peak vegetation conditions
everywhere -- free of clouds (which have low NDVI) and capturing the moment each
field was at maximum greenness.

### Max, Min, and Sum Composites

These specialized aggregations serve specific analytical needs:

```wolfram
bbox = {-89.5, 43.0, -89.0, 43.3};

(* Peak greenness: maximum NDVI over the growing season *)
ndviCollection = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-04-01", "2024-10-01"] //
  GEEFilterBounds[bbox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
  GEECollectionMap[
    GEESelectBands[{"B8", "B4"}] //
      GEENormalizedDifference[{"B8", "B4"}]
  ];

(* Maximum NDVI across the season *)
peakNdvi = ndviCollection // GEECollectionMax;

peakImg = GEEComputePixels[bbox, peakNdvi,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|
    "min" -> 0, "max" -> 1,
    "palette" -> {"brown", "yellow", "green", "darkgreen"}
  |>]
```

`GEECollectionMax` finds the maximum NDVI each pixel achieved at any point
during the season. Cropland that was green even briefly will show a high value.
Permanently barren areas will remain low. This is useful for distinguishing
between land that was *ever* vegetated versus land that was not.

---

## Summary

This chapter covered the core satellite imagery workflows you will use in
nearly every Google Earth Engine analysis:

| Topic | Key Functions |
|-------|--------------|
| Loading assets | `GEELoadImage`, `GEECollection`, `GEEGetAssetInfo` |
| Filtering | `GEEFilterDate`, `GEEFilterBounds`, `GEEFilterProperty` |
| Band selection | `GEESelectBands` |
| Compositing | `GEEMedian`, `GEEMean`, `GEEMosaic`, `GEEQualityMosaic` |
| Specialized composites | `GEECollectionMax`, `GEECollectionMin`, `GEECollectionSum` |
| Arithmetic | `GEEMultiply`, `GEEAdd` |
| Masking | `GEEUpdateMask`, `GEENotEquals`, `GEEAnd` |
| Rendering | `GEEComputePixels`, `GEEImage`, `GEEVisualize`, `GEEGeoGraphics` |
| Sorting/limiting | `GEESort`, `GEELimit`, `GEEFirst` |
| Post-processing | `ImageAdjust`, `Sharpen`, `ColorConvert`, `GraphicsRow` |

The pipeline pattern -- `GEECollection // Filter // Select // Aggregate` --
is the foundation of everything that follows. Chapter 3 will build on these
fundamentals to compute spectral indices (NDVI, NDWI, EVI) and perform
band math for environmental analysis.


---

# Chapter 3: Climate and Weather Analysis

Climate and weather datasets form the backbone of Earth observation science. Google
Earth Engine hosts decades of satellite-derived temperature, precipitation,
atmospheric, and radiation products at global scales. This chapter demonstrates how
to extract, process, and analyze these datasets using the GoogleEarthEngineClient
paclet alongside Wolfram Language's built-in statistical and time series tools.

Every example follows a consistent pattern: build a server-side processing pipeline
with the `//` operator, retrieve the result with `GEECompute`, `GEEIdentify`, or
`GEEComputePixels`, then analyze client-side with Wolfram Language functions such
as `TimeSeries`, `LinearModelFit`, `MovingAverage`, and `DateListPlot`.

---

## 3.1 Surface Temperature

Land surface temperature (LST) is a fundamental climate variable that governs
surface energy balance, evapotranspiration, and urban comfort. Two complementary
satellite products provide LST at different spatial and temporal resolutions.

### 3.1.1 MODIS Land Surface Temperature

The `MODIS/061/MOD11A2` product delivers 8-day composite LST at 1 km resolution.
Raw pixel values are stored as scaled integers; multiply by 0.02 to convert to
Kelvin, then subtract 273.15 to obtain degrees Celsius.

**Map daytime LST over a city to reveal the urban heat island effect:**

```wolfram
(* Build a summer LST composite for Phoenix, Arizona *)
lstExpr = GEECollection["MODIS/061/MOD11A2"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[{-112.3, 33.3, -111.8, 33.6}] //
  GEESelectBands[{"LST_Day_1km"}] //
  GEEMean //
  GEEMultiply[0.02] //
  GEEAdd[-273.15];

(* Render as a color-mapped temperature image *)
lstImage = GEEComputePixels[{-112.3, 33.3, -111.8, 33.6}, lstExpr,
  "VisParams" -> <|"min" -> 35, "max" -> 55,
    "palette" -> {"#2166ac", "#67a9cf", "#d1e5f0",
      "#fddbc7", "#ef8a62", "#b2182b"}|>,
  "ImageSize" -> {512, 512}]
(* Blue = cooler parks and irrigated areas, red = hot impervious surfaces *)
```

The scale factor pipeline (`GEEMultiply[0.02] // GEEAdd[-273.15]`) runs entirely
server-side, so you receive physically meaningful Celsius values without
downloading raw integers.

**Query LST at specific points across the urban-rural gradient:**

```wolfram
(* Define points: downtown, suburb, agricultural fringe *)
points = <|
  "Downtown Phoenix" -> GeoPosition[{33.45, -112.07}],
  "Scottsdale Suburb" -> GeoPosition[{33.50, -111.93}],
  "Rural Farmland" -> GeoPosition[{33.38, -112.25}]
|>;

lstResults = Association @ KeyValueMap[
  Function[{name, pos},
    name -> GEEIdentify[pos, lstExpr]["Values"][[1]]
  ],
  points
];

BarChart[lstResults,
  ChartLabels -> Keys[lstResults],
  AxesLabel -> {None, "LST (\[Degree]C)"},
  PlotLabel -> "Phoenix Urban Heat Island - Summer 2024",
  ChartStyle -> "TemperatureMap"]
(* Downtown typically 5-10\[Degree]C warmer than surrounding farmland *)
```

### 3.1.2 Landsat Thermal Band

Landsat 8 Collection 2 Level 2 provides surface temperature via the `ST_B10` band
at 30 m resolution -- much finer than MODIS. This enables intra-urban thermal
comparisons between parks and built-up areas. For the Landsat thermal scale
factors and band conventions, see Section 2.2. For urban heat island analysis
using these thermal products, see Section 7.2.

**Compare LST between an urban park and its surroundings:**

```wolfram
(* Cloud-filtered Landsat 8 surface temperature for Austin, TX *)
landsatLST = GEECollection["LANDSAT/LC08/C02/T1_L2"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[{-97.8, 30.2, -97.7, 30.35}] //
  GEEFilterProperty["CLOUD_COVER", "LessThan", 20] //
  GEESelectBands[{"ST_B10"}] //
  GEEMedian //
  GEEMultiply[0.00341802] //
  GEEAdd[149.0 - 273.15];

(* Sample at multiple points: Zilker Park vs. downtown *)
parkPoints = {
  GeoPosition[{30.267, -97.773}],  (* Zilker Park center *)
  GeoPosition[{30.271, -97.770}],  (* Zilker Park edge *)
  GeoPosition[{30.264, -97.776}]   (* Barton Springs *)
};
urbanPoints = {
  GeoPosition[{30.267, -97.743}],  (* Congress Avenue *)
  GeoPosition[{30.270, -97.740}],  (* East 6th Street *)
  GeoPosition[{30.265, -97.747}]   (* Rainey Street *)
};

parkTemps = Mean[
  First /@ (#["Values"] & /@ GEEGetSamples[parkPoints, landsatLST])];
urbanTemps = Mean[
  First /@ (#["Values"] & /@ GEEGetSamples[urbanPoints, landsatLST])];

Grid[{
  {"Location", "Mean LST (\[Degree]C)"},
  {"Zilker Park", Round[parkTemps, 0.1]},
  {"Downtown", Round[urbanTemps, 0.1]},
  {"Difference", Round[urbanTemps - parkTemps, 0.1]}
}, Frame -> All]
```

### 3.1.3 Satellite vs. Ground Station Validation

Comparing satellite-derived LST with ground-based air temperature helps
establish confidence in the remote sensing product. Note that LST (skin
temperature) and air temperature (measured at ~2 m height) differ physically,
so systematic offsets are expected.

```wolfram
(* Wolfram Language ground station data for Austin, July 2024 *)
groundTemp = WeatherData["Austin", "Temperature",
  {{2024, 7, 1}, {2024, 7, 31}, "Day"}];

(* GEE satellite LST at the Austin weather station location *)
stationPos = GeoPosition[{30.30, -97.70}];
satelliteLST = Table[
  Module[{dateStr, endStr, expr, result},
    dateStr = DateString[{2024, 7, d}, {"Year", "-", "Month", "-", "Day"}];
    endStr = DateString[{2024, 7, d + 1}, {"Year", "-", "Month", "-", "Day"}];
    expr = GEECollection["MODIS/061/MOD11A2"] //
      GEEFilterDate[dateStr, endStr] //
      GEESelectBands[{"LST_Day_1km"}] //
      GEEMosaic //
      GEEMultiply[0.02] //
      GEEAdd[-273.15];
    result = GEEIdentify[stationPos, expr];
    If[result["Values"][[1]] === Null,
      Missing["NoData"],
      result["Values"][[1]]
    ]
  ],
  {d, 1, 28, 8}  (* 8-day intervals matching MODIS compositing *)
];

(* Build time series for both sources *)
modDates = Table[DateObject[{2024, 7, d}], {d, 1, 28, 8}];
satelliteTS = TimeSeries[
  DeleteCases[
    Transpose[{modDates, satelliteLST}],
    {_, _Missing}
  ]
];

(* Plot both on the same axis *)
DateListPlot[{groundTemp, satelliteTS},
  PlotLegends -> {"Ground Station (Air Temp)", "MODIS LST (Skin Temp)"},
  PlotLabel -> "Austin, TX - July 2024: Ground vs. Satellite Temperature",
  AxesLabel -> {None, "Temperature (\[Degree]C)"},
  PlotStyle -> {Blue, Red},
  Joined -> {True, False},
  PlotMarkers -> {None, Automatic}]
(* LST is typically warmer than air temperature, especially on sunny days *)
```

---

## 3.2 Precipitation and Rainfall

Precipitation is the primary driver of hydrology, agriculture, and flood risk.
Two complementary products provide global coverage at different resolutions.

### 3.2.1 CHIRPS Daily Rainfall

The Climate Hazards Group InfraRed Precipitation with Station data (CHIRPS) at
`UCSB-CHG/CHIRPS/DAILY` provides daily rainfall at approximately 5 km resolution
with records extending back to 1981. This long record makes it ideal for
climatological analysis.

**Monthly rainfall accumulation:**

Summing daily images over one month gives total precipitation in millimeters.
`GEECollectionSum` performs a pixel-wise sum across the entire filtered collection.

```wolfram
(* Total rainfall for July 2024 over the Indian monsoon region *)
julyRain = GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
  GEEFilterDate["2024-07-01", "2024-08-01"] //
  GEEFilterBounds[{68.0, 8.0, 90.0, 28.0}] //
  GEESelectBands[{"precipitation"}] //
  GEECollectionSum;

(* Render the monthly accumulation map *)
GEEComputePixels[{68.0, 8.0, 90.0, 28.0}, julyRain,
  "VisParams" -> <|"min" -> 0, "max" -> 800,
    "palette" -> {"#ffffcc", "#a1dab4", "#41b6c4",
      "#2c7fb8", "#253494"}|>,
  "ImageSize" -> {600, 500}]
(* Western Ghats and northeast India show peak monsoon rainfall *)
```

**Rainfall anomaly -- compare to the long-term mean:**

A rainfall anomaly highlights whether a given month was wetter or drier than
normal. Compute the long-term July mean (e.g., 2010-2023), then subtract from
the current year.

```wolfram
(* Long-term July mean: 14 years of July data *)
longTermJuly = GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
  GEEFilterDate["2010-07-01", "2023-08-01"] //
  GEEFilterBounds[{68.0, 8.0, 90.0, 28.0}] //
  GEEFilterProperty["system:time_start", "GreaterThanOrEquals",
    AbsoluteTime[{2010, 7, 1}] * 1000] //
  GEESelectBands[{"precipitation"}] //
  GEEMean //
  GEEMultiply[31];  (* Scale daily mean to monthly total *)

(* Current year July total *)
currentJuly = GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
  GEEFilterDate["2024-07-01", "2024-08-01"] //
  GEEFilterBounds[{68.0, 8.0, 90.0, 28.0}] //
  GEESelectBands[{"precipitation"}] //
  GEECollectionSum;

(* Anomaly = current - long-term mean *)
anomaly = GEESubtract[currentJuly, longTermJuly];

GEEComputePixels[{68.0, 8.0, 90.0, 28.0}, anomaly,
  "VisParams" -> <|"min" -> -200, "max" -> 200,
    "palette" -> {"#8c510a", "#d8b365", "#f6e8c3",
      "#f5f5f5", "#c7eae5", "#5ab4ac", "#01665e"}|>,
  "ImageSize" -> {600, 500}]
(* Brown = drier than normal, teal = wetter than normal *)
```

### 3.2.2 GPM IMERG Precipitation

The Global Precipitation Measurement (GPM) IMERG product at
`NASA/GPM_L3/IMERG_V07` provides higher temporal resolution precipitation
data (half-hourly to monthly aggregates) at 0.1 degree (~10 km) resolution.

```wolfram
(* GPM monthly precipitation map for Southeast Asia *)
gpmRain = GEECollection["NASA/GPM_L3/IMERG_V07"] //
  GEEFilterDate["2024-07-01", "2024-08-01"] //
  GEEFilterBounds[{95.0, -10.0, 140.0, 20.0}] //
  GEESelectBands[{"precipitation"}] //
  GEECollectionSum;

GEEComputePixels[{95.0, -10.0, 140.0, 20.0}, gpmRain,
  "VisParams" -> <|"min" -> 0, "max" -> 600,
    "palette" -> {"#ffffcc", "#a1dab4", "#41b6c4",
      "#2c7fb8", "#253494"}|>,
  "ImageSize" -> {600, 400}]
```

### 3.2.3 Monthly Rainfall Time Series with Trend Analysis

Building a multi-month rainfall time series from GEE point queries and analyzing
it with Wolfram Language statistical tools is a powerful workflow for detecting
climate trends.

```wolfram
(* Extract monthly rainfall for Nairobi over 3 years *)
months = Flatten @ Table[
  {year, month},
  {year, 2022, 2024}, {month, 1, 12}
];

nairobiGeom = GEEGeometry[{36.7, -1.4, 36.9, -1.2}];

monthlyRain = Table[
  Module[{startDate, endDate, expr, result},
    startDate = DateString[DateObject[{yr, mo, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    endDate = DateString[DateObject[{yr, mo + 1, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    expr = GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
      GEEFilterDate[startDate, endDate] //
      GEEFilterBounds[{36.7, -1.4, 36.9, -1.2}] //
      GEESelectBands[{"precipitation"}] //
      GEECollectionSum //
      GEEReduceRegion[nairobiGeom, "mean", 5000];
    result = GEECompute[expr];
    First[Values[result]]
  ],
  {yr, mo} -> months
];

(* Build a TimeSeries object *)
dates = DateObject[{#[[1]], #[[2]], 15}] & /@ months;
rainTS = TimeSeries[monthlyRain, {dates}];

(* Plot the raw monthly values *)
DateListPlot[rainTS,
  PlotLabel -> "Nairobi Monthly Rainfall (2022-2024)",
  AxesLabel -> {None, "Rainfall (mm)"},
  Filling -> Axis,
  FillingStyle -> Directive[Opacity[0.3], Blue]]
```

**Apply smoothing and trend detection:**

```wolfram
(* 3-month moving average to highlight seasonal cycles *)
smoothed = MovingAverage[rainTS["Values"], 3];
smoothDates = rainTS["Dates"][[2 ;; -2]];
smoothTS = TimeSeries[smoothed, {smoothDates}];

(* Linear trend fit *)
numericTimes = AbsoluteTime /@ dates;
lm = LinearModelFit[
  Transpose[{numericTimes, monthlyRain}],
  x, x];

(* Combined visualization *)
Show[
  DateListPlot[rainTS,
    PlotStyle -> Directive[Opacity[0.5], Blue],
    PlotLabel -> "Nairobi Rainfall: Trend Analysis"],
  DateListPlot[smoothTS,
    PlotStyle -> Directive[Thick, Orange],
    Joined -> True],
  Plot[lm[AbsoluteTime[t]], {t, dates[[1]], dates[[-1]]},
    PlotStyle -> Directive[Thick, Dashed, Red]],
  PlotLegends -> {"Monthly", "3-Month Moving Avg", "Linear Trend"},
  AxesLabel -> {None, "Rainfall (mm)"}
]

(* Report the trend slope in mm/year *)
slopePerSecond = lm["BestFitParameters"][[2]];
slopePerYear = slopePerSecond * (365.25 * 86400);
Print["Trend: ", Round[slopePerYear, 0.1], " mm/year"]
```

---

## 3.3 Atmospheric Data

Atmospheric reanalysis products combine satellite observations with numerical
weather models to produce spatially complete, temporally consistent records
of key atmospheric variables.

### 3.3.1 ERA5-Land Reanalysis

`ECMWF/ERA5_LAND/DAILY_AGGR` provides daily aggregates of temperature,
precipitation, wind, humidity, and pressure at approximately 11 km resolution.
Its consistent methodology makes it well suited for climate trend studies.

**Extract a temperature time series for a single point over one year:**

```wolfram
(* Monthly mean temperature for Berlin, 2024 *)
berlinPos = GeoPosition[{52.52, 13.40}];

monthlyTemp = Table[
  Module[{startDate, endDate, expr, result},
    startDate = DateString[DateObject[{2024, mo, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    endDate = DateString[DateObject[{2024, mo + 1, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    expr = GEECollection["ECMWF/ERA5_LAND/DAILY_AGGR"] //
      GEEFilterDate[startDate, endDate] //
      GEESelectBands[{"temperature_2m"}] //
      GEEMean //
      GEEAdd[-273.15];  (* Kelvin to Celsius *)
    result = GEEIdentify[berlinPos, expr];
    result["Values"][[1]]
  ],
  {mo, 1, 12}
];

dates = Table[DateObject[{2024, mo, 15}], {mo, 1, 12}];
tempTS = TimeSeries[monthlyTemp, {dates}];

DateListPlot[tempTS,
  PlotLabel -> "Berlin Monthly Mean Temperature - ERA5-Land 2024",
  AxesLabel -> {None, "Temperature (\[Degree]C)"},
  Joined -> True,
  PlotMarkers -> Automatic,
  Filling -> 0,
  FillingStyle -> Directive[Opacity[0.2], Red],
  GridLines -> Automatic]
```

**Wind speed map from u and v components:**

Wind speed is not stored directly in ERA5; instead, the eastward (u10) and
northward (v10) components are provided separately. Wind speed is the magnitude
of the wind vector: sqrt(u^2 + v^2). We compute this entirely server-side
using the expression builder arithmetic.

```wolfram
(* January 2024 mean wind speed over Western Europe *)
u10 = GEECollection["ECMWF/ERA5_LAND/DAILY_AGGR"] //
  GEEFilterDate["2024-01-01", "2024-02-01"] //
  GEEFilterBounds[{-10.0, 35.0, 15.0, 60.0}] //
  GEESelectBands[{"u_component_of_wind_10m"}] //
  GEEMean;

v10 = GEECollection["ECMWF/ERA5_LAND/DAILY_AGGR"] //
  GEEFilterDate["2024-01-01", "2024-02-01"] //
  GEEFilterBounds[{-10.0, 35.0, 15.0, 60.0}] //
  GEESelectBands[{"v_component_of_wind_10m"}] //
  GEEMean;

(* Wind speed = sqrt(u^2 + v^2) *)
uSquared = u10 // GEEPow[2];
vSquared = v10 // GEEPow[2];
windSpeed = GEEAdd[uSquared, vSquared] // GEESqrt;

GEEComputePixels[{-10.0, 35.0, 15.0, 60.0}, windSpeed,
  "VisParams" -> <|"min" -> 0, "max" -> 8,
    "palette" -> {"#ffffcc", "#c7e9b4", "#7fcdbb",
      "#41b6c4", "#1d91c0", "#225ea8", "#0c2c84"}|>,
  "ImageSize" -> {500, 500}]
(* Higher values along the North Sea and Atlantic coasts *)
```

### 3.3.2 An Alternative Approach: GEEExpression for Wind Speed

When the arithmetic involves multiple bands from the same image, `GEEExpression`
can be more concise than chaining individual math operators. This approach
requires all bands in a single image, so we select both components and use
the text expression syntax.

```wolfram
windExpr = GEECollection["ECMWF/ERA5_LAND/DAILY_AGGR"] //
  GEEFilterDate["2024-01-01", "2024-02-01"] //
  GEEFilterBounds[{-10.0, 35.0, 15.0, 60.0}] //
  GEESelectBands[{"u_component_of_wind_10m", "v_component_of_wind_10m"}] //
  GEEMean //
  GEEExpression["sqrt(u * u + v * v)", <|
    "u" -> "u_component_of_wind_10m_mean",
    "v" -> "v_component_of_wind_10m_mean"|>];

GEEComputePixels[{-10.0, 35.0, 15.0, 60.0}, windExpr,
  "VisParams" -> <|"min" -> 0, "max" -> 8,
    "palette" -> {"#ffffcc", "#c7e9b4", "#7fcdbb",
      "#41b6c4", "#1d91c0", "#225ea8", "#0c2c84"}|>,
  "ImageSize" -> {500, 500}]
```

Note the `_mean` suffix on band names: `GEEMean` appends this suffix during
collection reduction (see Section 3.3.1 note on band naming).

### 3.3.3 MODIS Aerosol Optical Depth

Aerosol optical depth (AOD) measures the amount of particulate matter in
the atmosphere. High AOD values indicate pollution, dust storms, or wildfire
smoke. `MODIS/061/MOD04_L2` provides AOD at 10 km resolution.

```wolfram
(* AOD over the Indo-Gangetic Plain during winter pollution season *)
aodExpr = GEECollection["MODIS/061/MOD04_L2"] //
  GEEFilterDate["2024-11-01", "2025-01-01"] //
  GEEFilterBounds[{72.0, 22.0, 88.0, 30.0}] //
  GEESelectBands[{"Optical_Depth_Land_And_Ocean"}] //
  GEEMean;

GEEComputePixels[{72.0, 22.0, 88.0, 30.0}, aodExpr,
  "VisParams" -> <|"min" -> 0, "max" -> 1.5,
    "palette" -> {"#00ff00", "#ffff00", "#ff8800", "#ff0000", "#880000"}|>,
  "ImageSize" -> {600, 400}]
(* Red/dark red over Delhi and the Gangetic Plain indicates severe pollution *)
```

**Query AOD at specific cities for comparison:**

```wolfram
cities = <|
  "Delhi" -> GeoPosition[{28.61, 77.21}],
  "Kolkata" -> GeoPosition[{22.57, 88.36}],
  "Mumbai" -> GeoPosition[{19.08, 72.88}],
  "Bangalore" -> GeoPosition[{12.97, 77.59}]
|>;

aodValues = Association @ KeyValueMap[
  Function[{name, pos},
    name -> GEEIdentify[pos, aodExpr]["Values"][[1]]
  ],
  cities
];

BarChart[aodValues,
  ChartLabels -> Keys[aodValues],
  AxesLabel -> {None, "AOD (unitless)"},
  PlotLabel -> "Winter Aerosol Optical Depth - Nov 2024 to Jan 2025",
  ChartStyle -> "SunsetColors"]
```

---

## 3.4 Evapotranspiration

Evapotranspiration (ET) quantifies water loss from the land surface through
soil evaporation and plant transpiration. It is a critical variable for
agricultural water management, drought assessment, and hydrological modeling.
For a complete watershed-scale water budget combining precipitation and ET,
see Section 6.8.

### 3.4.1 MODIS Evapotranspiration

`MODIS/061/MOD16A2` provides 8-day ET composites at 500 m resolution. The
`ET` band stores values in units of kg/m^2/8-day (equivalent to mm/8-day);
the scale factor is 0.1.

**Map seasonal ET over an agricultural region:**

```wolfram
(* Growing season ET for the California Central Valley *)
etExpr = GEECollection["MODIS/061/MOD16A2"] //
  GEEFilterDate["2024-04-01", "2024-10-01"] //
  GEEFilterBounds[{-122.0, 35.0, -119.0, 38.5}] //
  GEESelectBands[{"ET"}] //
  GEECollectionSum //
  GEEMultiply[0.1];  (* Scale to mm *)

GEEComputePixels[{-122.0, 35.0, -119.0, 38.5}, etExpr,
  "VisParams" -> <|"min" -> 0, "max" -> 800,
    "palette" -> {"#ffffcc", "#d9f0a3", "#addd8e",
      "#78c679", "#31a354", "#006837"}|>,
  "ImageSize" -> {500, 600}]
(* High ET over irrigated farmland, low ET over the Coast Ranges *)
```

### 3.4.2 Irrigated vs. Rainfed Cropland ET Comparison

Use `GEEReduceRegion` on two different geometries to compare mean ET between
irrigated and rainfed areas. This reveals the water demand differential
driven by irrigation practices.

```wolfram
(* Define two geometries: irrigated and rainfed zones in the Central Valley *)
irrigatedGeom = GEEGeometry[{-120.8, 36.5, -120.4, 36.9}];  (* West side *)
rainfedGeom = GEEGeometry[{-119.8, 36.0, -119.4, 36.4}];    (* East foothills *)

(* Mean ET for each zone *)
irrigatedET = GEECompute[
  etExpr // GEEReduceRegion[irrigatedGeom, "mean", 500]
];
rainfedET = GEECompute[
  etExpr // GEEReduceRegion[rainfedGeom, "mean", 500]
];

Grid[{
  {"Zone", "Mean ET (mm/season)"},
  {"Irrigated", Round[First[Values[irrigatedET]], 1]},
  {"Rainfed", Round[First[Values[rainfedET]], 1]},
  {"Ratio", Round[
    First[Values[irrigatedET]] / First[Values[rainfedET]], 0.1]}
}, Frame -> All,
  Background -> {None, {LightBlue, None, None, None}}]
(* Irrigated areas typically show 2-3x higher ET than rainfed *)
```

### 3.4.3 Water Balance: Precipitation Minus Evapotranspiration

A simplified water balance model uses precipitation minus ET to estimate
net water availability. Positive values indicate surplus (potential runoff
or groundwater recharge); negative values indicate deficit (requiring
irrigation or drawing from storage).

**Server-side approach using `GEESubtract`:**

```wolfram
(* Annual precipitation from CHIRPS (sum of daily values) *)
annualPrecip = GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
  GEEFilterDate["2024-01-01", "2025-01-01"] //
  GEEFilterBounds[{-122.0, 35.0, -119.0, 38.5}] //
  GEESelectBands[{"precipitation"}] //
  GEECollectionSum;

(* Annual ET from MODIS (sum of 8-day composites, scaled) *)
annualET = GEECollection["MODIS/061/MOD16A2"] //
  GEEFilterDate["2024-01-01", "2025-01-01"] //
  GEEFilterBounds[{-122.0, 35.0, -119.0, 38.5}] //
  GEESelectBands[{"ET"}] //
  GEECollectionSum //
  GEEMultiply[0.1];

(* Water balance = P - ET *)
waterBalance = GEESubtract[annualPrecip, annualET];

GEEComputePixels[{-122.0, 35.0, -119.0, 38.5}, waterBalance,
  "VisParams" -> <|"min" -> -500, "max" -> 500,
    "palette" -> {"#8c510a", "#d8b365", "#f6e8c3",
      "#f5f5f5", "#c7eae5", "#5ab4ac", "#01665e"}|>,
  "ImageSize" -> {500, 600}]
(* Brown = water deficit (ET > P), teal = water surplus (P > ET) *)
```

**Client-side approach using `GEECompute` results:**

When you need the numeric values for further analysis in Wolfram Language,
use `GEEReduceRegion` to extract regional means, then compute the balance
client-side.

```wolfram
regionGeom = GEEGeometry[{-121.0, 36.0, -120.0, 37.0}];

precipMean = GEECompute[
  annualPrecip // GEEReduceRegion[regionGeom, "mean", 5000]
];
etMean = GEECompute[
  annualET // GEEReduceRegion[regionGeom, "mean", 500]
];

pVal = First[Values[precipMean]];
etVal = First[Values[etMean]];
balance = pVal - etVal;

Print["Precipitation: ", Round[pVal, 1], " mm/year"]
Print["Evapotranspiration: ", Round[etVal, 1], " mm/year"]
Print["Water Balance: ", Round[balance, 1], " mm/year"]
Print["Status: ", If[balance > 0, "Surplus", "Deficit"]]
```

---

## 3.5 Multi-Year Climate Analysis

Longer time horizons reveal trends, periodicities, and climate shifts that
single-year snapshots cannot capture. This section demonstrates decadal
analysis workflows that combine GEE data extraction with Wolfram Language
statistical and time series functions.

### 3.5.1 Decadal Temperature Trend

Extract annual mean land surface temperature for 10 years, fit a linear
trend, and forecast future values.

```wolfram
(* Annual mean LST for a region near Madrid, 2014-2024 *)
madridGeom = GEEGeometry[{-3.8, 40.3, -3.5, 40.5}];
years = Range[2014, 2024];

annualLST = Table[
  Module[{startDate, endDate, expr, result},
    startDate = ToString[yr] <> "-01-01";
    endDate = ToString[yr + 1] <> "-01-01";
    expr = GEECollection["MODIS/061/MOD11A2"] //
      GEEFilterDate[startDate, endDate] //
      GEEFilterBounds[{-3.8, 40.3, -3.5, 40.5}] //
      GEESelectBands[{"LST_Day_1km"}] //
      GEEMean //
      GEEMultiply[0.02] //
      GEEAdd[-273.15] //
      GEEReduceRegion[madridGeom, "mean", 1000];
    result = GEECompute[expr];
    First[Values[result]]
  ],
  {yr, years}
];

(* Build TimeSeries *)
dates = DateObject[{#, 7, 1}] & /@ years;
lstTS = TimeSeries[annualLST, {dates}];

(* Linear trend fit *)
lm = LinearModelFit[
  Transpose[{years, annualLST}],
  x, x];

(* Forecast 5 years ahead *)
futureYears = Range[2025, 2029];
forecast = lm /@ futureYears;

(* Visualization with confidence bands *)
Show[
  ListPlot[Transpose[{years, annualLST}],
    PlotStyle -> {PointSize[0.015], Blue},
    PlotLabel -> "Madrid Decadal LST Trend (2014-2024)"],
  Plot[{
      lm[x],
      lm[x] + 2 * lm["EstimatedVariance"]^0.5,
      lm[x] - 2 * lm["EstimatedVariance"]^0.5
    }, {x, 2014, 2029},
    PlotStyle -> {
      Directive[Thick, Red],
      Directive[Thin, Dashed, Red],
      Directive[Thin, Dashed, Red]},
    Filling -> {2 -> {3}}],
  ListPlot[Transpose[{futureYears, forecast}],
    PlotStyle -> {PointSize[0.012], Red, Opacity[0.5]}],
  AxesLabel -> {"Year", "Mean LST (\[Degree]C)"},
  PlotRange -> All,
  GridLines -> Automatic
]

(* Report the trend *)
slope = lm["BestFitParameters"][[2]];
Print["Warming rate: ", Round[slope, 0.01], " \[Degree]C/year"]
Print["R-squared: ", Round[lm["RSquared"], 0.001]]
```

### 3.5.2 Time Series Forecasting

Use Wolfram Language's `TimeSeriesForecast` for a model-based projection
that accounts for seasonality.

```wolfram
(* Monthly LST time series for 5 years *)
monthlyLST = Flatten @ Table[
  Module[{startDate, endDate, expr, result},
    startDate = DateString[DateObject[{yr, mo, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    endDate = DateString[DateObject[{yr, mo + 1, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    expr = GEECollection["MODIS/061/MOD11A2"] //
      GEEFilterDate[startDate, endDate] //
      GEEFilterBounds[{-3.8, 40.3, -3.5, 40.5}] //
      GEESelectBands[{"LST_Day_1km"}] //
      GEEMean //
      GEEMultiply[0.02] //
      GEEAdd[-273.15] //
      GEEReduceRegion[madridGeom, "mean", 1000];
    result = GEECompute[expr];
    First[Values[result]]
  ],
  {yr, 2020, 2024}, {mo, 1, 12}
];

monthDates = Flatten @ Table[
  DateObject[{yr, mo, 15}],
  {yr, 2020, 2024}, {mo, 1, 12}
];
lstMonthlyTS = TimeSeries[monthlyLST, {monthDates}];

(* Forecast 12 months ahead *)
forecastTS = TimeSeriesForecast[lstMonthlyTS, 12];

DateListPlot[{lstMonthlyTS, forecastTS},
  PlotLegends -> {"Observed", "Forecast"},
  PlotLabel -> "Madrid Monthly LST with 12-Month Forecast",
  AxesLabel -> {None, "LST (\[Degree]C)"},
  PlotStyle -> {Blue, Directive[Dashed, Red]}]
```

### 3.5.3 Drought Monitoring with Standardized Precipitation Index

The Standardized Precipitation Index (SPI) transforms precipitation data into
a standardized metric where negative values indicate drought. This simplified
implementation computes monthly precipitation z-scores using the long-term
mean and standard deviation.

```wolfram
(* Monthly precipitation for a drought-prone region over 10 years *)
regionGeom = GEEGeometry[{-5.5, 36.5, -4.5, 37.5}];  (* Southern Spain *)

monthlyPrecip = Flatten @ Table[
  Module[{startDate, endDate, expr, result},
    startDate = DateString[DateObject[{yr, mo, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    endDate = DateString[DateObject[{yr, mo + 1, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    expr = GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
      GEEFilterDate[startDate, endDate] //
      GEEFilterBounds[{-5.5, 36.5, -4.5, 37.5}] //
      GEESelectBands[{"precipitation"}] //
      GEECollectionSum //
      GEEReduceRegion[regionGeom, "mean", 5000];
    result = GEECompute[expr];
    First[Values[result]]
  ],
  {yr, 2015, 2024}, {mo, 1, 12}
];

(* Compute SPI-like z-scores by month *)
(* Group values by calendar month to compute monthly climatology *)
byMonth = Table[
  monthlyPrecip[[mo ;; ;; 12]],  (* Every value for this calendar month *)
  {mo, 1, 12}
];
monthMeans = Mean /@ byMonth;
monthStdDevs = StandardDeviation /@ byMonth;

spi = Table[
  Module[{mo, idx},
    idx = Mod[i - 1, 12] + 1;
    If[monthStdDevs[[idx]] == 0, 0,
      (monthlyPrecip[[i]] - monthMeans[[idx]]) / monthStdDevs[[idx]]
    ]
  ],
  {i, Length[monthlyPrecip]}
];

(* Classify drought severity *)
(* SPI categories: >= 2.0 extremely wet, 1.5-2.0 very wet, 1.0-1.5 moderately wet,
   -1.0 to 1.0 near normal, -1.0 to -1.5 moderately dry,
   -1.5 to -2.0 severely dry, <= -2.0 extremely dry *)

spiDates = Flatten @ Table[
  DateObject[{yr, mo, 15}],
  {yr, 2015, 2024}, {mo, 1, 12}
];
spiTS = TimeSeries[spi, {spiDates}];

(* Color-coded drought plot *)
DateListPlot[spiTS,
  PlotLabel -> "Standardized Precipitation Index - Southern Spain (2015-2024)",
  AxesLabel -> {None, "SPI"},
  Filling -> 0,
  ColorFunction -> Function[{x, y},
    Which[
      y < -2, Darker[Red],
      y < -1.5, Red,
      y < -1, Orange,
      y > 1.5, Darker[Blue],
      y > 1, Blue,
      True, Gray
    ]],
  ColorFunctionScaling -> False,
  PlotRange -> {All, {-3, 3}},
  GridLines -> {None, {-2, -1.5, -1, 1, 1.5, 2}},
  GridLinesStyle -> Directive[Dashed, GrayLevel[0.7]],
  Epilog -> {
    Text[Style["Extremely Dry", 8, Red], Scaled[{0.95, 0.05}], {1, 0}],
    Text[Style["Extremely Wet", 8, Blue], Scaled[{0.95, 0.95}], {1, 0}]
  }]
```

### 3.5.4 Detecting Seasonal Cycles with Fourier Analysis

Wolfram Language's `Fourier` and `Periodogram` functions reveal dominant
periodicities in climate time series. A monthly temperature series should
show a strong 12-month cycle.

```wolfram
(* Use the monthly LST time series from Section 3.5.2 *)
(* Compute the power spectrum *)
Periodogram[lstMonthlyTS["Values"],
  PlotLabel -> "LST Power Spectrum - Madrid",
  PlotRange -> All,
  ScalingFunctions -> "Log"]

(* The dominant peak near frequency 1/12 confirms the annual cycle *)
(* A secondary peak at 1/6 (semiannual) may also appear due to the
   bimodal temperature distribution in continental climates *)

(* Extract the dominant period *)
ft = Abs[Fourier[lstMonthlyTS["Values"]]]^2;
freqs = Range[0, Length[ft] - 1] / Length[ft];
peakIdx = Ordering[ft[[2 ;; Floor[Length[ft]/2]]], -1][[1]] + 1;
dominantPeriod = Length[ft] / (peakIdx - 1);
Print["Dominant period: ", Round[dominantPeriod, 0.1], " months"]
(* Expected: ~12 months *)
```

---

## 3.6 Solar Radiation

Solar radiation drives the surface energy budget and is critical for solar
energy site assessment. Combining Wolfram Language's astronomical functions
with GEE terrain data enables physically based irradiance estimation.

### 3.6.1 Solar Geometry with Wolfram Language

The built-in `SunPosition` function computes solar altitude and azimuth for
any location and time, which determines how much direct sunlight reaches
a tilted surface.

```wolfram
(* Solar position at noon on the summer solstice in Austin, TX *)
pos = GeoPosition[{30.27, -97.74}];
date = DateObject[{2024, 6, 21, 12, 0, 0}, TimeZone -> -5];

sunPos = SunPosition[pos, date];
altitude = QuantityMagnitude[sunPos[[1]], "AngularDegrees"];
azimuth = QuantityMagnitude[sunPos[[2]], "AngularDegrees"];

Print["Solar altitude: ", Round[altitude, 0.1], "\[Degree]"]
Print["Solar azimuth: ", Round[azimuth, 0.1], "\[Degree]"]

(* Daily solar trajectory *)
times = Table[
  DateObject[{2024, 6, 21, h, 0, 0}, TimeZone -> -5],
  {h, 6, 20, 0.5}
];
trajectory = Table[
  Module[{sp},
    sp = SunPosition[pos, t];
    {QuantityMagnitude[sp[[2]], "AngularDegrees"],
     QuantityMagnitude[sp[[1]], "AngularDegrees"]}
  ],
  {t, times}
];

ListLinePlot[trajectory,
  PlotLabel -> "Solar Trajectory - Austin, TX (Summer Solstice)",
  AxesLabel -> {"Azimuth (\[Degree])", "Altitude (\[Degree])"},
  PlotRange -> {{0, 360}, {0, 90}},
  AspectRatio -> 1/3,
  PlotMarkers -> Automatic]
```

### 3.6.2 Terrain-Adjusted Solar Irradiance

Slope and aspect from GEE terrain data determine how a surface is oriented
relative to incoming sunlight. South-facing slopes in the Northern Hemisphere
receive more direct radiation than north-facing slopes.

```wolfram
(* Compute terrain from SRTM DEM *)
dem = GEELoadImage["USGS/SRTMGL1_003"];
terrain = GEETerrain[dem];

(* Sample slope and aspect at a mountain location *)
mountainPos = GeoPosition[{39.75, -105.25}];  (* Rocky Mountain foothills *)
terrainVals = GEEIdentify[mountainPos, terrain];

(* GEETerrain produces bands: elevation, slope, aspect, hillshade *)
Print["Terrain at sample point:"]
MapThread[
  Print["  ", #1, ": ", #2] &,
  {terrainVals["Bands"], terrainVals["Values"]}
]
```

**Estimate clear-sky solar irradiance on a tilted surface:**

```wolfram
(* Solar constant (W/m^2) *)
solarConstant = 1361;

(* Sample terrain across a mountain transect *)
transectPoints = Table[
  GeoPosition[{39.75, lon}],
  {lon, -105.40, -105.10, 0.03}
];
terrainSamples = GEEGetSamples[transectPoints, terrain];

(* Compute solar angle at noon, summer solstice *)
solarAlt = QuantityMagnitude[
  SunPosition[GeoPosition[{39.75, -105.25}],
    DateObject[{2024, 6, 21, 12, 0, 0}, TimeZone -> -6]][[1]],
  "AngularDegrees"];
solarAz = QuantityMagnitude[
  SunPosition[GeoPosition[{39.75, -105.25}],
    DateObject[{2024, 6, 21, 12, 0, 0}, TimeZone -> -6]][[2]],
  "AngularDegrees"];

(* Compute irradiance on tilted surfaces *)
(* Bands are alphabetical: aspect, elevation, hillshade, slope *)
irradiance = Table[
  Module[{vals, aspect, slope, cosIncidence, irr},
    vals = terrainSamples[[i]]["Values"];
    (* Band order from GEETerrain: aspect, elevation, hillshade, slope *)
    aspect = vals[[1]] * Pi / 180;   (* Convert to radians *)
    slope = vals[[4]] * Pi / 180;
    (* Cosine of incidence angle between sun vector and surface normal *)
    cosIncidence = Sin[solarAlt * Pi / 180] * Cos[slope] +
      Cos[solarAlt * Pi / 180] * Sin[slope] *
      Cos[(solarAz - vals[[1]]) * Pi / 180];
    irr = solarConstant * Max[0, cosIncidence] * 0.75;  (* 0.75 atmospheric transmittance *)
    irr
  ],
  {i, Length[terrainSamples]}
];

ListLinePlot[
  Transpose[{Range[Length[irradiance]], irradiance}],
  PlotLabel -> "Estimated Solar Irradiance Along Mountain Transect",
  AxesLabel -> {"Transect Point", "Irradiance (W/m\[TwoSuperior])"},
  Filling -> Bottom,
  FillingStyle -> Directive[Opacity[0.3], Yellow],
  PlotRange -> {0, All}]
```

### 3.6.3 Hillshade Visualization

GEE's `GEETerrain` also computes hillshade (simulated shadow pattern) which
provides an intuitive view of terrain relief. Combining hillshade with
elevation creates publication-quality terrain maps.

```wolfram
(* Hillshade map of the Colorado Rockies *)
terrainImg = GEETerrain[GEELoadImage["USGS/SRTMGL1_003"]];

(* Select just the hillshade band *)
hillshade = terrainImg // GEESelectBands[{"hillshade"}];

GEEComputePixels[{-106.0, 39.0, -105.0, 40.0}, hillshade,
  "VisParams" -> <|"min" -> 0, "max" -> 255|>,
  "ImageSize" -> {512, 512}]
```

---

## 3.7 Putting It All Together: Multi-Variable Climate Dashboard

This final section demonstrates how to combine multiple climate variables
into a unified analysis. We extract temperature, precipitation, ET, and
wind data for a single region and present them as an integrated dashboard.

```wolfram
(* Define the study region: Central Spain *)
region = {-4.0, 39.5, -3.0, 40.5};
regionGeom = GEEGeometry[region];
studyPoint = GeoPosition[{40.0, -3.5}];

(* --- Temperature from ERA5 --- *)
tempData = Table[
  Module[{s, e, expr, result},
    s = DateString[DateObject[{2024, mo, 1}], {"Year", "-", "Month", "-", "Day"}];
    e = DateString[DateObject[{2024, mo + 1, 1}], {"Year", "-", "Month", "-", "Day"}];
    expr = GEECollection["ECMWF/ERA5_LAND/DAILY_AGGR"] //
      GEEFilterDate[s, e] //
      GEESelectBands[{"temperature_2m"}] //
      GEEMean //
      GEEAdd[-273.15];
    result = GEEIdentify[studyPoint, expr];
    result["Values"][[1]]
  ],
  {mo, 1, 12}
];

(* --- Precipitation from CHIRPS --- *)
precipData = Table[
  Module[{s, e, expr, result},
    s = DateString[DateObject[{2024, mo, 1}], {"Year", "-", "Month", "-", "Day"}];
    e = DateString[DateObject[{2024, mo + 1, 1}], {"Year", "-", "Month", "-", "Day"}];
    expr = GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
      GEEFilterDate[s, e] //
      GEEFilterBounds[region] //
      GEESelectBands[{"precipitation"}] //
      GEECollectionSum //
      GEEReduceRegion[regionGeom, "mean", 5000];
    result = GEECompute[expr];
    First[Values[result]]
  ],
  {mo, 1, 12}
];

(* --- Evapotranspiration from MODIS --- *)
etData = Table[
  Module[{s, e, expr, result},
    s = DateString[DateObject[{2024, mo, 1}], {"Year", "-", "Month", "-", "Day"}];
    e = DateString[DateObject[{2024, mo + 1, 1}], {"Year", "-", "Month", "-", "Day"}];
    expr = GEECollection["MODIS/061/MOD16A2"] //
      GEEFilterDate[s, e] //
      GEEFilterBounds[region] //
      GEESelectBands[{"ET"}] //
      GEECollectionSum //
      GEEMultiply[0.1] //
      GEEReduceRegion[regionGeom, "mean", 500];
    result = GEECompute[expr];
    First[Values[result]]
  ],
  {mo, 1, 12}
];

(* --- Build dashboard --- *)
months = Table[DateObject[{2024, mo, 15}], {mo, 1, 12}];

tempTS = TimeSeries[tempData, {months}];
precipTS = TimeSeries[precipData, {months}];
etTS = TimeSeries[etData, {months}];
waterBalanceTS = TimeSeries[precipData - etData, {months}];

Grid[{
  {
    DateListPlot[tempTS,
      PlotLabel -> "Temperature (\[Degree]C)",
      PlotStyle -> Red, Joined -> True, PlotMarkers -> Automatic,
      ImageSize -> 350],
    DateListPlot[precipTS,
      PlotLabel -> "Precipitation (mm)",
      Filling -> Axis, FillingStyle -> Directive[Opacity[0.3], Blue],
      ImageSize -> 350]
  },
  {
    DateListPlot[etTS,
      PlotLabel -> "Evapotranspiration (mm)",
      PlotStyle -> Darker[Green], Joined -> True, PlotMarkers -> Automatic,
      ImageSize -> 350],
    DateListPlot[waterBalanceTS,
      PlotLabel -> "Water Balance: P - ET (mm)",
      Filling -> 0,
      ColorFunction -> Function[{x, y}, If[y > 0, Blue, Red]],
      ColorFunctionScaling -> False,
      ImageSize -> 350]
  }
}, Spacings -> {1, 1},
  Frame -> All,
  Background -> White]
```

**Compute annual summary statistics:**

```wolfram
annualSummary = <|
  "Mean Temperature" ->
    Row[{Round[Mean[tempData], 0.1], " \[Degree]C"}],
  "Total Precipitation" ->
    Row[{Round[Total[precipData], 1], " mm"}],
  "Total ET" ->
    Row[{Round[Total[etData], 1], " mm"}],
  "Annual Water Balance" ->
    Row[{Round[Total[precipData] - Total[etData], 1], " mm"}],
  "Wettest Month" ->
    DateString[months[[Ordering[precipData, -1][[1]]]],
      {"MonthName"}],
  "Driest Month" ->
    DateString[months[[Ordering[precipData, 1][[1]]]],
      {"MonthName"}],
  "Hottest Month" ->
    DateString[months[[Ordering[tempData, -1][[1]]]],
      {"MonthName"}]
|>;

Dataset[annualSummary]
```

---

## Summary

1. **Scale factors matter.** Most climate products store values as scaled
   integers for compression. Always check the dataset documentation and apply
   the correct scale factor (`GEEMultiply`) and offset (`GEEAdd`) before
   interpreting values.

2. **Server-side vs. client-side processing.** Use server-side arithmetic
   (`GEEMultiply`, `GEEAdd`, `GEESubtract`, `GEEExpression`) when you need
   to produce maps or process large regions. Use client-side computation when
   you need fine-grained statistical analysis with Wolfram Language tools
   (`LinearModelFit`, `TimeSeries`, `Fourier`).

3. **The `//` pipeline is composable.** Each expression builder returns an
   expression tree that can be passed to any consumer function. Build
   reusable pipeline fragments and combine them:

   ```wolfram
   (* Reusable CHIRPS monthly sum builder *)
   chirpsMonthlySum[startDate_, endDate_, bbox_] :=
     GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
       GEEFilterDate[startDate, endDate] //
       GEEFilterBounds[bbox] //
       GEESelectBands[{"precipitation"}] //
       GEECollectionSum;
   ```

4. **`GEEReduceRegion` bridges server and client.** It computes a spatial
   statistic on the server and returns a single number, which is the natural
   interface point for Wolfram Language time series analysis.

5. **Band name suffixes.** `GEEMean` appends `_mean` and `GEEMedian` appends
   `_median` to band names. When using `GEEExpression` after an aggregation
   step, reference the suffixed names (e.g., `"temperature_2m_mean"`).

6. **Wolfram Language statistical tools complement GEE.** Functions like
   `TimeSeries`, `MovingAverage`, `LinearModelFit`, `TimeSeriesForecast`,
   `Periodogram`, and `Fourier` add analytical depth that the GEE API alone
   cannot provide.

---

## Quick Reference: Datasets Used in This Chapter

| Dataset | Asset ID | Resolution | Key Bands |
|---------|----------|------------|-----------|
| MODIS LST | `MODIS/061/MOD11A2` | 1 km, 8-day | `LST_Day_1km` (x0.02 -> K) |
| Landsat 8 LST | `LANDSAT/LC08/C02/T1_L2` | 30 m, 16-day | `ST_B10` (x0.00341802 + 149 -> K) |
| CHIRPS Rainfall | `UCSB-CHG/CHIRPS/DAILY` | 5 km, daily | `precipitation` (mm/day) |
| GPM IMERG | `NASA/GPM_L3/IMERG_V07` | 10 km, varies | `precipitation` (mm/hr) |
| ERA5-Land | `ECMWF/ERA5_LAND/DAILY_AGGR` | 11 km, daily | `temperature_2m` (K), `u/v_component_of_wind_10m` (m/s) |
| MODIS AOD | `MODIS/061/MOD04_L2` | 10 km, daily | `Optical_Depth_Land_And_Ocean` |
| MODIS ET | `MODIS/061/MOD16A2` | 500 m, 8-day | `ET` (x0.1 -> mm/8-day) |
| SRTM DEM | `USGS/SRTMGL1_003` | 30 m, static | `elevation` (m) |

## Quick Reference: Key Functions Used in This Chapter

| Function | Purpose |
|----------|---------|
| `GEECollection` | Load an ImageCollection |
| `GEEFilterDate` | Filter by date range |
| `GEEFilterBounds` | Filter by spatial extent |
| `GEESelectBands` | Select specific bands |
| `GEEMean` / `GEEMedian` | Temporal aggregation |
| `GEECollectionSum` | Pixel-wise sum across collection |
| `GEEMultiply` / `GEEAdd` / `GEESubtract` | Server-side arithmetic |
| `GEEPow` / `GEESqrt` | Server-side exponentiation |
| `GEEExpression` | Text-based math expressions |
| `GEEReduceRegion` | Spatial statistics |
| `GEEGeometry` | Define point or rectangle geometry |
| `GEECompute` | Execute expression and return value |
| `GEEIdentify` | Query pixel values at a point |
| `GEEGetSamples` | Query pixels at multiple points |
| `GEEComputePixels` | Render an image |
| `GEEVisualize` | Server-side color mapping |
| `GEETerrain` | Compute slope, aspect, hillshade |
| `GEEClip` | Clip image to geometry |


---

# Chapter 4: Terrain and Geophysical Analysis

Terrain analysis is foundational to Earth science. Whether you are mapping
landslide hazards, planning road corridors, modeling watershed hydrology, or
classifying ecosystems, the starting point is almost always a Digital Elevation
Model (DEM). This chapter shows how to retrieve, process, and visualize
elevation data and its derivatives using the GoogleEarthEngineClient paclet,
and then extends the techniques to land cover, soil properties, and geophysical
texture analysis.

Throughout this chapter we make heavy use of the `//` postfix (pipe) operator
to build composable server-side processing pipelines. Computations run on the
Google Earth Engine backend; only the final rendered pixels are transferred to
your Mathematica session.

---

## 4.1 Digital Elevation Models

A DEM assigns an elevation value to every pixel on the Earth's surface. Google
Earth Engine hosts several global DEMs at varying resolutions and vintages.
The three most commonly used are:

| Dataset | Asset ID | Resolution | Notes |
|---------|----------|-----------|-------|
| SRTM v3 | `USGS/SRTMGL1_003` | 30 m | Shuttle Radar Topography Mission (2000). Near-global coverage 60N--56S. IMAGE type. |
| ALOS World 3D | `JAXA/ALOS/AW3D30/V3_2` | 30 m | PRISM stereo photogrammetry. Better accuracy in rugged mountainous terrain. |
| Copernicus GLO-30 | `COPERNICUS/DEM/GLO30` | 30 m | Most recent (2021). Derived from TanDEM-X radar interferometry. |

SRTM is an `IMAGE` asset (a single global mosaic), so you load it with
`GEELoadImage` rather than `GEECollection`.

### 4.1.1 Retrieve SRTM Elevation for the Swiss Alps

The Swiss Alps span roughly 7.5--8.5 E longitude and 46.0--47.0 N latitude.
This bounding box captures the Bernese Oberland, including the Eiger, Monch,
and Jungfrau peaks.

```wolfram
Needs["GoogleEarthEngineClient`"]
GEEConnect["path/to/service-account-key.json"];

(* Load the global SRTM DEM *)
dem = GEELoadImage["USGS/SRTMGL1_003"];

(* Render the Swiss Alps with a terrain palette *)
swissAlps = GEEComputePixels[
  {7.5, 46.0, 8.5, 47.0},
  dem,
  "VisParams" -> <|
    "min" -> 500, "max" -> 4500,
    "palette" -> {"006400", "228B22", "FFD700", "8B4513", "FFFFFF"}
  |>,
  "ImageSize" -> 1024
]
```

The palette progresses from dark green (valley floors near 500 m) through
forest green and gold (alpine meadows) to brown (exposed rock) and white
(glaciated summits above 4000 m). This color scheme is standard in Swiss
topographic cartography.

### 4.1.2 Point Elevation Query

`GEEIdentify` returns the raw pixel value at a single geographic coordinate.
This is the fastest way to look up the elevation at a known location without
downloading an entire raster.

```wolfram
(* Elevation of Mount Everest summit *)
everest = GEEIdentify[
  GeoPosition[{27.99, 86.93}],
  "USGS/SRTMGL1_003"
]
(* Returns <|"Position" -> ..., "Values" -> <|"elevation" -> 8729|>, ...  |> *)
```

Note that SRTM reports approximately 8729 m for Everest because the radar
measured the snow/ice surface, not bare earth, and the 30 m pixel averages
the summit with lower surrounding terrain.

```wolfram
(* Compare with Wolfram's built-in GeoElevationData *)
GeoElevationData[GeoPosition[{27.99, 86.93}]]
```

The built-in `GeoElevationData` draws from a different source and may return a
slightly different value. Comparing the two is a useful sanity check.

### 4.1.3 Batch Elevation Sampling Along a Transect

Use `GEEGetSamples` to query elevations at many points in a single API call.
This is far more efficient than looping over `GEEIdentify`.

```wolfram
(* Sample a transect from Interlaken to the Jungfrau summit *)
transectPoints = Table[
  GeoPosition[{46.6844 + i * (46.5365 - 46.6844) / 50,
                7.8505 + i * (7.9614 - 7.8505) / 50}],
  {i, 0, 50}
];

samples = GEEGetSamples[transectPoints, "USGS/SRTMGL1_003"];

(* Extract elevations and plot the profile *)
elevations = Lookup["elevation"] /@ (Lookup["Values"] /@ samples);

ListLinePlot[elevations,
  AxesLabel -> {"Sample Index", "Elevation (m)"},
  PlotLabel -> "Interlaken to Jungfrau Transect",
  PlotTheme -> "Scientific",
  Filling -> Bottom
]
```

### 4.1.4 Elevation Statistics Over a Region

`GEEReduceRegion` computes a single aggregate statistic over a geographic
region entirely server-side. Combined with `GEECompute`, this lets you
calculate min, max, and mean elevation without downloading raster data.

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"];
bbox = GEEGeometry[{7.5, 46.0, 8.5, 47.0}];

(* Mean elevation *)
meanElev = GEECompute[
  dem // GEEReduceRegion[bbox, "mean", 30]
]

(* Min and max elevation *)
minElev = GEECompute[
  dem // GEEReduceRegion[bbox, "min", 30]
]

maxElev = GEECompute[
  dem // GEEReduceRegion[bbox, "max", 30]
]
```

The third argument to `GEEReduceRegion` is the scale in meters. Using 30
matches the native SRTM resolution and avoids resampling artifacts. Increase
the scale (e.g., 500) for faster computation over very large regions.

### 4.1.5 Comparing DEMs

Different DEMs have different error characteristics. ALOS performs better in
steep terrain; Copernicus is the most temporally recent.

```wolfram
(* ALOS World 3D *)
alosDEM = GEECollection["JAXA/ALOS/AW3D30/V3_2"] //
  GEESelectBands[{"DSM"}] //
  GEEMosaic;

alosImg = GEEComputePixels[
  {7.5, 46.0, 8.5, 47.0},
  alosDEM,
  "VisParams" -> <|"min" -> 500, "max" -> 4500,
    "palette" -> {"006400", "228B22", "FFD700", "8B4513", "FFFFFF"}|>,
  "ImageSize" -> 1024
]

(* Side-by-side comparison *)
GraphicsRow[{swissAlps, alosImg},
  ImageSize -> 800,
  PlotLabel -> {"SRTM", "ALOS World 3D"}
]
```

---

## 4.2 Terrain Derivatives with GEETerrain

Raw elevation is only the beginning. Slope, aspect, and hillshade are
first-order derivatives that reveal the shape of the land surface.

`GEETerrain` wraps the GEE `Algorithms.Terrain` function, computing slope
(degrees), aspect (degrees from north), and hillshade (0--255) from a DEM in
a single server-side call. The result is a multi-band image.

```wolfram
terrain = GEELoadImage["USGS/SRTMGL1_003"] // GEETerrain;
```

### 4.2.1 Hillshade Map of the Grand Canyon

Hillshade simulates illumination from a light source (default: azimuth 315,
altitude 45) and is the foundation of cartographic relief shading. For
terrain-adjusted solar irradiance calculations that build on hillshade and
aspect, see Section 3.6.2.

```wolfram
(* Grand Canyon bounding box *)
grandCanyonBBox = {-112.3, 36.0, -111.7, 36.35};

terrain = GEELoadImage["USGS/SRTMGL1_003"] // GEETerrain;
hillshade = terrain // GEESelectBands[{"hillshade"}];

hillshadeImg = GEEComputePixels[
  grandCanyonBBox,
  hillshade,
  "VisParams" -> <|"min" -> 0, "max" -> 255|>,
  "ImageSize" -> 1200
]
```

The result reveals the intricate canyon morphology -- the layered mesas,
narrow side canyons, and the meandering Colorado River corridor -- in a way
that a flat elevation color map cannot.

### 4.2.2 Slope Map with Gradient Visualization

Slope quantifies terrain steepness. Flat terrain has slope near 0 degrees;
vertical cliffs approach 90 degrees. Slope maps are essential for landslide
susceptibility, agricultural suitability, and construction planning.

```wolfram
slope = terrain // GEESelectBands[{"slope"}];

slopeImg = GEEComputePixels[
  grandCanyonBBox,
  slope,
  "VisParams" -> <|
    "min" -> 0, "max" -> 60,
    "palette" -> {"00FF00", "FFFF00", "FF8800", "FF0000"}
  |>,
  "ImageSize" -> 1200
]
```

Green pixels are flat plateaus and river terraces. Red pixels are the steep
canyon walls where slope exceeds 60 degrees.

### 4.2.3 Aspect Map Showing Cardinal Directions

Aspect is the compass direction a slope faces. North-facing slopes (aspect
near 0 or 360) receive less direct sunlight in the Northern Hemisphere
and tend to retain more moisture and snow.

```wolfram
aspect = terrain // GEESelectBands[{"aspect"}];

aspectImg = GEEComputePixels[
  grandCanyonBBox,
  aspect,
  "VisParams" -> <|
    "min" -> 0, "max" -> 360,
    "palette" -> {
      "0000FF", "00FFFF", "00FF00", "FFFF00",
      "FF0000", "FF00FF", "0000FF"
    }
  |>,
  "ImageSize" -> 1200
]
```

The circular palette wraps blue (north) through cyan (east), green (south),
yellow (west), red (northwest), and back to blue, ensuring that 0 and 360
degrees share the same color.

### 4.2.4 Combining Hillshade and Slope for Cartographic Rendering

Professional topographic maps often overlay a semi-transparent slope
classification on a hillshade base. You can achieve this in Mathematica by
compositing the two images client-side.

```wolfram
(* Retrieve both layers at the same resolution *)
hillshadeRaster = GEEComputePixels[
  grandCanyonBBox, hillshade,
  "VisParams" -> <|"min" -> 0, "max" -> 255|>,
  "ImageSize" -> 1024
];

slopeRaster = GEEComputePixels[
  grandCanyonBBox, slope,
  "VisParams" -> <|
    "min" -> 0, "max" -> 60,
    "palette" -> {"00FF00", "FFFF00", "FF0000"}
  |>,
  "ImageSize" -> 1024
];

(* Blend the two layers *)
ImageCompose[hillshadeRaster, {slopeRaster, 0.4}]
```

The 0.4 opacity on the slope layer lets the hillshade detail show through
while still conveying slope intensity via color.

---

## 4.3 Advanced Terrain Analysis

Beyond the standard terrain derivatives, the paclet provides spatial
filtering, gradient computation, and reprojection functions for more
sophisticated analysis.

### 4.3.1 Gradient Magnitude for Edge Detection

`GEEGradient` computes the x and y partial derivatives of an image. The
gradient magnitude highlights sharp elevation changes -- ridgelines, cliff
edges, and fault scarps.

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"];

(* Compute the spatial gradient *)
gradient = dem // GEEGradient;

(* Gradient magnitude = sqrt(dx^2 + dy^2) *)
(* Use GEE expression builder to compute magnitude server-side *)
gradX = gradient // GEESelectBands[{"x"}];
gradY = gradient // GEESelectBands[{"y"}];
magnitude = GEESqrt[
  GEEAdd[
    GEEMultiply[gradX, gradX],
    GEEMultiply[gradY, gradY]
  ]
];

gradImg = GEEComputePixels[
  grandCanyonBBox,
  magnitude,
  "VisParams" -> <|"min" -> 0, "max" -> 0.5,
    "palette" -> {"000000", "FFFFFF"}|>,
  "ImageSize" -> 1024
]
```

Bright pixels in the output correspond to locations where elevation changes
most rapidly -- exactly the edges of canyon walls and mesa rims.

### 4.3.2 Smoothing a DEM with Focal Filters

High-resolution DEMs can contain noise from sensor artifacts, vegetation
canopy effects, or processing errors. Focal filters smooth these artifacts.

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"];

(* Apply a 100 m radius focal mean to smooth the DEM *)
smoothDEM = dem // GEEFocalMean[100];

(* Compare original and smoothed *)
original = GEEComputePixels[
  grandCanyonBBox, dem,
  "VisParams" -> <|"min" -> 800, "max" -> 2200|>,
  "ImageSize" -> 512
];

smoothed = GEEComputePixels[
  grandCanyonBBox, smoothDEM,
  "VisParams" -> <|"min" -> 800, "max" -> 2200|>,
  "ImageSize" -> 512
];

GraphicsRow[{original, smoothed},
  ImageSize -> 800,
  PlotLabel -> {"Original SRTM", "Focal Mean (100 m)"}
]
```

`GEEFocalMedian` is often preferable to `GEEFocalMean` because the median
is robust to outliers and preserves sharp edges better.

```wolfram
(* Median filter -- better edge preservation *)
medianDEM = dem // GEEFocalMedian[100];
```

### 4.3.3 Local Relief Model (Topographic Prominence)

A local relief model (LRM) reveals fine-scale landforms that are invisible
in the raw DEM because they are overwhelmed by regional elevation trends.
The technique subtracts a smoothed surface from the original, isolating
local relief.

The formula is: `LRM = FocalMax(dem, r) - FocalMin(dem, r)`. This yields the
range of elevation within a neighborhood of radius `r`, highlighting ridges,
valleys, and other features at that scale.

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"];

(* Compute local relief within a 1000 m radius *)
localMax = dem // GEEFocalMax[1000];
localMin = dem // GEEFocalMin[1000];
localRelief = GEESubtract[localMax, localMin];

lrmImg = GEEComputePixels[
  grandCanyonBBox,
  localRelief,
  "VisParams" -> <|
    "min" -> 0, "max" -> 800,
    "palette" -> {"FFFFFF", "FFD700", "FF4500", "8B0000"}
  |>,
  "ImageSize" -> 1024
]
```

High local relief values (deep red) mark the canyon rims where the
difference between nearby maxima (plateau surface) and minima (canyon floor)
is greatest. Low values (white) indicate either flat plateaus or the flat
canyon floor itself.

### 4.3.4 Resampling and Reprojection

When combining datasets at different resolutions or projections, explicit
reprojection prevents subtle alignment errors.

```wolfram
(* Resample DEM with bilinear interpolation for smoother output *)
smoothResampled = GEELoadImage["USGS/SRTMGL1_003"] //
  GEEResample["bilinear"] //
  GEEReproject["EPSG:4326", 90];

resampledImg = GEEComputePixels[
  {7.5, 46.0, 8.5, 47.0},
  smoothResampled,
  "VisParams" -> <|"min" -> 500, "max" -> 4500,
    "palette" -> {"006400", "228B22", "FFD700", "8B4513", "FFFFFF"}|>,
  "ImageSize" -> 512
]
```

The `GEEResample["bilinear"]` call sets the interpolation method applied
when pixels are resampled during reprojection. The default is
nearest-neighbor, which is fast but produces blocky artifacts. Bilinear
interpolation produces smoother results suitable for visualization.
Use `"bicubic"` for the smoothest output at higher computational cost.

The `GEEReproject["EPSG:4326", 90]` call forces the output to WGS84
geographic coordinates at 90 m pixel spacing. Choose the scale carefully:
reprojecting a 30 m DEM to 90 m discards information, while reprojecting
to 10 m creates false precision.

---

## 4.4 Hydrological Terrain Analysis

Terrain controls where water flows. Slope, curvature, and contributing area
determine drainage patterns, flood susceptibility, and erosion potential.
While GEE does not include a full hydrological routing algorithm, you can
approximate many analyses using slope thresholds and Boolean logic.

### 4.4.1 Identifying Flat Areas (Potential Flood Zones)

Near-flat terrain (slope < 2 degrees) indicates areas where water pools
rather than draining. These areas are candidates for flood zones, wetlands,
or agricultural irrigation.

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"];
terrain = dem // GEETerrain;
slope = terrain // GEESelectBands[{"slope"}];

(* Boolean mask: 1 where slope < 2 degrees, 0 elsewhere *)
flatAreas = slope // GEELessThan[2];

flatImg = GEEComputePixels[
  {-90.5, 29.5, -89.5, 30.5},   (* Mississippi River Delta region *)
  flatAreas,
  "VisParams" -> <|
    "min" -> 0, "max" -> 1,
    "palette" -> {"FFFFFF", "0000FF"}
  |>,
  "ImageSize" -> 1024
]
```

Blue pixels in the result correspond to the flat deltaic terrain of the
Mississippi River Delta -- a region highly vulnerable to flooding.

### 4.4.2 Computing Area of Flat Terrain

How much of a region is essentially flat? Combine the Boolean mask with
`GEEPixelArea` and `GEEReduceRegion` to compute the total area server-side.

```wolfram
(* Multiply the binary mask by pixel area to get area in m^2 *)
flatAreaM2 = GEEMultiply[flatAreas, GEEPixelArea[]];

bbox = GEEGeometry[{-90.5, 29.5, -89.5, 30.5}];
totalFlatArea = GEECompute[
  flatAreaM2 // GEEReduceRegion[bbox, "sum", 30]
]

(* Convert to km^2 *)
flatAreaKm2 = totalFlatArea / 1.0*^6
```

### 4.4.3 Terrain Classification with Boolean Logic

Combining elevation and slope thresholds produces a simple terrain
classification without any machine learning.

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"];
terrain = dem // GEETerrain;
slope = terrain // GEESelectBands[{"slope"}];
elev = dem // GEESelectBands[{"elevation"}];

(* Classification rules:
   Mountain:   elevation > 2000 AND slope > 20
   Hill:       elevation > 500  AND slope > 5 AND NOT mountain
   Floodplain: elevation < 200  AND slope < 2
   Plateau:    elevation > 500  AND slope < 5       *)

mountain = GEEAnd[
  elev // GEEGreaterThan[2000],
  slope // GEEGreaterThan[20]
];

floodplain = GEEAnd[
  elev // GEELessThan[200],
  slope // GEELessThan[2]
];

(* Encode as a single classification band:
   mountain = 3, floodplain = 1, other = 0 *)
classified = GEEAdd[
  GEEMultiply[mountain, GEEConstant[3]],
  GEEMultiply[floodplain, GEEConstant[1]]
];

classImg = GEEComputePixels[
  {-100, 25, -80, 45},   (* Eastern US *)
  classified,
  "VisParams" -> <|
    "min" -> 0, "max" -> 3,
    "palette" -> {"E0E0E0", "0000FF", "00FF00", "8B4513"}
  |>,
  "ImageSize" -> 1024
]
```

This simplistic classification already captures the major physiographic
regions: the flat Mississippi floodplain (blue), the Appalachian ridges
(brown), and the coastal plain (gray).

### 4.4.4 Stream-Adjacent Terrain

Combining elevation with vector hydrological data can identify riparian zones
and flood-prone corridors.

```wolfram
(* Load DEM and compute slope *)
dem = GEELoadImage["USGS/SRTMGL1_003"];
slope = dem // GEETerrain // GEESelectBands[{"slope"}];

(* Near-flat AND low elevation -- riparian candidates *)
lowFlat = GEEAnd[
  dem // GEELessThan[500],
  slope // GEELessThan[3]
];

riparianImg = GEEComputePixels[
  {-122.5, 37.5, -121.5, 38.5},   (* Sacramento Valley *)
  lowFlat,
  "VisParams" -> <|
    "min" -> 0, "max" -> 1,
    "palette" -> {"FFFFFF", "00BFFF"}
  |>,
  "ImageSize" -> 1024
]
```

---

## 4.5 Land Cover and Land Use

Land cover classification maps the physical material on the Earth's surface
(forest, water, built-up area, cropland, etc.). These maps are derived from
satellite imagery using supervised classification algorithms and are
distributed as categorical rasters.

### 4.5.1 ESA WorldCover (10 m Resolution)

ESA WorldCover v200 is the highest-resolution freely available global land
cover dataset. It classifies every 10 m pixel into one of 11 classes.

| Value | Class | Color |
|-------|-------|-------|
| 10 | Tree cover | `006400` |
| 20 | Shrubland | `FFBB22` |
| 30 | Grassland | `FFFF4C` |
| 40 | Cropland | `F096FF` |
| 50 | Built-up | `FA0000` |
| 60 | Bare / sparse vegetation | `B4B4B4` |
| 70 | Snow and ice | `F0F0F0` |
| 80 | Permanent water bodies | `0064C8` |
| 90 | Herbaceous wetland | `0096A0` |
| 95 | Mangroves | `00CF75` |
| 100 | Moss and lichen | `FAE6A0` |

```wolfram
lc = GEELoadImage["ESA/WorldCover/v200"];

(* Land cover map of the Netherlands *)
bbox = {3.3, 50.7, 7.2, 53.6};

lcImg = GEEComputePixels[
  bbox, lc,
  "VisParams" -> <|
    "min" -> 10, "max" -> 100,
    "palette" -> {
      "006400", "FFBB22", "FFFF4C", "F096FF",
      "FA0000", "B4B4B4", "F0F0F0", "0064C8",
      "0096A0", "00CF75", "FAE6A0"
    }
  |>,
  "ImageSize" -> 1024
]
```

The Netherlands provides a striking example: intensive cropland (pink)
dominates the interior, built-up areas (red) mark the Randstad urban
agglomeration, and permanent water (blue) traces the Rhine-Meuse delta
and the IJsselmeer.

### 4.5.2 Area per Land Cover Class

A common analytical task is computing how much area each class occupies.
The approach is: (1) create a binary mask for each class, (2) multiply by
pixel area, and (3) sum with `GEEReduceRegion`.

```wolfram
lc = GEELoadImage["ESA/WorldCover/v200"];
bbox = GEEGeometry[{3.3, 50.7, 7.2, 53.6}];

(* Function to compute area for a single class value *)
classArea[classValue_Integer] := Module[{mask, areaImage},
  mask = lc // GEEEquals[classValue];
  areaImage = GEEMultiply[mask, GEEPixelArea[]];
  GEECompute[areaImage // GEEReduceRegion[bbox, "sum", 100]]
]

(* Compute area for each WorldCover class *)
classValues = {10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 100};
classNames = {"Tree cover", "Shrubland", "Grassland", "Cropland",
  "Built-up", "Bare", "Snow/Ice", "Water", "Wetland",
  "Mangroves", "Moss/Lichen"};

areas = classArea /@ classValues;

(* Convert m^2 to km^2 and plot *)
areasKm2 = areas / 1.0*^6;

BarChart[areasKm2,
  ChartLabels -> Placed[classNames, Below, Rotate[#, Pi/4] &],
  AxesLabel -> {None, "Area (km\[SuperscriptBox]2)"},
  PlotLabel -> "Netherlands Land Cover Area by Class",
  ChartStyle -> "Pastel",
  PlotTheme -> "Scientific"
]
```

### 4.5.3 Land Cover Change Detection

Comparing two time periods reveals deforestation, urbanization, or
agricultural expansion. MODIS Land Cover provides annual maps going back
to 2001.

```wolfram
(* MODIS Land Cover for 2001 and 2020 *)
lc2001 = GEECollection["MODIS/061/MCD12Q1"] //
  GEEFilterDate["2001-01-01", "2001-12-31"] //
  GEEFirst //
  GEESelectBands[{"LC_Type1"}];

lc2020 = GEECollection["MODIS/061/MCD12Q1"] //
  GEEFilterDate["2020-01-01", "2020-12-31"] //
  GEEFirst //
  GEESelectBands[{"LC_Type1"}];

(* Pixels where land cover class changed *)
changed = GEENotEquals[lc2001, lc2020];

(* Visualize change over the Amazon basin *)
amazonBBox = {-65, -15, -50, 0};

changeImg = GEEComputePixels[
  amazonBBox,
  changed,
  "VisParams" -> <|
    "min" -> 0, "max" -> 1,
    "palette" -> {"000000", "FF0000"}
  |>,
  "ImageSize" -> 1024
]
```

Red pixels mark locations where the MODIS IGBP classification changed
between 2001 and 2020. The arc of deforestation along the southern and
eastern Amazon is clearly visible.

### 4.5.4 Wolfram Integration: GeoRegionValuePlot

Wolfram Language's `GeoRegionValuePlot` creates thematic choropleth maps
from country- or region-level data. You can feed it statistics computed
from GEE.

```wolfram
(* Compute forest cover fraction for several South American countries *)
lc = GEELoadImage["ESA/WorldCover/v200"];

forestFraction[countryEntity_] := Module[
  {bbox, region, forestMask, forestArea, totalArea},
  bbox = GeoBoundingBox[countryEntity];
  region = GEEGeometry[bbox];
  forestMask = lc // GEEEquals[10];
  forestArea = GEECompute[
    GEEMultiply[forestMask, GEEPixelArea[]] //
      GEEReduceRegion[region, "sum", 500]
  ];
  totalArea = GEECompute[
    GEEPixelArea[] // GEEReduceRegion[region, "sum", 500]
  ];
  forestArea / totalArea
]

countries = {
  Entity["Country", "Brazil"],
  Entity["Country", "Colombia"],
  Entity["Country", "Peru"],
  Entity["Country", "Bolivia"],
  Entity["Country", "Venezuela"]
};

fractions = forestFraction /@ countries;

GeoRegionValuePlot[
  Thread[countries -> fractions],
  GeoRange -> "SouthAmerica",
  PlotLegends -> Automatic,
  PlotLabel -> "Forest Cover Fraction (ESA WorldCover)"
]
```

---

## 4.6 Soil Properties

Soil data is critical for agriculture, carbon accounting, and ecosystem
modeling. The OpenLandMap project provides global gridded soil property
maps derived from machine learning models trained on field observations.

### 4.6.1 Key Soil Datasets

| Property | Asset ID | Units |
|----------|----------|-------|
| Organic Carbon | `OpenLandMap/SOL/SOL_ORGANIC-CARBON_USDA-6A1C_M/v02` | g/kg |
| pH (H2O) | `OpenLandMap/SOL/SOL_PH-H2O_USDA-4C1A2A_M/v02` | pH x 10 |
| Clay Content | `OpenLandMap/SOL/SOL_CLAY-WFRACTION_USDA-3A1A1A_M/v02` | % |
| Bulk Density | `OpenLandMap/SOL/SOL_BULKDENS-FINEEARTH_USDA-4A1H_M/v02` | kg/m^3 (x10) |

Each dataset contains bands for multiple standard depths: 0 cm, 10 cm,
30 cm, 60 cm, 100 cm, and 200 cm.

### 4.6.2 Soil Organic Carbon Map

```wolfram
(* Soil organic carbon at 0 cm depth for Iowa, USA *)
soc = GEELoadImage["OpenLandMap/SOL/SOL_ORGANIC-CARBON_USDA-6A1C_M/v02"] //
  GEESelectBands[{"b0"}];   (* b0 = 0 cm depth *)

iowaBBox = {-96.7, 40.3, -90.1, 43.6};

socImg = GEEComputePixels[
  iowaBBox, soc,
  "VisParams" -> <|
    "min" -> 0, "max" -> 120,
    "palette" -> {"FFFFD4", "FED98E", "FE9929", "D95F0E", "993404"}
  |>,
  "ImageSize" -> 1024
]
```

The YlOrBr (yellow-orange-brown) palette is the conventional choice for
soil organic carbon: light yellow for mineral soils with little organic
matter, deep brown for carbon-rich prairie or wetland soils.

### 4.6.3 Multi-Depth Soil Profile

Soil properties vary with depth. Querying all depth bands and plotting
them as a vertical profile reveals the soil structure.

```wolfram
(* Query soil organic carbon at all depths for a point in central Iowa *)
soc = GEELoadImage["OpenLandMap/SOL/SOL_ORGANIC-CARBON_USDA-6A1C_M/v02"];

socValues = GEEIdentify[
  GeoPosition[{42.0, -93.5}],
  soc
];

depths = {0, 10, 30, 60, 100, 200};
bandNames = {"b0", "b10", "b30", "b60", "b100", "b200"};
carbonValues = Lookup[socValues["Values"], bandNames];

ListLinePlot[
  Transpose[{-depths, carbonValues}],
  AxesLabel -> {"Depth (cm)", "Organic Carbon (g/kg)"},
  PlotLabel -> "Soil Organic Carbon Profile, Central Iowa",
  PlotTheme -> "Scientific",
  PlotMarkers -> Automatic,
  Filling -> Axis,
  ScalingFunctions -> {"Reverse", Identity}
]
```

Typical prairie soils show high organic carbon near the surface that
decreases exponentially with depth, reflecting the zone of biological
activity and root density.

### 4.6.4 Soil pH Map

```wolfram
(* Soil pH at 0 cm depth -- note values are pH x 10 *)
ph = GEELoadImage["OpenLandMap/SOL/SOL_PH-H2O_USDA-4C1A2A_M/v02"] //
  GEESelectBands[{"b0"}] //
  GEEDivide[10];   (* Convert to actual pH *)

phImg = GEEComputePixels[
  iowaBBox, ph,
  "VisParams" -> <|
    "min" -> 4.5, "max" -> 8.5,
    "palette" -> {"FF0000", "FF8800", "FFFF00", "00FF00", "0000FF"}
  |>,
  "ImageSize" -> 1024
]
```

---

## 4.7 Geophysical Texture Analysis

Texture -- the spatial arrangement of pixel values -- carries information
that individual pixel values do not. Two regions may have the same mean
elevation but very different roughness, which affects radar backscatter,
surface runoff, and habitat suitability.

### 4.7.1 Entropy for Geological Feature Detection

`GEEEntropy` computes Shannon entropy within a neighborhood, quantifying
local pixel value diversity. High entropy indicates heterogeneous terrain;
low entropy indicates uniform surfaces.

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"];

(* Entropy with a 500 m radius neighborhood *)
entropyImg = dem // GEEEntropy[500];

(* Death Valley / Basin and Range region *)
basinRangeBBox = {-117.5, 35.5, -116.0, 37.0};

entropyVis = GEEComputePixels[
  basinRangeBBox,
  entropyImg,
  "VisParams" -> <|
    "min" -> 0, "max" -> 4,
    "palette" -> {"000033", "0066CC", "33CC33", "FFFF00", "FF3300"}
  |>,
  "ImageSize" -> 1024
]
```

In the Basin and Range province, high-entropy zones (red/yellow) correspond
to the rugged mountain ranges, while low-entropy zones (dark blue) are the
flat playas and alluvial fans.

### 4.7.2 Edge Detection with Convolution Kernels

`GEEConvolve` applies a user-defined kernel to an image server-side. A
Laplacian kernel highlights ridges, faults, and other linear features
(lineaments) that may indicate geological structures.

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"];

(* Laplacian edge-detection kernel *)
laplacianKernel = <|
  "type" -> "Kernel.fixed",
  "width" -> 3,
  "height" -> 3,
  "weights" -> {0, -1, 0, -1, 4, -1, 0, -1, 0}
|>;

edges = dem // GEEConvolve[laplacianKernel];

edgeImg = GEEComputePixels[
  basinRangeBBox,
  edges // GEEAbs,
  "VisParams" -> <|"min" -> 0, "max" -> 200,
    "palette" -> {"000000", "FFFFFF"}|>,
  "ImageSize" -> 1024
]
```

The resulting image resembles a hand-drawn geological line map: bright lines
trace fault scarps, ridge crests, and alluvial fan boundaries.

### 4.7.3 Combining Texture Metrics

For comprehensive terrain characterization, combine entropy, gradient
magnitude, and local relief into a multi-layer analysis.

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"];

(* Three texture metrics *)
entropy = dem // GEEEntropy[500];
localRelief = GEESubtract[dem // GEEFocalMax[1000], dem // GEEFocalMin[1000]];
slope = dem // GEETerrain // GEESelectBands[{"slope"}];

(* Retrieve each as a separate image *)
bbox = basinRangeBBox;

entropyRaster = GEEComputePixels[bbox, entropy,
  "VisParams" -> <|"min" -> 0, "max" -> 4|>, "ImageSize" -> 512];
reliefRaster = GEEComputePixels[bbox, localRelief,
  "VisParams" -> <|"min" -> 0, "max" -> 1500|>, "ImageSize" -> 512];
slopeRaster = GEEComputePixels[bbox, slope,
  "VisParams" -> <|"min" -> 0, "max" -> 45|>, "ImageSize" -> 512];

GraphicsGrid[
  {{entropyRaster, reliefRaster, slopeRaster}},
  ImageSize -> 900,
  PlotLabel -> {"Entropy", "Local Relief", "Slope"}
]
```

---

## 4.8 3D Visualization with Wolfram Language

Mathematica excels at 3D scientific visualization. By retrieving raster data
from GEE and converting it to numeric arrays, you can render publication-quality
3D terrain models entirely within Wolfram Language.

### 4.8.1 DEM to ListPlot3D

`GEEComputePixels` returns an `Image` object. Convert it to a numeric matrix
with `ImageData`, then render with `ListPlot3D` or `ReliefPlot`.

```wolfram
(* Retrieve a small DEM tile around the Matterhorn *)
matterhornBBox = {7.60, 45.95, 7.75, 46.05};

demImage = GEEComputePixels[
  matterhornBBox,
  GEELoadImage["USGS/SRTMGL1_003"],
  "ImageSize" -> 256
];

(* Convert Image to numeric elevation matrix *)
elevMatrix = ImageData[demImage, "Real32"];

(* If the image is multi-channel, take the first channel *)
If[ArrayDepth[elevMatrix] == 3,
  elevMatrix = elevMatrix[[All, All, 1]]
];

(* Render 3D terrain *)
ListPlot3D[Reverse[elevMatrix],
  PlotRange -> All,
  ColorFunction -> "AlpineColors",
  MeshFunctions -> {#3 &},
  MeshStyle -> Opacity[0.3],
  BoxRatios -> {1, 1, 0.5},
  PlotLabel -> "Matterhorn Region (SRTM)",
  ImageSize -> 600
]
```

The `Reverse` call flips the matrix because image row 0 is the top (north)
while `ListPlot3D` expects the first row to be the bottom of the plot.

### 4.8.2 ReliefPlot for 2.5D Shaded Relief

`ReliefPlot` produces a shaded relief visualization similar to hillshade
but rendered client-side with full control over lighting.

```wolfram
ReliefPlot[Reverse[elevMatrix],
  ColorFunction -> "DarkTerrain",
  PlotLabel -> "Matterhorn Region -- Shaded Relief",
  ImageSize -> 600
]
```

### 4.8.3 Comparing GEE SRTM with Wolfram GeoElevationData

Wolfram's built-in `GeoElevationData` provides elevation from a different
source (typically SRTM or ASTER, depending on the region). Comparing the
two is a useful validation exercise.

```wolfram
(* Wolfram built-in elevation for the same region *)
wolframElev = GeoElevationData[
  GeoBoundingBox[{GeoPosition[{45.95, 7.60}], GeoPosition[{46.05, 7.75}]}],
  GeoZoomLevel -> 10
];

(* Plot both *)
GraphicsRow[{
  ReliefPlot[Reverse[elevMatrix],
    PlotLabel -> "GEE SRTM", ImageSize -> 400],
  ReliefPlot[QuantityMagnitude[wolframElev],
    PlotLabel -> "Wolfram GeoElevationData", ImageSize -> 400]
}]
```

### 4.8.4 Overlay Satellite Imagery on 3D Terrain

The most compelling terrain visualizations drape satellite imagery over a
3D surface. Retrieve the RGB image and DEM separately from GEE, then
combine them in `ListPlot3D` using the `PlotStyle` texture option.

```wolfram
(* Step 1: Retrieve Sentinel-2 RGB *)
rgb = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2023-06-01", "2023-09-30"] //
  GEEFilterBounds[matterhornBBox] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
  GEESelectBands[{"B4", "B3", "B2"}] //
  GEEMedian;

rgbImage = GEEComputePixels[
  matterhornBBox, rgb,
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>,
  "ImageSize" -> 256
];

(* Step 2: Retrieve DEM at matching resolution *)
demImage = GEEComputePixels[
  matterhornBBox,
  GEELoadImage["USGS/SRTMGL1_003"],
  "ImageSize" -> 256
];

elevMatrix = ImageData[demImage, "Real32"];
If[ArrayDepth[elevMatrix] == 3,
  elevMatrix = elevMatrix[[All, All, 1]]
];

(* Step 3: Drape RGB over 3D terrain *)
ListPlot3D[Reverse[elevMatrix],
  PlotRange -> All,
  PlotStyle -> Texture[rgbImage],
  Mesh -> None,
  BoxRatios -> {1, 1, 0.5},
  Lighting -> "Neutral",
  PlotLabel -> "Matterhorn: Sentinel-2 Draped on SRTM",
  ImageSize -> 700
]
```

This produces a photorealistic 3D view of the Matterhorn with glaciers,
rock faces, and alpine meadows visible on the terrain surface.

### 4.8.5 Contour Maps

`ListContourPlot` generates topographic contour lines from the elevation
matrix, mimicking traditional topographic maps.

```wolfram
ListContourPlot[Reverse[elevMatrix],
  Contours -> Range[1500, 4500, 100],
  ContourLabels -> True,
  ContourStyle -> Directive[Thin, GrayLevel[0.3]],
  ColorFunction -> "AlpineColors",
  PlotLabel -> "Matterhorn Contour Map (100 m interval)",
  FrameLabel -> {"Column (px)", "Row (px)"},
  ImageSize -> 600
]
```

For georeferenced contours, convert pixel indices to geographic coordinates
using the bounding box:

```wolfram
{nRows, nCols} = Dimensions[elevMatrix];
{west, south, east, north} = matterhornBBox;

(* Map pixel indices to lon/lat *)
lonValues = Subdivide[west, east, nCols - 1];
latValues = Subdivide[south, north, nRows - 1];

ListContourPlot[Reverse[elevMatrix],
  DataRange -> {{west, east}, {south, north}},
  Contours -> Range[1500, 4500, 200],
  ContourLabels -> True,
  ContourStyle -> Directive[Thin, GrayLevel[0.3]],
  ColorFunction -> "AlpineColors",
  FrameLabel -> {"Longitude", "Latitude"},
  PlotLabel -> "Matterhorn Contour Map (georeferenced)",
  ImageSize -> 600
]
```

---

## 4.9 Putting It All Together: Multi-Layer Terrain Report

This section demonstrates a complete workflow that combines several
techniques from the chapter into a single analytical report for a
region of interest.

### 4.9.1 Region Setup

```wolfram
Needs["GoogleEarthEngineClient`"]
GEEConnect["path/to/service-account-key.json"];

(* Study area: Yosemite National Park *)
yosemiteBBox = {-119.9, 37.5, -119.2, 38.1};
yosemiteGeom = GEEGeometry[yosemiteBBox];
imgSize = 1024;
```

### 4.9.2 Elevation and Terrain

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"];
terrain = dem // GEETerrain;

(* Retrieve all layers *)
elevImg = GEEComputePixels[yosemiteBBox, dem,
  "VisParams" -> <|"min" -> 600, "max" -> 4000,
    "palette" -> {"1A5276", "27AE60", "F4D03F", "E67E22", "FFFFFF"}|>,
  "ImageSize" -> imgSize];

hillshadeImg = GEEComputePixels[yosemiteBBox,
  terrain // GEESelectBands[{"hillshade"}],
  "VisParams" -> <|"min" -> 0, "max" -> 255|>,
  "ImageSize" -> imgSize];

slopeImg = GEEComputePixels[yosemiteBBox,
  terrain // GEESelectBands[{"slope"}],
  "VisParams" -> <|"min" -> 0, "max" -> 60,
    "palette" -> {"00FF00", "FFFF00", "FF0000"}|>,
  "ImageSize" -> imgSize];
```

### 4.9.3 Elevation Statistics

```wolfram
meanElev = GEECompute[dem // GEEReduceRegion[yosemiteGeom, "mean", 30]];
minElev  = GEECompute[dem // GEEReduceRegion[yosemiteGeom, "min", 30]];
maxElev  = GEECompute[dem // GEEReduceRegion[yosemiteGeom, "max", 30]];

Grid[{
  {"Statistic", "Elevation (m)"},
  {"Minimum", minElev},
  {"Mean", Round[meanElev]},
  {"Maximum", maxElev}
}, Frame -> All, Background -> {None, {LightBlue, None}}]
```

### 4.9.4 Land Cover Overlay

```wolfram
lc = GEELoadImage["ESA/WorldCover/v200"];

lcImg = GEEComputePixels[yosemiteBBox, lc,
  "VisParams" -> <|
    "min" -> 10, "max" -> 100,
    "palette" -> {
      "006400", "FFBB22", "FFFF4C", "F096FF",
      "FA0000", "B4B4B4", "F0F0F0", "0064C8",
      "0096A0", "00CF75", "FAE6A0"
    }
  |>,
  "ImageSize" -> imgSize];
```

### 4.9.5 Local Relief

```wolfram
localRelief = GEESubtract[
  dem // GEEFocalMax[1000],
  dem // GEEFocalMin[1000]
];

reliefImg = GEEComputePixels[yosemiteBBox, localRelief,
  "VisParams" -> <|"min" -> 0, "max" -> 1200,
    "palette" -> {"FFFFFF", "FFD700", "FF4500", "8B0000"}|>,
  "ImageSize" -> imgSize];
```

### 4.9.6 Dashboard Layout

```wolfram
GraphicsGrid[{
  {Labeled[elevImg, "Elevation", Top],
   Labeled[hillshadeImg, "Hillshade", Top]},
  {Labeled[slopeImg, "Slope", Top],
   Labeled[reliefImg, "Local Relief (1 km)", Top]},
  {Labeled[lcImg, "Land Cover (ESA WorldCover)", Top],
   Labeled[ImageCompose[hillshadeImg, {slopeImg, 0.4}],
     "Hillshade + Slope Overlay", Top]}
}, ImageSize -> 1000, Spacings -> {10, 10}]
```

This produces a six-panel dashboard summarizing the terrain character of
Yosemite National Park: elevation, hillshade, slope, local relief, land
cover, and a composite overlay. Each panel was computed server-side on
Google Earth Engine and rendered locally in Mathematica -- a workflow that
scales to any region on Earth.

---

## Summary

This chapter covered the core techniques for terrain and geophysical
analysis with the GoogleEarthEngineClient paclet:

- **Section 4.1** -- Retrieving and comparing Digital Elevation Models
  (SRTM, ALOS, Copernicus), point queries, batch sampling, and regional
  statistics with `GEEReduceRegion`.

- **Section 4.2** -- Computing slope, aspect, and hillshade with
  `GEETerrain` and combining layers for cartographic rendering.

- **Section 4.3** -- Advanced spatial analysis with `GEEGradient`,
  `GEEFocalMean`, `GEEFocalMax`/`GEEFocalMin` for local relief, and
  `GEEReproject`/`GEEResample` for resolution control.

- **Section 4.4** -- Hydrological terrain analysis using slope thresholds,
  Boolean logic (`GEEAnd`, `GEEGreaterThan`, `GEELessThan`), and terrain
  classification.

- **Section 4.5** -- Land cover mapping with ESA WorldCover and MODIS,
  area computation with `GEEPixelArea`, and change detection.

- **Section 4.6** -- Soil property retrieval from OpenLandMap, including
  multi-depth profile visualization.

- **Section 4.7** -- Texture analysis with `GEEEntropy` and lineament
  detection with `GEEConvolve`.

- **Section 4.8** -- 3D visualization with `ListPlot3D`, `ReliefPlot`,
  `ListContourPlot`, and satellite imagery draped on terrain.

- **Section 4.9** -- A complete multi-layer terrain report workflow
  combining all techniques into a dashboard.

The next chapter extends these techniques to time-series analysis, where
we track how landscapes change over months, years, and decades.


---

# Chapter 5: Vegetation, Agriculture & Precision Farming

Vegetation monitoring from space is one of the most mature applications of remote
sensing. Satellites measure how plants interact with sunlight -- absorbing red
wavelengths for photosynthesis while reflecting near-infrared -- and this
spectral signature lets us quantify crop health, detect water stress, estimate
yields, and guide precision agriculture decisions. This chapter brings together
Google Earth Engine imagery, Wolfram Language analysis, and ground-sensor
integration into end-to-end workflows for agricultural scientists and engineers.

---

## 5.1 Vegetation Indices

Vegetation indices transform multi-band reflectance into single numbers that
correlate with plant properties such as chlorophyll content, canopy cover, and
leaf water content. The most widely used index is NDVI, but several alternatives
address its known limitations.

### 5.1.1 NDVI -- Normalized Difference Vegetation Index

**Physical basis.** Healthy green vegetation absorbs strongly in the red band
(~660 nm) because chlorophyll uses red photons for photosynthesis, while
reflecting strongly in the near-infrared (~850 nm) because the internal cell
structure of leaves scatters NIR light. NDVI captures this contrast:

```
NDVI = (NIR - Red) / (NIR + Red)
```

Values range from -1 to +1. Bare soil typically falls between 0.1 and 0.2,
sparse vegetation between 0.2 and 0.5, and dense healthy crops above 0.6.

**NDVI map of California's Central Valley (Sentinel-2).**

```wolfram
centralValley = {-121.5, 36.0, -119.5, 37.5};

ndviImage =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-07-01", "2024-08-01"] //
    GEEFilterBounds[centralValley] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}];

(* Visualize with a green-to-brown palette *)
GEEComputePixels[centralValley,
  ndviImage //
    GEEVisualize[<|
      "min" -> -0.1,
      "max" -> 0.9,
      "palette" -> {"#8B4513", "#D2B48C", "#F5F5DC", "#ADFF2F", "#006400"}
    |>],
  "ImageSize" -> 1024]
```

The palette runs from brown (bare soil, low NDVI) through tan and beige
(sparse cover) to bright green and dark green (vigorous crops). July is
peak growing season in the Central Valley, so irrigated fields appear dark
green while fallowed parcels remain brown.

**NDVI time series -- monthly composites.**

Extracting mean NDVI over a region for each month builds a phenology curve
that reveals green-up, peak, and senescence dates.

```wolfram
field = GEEGeometry[{-120.5, 36.8, -120.3, 37.0}];

monthlyNDVI = Table[
  Module[{start, end, composite, ndvi, stats},
    start = DateString[DateObject[{2024, m, 1}], {"Year", "-", "Month", "-", "Day"}];
    end = DateString[DatePlus[DateObject[{2024, m, 1}], {1, "Month"}],
      {"Year", "-", "Month", "-", "Day"}];

    composite =
      GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
        GEEFilterDate[start, end] //
        GEEFilterBounds[{-120.5, 36.8, -120.3, 37.0}] //
        GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
        GEEMedian;

    ndvi = composite // GEENormalizedDifference[{"B8", "B4"}];

    stats = GEECompute[
      ndvi // GEEReduceRegion[field, "mean", 30]
    ];

    {DateObject[{2024, m, 15}], stats["NDVI"]}
  ],
  {m, 1, 12}
];

(* Build a TimeSeries and plot *)
ndviTS = TimeSeries[monthlyNDVI[[All, 2]], {monthlyNDVI[[All, 1]]}];

DateListPlot[ndviTS,
  PlotLabel -> "Monthly Mean NDVI -- Central Valley Field",
  FrameLabel -> {"Date", "NDVI"},
  Filling -> Axis,
  PlotRange -> {0, 1},
  PlotTheme -> "Scientific"]
```

**NDVI from Landsat 8/9.** The band names differ from Sentinel-2. Landsat
Collection 2 surface reflectance uses `SR_B5` (NIR) and `SR_B4` (red):

```wolfram
landsatNDVI =
  GEECollection["LANDSAT/LC09/C02/T1_L2"] //
    GEEFilterDate["2024-06-01", "2024-09-01"] //
    GEEFilterBounds[centralValley] //
    GEEFilterProperty["CLOUD_COVER", "LessThan", 15] //
    GEEMedian //
    GEENormalizedDifference[{"SR_B5", "SR_B4"}];
```

### 5.1.2 EVI -- Enhanced Vegetation Index

NDVI saturates in dense canopies where LAI exceeds roughly 3. EVI was designed
for the MODIS sensor to remain sensitive in high-biomass regions by incorporating
a blue band to correct for atmospheric aerosol scattering and a soil adjustment
factor:

```
EVI = 2.5 * ((NIR - Red) / (NIR + 6*Red - 7.5*Blue + 1))
```

**Computing EVI with `GEEExpression`.**

```wolfram
sentinel2Composite =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-07-01", "2024-08-01"] //
    GEEFilterBounds[centralValley] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEMedian //
    GEESelectBands[{"B8", "B4", "B2"}];

eviImage =
  sentinel2Composite //
    GEEExpression[
      "2.5 * ((nir - red) / (nir + 6 * red - 7.5 * blue + 1))",
      <|"nir" -> "B8", "red" -> "B4", "blue" -> "B2"|>
    ];
```

**Side-by-side comparison of NDVI and EVI.**

```wolfram
ndviVis = ndviImage // GEEVisualize[<|"min" -> 0, "max" -> 1,
  "palette" -> {"white", "green", "darkgreen"}|>];

eviVis = eviImage // GEEVisualize[<|"min" -> 0, "max" -> 0.8,
  "palette" -> {"white", "green", "darkgreen"}|>];

GraphicsRow[{
  GEEComputePixels[centralValley, ndviVis, "ImageSize" -> 512],
  GEEComputePixels[centralValley, eviVis, "ImageSize" -> 512]
}, ImageSize -> 1100,
  PlotLabel -> "NDVI (left) vs EVI (right) -- July 2024"]
```

In densely vegetated fields (rice paddies, orchards), EVI retains more
contrast than NDVI, which compresses toward 0.8-0.9.

### 5.1.3 NDWI -- Normalized Difference Water Index

NDWI uses the green and NIR bands to detect water content in vegetation. It is
particularly useful for identifying crop water stress before it becomes visible
in NDVI. For NDWI applied to open water body detection rather than vegetation
water content, see Section 6.1.

```wolfram
(* Sentinel-2: B3 = Green, B8 = NIR *)
ndwiImage =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-08-01", "2024-09-01"] //
    GEEFilterBounds[centralValley] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEMedian //
    GEENormalizedDifference[{"B3", "B8"}];

(* Positive NDWI indicates high water content; negative indicates stress *)
GEEComputePixels[centralValley,
  ndwiImage // GEEVisualize[<|
    "min" -> -0.4, "max" -> 0.4,
    "palette" -> {"brown", "lightyellow", "cyan", "blue"}
  |>],
  "ImageSize" -> 800]
```

Water-stressed crops show strongly negative NDWI values. Pairing NDWI with
NDVI helps distinguish water stress (low NDWI, moderate NDVI) from general
senescence (both declining).

### 5.1.4 LAI -- Leaf Area Index from MODIS

LAI quantifies the total one-sided area of leaf tissue per unit ground area
(m^2/m^2). MODIS provides a global 500 m LAI product every 8 days.

```wolfram
forestRegion = {-122.5, 37.5, -121.5, 38.5};

laiImage =
  GEECollection["MODIS/061/MOD15A2H"] //
    GEEFilterDate["2024-07-01", "2024-07-31"] //
    GEEFilterBounds[forestRegion] //
    GEEMean //
    GEESelectBands[{"Lai_500m"}] //
    GEEMultiply[0.1];  (* Scale factor: raw values * 0.1 = true LAI *)

GEEComputePixels[forestRegion,
  laiImage // GEEVisualize[<|
    "min" -> 0, "max" -> 7,
    "palette" -> {"#FFFFCC", "#41B6C4", "#225EA8", "#081D58"}
  |>],
  "ImageSize" -> 800]
```

The scale factor of 0.1 converts the integer-stored values to physical LAI
units. Dense forests typically show LAI values of 4-7, while grasslands and
croplands range from 1-4.

---

## 5.2 Crop Monitoring Workflows

### 5.2.1 Seasonal Crop Phenology from NDVI

A full phenology curve captures the lifecycle of a crop from planting through
harvest. The key phenological stages are:

- **Green-up**: NDVI begins rising (planting/emergence)
- **Peak**: Maximum NDVI (full canopy closure)
- **Senescence**: NDVI declining (maturation, drying)
- **Harvest**: Abrupt NDVI drop

**Full phenology curve -- March through November.**

```wolfram
fieldBBox = {-120.65, 36.85, -120.55, 36.95};
fieldGeom = GEEGeometry[fieldBBox];

phenologyData = Table[
  Module[{start, end, ndvi, stats},
    start = DateString[DateObject[{2024, m, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    end = DateString[DatePlus[DateObject[{2024, m, 1}], {1, "Month"}],
      {"Year", "-", "Month", "-", "Day"}];

    ndvi =
      GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
        GEEFilterDate[start, end] //
        GEEFilterBounds[fieldBBox] //
        GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 25] //
        GEEMedian //
        GEENormalizedDifference[{"B8", "B4"}];

    stats = GEECompute[ndvi // GEEReduceRegion[fieldGeom, "mean", 10]];
    stats["NDVI"]
  ],
  {m, 3, 11}
];

dates = Table[DateObject[{2024, m, 15}], {m, 3, 11}];
phenologyTS = TimeSeries[phenologyData, {dates}];
```

**Fourier analysis to identify growing-season periodicity.**

```wolfram
(* Pad the series and compute the power spectrum *)
paddedValues = PadRight[phenologyData, 16, Mean[phenologyData]];
spectrum = Abs[Fourier[paddedValues]]^2;

ListLinePlot[spectrum[[2 ;; 8]],
  PlotLabel -> "NDVI Power Spectrum",
  FrameLabel -> {"Frequency Component", "Power"},
  PlotTheme -> "Scientific"]
```

A dominant peak at frequency component 2 corresponds to a single growing season
(one cycle per year). Two peaks would indicate a double-crop system.

**Detecting green-up, peak, and senescence dates.**

```wolfram
(* Interpolate to get a smooth daily curve *)
dailyCurve = Interpolation[
  Transpose[{Range[Length[phenologyData]], phenologyData}],
  InterpolationOrder -> 3];

(* Green-up: where derivative first exceeds a threshold *)
greenUpMonth = First @ Select[
  Range[1, Length[phenologyData] - 1],
  (dailyCurve'[#] > 0.05) &
];

(* Peak: maximum value *)
peakMonth = First @ Ordering[phenologyData, -1];

(* Senescence: where derivative becomes strongly negative after peak *)
senescenceMonth = First @ Select[
  Range[peakMonth + 1, Length[phenologyData]],
  (dailyCurve'[#] < -0.05) &
];

(* Map back to calendar months (offset by 2 since we start at March) *)
{greenUpMonth + 2, peakMonth + 2, senescenceMonth + 2}
```

**Compare NDVI profiles for different crop types.**

```wolfram
(* Define fields of known crop type *)
cornField = GEEGeometry[{-120.4, 36.9, -120.3, 37.0}];
alfalfaField = GEEGeometry[{-120.7, 36.7, -120.6, 36.8}];
orchardField = GEEGeometry[{-121.0, 37.1, -120.9, 37.2}];

extractProfile[geom_, bbox_] := Table[
  Module[{start, end, ndvi, stats},
    start = DateString[DateObject[{2024, m, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    end = DateString[DatePlus[DateObject[{2024, m, 1}], {1, "Month"}],
      {"Year", "-", "Month", "-", "Day"}];
    ndvi =
      GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
        GEEFilterDate[start, end] //
        GEEFilterBounds[bbox] //
        GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 25] //
        GEEMedian //
        GEENormalizedDifference[{"B8", "B4"}];
    stats = GEECompute[ndvi // GEEReduceRegion[geom, "mean", 10]];
    stats["NDVI"]
  ],
  {m, 3, 11}
];

cornProfile = extractProfile[cornField, {-120.4, 36.9, -120.3, 37.0}];
alfalfaProfile = extractProfile[alfalfaField, {-120.7, 36.7, -120.6, 36.8}];
orchardProfile = extractProfile[orchardField, {-121.0, 37.1, -120.9, 37.2}];

months = Table[DateObject[{2024, m, 15}], {m, 3, 11}];

DateListPlot[{
    TimeSeries[cornProfile, {months}],
    TimeSeries[alfalfaProfile, {months}],
    TimeSeries[orchardProfile, {months}]
  },
  PlotLegends -> {"Corn", "Alfalfa", "Orchard"},
  PlotLabel -> "NDVI Profiles by Crop Type",
  FrameLabel -> {"Date", "NDVI"},
  PlotRange -> {0, 1},
  PlotTheme -> "Scientific"]
```

Corn shows a single sharp peak in July-August. Alfalfa, cut multiple times per
season, displays a sawtooth pattern. Orchards maintain relatively stable NDVI
from spring through fall.

### 5.2.2 MODIS 16-Day NDVI

MODIS provides pre-computed NDVI at 16-day intervals with consistent atmospheric
correction, making it ideal for long time-series analysis.

```wolfram
modisNDVI = Table[
  Module[{start, end, stats},
    start = DateString[DateObject[{2024, 1, 1}] ~DatePlus~ {(i - 1) * 16, "Day"},
      {"Year", "-", "Month", "-", "Day"}];
    end = DateString[DateObject[{2024, 1, 1}] ~DatePlus~ {i * 16, "Day"},
      {"Year", "-", "Month", "-", "Day"}];

    stats = GEECompute[
      GEECollection["MODIS/061/MOD13A2"] //
        GEEFilterDate[start, end] //
        GEEFilterBounds[fieldBBox] //
        GEEMean //
        GEESelectBands[{"NDVI"}] //
        GEEMultiply[0.0001] //  (* MODIS scale factor *)
        GEEReduceRegion[fieldGeom, "mean", 1000]
    ];
    {DateObject[{2024, 1, 1}] ~DatePlus~ {(i - 1) * 16 + 8, "Day"},
     stats["NDVI"]}
  ],
  {i, 1, 23}
];
```

**Smoothing with `MovingAverage` for cleaner phenology curves.**

```wolfram
rawValues = modisNDVI[[All, 2]];
smoothedValues = MovingAverage[rawValues, 3];
smoothedDates = modisNDVI[[3 ;; -3, 1]];

ListLinePlot[{
    Transpose[{modisNDVI[[All, 1]], rawValues}],
    Transpose[{smoothedDates, smoothedValues}]
  },
  PlotLegends -> {"Raw MODIS", "3-point Moving Average"},
  PlotLabel -> "MODIS 16-Day NDVI with Smoothing",
  FrameLabel -> {"Date", "NDVI"},
  PlotTheme -> "Scientific"]
```

The moving average removes noise from cloud contamination and sensor artifacts
while preserving the overall phenological shape.

---

## 5.3 Crop Classification

### 5.3.1 USDA Cropland Data Layer (CDL)

The Cropland Data Layer is a 30 m annual crop-type map covering the contiguous
United States, produced by USDA NASS. Each pixel is classified into one of over
100 crop categories.

**Display the CDL map.**

```wolfram
iowaRegion = {-94.0, 41.5, -92.0, 42.5};

cdlImage =
  GEECollection["USDA/NASS/CDL"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFirst //
    GEESelectBands[{"cropland"}];

GEEComputePixels[iowaRegion,
  cdlImage //
    GEEVisualize[<|
      "min" -> 0, "max" -> 255,
      "palette" -> {"#FFD700", "#00FF00", "#FF6347", "#8B4513",
                    "#1E90FF", "#32CD32", "#FF69B4", "#A0522D"}
    |>],
  "ImageSize" -> 1024]
```

**Compute area by crop type.**

CDL class values include 1 = Corn, 5 = Soybeans, 24 = Winter Wheat, among
others. We can compute the area of each crop type using pixel-level masking
and area reduction.

```wolfram
computeCropArea[cdl_, classValue_, geom_, bbox_] :=
  Module[{mask, area, stats},
    mask = cdl // GEEEquals[classValue];
    area = GEEPixelArea[] // GEEUpdateMask[mask];
    stats = GEECompute[
      area // GEEReduceRegion[geom, "sum", 30]
    ];
    stats["area"] / 1.0*^6  (* Convert m^2 to km^2 *)
  ];

iowaGeom = GEEGeometry[iowaRegion];

cornArea = computeCropArea[cdlImage, 1, iowaGeom, iowaRegion];
soyArea = computeCropArea[cdlImage, 5, iowaGeom, iowaRegion];
wheatArea = computeCropArea[cdlImage, 24, iowaGeom, iowaRegion];

BarChart[{cornArea, soyArea, wheatArea},
  ChartLabels -> {"Corn", "Soybeans", "Winter Wheat"},
  FrameLabel -> {None, "Area (km\[Superscript]2)"},
  PlotLabel -> "Crop Area -- Central Iowa, 2023",
  ChartStyle -> {Yellow, Green, Lighter[Brown]},
  PlotTheme -> "Business"]
```

### 5.3.2 ML-Based Classification from Satellite Imagery

When CDL is unavailable (outside the US or for custom crop types), you can
train your own classifier using satellite spectral bands as features.

**Step 1: Extract training data at known locations.**

```wolfram
(* Define training points with known crop labels *)
cornPoints = {
  GeoPosition[{41.8, -93.5}], GeoPosition[{41.9, -93.4}],
  GeoPosition[{42.0, -93.6}], GeoPosition[{41.7, -93.3}],
  GeoPosition[{42.1, -93.5}]
};

soyPoints = {
  GeoPosition[{41.6, -93.8}], GeoPosition[{41.7, -93.7}],
  GeoPosition[{41.8, -93.9}], GeoPosition[{41.5, -93.6}],
  GeoPosition[{41.9, -93.8}]
};

wheatPoints = {
  GeoPosition[{42.2, -93.2}], GeoPosition[{42.3, -93.1}],
  GeoPosition[{42.1, -93.3}], GeoPosition[{42.0, -93.2}],
  GeoPosition[{42.2, -93.0}]
};

(* July composite for peak growing season *)
julyComposite =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-07-01", "2024-08-01"] //
    GEEFilterBounds[{-94.0, 41.5, -92.0, 42.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEEMedian //
    GEESelectBands[{"B2", "B3", "B4", "B5", "B6", "B7", "B8", "B8A", "B11", "B12"}];

(* Extract spectral values *)
cornSamples = GEEGetSamples[cornPoints, julyComposite];
soySamples = GEEGetSamples[soyPoints, julyComposite];
wheatSamples = GEEGetSamples[wheatPoints, julyComposite];
```

**Step 2: Train a classifier in Wolfram Language.**

```wolfram
(* Format training data: {feature vector -> label} *)
formatSamples[samples_, label_] :=
  (Values[#["Values"]] -> label) & /@ samples;

trainingData = Join[
  formatSamples[cornSamples, "Corn"],
  formatSamples[soySamples, "Soybeans"],
  formatSamples[wheatSamples, "Wheat"]
];

(* Train a random forest classifier *)
cropClassifier = Classify[trainingData, Method -> "RandomForest"];
```

**Step 3: Evaluate the classifier.**

```wolfram
measurements = ClassifierMeasurements[cropClassifier, trainingData];

(* Overall accuracy *)
measurements["Accuracy"]

(* Confusion matrix *)
measurements["ConfusionMatrixPlot"]

(* Per-class precision and recall *)
measurements["Precision"]
measurements["Recall"]
```

**Step 4: Unsupervised clustering as an alternative.**

When labeled training data is unavailable, `FindClusters` can identify
spectrally distinct land cover groups.

```wolfram
(* Sample a grid of points *)
gridPoints = Flatten[
  Table[GeoPosition[{lat, lon}],
    {lat, 41.5, 42.5, 0.1}, {lon, -94.0, -92.0, 0.1}],
  1];

allSamples = GEEGetSamples[gridPoints, julyComposite];
spectralVectors = Values[#["Values"]] & /@ allSamples;

(* Cluster into 5 groups *)
clusters = FindClusters[spectralVectors -> Range[Length[spectralVectors]],
  5, Method -> "KMeans"];

(* Assign cluster labels back to geographic positions *)
clusterLabels = Table[0, Length[spectralVectors]];
Do[
  (clusterLabels[[#]] = k) & /@ clusters[[k]],
  {k, Length[clusters]}
];

(* Visualize clusters on a map *)
GeoListPlot[
  Table[
    Style[allSamples[[i]]["Position"], ColorData[97][clusterLabels[[i]]]],
    {i, Length[allSamples]}
  ],
  PlotLabel -> "Unsupervised Land Cover Clusters",
  GeoRange -> {{41.4, 42.6}, {-94.1, -91.9}}]
```

---

## 5.4 Soil Moisture and Water Management

### 5.4.1 Sentinel-1 SAR for Soil Moisture

Synthetic Aperture Radar (SAR) operates independently of cloud cover and
sunlight. The VV-polarized backscatter coefficient from Sentinel-1 correlates
with surface soil moisture: wetter soils produce stronger backscatter because
the dielectric constant of water is much higher than that of dry soil.

```wolfram
farmRegion = {-93.5, 41.5, -93.0, 42.0};

sarImage =
  GEECollection["COPERNICUS/S1_GRD"] //
    GEEFilterDate["2024-06-01", "2024-06-30"] //
    GEEFilterBounds[farmRegion] //
    GEEFilterProperty["instrumentMode", "Equals", "IW"] //
    GEEFilterProperty["orbitProperties_pass", "Equals", "ASCENDING"] //
    GEESelectBands[{"VV"}] //
    GEEMedian;

GEEComputePixels[farmRegion,
  sarImage // GEEVisualize[<|
    "min" -> -25, "max" -> 0,
    "palette" -> {"#000033", "#003366", "#006699", "#3399CC",
                  "#66CCFF", "#99FFFF"}
  |>],
  "ImageSize" -> 800]
```

VV backscatter values (in dB) typically range from -25 (very dry) to -5 (very
wet or standing water). The ascending orbit minimizes wind-induced roughness
artifacts on vegetation.

### 5.4.2 Temporal SAR for Irrigation Detection

Irrigated fields show consistently higher SAR backscatter than rainfed fields
during dry periods. Comparing backscatter statistics between known irrigated
and rainfed areas confirms this pattern.

```wolfram
irrigatedField = GEEGeometry[{-93.3, 41.7, -93.2, 41.8}];
rainfedField = GEEGeometry[{-93.4, 41.6, -93.3, 41.7}];

sarJune =
  GEECollection["COPERNICUS/S1_GRD"] //
    GEEFilterDate["2024-06-01", "2024-06-30"] //
    GEEFilterBounds[farmRegion] //
    GEEFilterProperty["instrumentMode", "Equals", "IW"] //
    GEEFilterProperty["orbitProperties_pass", "Equals", "ASCENDING"] //
    GEESelectBands[{"VV"}] //
    GEEMedian;

irrigatedVV = GEECompute[
  sarJune // GEEReduceRegion[irrigatedField, "mean", 10]
];

rainfedVV = GEECompute[
  sarJune // GEEReduceRegion[rainfedField, "mean", 10]
];

(* Compare: irrigated fields typically show 2-5 dB higher backscatter *)
{irrigatedVV["VV"], rainfedVV["VV"]}
```

### 5.4.3 NDVI-Based Irrigation Detection

An alternative approach compares NDVI trajectories. Irrigated fields maintain
high NDVI through dry summer months while rainfed fields decline.

```wolfram
extractNDVIProfile[geom_, bbox_] := Table[
  Module[{start, end, ndvi, stats},
    start = DateString[DateObject[{2024, m, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    end = DateString[DatePlus[DateObject[{2024, m, 1}], {1, "Month"}],
      {"Year", "-", "Month", "-", "Day"}];
    ndvi =
      GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
        GEEFilterDate[start, end] //
        GEEFilterBounds[bbox] //
        GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 25] //
        GEEMedian //
        GEENormalizedDifference[{"B8", "B4"}];
    stats = GEECompute[ndvi // GEEReduceRegion[geom, "mean", 10]];
    stats["NDVI"]
  ],
  {m, 5, 10}
];

irrigatedProfile = extractNDVIProfile[irrigatedField,
  {-93.3, 41.7, -93.2, 41.8}];
rainfedProfile = extractNDVIProfile[rainfedField,
  {-93.4, 41.6, -93.3, 41.7}];

months = Table[DateObject[{2024, m, 15}], {m, 5, 10}];

DateListPlot[{
    TimeSeries[irrigatedProfile, {months}],
    TimeSeries[rainfedProfile, {months}]
  },
  PlotLegends -> {"Irrigated", "Rainfed"},
  PlotLabel -> "Irrigation Detection via NDVI Divergence",
  FrameLabel -> {"Date", "NDVI"},
  PlotTheme -> "Scientific"]
```

The divergence between the two curves during July-August is the irrigation
signal. A persistent NDVI difference greater than 0.15 during the dry season
is a strong indicator of irrigation.

---

## 5.5 Yield Estimation and Variable Rate Application

### 5.5.1 Correlating NDVI with Yield

Peak-season NDVI is a well-established proxy for crop yield. The relationship
is approximately linear for grain crops within a single growing region, though
it saturates at very high biomass levels.

**Step 1: Extract NDVI at yield sampling points.**

```wolfram
(* Field sample locations with known yield (bushels/acre) *)
sampleLocations = {
  GeoPosition[{41.80, -93.50}], GeoPosition[{41.82, -93.48}],
  GeoPosition[{41.84, -93.52}], GeoPosition[{41.86, -93.46}],
  GeoPosition[{41.88, -93.54}], GeoPosition[{41.90, -93.44}],
  GeoPosition[{41.78, -93.56}], GeoPosition[{41.76, -93.42}],
  GeoPosition[{41.92, -93.50}], GeoPosition[{41.85, -93.49}]
};

yieldData = {182, 175, 190, 168, 195, 172, 160, 188, 178, 185};

(* Peak-season NDVI at those points *)
peakComposite =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-07-15", "2024-08-15"] //
    GEEFilterBounds[{-93.6, 41.7, -93.4, 42.0}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}];

ndviSamples = GEEGetSamples[sampleLocations, peakComposite];
ndviValues = #["Values"]["NDVI"] & /@ ndviSamples;
```

**Step 2: Build a regression model.**

```wolfram
(* Linear regression: yield = a * NDVI + b *)
yieldModel = LinearModelFit[
  Transpose[{ndviValues, yieldData}],
  x, x
];

(* Model summary *)
yieldModel["ParameterTable"]
yieldModel["RSquared"]

(* Visualize the fit *)
Show[
  ListPlot[Transpose[{ndviValues, yieldData}],
    PlotStyle -> PointSize[0.02],
    FrameLabel -> {"Peak NDVI", "Yield (bu/acre)"},
    PlotLabel -> "NDVI-Yield Regression"],
  Plot[yieldModel[x], {x, 0.4, 0.95},
    PlotStyle -> Red]
]
```

**Step 3: Predict yield from new NDVI data.**

```wolfram
(* Using the Wolfram Predict framework for a more robust model *)
yieldPredictor = Predict[
  Thread[ndviValues -> yieldData],
  Method -> "GradientBoostedTrees"
];

(* Predict yield at new field locations *)
newLocations = {
  GeoPosition[{41.83, -93.51}],
  GeoPosition[{41.87, -93.47}]
};

newNDVI = GEEGetSamples[newLocations, peakComposite];
newNDVIValues = #["Values"]["NDVI"] & /@ newNDVI;

predictedYields = yieldPredictor /@ newNDVIValues
```

### 5.5.2 Variable Rate Application (VRA) Maps

Precision agriculture applies inputs (fertilizer, seed, water) at variable
rates across a field based on spatial productivity patterns. NDVI-derived
management zones guide these prescriptions.

**Step 1: Sample NDVI across a field grid.**

```wolfram
(* Create a dense sampling grid within a field *)
fieldPoints = Flatten[
  Table[GeoPosition[{lat, lon}],
    {lat, 41.80, 41.90, 0.005},
    {lon, -93.55, -93.45, 0.005}],
  1];

fieldNDVI = GEEGetSamples[fieldPoints, peakComposite];
ndviGrid = #["Values"]["NDVI"] & /@ fieldNDVI;
```

**Step 2: Cluster into management zones.**

```wolfram
(* Cluster NDVI values into 4 management zones *)
zones = FindClusters[ndviGrid -> Range[Length[ndviGrid]], 4,
  Method -> "KMeans"];

(* Sort zones by mean NDVI -- zone 1 = lowest, zone 4 = highest *)
zoneMeans = Mean[ndviGrid[[#]]] & /@ zones;
sortOrder = Ordering[zoneMeans];
sortedZones = zones[[sortOrder]];

(* Assign zone labels *)
zoneLabels = Table[0, Length[ndviGrid]];
Do[
  (zoneLabels[[#]] = k) & /@ sortedZones[[k]],
  {k, 4}
];
```

**Step 3: Assign fertilizer rates and visualize.**

```wolfram
(* Prescription: higher NDVI zones need less N fertilizer *)
fertilizerRates = <|1 -> 200, 2 -> 160, 3 -> 120, 4 -> 80|>;  (* lbs N/acre *)

prescriptions = fertilizerRates /@ zoneLabels;

(* Visualize the prescription map *)
zoneColors = {Red, Orange, LightGreen, Darker[Green]};

GeoListPlot[
  Table[
    Style[fieldPoints[[i]], zoneColors[[zoneLabels[[i]]]]],
    {i, Length[fieldPoints]}
  ],
  PlotLabel -> "VRA Prescription Map (lbs N/acre)",
  PlotLegends -> SwatchLegend[zoneColors,
    {"200 lbs/ac", "160 lbs/ac", "120 lbs/ac", "80 lbs/ac"}],
  GeoRange -> {{41.79, 41.91}, {-93.56, -93.44}}]
```

The logic is straightforward: zones with low NDVI (low productivity) often
have depleted soil nitrogen and benefit from higher fertilizer application,
while high-NDVI zones already have sufficient nutrient availability.

---

## 5.6 Precision Agriculture Sensor Integration

Satellite data provides broad spatial coverage but limited temporal resolution
(5-16 day revisit) and moderate spatial resolution (10-30 m). Ground sensors,
weather stations, drones, and GPS instruments fill these gaps.

### 5.6.1 IoT Soil Sensors

Modern precision farms deploy networks of in-situ sensors measuring soil
moisture, temperature, and electrical conductivity (EC) at multiple depths.

**Importing and aligning sensor data.**

```wolfram
(* Import time-series data from a soil moisture sensor network *)
sensorData = Import["soil_sensors.csv", "Dataset", HeaderLines -> 1];

(* Expected columns: Timestamp, SensorID, Depth_cm, Moisture_pct, Temp_C, EC *)
sensorData // Dataset

(* Filter to a single sensor at 30 cm depth *)
sensor42 = sensorData[
  Select[#SensorID == 42 && #Depth_cm == 30 &]
];

(* Build a TimeSeries object *)
moistureTS = TimeSeries[
  Normal[sensor42[All, "Moisture_pct"]],
  {Normal[sensor42[All, "Timestamp"]]}
];

DateListPlot[moistureTS,
  PlotLabel -> "Soil Moisture at 30 cm -- Sensor 42",
  FrameLabel -> {"Date", "Volumetric Water Content (%)"},
  PlotRange -> {0, 50},
  PlotTheme -> "Scientific"]
```

**Aligning sensor data with satellite overpass dates.**

Satellite-derived soil moisture and in-situ measurements must be compared at
matching timestamps. `TimeSeriesResample` handles the temporal alignment.

```wolfram
(* Sentinel-1 overpasses occur every 6 days for our region *)
sarDates = DateRange[
  DateObject[{2024, 6, 1}],
  DateObject[{2024, 8, 31}],
  Quantity[6, "Days"]
];

(* Resample the sensor time series to satellite overpass dates *)
alignedMoisture = TimeSeriesResample[moistureTS, {sarDates}];

(* Now extract SAR backscatter at the sensor location for the same dates *)
sensorLocation = GeoPosition[{41.85, -93.50}];

sarValues = Table[
  Module[{start, end, sar, result},
    start = DateString[date, {"Year", "-", "Month", "-", "Day"}];
    end = DateString[DatePlus[date, {2, "Day"}],
      {"Year", "-", "Month", "-", "Day"}];
    sar =
      GEECollection["COPERNICUS/S1_GRD"] //
        GEEFilterDate[start, end] //
        GEEFilterBounds[{-93.6, 41.7, -93.4, 42.0}] //
        GEEFilterProperty["instrumentMode", "Equals", "IW"] //
        GEEFilterProperty["orbitProperties_pass", "Equals", "ASCENDING"] //
        GEESelectBands[{"VV"}] //
        GEEMedian;
    result = GEEIdentify[sensorLocation, sar];
    result["Values"]["VV"]
  ],
  {date, sarDates}
];

(* Validate: scatter plot of SAR backscatter vs in-situ moisture *)
ListPlot[
  Transpose[{alignedMoisture["Values"], sarValues}],
  FrameLabel -> {"In-Situ Moisture (%)", "SAR VV Backscatter (dB)"},
  PlotLabel -> "Satellite vs Ground Truth Soil Moisture",
  PlotStyle -> PointSize[0.015],
  PlotTheme -> "Scientific"]
```

### 5.6.2 Weather Station Data

Wolfram Language provides built-in access to weather station observations via
`WeatherData`. Comparing these with GEE gridded climate products (such as
ERA5) reveals systematic biases that can be corrected.

**Comparing ground station temperature with ERA5 reanalysis.**

```wolfram
(* Ground station: Des Moines, IA *)
stationTemp = WeatherData[
  Entity["WeatherStation", "KDSM"],
  "MeanTemperature",
  {{2024, 6, 1}, {2024, 8, 31}, "Day"}
];

(* ERA5 daily mean temperature at the same location *)
stationPos = GeoPosition[{41.534, -93.663}];

era5Temps = Table[
  Module[{start, end, result},
    start = DateString[date, {"Year", "-", "Month", "-", "Day"}];
    end = DateString[DatePlus[date, {1, "Day"}],
      {"Year", "-", "Month", "-", "Day"}];
    result = GEEIdentify[stationPos,
      GEECollection["ECMWF/ERA5_LAND/DAILY_AGGR"] //
        GEEFilterDate[start, end] //
        GEEFirst //
        GEESelectBands[{"temperature_2m"}]
    ];
    result["Values"]["temperature_2m"] - 273.15  (* Kelvin to Celsius *)
  ],
  {date, DateRange[DateObject[{2024, 6, 1}], DateObject[{2024, 8, 31}],
    Quantity[1, "Day"]]}
];

(* Bias correction using LinearModelFit *)
stationValues = QuantityMagnitude[stationTemp["Values"], "DegreesCelsius"];

biasModel = LinearModelFit[
  Transpose[{era5Temps, stationValues}],
  x, x
];

(* The slope and intercept correct ERA5 to match station observations *)
biasModel["BestFitParameters"]
biasModel["RSquared"]

DateListPlot[{stationTemp, TimeSeries[era5Temps,
    {DateRange[DateObject[{2024, 6, 1}], DateObject[{2024, 8, 31}],
      Quantity[1, "Day"]]}]},
  PlotLegends -> {"Weather Station", "ERA5 Reanalysis"},
  PlotLabel -> "Temperature Comparison -- Des Moines, IA",
  FrameLabel -> {"Date", "Temperature (\[Degree]C)"},
  PlotTheme -> "Scientific"]
```

### 5.6.3 Drone Multispectral Imagery

Drones equipped with multispectral cameras (MicaSense RedEdge, DJI P4
Multispectral) capture imagery at centimeter resolution. Comparing drone NDVI
with satellite NDVI validates both data sources and enables temporal fusion.

**Import drone GeoTIFF and compute NDVI locally.**

```wolfram
(* Import a 5-band multispectral GeoTIFF from a drone flight *)
droneRaster = Import["drone_multispectral.tif", "GeoTIFF"];

(* MicaSense RedEdge band order: Blue, Green, Red, RedEdge, NIR *)
droneBands = ImageData /@ ColorSeparate[droneRaster["Image"]];
nirBand = droneBands[[5]];
redBand = droneBands[[3]];

droneNDVI = Image[(nirBand - redBand) / (nirBand + redBand + 0.0001)];

(* Visualize with a green palette *)
Colorize[droneNDVI,
  ColorFunction -> (Blend[{Brown, Yellow, Green, Darker[Green]}, #] &),
  PlotLabel -> "Drone NDVI (5 cm resolution)"]
```

**Compare drone NDVI with Sentinel-2 NDVI.**

```wolfram
(* Sentinel-2 NDVI for the same date and area *)
droneFlightDate = "2024-07-20";
droneBBox = {-93.52, 41.84, -93.48, 41.88};

sentinelNDVI =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-07-18", "2024-07-22"] //
    GEEFilterBounds[droneBBox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}];

sentinelImage = GEEComputePixels[droneBBox, sentinelNDVI, "ImageSize" -> 256];

(* Downscale drone NDVI to match Sentinel-2 resolution for comparison *)
droneDownscaled = ImageResize[droneNDVI, ImageDimensions[sentinelImage]];

(* Pixel-by-pixel correlation *)
sentinelValues = Flatten[ImageData[sentinelImage]];
droneValues = Flatten[ImageData[droneDownscaled]];

ListPlot[Transpose[{droneValues, sentinelValues}],
  FrameLabel -> {"Drone NDVI (resampled)", "Sentinel-2 NDVI"},
  PlotLabel -> "Cross-Platform NDVI Validation",
  PlotStyle -> {PointSize[0.003], Opacity[0.3]},
  Epilog -> {Red, Dashed, InfiniteLine[{0, 0}, {1, 1}]},
  PlotTheme -> "Scientific",
  AspectRatio -> 1]
```

The 1:1 line (red dashed) shows the ideal agreement. Systematic offsets
indicate calibration differences between the drone sensor and Sentinel-2.

**Temporal fusion: filling gaps between satellite passes with drone data.**

```wolfram
(* Satellite NDVI available roughly every 5 days *)
satelliteDates = DateRange[
  DateObject[{2024, 7, 1}], DateObject[{2024, 8, 31}],
  Quantity[5, "Days"]];

satelliteNDVIMeans = Table[
  Module[{start, end, ndvi, geom, stats},
    start = DateString[d, {"Year", "-", "Month", "-", "Day"}];
    end = DateString[DatePlus[d, {3, "Day"}],
      {"Year", "-", "Month", "-", "Day"}];
    geom = GEEGeometry[droneBBox];
    ndvi =
      GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
        GEEFilterDate[start, end] //
        GEEFilterBounds[droneBBox] //
        GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 30] //
        GEEMedian //
        GEENormalizedDifference[{"B8", "B4"}];
    stats = GEECompute[ndvi // GEEReduceRegion[geom, "mean", 10]];
    stats["NDVI"]
  ],
  {d, satelliteDates}
];

(* Drone flights fill specific gaps *)
droneFlightDates = {DateObject[{2024, 7, 12}], DateObject[{2024, 7, 20}],
  DateObject[{2024, 8, 5}]};
droneMeanNDVI = {0.72, 0.78, 0.81};  (* Field-average from drone imagery *)

(* Merge into a single time series *)
allDates = Sort @ Join[satelliteDates, droneFlightDates];
allValues = Join[
  Thread[satelliteDates -> satelliteNDVIMeans],
  Thread[droneFlightDates -> droneMeanNDVI]
] // SortBy[First] // Values;

fusedTS = TimeSeries[allValues, {allDates}];

DateListPlot[fusedTS,
  PlotLabel -> "Fused Satellite + Drone NDVI Time Series",
  FrameLabel -> {"Date", "Field Mean NDVI"},
  PlotMarkers -> Automatic,
  PlotTheme -> "Scientific"]
```

### 5.6.4 GNSS/RTK Positioning for Field Sampling

High-precision GPS coordinates from RTK-enabled receivers georeferenced field
samples (soil cores, yield monitor points) to within centimeters. These
coordinates feed directly into `GEEGetSamples` for multi-point extraction.

```wolfram
(* Import RTK GPS coordinates from a field sampling campaign *)
gpsData = Import["field_samples_rtk.csv", "Dataset", HeaderLines -> 1];

(* Expected columns: SampleID, Latitude, Longitude, Yield_bu_acre *)
samplePositions = GeoPosition[{#Latitude, #Longitude}] & /@
  Normal[gpsData];

(* Extract multi-band satellite data at each GPS point *)
multiBandComposite =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-07-15", "2024-08-15"] //
    GEEFilterBounds[{-93.6, 41.7, -93.4, 42.0}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEEMedian //
    GEESelectBands[{"B2", "B3", "B4", "B8", "B11", "B12"}];

spectralData = GEEGetSamples[samplePositions, multiBandComposite];

(* Combine with yield data for regression modeling *)
yieldValues = Normal[gpsData[All, "Yield_bu_acre"]];
featureVectors = Values[#["Values"]] & /@ spectralData;

multiVariateModel = LinearModelFit[
  Join[featureVectors, List /@ yieldValues, 2],
  {b2, b3, b4, b8, b11, b12},
  {b2, b3, b4, b8, b11, b12}
];

multiVariateModel["RSquared"]
multiVariateModel["ParameterTable"]
```

Using the full spectral signature (not just NDVI) typically improves yield
prediction because shortwave infrared bands capture moisture stress and soil
background effects that NDVI alone misses.

---

## 5.7 Field Boundary Detection

Detecting field boundaries from satellite imagery is useful for delineating
management units without manual digitization. NDVI gradients mark the edges
between fields with different crop types or management practices.

**Step 1: Compute NDVI gradient magnitude.**

```wolfram
fieldBoundaryRegion = {-93.5, 41.8, -93.3, 42.0};

ndviForEdges =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-07-01", "2024-08-01"] //
    GEEFilterBounds[fieldBoundaryRegion] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}];

(* GEEGradient computes x and y partial derivatives *)
gradientImage = ndviForEdges // GEEGradient;
```

**Step 2: Retrieve and process with Wolfram image functions.**

```wolfram
(* Fetch the gradient as a raster *)
gradImg = GEEComputePixels[fieldBoundaryRegion, gradientImage,
  "ImageSize" -> 1024];

(* Compute gradient magnitude from x and y components *)
gradBands = ColorSeparate[gradImg];
gradX = ImageData[gradBands[[1]]];
gradY = ImageData[gradBands[[2]]];
gradMagnitude = Image[Sqrt[gradX^2 + gradY^2]];

(* Threshold to find strong edges *)
binaryEdges = Binarize[gradMagnitude, 0.05];

(* Clean up with morphological operations *)
cleanEdges = Closing[Thinning[binaryEdges], 1];

(* Overlay on the NDVI image *)
ndviRaster = GEEComputePixels[fieldBoundaryRegion,
  ndviForEdges // GEEVisualize[<|
    "min" -> 0, "max" -> 0.9,
    "palette" -> {"#8B4513", "#ADFF2F", "#006400"}
  |>],
  "ImageSize" -> 1024];

HighlightImage[ndviRaster, cleanEdges,
  Method -> {"DiskMarker", 1},
  "HighlightColor" -> Red]
```

**Alternative: Using Wolfram's `EdgeDetect`.**

```wolfram
(* Fetch NDVI as a single-channel image *)
ndviGray = GEEComputePixels[fieldBoundaryRegion, ndviForEdges,
  "ImageSize" -> 1024];

(* Apply Canny edge detection *)
edges = EdgeDetect[ndviGray, 2, {0.05, 0.15}];

(* Identify connected components as potential field polygons *)
components = MorphologicalComponents[ColorNegate[edges]];
numFields = Max[components];

Colorize[components,
  PlotLabel -> StringTemplate["Detected `` potential fields"][numFields]]
```

This approach works best during peak growing season when adjacent fields
with different crops show maximum NDVI contrast.

---

## 5.8 Evapotranspiration and Irrigation Scheduling

Evapotranspiration (ET) measures the total water lost from the land surface
through soil evaporation and plant transpiration. It is the single most
important variable for irrigation scheduling because it quantifies actual
crop water consumption.

### 5.8.1 MODIS ET Product

The MODIS MOD16A2 product provides 8-day composite ET at 500 m resolution,
derived from the Penman-Monteith equation using MODIS LAI, albedo, and
meteorological inputs.

```wolfram
irrigatedRegion = {-93.5, 41.7, -93.2, 41.9};
irrigatedGeom = GEEGeometry[irrigatedRegion];

etData = Table[
  Module[{start, end, et, stats},
    start = DateString[DateObject[{2024, 1, 1}] ~DatePlus~ {(i - 1) * 8, "Day"},
      {"Year", "-", "Month", "-", "Day"}];
    end = DateString[DateObject[{2024, 1, 1}] ~DatePlus~ {i * 8, "Day"},
      {"Year", "-", "Month", "-", "Day"}];

    et =
      GEECollection["MODIS/061/MOD16A2"] //
        GEEFilterDate[start, end] //
        GEEFilterBounds[irrigatedRegion] //
        GEEMean //
        GEESelectBands[{"ET"}] //
        GEEMultiply[0.1];  (* Scale factor: 0.1 kg/m^2/8day *)

    stats = GEECompute[
      et // GEEReduceRegion[irrigatedGeom, "mean", 500]
    ];
    {DateObject[{2024, 1, 1}] ~DatePlus~ {(i - 1) * 8 + 4, "Day"},
     stats["ET"]}
  ],
  {i, 1, 46}
];

etTS = TimeSeries[etData[[All, 2]], {etData[[All, 1]]}];

DateListPlot[etTS,
  PlotLabel -> "8-Day Evapotranspiration -- Irrigated Field",
  FrameLabel -> {"Date", "ET (kg/m\[Superscript]2/8-day)"},
  Filling -> Axis,
  PlotTheme -> "Scientific"]
```

### 5.8.2 Irrigation Scheduling Decision Support

A practical irrigation scheduling rule triggers watering when cumulative ET
since the last irrigation event exceeds the soil's readily available water
(RAW), which depends on soil type and root depth.

```wolfram
(* Parameters for a silt loam soil with corn *)
fieldCapacity = 0.33;        (* m^3/m^3 *)
wiltingPoint = 0.13;         (* m^3/m^3 *)
rootDepth = 1.0;             (* meters *)
managementAllowableDepletion = 0.5;

totalAvailableWater = (fieldCapacity - wiltingPoint) * rootDepth * 1000;
  (* mm *)
readilyAvailableWater = totalAvailableWater * managementAllowableDepletion;
  (* mm *)

(* Convert 8-day ET to daily ET (approximate) and accumulate *)
dailyET = etData[[All, 2]] / 8.0;  (* mm/day approximation *)
cumulativeET = Accumulate[Flatten @ Table[
  ConstantArray[dailyET[[i]], 8],
  {i, Length[dailyET]}
]];

(* Find dates when cumulative ET exceeds RAW since last reset *)
irrigationDates = {};
runningET = 0.0;
dayIndex = 0;

Do[
  runningET += dailyET[[i]] * 8;  (* 8-day block *)
  dayIndex += 8;
  If[runningET >= readilyAvailableWater,
    AppendTo[irrigationDates,
      DateObject[{2024, 1, 1}] ~DatePlus~ {dayIndex, "Day"}];
    runningET = 0.0;
  ],
  {i, Length[dailyET]}
];

(* Display recommended irrigation dates *)
Column[{
  StringTemplate["Readily Available Water: `` mm"][
    NumberForm[readilyAvailableWater, 3]],
  StringTemplate["Number of irrigation events: ``"][
    Length[irrigationDates]],
  Grid[{{"Event", "Recommended Date"}} ~Join~
    MapIndexed[{First[#2], DateString[#1, {"Month", "/", "Day"}]} &,
      irrigationDates],
    Frame -> All, Background -> {None, {LightBlue, None}}]
}]
```

### 5.8.3 Crop Water Stress Index from Thermal and Vegetation Data

The Crop Water Stress Index (CWSI) combines canopy temperature (from Landsat
thermal bands) with vegetation cover (NDVI) to detect water stress. Stressed
crops close their stomata, reducing transpiration and raising canopy
temperature.

```wolfram
(* Landsat 9 thermal band and NDVI *)
landsatComposite =
  GEECollection["LANDSAT/LC09/C02/T1_L2"] //
    GEEFilterDate["2024-07-01", "2024-08-01"] //
    GEEFilterBounds[irrigatedRegion] //
    GEEFilterProperty["CLOUD_COVER", "LessThan", 15] //
    GEEMedian;

(* NDVI *)
landsatNDVI = landsatComposite // GEENormalizedDifference[{"SR_B5", "SR_B4"}];

(* Land surface temperature (ST_B10, scale factor 0.00341802, offset 149.0) *)
lst = landsatComposite //
  GEESelectBands[{"ST_B10"}] //
  GEEMultiply[0.00341802] //
  GEEAdd[149.0] //
  GEESubtract[273.15];  (* Convert Kelvin to Celsius *)

(* Combine NDVI and LST into a single image *)
ndviLST = landsatNDVI //
  GEERename[{"NDVI"}] //
  GEEAddBands[lst // GEERename[{"LST"}]];

(* Extract paired NDVI-LST values at sample points *)
sampleGrid = Flatten[
  Table[GeoPosition[{lat, lon}],
    {lat, 41.7, 41.9, 0.01},
    {lon, -93.5, -93.2, 0.01}],
  1];

ndviLSTSamples = GEEGetSamples[sampleGrid, ndviLST];

ndviVals = #["Values"]["NDVI"] & /@ ndviLSTSamples;
lstVals = #["Values"]["LST"] & /@ ndviLSTSamples;

(* NDVI-LST scatter plot: the "triangle" method *)
ListPlot[Transpose[{ndviVals, lstVals}],
  FrameLabel -> {"NDVI", "LST (\[Degree]C)"},
  PlotLabel -> "NDVI-LST Triangle for Water Stress Detection",
  PlotStyle -> {PointSize[0.008], Opacity[0.5]},
  PlotTheme -> "Scientific",
  AspectRatio -> 1]
```

In the NDVI-LST scatter plot, points form a triangular envelope. The upper
edge (hot, vegetated) represents maximum water stress. The lower edge (cool,
vegetated) represents well-watered conditions. Points near the upper edge
indicate fields that need irrigation.

**Computing a pixel-level stress index.**

```wolfram
(* Fit the dry edge (upper boundary) and wet edge (lower boundary) *)
(* For a simplified CWSI: normalize LST between wet and dry edges *)

(* Approximate wet and dry edge temperatures for a given NDVI *)
dryEdgeModel = LinearModelFit[
  Select[Transpose[{ndviVals, lstVals}], #[[2]] > Quantile[lstVals, 0.9] &],
  x, x];

wetEdgeModel = LinearModelFit[
  Select[Transpose[{ndviVals, lstVals}], #[[2]] < Quantile[lstVals, 0.1] &],
  x, x];

(* CWSI = (T_observed - T_wet) / (T_dry - T_wet) *)
(* Values near 0 = no stress, near 1 = severe stress *)
cwsiValues = Table[
  Module[{tDry, tWet},
    tDry = dryEdgeModel[ndviVals[[i]]];
    tWet = wetEdgeModel[ndviVals[[i]]];
    Clip[(lstVals[[i]] - tWet) / (tDry - tWet), {0, 1}]
  ],
  {i, Length[ndviVals]}
];

(* Map CWSI values back to geographic positions *)
GeoListPlot[
  Table[
    Style[sampleGrid[[i]],
      Blend[{Darker[Green], Yellow, Red}, cwsiValues[[i]]]],
    {i, Length[sampleGrid]}
  ],
  PlotLabel -> "Crop Water Stress Index",
  PlotLegends -> BarLegend[{
    (Blend[{Darker[Green], Yellow, Red}, #] &),
    {0, 1}}, LegendLabel -> "CWSI"],
  GeoRange -> {{41.69, 41.91}, {-93.51, -93.19}}]
```

---

## Summary

This chapter demonstrated end-to-end vegetation and agriculture workflows that
combine Google Earth Engine satellite data with Wolfram Language analysis:

| Section | Key Techniques |
|---------|---------------|
| 5.1 Vegetation Indices | `GEENormalizedDifference`, `GEEExpression`, spectral index computation |
| 5.2 Crop Monitoring | `TimeSeries`, `Fourier`, `MovingAverage`, phenology extraction |
| 5.3 Crop Classification | `GEEGetSamples`, `Classify`, `FindClusters`, `ClassifierMeasurements` |
| 5.4 Soil Moisture | Sentinel-1 SAR, `GEEFilterProperty`, irrigation detection |
| 5.5 Yield Estimation | `LinearModelFit`, `Predict`, VRA zone mapping |
| 5.6 Sensor Integration | `Import`, `TimeSeriesResample`, drone/satellite fusion, RTK GPS |
| 5.7 Field Boundaries | `GEEGradient`, `EdgeDetect`, `MorphologicalComponents` |
| 5.8 Evapotranspiration | MODIS ET, irrigation scheduling, CWSI thermal analysis |

The common thread is the composable pipeline pattern: build a GEE expression
with `//` chaining, extract data with `GEEComputePixels`, `GEEGetSamples`, or
`GEEReduceRegion`, then analyze with Wolfram Language functions. This pattern
scales from single-field precision agriculture to regional crop monitoring.

### Key API Functions Used

**Data loading and filtering:** `GEECollection`, `GEEFilterDate`,
`GEEFilterBounds`, `GEEFilterProperty`, `GEESelectBands`, `GEEFirst`

**Aggregation:** `GEEMedian`, `GEEMean`

**Band math:** `GEENormalizedDifference`, `GEEExpression`, `GEEMultiply`,
`GEEAdd`, `GEESubtract`, `GEEDivide`, `GEEAddBands`, `GEERename`

**Masking and logic:** `GEEEquals`, `GEEGreaterThan`, `GEELessThan`,
`GEEUpdateMask`, `GEESelfMask`, `GEEAnd`, `GEEWhere`

**Spatial analysis:** `GEEReduceRegion`, `GEEGeometry`, `GEEGradient`,
`GEEPixelArea`, `GEEClip`

**Visualization:** `GEEVisualize`, `GEEComputePixels`, `GEEImage`

**Point extraction:** `GEEIdentify`, `GEEGetSamples`


---

# Chapter 6: Water Resources and Hydrology

Water is the most dynamic surface feature visible from space. Lakes expand and
contract with the seasons, rivers flood and recede, glaciers retreat decade over
decade, and reservoirs respond to human management decisions in near real time.
Satellite remote sensing provides the only practical means of monitoring these
processes at regional to global scales, and Google Earth Engine hosts the key
datasets -- Sentinel-2 multispectral imagery, Sentinel-1 SAR, MODIS snow
products, CHIRPS rainfall, and the JRC Global Surface Water dataset -- that make
this monitoring possible.

This chapter walks through the full spectrum of hydrological analysis: detecting
water bodies with spectral indices, tracking reservoir storage over time, mapping
floods with radar, monitoring snow and ice, analyzing precipitation patterns, and
estimating water quality from optical imagery. Every example uses the
`GoogleEarthEngineClient` paclet to build server-side processing pipelines and
then brings the results into Wolfram Language for analysis, visualization, and
modeling.

```wolfram
Needs["GoogleEarthEngineClient`"]
GEEConnect["/path/to/service-account-key.json"]
```

---

## 6.1 Water Body Detection

### The Physics of Water in Satellite Imagery

Water has a distinctive spectral signature: it reflects moderately in the visible
green wavelengths and absorbs strongly in the near-infrared (NIR) and
short-wave infrared (SWIR). This contrast is the foundation of every
water-detection index used in remote sensing.

### NDWI -- Normalized Difference Water Index

The NDWI exploits the contrast between green reflectance (Sentinel-2 Band 3) and
NIR absorption (Band 8). Water pixels yield positive NDWI values; vegetation and
soil yield negative values. Note that the same index applied to vegetation canopy
water content is covered in Section 5.1.3; here we focus on surface water
detection.

```wolfram
(* Define a region of interest: Lake Balaton, Hungary *)
bbox = {17.6, 46.7, 18.2, 47.0};

(* Build a cloud-filtered Sentinel-2 composite for summer 2024 *)
s2Composite =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-09-01"] //
    GEEFilterBounds[bbox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEMedian;

(* Compute NDWI: (Green - NIR) / (Green + NIR) *)
ndwi = s2Composite // GEENormalizedDifference[{"B3", "B8"}];

(* Visualize: blue = water (positive), brown = land (negative) *)
ndwiImage = GEEComputePixels[bbox, ndwi,
  "VisParams" -> <|"min" -> -0.5, "max" -> 0.5,
    "palette" -> {"#8B4513", "#FFFFFF", "#0000FF"}|>]
```

To extract only water pixels, threshold at zero and apply a self-mask. Pixels
where NDWI <= 0 are masked out, leaving only water.

```wolfram
waterMask = ndwi //
  GEEGreaterThan[0] //
  GEESelfMask;

waterImage = GEEComputePixels[bbox, waterMask,
  "VisParams" -> <|"min" -> 0, "max" -> 1,
    "palette" -> {"#0000FF"}|>]
```

### MNDWI -- Modified NDWI for Urban Areas

In urban areas, built-up surfaces (concrete, asphalt) can produce false
positives with standard NDWI because they also reflect in the NIR. The Modified
NDWI substitutes SWIR (Band 11) for NIR, which better separates water from
built-up surfaces because SWIR reflectance is higher for dry built-up materials
and lower for water.

```wolfram
(* Region: Bangkok, Thailand -- urban waterways mixed with buildings *)
bkkBox = {100.45, 13.65, 100.65, 13.85};

s2Bangkok =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-01-01", "2024-04-01"] //
    GEEFilterBounds[bkkBox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEEMedian;

(* Standard NDWI *)
ndwiBangkok = s2Bangkok // GEENormalizedDifference[{"B3", "B8"}];

(* Modified NDWI: (Green - SWIR) / (Green + SWIR) *)
mndwiBangkok = s2Bangkok // GEENormalizedDifference[{"B3", "B11"}];

(* Compare side by side *)
ndwiImg = GEEComputePixels[bkkBox, ndwiBangkok,
  "VisParams" -> <|"min" -> -0.5, "max" -> 0.5,
    "palette" -> {"#8B4513", "#FFFFFF", "#0000FF"}|>];

mndwiImg = GEEComputePixels[bkkBox, mndwiBangkok,
  "VisParams" -> <|"min" -> -0.5, "max" -> 0.5,
    "palette" -> {"#8B4513", "#FFFFFF", "#0000FF"}|>];

GraphicsRow[{
  Labeled[Image[ndwiImg, ImageSize -> 400], "NDWI", Top],
  Labeled[Image[mndwiImg, ImageSize -> 400], "MNDWI", Top]
}]
```

In the output, the MNDWI image will show cleaner water boundaries along the Chao
Phraya River, with fewer false positives from adjacent buildings.

### JRC Global Surface Water -- 38 Years of Water History

The JRC Global Surface Water dataset provides a pre-computed, pixel-level
history of surface water occurrence from 1984 to present at 30-meter resolution.
The `occurrence` band encodes the percentage of time each pixel was classified as
water, making it straightforward to separate permanent water bodies from seasonal
or ephemeral ones.

```wolfram
(* JRC Global Surface Water *)
jrcWater = GEELoadImage["JRC/GSW1_4/GlobalSurfaceWater"];

(* Lake Chad region -- dramatic shrinkage over decades *)
chadBox = {13.5, 12.5, 15.5, 14.0};

(* Occurrence band: 0-100 (% of time pixel was water) *)
occurrence = jrcWater // GEESelectBands[{"occurrence"}];

occurrenceImage = GEEComputePixels[chadBox, occurrence,
  "VisParams" -> <|"min" -> 0, "max" -> 100,
    "palette" -> {"#FFFFFF", "#ADD8E6", "#0000FF", "#00008B"}|>]
```

Classify water into permanence categories using threshold logic.

```wolfram
(* Permanent water: present > 80% of the time *)
permanentWater = occurrence //
  GEEGreaterThan[80] //
  GEESelfMask;

(* Seasonal water: present 20-80% of the time *)
seasonalWater = occurrence //
  GEEGreaterThan[20] //
  GEEAnd[occurrence // GEELessThan[80]] //
  GEESelfMask;

(* Seasonality band: number of months water is present per year *)
seasonality = jrcWater // GEESelectBands[{"seasonality"}];

seasonalityImage = GEEComputePixels[chadBox, seasonality,
  "VisParams" -> <|"min" -> 0, "max" -> 12,
    "palette" -> {"#FFFFFF", "#87CEEB", "#4169E1", "#00008B"}|>]
```

### Extracting Water Statistics at a Point

Use `GEEIdentify` to query the JRC dataset at a specific location and retrieve
the occurrence value directly.

```wolfram
(* Query Lake Chad center *)
GEEIdentify[GeoPosition[{13.2, 14.1}], occurrence]

(* Returns: <|"Position" -> ..., "Values" -> <|"occurrence" -> 42|>, ..."|> *)
(* 42% occurrence indicates seasonal/declining water *)
```

---

## 6.2 Reservoir and Lake Monitoring

### Tracking Reservoir Surface Area Over Time

Reservoir surface area is a practical proxy for storage volume. By computing
monthly NDWI composites and counting water pixels, we can build a time series
of reservoir extent.

```wolfram
(* Target: Lake Mead, Nevada/Arizona, USA *)
meadBox = {-114.9, 35.9, -114.3, 36.4};
meadGeom = GEEGeometry[meadBox];

(* Function to compute water area for a single month *)
reservoirAreaForMonth[year_Integer, month_Integer] := Module[
  {startDate, endDate, composite, waterMask, areaImage, stats},

  startDate = DateString[{year, month, 1}, "ISODate"];
  endDate = DateString[DatePlus[{year, month, 1}, {1, "Month"}], "ISODate"];

  (* Monthly Sentinel-2 composite *)
  composite =
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
      GEEFilterDate[startDate, endDate] //
      GEEFilterBounds[meadBox] //
      GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 30] //
      GEEMedian;

  (* NDWI water mask *)
  waterMask = composite //
    GEENormalizedDifference[{"B3", "B8"}] //
    GEEGreaterThan[0] //
    GEESelfMask;

  (* Multiply water mask by pixel area, then sum *)
  areaImage = waterMask // GEEMultiply[GEEPixelArea[]];

  stats = GEECompute[
    areaImage // GEEReduceRegion[meadGeom, "sum", 30]
  ];

  (* Return date and area in km^2 *)
  {DateObject[{year, month, 1}],
   Lookup[stats, "nd", 0] / 1.0*^6}
]
```

Build a multi-year time series and visualize.

```wolfram
(* Compute monthly areas from 2020 through 2024 *)
monthlyData = Flatten[
  Table[
    reservoirAreaForMonth[y, m],
    {y, 2020, 2024}, {m, 1, 12}
  ] // DeleteCases[{_, 0 | 0.}],
  1
];

(* Build a TimeSeries and plot *)
areaSeries = TimeSeries[monthlyData];

DateListPlot[areaSeries,
  PlotLabel -> "Lake Mead Surface Area (2020-2024)",
  FrameLabel -> {"Date", "Surface Area (km\[Superscript]2)"},
  PlotStyle -> Blue,
  Filling -> Axis,
  FillingStyle -> Directive[Opacity[0.2], Blue],
  GridLines -> Automatic,
  ImageSize -> Large]
```

### Before/After Drought Comparison

A direct visual comparison between wet and dry periods can be more compelling
than a time series chart. Here we compare Lake Mead in a wet year versus a
drought year.

```wolfram
(* Wet period: spring 2019 *)
wetComposite =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2019-04-01", "2019-07-01"] //
    GEEFilterBounds[meadBox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEEMedian;

wetWater = wetComposite //
  GEENormalizedDifference[{"B3", "B8"}] //
  GEEGreaterThan[0] //
  GEESelfMask;

(* Dry period: summer 2022 (historic low) *)
dryComposite =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2022-06-01", "2022-09-01"] //
    GEEFilterBounds[meadBox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEEMedian;

dryWater = dryComposite //
  GEENormalizedDifference[{"B3", "B8"}] //
  GEEGreaterThan[0] //
  GEESelfMask;

(* Render both *)
visPar = <|"min" -> 0, "max" -> 1, "palette" -> {"#0000FF"}|>;

wetImg = GEEComputePixels[meadBox, wetWater, "VisParams" -> visPar];
dryImg = GEEComputePixels[meadBox, dryWater, "VisParams" -> visPar];

GraphicsRow[{
  Labeled[Image[wetImg, ImageSize -> 400], "Spring 2019", Top],
  Labeled[Image[dryImg, ImageSize -> 400], "Summer 2022", Top]
}, Spacings -> 20]
```

### Overlay on a Basemap with GEEGeoGraphics

`GEEGeoGraphics` renders GEE imagery as a background layer with geographic
primitives drawn on top, making it easy to annotate water features.

```wolfram
GEEGeoGraphics[
  {EdgeForm[Red], FaceForm[None],
   Rectangle @@ (GeoPosition /@ {{35.9, -114.9}, {36.4, -114.3}})},
  dryWater,
  GeoRange -> {{35.85, 36.45}, {-114.95, -114.25}},
  "VisParams" -> <|"min" -> 0, "max" -> 1,
    "palette" -> {"#0066CC"}|>,
  ImageSize -> 600]
```

---

## 6.3 Flood Mapping

### SAR-Based Flood Detection

Synthetic Aperture Radar (Sentinel-1) is the workhorse of flood mapping because
it operates at microwave wavelengths that penetrate clouds and work day or night.
For an introduction to Sentinel-1 SAR imagery and dual-polarization composites,
see Section 2.5 (Sentinel-1 SAR). Over calm floodwater, the radar signal reflects
away from the sensor (specular reflection), producing a characteristic drop in
backscatter. This drop -- typically 3 dB or more in the VV polarization -- is the
primary signal for flood detection.

```wolfram
(* Example: Emilia-Romagna floods, Italy, May 2023 *)
floodBox = {11.8, 44.1, 12.4, 44.5};

(* Pre-flood baseline: January 2023 *)
preSAR =
  GEECollection["COPERNICUS/S1_GRD"] //
    GEEFilterDate["2023-01-01", "2023-02-01"] //
    GEEFilterBounds[floodBox] //
    GEEFilterProperty["instrumentMode", "Equals", "IW"] //
    GEESelectBands[{"VV"}] //
    GEEMedian;

(* Post-flood: May 2023 *)
postSAR =
  GEECollection["COPERNICUS/S1_GRD"] //
    GEEFilterDate["2023-05-15", "2023-05-25"] //
    GEEFilterBounds[floodBox] //
    GEEFilterProperty["instrumentMode", "Equals", "IW"] //
    GEESelectBands[{"VV"}] //
    GEEMedian;

(* SAR backscatter change (dB) *)
sarChange = GEESubtract[postSAR, preSAR];

(* Visualize the change: red = decrease (flooding), blue = increase *)
changeImage = GEEComputePixels[floodBox, sarChange,
  "VisParams" -> <|"min" -> -10, "max" -> 10,
    "palette" -> {"#FF0000", "#FFFFFF", "#0000FF"}|>]
```

### Thresholding to Extract Flood Extent

A backscatter decrease of 3 dB or more is a conservative threshold for
identifying flooded pixels. This threshold is physically motivated: specular
reflection from still water surfaces causes a sharp drop in received power.

```wolfram
(* Identify flooded pixels: backscatter dropped by more than 3 dB *)
floodMask = sarChange //
  GEELessThan[-3] //
  GEESelfMask;

floodImage = GEEComputePixels[floodBox, floodMask,
  "VisParams" -> <|"min" -> 0, "max" -> 1,
    "palette" -> {"#FF4444"}|>]
```

### Computing Flood Extent Area

Multiply the binary flood mask by pixel area and sum over the region to get
the total flooded area in square meters, then convert to square kilometers.

```wolfram
floodGeom = GEEGeometry[floodBox];

floodAreaImage = floodMask // GEEMultiply[GEEPixelArea[]];

floodStats = GEECompute[
  floodAreaImage // GEEReduceRegion[floodGeom, "sum", 10]
];

floodAreaKm2 = Lookup[floodStats, "VV", 0] / 1.0*^6;

(* Display with proper units *)
Quantity[floodAreaKm2, "Kilometers"^2]
```

### Overlay Flood Extent on a Basemap

Combining flood detection results with Wolfram Language's built-in geographic
visualization creates publication-quality maps.

```wolfram
(* Retrieve flood extent as a geo-tagged image *)
floodGeoImg = GEEImage[
  GeoPosition[{44.3, 12.1}],
  floodMask,
  GeoRange -> Quantity[30, "Kilometers"],
  "VisParams" -> <|"min" -> 0, "max" -> 1,
    "palette" -> {"#FF0000"}|>];

(* Overlay on GeoGraphics basemap *)
Show[
  GeoGraphics[
    GeoRange -> {{44.1, 44.5}, {11.8, 12.4}},
    GeoBackground -> "StreetMap",
    ImageSize -> 600],
  Graphics[Inset[floodGeoImg, Center, Center, Scaled[1]]]
]
```

Alternatively, use `GEEGeoGraphics` to render the flood extent directly on a
GEE-sourced background.

```wolfram
GEEGeoGraphics[
  {Opacity[0.5], Red,
   Text["Flood Extent", GeoPosition[{44.3, 12.1}]]},
  floodMask,
  GeoRange -> {{44.1, 44.5}, {11.8, 12.4}},
  "VisParams" -> <|"min" -> 0, "max" -> 1,
    "palette" -> {"#FF4444"}|>,
  ImageSize -> 600]
```

---

## 6.4 Snow and Ice

### MODIS Daily Snow Cover

The MODIS MOD10A1 product provides daily snow cover at 500-meter resolution. The
`NDSI_Snow_Cover` band uses the Normalized Difference Snow Index, which exploits
the high visible reflectance and low SWIR reflectance of snow. Values range from
0 to 100, with values above ~40 indicating snow-covered pixels.

```wolfram
(* Snow cover over the European Alps, mid-winter 2024 *)
alpsBox = {6.0, 45.5, 13.0, 47.5};

snowCover =
  GEECollection["MODIS/061/MOD10A1"] //
    GEEFilterDate["2024-01-15", "2024-01-25"] //
    GEEFilterBounds[alpsBox] //
    GEESelectBands[{"NDSI_Snow_Cover"}] //
    GEEMedian;

snowImage = GEEComputePixels[alpsBox, snowCover,
  "VisParams" -> <|"min" -> 0, "max" -> 100,
    "palette" -> {"#000000", "#87CEEB", "#FFFFFF"}|>]
```

### Snow Cover Time Series -- Tracking Seasonal Snowpack

Monitoring the seasonal evolution of snow cover area is critical for water
resource forecasting. Mountain snowpack acts as a natural reservoir, and its
spring melt drives downstream water supply.

```wolfram
(* Compute snow-covered area for a given date range *)
snowAreaForPeriod[startDate_String, endDate_String, region_,
  regionGeom_] := Module[
  {composite, snowMask, areaImage, stats},

  composite =
    GEECollection["MODIS/061/MOD10A1"] //
      GEEFilterDate[startDate, endDate] //
      GEEFilterBounds[region] //
      GEESelectBands[{"NDSI_Snow_Cover"}] //
      GEEMean;

  (* Snow where NDSI > 40 *)
  snowMask = composite //
    GEEGreaterThan[40] //
    GEESelfMask;

  areaImage = snowMask // GEEMultiply[GEEPixelArea[]];

  stats = GEECompute[
    areaImage // GEEReduceRegion[regionGeom, "sum", 500]
  ];

  Lookup[stats, "NDSI_Snow_Cover", 0] / 1.0*^6
]
```

Build a monthly time series for one water year (October through September).

```wolfram
alpsGeom = GEEGeometry[alpsBox];

(* Water year 2023-2024 *)
months = Flatten[{
  Table[{2023, m}, {m, 10, 12}],
  Table[{2024, m}, {m, 1, 9}]
}, 1];

snowData = Table[
  Module[{start, end, area},
    start = DateString[{yr, mo, 1}, "ISODate"];
    end = DateString[DatePlus[{yr, mo, 1}, {1, "Month"}], "ISODate"];
    area = snowAreaForPeriod[start, end, alpsBox, alpsGeom];
    {DateObject[{yr, mo, 15}], area}
  ],
  {{yr, mo}, months}
];

snowSeries = TimeSeries[snowData];

DateListPlot[snowSeries,
  PlotLabel -> "Alps Snow Cover Area (Water Year 2023-2024)",
  FrameLabel -> {"Date", "Snow Area (km\[Superscript]2)"},
  PlotStyle -> Directive[Thick, RGBColor[0.3, 0.5, 0.9]],
  Filling -> Axis,
  FillingStyle -> Directive[Opacity[0.15], Blue],
  GridLines -> Automatic,
  ImageSize -> Large]
```

### Glacier Extent Mapping with Sentinel-2

The Normalized Difference Snow Index (NDSI) can also delineate glacier
boundaries. For glaciers, we use Sentinel-2 at 10/20-meter resolution for
sharper boundaries than MODIS. The NDSI formula uses Green (B3) and SWIR (B11),
the same band combination as MNDWI but interpreted differently in the context of
cryospheric mapping.

```wolfram
(* Aletsch Glacier, Switzerland *)
glacierBox = {7.95, 46.38, 8.15, 46.52};

s2Glacier =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-07-01", "2024-09-01"] //
    GEEFilterBounds[glacierBox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEMedian;

(* NDSI for snow/ice *)
ndsi = s2Glacier // GEENormalizedDifference[{"B3", "B11"}];

(* Glacier pixels: NDSI > 0.4 *)
glacierMask = ndsi //
  GEEGreaterThan[0.4] //
  GEESelfMask;

(* True-color background *)
rgbImg = GEEComputePixels[glacierBox,
  s2Glacier // GEESelectBands[{"B4", "B3", "B2"}],
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>];

(* Glacier mask overlay *)
glacierImg = GEEComputePixels[glacierBox, glacierMask,
  "VisParams" -> <|"min" -> 0, "max" -> 1,
    "palette" -> {"#00FFFF"}|>];

GraphicsRow[{
  Labeled[Image[rgbImg, ImageSize -> 400], "True Color", Top],
  Labeled[Image[glacierImg, ImageSize -> 400], "Glacier Extent (NDSI > 0.4)", Top]
}]
```

### Multi-Year Glacier Retreat Analysis

Compare glacier extent across multiple years to quantify retreat.

```wolfram
glacierGeom = GEEGeometry[glacierBox];

glacierAreaForYear[year_Integer] := Module[
  {startDate, endDate, composite, ndsiImg, mask, areaImg, stats},

  startDate = ToString[year] <> "-07-01";
  endDate = ToString[year] <> "-09-30";

  composite =
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
      GEEFilterDate[startDate, endDate] //
      GEEFilterBounds[glacierBox] //
      GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
      GEEMedian;

  ndsiImg = composite // GEENormalizedDifference[{"B3", "B11"}];
  mask = ndsiImg // GEEGreaterThan[0.4] // GEESelfMask;
  areaImg = mask // GEEMultiply[GEEPixelArea[]];

  stats = GEECompute[
    areaImg // GEEReduceRegion[glacierGeom, "sum", 20]
  ];

  Lookup[stats, "nd", 0] / 1.0*^6
]

(* Compute glacier area for each summer from 2017 to 2024 *)
years = Range[2017, 2024];
glacierAreas = AssociationThread[years, glacierAreaForYear /@ years];

(* Bar chart of glacier extent *)
BarChart[Values[glacierAreas],
  ChartLabels -> Keys[glacierAreas],
  PlotLabel -> "Aletsch Glacier Summer Extent",
  AxesLabel -> {None, "Area (km\[Superscript]2)"},
  ChartStyle -> RGBColor[0.3, 0.7, 0.9],
  ImageSize -> Large]
```

---

## 6.5 Precipitation and Runoff

### CHIRPS Daily Rainfall

CHIRPS (Climate Hazards Group InfraRed Precipitation with Station data) provides
daily rainfall estimates at ~5.5 km resolution from 1981 to near-present. It
combines satellite infrared data with station observations, making it one of the
most widely used precipitation products for hydrological modeling. For a broader
treatment of CHIRPS including rainfall anomalies, trend analysis, and comparison
with GPM IMERG, see Section 3.2.

```wolfram
(* Define a watershed: Tana River basin, Kenya *)
tanaCoords = {
  {39.5, -1.0}, {40.5, -1.0}, {40.5, -2.5},
  {39.0, -3.5}, {38.0, -2.0}, {39.5, -1.0}
};
tanaPolygon = GEEPolygon[tanaCoords];

(* Monthly rainfall accumulation for January 2024 *)
janRain =
  GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
    GEEFilterDate["2024-01-01", "2024-02-01"] //
    GEEFilterBounds[{38.0, -3.5, 40.5, -1.0}] //
    GEECollectionSum //
    GEEClip[tanaPolygon];

rainImage = GEEComputePixels[{38.0, -3.5, 40.5, -1.0}, janRain,
  "VisParams" -> <|"min" -> 0, "max" -> 200,
    "palette" -> {"#FFFFCC", "#41B6C4", "#0C2C84"}|>]
```

### Annual Rainfall Accumulation

```wolfram
(* Annual rainfall for 2023 *)
annualRain =
  GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFilterBounds[{38.0, -3.5, 40.5, -1.0}] //
    GEECollectionSum //
    GEEClip[tanaPolygon];

(* Mean rainfall over the watershed *)
meanRainfall = GEECompute[
  annualRain // GEEReduceRegion[tanaPolygon, "mean", 5000]
];

(* Result in mm *)
annualMeanMm = Lookup[meanRainfall, "precipitation", Missing[]];

(* Convert to total volume over watershed *)
(* First compute watershed area *)
watershedAreaM2 = GEECompute[GEEArea[tanaPolygon]];

(* Rainfall depth (mm) -> volume (m^3) *)
totalVolumeM3 = Quantity[annualMeanMm, "Millimeters"] *
  Quantity[watershedAreaM2, "Meters"^2] //
  UnitConvert[#, "Meters"^3] &
```

### Monthly Rainfall Time Series

Extract a multi-year monthly rainfall series for trend analysis.

```wolfram
monthlyRainfall[year_Integer, month_Integer] := Module[
  {startDate, endDate, monthlySum, stats},

  startDate = DateString[{year, month, 1}, "ISODate"];
  endDate = DateString[DatePlus[{year, month, 1}, {1, "Month"}], "ISODate"];

  monthlySum =
    GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
      GEEFilterDate[startDate, endDate] //
      GEEFilterBounds[{38.0, -3.5, 40.5, -1.0}] //
      GEECollectionSum //
      GEEClip[tanaPolygon];

  stats = GEECompute[
    monthlySum // GEEReduceRegion[tanaPolygon, "mean", 5000]
  ];

  {DateObject[{year, month, 15}],
   Lookup[stats, "precipitation", 0]}
]

(* Build 5-year series *)
rainData = Flatten[
  Table[monthlyRainfall[y, m], {y, 2019, 2023}, {m, 1, 12}],
  1
];

rainSeries = TimeSeries[rainData];

DateListPlot[rainSeries,
  PlotLabel -> "Tana River Basin Monthly Rainfall (2019-2023)",
  FrameLabel -> {"Date", "Rainfall (mm)"},
  Filling -> Axis,
  PlotStyle -> Directive[Thick, RGBColor[0.2, 0.4, 0.8]],
  FillingStyle -> Directive[Opacity[0.2], Blue],
  ImageSize -> Large]
```

### Rainfall-Runoff Relationship

Compare satellite-derived rainfall with observed streamflow to build a simple
rainfall-runoff model. Streamflow data can be imported from a CSV file (e.g.,
from a national hydrological service).

```wolfram
(* Import observed monthly streamflow (m^3/s) *)
streamflowData = Import[
  "data/tana_streamflow_monthly.csv", "Dataset",
  HeaderLines -> 1
];

(* Extract matching monthly rainfall from our series *)
rainfallValues = rainSeries["Values"];
streamflowValues = Normal[streamflowData[All, "Discharge_m3s"]];

(* Ensure same length *)
nMonths = Min[Length[rainfallValues], Length[streamflowValues]];
rain = rainfallValues[[;;nMonths]];
flow = streamflowValues[[;;nMonths]];

(* Fit a linear model: Q = a * P + b *)
model = LinearModelFit[
  Transpose[{rain, flow}],
  x, x
];

(* Display the model *)
model["BestFit"]
model["RSquared"]

(* Scatter plot with regression line *)
Show[
  ListPlot[Transpose[{rain, flow}],
    PlotStyle -> PointSize[0.015],
    AxesLabel -> {"Monthly Rainfall (mm)", "Streamflow (m\[Superscript]3/s)"},
    PlotLabel -> "Rainfall-Runoff Relationship"],
  Plot[model[x], {x, 0, Max[rain]},
    PlotStyle -> Directive[Red, Thick]]
]
```

---

## 6.6 Water Quality Indicators

### Turbidity Estimation from Sentinel-2

Turbidity -- the cloudiness of water caused by suspended sediments -- correlates
strongly with red-band reflectance. Clear water absorbs red light, while
sediment-laden water reflects it. The red band (B4) of Sentinel-2 provides a
simple but effective turbidity proxy at 10-meter resolution.

```wolfram
(* Target: Chesapeake Bay after a storm event *)
bayBox = {-76.5, 37.0, -75.8, 37.6};

s2Bay =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-09-01", "2024-10-01"] //
    GEEFilterBounds[bayBox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
    GEEMedian;

(* Extract red band as turbidity proxy *)
redBand = s2Bay // GEESelectBands[{"B4"}];

(* Mask land using NDWI *)
waterMask = s2Bay //
  GEENormalizedDifference[{"B3", "B8"}] //
  GEEGreaterThan[0];

(* Apply water mask to red band *)
turbidity = redBand // GEEUpdateMask[waterMask];

turbidityImage = GEEComputePixels[bayBox, turbidity,
  "VisParams" -> <|"min" -> 0, "max" -> 1500,
    "palette" -> {"#0000FF", "#00FF00", "#FFFF00", "#FF0000"}|>]
```

### Chlorophyll-a and Algal Bloom Detection

Chlorophyll-a concentration correlates with the ratio of green to blue
reflectance. Elevated green-to-blue ratios indicate higher phytoplankton
density, which can signal harmful algal blooms in lakes and reservoirs.

```wolfram
(* Target: Lake Erie -- prone to harmful algal blooms *)
erieBox = {-83.5, 41.3, -82.5, 42.0};

s2Erie =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-07-01", "2024-09-01"] //
    GEEFilterBounds[erieBox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEEMedian;

(* Green/Blue band ratio as chlorophyll-a proxy *)
greenBand = s2Erie // GEESelectBands[{"B3"}];
blueBand = s2Erie // GEESelectBands[{"B2"}];

chlRatio = GEEDivide[greenBand, blueBand];

(* Mask to water only *)
erieWaterMask = s2Erie //
  GEENormalizedDifference[{"B3", "B8"}] //
  GEEGreaterThan[0];

chlWater = chlRatio // GEEUpdateMask[erieWaterMask];

chlImage = GEEComputePixels[erieBox, chlWater,
  "VisParams" -> <|"min" -> 0.8, "max" -> 2.5,
    "palette" -> {"#0000FF", "#00FF00", "#FFFF00", "#FF0000"}|>]
```

### Algal Bloom Area Estimation

```wolfram
(* Define bloom threshold: green/blue ratio > 1.5 *)
bloomMask = chlWater //
  GEEGreaterThan[1.5] //
  GEESelfMask;

bloomArea = bloomMask // GEEMultiply[GEEPixelArea[]];

erieGeom = GEEGeometry[erieBox];
bloomStats = GEECompute[
  bloomArea // GEEReduceRegion[erieGeom, "sum", 20]
];

bloomAreaKm2 = Lookup[bloomStats, "B3", 0] / 1.0*^6;
Print["Estimated bloom area: ", Quantity[bloomAreaKm2, "Kilometers"^2]]
```

### Color Analysis of Retrieved Water Imagery

Wolfram Language's image processing functions can extract additional information
from the retrieved satellite imagery on the client side.

```wolfram
(* Retrieve true-color image of Lake Erie *)
erieRGB = GEEImage[
  GeoPosition[{41.7, -83.0}],
  s2Erie // GEESelectBands[{"B4", "B3", "B2"}],
  GeoRange -> Quantity[50, "Kilometers"],
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>];

(* Extract dominant colors -- green tints indicate algae *)
DominantColors[erieRGB, 5]

(* Measure how "green" the water is using color distance *)
greenRef = RGBColor[0.2, 0.5, 0.2]; (* algal green *)
blueRef = RGBColor[0.1, 0.2, 0.5]; (* clean water blue *)

pixels = ImageData[erieRGB];
greenDist = Map[ColorDistance[RGBColor @@ #, greenRef] &, pixels, {2}];
blueDist = Map[ColorDistance[RGBColor @@ #, blueRef] &, pixels, {2}];

(* Ratio image: low values = more green (potential algae) *)
ratioImg = Image[greenDist / (blueDist + 0.01)];
Labeled[ratioImg, "Green/Blue Color Distance Ratio"]
```

---

## 6.7 Wetland Mapping

### Multi-Index Wetland Classification

Wetlands occupy the boundary between terrestrial and aquatic systems. They
support dense vegetation (high NDVI) while maintaining high soil moisture or
standing water (moderate NDWI). A combination of spectral indices can
distinguish wetlands from pure water bodies and dry land.

```wolfram
(* Target: Okavango Delta, Botswana *)
okBox = {22.0, -20.0, 24.0, -18.5};

s2Okavango =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-03-01", "2024-06-01"] //
    GEEFilterBounds[okBox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEEMedian;

(* Compute indices *)
ndvi = s2Okavango // GEENormalizedDifference[{"B8", "B4"}];
ndwi = s2Okavango // GEENormalizedDifference[{"B3", "B8"}];
mndwi = s2Okavango // GEENormalizedDifference[{"B3", "B11"}];
```

Apply classification rules to separate water, wetland, and dryland.

```wolfram
(* Open water: NDWI > 0.3 *)
openWater = ndwi //
  GEEGreaterThan[0.3] //
  GEESelfMask;

(* Wetland vegetation: NDVI > 0.2 AND NDWI > -0.1 *)
wetlandVeg = GEEAnd[
  ndvi // GEEGreaterThan[0.2],
  ndwi // GEEGreaterThan[-0.1]
] // GEESelfMask;

(* Build a classified image using GEEWhere *)
(* Start with a constant image of 0 (unclassified) *)
classified = GEEConstant[0] //
  GEEWhere[ndwi // GEEGreaterThan[-0.1], 1] //   (* moist soil *)
  GEEWhere[wetlandVeg, 2] //                       (* wetland *)
  GEEWhere[openWater, 3];                          (* open water *)

classImage = GEEComputePixels[okBox, classified,
  "VisParams" -> <|"min" -> 0, "max" -> 3,
    "palette" -> {"#D2B48C", "#90EE90", "#006400", "#0000FF"}|>]
```

The resulting image shows four classes: dry land (tan), moist soil (light
green), wetland vegetation (dark green), and open water (blue).

### Wetland Area by Class

```wolfram
okGeom = GEEGeometry[okBox];

(* Area for each class *)
wetlandClasses = Association @@ Table[
  Module[{mask, areaImg, stats},
    mask = classified // GEEEquals[classVal] // GEESelfMask;
    areaImg = mask // GEEMultiply[GEEPixelArea[]];
    stats = GEECompute[
      areaImg // GEEReduceRegion[okGeom, "sum", 30]
    ];
    className -> Lookup[stats, "constant", 0] / 1.0*^6
  ],
  {{classVal, className},
   {{1, "Moist Soil"}, {2, "Wetland"}, {3, "Open Water"}}}
];

(* Display as a Dataset *)
Dataset[wetlandClasses]

(* Pie chart *)
PieChart[Values[wetlandClasses],
  ChartLabels -> Keys[wetlandClasses],
  ChartStyle -> {"LightGreen", "DarkGreen", "Blue"},
  PlotLabel -> "Okavango Delta Land Cover (km\[Superscript]2)",
  ImageSize -> 400]
```

### ESA WorldCover Wetland Extraction

The ESA WorldCover product provides a global land cover map at 10-meter
resolution. Class 90 corresponds to herbaceous wetlands.

```wolfram
(* ESA WorldCover 2021 *)
worldCover = GEELoadImage["ESA/WorldCover/v200/2021"];

(* Extract wetland class (value = 90) *)
wetlands = worldCover //
  GEESelectBands[{"Map"}] //
  GEEEquals[90] //
  GEESelfMask;

wetlandImg = GEEComputePixels[okBox, wetlands,
  "VisParams" -> <|"min" -> 0, "max" -> 1,
    "palette" -> {"#006400"}|>]

(* Compute wetland area *)
wetlandArea = wetlands // GEEMultiply[GEEPixelArea[]];
wetlandStats = GEECompute[
  wetlandArea // GEEReduceRegion[okGeom, "sum", 10]
];

Quantity[Lookup[wetlandStats, "Map", 0] / 1.0*^6, "Kilometers"^2]
```

---

## 6.8 Watershed-Scale Analysis

### Building a Water Budget

A watershed water budget balances inputs (precipitation) against outputs
(evapotranspiration, runoff, groundwater recharge). At the simplest level:

    Net Water = Precipitation - Evapotranspiration

We can compute both terms from satellite data: CHIRPS for precipitation and
MODIS MOD16A2 for evapotranspiration (ET).

```wolfram
(* Define a watershed: Upper Blue Nile Basin, Ethiopia *)
nileCoords = {
  {37.0, 8.0}, {40.0, 8.0}, {40.0, 12.0},
  {37.5, 13.0}, {35.5, 12.0}, {35.5, 9.0}, {37.0, 8.0}
};
nilePolygon = GEEPolygon[nileCoords];
nileBbox = {35.5, 8.0, 40.0, 13.0};

(* Monthly water budget for 2023 *)
waterBudgetMonth[year_Integer, month_Integer] := Module[
  {startDate, endDate, precip, et, precipStats, etStats, pMm, etMm},

  startDate = DateString[{year, month, 1}, "ISODate"];
  endDate = DateString[DatePlus[{year, month, 1}, {1, "Month"}], "ISODate"];

  (* CHIRPS precipitation (mm/day -> mm/month via sum) *)
  precip =
    GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
      GEEFilterDate[startDate, endDate] //
      GEEFilterBounds[nileBbox] //
      GEECollectionSum //
      GEEClip[nilePolygon];

  precipStats = GEECompute[
    precip // GEEReduceRegion[nilePolygon, "mean", 5000]
  ];

  (* MODIS ET (kg/m^2/8day -> sum and scale) *)
  et =
    GEECollection["MODIS/061/MOD16A2GF"] //
      GEEFilterDate[startDate, endDate] //
      GEEFilterBounds[nileBbox] //
      GEESelectBands[{"ET"}] //
      GEECollectionSum //
      GEEMultiply[0.1] //   (* Scale factor: 0.1 kg/m^2 = 0.1 mm *)
      GEEClip[nilePolygon];

  etStats = GEECompute[
    et // GEEReduceRegion[nilePolygon, "mean", 500]
  ];

  pMm = Lookup[precipStats, "precipitation", 0];
  etMm = Lookup[etStats, "ET", 0];

  <|
    "Month" -> DateObject[{year, month, 1}, "Month"],
    "Precipitation_mm" -> pMm,
    "ET_mm" -> etMm,
    "NetWater_mm" -> pMm - etMm
  |>
]
```

Build the full annual water budget.

```wolfram
budgetData = Table[
  waterBudgetMonth[2023, m],
  {m, 1, 12}
];

budgetDS = Dataset[budgetData];

(* Display the table *)
budgetDS[All, {"Month", "Precipitation_mm", "ET_mm", "NetWater_mm"}]
```

### Visualizing the Water Budget

```wolfram
(* Extract columns for plotting *)
months = Normal[budgetDS[All, "Month"]];
precip = Normal[budgetDS[All, "Precipitation_mm"]];
et = Normal[budgetDS[All, "ET_mm"]];
netWater = Normal[budgetDS[All, "NetWater_mm"]];

DateListPlot[
  {TimeSeries[Transpose[{months, precip}]],
   TimeSeries[Transpose[{months, et}]],
   TimeSeries[Transpose[{months, netWater}]]},
  PlotLegends -> {"Precipitation", "ET", "Net (P - ET)"},
  PlotLabel -> "Upper Blue Nile Water Budget (2023)",
  FrameLabel -> {"Month", "Water Depth (mm)"},
  PlotStyle -> {Blue, Red, Directive[Thick, Darker[Green]]},
  Filling -> {3 -> Axis},
  FillingStyle -> Directive[Opacity[0.1], Green],
  GridLines -> Automatic,
  ImageSize -> Large]
```

### Volume Conversion with Wolfram Units

Convert the water budget from depth (mm) to volume (cubic meters) using the
watershed area and Wolfram Language's unit system.

```wolfram
(* Compute watershed area *)
watershedAreaM2 = GEECompute[GEEArea[nilePolygon]];

(* Annual totals *)
annualPrecipMm = Total[precip];
annualETMm = Total[et];
annualNetMm = annualPrecipMm - annualETMm;

(* Convert: mm over area -> m^3 *)
volumeConvert[depthMm_, areaM2_] :=
  UnitConvert[
    Quantity[depthMm, "Millimeters"] * Quantity[areaM2, "Meters"^2],
    "Meters"^3
  ]

annualPrecipVol = volumeConvert[annualPrecipMm, watershedAreaM2];
annualETVol = volumeConvert[annualETMm, watershedAreaM2];
annualNetVol = volumeConvert[annualNetMm, watershedAreaM2];

(* Summary *)
Dataset[<|
  "Annual Precipitation" -> UnitConvert[annualPrecipVol, "Kilometers"^3],
  "Annual ET" -> UnitConvert[annualETVol, "Kilometers"^3],
  "Net Water Availability" -> UnitConvert[annualNetVol, "Kilometers"^3]
|>]
```

### Spatial P-ET Map

Instead of basin-average values, compute the spatial pattern of P - ET to
identify which sub-regions generate the most runoff.

```wolfram
(* Annual precipitation *)
annualP =
  GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFilterBounds[nileBbox] //
    GEECollectionSum //
    GEEClip[nilePolygon];

(* Annual ET *)
annualET =
  GEECollection["MODIS/061/MOD16A2GF"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFilterBounds[nileBbox] //
    GEESelectBands[{"ET"}] //
    GEECollectionSum //
    GEEMultiply[0.1] //
    GEEClip[nilePolygon];

(* Spatial net water = P - ET *)
netWaterMap = GEESubtract[annualP, annualET];

netWaterImage = GEEComputePixels[nileBbox, netWaterMap,
  "VisParams" -> <|"min" -> -200, "max" -> 1000,
    "palette" -> {"#FF0000", "#FFFF00", "#00FF00", "#0000FF"}|>]
```

Red areas experience water deficit (ET exceeds P); blue areas produce surplus
water that becomes runoff or groundwater recharge.

---

## 6.9 Putting It All Together: Integrated Watershed Assessment

This section combines techniques from throughout the chapter into a single
watershed assessment workflow.

```wolfram
(* Target: Mekong Delta, Vietnam *)
mekongBox = {105.0, 9.0, 107.0, 11.0};
mekongCoords = {
  {105.0, 9.0}, {107.0, 9.0}, {107.0, 11.0},
  {105.0, 11.0}, {105.0, 9.0}
};
mekongPoly = GEEPolygon[mekongCoords];
mekongGeom = GEEGeometry[mekongBox];
```

### Step 1: Map Current Water Bodies

```wolfram
s2Mekong =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-01-01", "2024-04-01"] //
    GEEFilterBounds[mekongBox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEEMedian;

mekongNDWI = s2Mekong // GEENormalizedDifference[{"B3", "B8"}];
mekongWater = mekongNDWI // GEEGreaterThan[0] // GEESelfMask;

(* Water area *)
waterAreaImg = mekongWater // GEEMultiply[GEEPixelArea[]];
waterStats = GEECompute[
  waterAreaImg // GEEReduceRegion[mekongGeom, "sum", 10]
];

mekongWaterKm2 = Lookup[waterStats, "nd", 0] / 1.0*^6;
```

### Step 2: Seasonal Precipitation

```wolfram
mekongPrecip =
  GEECollection["UCSB-CHG/CHIRPS/DAILY"] //
    GEEFilterDate["2023-01-01", "2024-01-01"] //
    GEEFilterBounds[mekongBox] //
    GEECollectionSum //
    GEEClip[mekongPoly];

precipMean = GEECompute[
  mekongPrecip // GEEReduceRegion[mekongPoly, "mean", 5000]
];
```

### Step 3: Land Cover Composition

```wolfram
mekongLC = GEELoadImage["ESA/WorldCover/v200/2021"] //
  GEESelectBands[{"Map"}] //
  GEEClip[mekongPoly];

(* Extract specific classes *)
classAreas = Association @@ Table[
  Module[{mask, areaImg, stats},
    mask = mekongLC // GEEEquals[classVal] // GEESelfMask;
    areaImg = mask // GEEMultiply[GEEPixelArea[]];
    stats = GEECompute[
      areaImg // GEEReduceRegion[mekongGeom, "sum", 10]
    ];
    className -> Lookup[stats, "Map", 0] / 1.0*^6
  ],
  {{classVal, className}, {
    {10, "Tree Cover"}, {20, "Shrubland"}, {30, "Grassland"},
    {40, "Cropland"}, {50, "Built-up"}, {60, "Bare"},
    {80, "Water"}, {90, "Wetland"}, {95, "Mangroves"}
  }}
];

Dataset[classAreas]
```

### Step 4: Water Quality Assessment

```wolfram
(* Turbidity proxy across the delta waterways *)
mekongRedBand = s2Mekong // GEESelectBands[{"B4"}];
mekongTurbidity = mekongRedBand // GEEUpdateMask[mekongWater];

(* Sample turbidity at key locations *)
samplePoints = {
  GeoPosition[{10.0, 106.7}],   (* Ho Chi Minh City *)
  GeoPosition[{10.3, 106.1}],   (* Upper delta *)
  GeoPosition[{9.5, 106.3}],    (* Lower delta *)
  GeoPosition[{9.8, 105.5}]     (* Ca Mau peninsula *)
};

turbiditySamples = GEEGetSamples[samplePoints, mekongTurbidity];
```

### Step 5: Summary Dashboard

```wolfram
(* Compile all results into a summary Dataset *)
summary = Dataset[<|
  "Water Body Area" -> Quantity[mekongWaterKm2, "Kilometers"^2],
  "Mean Annual Precipitation" ->
    Quantity[Lookup[precipMean, "precipitation", 0], "Millimeters"],
  "Cropland Area" -> Quantity[Lookup[classAreas, "Cropland", 0], "Kilometers"^2],
  "Wetland Area" -> Quantity[Lookup[classAreas, "Wetland", 0], "Kilometers"^2],
  "Water Area (WorldCover)" ->
    Quantity[Lookup[classAreas, "Water", 0], "Kilometers"^2]
|>];

summary

(* Multi-panel visualization *)
GraphicsGrid[{
  {GEEComputePixels[mekongBox,
     s2Mekong // GEESelectBands[{"B4", "B3", "B2"}],
     "VisParams" -> <|"min" -> 0, "max" -> 3000|>],
   GEEComputePixels[mekongBox, mekongNDWI,
     "VisParams" -> <|"min" -> -0.5, "max" -> 0.5,
       "palette" -> {"#8B4513", "#FFFFFF", "#0000FF"}|>]},
  {GEEComputePixels[mekongBox, mekongTurbidity,
     "VisParams" -> <|"min" -> 0, "max" -> 1500,
       "palette" -> {"#0000FF", "#00FF00", "#FF0000"}|>],
   GEEComputePixels[mekongBox, mekongLC,
     "VisParams" -> <|"min" -> 10, "max" -> 95,
       "palette" -> {"#006400", "#FFBB22", "#FFFF4C",
         "#F096FF", "#FA0000", "#B4B4B4", "#0064C8",
         "#0096A0", "#00CF75"}|>]}
}, ImageSize -> 800, Spacings -> 5]
```

---

## Summary

| Function | Purpose in This Chapter |
|---|---|
| `GEENormalizedDifference` | Compute NDWI, MNDWI, NDVI, NDSI from band pairs |
| `GEECollection` | Load Sentinel-2, Sentinel-1, MODIS, CHIRPS collections |
| `GEELoadImage` | Load single-image assets (JRC, ESA WorldCover) |
| `GEEFilterDate` | Restrict collections to specific time windows |
| `GEEFilterBounds` | Spatial filtering to region of interest |
| `GEEFilterProperty` | Cloud filtering, instrument mode selection |
| `GEESelectBands` | Extract specific bands for analysis |
| `GEEMedian` / `GEEMean` | Create cloud-free composites |
| `GEECollectionSum` | Accumulate daily rainfall, ET over time |
| `GEEGreaterThan` / `GEELessThan` | Threshold indices into binary masks |
| `GEESelfMask` | Remove zero/false pixels from masks |
| `GEEUpdateMask` | Apply one image as a mask on another |
| `GEESubtract` / `GEEDivide` | Band math: SAR change detection, band ratios |
| `GEEMultiply` | Scale factors, area computation |
| `GEEPixelArea` | Pixel area in m^2 for areal statistics |
| `GEEReduceRegion` | Zonal statistics over a geometry |
| `GEEClip` | Clip rasters to watershed boundaries |
| `GEEPolygon` | Define custom watershed/region geometries |
| `GEEGeometry` | Create point and rectangle geometries |
| `GEEConstant` | Initialize classified images |
| `GEEWhere` | Conditional pixel assignment |
| `GEEAnd` / `GEEEquals` | Logical operations for multi-criteria classification |
| `GEEVisualize` | Server-side rendering with palettes |
| `GEEComputePixels` | Retrieve processed imagery |
| `GEEImage` | Geo-tagged image retrieval |
| `GEEGeoGraphics` | Overlay results on geographic basemaps |
| `GEEIdentify` | Point queries on raster data |
| `GEEGetSamples` | Multi-point extraction for validation |
| `GEECompute` | Execute arbitrary server-side expressions |
| `GEEArea` | Compute geometry area for unit conversion |
| `GEEBuffer` | Buffer geometries for spatial analysis |

## Further Reading

- McFeeters, S.K. (1996). "The use of the Normalized Difference Water Index
  (NDWI) in the delineation of open water features." *International Journal of
  Remote Sensing*, 17(7), 1425-1432.
- Xu, H. (2006). "Modification of normalised difference water index (NDWI) to
  enhance open water features in remotely sensed imagery." *International Journal
  of Remote Sensing*, 27(14), 3025-3033.
- Pekel, J.F. et al. (2016). "High-resolution mapping of global surface water
  and its long-term changes." *Nature*, 540, 418-422.
- Funk, C. et al. (2015). "The climate hazards infrared precipitation with
  stations -- a new environmental record for monitoring extremes." *Scientific
  Data*, 2, 150066.


---

# Chapter 7: Urban and Population Analysis

Cities occupy less than 3% of the Earth's land surface yet account for over 70% of
global energy consumption and CO2 emissions. Satellite remote sensing provides a
unique vantage point for studying urbanization: nighttime lights reveal economic
activity, thermal sensors expose heat islands, and multispectral imagery tracks the
physical expansion of impervious surfaces. This chapter demonstrates how to combine
Google Earth Engine datasets with Wolfram Language analysis tools to quantify and
visualize urban phenomena at scales ranging from a single neighborhood to a
multi-city global comparison.

---

## 7.1 Nighttime Lights

Nighttime light emissions are among the most direct satellite-observable proxies for
human economic activity. Brighter lights generally correlate with higher population
density, greater GDP, and more developed infrastructure. Two complementary datasets
provide coverage from 1992 to the present.

### VIIRS Monthly Nighttime Lights

The Visible Infrared Imaging Radiometer Suite (VIIRS) Day/Night Band produces
monthly composites of nighttime radiance at approximately 500 m resolution. The
`avg_rad` band reports average radiance in nanowatts per square centimeter per
steradian (nW/cm2/sr).

**Nightlight map of the Tokyo metropolitan area:**

```wolfram
tokyoLights = GEECollection["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG"] //
  GEEFilterDate["2024-01-01", "2024-07-01"] //
  GEEFilterBounds[{139.5, 35.4, 140.1, 35.9}] //
  GEESelectBands[{"avg_rad"}] //
  GEEMedian;

GEEImage[
  Entity["City", {"Tokyo", "Tokyo", "Japan"}],
  tokyoLights,
  GeoRange -> Quantity[60, "Kilometers"],
  RasterSize -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 80,
    "palette" -> {"#000000", "#0d0887", "#7e03a8",
      "#cc4778", "#f89540", "#f0f921"}|>
]
```

The palette runs from black (no light) through purple and orange to bright yellow,
giving a sense of the radiance gradient from rural periphery to the dense urban
core. The median composite over six months reduces noise from cloud contamination
and transient light sources.

**Compare nightlight radiance across multiple cities:**

To quantify differences between cities, extract the mean radiance over each urban
footprint with `GEEReduceRegion` and compile results into a `Dataset`.

```wolfram
cities = <|
  "Tokyo"    -> {139.5, 35.5, 140.0, 35.85},
  "New York" -> {-74.1, 40.6, -73.7, 40.9},
  "London"   -> {-0.3, 51.35, 0.1, 51.6},
  "Mumbai"   -> {72.75, 18.9, 73.05, 19.2},
  "Lagos"    -> {3.2, 6.35, 3.55, 6.65}
|>;

viirs = GEECollection["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG"] //
  GEEFilterDate["2024-01-01", "2024-07-01"] //
  GEESelectBands[{"avg_rad"}] //
  GEEMedian;

radiance = Association @ KeyValueMap[
  Function[{name, bbox},
    name -> First @ Values @ GEECompute[
      viirs // GEEReduceRegion[GEEGeometry[bbox], "mean", 500]
    ]
  ],
  cities
];

BarChart[
  Values[radiance],
  ChartLabels -> Keys[radiance],
  AxesLabel -> {None, "Mean Radiance (nW/cm\[ThinSpace]2/sr)"},
  PlotLabel -> "VIIRS Mean Nightlight Radiance (Jan-Jun 2024)",
  ChartStyle -> "DarkRainbow"
]
```

The resulting bar chart provides an immediate visual comparison. Cities like Tokyo
and New York typically show significantly higher radiance than rapidly growing cities
like Lagos, where large portions of the metropolitan area still lack continuous
electrification.

### DMSP-OLS Historical Nightlights (1992--2013)

For long-term urbanization studies, the Defense Meteorological Satellite Program
Operational Linescan System (DMSP-OLS) provides annual composites spanning over two
decades. The `stable_lights` band contains a 0--63 digital number representing
relative light intensity.

**Track urbanization growth in Shenzhen over two decades:**

Shenzhen transformed from a small town to a megacity in a single generation. DMSP
nightlights capture this expansion.

```wolfram
years = {1992, 2002, 2013};

shenzhenBBox = {113.7, 22.4, 114.4, 22.7};

images = Association @ Map[
  Function[year,
    year -> (
      GEECollection["NOAA/DMSP-OLS/NIGHTTIME_LIGHTS"] //
        GEEFilterDate[
          DateString[{year, 1, 1}, "ISODate"],
          DateString[{year + 1, 1, 1}, "ISODate"]] //
        GEESelectBands[{"stable_lights"}] //
        GEEMedian
    )
  ],
  years
];

Grid[{
  Map[
    GEEImage[
      GeoPosition[{22.55, 114.05}], images[#],
      GeoRange -> Quantity[40, "Kilometers"],
      RasterSize -> {512, 512},
      "VisParams" -> <|"min" -> 0, "max" -> 63,
        "palette" -> {"#000000", "#ffff00", "#ffffff"}|>
    ] &,
    years
  ],
  Map[Style[ToString[#], Bold, 14] &, years]
}]
```

The three panels show the progressive brightening and spatial expansion of
Shenzhen's lit area, a hallmark of rapid urbanization.

### Wolfram Integration: GeoRegionValuePlot

Combine GEE-extracted radiance statistics with Wolfram's built-in geographic
visualization to produce a choropleth map of nightlight intensity by country or
state.

```wolfram
states = {"California", "Texas", "NewYork", "Florida", "Illinois"};

stateBoxes = <|
  "California" -> {-124.5, 32.5, -114.1, 42.0},
  "Texas"      -> {-106.7, 25.8, -93.5, 36.5},
  "NewYork"    -> {-79.8, 40.5, -71.8, 45.0},
  "Florida"    -> {-87.6, 24.5, -80.0, 31.0},
  "Illinois"   -> {-91.5, 36.9, -87.0, 42.5}
|>;

viirs = GEECollection["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG"] //
  GEEFilterDate["2024-01-01", "2024-07-01"] //
  GEESelectBands[{"avg_rad"}] //
  GEEMedian;

stateRadiance = KeyValueMap[
  Function[{state, bbox},
    Entity["AdministrativeDivision", {state, "UnitedStates"}] ->
      First @ Values @ GEECompute[
        viirs // GEEReduceRegion[GEEGeometry[bbox], "mean", 1000]
      ]
  ],
  stateBoxes
];

GeoRegionValuePlot[stateRadiance,
  PlotLabel -> "Mean Nightlight Radiance by State",
  ColorFunction -> "SunsetColors",
  GeoRange -> "UnitedStates"
]
```

### Logarithmic Scaling for High Dynamic Range

Nighttime radiance spans several orders of magnitude. Applying a log transform
server-side compresses the dynamic range before visualization, revealing detail in
both dim rural areas and saturated urban cores.

```wolfram
viirs = GEECollection["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG"] //
  GEEFilterDate["2024-01-01", "2024-07-01"] //
  GEEFilterBounds[{-74.3, 40.4, -73.6, 41.0}] //
  GEESelectBands[{"avg_rad"}] //
  GEEMedian //
  GEEAdd[1] //       (* shift to avoid log(0) *)
  GEELog10;

GEEImage[
  GeoPosition[{40.7, -73.95}],
  viirs,
  GeoRange -> Quantity[50, "Kilometers"],
  RasterSize -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 2.5,
    "palette" -> {"#000004", "#51127c", "#b73779",
      "#fc8961", "#fcfdbf"}|>
]
```

Adding 1 before taking `GEELog10` avoids undefined values at zero-radiance pixels.
The resulting image reveals suburban structure that would otherwise be invisible
against the bright Manhattan core.

---

## 7.2 Urban Heat Island Effect

Urban surfaces -- asphalt, concrete, and rooftops -- absorb and re-emit solar
radiation far more efficiently than vegetation, creating the urban heat island (UHI)
effect. Satellite-derived land surface temperature (LST) is the primary tool for
mapping this phenomenon.

### Landsat 8 Surface Temperature

Landsat 8 Collection 2 Level 2 provides a thermal band (`ST_B10`) with a linear
scale factor. The conversion pipeline transforms raw digital numbers to degrees
Celsius. For the general treatment of satellite-derived land surface temperature
including MODIS LST and ground-station validation, see Sections 3.1 and 3.1.3.

```wolfram
lstCelsius = GEECollection["LANDSAT/LC08/C02/T1_L2"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[{-77.2, 38.75, -76.8, 39.05}] //
  GEEFilterProperty["CLOUD_COVER", "LessThan", 20] //
  GEESelectBands[{"ST_B10"}] //
  GEEMedian //
  GEEMultiply[0.00341802] //   (* scale factor *)
  GEEAdd[149.0] //             (* offset to Kelvin *)
  GEEAdd[-273.15];            (* Kelvin to Celsius *)

GEEImage[
  GeoPosition[{38.9, -77.0}],
  lstCelsius,
  GeoRange -> Quantity[30, "Kilometers"],
  RasterSize -> {1024, 1024},
  "VisParams" -> <|"min" -> 25, "max" -> 50,
    "palette" -> {"#313695", "#4575b4", "#abd9e9",
      "#fee090", "#f46d43", "#a50026"}|>
]
```

This produces a surface temperature map of Washington, D.C., where the National
Mall, downtown corridors, and parking lots appear as hot spots against the cooler
green spaces of Rock Creek Park and the Potomac River margins.

### MODIS Land Surface Temperature

For broader-scale or time-series UHI analysis, MODIS provides 8-day LST composites
(`MOD11A2`) at 1 km resolution. The `LST_Day_1km` band requires multiplication by
0.02 to convert to Kelvin.

```wolfram
modisLST = GEECollection["MODIS/061/MOD11A2"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[{-88.0, 41.6, -87.4, 42.1}] //
  GEESelectBands[{"LST_Day_1km"}] //
  GEEMedian //
  GEEMultiply[0.02] //        (* scale to Kelvin *)
  GEEAdd[-273.15];           (* to Celsius *)

GEEImage[
  Entity["City", {"Chicago", "Illinois", "UnitedStates"}],
  modisLST,
  GeoRange -> Quantity[40, "Kilometers"],
  RasterSize -> {512, 512},
  "VisParams" -> <|"min" -> 25, "max" -> 45,
    "palette" -> {"#2166ac", "#67a9cf", "#d1e5f0",
      "#fddbc7", "#ef8a62", "#b2182b"}|>
]
```

### Quantifying UHI Intensity

UHI intensity is defined as the difference in surface temperature between the urban
core and a nearby rural reference. Extract mean LST for two geometries and compute
the differential.

```wolfram
lstCelsius = GEECollection["LANDSAT/LC08/C02/T1_L2"] //
  GEEFilterDate["2023-06-01", "2023-09-01"] //
  GEEFilterBounds[{-74.1, 40.6, -73.7, 40.9}] //
  GEEFilterProperty["CLOUD_COVER", "LessThan", 15] //
  GEESelectBands[{"ST_B10"}] //
  GEEMedian //
  GEEMultiply[0.00341802] //
  GEEAdd[149.0] //
  GEEAdd[-273.15];

(* Urban core: Midtown Manhattan *)
urbanGeom = GEEGeometry[{-73.99, 40.74, -73.96, 40.76}];

(* Rural reference: farmland in northern New Jersey *)
ruralGeom = GEEGeometry[{-74.55, 40.85, -74.45, 40.95}];

urbanLST = First @ Values @ GEECompute[
  lstCelsius // GEEReduceRegion[urbanGeom, "mean", 30]
];
ruralLST = First @ Values @ GEECompute[
  lstCelsius // GEEReduceRegion[ruralGeom, "mean", 30]
];

uhiIntensity = urbanLST - ruralLST;

Dataset[<|
  "Urban Mean LST" -> Quantity[Round[urbanLST, 0.1], "DegreesCelsius"],
  "Rural Mean LST" -> Quantity[Round[ruralLST, 0.1], "DegreesCelsius"],
  "UHI Intensity"  -> Quantity[Round[uhiIntensity, 0.1], "DegreesCelsius"]
|>]
```

A typical summertime UHI intensity for New York City is 4--8 degrees Celsius,
depending on the reference site and atmospheric conditions.

### Overlay Temperature on GeoGraphics

Use `GEEGeoGraphics` to overlay urban boundary annotations on a thermal basemap.

```wolfram
GEEGeoGraphics[
  {EdgeForm[{Thick, White}], FaceForm[None],
   GeoPolygon[{
     GeoPosition[{40.76, -73.99}], GeoPosition[{40.76, -73.96}],
     GeoPosition[{40.74, -73.96}], GeoPosition[{40.74, -73.99}]
   }],
   White, GeoMarker[GeoPosition[{40.75, -73.975}],
     "Label" -> "Urban Core"]},
  lstCelsius,
  GeoRange -> Quantity[25, "Kilometers"],
  RasterSize -> {800, 800},
  "VisParams" -> <|"min" -> 28, "max" -> 48,
    "palette" -> {"#313695", "#fee090", "#a50026"}|>
]
```

---

## 7.3 Built-Up Area and Impervious Surface

Impervious surfaces -- roads, buildings, and pavement -- are the physical
manifestation of urbanization. Mapping their extent and growth is fundamental to
urban planning, hydrology, and climate adaptation studies.

### Normalized Difference Built-Up Index (NDBI)

NDBI exploits the higher reflectance of built-up surfaces in the short-wave
infrared (SWIR) relative to the near-infrared (NIR). For Sentinel-2, NDBI is
computed as (B11 - B8) / (B11 + B8). Positive values indicate built-up areas.

```wolfram
ndbi = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-03-01", "2024-06-01"] //
  GEEFilterBounds[{77.0, 28.4, 77.4, 28.8}] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
  GEEMedian //
  GEENormalizedDifference[{"B11", "B8"}];

GEEImage[
  Entity["City", {"NewDelhi", "Delhi", "India"}],
  ndbi,
  GeoRange -> Quantity[30, "Kilometers"],
  RasterSize -> {1024, 1024},
  "VisParams" -> <|"min" -> -0.3, "max" -> 0.3,
    "palette" -> {"#1a9850", "#ffffbf", "#d73027"}|>
]
```

Green tones represent vegetated areas (negative NDBI), yellow marks the transition
zone, and red highlights dense built-up land. The sharp contrast between Old Delhi's
compact urban fabric and the surrounding agricultural belt is clearly visible.

### ESA WorldCover Built-Up Class

ESA WorldCover is a 10 m resolution global land cover product derived from
Sentinel-1 and Sentinel-2. Class 50 represents built-up areas. By isolating this
class and combining it with `GEEPixelArea`, you can compute the total built-up
area within any polygon.

```wolfram
worldCover = GEELoadImage[
  "ESA/WorldCover/v200/2021"
] // GEESelectBands[{"Map"}];

(* Create a binary mask: 1 where built-up, 0 elsewhere *)
builtUp = worldCover // GEEEquals[50];

(* Visualize built-up footprint over Sao Paulo *)
GEEImage[
  Entity["City", {"SaoPaulo", "SaoPaulo", "Brazil"}],
  builtUp,
  GeoRange -> Quantity[50, "Kilometers"],
  RasterSize -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 1,
    "palette" -> {"#e0e0e0", "#d7191c"}|>
]
```

**Compute built-up area percentage for a city:**

```wolfram
cityBBox = {-46.8, -23.7, -46.4, -23.4};
cityGeom = GEEGeometry[cityBBox];

builtUpArea = builtUp //
  GEEMultiply[GEEPixelArea[]] //
  GEEReduceRegion[cityGeom, "sum", 10];

totalArea = GEEPixelArea[] //
  GEEClip[cityGeom] //
  GEEReduceRegion[cityGeom, "sum", 10];

builtUpM2 = First @ Values @ GEECompute[builtUpArea];
totalM2 = First @ Values @ GEECompute[totalArea];

builtUpPct = 100.0 * builtUpM2 / totalM2;

StringForm["Built-up area: ``% of the ```` km\[ThinSpace]2 region",
  Round[builtUpPct, 0.1],
  Round[totalM2 / 10^6, 1]
]
```

### Global Human Settlement Layer (GHSL)

The JRC Global Human Settlement Layer provides built-up surface area estimates at
multiple epochs (1975, 1990, 2000, 2015, 2020), enabling historical analysis of
urban expansion.

```wolfram
epochs = {1975, 1990, 2000, 2015};

lagosBox = {3.1, 6.3, 3.7, 6.7};
lagosGeom = GEEGeometry[lagosBox];

builtUpByEpoch = Association @ Map[
  Function[year,
    Module[{img, result},
      img = GEELoadImage[
        "JRC/GHSL/P2023A/GHS_BUILT_S/" <> ToString[year]
      ] // GEESelectBands[{"built_surface"}];
      result = GEECompute[
        img // GEEReduceRegion[lagosGeom, "sum", 100]
      ];
      year -> First[Values[result]] / 10^6  (* m2 to km2 *)
    ]
  ],
  epochs
];

ListLinePlot[
  builtUpByEpoch,
  PlotMarkers -> Automatic,
  AxesLabel -> {"Year", "Built-Up Area (km\[ThinSpace]2)"},
  PlotLabel -> "Lagos: Built-Up Surface Expansion",
  PlotStyle -> Directive[Thick, RGBColor[0.8, 0.2, 0.2]],
  Filling -> Axis
]
```

This plot reveals the exponential growth trajectory that characterizes many cities
in Sub-Saharan Africa.

---

## 7.4 Urban Sprawl and Change Detection

Urbanization is not a static condition but an ongoing process. Change detection
techniques compare imagery from different time periods to identify where land use
transitions have occurred.

### Land Cover Change Between Two Periods

Compare ESA WorldCover products from 2020 and 2021 to find pixels that transitioned
from vegetation (classes 10, 20, 30) to built-up (class 50).

```wolfram
lc2020 = GEELoadImage["ESA/WorldCover/v100/2020"] //
  GEESelectBands[{"Map"}];
lc2021 = GEELoadImage["ESA/WorldCover/v200/2021"] //
  GEESelectBands[{"Map"}];

(* Vegetation in 2020: tree cover (10), shrubland (20), grassland (30) *)
veg2020 = lc2020 // GEELessThan[40];   (* classes < 40 are vegetation *)

(* Built-up in 2021 *)
built2021 = lc2021 // GEEEquals[50];

(* Pixels that changed from vegetation to built-up *)
vegToBuilt = veg2020 // GEEAnd[built2021] // GEESelfMask;

GEEImage[
  GeoPosition[{30.05, 31.25}],   (* Cairo *)
  vegToBuilt,
  GeoRange -> Quantity[50, "Kilometers"],
  RasterSize -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 1,
    "palette" -> {"#ff0000"}|>
]
```

Red pixels indicate locations where agricultural or natural vegetation was replaced
by built-up surface. In rapidly urbanizing regions like the Nile Delta fringe, this
pattern is clearly visible.

### NDVI Loss as Urbanization Proxy

Normalized Difference Vegetation Index (NDVI) decline between two dates serves as a
reliable proxy for land conversion. Areas experiencing significant NDVI loss are
likely undergoing urbanization or deforestation. For the fundamentals of NDVI
computation and interpretation, see Section 5.1.1.

```wolfram
makeNDVI = Function[{startDate, endDate},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate[startDate, endDate] //
    GEEFilterBounds[{116.1, 39.7, 116.7, 40.1}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}]
];

ndvi2019 = makeNDVI["2019-06-01", "2019-09-01"];
ndvi2024 = makeNDVI["2024-06-01", "2024-09-01"];

(* Negative difference = vegetation loss *)
ndviChange = ndvi2024 // GEESubtract[ndvi2019];

(* Threshold: significant loss where NDVI dropped by more than 0.2 *)
significantLoss = ndviChange // GEELessThan[-0.2] // GEESelfMask;

GEEImage[
  GeoPosition[{39.9, 116.4}],   (* Beijing *)
  significantLoss,
  GeoRange -> Quantity[40, "Kilometers"],
  RasterSize -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 1,
    "palette" -> {"#e31a1c"}|>
]
```

Note: A decrease of 0.2 or more in NDVI is a commonly used threshold in the
literature, though the optimal value depends on the land cover context and the
time span between observations.

### Visualizing Change with a Continuous Map

Rather than a binary threshold, displaying the full range of NDVI change reveals
both areas of vegetation loss and gain.

```wolfram
GEEImage[
  GeoPosition[{39.9, 116.4}],
  ndviChange,
  GeoRange -> Quantity[40, "Kilometers"],
  RasterSize -> {1024, 1024},
  "VisParams" -> <|"min" -> -0.4, "max" -> 0.4,
    "palette" -> {"#d73027", "#fc8d59", "#fee08b",
      "#d9ef8b", "#91cf60", "#1a9850"}|>
]
```

Red tones indicate vegetation loss (potential urbanization), while green tones
indicate vegetation gain (reforestation or agricultural expansion).

---

## 7.5 Population and Demographics

Gridded population datasets disaggregate census counts into continuous raster
surfaces, enabling population estimates for arbitrary regions without relying on
administrative boundary alignment.

### WorldPop Population Density

WorldPop provides 100 m resolution population count grids. Because population
density varies by orders of magnitude, logarithmic scaling is essential for
meaningful visualization.

```wolfram
pop = GEECollection["WorldPop/GP/100m/pop"] //
  GEEFilterDate["2020-01-01", "2021-01-01"] //
  GEEFilterBounds[{28.8, -2.0, 30.2, -1.0}] //
  GEESelectBands[{"population"}] //
  GEEMosaic;

popLog = pop //
  GEEAdd[1] //     (* avoid log(0) *)
  GEELog10;

GEEImage[
  GeoPosition[{-1.95, 29.87}],   (* Kigali, Rwanda *)
  popLog,
  GeoRange -> Quantity[30, "Kilometers"],
  RasterSize -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 3,
    "palette" -> {"#ffffcc", "#c2e699", "#78c679",
      "#238443", "#004529"}|>
]
```

On this log10 scale, a value of 1 corresponds to 10 people per pixel, 2 to 100,
and 3 to 1000. The concentric density gradient from Kigali's center to its rural
outskirts is immediately apparent.

### Estimate Population Within a Custom Polygon

Define an arbitrary region of interest and compute the total population by summing
all pixels within it.

```wolfram
(* Define a polygon around central Nairobi *)
nairobiPoly = GEEPolygon[{
  {36.75, -1.35}, {36.90, -1.35}, {36.90, -1.22},
  {36.75, -1.22}, {36.75, -1.35}
}];

pop = GEECollection["WorldPop/GP/100m/pop"] //
  GEEFilterDate["2020-01-01", "2021-01-01"] //
  GEESelectBands[{"population"}] //
  GEEMosaic //
  GEEClip[nairobiPoly];

totalPop = First @ Values @ GEECompute[
  pop // GEEReduceRegion[nairobiPoly, "sum", 100]
];

StringForm["Estimated population within polygon: `` people",
  Round[totalPop]
]
```

### Wolfram Integration: Cross-Referencing with Entity Data

Wolfram Language's built-in `Entity` framework provides census-derived population
figures. Comparing these with satellite-derived estimates helps validate gridded
products and identify discrepancies.

```wolfram
citiesWL = {
  Entity["City", {"Nairobi", "Nairobi", "Kenya"}],
  Entity["City", {"Lagos", "Lagos", "Nigeria"}],
  Entity["City", {"Kinshasa", "Kinshasa", "DemocraticRepublicOfTheCongo"}],
  Entity["City", {"AddisAbaba", "AddisAbaba", "Ethiopia"}],
  Entity["City", {"Dar Es Salaam", "DarEsSalaam", "Tanzania"}]
};

censusPop = Map[
  # -> #["Population"] &,
  citiesWL
];

Dataset[censusPop]
```

### GeoBubbleChart for Multi-City Visualization

`GeoBubbleChart` provides an intuitive way to display population or any scalar
quantity at geographic locations, with bubble size proportional to the value.

```wolfram
cityData = {
  GeoPosition[{-1.29, 36.82}]  -> 4.4 * 10^6,   (* Nairobi *)
  GeoPosition[{6.52, 3.38}]    -> 15.4 * 10^6,   (* Lagos *)
  GeoPosition[{-4.32, 15.31}]  -> 17.1 * 10^6,   (* Kinshasa *)
  GeoPosition[{9.02, 38.75}]   -> 5.4 * 10^6,    (* Addis Ababa *)
  GeoPosition[{-6.79, 39.28}]  -> 7.4 * 10^6     (* Dar es Salaam *)
};

GeoBubbleChart[cityData,
  PlotLabel -> "Major African Cities by Population",
  GeoRange -> "Africa",
  BubbleSizes -> {0.02, 0.08},
  ChartStyle -> "DarkRainbow"
]
```

---

## 7.6 Air Quality and Pollution

Urban pollution is both a consequence of dense economic activity and a major
public health concern. Satellite instruments now provide daily global maps of key
pollutants, enabling analysis that was impossible with ground station networks alone.

### Sentinel-5P TROPOMI: Nitrogen Dioxide

The TROPOspheric Monitoring Instrument (TROPOMI) on Sentinel-5P measures
tropospheric NO2 column density, a primary indicator of combustion-related air
pollution from vehicles, power plants, and industry.

```wolfram
no2 = GEECollection["COPERNICUS/S5P/OFFL/L3_NO2"] //
  GEEFilterDate["2024-01-01", "2024-04-01"] //
  GEEFilterBounds[{112.5, 22.0, 114.5, 23.5}] //
  GEESelectBands[{"tropospheric_NO2_column_number_density"}] //
  GEEMean;

GEEImage[
  GeoPosition[{23.0, 113.3}],   (* Pearl River Delta *)
  no2,
  GeoRange -> Quantity[100, "Kilometers"],
  RasterSize -> {1024, 1024},
  "VisParams" -> <|
    "min" -> 0, "max" -> 0.0002,
    "palette" -> {"#ffffb2", "#fecc5c", "#fd8d3c",
      "#f03b20", "#bd0026"}|>
]
```

The Pearl River Delta -- encompassing Guangzhou, Shenzhen, Dongguan, and Hong Kong
-- is one of the world's most industrialized regions. The NO2 map reveals pollution
hotspots centered on industrial zones and major highway corridors.

### Aerosol Optical Depth from MODIS

Aerosol Optical Depth (AOD) measures the extinction of sunlight by atmospheric
particulates. MODIS provides daily AOD at 1 km resolution through the `MODIS/061/MCD19A2_GRANULES` product.

```wolfram
aod = GEECollection["MODIS/061/MCD19A2_GRANULES"] //
  GEEFilterDate["2024-01-01", "2024-04-01"] //
  GEEFilterBounds[{76.8, 28.3, 77.5, 28.9}] //
  GEESelectBands[{"Optical_Depth_047"}] //
  GEEMean //
  GEEMultiply[0.001];   (* scale factor *)

GEEImage[
  Entity["City", {"NewDelhi", "Delhi", "India"}],
  aod,
  GeoRange -> Quantity[40, "Kilometers"],
  RasterSize -> {512, 512},
  "VisParams" -> <|"min" -> 0, "max" -> 1.5,
    "palette" -> {"#00ff00", "#ffff00", "#ff0000", "#800000"}|>
]
```

### Correlating Nightlights with NO2 Pollution

A scientifically interesting question: does nighttime light intensity predict NO2
pollution? Extracting both quantities at the same set of locations enables a
scatter plot and regression analysis.

```wolfram
(* Define sample points across a metropolitan region *)
samplePoints = Table[
  GeoPosition[{lat, lon}],
  {lat, 40.5, 41.0, 0.05},
  {lon, -74.2, -73.7, 0.05}
] // Flatten;

(* Build VIIRS composite *)
viirs = GEECollection["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG"] //
  GEEFilterDate["2024-01-01", "2024-07-01"] //
  GEEFilterBounds[{-74.3, 40.4, -73.6, 41.1}] //
  GEESelectBands[{"avg_rad"}] //
  GEEMedian;

(* Build NO2 composite *)
no2 = GEECollection["COPERNICUS/S5P/OFFL/L3_NO2"] //
  GEEFilterDate["2024-01-01", "2024-07-01"] //
  GEEFilterBounds[{-74.3, 40.4, -73.6, 41.1}] //
  GEESelectBands[{"tropospheric_NO2_column_number_density"}] //
  GEEMean;

(* Sample both datasets at the same points *)
lightSamples = GEEGetSamples[samplePoints, viirs];
no2Samples = GEEGetSamples[samplePoints, no2];

(* Extract numeric values *)
lightVals = Map[First @ Values @ #["Values"] &, lightSamples];
no2Vals = Map[First @ Values @ #["Values"] &, no2Samples];

pairs = Select[
  Transpose[{lightVals, no2Vals}],
  AllTrue[NumericQ]   (* remove any missing-data points *)
];

(* Scatter plot with linear fit *)
fit = LinearModelFit[pairs, x, x];

Show[
  ListPlot[pairs,
    AxesLabel -> {"Nightlight Radiance (nW/cm2/sr)",
      "NO2 Column Density (mol/m2)"},
    PlotLabel -> "Nightlight vs NO2: New York Metro",
    PlotStyle -> PointSize[0.015]],
  Plot[fit[x], {x, Min[pairs[[All, 1]]], Max[pairs[[All, 1]]]},
    PlotStyle -> {Red, Thick}]
]

(* Report R-squared *)
fit["RSquared"]
```

A positive correlation is generally expected, though the strength depends on the
mix of residential versus industrial lighting in the study area.

---

## 7.7 Infrastructure and Transportation

Urban infrastructure -- roads, buildings, and utilities -- shapes the spatial
structure of cities. While dedicated vector datasets (e.g., OpenStreetMap) provide
the most precise infrastructure maps, satellite imagery offers complementary
information through texture and spectral analysis.

### Texture Analysis with NAIP Imagery

The National Agriculture Imagery Program (NAIP) provides 1 m resolution aerial
imagery for the continental United States. The `GEEEntropy` function computes local
Shannon entropy within a neighborhood, highlighting areas of high spatial
complexity such as road networks, building edges, and industrial facilities.

```wolfram
naip = GEECollection["USDA/NAIP/DOQQ"] //
  GEEFilterDate["2021-01-01", "2022-01-01"] //
  GEEFilterBounds[{-122.45, 37.75, -122.38, 37.80}] //
  GEESelectBands[{"R"}] //
  GEEMosaic;

entropy = naip // GEEEntropy[30];

GEEImage[
  GeoPosition[{37.775, -37.415}],
  entropy,
  GeoRange -> Quantity[5, "Kilometers"],
  RasterSize -> {1024, 1024},
  "VisParams" -> <|"min" -> 2, "max" -> 5,
    "palette" -> {"#f7f7f7", "#969696", "#252525"}|>
]
```

High-entropy pixels (dark) correspond to complex texture: building clusters,
freeway interchanges, and commercial districts. Low-entropy regions (light)
correspond to uniform surfaces: water, parks, and open fields.

### Querying Feature Collections

GEE hosts vector datasets as FeatureCollections. The `GEEComputeFeatures` function
queries these tables with spatial and attribute filters.

```wolfram
(* Query US state boundaries for California *)
features = GEEComputeFeatures[
  "TIGER/2018/States",
  <|"property" -> "NAME", "op" -> "Equals", "value" -> "California"|>,
  "MaxFeatures" -> 1
];

(* Extract the geometry for further analysis *)
caGeometry = features[[1]]["geometry"]
```

### Wolfram Integration: GeoPath and GeoDistance

For transportation analysis, Wolfram Language's `GeoPath` and `GeoDistance` provide
geodesic routing and distance calculations that complement satellite-derived
infrastructure maps.

```wolfram
(* Great-circle path and distance between two urban centers *)
path = GeoPath[{
  Entity["City", {"LosAngeles", "California", "UnitedStates"}],
  Entity["City", {"SanFrancisco", "California", "UnitedStates"}]
}];

dist = GeoDistance[
  Entity["City", {"LosAngeles", "California", "UnitedStates"}],
  Entity["City", {"SanFrancisco", "California", "UnitedStates"}]
];

GeoGraphics[{Thick, Red, path},
  GeoRange -> "California",
  GeoBackground -> "StreetMap"
]
```

---

## 7.8 Multi-City Comparative Analysis

The workflows introduced in this chapter converge in a multi-city comparative
analysis. By extracting several urban indicators for a consistent set of cities, you
can build a dashboard-style summary that reveals how cities differ in their
nightlight intensity, thermal signatures, built-up extent, and vegetation cover.

### Define the Study Cities

```wolfram
studyCities = <|
  "Tokyo"     -> <|"bbox" -> {139.55, 35.55, 139.95, 35.80},
                   "center" -> GeoPosition[{35.68, 139.75}]|>,
  "New York"  -> <|"bbox" -> {-74.05, 40.65, -73.75, 40.85},
                   "center" -> GeoPosition[{40.75, -73.90}]|>,
  "Sao Paulo" -> <|"bbox" -> {-46.75, -23.65, -46.45, -23.45},
                   "center" -> GeoPosition[{-23.55, -46.60}]|>,
  "Cairo"     -> <|"bbox" -> {31.15, 29.95, 31.45, 30.15},
                   "center" -> GeoPosition[{30.05, 31.30}]|>,
  "Mumbai"    -> <|"bbox" -> {72.80, 18.90, 73.05, 19.15},
                   "center" -> GeoPosition[{19.05, 72.90}]|>
|>;
```

### Extract Indicators

Build a reusable extraction function for each indicator.

```wolfram
(* 1. Mean nightlight radiance *)
extractRadiance[bbox_] := Module[{img, geom},
  img = GEECollection["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG"] //
    GEEFilterDate["2024-01-01", "2024-07-01"] //
    GEEFilterBounds[bbox] //
    GEESelectBands[{"avg_rad"}] //
    GEEMedian;
  geom = GEEGeometry[bbox];
  First @ Values @ GEECompute[img // GEEReduceRegion[geom, "mean", 500]]
]

(* 2. Mean land surface temperature (Celsius) *)
extractLST[bbox_] := Module[{img, geom},
  img = GEECollection["MODIS/061/MOD11A2"] //
    GEEFilterDate["2024-06-01", "2024-09-01"] //
    GEEFilterBounds[bbox] //
    GEESelectBands[{"LST_Day_1km"}] //
    GEEMedian //
    GEEMultiply[0.02] //
    GEEAdd[-273.15];
  geom = GEEGeometry[bbox];
  First @ Values @ GEECompute[img // GEEReduceRegion[geom, "mean", 1000]]
]

(* 3. Mean NDBI *)
extractNDBI[bbox_] := Module[{img, geom},
  img = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-03-01", "2024-06-01"] //
    GEEFilterBounds[bbox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEEMedian //
    GEENormalizedDifference[{"B11", "B8"}];
  geom = GEEGeometry[bbox];
  First @ Values @ GEECompute[img // GEEReduceRegion[geom, "mean", 20]]
]

(* 4. Built-up area percentage from ESA WorldCover *)
extractBuiltUpPct[bbox_] := Module[{builtUp, geom, builtArea, totalArea},
  builtUp = GEELoadImage["ESA/WorldCover/v200/2021"] //
    GEESelectBands[{"Map"}] //
    GEEEquals[50];
  geom = GEEGeometry[bbox];
  builtArea = First @ Values @ GEECompute[
    builtUp // GEEMultiply[GEEPixelArea[]] //
      GEEReduceRegion[geom, "sum", 10]
  ];
  totalArea = First @ Values @ GEECompute[
    GEEPixelArea[] // GEEClip[geom] //
      GEEReduceRegion[geom, "sum", 10]
  ];
  100.0 * builtArea / totalArea
]
```

### Build the Comparative Dataset

```wolfram
dashboard = Association @ KeyValueMap[
  Function[{city, info},
    city -> <|
      "Nightlight (nW/cm2/sr)" -> Round[extractRadiance[info["bbox"]], 0.1],
      "LST (C)"                -> Round[extractLST[info["bbox"]], 0.1],
      "Mean NDBI"              -> Round[extractNDBI[info["bbox"]], 0.01],
      "Built-Up %"             -> Round[extractBuiltUpPct[info["bbox"]], 0.1]
    |>
  ],
  studyCities
];

Dataset[dashboard]
```

This produces a five-row table with four columns, providing an at-a-glance
comparison of urban intensity across continents.

### Comparative Bar Charts

```wolfram
indicators = {"Nightlight (nW/cm2/sr)", "LST (C)",
  "Mean NDBI", "Built-Up %"};

charts = Map[
  Function[ind,
    BarChart[
      Map[dashboard[#][ind] &, Keys[studyCities]],
      ChartLabels -> Keys[studyCities],
      PlotLabel -> ind,
      ChartStyle -> "Pastel"
    ]
  ],
  indicators
];

GraphicsGrid[Partition[charts, 2], ImageSize -> 800]
```

### City Location Map

Add geographic context with a `GeoGraphics` display showing all five study cities.

```wolfram
markers = KeyValueMap[
  Function[{city, info},
    {PointSize[0.02], Red,
     GeoMarker[info["center"], "Label" -> city]}
  ],
  studyCities
];

GeoGraphics[markers,
  GeoRange -> "World",
  GeoProjection -> "Robinson",
  ImageSize -> 700
]
```

---

## Summary

This chapter demonstrated how to combine Google Earth Engine's global satellite
archive with Wolfram Language's analytical and visualization capabilities to study
urban environments. The key techniques covered were:

- **Nighttime lights** (VIIRS, DMSP-OLS) as proxies for economic activity, with
  `GEELog10` for dynamic range compression and `GeoRegionValuePlot` for choropleth
  mapping.
- **Urban heat islands** measured via Landsat and MODIS thermal bands, quantified
  as the temperature differential between urban and rural reference areas using
  `GEEReduceRegion`.
- **Built-up area mapping** through NDBI, ESA WorldCover classification, and the
  GHSL time series, with `GEEEquals`, `GEEPixelArea`, and `GEEReduceRegion` for
  area computation.
- **Change detection** using multi-temporal land cover comparison and NDVI
  differencing to identify urbanization fronts.
- **Population estimation** with WorldPop gridded data, validated against Wolfram's
  `Entity` framework and visualized with `GeoBubbleChart`.
- **Air quality monitoring** via Sentinel-5P NO2 and MODIS AOD, including
  correlation analysis with nightlight intensity using `GEEGetSamples` and
  `LinearModelFit`.
- **Infrastructure analysis** through texture-based feature extraction with
  `GEEEntropy` and vector queries via `GEEComputeFeatures`.
- **Multi-city dashboards** that synthesize multiple indicators into a single
  comparative `Dataset` with `BarChart` visualizations.

These workflows are building blocks. A natural next step is to add temporal depth --
repeating the extraction for multiple years to construct time series of urban
indicators -- or to scale the analysis to dozens or hundreds of cities for global
comparative studies.


---

# Chapter 8: Advanced Techniques and Wolfram Language Integration

This chapter demonstrates sophisticated workflows that combine the server-side
processing power of Google Earth Engine with the analytical, visualization, and
machine learning capabilities of the Wolfram Language. Each section builds on
the fundamentals covered in earlier chapters to show what becomes possible when
these two platforms work together.

---

## 8.1 Machine Learning with GEE Data

The Wolfram Language provides a complete machine learning stack through
`Classify`, `Predict`, `FindClusters`, and related functions. By extracting
spectral data from GEE and feeding it into these built-in learners, you can
build land cover classifiers, biomass predictors, and unsupervised clustering
models without leaving a single notebook.

### Supervised Classification: Land Cover from Sentinel-2

The general workflow is: define training points with known labels, extract
multi-band spectral values at those points using `GEEGetSamples`, train a
classifier, and evaluate its performance. For an application of this workflow
to crop-type classification specifically, see Section 5.3.2.

**Step 1: Define training locations and labels.**

Each training point is a `GeoPosition` with a known land cover class. In
practice you would derive these from field surveys, existing land cover maps,
or careful visual interpretation.

```wolfram
Needs["GoogleEarthEngineClient`"]
GEEConnect["/path/to/service-account-key.json"]

(* Training points: {GeoPosition, class label} *)
trainingPoints = {
  (* Water *)
  {GeoPosition[{45.44, 12.34}], "Water"},
  {GeoPosition[{45.43, 12.35}], "Water"},
  {GeoPosition[{45.45, 12.33}], "Water"},
  (* Forest *)
  {GeoPosition[{46.05, 11.12}], "Forest"},
  {GeoPosition[{46.06, 11.13}], "Forest"},
  {GeoPosition[{46.07, 11.11}], "Forest"},
  (* Cropland *)
  {GeoPosition[{45.10, 11.80}], "Crop"},
  {GeoPosition[{45.11, 11.81}], "Crop"},
  {GeoPosition[{45.12, 11.79}], "Crop"},
  (* Urban *)
  {GeoPosition[{45.46, 9.19}], "Urban"},
  {GeoPosition[{45.47, 9.18}], "Urban"},
  {GeoPosition[{45.48, 9.20}], "Urban"},
  (* Bare soil *)
  {GeoPosition[{44.80, 11.50}], "Bare"},
  {GeoPosition[{44.81, 11.51}], "Bare"},
  {GeoPosition[{44.82, 11.49}], "Bare"}
};
```

**Step 2: Build a cloud-free Sentinel-2 composite and extract spectral values.**

We select bands B2 through B12 (visible, red edge, NIR, SWIR) because these
carry the spectral information that distinguishes land cover types.

```wolfram
sentinel2 =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-09-01"] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B2", "B3", "B4", "B5", "B6", "B7", "B8", "B8A",
      "B11", "B12"}] //
    GEEMedian;

(* Extract band values at all training points *)
samples = GEEGetSamples[
  trainingPoints[[All, 1]],
  sentinel2,
  "Bands" -> {"B2", "B3", "B4", "B5", "B6", "B7", "B8", "B8A",
    "B11", "B12"}
];
```

**Step 3: Build training data and train a classifier.**

The `Classify` function accepts training data as `{feature -> label, ...}`
rules. Each feature vector is the list of band values for that pixel.

```wolfram
(* Pair each sample's spectral values with its label *)
trainingData = MapThread[
  #1["Values"] -> #2 &,
  {samples, trainingPoints[[All, 2]]}
];

(* Train with Random Forest *)
classifier = Classify[trainingData, Method -> "RandomForest"]
```

**Step 4: Evaluate model performance.**

`ClassifierMeasurements` provides accuracy, confusion matrix, F1 scores, and
many other diagnostics.

```wolfram
cm = ClassifierMeasurements[classifier, trainingData];

(* Overall accuracy *)
cm["Accuracy"]

(* Confusion matrix -- shows where classes are being mixed *)
cm["ConfusionMatrixPlot"]

(* Per-class F1 score *)
cm["F1Score"]
```

**Step 5: Apply the classifier to new locations.**

```wolfram
newPoints = {
  GeoPosition[{45.50, 12.00}],
  GeoPosition[{46.10, 11.20}],
  GeoPosition[{45.00, 11.90}]
};

newSamples = GEEGetSamples[newPoints, sentinel2,
  "Bands" -> {"B2", "B3", "B4", "B5", "B6", "B7", "B8", "B8A",
    "B11", "B12"}];

predictions = classifier /@ (newSamples[[All, "Values"]])
(* e.g. {"Water", "Forest", "Crop"} *)
```

### Unsupervised Clustering

When you do not have labeled training data, `FindClusters` can discover
natural groupings in spectral space. This is useful for exploratory analysis
to understand what surface types exist in a scene.

```wolfram
(* Sample a grid of points across a region *)
gridPoints = Flatten[
  Table[
    GeoPosition[{lat, lon}],
    {lat, 45.0, 45.5, 0.05},
    {lon, 11.0, 11.5, 0.05}
  ]
];

gridSamples = GEEGetSamples[gridPoints, sentinel2,
  "Bands" -> {"B2", "B3", "B4", "B5", "B6", "B7", "B8", "B11", "B12"}];

spectralVectors = gridSamples[[All, "Values"]];

(* Cluster into 5 groups *)
clusters = FindClusters[spectralVectors, 5, Method -> "KMeans"];
```

**Visualize the spectral space with dimensionality reduction.**

Reducing to 2 or 3 dimensions helps you see whether the clusters are well
separated, which indicates distinct surface types.

```wolfram
reduced = DimensionReduction[spectralVectors, 2,
  Method -> "PrincipalComponentAnalysis"];

ListPlot[
  MapThread[
    Tooltip[#1, #2] &,
    {reduced, FindClusters[spectralVectors -> Range[Length[spectralVectors]], 5]}
  ],
  PlotLabel -> "Spectral Space (PCA)",
  FrameLabel -> {"PC1", "PC2"}
]
```

### Regression: Predicting Biomass from Spectral Indices

For continuous target variables such as biomass, crop yield, or soil moisture,
use `Predict` instead of `Classify`.

```wolfram
(* Training data: spectral indices paired with field-measured biomass (kg/m^2) *)
biomassTraining = {
  {0.72, 0.35, 0.21} -> 4.5,   (* {NDVI, EVI, NDWI} -> biomass *)
  {0.68, 0.31, 0.18} -> 3.9,
  {0.45, 0.20, 0.10} -> 1.8,
  {0.82, 0.42, 0.28} -> 6.1,
  {0.55, 0.25, 0.14} -> 2.5
};

biomassPredictor = Predict[biomassTraining, Method -> "GradientBoostedTrees"];

(* Predict biomass for new spectral measurements *)
biomassPredictor[{0.65, 0.30, 0.17}]
```

To extract the spectral indices from GEE for the prediction input:

```wolfram
ndviImage =
  sentinel2 //
    GEENormalizedDifference[{"B8", "B4"}] //
    GEERename[{"NDVI"}];

eviImage =
  sentinel2 //
    GEEExpression[
      "2.5 * ((NIR - RED) / (NIR + 6 * RED - 7.5 * BLUE + 1))",
      <|"NIR" -> "B8", "RED" -> "B4", "BLUE" -> "B2"|>
    ] //
    GEERename[{"EVI"}];

ndwiImage =
  sentinel2 //
    GEENormalizedDifference[{"B3", "B8"}] //
    GEERename[{"NDWI"}];

indexStack =
  ndviImage //
    GEEAddBands[eviImage] //
    GEEAddBands[ndwiImage];

fieldSamples = GEEGetSamples[fieldPoints, indexStack,
  "Bands" -> {"NDVI", "EVI", "NDWI"}];

predictedBiomass = biomassPredictor /@ (fieldSamples[[All, "Values"]])
```

---

## 8.2 Time Series Analysis

Earth observation time series reveal trends, seasonal patterns, and anomalies
in environmental processes. The Wolfram Language provides a rich set of tools
for temporal analysis that complement GEE's server-side compositing.

### Building Multi-Year Time Series

The general pattern is to iterate over time windows, compute a regional
statistic for each window using `GEECompute` with `GEEReduceRegion`, and
assemble the results into a `TimeSeries` object.

```wolfram
(* Define region of interest: a forest polygon *)
forestPolygon = GEEPolygon[{
  {-72.5, -13.0}, {-72.3, -13.0}, {-72.3, -12.8},
  {-72.5, -12.8}, {-72.5, -13.0}
}];

(* Generate monthly date ranges over 5 years *)
dateRanges = Table[
  {
    DateString[DateObject[{year, month, 1}], {"Year", "-", "Month", "-", "Day"}],
    DateString[
      DatePlus[DateObject[{year, month, 1}], {1, "Month"}],
      {"Year", "-", "Month", "-", "Day"}
    ]
  },
  {year, 2019, 2023},
  {month, 1, 12}
] // Flatten[#, 1] &;

(* Extract mean NDVI for each month *)
ndviTimeSeries = Table[
  Module[{pipeline, result},
    pipeline =
      GEECollection["MODIS/061/MOD13A2"] //
        GEEFilterDate[dates[[1]], dates[[2]]] //
        GEESelectBands[{"NDVI"}] //
        GEEMean //
        GEEMultiply[0.0001] //  (* Apply MODIS scale factor *)
        GEEReduceRegion[forestPolygon, "mean", 1000];
    result = GEECompute[pipeline];
    {DateObject[dates[[1]]], result["NDVI"]}
  ],
  {dates, dateRanges}
];

(* Build a TimeSeries object *)
ndviTS = TimeSeries[
  ndviTimeSeries[[All, 2]],
  {ndviTimeSeries[[All, 1]]}
];

DateListPlot[ndviTS,
  PlotLabel -> "Monthly Mean NDVI (2019-2023)",
  FrameLabel -> {"Date", "NDVI"},
  Filling -> Axis
]
```

### Trend Detection

A linear fit to the time series reveals whether vegetation is greening
(positive slope) or browning (negative slope) over the study period. For
non-linear dynamics, `FindFit` can model logistic growth, exponential decay,
or other functional forms.

```wolfram
(* Convert dates to numeric values for fitting *)
numericDates = AbsoluteTime /@ ndviTimeSeries[[All, 1]];
ndviValues = ndviTimeSeries[[All, 2]];

(* Linear trend *)
lm = LinearModelFit[
  Transpose[{numericDates, ndviValues}],
  x, x
];

(* Slope tells you the rate of change *)
slope = lm["BestFitParameters"][[2]];
Print["NDVI trend: ", slope * (365.25 * 86400), " per year"]

(* Nonlinear fit: logistic recovery model *)
logisticModel = FindFit[
  Transpose[{numericDates - Min[numericDates], ndviValues}],
  k / (1 + a * Exp[-r * t]),
  {k, a, r}, t
];

Show[
  ListPlot[Transpose[{numericDates, ndviValues}]],
  Plot[lm[x], {x, Min[numericDates], Max[numericDates]}, PlotStyle -> Red],
  PlotLabel -> "NDVI Trend Detection"
]
```

### Seasonal Decomposition

Fourier analysis separates the time series into its constituent frequencies,
letting you isolate the annual cycle from multi-year trends and short-term
noise.

```wolfram
(* Fourier transform of NDVI series *)
ft = Fourier[ndviValues];

(* Periodogram reveals dominant frequencies *)
Periodogram[ndviValues,
  PlotLabel -> "NDVI Frequency Spectrum",
  SampleRate -> 12  (* monthly data = 12 samples/year *)
]

(* Isolate seasonal component using bandpass filter *)
(* Pass frequencies near 1 cycle/year *)
seasonalComponent = BandpassFilter[ndviValues, {0.8/12, 1.2/12}];

(* Trend: low-pass filter *)
trendComponent = LowpassFilter[ndviValues, 0.5/12];

(* Residual = original - trend - seasonal *)
residualComponent = ndviValues - trendComponent - seasonalComponent;

GraphicsRow[{
  ListLinePlot[trendComponent, PlotLabel -> "Trend"],
  ListLinePlot[seasonalComponent, PlotLabel -> "Seasonal"],
  ListLinePlot[residualComponent, PlotLabel -> "Residual"]
}, ImageSize -> Large]
```

### Anomaly Detection

Anomalies are months where observed NDVI deviates significantly from the
long-term climatological mean for that calendar month. This approach can
flag drought, flooding, or land use change events.

```wolfram
(* Group values by calendar month *)
monthlyGroups = GroupBy[
  ndviTimeSeries,
  DateValue[#[[1]], "Month"] &,
  #[[All, 2]] &
];

(* Compute climatological mean and standard deviation per month *)
climatology = Association @ Table[
  month -> <|
    "Mean" -> Mean[monthlyGroups[month]],
    "StdDev" -> StandardDeviation[monthlyGroups[month]]
  |>,
  {month, Keys[monthlyGroups]}
];

(* Flag anomalies: months deviating more than 2 sigma *)
anomalies = Select[ndviTimeSeries,
  Module[{month, val, clim},
    month = DateValue[#[[1]], "Month"];
    val = #[[2]];
    clim = climatology[month];
    Abs[val - clim["Mean"]] > 2 * clim["StdDev"]
  ] &
];

Print["Detected ", Length[anomalies], " anomalous months"]
Print["Anomaly dates: ", anomalies[[All, 1]]]
```

### Forecasting

`TimeSeriesForecast` uses the structure it detects in the historical data
(trend, seasonality, autocorrelation) to project forward.

```wolfram
(* Forecast the next 12 months *)
forecast = TimeSeriesForecast[ndviTS, {12}];

DateListPlot[{ndviTS, forecast},
  PlotLabel -> "NDVI Forecast (12 months)",
  PlotLegends -> {"Historical", "Forecast"},
  FrameLabel -> {"Date", "NDVI"}
]
```

---

## 8.3 Image Processing Pipeline

GEE delivers raster data as `Image` objects. Once client-side, the full power
of the Wolfram Language image processing stack is available for enhancement,
segmentation, edge detection, and change analysis.

### Enhancement for Publication-Quality Output

Raw satellite imagery often needs contrast adjustment and color balancing
before it is suitable for publication or reports.

```wolfram
(* Fetch a Sentinel-2 true-color image *)
rawImage = GEEComputePixels[
  {12.4, 41.8, 12.6, 42.0},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-08-31"] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 5] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian //
    GEEVisualize[<|"min" -> 0, "max" -> 3000|>],
  "ImageSize" -> 1024
];

(* Enhance *)
enhanced =
  rawImage //
    ImageAdjust[#, {0.1, 0.2}] & //   (* Contrast and brightness *)
    Sharpen[#, 2] & //                 (* Edge enhancement *)
    ColorBalance;                       (* White balance correction *)

(* Match a reference histogram for consistent styling *)
referenceImage = Import["reference_scene.png"];
matched = HistogramTransform[enhanced, referenceImage];

GraphicsRow[{rawImage, enhanced, matched},
  ImageSize -> Large,
  PlotLabel -> {"Raw", "Enhanced", "Histogram Matched"}
]
```

### Segmentation: Counting Crop Fields

Thresholding an NDVI image and analyzing connected components lets you count
and measure individual features such as crop fields or water bodies.

```wolfram
(* Compute NDVI image *)
ndviRaster = GEEComputePixels[
  {11.0, 44.8, 11.4, 45.0},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-07-01", "2024-08-31"] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}] //
    GEEVisualize[<|"min" -> -0.2, "max" -> 0.9,
      "palette" -> {"brown", "yellow", "green", "darkgreen"}|>],
  "ImageSize" -> 512
];

(* Threshold to isolate high-NDVI vegetation *)
binary = Binarize[ndviRaster, 0.5];

(* Identify connected components *)
components = MorphologicalComponents[binary];
nFields = Max[components];

(* Measure each component *)
measurements = ComponentMeasurements[components,
  {"Area", "Centroid", "EquivalentDiskRadius", "Perimeter"}
];

Print["Detected ", nFields, " crop fields"]

(* Filter by minimum area to remove noise *)
significantFields = Select[measurements, #[[2, 1]] > 100 &];
Print["Significant fields (>100 pixels): ", Length[significantFields]]
```

The same segmentation workflow applies to water detection: compute NDWI
(`GEENormalizedDifference[{"B3", "B8"}]`), threshold, and run
`MorphologicalComponents` and `ComponentMeasurements` to count and measure
individual water bodies.

### Edge Detection: Coastline Extraction

`EdgeDetect` finds boundaries in an image, which is useful for extracting
coastlines, field boundaries, or urban edges.

```wolfram
(* NDWI-based water mask for a coastal area *)
coastalNDWI = GEEComputePixels[
  {-5.0, 36.7, -4.8, 36.9},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-05-01", "2024-08-31"] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEMedian //
    GEENormalizedDifference[{"B3", "B8"}] //
    GEEVisualize[<|"min" -> -0.5, "max" -> 0.5|>],
  "ImageSize" -> 512
];

coastline = EdgeDetect[Binarize[coastalNDWI, 0.2]];

(* Extract linear features *)
lines = ImageLines[coastline, 0.1, Method -> "Hough"];

Show[coastalNDWI, Graphics[{Red, Thick, Line /@ lines}]]
```

### Change Detection with Image Differencing

Comparing images from two dates reveals changes in land cover, urban growth,
deforestation, or flood extent.

```wolfram
(* Before image *)
beforeImage = GEEComputePixels[
  {116.3, 39.8, 116.5, 40.0},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2020-06-01", "2020-08-31"] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}] //
    GEEVisualize[<|"min" -> -0.2, "max" -> 0.8|>],
  "ImageSize" -> 512
];

(* After image *)
afterImage = GEEComputePixels[
  {116.3, 39.8, 116.5, 40.0},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-08-31"] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}] //
    GEEVisualize[<|"min" -> -0.2, "max" -> 0.8|>],
  "ImageSize" -> 512
];

(* Pixel-wise difference *)
changeImage = ImageDifference[afterImage, beforeImage];

(* Emphasize changes *)
emphasizedChange = changeImage // ImageAdjust // ColorNegate;

GraphicsRow[{beforeImage, afterImage, emphasizedChange},
  PlotLabel -> {"2020", "2024", "Change"}
]
```

---

## 8.4 Geographic Visualization

The Wolfram Language's geographic visualization functions integrate naturally
with GEE data, enabling everything from simple point overlays to interactive
multi-panel dashboards.

### GeoGraphics and GEEGeoGraphics

`GEEGeoGraphics` places Wolfram Language geographic primitives on top of a
GEE satellite basemap instead of the default map tiles.

```wolfram
(* Sample points overlaid on a GEE satellite background *)
sampleLocations = {
  GeoPosition[{40.42, -3.70}],
  GeoPosition[{40.45, -3.68}],
  GeoPosition[{40.40, -3.72}]
};

GEEGeoGraphics[
  {Red, PointSize[Large], Point /@ sampleLocations},
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-08-31"] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian //
    GEEVisualize[<|"min" -> 0, "max" -> 3000|>],
  GeoRange -> Quantity[15, "Kilometers"],
  GeoCenter -> GeoPosition[{40.42, -3.70}],
  ImageSize -> 600
]
```

For standard basemaps (without GEE imagery), use the built-in `GeoGraphics`:

```wolfram
GeoGraphics[
  {Red, PointSize[Large], Point /@ sampleLocations,
   EdgeForm[{Thick, Blue}], FaceForm[None],
   Polygon[GeoPosition[{{40.41, -3.71}, {40.43, -3.71},
     {40.43, -3.69}, {40.41, -3.69}}]]
  },
  GeoRange -> Quantity[10, "Kilometers"],
  GeoCenter -> GeoPosition[{40.42, -3.70}]
]
```

### Thematic Mapping: Choropleth and Bubble Charts

`GeoRegionValuePlot` creates choropleth maps from named geographic entities.
This is powerful when combined with `GEEReduceRegion` or `GEEComputeFeatures`
to extract per-region statistics.

```wolfram
(* Compute mean NDVI per US state *)
states = EntityList[EntityClass["AdministrativeDivision", "USStatesKind"]];

stateNDVI = Table[
  Module[{bbox, pipeline, result},
    bbox = EntityValue[state, "BoundingBox"];
    pipeline =
      GEECollection["MODIS/061/MOD13A2"] //
        GEEFilterDate["2024-06-01", "2024-08-31"] //
        GEESelectBands[{"NDVI"}] //
        GEEMean //
        GEEMultiply[0.0001] //
        GEEReduceRegion[
          GEEGeometry[bbox],
          "mean", 5000
        ];
    result = GEECompute[pipeline];
    state -> result["NDVI"]
  ],
  {state, states}
];

GeoRegionValuePlot[stateNDVI,
  PlotLabel -> "Mean Summer NDVI by US State (2024)",
  ColorFunction -> "GreenBrownTerrain",
  PlotLegends -> Automatic
]
```

`GeoBubbleChart` displays proportional symbols, useful for showing point-based
measurements with magnitude.

```wolfram
(* Bubble chart of NDVI at field sites *)
fieldData = {
  GeoPosition[{38.9, -77.0}] -> 0.65,
  GeoPosition[{34.0, -118.2}] -> 0.32,
  GeoPosition[{41.8, -87.6}] -> 0.48,
  GeoPosition[{29.7, -95.3}] -> 0.55
};

GeoBubbleChart[fieldData,
  PlotLabel -> "Field Site NDVI",
  BubbleSizes -> {0.02, 0.06}
]
```

### Multi-Panel Layouts

Side-by-side comparison is essential for seasonal analysis, before/after
studies, and multi-band visualization.

```wolfram
(* Four-season comparison *)
seasons = {
  {"2024-01-01", "2024-03-31", "Winter"},
  {"2024-04-01", "2024-06-30", "Spring"},
  {"2024-07-01", "2024-09-30", "Summer"},
  {"2024-10-01", "2024-12-31", "Fall"}
};

bbox = {-122.5, 37.7, -122.3, 37.9};

seasonImages = Table[
  GEEComputePixels[bbox,
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
      GEEFilterDate[s[[1]], s[[2]]] //
      GEEFilterBounds[bbox] //
      GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20] //
      GEESelectBands[{"B4", "B3", "B2"}] //
      GEEMedian //
      GEEVisualize[<|"min" -> 0, "max" -> 3000|>],
    "ImageSize" -> 256
  ] -> s[[3]],
  {s, seasons}
];

GraphicsGrid[
  Partition[
    Labeled[#[[1]], #[[2]], Top] & /@ seasonImages,
    2
  ],
  ImageSize -> 800
]
```

### Interactive Exploration

`Manipulate` lets you build interactive controls that dynamically change GEE
query parameters. This is particularly useful during exploratory analysis.

```wolfram
Manipulate[
  GEEComputePixels[
    {-122.5, 37.7, -122.3, 37.9},
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
      GEEFilterDate[
        DateString[startDate, {"Year", "-", "Month", "-", "Day"}],
        DateString[DatePlus[startDate, {3, "Month"}],
          {"Year", "-", "Month", "-", "Day"}]
      ] //
      GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", cloudMax] //
      GEESelectBands[{"B4", "B3", "B2"}] //
      GEEMedian //
      GEEVisualize[<|"min" -> 0, "max" -> maxReflectance|>],
    "ImageSize" -> 512
  ],
  {{startDate, DateObject[{2024, 1, 1}], "Start Date"},
    DateObject[{2020, 1, 1}], DateObject[{2024, 10, 1}]},
  {{cloudMax, 15, "Max Cloud %"}, 1, 50, 1},
  {{maxReflectance, 3000, "Max Reflectance"}, 500, 6000, 100}
]
```

For more complex dashboards, `DynamicModule` provides full control over state
management, letting you combine multiple controls (popup menus, sliders,
checkboxes) with dynamically updated GEE imagery and plots.

---

## 8.5 Data Import/Export and Interoperability

Real-world analyses rarely use GEE data in isolation. You typically combine
satellite imagery with field measurements, climate model output, census data,
or other geospatial layers.

### Importing External Data

**CSV tabular data:**

```wolfram
(* Field measurements with coordinates *)
fieldData = Import["field_measurements.csv", "Dataset", HeaderLines -> 1];

(* Extract coordinates for GEE sampling *)
fieldPoints = GeoPosition /@ Normal[fieldData[All, {"Latitude", "Longitude"}]];
```

**GeoJSON for region definitions:**

```wolfram
(* Parse GeoJSON to extract polygon coordinates for GEE *)
geojson = Import["study_area.geojson", "RawJSON"];
coords = geojson["features"][[1]]["geometry"]["coordinates"][[1]];

(* Convert to GEE polygon -- GeoJSON uses {lon, lat} order *)
studyArea = GEEPolygon[coords];

(* Use the polygon to clip a GEE image *)
clippedImage =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-08-31"] //
    GEEMedian //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEClip[studyArea];
```

**Other formats:** GeoTIFF, NetCDF, and KML all import with a single call:

```wolfram
externalDEM = Import["local_dem.tif", "GeoTIFF"];
tempGrid = Import["climate_model.nc", {"NetCDF", "tas"}];
kmlData = Import["study_sites.kml"];
```

### Exporting Results

**Raster images:**

```wolfram
(* Save enhanced satellite image *)
Export["enhanced_composite.png", enhanced]

(* High-resolution TIFF *)
Export["analysis_result.tif", ndviRaster]
```

**Tabular results:**

```wolfram
(* Export sampled data as CSV *)
resultsDataset = Dataset[
  MapThread[
    <|"Lat" -> #1[[1, 1]], "Lon" -> #1[[1, 2]],
      "NDVI" -> #2|> &,
    {fieldPoints, predictedBiomass}
  ]
];

Export["ndvi_results.csv", resultsDataset]
```

**GeoJSON for GIS interchange:**

```wolfram
(* Build GeoJSON from analysis results *)
features = Table[
  <|
    "type" -> "Feature",
    "geometry" -> <|
      "type" -> "Point",
      "coordinates" -> {pt[[1, 2]], pt[[1, 1]]}  (* lon, lat *)
    |>,
    "properties" -> <|"ndvi" -> val|>
  |>,
  {pt, fieldPoints}, {val, predictedBiomass}
] // Flatten;

geojsonOutput = <|
  "type" -> "FeatureCollection",
  "features" -> features
|>;

Export["output.geojson", geojsonOutput, "RawJSON"]
```

### KML/KMZ for Google Earth

Building KML from GEE query results lets you share findings with
collaborators who use Google Earth.

```wolfram
(* Generate KML placemarks from sampled data *)
kmlPlacemarks = StringJoin @@ Table[
  StringTemplate[
    "<Placemark><name>Site `i`</name>\
     <description>NDVI: `val`</description>\
     <Point><coordinates>`lon`,`lat`,0</coordinates></Point>\
     </Placemark>\n"
  ][<|"i" -> i, "val" -> predictedBiomass[[i]],
      "lon" -> fieldPoints[[i, 1, 2]],
      "lat" -> fieldPoints[[i, 1, 1]]|>],
  {i, Length[fieldPoints]}
];

kmlDoc = "<?xml version=\"1.0\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n\
<Document><name>NDVI Samples</name>\n" <> kmlPlacemarks <> "</Document>\n</kml>";

Export["sample_points.kml", kmlDoc, "Text"]
```

---

## 8.6 Physical Units and Quantities

The Wolfram Language `Quantity` system ensures unit-aware calculations,
eliminating a common source of error when converting between measurement
systems. Solar geometry functions add physical context to satellite
observations.

### Unit-Aware Area Calculations

`GEEArea` returns values in square meters. Converting to more practical units
is straightforward with `Quantity` and `UnitConvert`.

```wolfram
(* Compute the area of a study region *)
regionPoly = GEEPolygon[{
  {-73.0, 4.0}, {-72.5, 4.0}, {-72.5, 4.5},
  {-73.0, 4.5}, {-73.0, 4.0}
}];

areaM2 = GEECompute[GEEArea[regionPoly]];

(* Convert to practical units *)
areaKm2 = UnitConvert[Quantity[areaM2, "SquareMeters"], "SquareKilometers"]
areaHectares = UnitConvert[Quantity[areaM2, "SquareMeters"], "Hectares"]

Print["Study area: ", areaKm2]
Print["Study area: ", areaHectares]
```

**Pixel-level area computation with `GEEPixelArea`:**

```wolfram
(* Compute total vegetated area using pixel-area weighting *)
vegetatedArea =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-08-31"] //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}] //
    GEEGreaterThan[0.4] //            (* vegetation mask: 1 where NDVI > 0.4 *)
    GEEMultiply[GEEPixelArea[]] //    (* multiply mask by pixel area in m2 *)
    GEEReduceRegion[regionPoly, "sum", 10];

totalVegetatedM2 = GEECompute[vegetatedArea];

vegetatedKm2 = UnitConvert[
  Quantity[totalVegetatedM2["nd"], "SquareMeters"],
  "SquareKilometers"
]
```

### Solar Geometry

`SunPosition` computes the sun's elevation and azimuth at any point and time,
which is essential for normalizing reflectance values to account for
illumination differences between acquisition dates.

```wolfram
(* Compute solar zenith angle at satellite overpass time *)
overpassTime = DateObject[{2024, 7, 15, 10, 30, 0}, TimeZone -> 0];
location = GeoPosition[{45.0, 11.0}];

sunPos = SunPosition[location, overpassTime];
solarElevation = QuantityMagnitude[sunPos[[1]]];  (* degrees *)
solarZenith = 90 - solarElevation;

Print["Solar zenith angle: ", solarZenith, " degrees"]

(* Cosine correction factor *)
cosFactor = Cos[solarZenith * Degree];
Print["Cosine correction factor: ", cosFactor]
```

### Day Length and Phenology

Correlating day length with vegetation phenology helps explain why plants
green up and senesce at particular times of year.

```wolfram
(* Compute day length throughout the year *)
location = GeoPosition[{48.0, 11.0}];  (* Munich *)

dayLengths = Table[
  Module[{date, rise, set, hours},
    date = DateObject[{2024, 1, 1}] + Quantity[d, "Days"];
    rise = Sunrise[location, date];
    set = Sunset[location, date];
    hours = QuantityMagnitude[DateDifference[rise, set, "Hours"]];
    {d, hours}
  ],
  {d, 0, 364}
];

(* Plot day length alongside NDVI time series *)
Show[
  ListLinePlot[dayLengths,
    PlotStyle -> Orange,
    PlotLegends -> {"Day Length (hours)"},
    ScalingFunctions -> {None, None}
  ],
  PlotLabel -> "Day Length at 48N"
]
```

### Coordinate Bands with GEEPixelLonLat

`GEEPixelLonLat` creates an image whose pixel values are the geographic
coordinates, useful for latitude-dependent corrections or masking.

```wolfram
(* Mask to only southern-hemisphere pixels *)
lonlat = GEEPixelLonLat[];

southernMask =
  lonlat //
    GEESelectBands[{"latitude"}] //
    GEELessThan[0];

(* Apply to a global dataset *)
maskedImage =
  GEELoadImage["MODIS/061/MOD13A2/2024_06_01"] //
    GEESelectBands[{"NDVI"}] //
    GEEUpdateMask[southernMask];
```

---

## 8.7 Parallel and Batch Processing

When analyzing many regions or time steps, parallel execution can dramatically
reduce wall-clock time.

### Parallel Multi-Region Analysis

`ParallelMap` distributes computations across available kernels. Each kernel
needs its own authenticated connection.

```wolfram
(* Define field polygons *)
fieldGeometries = Table[
  GEEPolygon[{
    {lon, lat}, {lon + 0.01, lat}, {lon + 0.01, lat + 0.01},
    {lon, lat + 0.01}, {lon, lat}
  }],
  {lat, 45.0, 45.49, 0.01},
  {lon, 11.0, 11.49, 0.01}
] // Flatten;

Print["Processing ", Length[fieldGeometries], " field polygons"]

(* Ensure parallel kernels are loaded *)
LaunchKernels[];

ParallelEvaluate[
  Needs["GoogleEarthEngineClient`"];
  GEEConnect["/path/to/service-account-key.json"];
];

(* Build the pipeline once -- it is just a symbolic expression *)
ndviPipeline =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-08-31"] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}];

(* Extract mean NDVI per field in parallel *)
fieldNDVI = ParallelMap[
  Function[geom,
    GEECompute[
      ndviPipeline // GEEReduceRegion[geom, "mean", 10]
    ]
  ],
  fieldGeometries
];
```

### Server-Side Multi-Region Reduction with GEEReduceRegions

For moderate numbers of regions, `GEEReduceRegions` is more efficient because
it sends a single request to GEE rather than one per region.

```wolfram
(* Load a FeatureCollection of administrative boundaries *)
adminBoundaries = GEEFeatureCollection["FAO/GAUL/2015/level1"];

(* Reduce NDVI over all sub-national regions at once *)
regionStats =
  ndviPipeline //
    GEEReduceRegions[adminBoundaries, "mean", 500];

results = GEECompute[regionStats];
```

### Batch Temporal Extraction

For multi-year monthly statistics, `Table` generates the full set of queries
and `ParallelTable` speeds up execution.

```wolfram
(* Monthly NDVI for 5 years, parallelized *)
monthlyStats = ParallelTable[
  Module[{startDate, endDate, pipeline},
    startDate = DateString[DateObject[{year, month, 1}],
      {"Year", "-", "Month", "-", "Day"}];
    endDate = DateString[DatePlus[DateObject[{year, month, 1}], {1, "Month"}],
      {"Year", "-", "Month", "-", "Day"}];
    pipeline =
      GEECollection["MODIS/061/MOD13A2"] //
        GEEFilterDate[startDate, endDate] //
        GEESelectBands[{"NDVI"}] //
        GEEMean //
        GEEMultiply[0.0001] //
        GEEReduceRegion[forestPolygon, "mean", 1000];
    <|"Year" -> year, "Month" -> month,
      "NDVI" -> GEECompute[pipeline]["NDVI"]|>
  ],
  {year, 2019, 2023},
  {month, 1, 12}
] // Flatten;

monthlyDataset = Dataset[monthlyStats];
```

---

## 8.8 Reproducible Research Workflows

A well-structured Mathematica notebook serves as both the analysis script and
the research narrative. This section outlines a template for reproducible
workflows that combine GEE data acquisition, analysis, and reporting.

### Notebook Structure Template

A reproducible analysis notebook should follow this general structure. Each
section is a separate cell group in the notebook.

**Section 1: Setup and Authentication**

```wolfram
(* === SETUP === *)
Needs["GoogleEarthEngineClient`"]

(* Authenticate *)
conn = GEEConnect["/path/to/service-account-key.json"]

(* Verify connection *)
$GEEConnection

(* List available assets to confirm access *)
GEEListAssets["projects/earthengine-public/assets/COPERNICUS",
  "MaxResults" -> 5]
```

**Section 2: Parameters and Configuration**

Centralizing all parameters in one cell makes the analysis easy to rerun with
different settings.

```wolfram
(* === PARAMETERS === *)
studyRegion = GEEPolygon[{
  {-72.5, -13.0}, {-72.0, -13.0}, {-72.0, -12.5},
  {-72.5, -12.5}, {-72.5, -13.0}
}];

studyBBox = {-72.5, -13.0, -72.0, -12.5};
startDate = "2020-01-01";
endDate = "2024-12-31";
cloudThreshold = 15;
ndviThreshold = 0.4;
targetScale = 30;  (* meters *)
```

**Section 3: Data Acquisition**

```wolfram
(* === DATA ACQUISITION === *)

(* Check asset metadata *)
assetInfo = GEEGetAssetInfo["COPERNICUS/S2_SR_HARMONIZED"];
Print["Asset type: ", assetInfo["Type"]]
Print["Available bands: ", assetInfo["Bands"][[All, "Name"]]]

(* Build the base collection *)
s2Collection =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate[startDate, endDate] //
    GEEFilterBounds[studyBBox] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", cloudThreshold];

(* Cloud-masked NDVI composite *)
ndviComposite =
  s2Collection //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}];

(* Fetch the NDVI image *)
ndviImage = GEEComputePixels[studyBBox, ndviComposite //
  GEEVisualize[<|"min" -> 0, "max" -> 0.8,
    "palette" -> {"brown", "yellow", "green", "darkgreen"}|>],
  "ImageSize" -> 512
];

(* True-color composite *)
rgbComposite =
  s2Collection //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian //
    GEEVisualize[<|"min" -> 0, "max" -> 3000|>];

rgbImage = GEEComputePixels[studyBBox, rgbComposite, "ImageSize" -> 512];

(* Geo-tagged image with GEEImage -- returns image with geo metadata *)
geoTaggedNDVI = GEEImage[
  GeoPosition[{-12.75, -72.25}],
  ndviComposite,
  GeoRange -> Quantity[20, "Kilometers"],
  ImageSize -> 512
];

(* Fetch a single map tile with GEEGetTile *)
tile = GEEGetTile[rgbComposite, GeoPosition[{-12.75, -72.25}], 12];

(* Elevation data *)
elevation = GEELoadImage["USGS/SRTMGL1_003"];
terrainData = elevation // GEETerrain;

(* Identify pixel values at key points *)
centralPoint = GeoPosition[{-12.75, -72.25}];
elevationAtCenter = GEEIdentify[centralPoint, elevation];
Print["Elevation at center: ", elevationAtCenter["Values"], " m"]
```

**Section 4: Analysis**

```wolfram
(* === ANALYSIS === *)

(* Regional statistics *)
meanNDVI = GEECompute[
  ndviComposite // GEEReduceRegion[studyRegion, "mean", targetScale]
];

stdNDVI = GEECompute[
  ndviComposite //
    GEEReduceStdDev //
    GEEReduceRegion[studyRegion, "mean", targetScale]
];

(* Vegetation area calculation *)
vegMask = ndviComposite // GEEGreaterThan[ndviThreshold];

vegArea = GEECompute[
  vegMask //
    GEEMultiply[GEEPixelArea[]] //
    GEEReduceRegion[studyRegion, "sum", targetScale]
];

totalArea = GEECompute[GEEArea[studyRegion]];

vegFraction = vegArea["nd"] / totalArea;

Print["Vegetation fraction: ", NumberForm[vegFraction * 100, 3], "%"]

(* Elevation-NDVI relationship *)
combinedImage =
  ndviComposite //
    GEERename[{"NDVI"}] //
    GEEAddBands[elevation // GEESelectBands[{"elevation"}]];

sampledData = GEESample[combinedImage, studyRegion, targetScale];
sampleResults = GEECompute[sampledData];

(* Statistical percentiles *)
percentileResult = GEECompute[
  s2Collection //
    GEEMedian //
    GEENormalizedDifference[{"B8", "B4"}] //
    GEEReducePercentile[{10, 25, 50, 75, 90}] //
    GEEReduceRegion[studyRegion, "mean", targetScale]
];

Print["NDVI percentiles: ", percentileResult]
```

**Section 5: Advanced Processing**

```wolfram
(* === ADVANCED PROCESSING === *)

(* Spatial filtering for noise reduction *)
smoothedNDVI =
  ndviComposite //
    GEEFocalMean[90] //      (* 90-meter radius smoothing *)
    GEEVisualize[<|"min" -> 0, "max" -> 0.8|>];

(* Texture analysis via entropy *)
textureImage =
  s2Collection //
    GEEMedian //
    GEESelectBands[{"B8"}] //
    GEEEntropy[30];

(* Gradient for edge detection *)
gradientImage =
  s2Collection //
    GEEMedian //
    GEESelectBands[{"B8"}] //
    GEEGradient;

(* Type casting for computation *)
intImage =
  ndviComposite //
    GEEMultiply[10000] //
    GEEToInt;

floatImage =
  GEELoadImage["USGS/SRTMGL1_003"] //
    GEEToFloat;

(* Band math with GEEExpression *)
enhancedVeg =
  s2Collection //
    GEEMedian //
    GEEExpression[
      "(NIR - RED) / (NIR + RED + 0.5) * 1.5",
      <|"NIR" -> "B8", "RED" -> "B4"|>
    ];

(* Mathematical operations *)
logTransformed =
  ndviComposite //
    GEEAbs //                 (* Ensure positive values *)
    GEEAdd[0.001] //          (* Avoid log(0) *)
    GEELog;

sqrtTransformed =
  ndviComposite //
    GEEAbs //
    GEESqrt;

(* Conditional replacement *)
correctedNDVI =
  ndviComposite //
    GEEWhere[
      ndviComposite // GEELessThan[-0.1],  (* test: negative anomalies *)
      GEEConstant[0]                        (* replace with zero *)
    ];

(* Reprojection and resampling *)
reprojected =
  ndviComposite //
    GEEResample["bilinear"] //
    GEEReproject["EPSG:32632", 20];  (* UTM zone 32N, 20m resolution *)

(* Focal statistics: local range = local max minus local min *)
localRange =
  (ndviComposite // GEEFocalMax[150]) //
    GEESubtract[ndviComposite // GEEFocalMin[150]];
localMedian = ndviComposite // GEEFocalMedian[150];

(* Kernel convolution for edge detection *)
edgeKernel = <|"type" -> "Kernel", "width" -> 3, "height" -> 3,
  "values" -> {-1, -1, -1, -1, 8, -1, -1, -1, -1}|>;
edgeDetected = s2Collection // GEEMedian // GEESelectBands[{"B8"}] // GEEConvolve[edgeKernel];

(* Math operations: power, modulo, exponential, log10 *)
powerImage = ndviComposite // GEEPow[2];
modImage = intImage // GEEMod[100];
expImage = ndviComposite // GEEExp;
log10Image = ndviComposite // GEEAbs // GEEAdd[0.001] // GEELog10;
```

**Section 6: Collection Operations and Joins**

```wolfram
(* === COLLECTION OPERATIONS === *)

(* Quality mosaic: select best pixels by NDVI *)
qualityComposite =
  s2Collection //
    GEECollectionMap[Function[img,
      img //
        GEEAddBands[
          img // GEENormalizedDifference[{"B8", "B4"}] // GEERename[{"NDVI"}]
        ]
    ]] //
    GEEQualityMosaic["NDVI"];

(* Collection-level statistics *)
collectionMax = s2Collection // GEESelectBands[{"B8"}] // GEECollectionMax;
collectionMin = s2Collection // GEESelectBands[{"B8"}] // GEECollectionMin;
collectionSum = s2Collection // GEESelectBands[{"B8"}] // GEECollectionSum;

(* Reduce to count: how many clear observations per pixel *)
observationCount =
  s2Collection //
    GEESelectBands[{"B8"}] //
    GEEReduceCount;

(* Stack collection into multi-band image *)
stacked =
  s2Collection //
    GEELimit[6] //
    GEESelectBands[{"B8"}] //
    GEEToBands;

(* Sort collection and get first image *)
bestImage =
  s2Collection //
    GEESort["CLOUDY_PIXEL_PERCENTAGE"] //
    GEEFirst;

(* Get metadata from an image *)
imageDate = GEECompute[bestImage // GEEDate];
cloudPct = GEECompute[bestImage // GEEGet["CLOUDY_PIXEL_PERCENTAGE"]];

(* Set metadata *)
taggedImage =
  ndviComposite //
    GEESet[<|"analysis" -> "summer_composite", "threshold" -> 0.4|>];

(* Merge two collections *)
s2Spring =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-03-01", "2024-05-31"] //
    GEEFilterBounds[studyBBox];

s2Fall =
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-09-01", "2024-11-30"] //
    GEEFilterBounds[studyBBox];

mergedCollection = s2Spring // GEEMerge[s2Fall];

(* Cast band types *)
castImage =
  ndviComposite //
    GEECast[<|"nd" -> "float"|>];

(* Joins: match Landsat and Sentinel-2 scenes acquired within 1 day *)
landsat = GEECollection["LANDSAT/LC09/C02/T1_L2"] //
  GEEFilterDate["2024-06-01", "2024-08-31"] // GEEFilterBounds[studyBBox];
sentinel = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-06-01", "2024-08-31"] // GEEFilterBounds[studyBBox];

cond = <|"type" -> "maxDifference", "difference" -> 86400000,
  "leftField" -> "system:time_start", "rightField" -> "system:time_start"|>;

joined = GEEJoinSimple[landsat, sentinel, cond];
innerJoined = GEEJoinInner[landsat, sentinel, cond];
bestMatched = GEEJoinSaveBest[landsat, sentinel, cond, "closest_sentinel"];
allMatched = GEEJoinSaveAll[landsat, sentinel, cond, "matching_sentinel"];
```

**Section 7: Masking, Geometry, and Vectorization**

```wolfram
(* === MASKING AND GEOMETRY === *)

(* Self-mask: remove zero-value pixels *)
selfMasked = ndviComposite // GEESelfMask;

(* Unmask: fill masked areas with a constant *)
filledNDVI = ndviComposite // GEEUnmask[-9999];

(* Boolean logic for complex masks *)
vegetationMask = ndviComposite // GEEGreaterThan[0.3];
waterMask = ndviComposite // GEELessThan[-0.1];
notWater = waterMask // GEENot;

(* Combine masks: vegetation AND not-water *)
combinedMask = vegetationMask // GEEAnd[notWater];

(* Test equality and inequality *)
equalsMask = intImage // GEEEquals[5000];
notEqualsMask = intImage // GEENotEquals[0];

(* Logical OR *)
anyVegetation = vegetationMask // GEEOr[
  ndviComposite // GEEGreaterThan[0.2]
];

(* Geometry operations *)
bufferZone = studyRegion // GEEBuffer[5000];  (* 5 km buffer *)
centroid = GEECentroid[studyRegion];
bounds = GEEBounds[studyRegion];
area = GEECompute[GEEArea[bufferZone]];

(* Line geometry *)
transect = GEELineString[{
  {-72.4, -12.9}, {-72.2, -12.7}, {-72.1, -12.6}
}];

transectBuffer = transect // GEEBuffer[500];  (* 500m corridor *)

(* Vectorize: convert raster to polygons *)
vectors = GEEReduceToVectors[
  ndviComposite // GEEGreaterThan[ndviThreshold],
  studyRegion,
  targetScale
];

vectorResults = GEECompute[vectors];
```

**Section 8: Visualization**

```wolfram
(* === VISUALIZATION === *)

GraphicsRow[{
  Labeled[rgbImage, "True Color", Top],
  Labeled[ndviImage, "NDVI", Top]
}, ImageSize -> 800]

(* GEE background with overlaid features *)
GEEGeoGraphics[
  {
    EdgeForm[{Thick, Red}], FaceForm[None],
    Polygon[GeoPosition[{
      {-13.0, -72.5}, {-13.0, -72.0},
      {-12.5, -72.0}, {-12.5, -72.5}
    }]],
    Green, PointSize[Large],
    Point[centralPoint]
  },
  rgbComposite,
  GeoRange -> Quantity[50, "Kilometers"],
  GeoCenter -> centralPoint,
  ImageSize -> 600
]
```

**Section 9: Export**

```wolfram
(* === EXPORT === *)

Export["figures/ndvi_composite.png", ndviImage]
Export["figures/rgb_composite.png", rgbImage]

Export["data/monthly_ndvi.csv", monthlyDataset]
Export["data/field_predictions.csv", resultsDataset]

Print["Analysis complete. Outputs saved to figures/ and data/"]
```

### Checklist for Reproducibility

Following these practices ensures that anyone (including your future self) can
rerun the analysis and obtain the same results:

1. **Pin all parameters** at the top of the notebook: date ranges, thresholds,
   region definitions, scale values.
2. **Record the paclet version**: `PacletInformation["GoogleEarthEngineClient"]`.
3. **Use deterministic composites**: `GEEMedian` and `GEEMean` produce the same
   result given the same input collection. Avoid `GEEMosaic` when
   reproducibility matters, because it depends on image ordering.
4. **Export intermediate data**: save extracted time series and sample values
   to CSV so that downstream analysis does not require re-querying GEE.
5. **Document decisions**: use text cells in the notebook to explain why
   specific thresholds, date ranges, or methods were chosen.
6. **Version control**: commit the notebook and its exported data to a Git
   repository.

---

## Summary

This chapter demonstrated how GEE data acquisition and the Wolfram Language's
analytical capabilities combine to support end-to-end scientific workflows:

- **Machine learning** with `Classify`, `Predict`, and `FindClusters` applied
  to spectral data extracted via `GEEGetSamples`.
- **Time series analysis** using `TimeSeries`, `LinearModelFit`, `FindFit`,
  `Fourier`, `BandpassFilter`, and `TimeSeriesForecast` on data built from
  iterated `GEECompute` and `GEEReduceRegion` calls.
- **Image processing** with `ImageAdjust`, `Binarize`,
  `MorphologicalComponents`, `EdgeDetect`, and `ImageDifference` applied to
  GEE rasters.
- **Geographic visualization** via `GEEGeoGraphics`, `GeoRegionValuePlot`,
  `GeoBubbleChart`, `GraphicsGrid`, `Manipulate`, and `DynamicModule`.
- **Data interoperability** through `Import` and `Export` for CSV, GeoJSON,
  GeoTIFF, NetCDF, and KML formats.
- **Physical units** with the `Quantity` system, `SunPosition`, `Sunrise`,
  and `Sunset` for unit-aware and physically grounded computations.
- **Parallel processing** with `ParallelMap` and `ParallelTable` for
  multi-region and multi-temporal batch workflows, plus `GEEReduceRegions`
  for server-side batching.
- **Reproducible notebooks** structured with clear sections for setup,
  parameters, acquisition, analysis, visualization, and export.

Every public function in the GoogleEarthEngineClient API appears in at least
one example above, from data loading and filtering through band math, masking,
spatial processing, collection operations, joins, and output retrieval.


---

# Chapter 9: Appendices

---

## Appendix A: Function Quick Reference

All public functions in the GoogleEarthEngineClient paclet, organized by category. The **Operator** column indicates whether the function supports a curried form for use with `//` (postfix application).

### Authentication

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEConnect` | Authenticate with GEE using a service account key file | No | `GEEConnect["key.json"]` |
| `$GEEConnection` | Global variable holding current authentication state | N/A | `$GEEConnection["Project"]` |

### Asset Metadata

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEGetAssetInfo` | Fetch metadata for a GEE asset | No | `GEEGetAssetInfo["USGS/SRTMGL1_003"]` |
| `GEEListAssets` | List assets in a folder or collection | No | `GEEListAssets["projects/earthengine-public/assets/USGS"]` |

### Image Retrieval

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEComputePixels` | Compute pixels for a GEE image over a bounding box | No | `GEEComputePixels[{-122, 37, -121, 38}, "USGS/SRTMGL1_003"]` |
| `GEEImage` | Return a geo-tagged Image of a region from a GEE asset | No | `GEEImage[Entity["City", {"Denver", "Colorado", "UnitedStates"}], expr]` |
| `GEEGetTile` | Fetch a single map tile at a given zoom/x/y | No | `GEEGetTile["USGS/SRTMGL1_003", 10, 164, 395]` |

### Point Queries

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEIdentify` | Identify pixel values at a single point | No | `GEEIdentify[GeoPosition[{37.7, -122.4}], expr]` |
| `GEEGetSamples` | Extract pixel values at multiple points | No | `GEEGetSamples[{GeoPosition[{37, -122}]}, expr]` |

### Feature Queries

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEComputeFeatures` | Query features from a table asset matching a filter | No | `GEEComputeFeatures["FAO/GAUL/2015/level0", filter]` |

### Computation

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEECompute` | Compute an arbitrary value from a GEE expression | No | `GEECompute[expr]` |

### Visualization

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEGeoGraphics` | Render geographic primitives on a GEE background map | No | `GEEGeoGraphics[{}, expr, GeoRange -> bbox]` |

### Loading

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEECollection` | Create an ImageCollection expression | No | `GEECollection["COPERNICUS/S2_SR_HARMONIZED"]` |
| `GEELoadImage` | Create a single Image expression | No | `GEELoadImage["USGS/SRTMGL1_003"]` |
| `GEEFeatureCollection` | Create a FeatureCollection expression | No | `GEEFeatureCollection["FAO/GAUL/2015/level0"]` |

### Filtering

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEFilterDate` | Filter a collection by date range | Yes | `coll // GEEFilterDate["2023-06-01", "2023-09-01"]` |
| `GEEFilterBounds` | Filter a collection by spatial bounds | Yes | `coll // GEEFilterBounds[{-122, 37, -121, 38}]` |
| `GEEFilterProperty` | Filter a collection by a metadata property | Yes | `coll // GEEFilterProperty["CLOUD_COVER", "LessThan", 20]` |

### Band Selection

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEESelectBands` | Select specific bands from an image | Yes | `img // GEESelectBands[{"B4", "B3", "B2"}]` |

### Aggregation

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEMosaic` | Mosaic a collection into a single image | No | `GEEMosaic[coll]` |
| `GEEMedian` | Reduce a collection to per-pixel median | No | `GEEMedian[coll]` |
| `GEEMean` | Reduce a collection to per-pixel mean | No | `GEEMean[coll]` |
| `GEECollectionMax` | Pixel-wise max composite of a collection | No | `GEECollectionMax[coll]` |
| `GEECollectionMin` | Pixel-wise min composite of a collection | No | `GEECollectionMin[coll]` |
| `GEECollectionSum` | Pixel-wise sum of a collection | No | `GEECollectionSum[coll]` |
| `GEEToBands` | Stack all images into a single multi-band image | No | `GEEToBands[coll]` |
| `GEEQualityMosaic` | Mosaic using a quality band for best-pixel selection | Yes | `coll // GEEQualityMosaic["NDVI"]` |

### Sorting and Limiting

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEESort` | Sort a collection by a property | Yes | `coll // GEESort["CLOUD_COVER"]` |
| `GEELimit` | Limit a collection to at most n images | Yes | `coll // GEELimit[10]` |
| `GEEFirst` | Get the first image from a collection | No | `GEEFirst[coll]` |

### Visualization Helpers

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEVisualize` | Apply server-side visualization parameters | Yes | `img // GEEVisualize[<\|"min" -> 0, "max" -> 3000\|>]` |

### Geometry

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEGeometry` | Create a point or rectangle geometry | No | `GEEGeometry[{-105.0, 39.7}]` |
| `GEEPolygon` | Create a polygon from coordinate pairs | No | `GEEPolygon[{{-105, 39}, {-104, 39}, {-104, 40}, {-105, 40}}]` |
| `GEELineString` | Create a line geometry from coordinate pairs | No | `GEELineString[{{-105, 39}, {-104, 40}}]` |
| `GEEBuffer` | Buffer a geometry by distance in meters | Yes | `geom // GEEBuffer[1000]` |
| `GEECentroid` | Compute the centroid of a geometry | No | `GEECentroid[geom]` |
| `GEEBounds` | Compute the bounding box of a geometry | No | `GEEBounds[geom]` |
| `GEEArea` | Compute the area in square meters | No | `GEEArea[geom]` |

### Statistics

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEReduceRegion` | Compute a statistic over a region | Yes | `img // GEEReduceRegion[geom, "mean", 30]` |
| `GEEReduceRegions` | Reduce an image over multiple geometries | Yes | `img // GEEReduceRegions[fc, "mean", 30]` |
| `GEEReduceStdDev` | Reduce a collection to per-pixel standard deviation | No | `GEEReduceStdDev[coll]` |
| `GEEReduceCount` | Reduce a collection to per-pixel count | No | `GEEReduceCount[coll]` |
| `GEEReducePercentile` | Reduce a collection to specified percentiles | Yes | `coll // GEEReducePercentile[{10, 50, 90}]` |
| `GEESample` | Sample pixel values within a region at a scale | Yes | `img // GEESample[geom, 30]` |
| `GEEReduceToVectors` | Vectorize an image within a geometry | Yes | `img // GEEReduceToVectors[geom, 30]` |

### Spectral Indices

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEENormalizedDifference` | Compute (b1 - b2) / (b1 + b2) server-side | Yes | `img // GEENormalizedDifference[{"B8", "B4"}]` |

### Masking

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEUpdateMask` | Update the mask of an image using another image | Yes | `img // GEEUpdateMask[maskImg]` |
| `GEEUnmask` | Replace masked pixels with a value (default 0) | Yes | `img // GEEUnmask[0]` |
| `GEESelfMask` | Mask pixels where value is 0 or already masked | No | `GEESelfMask[img]` |
| `GEEClip` | Clip an image to a geometry | Yes | `img // GEEClip[geom]` |

### Band Manipulation

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEAddBands` | Add bands from another image | Yes | `img // GEEAddBands[ndviImg]` |
| `GEERename` | Rename bands of an image | Yes | `img // GEERename[{"red", "green", "blue"}]` |

### Image Math

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEAdd` | Per-pixel addition | Yes | `img // GEEAdd[0.5]` |
| `GEESubtract` | Per-pixel subtraction | Yes | `img // GEESubtract[otherImg]` |
| `GEEMultiply` | Per-pixel multiplication | Yes | `img // GEEMultiply[0.0001]` |
| `GEEDivide` | Per-pixel division | Yes | `img // GEEDivide[10000]` |
| `GEEPow` | Per-pixel exponentiation | Yes | `img // GEEPow[2]` |
| `GEEMod` | Per-pixel modulo | Yes | `img // GEEMod[256]` |
| `GEEAbs` | Per-pixel absolute value | No | `GEEAbs[img]` |
| `GEESqrt` | Per-pixel square root | No | `GEESqrt[img]` |
| `GEELog` | Per-pixel natural logarithm | No | `GEELog[img]` |
| `GEELog10` | Per-pixel base-10 logarithm | No | `GEELog10[img]` |
| `GEEExp` | Per-pixel exponential (e^x) | No | `GEEExp[img]` |

### Math Expressions

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEExpression` | Evaluate a math expression with band bindings | Yes | `img // GEEExpression["2.5 * (nir - red) / (nir + 6*red - 7.5*blue + 1)", bindings]` |

### Comparison

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEGreaterThan` | Per-pixel greater-than (returns 0/1) | Yes | `img // GEEGreaterThan[0.3]` |
| `GEELessThan` | Per-pixel less-than (returns 0/1) | Yes | `img // GEELessThan[0.1]` |
| `GEEEquals` | Per-pixel equality (returns 0/1) | Yes | `img // GEEEquals[1]` |
| `GEENotEquals` | Per-pixel inequality (returns 0/1) | Yes | `img // GEENotEquals[0]` |

### Logical

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEAnd` | Logical AND of two images | Yes | `mask1 // GEEAnd[mask2]` |
| `GEEOr` | Logical OR of two images | Yes | `mask1 // GEEOr[mask2]` |
| `GEENot` | Logical NOT of an image | No | `GEENot[mask]` |

### Conditional

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEWhere` | Replace pixels where test is true with a value | Yes | `img // GEEWhere[testImg, -9999]` |

### Collection Operations

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEECollectionMap` | Apply a function to each image in a collection | Yes | `coll // GEECollectionMap[addNDVI]` |
| `GEEMerge` | Merge two collections | Yes | `coll1 // GEEMerge[coll2]` |

### Terrain

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEETerrain` | Compute slope, aspect, and hillshade from a DEM | No | `GEETerrain[dem]` |

### Spatial Processing

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEReproject` | Reproject an image to a CRS at a given scale | Yes | `img // GEEReproject["EPSG:4326", 30]` |
| `GEEResample` | Set resampling method (bilinear, bicubic) | Yes | `img // GEEResample["bilinear"]` |
| `GEEFocalMean` | Apply a focal mean filter | Yes | `img // GEEFocalMean[100]` |
| `GEEFocalMax` | Apply a focal max filter | Yes | `img // GEEFocalMax[100]` |
| `GEEFocalMin` | Apply a focal min filter | Yes | `img // GEEFocalMin[100]` |
| `GEEFocalMedian` | Apply a focal median filter | Yes | `img // GEEFocalMedian[100]` |
| `GEEConvolve` | Convolve an image with a kernel | Yes | `img // GEEConvolve[kernel]` |
| `GEEGradient` | Compute x and y gradient of an image | No | `GEEGradient[img]` |
| `GEEEntropy` | Compute entropy within a neighborhood radius | Yes | `img // GEEEntropy[50]` |

### Pixel Generators

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEPixelArea` | Create an image of pixel areas in square meters | N/A | `GEEPixelArea[]` |
| `GEEPixelLonLat` | Create an image with longitude/latitude bands | N/A | `GEEPixelLonLat[]` |
| `GEEConstant` | Create a constant-value image | No | `GEEConstant[1]` |

### Metadata

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEGet` | Get a metadata property from an image | Yes | `img // GEEGet["system:time_start"]` |
| `GEESet` | Set metadata properties on an image | Yes | `img // GEESet[<\|"label" -> "summer"\|>]` |
| `GEEDate` | Get the acquisition date of an image | No | `GEEDate[img]` |

### Type Casting

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEECast` | Cast band types using a mapping association | Yes | `img // GEECast[<\|"B4" -> "float"\|>]` |
| `GEEToFloat` | Convert all bands to float type | No | `GEEToFloat[img]` |
| `GEEToInt` | Convert all bands to integer type | No | `GEEToInt[img]` |

### Joins

| Function | Description | Operator | Example |
|---|---|---|---|
| `GEEJoinSimple` | Simple join of two collections by a condition | No | `GEEJoinSimple[primary, secondary, condition]` |
| `GEEJoinInner` | Inner join of two collections by a condition | No | `GEEJoinInner[primary, secondary, condition]` |
| `GEEJoinSaveBest` | Join and save the best match as a property | Yes | `primary // GEEJoinSaveBest[secondary, cond, "match"]` |
| `GEEJoinSaveAll` | Join and save all matches as a property | Yes | `primary // GEEJoinSaveAll[secondary, cond, "matches"]` |

---

## Appendix B: GEE Dataset Catalog Quick Reference

### Optical Imagery

| Dataset | Asset ID | Resolution | Temporal | Key Bands |
|---|---|---|---|---|
| Landsat 5 SR | `LANDSAT/LT05/C02/T1_L2` | 30 m | 1984--2012, 16 days | SR_B1--SR_B5, SR_B7, ST_B6 |
| Landsat 7 SR | `LANDSAT/LE07/C02/T1_L2` | 30 m | 1999--present, 16 days | SR_B1--SR_B5, SR_B7, ST_B6 |
| Landsat 8 SR | `LANDSAT/LC08/C02/T1_L2` | 30 m | 2013--present, 16 days | SR_B1--SR_B7, ST_B10 |
| Landsat 9 SR | `LANDSAT/LC09/C02/T1_L2` | 30 m | 2021--present, 16 days | SR_B1--SR_B7, ST_B10 |
| Sentinel-2 SR | `COPERNICUS/S2_SR_HARMONIZED` | 10 m | 2017--present, 5 days | B2, B3, B4, B8, B11, B12, SCL |
| Sentinel-2 Cloud Prob. | `COPERNICUS/S2_CLOUD_PROBABILITY` | 10 m | 2017--present, 5 days | probability |
| MODIS Terra SR | `MODIS/061/MOD09GA` | 500 m | 2000--present, daily | sur_refl_b01--sur_refl_b07 |
| NAIP | `USDA/NAIP/DOQQ` | 0.6--1 m | Varies by state, ~2--3 yr | R, G, B, N |

### Radar

| Dataset | Asset ID | Resolution | Key Bands |
|---|---|---|---|
| Sentinel-1 GRD | `COPERNICUS/S1_GRD` | 10 m | VV, VH, angle |

### Elevation and Terrain

| Dataset | Asset ID | Resolution | Key Bands |
|---|---|---|---|
| SRTM 30 m | `USGS/SRTMGL1_003` | 30 m | elevation |
| ALOS DEM | `JAXA/ALOS/AW3D30/V3_2` | 30 m | DSM |
| Copernicus DEM GLO-30 | `COPERNICUS/DEM/GLO30` | 30 m | DEM |

### Climate and Weather

| Dataset | Asset ID | Resolution | Temporal | Key Bands |
|---|---|---|---|---|
| ERA5 Monthly | `ECMWF/ERA5_LAND/MONTHLY_AGGR` | 11 km | 1950--present, monthly | temperature_2m, total_precipitation_sum |
| CHIRPS Precipitation | `UCSB-CHG/CHIRPS/DAILY` | 5.5 km | 1981--present, daily | precipitation |
| GPM Precipitation | `NASA/GPM_L3/IMERG_V07` | 11 km | 2000--present, 30 min | precipitation |
| MODIS LST | `MODIS/061/MOD11A1` | 1 km | 2000--present, daily | LST_Day_1km, LST_Night_1km |
| MODIS ET | `MODIS/061/MOD16A2` | 500 m | 2001--present, 8 days | ET, PET |

### Vegetation

| Dataset | Asset ID | Resolution | Temporal | Key Bands |
|---|---|---|---|---|
| MODIS NDVI | `MODIS/061/MOD13A2` | 1 km | 2000--present, 16 days | NDVI, EVI |
| MODIS LAI | `MODIS/061/MCD15A3H` | 500 m | 2002--present, 4 days | Lai, Fpar |
| USDA CDL | `USDA/NASS/CDL` | 30 m | 2008--present, yearly | cropland |

### Land Cover

| Dataset | Asset ID | Resolution | Temporal | Key Bands |
|---|---|---|---|---|
| ESA WorldCover | `ESA/WorldCover/v200` | 10 m | 2021 | Map |
| MODIS Land Cover | `MODIS/061/MCD12Q1` | 500 m | 2001--present, yearly | LC_Type1 |
| Dynamic World | `GOOGLE/DYNAMICWORLD/V1` | 10 m | 2015--present, ~5 days | label, water, trees, ... |
| NLCD | `USGS/NLCD_RELEASES/2021_REL/NLCD` | 30 m | Multi-year | landcover |

### Water

| Dataset | Asset ID | Resolution | Temporal | Key Bands |
|---|---|---|---|---|
| JRC Global Surface Water | `JRC/GSW1_4/GlobalSurfaceWater` | 30 m | 1984--2021 | occurrence, recurrence, seasonality |
| MODIS Snow Cover | `MODIS/061/MOD10A1` | 500 m | 2000--present, daily | NDSI_Snow_Cover |

### Nightlights and Population

| Dataset | Asset ID | Resolution | Temporal | Key Bands |
|---|---|---|---|---|
| VIIRS DNB Monthly | `NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG` | 500 m | 2012--present, monthly | avg_rad |
| DMSP-OLS Nightlights | `NOAA/DMSP-OLS/NIGHTTIME_LIGHTS` | 1 km | 1992--2013, yearly | stable_lights |
| WorldPop | `WorldPop/GP/100m/pop` | 100 m | 2000--2020, yearly | population |
| GHSL Built-Up | `JRC/GHSL/P2023A/GHS_BUILT_S` | 10 m | Multi-epoch | built_surface_nres |

### Atmosphere

| Dataset | Asset ID | Resolution | Key Bands |
|---|---|---|---|
| Sentinel-5P NO2 | `COPERNICUS/S5P/OFFL/L3_NO2` | 1113 m | tropospheric_NO2_column_number_density |
| Sentinel-5P SO2 | `COPERNICUS/S5P/OFFL/L3_SO2` | 7 km | SO2_column_number_density |
| Sentinel-5P CO | `COPERNICUS/S5P/OFFL/L3_CO` | 1113 m | CO_column_number_density |
| Sentinel-5P O3 | `COPERNICUS/S5P/OFFL/L3_O3` | 7 km | O3_column_number_density |
| MODIS AOD | `MODIS/061/MOD04_3K` | 3 km | Optical_Depth_Land_And_Ocean |

### Soil

| Dataset | Asset ID | Resolution | Key Bands |
|---|---|---|---|
| OpenLandMap Clay | `OpenLandMap/SOL/SOL_CLAY-WFRACTION_USDA-3A1A1A_M/v02` | 250 m | b0, b10, b30, b60, b100, b200 |
| OpenLandMap Sand | `OpenLandMap/SOL/SOL_SAND-WFRACTION_USDA-3A1A1A_M/v02` | 250 m | b0, b10, b30, b60, b100, b200 |
| OpenLandMap Organic Carbon | `OpenLandMap/SOL/SOL_ORGANIC-CARBON_USDA-6A1C_M/v02` | 250 m | b0, b10, b30, b60, b100, b200 |

---

## Appendix C: Common Pipeline Patterns

### 1. Cloud-Free RGB Composite (Sentinel-2)

```wolfram
bbox = {-122.5, 37.7, -122.3, 37.9};

composite =
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
    // GEEFilterDate["2023-06-01", "2023-09-01"]
    // GEEFilterBounds[bbox]
    // GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 20]
    // GEESelectBands[{"B4", "B3", "B2"}]
    // GEEMedian
    // GEEVisualize[<|"min" -> 0, "max" -> 3000|>];

GEEComputePixels[bbox, composite]
```

### 2. NDVI Map with Green Palette

```wolfram
bbox = {-105.3, 39.9, -104.9, 40.1};

ndvi =
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
    // GEEFilterDate["2023-07-01", "2023-08-01"]
    // GEEFilterBounds[bbox]
    // GEEMedian
    // GEENormalizedDifference[{"B8", "B4"}]
    // GEEVisualize[<|
        "min" -> -0.1, "max" -> 0.8,
        "palette" -> {"white", "lightyellow", "green", "darkgreen"}
    |>];

GEEComputePixels[bbox, ndvi]
```

### 3. Land Surface Temperature (Landsat Thermal)

```wolfram
bbox = {-118.5, 33.8, -118.1, 34.1};

(* Landsat 8 thermal band, scale factor 0.00341802 + 149.0, convert K to C *)
lst =
    GEECollection["LANDSAT/LC08/C02/T1_L2"]
    // GEEFilterDate["2023-07-01", "2023-09-01"]
    // GEEFilterBounds[bbox]
    // GEEMedian
    // GEESelectBands[{"ST_B10"}]
    // GEEMultiply[0.00341802]
    // GEEAdd[149.0]
    // GEESubtract[273.15]
    // GEEVisualize[<|
        "min" -> 20, "max" -> 50,
        "palette" -> {"blue", "yellow", "red"}
    |>];

GEEComputePixels[bbox, lst]
```

### 4. Cloud Masking with SCL Band

```wolfram
(* Define a cloud-masking function using the Scene Classification Layer *)
maskClouds[img_] :=
    Module[{scl, mask},
        scl = img // GEESelectBands[{"SCL"}];
        (* SCL values 3=cloud shadow, 8=cloud medium, 9=cloud high, 10=cirrus *)
        mask =
            scl // GEENotEquals[3]
            // GEEAnd[scl // GEENotEquals[8]]
            // GEEAnd[scl // GEENotEquals[9]]
            // GEEAnd[scl // GEENotEquals[10]];
        img // GEEUpdateMask[mask]
    ];

bbox = {-122.5, 37.7, -122.3, 37.9};

composite =
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
    // GEEFilterDate["2023-01-01", "2023-12-31"]
    // GEEFilterBounds[bbox]
    // GEECollectionMap[maskClouds]
    // GEESelectBands[{"B4", "B3", "B2"}]
    // GEEMedian
    // GEEVisualize[<|"min" -> 0, "max" -> 3000|>];

GEEComputePixels[bbox, composite]
```

### 5. Time Series Extraction (Monthly Loop Pattern)

```wolfram
bbox = {-93.3, 41.5, -93.1, 41.7};
months = Table[
    {DateString[{2023, m, 1}, "ISODate"],
     DateString[{2023, m + 1, 1}, "ISODate"]},
    {m, 1, 12}
];

monthlyNDVI = Table[
    Module[{img},
        img =
            GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
            // GEEFilterDate[start, end]
            // GEEFilterBounds[bbox]
            // GEEMedian
            // GEENormalizedDifference[{"B8", "B4"}];
        GEEReduceRegion[img, GEEGeometry[bbox], "mean", 100]
    ],
    {{start, end}, months}
];

DateListPlot[
    TimeSeries[monthlyNDVI, {DateObject /@ months[[All, 1]]}],
    PlotLabel -> "Monthly Mean NDVI",
    FrameLabel -> {"Date", "NDVI"}
]
```

### 6. Multi-Region Statistics (Batch Pattern)

```wolfram
(* Define regions of interest *)
cities = <|
    "Denver"  -> {-105.0, 39.7, -104.9, 39.8},
    "Boulder" -> {-105.3, 40.0, -105.2, 40.1},
    "FtCollins" -> {-105.1, 40.55, -105.0, 40.6}
|>;

dem = GEELoadImage["USGS/SRTMGL1_003"];

elevationStats = Association @ KeyValueMap[
    Function[{name, bbox},
        name -> GEEReduceRegion[dem, GEEGeometry[bbox], "mean", 30]
    ],
    cities
];

BarChart[Values[elevationStats],
    ChartLabels -> Keys[elevationStats],
    AxesLabel -> {"City", "Mean Elevation (m)"}
]
```

### 7. Change Detection (Before/After Subtraction)

```wolfram
bbox = {-120.5, 36.5, -120.0, 37.0};

before =
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
    // GEEFilterDate["2020-06-01", "2020-09-01"]
    // GEEFilterBounds[bbox]
    // GEEMedian
    // GEENormalizedDifference[{"B8", "B4"}];

after =
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
    // GEEFilterDate["2023-06-01", "2023-09-01"]
    // GEEFilterBounds[bbox]
    // GEEMedian
    // GEENormalizedDifference[{"B8", "B4"}];

change =
    after
    // GEESubtract[before]
    // GEEVisualize[<|
        "min" -> -0.5, "max" -> 0.5,
        "palette" -> {"red", "white", "green"}
    |>];

GEEComputePixels[bbox, change]
```

### 8. Water Body Mapping (NDWI Threshold)

```wolfram
bbox = {-90.3, 29.9, -89.9, 30.1};

(* NDWI = (Green - NIR) / (Green + NIR) *)
waterMap =
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
    // GEEFilterDate["2023-06-01", "2023-09-01"]
    // GEEFilterBounds[bbox]
    // GEEMedian
    // GEENormalizedDifference[{"B3", "B8"}]
    // GEEGreaterThan[0.0]
    // GEESelfMask
    // GEEVisualize[<|
        "min" -> 0, "max" -> 1,
        "palette" -> {"blue"}
    |>];

GEEComputePixels[bbox, waterMap]
```

### 9. Terrain Analysis (DEM to Slope and Hillshade)

```wolfram
bbox = {-105.4, 39.6, -105.0, 40.0};

dem = GEELoadImage["USGS/SRTMGL1_003"];
terrain = GEETerrain[dem];

(* Slope visualization *)
slope =
    terrain
    // GEESelectBands[{"slope"}]
    // GEEVisualize[<|
        "min" -> 0, "max" -> 60,
        "palette" -> {"green", "yellow", "red"}
    |>];

(* Hillshade visualization *)
hillshade =
    terrain
    // GEESelectBands[{"hillshade"}]
    // GEEVisualize[<|"min" -> 0, "max" -> 255|>];

GraphicsRow[{
    GEEComputePixels[bbox, slope],
    GEEComputePixels[bbox, hillshade]
}]
```

### 10. Nightlight Comparison Across Cities

```wolfram
cities = <|
    "NYC"     -> {-74.1, 40.6, -73.8, 40.9},
    "Chicago" -> {-87.8, 41.7, -87.5, 42.0},
    "Houston" -> {-95.5, 29.6, -95.2, 29.9}
|>;

nightlight =
    GEECollection["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG"]
    // GEEFilterDate["2023-01-01", "2023-12-31"]
    // GEEMedian
    // GEESelectBands[{"avg_rad"}];

radiance = Association @ KeyValueMap[
    Function[{name, bbox},
        name -> GEEReduceRegion[nightlight, GEEGeometry[bbox], "mean", 500]
    ],
    cities
];

BarChart[Values[radiance],
    ChartLabels -> Keys[radiance],
    AxesLabel -> {"City", "Mean Radiance (nW/cm^2/sr)"},
    PlotLabel -> "Nightlight Radiance Comparison"
]
```

### 11. Crop Classification Training Data Extraction

```wolfram
(* Extract spectral signatures by land cover type from CDL *)
bbox = {-93.5, 41.5, -93.0, 42.0};

s2 =
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
    // GEEFilterDate["2023-07-01", "2023-08-01"]
    // GEEFilterBounds[bbox]
    // GEEMedian
    // GEESelectBands[{"B2", "B3", "B4", "B8", "B11", "B12"}];

(* Sample random pixels *)
samples = GEESample[s2, GEEGeometry[bbox], 100];

(* Convert to Dataset for analysis *)
ds = Dataset[samples];
```

### 12. Precipitation Accumulation from CHIRPS

```wolfram
bbox = {32.0, -5.0, 42.0, 5.0};

precip =
    GEECollection["UCSB-CHG/CHIRPS/DAILY"]
    // GEEFilterDate["2023-03-01", "2023-05-31"]
    // GEEFilterBounds[bbox]
    // GEECollectionSum
    // GEESelectBands[{"precipitation"}]
    // GEEVisualize[<|
        "min" -> 0, "max" -> 800,
        "palette" -> {"white", "lightblue", "blue", "purple"}
    |>];

GEEComputePixels[bbox, precip]
```

### 13. Quality Mosaic (Best-Pixel Selection)

```wolfram
bbox = {-122.5, 37.5, -121.5, 38.0};

(* Select the pixel with the highest NDVI across the collection *)
addNDVI[img_] :=
    img // GEEAddBands[
        img // GEENormalizedDifference[{"B8", "B4"}] // GEERename[{"NDVI"}]
    ];

bestPixel =
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
    // GEEFilterDate["2023-06-01", "2023-09-01"]
    // GEEFilterBounds[bbox]
    // GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 30]
    // GEECollectionMap[addNDVI]
    // GEEQualityMosaic["NDVI"]
    // GEESelectBands[{"B4", "B3", "B2"}]
    // GEEVisualize[<|"min" -> 0, "max" -> 3000|>];

GEEComputePixels[bbox, bestPixel]
```

### 14. Clipping to Custom Polygon

```wolfram
(* Define a custom polygon (e.g., a park boundary) *)
parkBoundary = GEEPolygon[{
    {-105.60, 40.35}, {-105.50, 40.40}, {-105.45, 40.38},
    {-105.48, 40.30}, {-105.58, 40.30}, {-105.60, 40.35}
}];

dem =
    GEELoadImage["USGS/SRTMGL1_003"]
    // GEEClip[parkBoundary]
    // GEEVisualize[<|
        "min" -> 2400, "max" -> 4000,
        "palette" -> {"green", "yellow", "brown", "white"}
    |>];

GEEComputePixels[{-105.65, 40.28, -105.40, 40.42}, dem]
```

### 15. Band Math with Expression (EVI Formula)

```wolfram
bbox = {-95.5, 29.5, -95.0, 30.0};

s2 =
    GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
    // GEEFilterDate["2023-07-01", "2023-08-01"]
    // GEEFilterBounds[bbox]
    // GEEMedian;

(* Enhanced Vegetation Index *)
evi =
    s2 // GEEExpression[
        "2.5 * ((NIR - RED) / (NIR + 6 * RED - 7.5 * BLUE + 1))",
        <|
            "NIR"  -> <|"type" -> "Image", "id" -> "B8"|>,
            "RED"  -> <|"type" -> "Image", "id" -> "B4"|>,
            "BLUE" -> <|"type" -> "Image", "id" -> "B2"|>
        |>
    ]
    // GEEVisualize[<|
        "min" -> -0.1, "max" -> 0.7,
        "palette" -> {"brown", "yellow", "green", "darkgreen"}
    |>];

GEEComputePixels[bbox, evi]
```

---

## Appendix D: Wolfram Language Integration Cheat Sheet

### Geographic Functions

| Function | Use With GEE |
|---|---|
| `GeoGraphics` | Display GEE raster tiles on an interactive map |
| `GeoRegionValuePlot` | Choropleth maps from GEE-derived regional statistics |
| `GeoListPlot` | Plot sampled point data on a map |
| `GeoBubbleChart` | Proportional symbol maps from GEE statistics |
| `GeoPosition` | Specify query points for `GEEIdentify` and `GEEGetSamples` |
| `GeoDistance` | Measure distances between sample locations |
| `GeoElevationData` | Compare local Wolfram DEM data with GEE SRTM |
| `GeoBoundingBox` | Extract bounding boxes from entities for use with `GEEComputePixels` |
| `Entity` | Pass countries, states, or cities directly to `GEEComputePixels` or `GEEImage` |

### Image Processing

| Function | Use With GEE |
|---|---|
| `ImageAdjust` | Stretch contrast of retrieved satellite images |
| `Sharpen` | Enhance edges in satellite imagery |
| `Binarize` | Threshold classification maps (water/no-water) |
| `MorphologicalComponents` | Label connected regions in classified images |
| `ComponentMeasurements` | Measure area and shape of detected features |
| `EdgeDetect` | Find boundaries in land-cover or water masks |
| `ImageDifference` | Local change detection between two date composites |
| `ColorConvert` | Convert color spaces for visual analysis |
| `DominantColors` | Extract representative colors from land-cover tiles |

### Time Series Analysis

| Function | Use With GEE |
|---|---|
| `TimeSeries` | Wrap monthly/weekly GEE-derived values |
| `TemporalData` | Multi-variate time series from multiple bands |
| `DateListPlot` | Plot NDVI, temperature, or precipitation over time |
| `MovingAverage` | Smooth noisy satellite-derived time series |
| `TimeSeriesResample` | Resample irregular observations to regular intervals |
| `TimeSeriesForecast` | Project vegetation or climate trends forward |

### Statistics and Machine Learning

| Function | Use With GEE |
|---|---|
| `Classify` | Train land-cover classifiers from GEE training data |
| `Predict` | Predict continuous values (biomass, yield) |
| `FindClusters` | Unsupervised land-cover clustering from spectral bands |
| `ClassifierMeasurements` | Evaluate accuracy of GEE-derived classification |
| `LinearModelFit` | Regression between spectral indices and field data |
| `FindFit` | Fit phenology curves to NDVI time series |
| `DimensionReduction` | PCA on multi-band imagery for feature reduction |

### Signal Processing

| Function | Use With GEE |
|---|---|
| `Fourier` | Frequency analysis of seasonal vegetation patterns |
| `Periodogram` | Identify dominant cycles in climate data |
| `BandpassFilter` | Isolate seasonal signals in NDVI time series |
| `LowpassFilter` | Remove high-frequency noise from time series |

### Data Handling

| Function | Use With GEE |
|---|---|
| `Dataset` | Structure GEE query results for tabular analysis |
| `Import` / `Export` | Read/write GeoTIFF, CSV, JSON results |
| `WeatherData` | Compare GEE climate data with Wolfram weather data |
| `SunPosition` | Compute solar geometry for radiometric correction |
| `Quantity` / `UnitConvert` | Handle physical units (meters, Kelvin, hectares) |

### Visualization

| Function | Use With GEE |
|---|---|
| `ListPlot` / `ListLinePlot` | Plot extracted pixel values and time series |
| `BarChart` | Compare statistics across regions or dates |
| `GraphicsRow` / `GraphicsGrid` | Side-by-side satellite image comparisons |
| `Manipulate` | Interactive exploration of date ranges or thresholds |
| `ColorData` | Map color schemes to continuous raster values |

---

## Appendix E: Troubleshooting

### Authentication Errors

**`GEEConnect::keynotfound` -- Key file not found**

The service account JSON key file path is incorrect or the file does not exist.

```wolfram
(* Verify the file exists before calling GEEConnect *)
FileExistsQ["path/to/key.json"]
(* Use an absolute path *)
GEEConnect[FileNameJoin[{$HomeDirectory, "keys", "gee-service-account.json"}]]
```

**`GEEConnect::invalidkey` -- Invalid service account JSON key**

The file exists but is not a valid GEE service account key. Ensure you downloaded a JSON key (not P12) from the Google Cloud Console under IAM > Service Accounts.

**`GEEConnect::authfail` -- Failed to obtain access token**

The service account exists but authentication failed. Common causes:
- The Earth Engine API is not enabled for the project
- The service account does not have Earth Engine access
- Network connectivity issues or proxy interference

### API Errors

**`GEEComputePixels::apierr` -- Expression tree errors**

This is the most common runtime error. Typical causes and fixes:

| Symptom | Cause | Fix |
|---|---|---|
| "Band not found" | Selecting a band that does not exist in the image | Check band names with `GEEGetAssetInfo` |
| "Image.select: Band ... not found" | Band name changed after aggregation | Use suffixed names: `"B4_median"` instead of `"B4"` |
| "Geometry out of range" | Coordinates in wrong order | Use `{west, south, east, north}` not `{south, west, north, east}` |
| "Too many pixels" | Region too large for the requested scale | Reduce bounding box size or increase scale |

**`GEEComputePixels::notimage` -- Server returned non-image content**

The server returned an error document instead of image bytes. Usually means the expression produced no data (empty collection after filtering, fully masked region).

### Band Name Suffixes After Aggregation

When you apply a reducer to a collection, band names gain a suffix:

| Reducer | Suffix Example |
|---|---|
| `GEEMedian` | `B4` becomes `B4_median` |
| `GEEMean` | `B4` becomes `B4_mean` |
| `GEECollectionMin` | `B4` becomes `B4_min` |
| `GEECollectionMax` | `B4` becomes `B4_max` |
| `GEECollectionSum` | `B4` becomes `B4_sum` |

**Tip:** Select bands before aggregation to avoid suffix issues:

```wolfram
(* This works: select before median *)
coll // GEESelectBands[{"B4", "B3", "B2"}] // GEEMedian

(* This may fail if you reference "B4" after median *)
coll // GEEMedian // GEESelectBands[{"B4"}]  (* needs "B4_median" *)
```

### Bounding Box and Memory Limits

GEE imposes server-side limits on the number of pixels in a single request. If your request fails:

- Reduce the bounding box area
- Increase the `"ImageSize"` denominator (fewer pixels requested)
- Use a coarser-resolution dataset
- Process in tiles and stitch locally

### Rate Limiting and Quotas

Google Earth Engine enforces per-project quotas. If you receive HTTP 429 responses:

- Add `Pause[1]` between batch requests
- Reduce concurrency (avoid `ParallelMap` over GEE calls)
- Monitor quota usage in the Google Cloud Console

### VisParams Not Working

If the image appears all-black or all-white after applying `GEEVisualize`:

- The `"min"` and `"max"` values do not match the data range. Use `GEEReduceRegion` with `"min"` and `"max"` reducers to find actual data range.
- For surface reflectance data, Sentinel-2 values are typically 0--10000 (not 0--1).
- For Landsat Collection 2, surface reflectance has a scale factor of 0.0000275 and offset of -0.2.
- Temperature products are often in Kelvin (scaled). Check the dataset documentation for scale factors.

### Band Selection: Before vs. After Aggregation

A common source of confusion is when to select bands in the pipeline:

```wolfram
(* Preferred: select bands before aggregation *)
(* Fewer bands processed = faster computation *)
GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
// GEEFilterDate["2023-06-01", "2023-09-01"]
// GEESelectBands[{"B4", "B3", "B2"}]
// GEEMedian

(* Alternative: select after aggregation *)
(* Band names may have suffixes depending on the reducer *)
GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
// GEEFilterDate["2023-06-01", "2023-09-01"]
// GEEMedian
// GEESelectBands[{"B4_median", "B3_median", "B2_median"}]
```

---

## Appendix F: Glossary

**Asset**
A named resource in the Google Earth Engine data catalog, identified by a string path such as `"USGS/SRTMGL1_003"`. Assets can be images, image collections, tables, or folders.

**Band**
A single channel of data within an image. Each band has a name, data type, and spatial resolution. For example, Sentinel-2 band `"B4"` is the red channel at 10 m resolution.

**Bounding Box**
A rectangular geographic extent specified as `{west, south, east, north}` in decimal degrees (EPSG:4326). Used to define the spatial scope of pixel retrieval.

**Collection**
See ImageCollection.

**Composite**
A single image created by combining multiple images from a collection, typically using a reducer such as median or mosaic. Compositing reduces cloud contamination and fills data gaps.

**Expression Tree**
The internal representation of a GEE computation. Functions like `GEEFilterDate`, `GEEMedian`, and `GEESelectBands` build nested Association structures that are serialized to JSON and sent to the GEE REST API for server-side execution.

**Feature**
A geographic object consisting of a geometry and a set of properties (key-value pairs). Analogous to a row in a GIS attribute table.

**FeatureCollection**
A collection of Features, analogous to a vector layer or shapefile. Created with `GEEFeatureCollection` and queried with `GEEComputeFeatures`.

**Geometry**
A geographic shape -- point, line, polygon, or rectangle -- used for spatial filtering, clipping, and region reduction. Created with `GEEGeometry`, `GEEPolygon`, or `GEELineString`.

**Image**
The fundamental raster data type in GEE. An Image contains one or more bands, each with pixel values, a coordinate reference system, and metadata properties.

**ImageCollection**
An ordered set of Images, typically from the same sensor and covering different dates or locations. Created with `GEECollection` and refined with filter and aggregation functions.

**Mask**
A per-pixel binary flag indicating whether a pixel is valid (1) or invalid/missing (0). Masked pixels are excluded from computations and display. Manipulated with `GEEUpdateMask`, `GEEUnmask`, and `GEESelfMask`.

**Mosaic**
A compositing method that overlays images in order, with later images covering earlier ones. The last valid pixel wins. Created with `GEEMosaic`.

**NDVI (Normalized Difference Vegetation Index)**
A spectral index computed as (NIR - Red) / (NIR + Red). Values range from -1 to 1, where higher values indicate denser vegetation. Computed with `GEENormalizedDifference[{"B8", "B4"}]` for Sentinel-2.

**Pixel**
The smallest spatial unit in a raster image. Each pixel has one value per band and covers a ground area determined by the image resolution.

**Reducer**
An aggregation operation applied across images in a collection (temporal reduction) or across pixels in a region (spatial reduction). Examples include mean, median, min, max, sum, and standard deviation.

**Scale**
The spatial resolution of a computation in meters per pixel. When using `GEEReduceRegion`, the scale parameter controls how finely pixels are sampled within the region.

**Surface Reflectance**
Satellite measurements corrected for atmospheric effects, representing the fraction of sunlight reflected by the Earth's surface. Sentinel-2 SR values range from 0 to 10000 (scale factor 0.0001).

**VisParams (Visualization Parameters)**
An Association controlling how image values are mapped to display colors. Common keys include `"min"`, `"max"`, `"palette"`, `"bands"`, and `"gamma"`. Applied with `GEEVisualize`.
