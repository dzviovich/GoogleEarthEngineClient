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
- Returns an Association with keys `"Position"`, `"Values"`, and `"Bands"`.
- `"Values"` is a list of numeric pixel values (one per band).
- `"Bands"` is a list of band name strings.
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
result = GEEIdentify[GeoPosition[{30.25, -97.75}],
  "COPERNICUS/S2_SR_HARMONIZED",
  "Bands" -> {"B4", "B3", "B2"}]
```

### NDVI Calculation

```wolfram
result = GEEIdentify[GeoPosition[{30.25, -97.75}],
  "USGS/SRTMGL1_003"];
(* For multi-band imagery: *)
(* ndvi = (nir - red) / (nir + red) *)
```

## See Also

`GEEGetSamples`, `GEEComputePixels`
