(* GoogleEarthEngineClient test suite *)

BeginTestSection["GoogleEarthEngineClient"]

Get[FileNameJoin[{DirectoryName[$TestFileName], "testInit.wl"}]];

$Authenticated = AssociationQ[$GEEConnection];

(* ================================================================ *)
(* === GEEConnect tests                                          === *)
(* ================================================================ *)

BeginTestSection["GEEConnect"]

VerificationTest[
  GEEConnect["nonexistent_file.json"],
  $Failed,
  {GEEConnect::keynotfound, GEEConnect::keynotfound},
  TestID -> "GEEConnect-missing-file"
]

VerificationTest[
  GEEConnect[123],
  $Failed,
  {GEEConnect::authfail},
  TestID -> "GEEConnect-bad-arg"
]

If[$Authenticated,
  VerificationTest[
    AssociationQ[$GEEConnection],
    True,
    TestID -> "GEEConnect-connection-is-association"
  ];

  VerificationTest[
    KeyExistsQ[$GEEConnection, "AccessToken"],
    True,
    TestID -> "GEEConnect-has-access-token"
  ];

  VerificationTest[
    KeyExistsQ[$GEEConnection, "Project"],
    True,
    TestID -> "GEEConnect-has-project"
  ];

  VerificationTest[
    StringQ[$GEEConnection["AccessToken"]],
    True,
    TestID -> "GEEConnect-token-is-string"
  ];
]

EndTestSection[]

(* ================================================================ *)
(* === GEEGetAssetInfo tests                                     === *)
(* ================================================================ *)

BeginTestSection["GEEGetAssetInfo"]

If[$Authenticated,
  VerificationTest[
    AssociationQ[GEEGetAssetInfo[$TestImageAsset]],
    True,
    TestID -> "GEEGetAssetInfo-returns-association"
  ];

  VerificationTest[
    Module[{info = GEEGetAssetInfo[$TestImageAsset]},
      KeyExistsQ[info, "Type"] && KeyExistsQ[info, "Bands"]
    ],
    True,
    TestID -> "GEEGetAssetInfo-has-expected-keys"
  ];

  VerificationTest[
    Module[{info = GEEGetAssetInfo[$TestImageAsset]},
      info["Type"]
    ],
    "IMAGE",
    TestID -> "GEEGetAssetInfo-srtm-type"
  ];

  VerificationTest[
    Module[{info = GEEGetAssetInfo[$TestImageAsset]},
      Length[info["Bands"]] > 0
    ],
    True,
    TestID -> "GEEGetAssetInfo-has-bands"
  ];
]

VerificationTest[
  GEEGetAssetInfo[123],
  $Failed,
  {GEEGetAssetInfo::fetchfail},
  TestID -> "GEEGetAssetInfo-bad-arg"
]

EndTestSection[]

(* ================================================================ *)
(* === GEEListAssets tests                                       === *)
(* ================================================================ *)

BeginTestSection["GEEListAssets"]

If[$Authenticated,
  VerificationTest[
    ListQ[GEEListAssets["USGS"]],
    True,
    TestID -> "GEEListAssets-returns-list"
  ];

  VerificationTest[
    Module[{assets = GEEListAssets["USGS", "MaxResults" -> 5]},
      Length[assets] <= 5
    ],
    True,
    TestID -> "GEEListAssets-respects-max-results"
  ];
]

VerificationTest[
  GEEListAssets[123],
  $Failed,
  {GEEListAssets::fetchfail},
  TestID -> "GEEListAssets-bad-arg"
]

EndTestSection[]

(* ================================================================ *)
(* === GEEComputePixels tests                                    === *)
(* ================================================================ *)

BeginTestSection["GEEComputePixels"]

If[$Authenticated,
  VerificationTest[
    ImageQ[GEEComputePixels[$TestImageAsset, $TestBBox]],
    True,
    TestID -> "GEEComputePixels-returns-image"
  ];

  VerificationTest[
    ImageDimensions[
      GEEComputePixels[$TestImageAsset, $TestBBox,
        "ImageSize" -> {256, 256}]
    ],
    {256, 256},
    TestID -> "GEEComputePixels-respects-image-size"
  ];

  VerificationTest[
    ImageDimensions[
      GEEComputePixels[$TestImageAsset, $TestBBox]
    ],
    {512, 512},
    TestID -> "GEEComputePixels-default-512"
  ];
]

