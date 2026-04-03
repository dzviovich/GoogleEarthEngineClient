#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Live integration test of all GoogleEarthEngineClient public functions *)

<<"C:\\Users\\dzvio\\OneDrive\\Documents\\Projects\\Mathematica\\2026-GoogleEarth\\Kernel\\GoogleEarthEngineClient.wl"

$keyFile = "C:\\Users\\dzvio\\OneDrive\\Documents\\Security\\skilful-orb-125723-7b77bca8ca07.json";

passed = 0;
failed = 0;

testResult[name_String, result_, check_] :=
  Module[{ok = check[result]},
    If[ok,
      Print["  PASS: ", name];
      passed++,
      Print["  FAIL: ", name];
      Print["    Result: ", Short[result, 3]];
      failed++
    ]
  ]

(* ========== 1. GEEConnect ========== *)
Print["--- 1. GEEConnect ---"]

conn = GEEConnect[$keyFile];
testResult["returns Association with Status->Connected", conn,
  AssociationQ[#] && #["Status"] === "Connected" &]

testResult["$GEEConnection is set", $GEEConnection,
  AssociationQ[#] && KeyExistsQ[#, "AccessToken"] &]

(* ========== 2. GEEGetAssetInfo ========== *)
Print["--- 2. GEEGetAssetInfo ---"]

info = GEEGetAssetInfo["USGS/SRTMGL1_003"];
testResult["returns Association", info, AssociationQ]

testResult["has Type key", info,
  AssociationQ[#] && KeyExistsQ[#, "Type"] &]

testResult["has Bands key with elevation", info,
  AssociationQ[#] && ListQ[#["Bands"]] &&
    MemberQ[#["Bands"][[All, "Name"]], "elevation"] &]

(* ========== 3. GEEListAssets ========== *)
Print["--- 3. GEEListAssets ---"]

assets = GEEListAssets["USGS", "MaxResults" -> 5];
testResult["returns a list", assets, ListQ]

testResult["list contains Associations", assets,
  ListQ[#] && Length[#] > 0 && AllTrue[#, AssociationQ] &]

(* ========== 4. GEEIdentify ========== *)
Print["--- 4. GEEIdentify ---"]

id1 = GEEIdentify[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003"];
testResult["returns Association with Values", id1,
  AssociationQ[#] && KeyExistsQ[#, "Values"] &]

testResult["elevation value is numeric", id1,
  AssociationQ[#] && Length[#["Values"]] > 0 &&
    NumericQ[First[#["Values"]]] &]

testResult["Bands contains elevation", id1,
  AssociationQ[#] && MemberQ[#["Bands"], "elevation"] &]

(* test with Bands option *)
id2 = GEEIdentify[GeoPosition[{30.25, -97.75}], "USGS/SRTMGL1_003",
  "Bands" -> {"elevation"}];
testResult["Bands option works", id2,
  AssociationQ[#] && Length[#["Values"]] === 1 &]

(* ========== 5. GEEGetSamples ========== *)
Print["--- 5. GEEGetSamples ---"]

samples = GEEGetSamples[
  {GeoPosition[{30.25, -97.75}], GeoPosition[{40.71, -74.01}]},
  "USGS/SRTMGL1_003"];
testResult["returns list of 2 results", samples,
  ListQ[#] && Length[#] === 2 &]

testResult["each result has Position and Values", samples,
  ListQ[#] && AllTrue[#,
    AssociationQ[#1] && KeyExistsQ[#1, "Position"] &&
      KeyExistsQ[#1, "Values"] &] &]

(* ========== 6. GEEComputePixels ========== *)
Print["--- 6. GEEComputePixels ---"]

pixels = GEEComputePixels["USGS/SRTMGL1_003",
  {-97.8, 30.2, -97.7, 30.3},
  "ImageSize" -> {256, 256}, "FileFormat" -> "PNG"];
testResult["returns an Image", pixels, ImageQ]

testResult["image has expected dimensions", pixels,
  ImageQ[#] && ImageDimensions[#] === {256, 256} &]

(* ========== 7. GEEImage ========== *)
Print["--- 7. GEEImage ---"]

gimg = GEEImage[
  Entity["City", {"Austin", "Texas", "UnitedStates"}],
  "USGS/SRTMGL1_003",
  RasterSize -> {256, 256}];
testResult["returns an Image", gimg, ImageQ]

testResult["image has MetaInformation", gimg,
  ImageQ[#] && AssociationQ[Options[#, MetaInformation][[1, 2]]] &]

(* ========== 8. GEEGetTile ========== *)
Print["--- 8. GEEGetTile ---"]

tile = GEEGetTile["USGS/SRTMGL1_003", 10, 237, 409,
  "VisParams" -> <|"min" -> 0, "max" -> 4000|>];
testResult["returns an Image", tile, ImageQ]

(* tile with GeoPosition *)
tile2 = GEEGetTile["USGS/SRTMGL1_003", GeoPosition[{30.25, -97.75}], 10,
  "VisParams" -> <|"min" -> 0, "max" -> 4000|>];
testResult["GeoPosition overload returns Image", tile2, ImageQ]

(* ========== 9. GEEComputeFeatures ========== *)
Print["--- 9. GEEComputeFeatures ---"]

features = GEEComputeFeatures["TIGER/2018/States", "",
  "MaxFeatures" -> 5];
testResult["returns a list", features, ListQ]

testResult["features have Properties", features,
  ListQ[#] && Length[#] > 0 &&
    AllTrue[#, AssociationQ[#1] && KeyExistsQ[#1, "Properties"] &] &]

(* ========== 10. GEECompute ========== *)
Print["--- 10. GEECompute ---"]

(* Use the new expression format *)
computeExpr = <|"functionInvocationValue" -> <|
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

comp = GEECompute[computeExpr];
testResult["returns a result", comp,
  AssociationQ[#] || NumericQ[#] &]

(* ========== 11. GEEGeoGraphics ========== *)
Print["--- 11. GEEGeoGraphics ---"]

gg = GEEGeoGraphics[
  {GeoMarker[GeoPosition[{30.25, -97.75}]]},
  "USGS/SRTMGL1_003",
  RasterSize -> {256, 256},
  "VisParams" -> <|"min" -> 0, "max" -> 500|>];
testResult["returns Graphics", gg,
  MatchQ[#, _Graphics | _Image] &]

(* ========== Summary ========== *)
Print[""]
Print["==========================="]
Print["  Passed: ", passed]
Print["  Failed: ", failed]
Print["  Total:  ", passed + failed]
Print["==========================="]
