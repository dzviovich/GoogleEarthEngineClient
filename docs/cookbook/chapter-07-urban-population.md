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