VerificationTest[
  GEEComputePixels[$TestImageAsset, {1, 2, 3}],
  $Failed,
  {GEEComputePixels::badbbox},
  TestID -> "GEEComputePixels-bad-bbox"
]

VerificationTest[
  GEEComputePixels[],
  $Failed,
  {GEEComputePixels::fetchfail},
  TestID -> "GEEComputePixels-no-args"
]

EndTestSection[]

(* ================================================================ *)
(* === GEEImage tests                                            === *)
(* ================================================================ *)

BeginTestSection["GEEImage"]

If[$Authenticated,
  VerificationTest[
    ImageQ[GEEImage[$TestPoint, $TestImageAsset]],
    True,
    TestID -> "GEEImage-returns-image"
  ];

  VerificationTest[
    ImageDimensions[
      GEEImage[$TestPoint, $TestImageAsset, RasterSize -> {256, 256}]
    ],
    {256, 256},
    TestID -> "GEEImage-custom-raster-size"
  ];

  VerificationTest[
    Module[{img = GEEImage[$TestPoint, $TestImageAsset]},
      KeyExistsQ[
        MetaInformation[img],
        "GeoMetaInformation"
      ]
    ],
    True,
    TestID -> "GEEImage-has-geo-metadata"
  ];

  VerificationTest[
    Module[{img = GEEImage[$TestPoint, $TestImageAsset],
        meta},
      meta = MetaInformation[img]["GeoMetaInformation"];
      KeyExistsQ[meta, "LonLatBox"]
    ],
    True,
    TestID -> "GEEImage-has-lonlatbox"
  ];

  VerificationTest[
    Module[{img = GEEImage[$TestPoint, $TestImageAsset],
        meta},
      meta = MetaInformation[img]["GeoMetaInformation"];
      meta["GEEAsset"]
    ],
    $TestImageAsset,
    TestID -> "GEEImage-metadata-asset"
  ];

  VerificationTest[
    Module[{img = GEEImage[$TestPoint, $TestImageAsset,
        GeoProjection -> "Equirectangular"], meta},
      meta = MetaInformation[img]["GeoMetaInformation"];
      meta["GeoProjection"]
    ],
    "Equirectangular",
    TestID -> "GEEImage-geo-projection"
  ];

  VerificationTest[
    Module[{img = GEEImage[$TestPoint, $TestImageAsset,
        ColorSpace -> "Grayscale"]},
      ImageColorSpace[img]
    ],
    "Grayscale",
    TestID -> "GEEImage-color-space"
  ];

  VerificationTest[
    Module[{img = GEEImage[$TestPoint, $TestImageAsset,
        GeoRange -> 5000]},
      ImageQ[img]
    ],
    True,
    TestID -> "GEEImage-geo-range-numeric"
  ];

  VerificationTest[
    Module[{img = GEEImage[$TestPoint, $TestImageAsset,
        GeoRange -> Quantity[5, "Kilometers"]]},
      ImageQ[img]
    ],
    True,
    TestID -> "GEEImage-geo-range-quantity"
  ];

  VerificationTest[
    Module[{img = GEEImage[$TestPoint, $TestImageAsset,
        GeoCenter -> GeoPosition[{30.3, -97.7}]]},
      ImageQ[img]
    ],
    True,
    TestID -> "GEEImage-geo-center"
  ];
]

VerificationTest[
  GEEImage[],
  $Failed,
  {GEEImage::imgfail},
  TestID -> "GEEImage-no-args"
]

EndTestSection[]

(* ================================================================ *)
(* === GEEGetTile tests                                          === *)
(* ================================================================ *)

BeginTestSection["GEEGetTile"]

