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

- `expression` is an Association representing a GEE expression tree.
- Expression trees use the format: `<|"type" -> "Invocation", "functionName" -> "...", "arguments" -> <|...|>|>`.
- Constants are wrapped as `<|"constantValue" -> value|>`.
- Returns the computed result (number, string, list, or Association).

## Examples

### Simple Arithmetic

```wolfram
GEECompute[
  <|"type" -> "Invocation",
    "functionName" -> "Number.add",
    "arguments" -> <|
      "left" -> <|"constantValue" -> 2|>,
      "right" -> <|"constantValue" -> 3|>
    |>|>
]
(* 5 *)
```

### Image Statistics

```wolfram
expr = <|"type" -> "Invocation",
  "functionName" -> "Image.reduceRegion",
  "arguments" -> <|
    "input" -> <|"type" -> "Invocation",
      "functionName" -> "Image.load",
      "arguments" -> <|
        "id" -> <|"constantValue" -> "USGS/SRTMGL1_003"|>
      |>|>,
    "reducer" -> <|"type" -> "Invocation",
      "functionName" -> "Reducer.mean",
      "arguments" -> <||>|>,
    "geometry" -> <|"type" -> "Invocation",
      "functionName" -> "GeometryConstructors.Rectangle",
      "arguments" -> <|
        "coordinates" -> <|
          "constantValue" -> {-97.8, 30.2, -97.7, 30.3}
        |>
      |>|>,
    "scale" -> <|"constantValue" -> 30|>,
    "bestEffort" -> <|"constantValue" -> True|>
  |>|>;
GEECompute[expr]
```

## See Also

`GEEIdentify`, `GEEComputeFeatures`
