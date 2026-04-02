# GEEGetSamples

Extract pixel values at multiple GeoPosition points from a GEE image asset.

## Usage

```wolfram
GEEGetSamples[points, assetId]
GEEGetSamples[points, assetId, "Bands" -> bandList]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"Bands"` | `Automatic` | List of band names, or `Automatic` for all |
| `"Project"` | `Automatic` | GCP project ID |

- `points` is a list of `GeoPosition` objects.
- Returns a list of Associations, each with keys `"Position"` and `"Values"`.
- Delegates to `GEEIdentify` for each point.

## Examples

### Basic

```wolfram
results = GEEGetSamples[
  {GeoPosition[{30.25, -97.75}], GeoPosition[{30.3, -97.7}]},
  "USGS/SRTMGL1_003"
]
results[[1]]["Values"]
```

## See Also

`GEEIdentify`, `GEEComputePixels`