If[$Authenticated,
  VerificationTest[
    ImageQ[GEEGetTile[$TestImageAsset, 5, 7, 14]],
    True,
    TestID -> "GEEGetTile-returns-image"
  ];

  VerificationTest[
    ImageQ[GEEGetTile[$TestImageAsset, $TestPoint, 8]],
    True,
    TestID -> "GEEGetTile-point-overload"
  ];
]

VerificationTest[
  GEEGetTile[],
  $Failed,
  {GEEGetTile::fetchfail},
  TestID -> "GEEGetTile-no-args"
]

EndTestSection[]

(* ================================================================ *)
(* === GEEIdentify tests                                         === *)
(* ================================================================ *)

BeginTestSection["GEEIdentify"]

If[$Authenticated,
  VerificationTest[
    AssociationQ[GEEIdentify[$TestPoint, $TestImageAsset]],
    True,
    TestID -> "GEEIdentify-returns-association"
  ];

  VerificationTest[
    Module[{result = GEEIdentify[$TestPoint, $TestImageAsset]},
      KeyExistsQ[result, "Values"] && KeyExistsQ[result, "Bands"]
    ],
    True,
    TestID -> "GEEIdentify-has-expected-keys"
  ];

  VerificationTest[
    Module[{result = GEEIdentify[$TestPoint, $TestImageAsset]},
      ListQ[result["Values"]] && Length[result["Values"]] > 0
    ],
    True,
    TestID -> "GEEIdentify-has-values"
  ];

  VerificationTest[
    Module[{result = GEEIdentify[$TestPoint, $TestImageAsset]},
      AllTrue[result["Values"], NumericQ]
    ],
    True,
    TestID -> "GEEIdentify-values-are-numeric"
  ];

  VerificationTest[
    Module[{result = GEEIdentify[$TestPoint, $TestImageAsset]},
      result["Position"]
    ],
    $TestPoint,
    TestID -> "GEEIdentify-preserves-position"
  ];
]

VerificationTest[
  GEEIdentify["not a point", $TestImageAsset],
  $Failed,
  {GEEIdentify::badpoint},
  TestID -> "GEEIdentify-bad-point"
]

VerificationTest[
  GEEIdentify[],
  $Failed,
  {GEEIdentify::fetchfail},
  TestID -> "GEEIdentify-no-args"
]

EndTestSection[]

(* ================================================================ *)
(* === GEEGetSamples tests                                       === *)
(* ================================================================ *)

BeginTestSection["GEEGetSamples"]

If[$Authenticated,
  VerificationTest[
    Module[{results = GEEGetSamples[
        {$TestPoint, GeoPosition[{30.3, -97.7}]},
        $TestImageAsset]},
      Length[results]
    ],
    2,
    TestID -> "GEEGetSamples-correct-count"
  ];

  VerificationTest[
    Module[{results = GEEGetSamples[{$TestPoint}, $TestImageAsset]},
      KeyExistsQ[results[[1]], "Position"] &&
        KeyExistsQ[results[[1]], "Values"]
    ],
    True,
    TestID -> "GEEGetSamples-has-expected-keys"
  ];

  VerificationTest[
    Module[{results = GEEGetSamples[{$TestPoint}, $TestImageAsset]},
      AllTrue[results[[1]]["Values"], NumericQ]
    ],
    True,
    TestID -> "GEEGetSamples-values-numeric"
  ];
]

VerificationTest[
  GEEGetSamples[],
  $Failed,
  {GEEGetSamples::fetchfail},
  TestID -> "GEEGetSamples-no-args"
]

EndTestSection[]

(* ================================================================ *)
(* === GEEComputeFeatures tests                                  === *)
(* ================================================================ *)

BeginTestSection["GEEComputeFeatures"]

