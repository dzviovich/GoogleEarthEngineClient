# GEEGetSamples

Extract pixel values at multiple GeoPosition points from a GEE image asset.

## Usage

```wolfram
GEEGetSamples[points, assetId]
GEEGetSamples[points, assetId, "Bands" -> bandList]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"Bands"` | `Automatic` | List of band names, or `Automatic` for all |
| `"Project"` | `Automatic` | GCP project ID |

- `points` is a list of `GeoPosition` objects.
- Returns a list of Associations, each with keys `"Position"` and `"Values"`.
- Delegates to `GEEIdentify` for each point.

## Examples

### Elevation Profile Along a Hiking Trail

Sample SRTM elevation at points along a ridge to build an elevation profile. Each point returns one value (meters):

```wolfram
(* Points along the Appalachian Trail near Clingmans Dome *)
trailPoints = {
  GeoPosition[{35.559, -83.500}],
  GeoPosition[{35.562, -83.495}],
  GeoPosition[{35.564, -83.490}],
  GeoPosition[{35.567, -83.485}],
  GeoPosition[{35.570, -83.480}],
  GeoPosition[{35.573, -83.475}]
};
results = GEEGetSamples[trailPoints, "USGS/SRTMGL1_003"];
elevations = First /@ (#["Values"] & /@ results);
ListLinePlot[elevations,
  PlotLabel -> "Appalachian Trail Elevation Profile",
  AxesLabel -> {"Sample Point", "Elevation (m)"},
  Filling -> Bottom]
```

### Compare Nighttime Brightness Across Cities

Sample VIIRS nighttime radiance at city centers to compare urbanization levels:

```wolfram
cities = <|
  "Tokyo" -> GeoPosition[{35.68, 139.69}],
  "London" -> GeoPosition[{51.51, -0.13}],
  "Cairo" -> GeoPosition[{30.04, 31.24}],
  "São Paulo" -> GeoPosition[{-23.55, -46.63}],
  "Nairobi" -> GeoPosition[{-1.29, 36.82}]
|>;
results = GEEGetSamples[Values[cities],
  "NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG",
  "Bands" -> {"avg_rad"}];
radiance = AssociationThread[
  Keys[cities],
  First /@ (#["Values"] & /@ results)
];
BarChart[radiance, ChartLabels -> Keys[radiance],
  AxesLabel -> {None, "Radiance (nW/cm²/sr)"},
  PlotLabel -> "Nighttime Light Intensity"]
```

### Land Cover at Sampling Stations

Identify ESA WorldCover land class at field stations to verify ground truth. Class IDs: 10=Tree, 20=Shrub, 30=Grass, 40=Crop, 50=Built-up, 60=Bare, 80=Water:

```wolfram
stations = {
  GeoPosition[{52.52, 13.40}],   (* Berlin — expect 50 Built-up *)
  GeoPosition[{47.37, 8.54}],    (* Zurich — expect 50 Built-up *)
  GeoPosition[{46.95, 7.45}],    (* Swiss farmland — expect 40 Crop *)
  GeoPosition[{46.60, 7.10}]     (* Swiss Alps forest — expect 10 Tree *)
};
results = GEEGetSamples[stations,
  GEECollection["ESA/WorldCover/v200"] //
    GEEFilterDate["2021-01-01", "2022-01-01"] //
    GEESelectBands[{"Map"}] //
    GEEMosaic];
classIds = First /@ (#["Values"] & /@ results)
(* e.g., {50, 50, 40, 10} *)
```

### NDVI Transect Across a Vegetation Gradient

Sample Sentinel-2 NIR and Red along a transect from Spanish plateau to forested mountains to compute NDVI at each point. NDVI near 0 = bare soil, near 1 = dense vegetation.

Note: bands are returned in alphabetical order (B4 before B8), not the order specified in `GEESelectBands`. Destructure as `{red, nir}` accordingly:

```wolfram
(* Transect from dry Castilla-La Mancha north into the Cantabrian forests *)
transect = Table[
  GeoPosition[{lat, -3.7}],
  {lat, 39.0, 43.0, 0.5}
];
results = GEEGetSamples[transect,
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-05-01", "2024-09-01"] //
    GEEFilterBounds[{-4.2, 38.5, -3.2, 43.5}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 15] //
    GEESelectBands[{"B8", "B4"}] //
    GEEMedian];
ndvi = Map[
  Module[{red, nir},
    (* Alphabetical order: B4=Red first, B8=NIR second *)
    {red, nir} = #["Values"];
    If[AnyTrue[{nir, red}, (# === Null &)],
      Missing["NoData"],
      (nir - red) / (nir + red)
    ]
  ] &,
  results
];
lats = First /@ (First /@ transect);
ListLinePlot[Transpose[{lats, ndvi}],
  PlotLabel -> "NDVI Transect: Spanish Plateau to Cantabrian Forest",
  AxesLabel -> {"Latitude (°N)", "NDVI"},
  PlotRange -> {-0.1, 1}]
```

### Surface Temperature at Weather Station Locations

Sample MODIS land surface temperature at known weather station coordinates to validate satellite-derived temperatures. Values are Kelvin × 0.02:

```wolfram
(* Weather stations across the US Southwest *)
stations = {
  GeoPosition[{33.45, -112.07}],  (* Phoenix *)
  GeoPosition[{36.17, -115.14}],  (* Las Vegas *)
  GeoPosition[{32.22, -110.93}],  (* Tucson *)
  GeoPosition[{35.08, -106.65}]   (* Albuquerque *)
};
results = GEEGetSamples[stations,
  "MODIS/061/MOD11A1",
  "Bands" -> {"LST_Day_1km"}];
tempC = Map[
  If[#["Values"][[1]] === Null,
    Missing["NoData"],
    #["Values"][[1]] * 0.02 - 273.15
  ] &,
  results
];
labels = {"Phoenix", "Las Vegas", "Tucson", "Albuquerque"};
TableForm[
  Transpose[{labels, Round[tempC, 0.1]}],
  TableHeadings -> {None, {"Station", "LST (°C)"}}]
```

### Handling Nodata: Coastal Transect

Sample elevation along a transect that crosses from land to ocean. Ocean pixels return `Null` in SRTM, useful for detecting coastlines programmatically:

```wolfram
(* Transect from Miami Beach into the Atlantic *)
transect = Table[
  GeoPosition[{25.79, lon}],
  {lon, -80.15, -79.95, 0.02}
];
results = GEEGetSamples[transect, "USGS/SRTMGL1_003"];
Table[
  {results[[i]]["Position"][[1, 2]],
   results[[i]]["Values"][[1]]},
  {i, Length[results]}
] // TableForm
(* Land points show small positive values; ocean points show Null *)
```

### Batch Sampling with Generated Grid

Generate a regular grid of sample points over an area and extract values. Useful for creating a coarse raster from point queries:

```wolfram
(* 5x5 grid over the Swiss Alps *)
points = Flatten[
  Table[GeoPosition[{lat, lon}],
    {lat, 46.2, 47.0, 0.2},
    {lon, 7.0, 8.6, 0.4}
  ], 1];
results = GEEGetSamples[points, "USGS/SRTMGL1_003"];
elevations = First /@ (#["Values"] & /@ results);
grid = Partition[elevations, 5];
ListDensityPlot[
  Flatten[Table[
    {j, 5 - i + 1, grid[[i, j]]},
    {i, Length[grid]}, {j, Length[grid[[1]]]}
  ], 1],
  ColorFunction -> "AlpineColors",
  PlotLegends -> Automatic,
  PlotLabel -> "Swiss Alps Elevation Grid (m)"]
```

## Possible Issues

- `GEEGetSamples` delegates to `GEEIdentify` for each point sequentially. For large point lists (>50), expect longer runtimes.
- If a single point fails (e.g., invalid coordinates), its `"Values"` will be `Missing["Failed"]` but other points still return results.
- Band names in results follow server order (alphabetical), not the order specified in the `"Bands"` option.
- For `IMAGE_COLLECTION` assets passed as strings, the collection is filtered spatially and temporally (last 3 years) before mosaicking. Use expression builders for older datasets.

## See Also

`GEEIdentify`, `GEEComputePixels`, `GEECollection`, `GEEFilterDate`, `GEEFilterProperty`
