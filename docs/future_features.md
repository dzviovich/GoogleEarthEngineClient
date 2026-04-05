# Future Features: Missing Expression Builder Helpers

Comparison of current expression builders against the Google Earth Engine REST API v1 function catalog. Organized by implementation priority.

## Tier 1 — High Value

Users need these frequently; currently requires manual expression tree construction or client-side workarounds.

| Helper | REST API Function | Description |
|--------|-------------------|-------------|
| `GEENormalizedDifference` | `Image.normalizedDifference` | `(b1 - b2) / (b1 + b2)` — essential for NDVI, NDWI, NDBI. Users currently fetch raw bands and compute manually. |
| `GEEClip` | `Image.clip` | Clip image to a geometry (polygon, rectangle). Nearly every production workflow needs this. |
| `GEEUpdateMask` | `Image.updateMask` | Apply/update a pixel mask (e.g., cloud masking by condition). |
| `GEEUnmask` | `Image.unmask` | Replace masked pixels with a value. |
| `GEESelfMask` | `Image.selfMask` | Mask where pixel value is 0 or already masked. |
| `GEEAddBands` | `Image.addBands` | Add bands from another image — critical for compositing derived bands. |
| `GEERename` | `Image.rename` | Rename bands for clarity. |
| `GEEAdd` | `Image.add` | Per-pixel addition (image + image or image + constant). |
| `GEESubtract` | `Image.subtract` | Per-pixel subtraction. |
| `GEEMultiply` | `Image.multiply` | Per-pixel multiplication. |
| `GEEDivide` | `Image.divide` | Per-pixel division. |
| `GEEExpression` | `Image.expression` | Evaluate a text math expression with band variable bindings. Supports `+`, `-`, `*`, `/`, `%`, `**`, ternary, comparisons. |

### Example Use Case: Server-Side NDVI

Currently users must do:
```wolfram
result = GEEIdentify[point, sentinel2Pipeline]
{red, nir} = result["Values"];  (* alphabetical: B4 before B8 *)
ndvi = (nir - red) / (nir + red)
```

With `GEENormalizedDifference`:
```wolfram
ndviImage = sentinel2Pipeline // GEENormalizedDifference[{"B8", "B4"}]
img = GEEComputePixels[bbox, ndviImage,
  "VisParams" -> <|"min" -> -0.1, "max" -> 0.9,
    "palette" -> {"brown", "yellow", "green", "darkgreen"}|>]
```

## Tier 2 — Frequently Used

| Helper | REST API Function | Description |
|--------|-------------------|-------------|
| `GEEGreaterThan` | `Image.gt` | Per-pixel greater than comparison (returns 0/1 mask). |
| `GEELessThan` | `Image.lt` | Per-pixel less than comparison. |
| `GEEEquals` | `Image.eq` | Per-pixel equality comparison. |
| `GEENotEquals` | `Image.neq` | Per-pixel inequality comparison. |
| `GEEAnd` | `Image.and` | Logical AND of two images. |
| `GEEOr` | `Image.or` | Logical OR of two images. |
| `GEENot` | `Image.not` | Logical NOT. |
| `GEEWhere` | `Image.where` | Conditional pixel replacement: `where(test, trueValue)`. |
| `GEECollectionMap` | `Collection.map` | Apply arbitrary transforms per image in a collection. Currently used internally for band selection but not exposed. |
| `GEEQualityMosaic` | `ImageCollection.qualityMosaic` | Mosaic using a quality band (best-pixel compositing). |
| `GEEMerge` | `ImageCollection.merge` | Merge two collections. |
| `GEECollectionMax` | `ImageCollection.max` | Pixel-wise max composite. |
| `GEECollectionMin` | `ImageCollection.min` | Pixel-wise min composite. |
| `GEECollectionSum` | `ImageCollection.sum` | Pixel-wise sum. |
| `GEEToBands` | `ImageCollection.toBands` | Stack collection into multi-band image. |
| `GEEReduceStdDev` | `Reducer.stdDev` | Standard deviation reducer. |
| `GEEReduceCount` | `Reducer.count` | Count reducer. |
| `GEEReducePercentile` | `Reducer.percentile` | Percentile reducer. |

### Example Use Case: Cloud Masking with Comparison + UpdateMask

```wolfram
(* Select the SCL (Scene Classification Layer) band *)
scl = sentinel2Image // GEESelectBands[{"SCL"}]
(* Create mask: SCL != 3 (cloud shadow) AND SCL != 8 (cloud medium) AND SCL != 9 (cloud high) *)
mask = scl // GEENotEquals[3] // GEEAnd[scl // GEENotEquals[8]] // GEEAnd[scl // GEENotEquals[9]]
(* Apply mask to the RGB image *)
cleanImage = rgbImage // GEEUpdateMask[mask]
```

