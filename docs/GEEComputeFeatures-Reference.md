# GEEComputeFeatures

Query features from a Google Earth Engine FeatureCollection.

## Usage

```wolfram
GEEComputeFeatures[assetId, filter]
GEEComputeFeatures[assetId]
GEEComputeFeatures[assetId, filter, opts]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"Properties"` | `All` | Property names to include |
| `"MaxFeatures"` | `1000` | Maximum features to return (API max: 1001) |
| `"GeoBounds"` | `None` | Spatial filter `{west, south, east, north}` |
| `"Project"` | `Automatic` | GCP project ID |

- `assetId` must refer to a `TABLE` asset (e.g., `"TIGER/2018/States"`, `"WCMC/WDPA/current/polygons"`).
- `filter` is a filter expression string. Use `""` for no filter.
- Returns a list of Associations with keys `"Properties"` and `"Geometry"`.
- `"Properties"` is an Association of property name-value pairs.
- `"Geometry"` is an Association with a `"type"` key (e.g., `"Polygon"`, `"MultiPolygon"`) and coordinate data.
- Supports spatial filtering via `"GeoBounds"`.
- The no-filter overload `GEEComputeFeatures[assetId, opts]` is equivalent to passing `""` as the filter.

## Examples

### List US States and Their Land Area

Query all US states and display names with land area. `ALAND` is land area in square meters:

```wolfram
features = GEEComputeFeatures["TIGER/2018/States", "",
  "Properties" -> {"NAME", "ALAND"},
  "MaxFeatures" -> 56];
Dataset[
  SortBy[
    Map[<|"State" -> #["Properties"]["NAME"],
          "Area (km²)" -> Round[#["Properties"]["ALAND"] / 10^6]|> &,
      features],
    -#["Area (km²)"] &
  ]
]
```

### Find Protected Areas Near a Location

Query World Database on Protected Areas within 50 km of Yellowstone to find national parks, wilderness areas, and wildlife refuges:

```wolfram
features = GEEComputeFeatures["WCMC/WDPA/current/polygons", "",
  "GeoBounds" -> {-111.5, 44.0, -109.5, 45.5},
  "Properties" -> {"NAME", "DESIG", "REP_AREA", "STATUS_YR"},
  "MaxFeatures" -> 50];
Dataset[
  Map[<|"Name" -> #["Properties"]["NAME"],
        "Designation" -> #["Properties"]["DESIG"],
        "Area (km²)" -> Round[#["Properties"]["REP_AREA"], 0.1],
        "Year" -> #["Properties"]["STATUS_YR"]|> &,
    features]
]
```

### Counties in a Metro Area

Find all counties within the Denver metropolitan area bounding box and display them as a table:

```wolfram
features = GEEComputeFeatures["TIGER/2018/Counties", "",
  "GeoBounds" -> {-105.3, 39.5, -104.5, 40.1},
  "Properties" -> {"NAME", "STATEFP", "ALAND"},
  "MaxFeatures" -> 20];
TableForm[
  Map[{#["Properties"]["NAME"],
       Round[#["Properties"]["ALAND"] / 10^6]} &,
    features],
  TableHeadings -> {None, {"County", "Area (km²)"}}]
```

### Visualize State Boundaries on a Map

Query a state boundary and convert the GeoJSON geometry to a Wolfram `Polygon` for overlay on `GeoGraphics`. GeoJSON coordinates are `{lon, lat}` pairs; use `Reverse` to convert to `{lat, lon}` for `GeoPosition`. The nesting depends on geometry type: `Polygon` has `coordinates[[ring, point]]`, `MultiPolygon` has `coordinates[[polygon, ring, point]]`:

