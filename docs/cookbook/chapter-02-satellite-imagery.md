# Chapter 2: Satellite Imagery Fundamentals

Working with satellite imagery is the core use case of Google Earth Engine. This
chapter covers the major satellite data sources available through GEE, how to
load and filter them using GoogleEarthEngineClient expression builders, and how
to transform raw sensor data into scientifically meaningful images using both
server-side GEE operations and client-side Wolfram Language processing.

**Prerequisite:** Authenticate per Section 1.3 and load the paclet with ``Needs["GoogleEarthEngineClient`"]``.

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
| NAIP         | B      | G      | R      | N      | --     | --     | --      |

Knowing these mappings is essential for constructing correct band composites.
A "true-color" composite always maps Red, Green, Blue sensor bands to the
display's R, G, B channels -- but the band *names* differ across sensors.

---

## 2.2 Landsat Imagery

The Landsat program, jointly managed by NASA and the USGS, provides the longest
continuous record of satellite Earth observation, stretching back to 1972.
Landsat 8 (launched 2013) carries the OLI and TIRS sensors; Landsat 9
(launched 2021) carries OLI-2 and TIRS-2. Both deliver 30-meter multispectral
imagery with a 16-day revisit cycle. Together they provide 8-day effective coverage.

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
for Landsat Collection 2 surface reflectance. Values around 7000 to 12000 typically
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
The SCL band provides per-pixel classification that you can use to mask unwanted
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
scl = composite // GEESelectBands[{"SCL_median"}];

mask = scl //
  GEENotEquals[3] //
  GEEAnd[scl // GEENotEquals[8]] //
  GEEAnd[scl // GEENotEquals[9]] //
  GEEAnd[scl // GEENotEquals[10]];

(* Step 3: Apply the mask to the RGB bands *)
clean = composite //
  GEESelectBands[{"B4_median", "B3_median", "B2_median"}] //
  GEEUpdateMask[mask];

(* Step 4: Render *)
img = GEEComputePixels[madridBbox, clean,
  "ImageSize" -> {1024, 1024},
  "VisParams" -> <|"min" -> 0, "max" -> 3000|>]
```

> **Note:** For production workflows, apply cloud masking per-image using
> `GEECollectionMap` before compositing (see Appendix C, Pattern 4). The
> post-median approach shown here is a simplified approximation.

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
(operating since 1999) and Aqua (since 2002) satellites, providing daily global
coverage at 250 m to 1 km resolution. While coarser than Landsat or Sentinel-2, MODIS is unmatched for
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
    "bands" -> {"VV_median", "VH_median", "VV_median"},
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
    Function[img,
      img // GEEAddBands[
        img // GEENormalizedDifference[{"B8", "B4"}] // GEERename[{"NDVI"}]
      ]
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
    Function[img,
      img // GEESelectBands[{"B8", "B4"}] //
        GEENormalizedDifference[{"B8", "B4"}]
    ]
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
is the foundation of everything that follows. Chapter 3 applies these
fundamentals to climate and weather datasets, while Chapter 5 extends them
to spectral indices (NDVI, EVI, LAI) and agricultural analysis.

---

*Next: [Chapter 3: Climate and Weather Analysis](chapter-03-climate-weather.md)*