If[$Authenticated,
  VerificationTest[
    ListQ[GEEComputeFeatures[$TestTableAsset, ""]],
    True,
    TestID -> "GEEComputeFeatures-returns-list"
  ];

  VerificationTest[
    Module[{features = GEEComputeFeatures[$TestTableAsset, "",
        "MaxFeatures" -> 5]},
      Length[features] <= 5
    ],
    True,
    TestID -> "GEEComputeFeatures-max-features"
  ];

  VerificationTest[
    Module[{features = GEEComputeFeatures[$TestTableAsset, "",
        "GeoBounds" -> $TestBBox, "MaxFeatures" -> 10]},
      AllTrue[features, AssociationQ]
    ],
    True,
    TestID -> "GEEComputeFeatures-geobounds-filter"
  ];

  VerificationTest[
    Module[{features = GEEComputeFeatures[$TestTableAsset, "",
        "MaxFeatures" -> 1]},
      If[Length[features] > 0,
        KeyExistsQ[features[[1]], "Properties"],
        True
      ]
    ],
    True,
    TestID -> "GEEComputeFeatures-has-properties"
  ];
]

VerificationTest[
  GEEComputeFeatures[123],
  $Failed,
  {GEEComputeFeatures::fetchfail},
  TestID -> "GEEComputeFeatures-bad-arg"
]

EndTestSection[]

(* ================================================================ *)
(* === GEECompute tests                                          === *)
(* ================================================================ *)

BeginTestSection["GEECompute"]

If[$Authenticated,
  VerificationTest[
    Module[{result = GEECompute[
        <|"type" -> "Invocation",
          "functionName" -> "Number.add",
          "arguments" -> <|
            "left" -> <|"constantValue" -> 2|>,
            "right" -> <|"constantValue" -> 3|>
          |>|>
      ]},
      result
    ],
    5,
    TestID -> "GEECompute-simple-addition"
  ];
]

VerificationTest[
  GEECompute[],
  $Failed,
  {GEECompute::fetchfail},
  TestID -> "GEECompute-no-args"
]

EndTestSection[]

(* ================================================================ *)
(* === GEEGeoGraphics tests                                      === *)
(* ================================================================ *)

BeginTestSection["GEEGeoGraphics"]

If[$Authenticated,
  VerificationTest[
    Head[GEEGeoGraphics[
      GeoMarker[$TestPoint], $TestImageAsset]],
    Graphics,
    TestID -> "GEEGeoGraphics-returns-graphics"
  ];

  VerificationTest[
    Head[GEEGeoGraphics[
      {GeoMarker[$TestPoint],
       GeoPath[{$TestPoint, GeoPosition[{30.3, -97.7}]}]},
      $TestImageAsset]],
    Graphics,
    TestID -> "GEEGeoGraphics-multiple-primitives"
  ];
]

VerificationTest[
  GEEGeoGraphics[{}, $TestImageAsset],
  $Failed,
  {GEEGeoGraphics::noauth},
  TestID -> "GEEGeoGraphics-empty-prims"
]

VerificationTest[
  GEEGeoGraphics[],
  $Failed,
  {GEEGeoGraphics::bgfail},
  TestID -> "GEEGeoGraphics-no-args"
]

EndTestSection[]

(* ================================================================ *)
(* === Error handling tests                                      === *)
(* ================================================================ *)

BeginTestSection["Error Handling"]

VerificationTest[
  GEEGetAssetInfo[],
  $Failed,
  {GEEGetAssetInfo::fetchfail},
  TestID -> "Error-GetAssetInfo-no-args"
]

VerificationTest[
  GEEComputePixels["test", "not-a-bbox"],
  $Failed,
  {GEEComputePixels::badbbox},
  TestID -> "Error-ComputePixels-bad-bbox"
]

VerificationTest[
  GEEIdentify["not-a-point", "asset"],
  $Failed,
  {GEEIdentify::badpoint},
  TestID -> "Error-Identify-bad-point"
]

VerificationTest[
  GEEGetSamples[],
  $Failed,
  {GEEGetSamples::fetchfail},
  TestID -> "Error-GetSamples-no-args"
]

VerificationTest[
  GEEComputeFeatures[],
  $Failed,
  {GEEComputeFeatures::fetchfail},
  TestID -> "Error-ComputeFeatures-no-args"
]

VerificationTest[
  GEECompute[],
  $Failed,
  {GEECompute::fetchfail},
  TestID -> "Error-Compute-no-args"
]

EndTestSection[]

EndTestSection[]
