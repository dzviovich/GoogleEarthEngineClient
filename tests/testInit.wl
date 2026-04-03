(* GoogleEarthEngineClient test setup *)

With[{kernelDir = FileNameJoin[{DirectoryName[$TestFileName], "..", "Kernel"}]},
  If[!MemberQ[$Path, kernelDir],
    PrependTo[$Path, kernelDir]
  ]
];
Needs["GoogleEarthEngineClient`"]

$TestKeyFile = Environment["GEE_SERVICE_ACCOUNT_KEY"];

$TestImageAsset = "USGS/SRTMGL1_003";

$TestCollectionAsset = "COPERNICUS/S2_SR_HARMONIZED";

$TestTableAsset = "WCMC/WDPA/current/polygons";

$TestBBox = {-97.8, 30.2, -97.7, 30.3};

$TestPoint = GeoPosition[{30.25, -97.75}];

If[StringQ[$TestKeyFile] && FileExistsQ[$TestKeyFile],
  GEEConnect[$TestKeyFile]
];
