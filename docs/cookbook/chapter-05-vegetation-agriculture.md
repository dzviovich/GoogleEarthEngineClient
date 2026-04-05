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