## Tier 3 — Specialized but Valuable

| Helper | REST API Function | Description |
|--------|-------------------|-------------|
| `GEETerrain` | `Algorithms.Terrain` | Compute slope, aspect, hillshade from a DEM. |
| `GEEReproject` | `Image.reproject` | Force a projection and scale. |
| `GEEResample` | `Image.resample` | Set resampling method (bilinear, bicubic). |
| `GEEFocalMean` | `Image.focalMean` | Spatial smoothing (mean kernel). |
| `GEEFocalMax` | `Image.focalMax` | Focal max. |
| `GEEFocalMin` | `Image.focalMin` | Focal min. |
| `GEEFocalMedian` | `Image.focalMedian` | Focal median. |
| `GEEConvolve` | `Image.convolve` | Convolution with a kernel. |
| `GEEGradient` | `Image.gradient` | Compute x/y gradient. |
| `GEEEntropy` | `Image.entropy` | Entropy within a neighborhood. |
| `GEEPixelArea` | `Image.pixelArea` | Image where each pixel value is its area in sq meters. |
| `GEEPixelLonLat` | `Image.pixelLonLat` | Image with lon/lat coordinate bands. |
| `GEEConstant` | `Image.constant` | Create a constant-value image. |
| `GEEReduceRegions` | `Image.reduceRegions` | Reduce over multiple geometries at once. |
| `GEESample` | `Image.sample` | Sample pixel values at random or specified points. |
| `GEEReduceToVectors` | `Image.reduceToVectors` | Vectorize an image. |

### Additional Image Math

| Helper | REST API Function | Description |
|--------|-------------------|-------------|
| `GEEPow` | `Image.pow` | Exponentiation. |
| `GEEMod` | `Image.mod` | Modulo. |
| `GEEAbs` | `Image.abs` | Absolute value. |
| `GEESqrt` | `Image.sqrt` | Square root. |
| `GEELog` | `Image.log` | Natural log. |
| `GEELog10` | `Image.log10` | Log base 10. |
| `GEEExp` | `Image.exp` | Exponential (e^x). |

### Geometry Builders

| Helper | REST API Function | Description |
|--------|-------------------|-------------|
| `GEEPolygon` | `GeometryConstructors.Polygon` | Construct a polygon geometry. |
| `GEELineString` | `GeometryConstructors.LineString` | Construct a line geometry. |
| `GEEBuffer` | `Geometry.buffer` | Buffer a geometry by distance. |
| `GEECentroid` | `Geometry.centroid` | Get centroid of a geometry. |
| `GEEBounds` | `Geometry.bounds` | Get bounding box of a geometry. |
| `GEEArea` | `Geometry.area` | Compute area of a geometry. |

### Property / Metadata

| Helper | REST API Function | Description |
|--------|-------------------|-------------|
| `GEEGet` | `Image.get` | Get a metadata property value. |
| `GEESet` | `Image.set` | Set metadata properties. |
| `GEEDate` | `Image.date` | Get acquisition date. |
| `GEECast` | `Image.cast` | Cast band types. |
| `GEEToFloat` | `Image.toFloat` | Convert all bands to float. |
| `GEEToInt` | `Image.toInt` | Convert all bands to int. |

### Joins

| Helper | REST API Function | Description |
|--------|-------------------|-------------|
| `GEEJoinSimple` | `Join.simple` | Simple join. |
| `GEEJoinInner` | `Join.inner` | Inner join. |
| `GEEJoinSaveBest` | `Join.saveBest` | Save best match. |
| `GEEJoinSaveAll` | `Join.saveAll` | Save all matches. |

## Recommended Implementation Order

1. `GEENormalizedDifference` — Unlocks NDVI/NDWI/NDBI visualization and export
2. `GEEClip` — Required for almost every production workflow
3. `GEEAdd` / `GEESubtract` / `GEEMultiply` / `GEEDivide` — Basic image math
4. `GEEUpdateMask` / `GEEUnmask` — Cloud masking workflows
5. `GEEAddBands` / `GEERename` — Compositing derived bands
6. `GEEExpression` — Complex math in one call
7. Comparison operators (`GEEGreaterThan`, `GEELessThan`, etc.) — Building masks
8. `GEEWhere` — Conditional pixel replacement
9. `GEECollectionMap` (general-purpose) — Apply arbitrary transforms
10. `GEETerrain` — Slope, aspect, hillshade from DEM
