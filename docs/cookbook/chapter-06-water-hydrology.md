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
