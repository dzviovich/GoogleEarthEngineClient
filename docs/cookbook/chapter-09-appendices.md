# Chapter 9: Appendices

---

## Appendix A: Function Quick Reference

All public functions in the GoogleEarthEngineClient paclet, organized by category. The **Operator** column indicates whether the function supports a curried form for use with `//` (postfix application).

**No** = direct form only; **N/A** = zero-argument or variable; **Yes** = supports curried `//` form.

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
| `GEEGeometry` | Create a point or rectangle geometry | No | `GEEGeometry[{39.7, -105.0}]` |
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

This catalog reflects datasets available as of early 2026. For the latest catalog, visit the [GEE Data Catalog](https://developers.google.com/earth-engine/datasets/catalog).

### Optical Imagery

| Dataset | Asset ID | Type | Resolution | Temporal | Key Bands |
|---|---|---|---|---|---|
| Landsat 5 SR | `LANDSAT/LT05/C02/T1_L2` | IMAGE_COLLECTION | 30 m | 1984--2012, 16 days | SR_B1--SR_B5, SR_B7, ST_B6 |
| Landsat 7 SR | `LANDSAT/LE07/C02/T1_L2` | IMAGE_COLLECTION | 30 m | 1999--present, 16 days | SR_B1--SR_B5, SR_B7, ST_B6 |
| Landsat 8 SR | `LANDSAT/LC08/C02/T1_L2` | IMAGE_COLLECTION | 30 m | 2013--present, 16 days | SR_B1--SR_B7, ST_B10 |
| Landsat 9 SR | `LANDSAT/LC09/C02/T1_L2` | IMAGE_COLLECTION | 30 m | 2021--present, 16 days | SR_B1--SR_B7, ST_B10 |
| Sentinel-2 SR | `COPERNICUS/S2_SR_HARMONIZED` | IMAGE_COLLECTION | 10 m | 2017--present, 5 days | B2, B3, B4, B8, B11, B12, SCL |
| Sentinel-2 Cloud Prob. | `COPERNICUS/S2_CLOUD_PROBABILITY` | IMAGE_COLLECTION | 10 m | 2017--present, 5 days | probability |
| MODIS Terra SR | `MODIS/061/MOD09GA` | IMAGE_COLLECTION | 500 m | 2000--present, daily | sur_refl_b01--sur_refl_b07 |
| NAIP | `USDA/NAIP/DOQQ` | IMAGE_COLLECTION | 0.6--1 m | Varies by state, ~2--3 yr | R, G, B, N |

### Radar

| Dataset | Asset ID | Type | Resolution | Key Bands |
|---|---|---|---|---|
| Sentinel-1 GRD | `COPERNICUS/S1_GRD` | IMAGE_COLLECTION | 10 m | VV, VH, angle |

### Elevation and Terrain

| Dataset | Asset ID | Type | Resolution | Key Bands |
|---|---|---|---|---|
| SRTM 30 m | `USGS/SRTMGL1_003` | IMAGE | 30 m | elevation |
| ALOS DEM | `JAXA/ALOS/AW3D30/V3_2` | IMAGE | 30 m | DSM |
| Copernicus DEM GLO-30 | `COPERNICUS/DEM/GLO30` | IMAGE_COLLECTION | 30 m | DEM |

### Climate and Weather

| Dataset | Asset ID | Type | Resolution | Temporal | Key Bands |
|---|---|---|---|---|---|
| ERA5 Monthly | `ECMWF/ERA5_LAND/MONTHLY_AGGR` | IMAGE_COLLECTION | 11 km | 1950--present, monthly | temperature_2m, total_precipitation_sum |
| CHIRPS Precipitation | `UCSB-CHG/CHIRPS/DAILY` | IMAGE_COLLECTION | 5.5 km | 1981--present, daily | precipitation |
| GPM Precipitation | `NASA/GPM_L3/IMERG_V07` | IMAGE_COLLECTION | 11 km | 2000--present, 30 min | precipitation |
| MODIS LST | `MODIS/061/MOD11A1` | IMAGE_COLLECTION | 1 km | 2000--present, daily | LST_Day_1km, LST_Night_1km |
| MODIS ET | `MODIS/061/MOD16A2` | IMAGE_COLLECTION | 500 m | 2001--present, 8 days | ET, PET |

### Vegetation

| Dataset | Asset ID | Type | Resolution | Temporal | Key Bands |
|---|---|---|---|---|---|
| MODIS NDVI | `MODIS/061/MOD13A2` | IMAGE_COLLECTION | 1 km | 2000--present, 16 days | NDVI, EVI |
| MODIS LAI | `MODIS/061/MCD15A3H` | IMAGE_COLLECTION | 500 m | 2002--present, 4 days | Lai, Fpar |
| USDA CDL | `USDA/NASS/CDL` | IMAGE_COLLECTION | 30 m | 2008--present, yearly | cropland |

### Land Cover

| Dataset | Asset ID | Type | Resolution | Temporal | Key Bands |
|---|---|---|---|---|---|
| ESA WorldCover | `ESA/WorldCover/v200` | IMAGE_COLLECTION | 10 m | 2021 | Map |
| MODIS Land Cover | `MODIS/061/MCD12Q1` | IMAGE_COLLECTION | 500 m | 2001--present, yearly | LC_Type1 |
| Dynamic World | `GOOGLE/DYNAMICWORLD/V1` | IMAGE_COLLECTION | 10 m | 2015--present, ~5 days | label, water, trees, ... |
| NLCD | `USGS/NLCD_RELEASES/2021_REL/NLCD` | IMAGE | 30 m | Multi-year | landcover |

### Water

| Dataset | Asset ID | Type | Resolution | Temporal | Key Bands |
|---|---|---|---|---|---|
| JRC Global Surface Water | `JRC/GSW1_4/GlobalSurfaceWater` | IMAGE | 30 m | 1984--2021 | occurrence, recurrence, seasonality |
| MODIS Snow Cover | `MODIS/061/MOD10A1` | IMAGE_COLLECTION | 500 m | 2000--present, daily | NDSI_Snow_Cover |

### Nightlights and Population

| Dataset | Asset ID | Type | Resolution | Temporal | Key Bands |
|---|---|---|---|---|---|
| VIIRS DNB Monthly | `NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG` | IMAGE_COLLECTION | 500 m | 2012--present, monthly | avg_rad |
| DMSP-OLS Nightlights | `NOAA/DMSP-OLS/NIGHTTIME_LIGHTS` | IMAGE_COLLECTION | 1 km | 1992--2013, yearly | stable_lights |
| WorldPop | `WorldPop/GP/100m/pop` | IMAGE_COLLECTION | 100 m | 2000--2020, yearly | population |
| GHSL Built-Up | `JRC/GHSL/P2023A/GHS_BUILT_S` | IMAGE_COLLECTION | 10 m | Multi-epoch | built_surface_nres |

### Atmosphere

| Dataset | Asset ID | Type | Resolution | Key Bands |
|---|---|---|---|---|
| Sentinel-5P NO2 | `COPERNICUS/S5P/OFFL/L3_NO2` | IMAGE_COLLECTION | 1113 m | tropospheric_NO2_column_number_density |
| Sentinel-5P SO2 | `COPERNICUS/S5P/OFFL/L3_SO2` | IMAGE_COLLECTION | 7 km | SO2_column_number_density |
| Sentinel-5P CO | `COPERNICUS/S5P/OFFL/L3_CO` | IMAGE_COLLECTION | 1113 m | CO_column_number_density |
| Sentinel-5P O3 | `COPERNICUS/S5P/OFFL/L3_O3` | IMAGE_COLLECTION | 7 km | O3_column_number_density |
| MODIS AOD (3 km) | `MODIS/061/MOD04_3K` | IMAGE_COLLECTION | 3 km | Optical_Depth_Land_And_Ocean |
| MODIS AOD (10 km) | `MODIS/061/MOD04_L2` | IMAGE_COLLECTION | 10 km | Optical_Depth_Land_And_Ocean |

> **Note:** `MOD04_3K` offers higher spatial resolution (3 km) but with more noise and fewer valid retrievals. `MOD04_L2` (10 km, used in Chapter 3) provides more stable retrievals over a wider range of surface types. Choose based on your spatial resolution needs.

### Soil

| Dataset | Asset ID | Type | Resolution | Key Bands |
|---|---|---|---|---|
| OpenLandMap Clay | `OpenLandMap/SOL/SOL_CLAY-WFRACTION_USDA-3A1A1A_M/v02` | IMAGE | 250 m | b0, b10, b30, b60, b100, b200 |
| OpenLandMap Sand | `OpenLandMap/SOL/SOL_SAND-WFRACTION_USDA-3A1A1A_M/v02` | IMAGE | 250 m | b0, b10, b30, b60, b100, b200 |
| OpenLandMap Organic Carbon | `OpenLandMap/SOL/SOL_ORGANIC-CARBON_USDA-6A1C_M/v02` | IMAGE | 250 m | b0, b10, b30, b60, b100, b200 |

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

Use this for cloud-free composites where per-image masking is needed.

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

Use this to build per-month statistics for trend analysis or seasonal decomposition.

```wolfram
bbox = {-93.3, 41.5, -93.1, 41.7};
(* Month 13 normalizes to January of next year *)
months = Table[
    {DateString[{2023, m, 1}, "ISODate"],
     DateString[{2023, m + 1, 1}, "ISODate"]},
    {m, 1, 12}
];

monthlyNDVI = Table[
    Module[{img, result},
        img =
            GEECollection["COPERNICUS/S2_SR_HARMONIZED"]
            // GEEFilterDate[start, end]
            // GEEFilterBounds[bbox]
            // GEEMedian
            // GEENormalizedDifference[{"B8", "B4"}];
        result = GEECompute[GEEReduceRegion[img, GEEGeometry[bbox], "mean", 100]];
        result["nd"]
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
        name -> First @ Values @ GEECompute[
            GEEReduceRegion[dem, GEEGeometry[bbox], "mean", 30]
        ]
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
        name -> First @ Values @ GEECompute[
            GEEReduceRegion[nightlight, GEEGeometry[bbox], "mean", 500]
        ]
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
samples = GEECompute[GEESample[s2, GEEGeometry[bbox], 100]];

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
    // GEESelectBands[{"precipitation_sum"}]
    // GEEVisualize[<|
        "min" -> 0, "max" -> 800,
        "palette" -> {"white", "lightblue", "blue", "purple"}
    |>];

GEEComputePixels[bbox, precip]
```

### 13. Quality Mosaic (Best-Pixel Selection)

Use this when you need the single best pixel per location rather than a statistical composite.

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
        <|"NIR" -> "B8", "RED" -> "B4", "BLUE" -> "B2"|>
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
| `DimensionReduce` | PCA on multi-band imagery for feature reduction |

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
