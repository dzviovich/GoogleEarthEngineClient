# GEECompute

Compute an arbitrary value from a Google Earth Engine expression tree.

## Usage

```wolfram
GEECompute[expression]
GEECompute[expression, "Project" -> projectId]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"Project"` | `Automatic` | GCP project ID |

- `expression` is an Association representing a GEE v1 expression tree.
- Expression nodes use `"functionInvocationValue"` for function calls and `"constantValue"` for constants.
- Returns the computed result: a number, string, list, or Association depending on the expression.
- Common function names include `Image.load`, `Image.select`, `Image.reduceRegion`, `ImageCollection.load`, `Collection.loadTable`, `Collection.size`, `Collection.filter`, `GeometryConstructors.Rectangle`, `GeometryConstructors.Point`, `Geometry.area`, `Geometry.centroid`, `Reducer.mean`, `Reducer.min`, `Reducer.max`, `Reducer.sum`, `Reducer.first`.
- Constant expressions (`"constantValue"`) are evaluated and returned as-is.

## Examples

### Mean Elevation of a Region

Compute the mean SRTM elevation over a bounding box using `GEEReduceRegion` and `GEEGeometry` helpers with the `//` pipe operator:

```wolfram
result = GEECompute[
  GEELoadImage["USGS/SRTMGL1_003"] //
    GEEReduceRegion[
      GEEGeometry[{86.8, 27.8, 87.2, 28.2}], "mean", 30]
]
result["elevation"]
(* Mean elevation in meters for the Everest region *)
```

### Compare Elevation Statistics Across Mountain Ranges

Compute min, mean, and max elevation for different regions and display as a table:

```wolfram
ranges = <|
  "Alps" -> {6.5, 45.8, 8.5, 47.0},
  "Rockies" -> {-107.0, 38.5, -105.0, 40.0},
  "Andes" -> {-70.0, -34.0, -69.0, -32.5},
  "Himalayas" -> {86.0, 27.5, 88.0, 28.5}
|>;
stats = Association @ Map[
  Module[{img, geom, mn, mx, avg},
    img = GEELoadImage["USGS/SRTMGL1_003"];
    geom = GEEGeometry[ranges[#]];
    mn = GEECompute[img // GEEReduceRegion[geom, "min", 30]];
    mx = GEECompute[img // GEEReduceRegion[geom, "max", 30]];
    avg = GEECompute[img // GEEReduceRegion[geom, "mean", 30]];
    # -> <|"Min" -> mn["elevation"], "Mean" -> Round[avg["elevation"]],
            "Max" -> mx["elevation"]|>
  ] &,
  Keys[ranges]
];
Dataset[stats]
```

### Count Images in a Collection

Count how many cloud-free Sentinel-2 images exist over a date range and region. Useful for checking data availability before running a large pipeline. Use expression builders to filter, then wrap in a raw `Collection.size` call:

```wolfram
coll = GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
  GEEFilterDate["2024-06-01", "2024-09-01"] //
  GEEFilterBounds[{2.2, 48.8, 2.5, 48.9}] //
  GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10];
GEECompute[<|"functionInvocationValue" -> <|
  "functionName" -> "Collection.size",
  "arguments" -> <|"collection" -> coll|>
|>|>]
(* Number of cloud-free scenes over Paris, summer 2024 *)
```

### Mean Reflectance from Cloud-Filtered Sentinel-2

Compute mean surface reflectance for RGB bands over an agricultural region to assess seasonal crop brightness:

```wolfram
result = GEECompute[
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-09-01"] //
    GEEFilterBounds[{-121.8, 38.3, -121.4, 38.7}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2"}] //
    GEEMedian //
    GEEReduceRegion[
      GEEGeometry[{-121.8, 38.3, -121.4, 38.7}], "mean", 10]
]
(* <|"B2" -> ..., "B3" -> ..., "B4" -> ...| > — mean reflectance values *)
```

### Compute Area of a Bounding Box

Compute the area of a geographic rectangle in square kilometers. `Geometry.area` returns square meters:

```wolfram
geom = GEEGeometry[{-73.0, 40.7, -72.0, 41.1}];
areaM2 = GEECompute[<|"functionInvocationValue" -> <|
  "functionName" -> "Geometry.area",
  "arguments" -> <|"geometry" -> geom|>
|>|>];
areaKm2 = areaM2 / 10^6
(* Area in km² of a rectangle over Long Island, NY *)
```

### Nighttime Radiance Statistics for a City

Compute mean and max VIIRS nighttime radiance over a city to quantify light pollution. VIIRS is an `IMAGE_COLLECTION`, so filter and aggregate to a single image first. Use `Values` to extract the numeric result regardless of band name:

```wolfram
geom = GEEGeometry[{-87.75, 41.75, -87.55, 41.95}];
img = GEECollection["NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG"] //
  GEEFilterDate["2024-01-01", "2024-07-01"] //
  GEEFilterBounds[{-87.75, 41.75, -87.55, 41.95}] //
  GEESelectBands[{"avg_rad"}] //
  GEEMedian;
mean = GEECompute[img // GEEReduceRegion[geom, "mean", 500]];
maxVal = GEECompute[img // GEEReduceRegion[geom, "max", 500]];
{First[Values[mean]], First[Values[maxVal]]}
(* {meanRadiance, maxRadiance} for central Chicago in nW/cm²/sr *)
```

### Raw Expression Tree

For operations not covered by helpers, build the expression tree directly. This example computes the centroid of a rectangle:

```wolfram
GEECompute[<|"functionInvocationValue" -> <|
  "functionName" -> "Geometry.centroid",
  "arguments" -> <|
    "geometry" -> GEEGeometry[{-105.3, 39.6, -105.1, 39.8}]
  |>
|>|>]
(* Returns centroid coordinates of a rectangle over Denver *)
```

## Possible Issues

- The `GEECompute::apierr` message surfaces the actual GEE API error when an expression is invalid.
- Geometry functions that accept `maxError` require an `ErrorMargin` function invocation, not a plain number (omit `maxError` to use the default).

## See Also

`GEEIdentify`, `GEEComputeFeatures`, `GEEReduceRegion`, `GEEGeometry`, `GEELoadImage`, `GEECollection`