```wolfram
features = GEEComputeFeatures["TIGER/2018/States", "",
  "GeoBounds" -> {-109.1, 36.9, -102.0, 41.1},
  "Properties" -> {"NAME"},
  "MaxFeatures" -> 1];
geom = features[[1]]["Geometry"];
(* Extract the outer ring, handling both Polygon and MultiPolygon *)
coords = If[geom["type"] === "MultiPolygon",
  geom["coordinates"][[1, 1]],
  geom["coordinates"][[1]]
];
poly = GeoPolygon[GeoPosition[Map[Reverse, coords]]];
GeoGraphics[{EdgeForm[Red], FaceForm[None], poly},
  GeoRange -> {{36.5, 41.5}, {-109.5, -101.5}},
  PlotLabel -> features[[1]]["Properties"]["NAME"]]
```

### Watershed Analysis

Find watersheds (HUC6) that drain into the Chesapeake Bay region and list their names and areas:

```wolfram
features = GEEComputeFeatures["USGS/WBD/2017/HUC06", "",
  "GeoBounds" -> {-77.5, 38.5, -75.5, 39.8},
  "Properties" -> {"name", "huc6", "areasqkm"},
  "MaxFeatures" -> 20];
Dataset[
  Map[<|"Watershed" -> #["Properties"]["name"],
        "HUC6" -> #["Properties"]["huc6"],
        "Area (km²)" -> #["Properties"]["areasqkm"]|> &,
    features]
]
```

### Compare Protected Area Coverage Across Regions

Count protected areas and total coverage in two different regions to compare conservation effort:

```wolfram
(* East Africa — Serengeti region *)
eastAfrica = GEEComputeFeatures["WCMC/WDPA/current/polygons", "",
  "GeoBounds" -> {33.5, -3.5, 36.0, -1.0},
  "Properties" -> {"NAME", "REP_AREA"},
  "MaxFeatures" -> 100];
(* Western Europe — Alps region *)
alps = GEEComputeFeatures["WCMC/WDPA/current/polygons", "",
  "GeoBounds" -> {6.0, 45.5, 10.5, 47.5},
  "Properties" -> {"NAME", "REP_AREA"},
  "MaxFeatures" -> 100];
TableForm[{
  {Length[eastAfrica],
   Round[Total[#["Properties"]["REP_AREA"] & /@ eastAfrica], 1]},
  {Length[alps],
   Round[Total[#["Properties"]["REP_AREA"] & /@ alps], 1]}
}, TableHeadings -> {{"East Africa", "Alps"},
  {"Count", "Total Area (km²)"}}]
```

### Global Administrative Boundaries

Query first-level administrative divisions (provinces/states) for a region. FAO GAUL provides global coverage:

```wolfram
features = GEEComputeFeatures["FAO/GAUL/2015/level1", "",
  "GeoBounds" -> {28.5, -4.5, 41.0, 4.5},
  "Properties" -> {"ADM0_NAME", "ADM1_NAME"},
  "MaxFeatures" -> 50];
Dataset[
  Map[<|"Country" -> #["Properties"]["ADM0_NAME"],
        "Province" -> #["Properties"]["ADM1_NAME"]|> &,
    features]
]
(* Returns administrative regions in East Africa: Kenya, Uganda, Tanzania, etc. *)
```

### Select Specific Properties

Use `"Properties"` to fetch only the fields you need, reducing response size and making results easier to work with:

```wolfram
(* Only fetch state name and FIPS code *)
features = GEEComputeFeatures["TIGER/2018/States", "",
  "Properties" -> {"NAME", "STATEFP"},
  "MaxFeatures" -> 10];
Map[{#["Properties"]["NAME"], #["Properties"]["STATEFP"]} &,
  features] // TableForm
```

## Possible Issues

- The API returns at most 1001 features per request.
- Large queries without spatial bounds may be slow or hit server-side compute limits.
- The `GEEComputeFeatures::apierr` message surfaces the actual GEE API error when a request fails (e.g., invalid asset name).
- Passing an `IMAGE` or `IMAGE_COLLECTION` asset instead of a `TABLE` asset will fail.

## See Also

`GEEGetAssetInfo`, `GEECompute`, `GEEIdentify`, `GEEFeatureCollection`
