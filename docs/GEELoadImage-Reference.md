# GEELoadImage

Create a GEE expression tree for a single Image asset.

## Usage

```wolfram
GEELoadImage[assetId]
```

## Details

- `assetId` is a string identifying a single `IMAGE` asset in the GEE data catalog (e.g., `"USGS/SRTMGL1_003"`, `"ESA/WorldCover/v200"`).
- Returns an Association representing an `Image.load` expression node. This is a lazy expression tree — no data is fetched until it is passed to `GEEComputePixels`, `GEECompute`, or `GEEImage`.
- Use `GEELoadImage` for single-image assets. For `IMAGE_COLLECTION` assets that require filtering and aggregation, use `GEECollection` instead.
- The returned expression can be piped into any image expression builder (`GEESelectBands`, `GEETerrain`, `GEEFocalMean`, `GEEClip`, arithmetic operators, etc.) using `//`.

## Examples

### Basic

```wolfram
dem = GEELoadImage["USGS/SRTMGL1_003"]
```

### Elevation with Color Palette

```wolfram
GEEComputePixels[{-105.4, 39.6, -105.1, 39.8},
  GEELoadImage["USGS/SRTMGL1_003"] //
    GEEVisualize[<|"min" -> 1500, "max" -> 4000,
      "palette" -> {"green", "yellow", "brown", "white"}|>]]
```

### Terrain Analysis

```wolfram
bbox = {6.5, 45.8, 8.5, 47.0};  (* Swiss Alps *)
hillshade = GEELoadImage["USGS/SRTMGL1_003"] //
  GEETerrain //
  GEESelectBands[{"hillshade"}];
GEEComputePixels[bbox, hillshade,
  "VisParams" -> <|"min" -> 0, "max" -> 255|>]
```

### Focal Smoothing

```wolfram
bbox = {-112.3, 36.0, -111.7, 36.5};  (* Grand Canyon *)
smoothDEM = GEELoadImage["USGS/SRTMGL1_003"] //
  GEEFocalMean[1000];
GEEComputePixels[bbox, smoothDEM,
  "VisParams" -> <|"min" -> 700, "max" -> 2500,
    "palette" -> {"green", "yellow", "brown", "white"}|>]
```

### Arithmetic Between Derived Images

```wolfram
bbox = {-105.5, 39.5, -105.0, 40.0};  (* Colorado Front Range *)
dem = GEELoadImage["USGS/SRTMGL1_003"];
localRelief = GEESubtract[
  dem // GEEFocalMax[2000],
  dem // GEEFocalMin[2000]];
GEEComputePixels[bbox, localRelief,
  "VisParams" -> <|"min" -> 0, "max" -> 1000,
    "palette" -> {"white", "yellow", "orange", "red"}|>]
```

### Reduce Region

```wolfram
GEECompute[
  GEELoadImage["USGS/SRTMGL1_003"] //
    GEEReduceRegion[GEEGeometry[{-97.8, 30.2, -97.7, 30.3}], "mean", 30]
]
```

### Land Cover Classification

```wolfram
bbox = {12.4, 41.8, 12.6, 42.0};  (* Rome *)
classified = GEELoadImage["ESA/WorldCover/v200"] //
  GEESelectBands[{"Map"}];
GEEComputePixels[bbox, classified,
  "VisParams" -> <|"min" -> 10, "max" -> 100,
    "palette" -> {"006400", "ffbb22", "ffff4c", "f096ff",
      "fa0000", "b4b4b4", "f0f0f0", "0064c8", "0096a0", "00cf75"}|>]
```

## Possible Issues

- `GEELoadImage` is for single `IMAGE` assets only. Passing an `IMAGE_COLLECTION` asset ID will produce a GEE API error. Use `GEECollection` for collections.
- The expression tree is inert until evaluated by `GEEComputePixels`, `GEECompute`, or `GEEImage`.

## See Also

`GEECollection`, `GEEComputePixels`, `GEECompute`, `GEEImage`, `GEETerrain`, `GEESelectBands`
