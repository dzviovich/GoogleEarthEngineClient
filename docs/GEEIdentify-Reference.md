# GEEIdentify

Identify pixel values at a GeoPosition from a Google Earth Engine image asset.

## Usage

```wolfram
GEEIdentify[point, assetId]
GEEIdentify[point, assetId, "Bands" -> bandList]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"Bands"` | `Automatic` | List of band names, or `Automatic` for all |
| `"Project"` | `Automatic` | GCP project ID |

- `point` must be a `GeoPosition`.
- `assetId` can refer to an `IMAGE` or `IMAGE_COLLECTION` asset. Collections are automatically filtered to a small region around the query point and the most recent 3 years of data, then mosaicked into a single image.
- Returns an Association with keys `"Position"`, `"Values"`, and `"Bands"`.
- `"Values"` is a list of numeric pixel values (one per band). Nodata pixels return `Null`.
- `"Bands"` is a list of band name strings. Band order is determined by the server (alphabetical), not by the order specified in the `"Bands"` option.
- Uses `value:compute` with a `reduceRegion` expression internally.

## Examples

### Elevation at a Named Location

Query the elevation of Mount Kilimanjaro's summit (5,895 m):

```wolfram
result = GEEIdentify[GeoPosition[{-3.0674, 37.3556}],
  "USGS/SRTMGL1_003"]
result["Values"]   (* {5880} — SRTM 30 m resolution *)
result["Bands"]    (* {"elevation"} *)
```

### Compare Elevations Across Locations

Retrieve elevations for several world capitals and display as a bar chart:

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
BarChart[elevations, ChartLabels -> Keys[elevations],
  AxesLabel -> {None, "Elevation (m)"},
  PlotLabel -> "Capital City Elevations"]
```

### Land Cover Classification

Determine the ESA WorldCover land class at a point. Class IDs: 10=Tree, 20=Shrub, 30=Grass, 40=Crop, 50=Built-up, 60=Bare, 70=Snow, 80=Water, 90=Wetland, 95=Mangrove, 100=Moss:

```wolfram
result = GEEIdentify[GeoPosition[{48.86, 2.35}],
  GEECollection["ESA/WorldCover/v200"] //
    GEEFilterDate["2021-01-01", "2022-01-01"] //
    GEESelectBands[{"Map"}] //
    GEEMosaic]
result["Values"]   (* {50} — Built-up (central Paris) *)
```

### Nighttime Light Intensity

Query VIIRS nighttime radiance to compare urban vs. rural brightness:

```wolfram
(* Urban: central Tokyo *)
urban = GEEIdentify[GeoPosition[{35.68, 139.69}],
  "NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG",
  "Bands" -> {"avg_rad"}]
(* Rural: Japanese Alps *)
rural = GEEIdentify[GeoPosition[{36.29, 137.65}],
  "NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG",
  "Bands" -> {"avg_rad"}]
{urban["Values"][[1]], rural["Values"][[1]]}
(* e.g., {148.3, 2.1} — nanoWatts/cm^2/sr *)
```

### Vegetation Index (NDVI) from Sentinel-2

Compute NDVI at a point from a cloud-filtered Sentinel-2 composite. Fetch NIR (B8) and Red (B4), then compute (NIR-Red)/(NIR+Red):

```wolfram
result = GEEIdentify[GeoPosition[{-1.95, 30.06}],
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-06-01", "2024-09-01"] //
    GEEFilterBounds[{29.9, -2.1, 30.2, -1.8}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B8", "B4"}] //
    GEEMedian]
{nir, red} = result["Values"];
ndvi = (nir - red) / (nir + red)
(* ~0.7 for dense forest in Nyungwe, Rwanda *)
```

### Surface Temperature (MODIS)

Query MODIS land surface temperature. Values are in Kelvin * 0.02 (scale factor). Convert to Celsius:

```wolfram
result = GEEIdentify[GeoPosition[{25.20, 55.27}],
  "MODIS/061/MOD11A1",
  "Bands" -> {"LST_Day_1km"}]
kelvinScaled = result["Values"][[1]];
tempC = kelvinScaled * 0.02 - 273.15
(* Surface temperature in Dubai in degrees Celsius *)
```

### Ocean Point Returns Null

Points over ocean (where SRTM has no data) return `Null`, which is useful for distinguishing land from water:

```wolfram
result = GEEIdentify[GeoPosition[{0.0, -30.0}],
  "USGS/SRTMGL1_003"]
result["Values"]   (* {Null} — mid-Atlantic ocean *)
```

### Expression Builder Pipeline

Use expression builders for full control. Cloud-filtered Sentinel-2 surface reflectance at a specific agricultural field:

```wolfram
result = GEEIdentify[GeoPosition[{38.53, -121.75}],
  GEECollection["COPERNICUS/S2_SR_HARMONIZED"] //
    GEEFilterDate["2024-05-01", "2024-08-01"] //
    GEEFilterBounds[{-122.0, 38.3, -121.5, 38.7}] //
    GEEFilterProperty["CLOUDY_PIXEL_PERCENTAGE", "LessThan", 10] //
    GEESelectBands[{"B4", "B3", "B2", "B8"}] //
    GEEMedian]
result["Bands"]    (* {"B2", "B3", "B4", "B8"} — alphabetical order *)
result["Values"]   (* {blueVal, greenVal, redVal, nirVal} *)
```

## Possible Issues

- For `IMAGE_COLLECTION` assets, the collection is filtered spatially and temporally (last 3 years) before mosaicking. This prevents errors from heterogeneous band orderings in older images.
- Band names in the result are returned in server order (alphabetical), which may differ from the order specified in the `"Bands"` option.
- Points over nodata regions (e.g., ocean for SRTM) return `Null` values rather than numeric values.
- The `GEEIdentify::apierr` message surfaces the actual GEE API error when a request fails (e.g., invalid asset name).

## See Also

`GEEGetSamples`, `GEEComputePixels`, `GEEImage`, `GEECollection`, `GEEFilterDate`, `GEEFilterProperty`
