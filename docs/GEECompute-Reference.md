# GEECompute

Compute an arbitrary value from a Google Earth Engine expression tree.

## Usage

```wolfram
GEECompute[expression]
GEECompute[expression, "Project" -> projectId]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"Project"` | `Automatic` | GCP project ID |

- `expression` is an Association representing a GEE v1 expression tree.
- Expression nodes use `"functionInvocationValue"` for function calls and `"constantValue"` for constants.
- Returns the computed result: a number, string, list, or Association depending on the expression.
- Common function names include `Image.load`, `Image.select`, `Image.reduceRegion`, `ImageCollection.load`, `Collection.loadTable`, `Collection.size`, `Collection.filter`, `GeometryConstructors.Rectangle`, `GeometryConstructors.Point`, `Geometry.area`, `Geometry.centroid`, `Reducer.mean`, `Reducer.min`, `Reducer.max`, `Reducer.sum`, `Reducer.first`.
- Constant expressions (`"constantValue"`) are evaluated and returned as-is.

## Examples

### Image Statistics (reduceRegion)

```wolfram
expr = <|"functionInvocationValue" -> <|
  "functionName" -> "Image.reduceRegion",
  "arguments" -> <|
    "image" -> <|"functionInvocationValue" -> <|
      "functionName" -> "Image.load",
      "arguments" -> <|"id" -> <|"constantValue" -> "USGS/SRTMGL1_003"|>|>
    |>|>,
    "reducer" -> <|"functionInvocationValue" -> <|
      "functionName" -> "Reducer.mean",
      "arguments" -> <||>
    |>|>,
    "geometry" -> <|"functionInvocationValue" -> <|
      "functionName" -> "GeometryConstructors.Rectangle",
      "arguments" -> <|
        "coordinates" -> <|"constantValue" -> {-97.8, 30.2, -97.7, 30.3}|>
      |>
    |>|>,
    "scale" -> <|"constantValue" -> 30|>,
    "bestEffort" -> <|"constantValue" -> True|>
  |>
|>|>;
GEECompute[expr]  (* <|"elevation" -> 213.5...|> *)
```

### Geometry Area

```wolfram
expr = <|"functionInvocationValue" -> <|
  "functionName" -> "Geometry.area",
  "arguments" -> <|
    "geometry" -> <|"functionInvocationValue" -> <|
      "functionName" -> "GeometryConstructors.Rectangle",
      "arguments" -> <|
        "coordinates" -> <|"constantValue" -> {-97.8, 30.2, -97.7, 30.3}|>
      |>
    |>|>
  |>
|>|>;
GEECompute[expr]  (* 1.068...e8 (square meters) *)
```

### Collection Size

```wolfram
expr = <|"functionInvocationValue" -> <|
  "functionName" -> "Collection.size",
  "arguments" -> <|
    "collection" -> <|"functionInvocationValue" -> <|
      "functionName" -> "ImageCollection.load",
      "arguments" -> <|"id" -> <|"constantValue" -> "MODIS/061/MCD12Q1"|>|>
    |>|>
  |>
|>|>;
GEECompute[expr]  (* integer count of images *)
```

### Constant Value

```wolfram
GEECompute[<|"constantValue" -> 42|>]  (* 42 *)
```

## Possible Issues

- The `GEECompute::apierr` message surfaces the actual GEE API error when an expression is invalid.
- Geometry functions that accept `maxError` require an `ErrorMargin` function invocation, not a plain number (omit `maxError` to use the default).

## See Also

`GEEIdentify`, `GEEComputeFeatures`
