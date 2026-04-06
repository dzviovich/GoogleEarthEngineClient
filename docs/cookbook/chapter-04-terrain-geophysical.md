# Chapter 4: Terrain and Geophysical Analysis

Terrain analysis is foundational to Earth science. Whether you are mapping
landslide hazards, planning road corridors, modeling watershed hydrology, or
classifying ecosystems, the starting point is almost always a Digital Elevation
Model (DEM). This chapter shows how to retrieve, process, and visualize
elevation data and its derivatives using the GoogleEarthEngineClient paclet,
and then extends the techniques to land cover, soil properties, and geophysical
texture analysis.

Throughout this chapter, examples make heavy use of the `//` postfix (pipe)
operator to build composable server-side processing pipelines. Computations run
on the Google Earth Engine backend; only the final rendered pixels are
transferred to your Mathematica session.

**Prerequisite:** Authenticate per Section 1.3 and load the paclet with ``Needs["GoogleEarthEngineClient`"]``.

---

## 4.1 Digital Elevation Models

A DEM assigns an elevation value to every pixel on the Earth's surface. Google
Earth Engine hosts several global DEMs at varying resolutions and vintages.
The three most commonly used are:

| Dataset | Asset ID | Type | Resolution | Notes |
|---------|----------|------|-----------|-------|
| SRTM v3 | `USGS/SRTMGL1_003` | IMAGE | 30 m | Shuttle Radar Topography Mission (2000). Near-global coverage 60N--56S. |
| ALOS World 3D | `JAXA/ALOS/AW3D30/V3_2` | IMAGE_COLLECTION | 30 m | PRISM stereo photogrammetry. Better accuracy in rugged mountainous terrain. |
| Copernicus GLO-30 | `COPERNICUS/DEM/GLO30` | IMAGE_COLLECTION | 30 m | Most recent (2021). Derived from TanDEM-X radar interferometry. |

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
(* Returns <|"Position" -> ..., "Values" -> {8729}, "Bands" -> {"elevation"}, ...  |> *)
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

`GEETerrain` wraps the GEE `Terrain` function, computing slope
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

### 4.3.3 Local Elevation Range (Topographic Ruggedness)

Local elevation range reveals fine-scale landforms that are invisible
in the raw DEM because they are overwhelmed by regional elevation trends.
The technique computes the difference between the focal maximum and focal
minimum, yielding the range of elevation within a neighborhood.

The formula is: `Range = FocalMax(dem, r) - FocalMin(dem, r)`. This yields the
range of elevation within a neighborhood of radius `r`, highlighting ridges,
valleys, and other features at that scale. (Note: this differs from a true
Local Relief Model, which subtracts a smoothed surface from the original DEM.)

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

**Performance note:** Focal operations use a circular kernel whose area
scales with radius squared. A 1000 m radius on 30 m SRTM data creates a
kernel covering roughly 3400 pixels -- this is computationally expensive
and may time out on large bounding boxes. Start with a small region or
reduce the radius. You can also `GEEReproject` to a coarser scale first
to reduce the number of pixels the kernel must process.

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

(* Convert to km^2 -- GEECompute returns an Association, so extract the value *)
flatAreaKm2 = First[Values[totalFlatArea]] / 1.0*^6
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
(* ESA WorldCover v200 is an IMAGE_COLLECTION; filter and mosaic *)
lc = GEECollection["ESA/WorldCover/v200"] //
  GEEFilterDate["2021-01-01", "2022-01-01"] //
  GEEMosaic;

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
(* ESA WorldCover v200 is an IMAGE_COLLECTION *)
lc = GEECollection["ESA/WorldCover/v200"] //
  GEEFilterDate["2021-01-01", "2022-01-01"] //
  GEEMosaic;
bbox = GEEGeometry[{3.3, 50.7, 7.2, 53.6}];

(* Function to compute area for a single class value *)
classArea[classValue_Integer] := Module[{mask, areaImage, stats},
  mask = lc // GEEEquals[classValue];
  areaImage = GEEMultiply[mask, GEEPixelArea[]];
  stats = GEECompute[areaImage // GEEReduceRegion[bbox, "sum", 100]];
  First[Values[stats]]  (* extract numeric value from Association *)
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
(* ESA WorldCover v200 is an IMAGE_COLLECTION *)
lc = GEECollection["ESA/WorldCover/v200"] //
  GEEFilterDate["2021-01-01", "2022-01-01"] //
  GEEMosaic;

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
  First[Values[forestArea]] / First[Values[totalArea]]
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
low entropy indicates uniform surfaces. Internally, `GEEEntropy` constructs
a `Kernel.circle` from the radius -- you pass the radius in meters, not a
raw kernel object. The input image must have integer pixel values; use
`GEEToInt` to convert continuous data (such as elevation) before calling
`GEEEntropy`.

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"];

(* GEEEntropy requires integer input -- convert the DEM first *)
(* Entropy with a 500 m radius neighborhood *)
entropyImg = dem // GEEToInt // GEEEntropy[500];

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

(* Laplacian edge-detection kernel -- must be a GEE expression tree *)
laplacianKernel = <|"functionInvocationValue" -> <|
  "functionName" -> "Kernel.fixed",
  "arguments" -> <|
    "width" -> <|"constantValue" -> 3|>,
    "height" -> <|"constantValue" -> 3|>,
    "weights" -> <|"constantValue" -> {0, -1, 0, -1, 4, -1, 0, -1, 0}|>
  |>
|>|>;

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

(* Three texture metrics -- GEEEntropy requires integer input *)
entropy = dem // GEEToInt // GEEEntropy[500];
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
lc = GEECollection["ESA/WorldCover/v200"] //
  GEEFilterDate["2021-01-01", "2022-01-01"] //
  GEEMosaic;

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

The next chapter applies these techniques to vegetation and agriculture,
covering spectral indices, crop monitoring, yield estimation, and
precision farming workflows.

---

*Next: [Chapter 5: Vegetation, Agriculture & Precision Farming](chapter-05-vegetation-agriculture.md)*
