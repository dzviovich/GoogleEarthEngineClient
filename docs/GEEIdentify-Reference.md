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

### SRTM Elevation

```wolfram
result = GEEIdentify[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003"]
result["Values"]  (* {elevation value in meters} *)
result["Bands"]   (* {"elevation"} *)
```

### Specific Bands

```wolfram
result = GEEIdentify[GeoPosition[{34.08, -117.45}],
  "NASA/ASTER_GED/AG100_003",
  "Bands" -> {"emissivity_band10", "emissivity_band11"}]
```

### ImageCollection (Sentinel-2)

```wolfram
result = GEEIdentify[GeoPosition[{40.4, -3.7}],
  "COPERNICUS/S2_SR_HARMONIZED",
  "Bands" -> {"B4", "B3", "B2"}]
```

### ImageCollection (Landsat 8)

```wolfram
result = GEEIdentify[GeoPosition[{37.77, -122.42}],
  "LANDSAT/LC08/C02/T1_L2",
  "Bands" -> {"SR_B4", "SR_B3", "SR_B2"}]
```

## Possible Issues

- For `IMAGE_COLLECTION` assets, the collection is filtered spatially and temporally (last 3 years) before mosaicking. This prevents errors from heterogeneous band orderings in older images.
- Band names in the result are returned in server order (alphabetical), which may differ from the order specified in the `"Bands"` option.
- Points over nodata regions (e.g., ocean for SRTM) return `Null` values rather than numeric values.
- The `GEEIdentify::apierr` message surfaces the actual GEE API error when a request fails (e.g., invalid asset name).

## See Also

`GEEGetSamples`, `GEEComputePixels`
