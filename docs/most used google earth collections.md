GEE doesn't publish official usage rankings, but based on research literature and community consensus, here are the top 10 most widely used image collections:

| #   | Collection Name                              | GEE ID                                              |
| --- | -------------------------------------------- | --------------------------------------------------- |
| 1   | **Landsat 8 Surface Reflectance**            | `LANDSAT/LC08/C02/T1_L2`                            |
| 2   | **Sentinel-2 MSI Surface Reflectance**       | `COPERNICUS/S2_SR_HARMONIZED`                       |
| 3   | **Landsat 7 ETM+ Surface Reflectance**       | `LANDSAT/LE07/C02/T1_L2`                            |
| 4   | **Landsat 5 TM Surface Reflectance**         | `LANDSAT/LT05/C02/T1_L2`                            |
| 5   | **MODIS Terra NDVI/EVI (MOD13Q1)**           | `MODIS/061/MOD13Q1`                                 |
| 6   | **MODIS Land Cover Type (MCD12Q1)**          | `MODIS/061/MCD12Q1`                                 |
| 7   | **Sentinel-1 SAR GRD**                       | `COPERNICUS/S1_GRD`                                 |
| 8   | **MODIS Land Surface Temperature (MOD11A1)** | `MODIS/061/MOD11A1`                                 |
| 9   | **SRTM Digital Elevation Model**             | `USGS/SRTMGL1_003` *(single image, but ubiquitous)* |
| 10  | **ERA5 Daily Climate Reanalysis**            | `ECMWF/ERA5/DAILY`                                  |

A few notes:

- Landsat-8 is the most frequently used sensor, appearing in ~31% of GEE studies, with Landsat-5 and Landsat-7 at 20% and 14% respectively.
- Sentinel-2 accounts for ~15% of usage and Sentinel-1 ~8%, with optical data clearly preferred over SAR.
- MODIS usage is lower due to its coarser spatial resolution (250m–1km) compared to Landsat and Sentinel.

The SRTM DEM is technically a single image, not a time-series collection, but it's referenced in nearly every GEE workflow that involves terrain.
