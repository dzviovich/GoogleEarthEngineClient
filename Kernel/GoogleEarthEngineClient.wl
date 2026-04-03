(* ::Package:: *)

BeginPackage["GoogleEarthEngineClient`"]

(* --- Public symbol declarations --- *)

GEEConnect::usage = "GEEConnect[keyFile] authenticate with Google Earth Engine \
using a service account JSON key file. Return a connection Association and \
store it in $GEEConnection.\n\
GEEConnect[keyFile, opts] connect with option \"Project\"."

GEEGetAssetInfo::usage = "GEEGetAssetInfo[assetId] fetch metadata for a \
Google Earth Engine asset and return an Association with keys \"Type\", \
\"Name\", \"Title\", \"Description\", \"StartTime\", \"EndTime\", \
\"Geometry\", \"Bands\", and \"Properties\".\n\
GEEGetAssetInfo[assetId, opts] fetch with option \"Project\"."

GEEListAssets::usage = "GEEListAssets[parent] list assets in a Google Earth \
Engine folder or collection and return a list of Associations.\n\
GEEListAssets[parent, opts] list with options \"MaxResults\" and \"Filter\"."

GEEComputePixels::usage = "GEEComputePixels[assetId, bbox] compute pixels \
for a GEE image asset over the bounding box {west, south, east, north}. \
Return an Image.\n\
GEEComputePixels[assetId, bbox, opts] compute with options \"ImageSize\", \
\"FileFormat\", \"Bands\", and \"CRS\"."

GEEImage::usage = "GEEImage[region, assetId] return a geo-tagged Image of \
region from the Google Earth Engine asset.\n\
GEEImage[region, assetId, opts] return an image with options \
RasterSize, GeoRange, GeoCenter, GeoResolution, GeoZoomLevel, \
GeoProjection, GeoRangePadding, \"FileFormat\", \"Bands\", ImageSize, \
and ColorSpace."

GEEGetTile::usage = "GEEGetTile[assetId, z, x, y] fetch a map tile at \
zoom level z, tile coordinates x, y for a GEE asset. Return an Image.\n\
GEEGetTile[assetId, point, z] fetch the tile containing the GeoPosition \
point at the given zoom level.\n\
GEEGetTile[assetId, z, x, y, opts] fetch with options \"Bands\" and \
\"VisParams\"."

GEEIdentify::usage = "GEEIdentify[point, assetId] identify pixel values \
at a GeoPosition from a Google Earth Engine image asset. Return an \
Association with keys \"Position\", \"Values\", and \"Bands\".\n\
GEEIdentify[point, assetId, opts] identify with option \"Bands\"."

GEEGetSamples::usage = "GEEGetSamples[points, assetId] extract pixel \
values at a list of GeoPosition points from a GEE image asset. Return \
a list of Associations with keys \"Position\" and \"Values\".\n\
GEEGetSamples[points, assetId, opts] extract with option \"Bands\"."

GEEComputeFeatures::usage = "GEEComputeFeatures[assetId, filter] query \
features from a Google Earth Engine table asset matching the filter. \
Return a list of feature Associations.\n\
GEEComputeFeatures[assetId, filter, opts] query with options \
\"Properties\", \"MaxFeatures\", and \"GeoBounds\"."

GEECompute::usage = "GEECompute[expression] compute an arbitrary value \
from a Google Earth Engine expression and return the result.\n\
GEECompute[expression, opts] compute with option \"Project\"."

GEEGeoGraphics::usage = "GEEGeoGraphics[primitives, assetId] render \
geographic primitives on a background map from a GEE asset. Return a \
Graphics object.\n\
GEEGeoGraphics[primitives, assetId, opts] render with options \
GeoProjection, GeoRange, GeoCenter, GeoRangePadding, RasterSize, \
GeoResolution, GeoZoomLevel, \"FileFormat\", \"Bands\", ImageSize, \
GeoBackground, ColorSpace, and \"VisParams\"."

$GEEConnection::usage = "$GEEConnection holds the current authentication \
state as an Association with keys \"Project\", \"AccessToken\", \"Expiry\", \
and \"KeyFile\". Set by GEEConnect."

(* --- Error message templates --- *)

GEEConnect::keynotfound = "Key file `1` not found.";
GEEConnect::invalidkey = "Key file `1` is not a valid service account JSON key.";
GEEConnect::authfail = "Failed to obtain access token: `1`.";

GEEGetAssetInfo::fetchfail = "Failed to fetch asset info for `1`.";
GEEGetAssetInfo::parsefail = "Response for `1` is not valid JSON.";
GEEGetAssetInfo::noauth = "Not authenticated. Call GEEConnect first.";

GEEListAssets::fetchfail = "Failed to list assets from `1`.";
GEEListAssets::noauth = "Not authenticated. Call GEEConnect first.";

GEEComputePixels::fetchfail = "Failed to compute pixels from `1`.";
GEEComputePixels::apierr = "GEE API error for `1`: `2`";
GEEComputePixels::notimage = "Server returned `1` instead of an image.";
GEEComputePixels::badbbox = "Expected bbox as {west, south, east, north}, got `1`.";
GEEComputePixels::noauth = "Not authenticated. Call GEEConnect first.";

GEEImage::bboxfail = "Could not compute GeoBoundingBox from the provided region.";
GEEImage::infofail = "Failed to retrieve asset info for `1`.";
GEEImage::imgfail = "Failed to fetch image from `1`.";
GEEImage::noauth = "Not authenticated. Call GEEConnect first.";

GEEGetTile::fetchfail = "Failed to fetch tile from `1`.";
GEEGetTile::notimage = "Server returned `1` instead of a tile image.";
GEEGetTile::mapfail = "Failed to create map ID for `1`.";
GEEGetTile::noauth = "Not authenticated. Call GEEConnect first.";

GEEIdentify::fetchfail = "Failed to identify at `1`.";
GEEIdentify::parsefail = "Response from identify is not valid JSON.";
GEEIdentify::apierr = "`1`";
GEEIdentify::badpoint = "Expected a GeoPosition, got `1`.";
GEEIdentify::noauth = "Not authenticated. Call GEEConnect first.";

GEEGetSamples::fetchfail = "Failed to get samples from `1`.";
GEEGetSamples::noauth = "Not authenticated. Call GEEConnect first.";

GEEComputeFeatures::fetchfail = "Failed to query features from `1`.";
GEEComputeFeatures::parsefail = "Query response is not valid JSON.";
GEEComputeFeatures::apierr = "`1`";
GEEComputeFeatures::noauth = "Not authenticated. Call GEEConnect first.";

GEECompute::fetchfail = "Failed to compute value.";
GEECompute::parsefail = "Compute response is not valid JSON.";
GEECompute::apierr = "`1`";
GEECompute::noauth = "Not authenticated. Call GEEConnect first.";

GEEGeoGraphics::bboxfail = "Could not compute bounding box from the provided primitives.";
GEEGeoGraphics::bgfail = "Failed to fetch background map from `1`.";
GEEGeoGraphics::noprims = "No geo primitives found in the input.";
GEEGeoGraphics::noauth = "Not authenticated. Call GEEConnect first.";

(* --- Options --- *)

Options[GEEConnect] = {
  "Project" -> Automatic
};

Options[GEEGetAssetInfo] = {
  "Project" -> Automatic
};

Options[GEEListAssets] = {
  "MaxResults" -> 100,
  "Filter" -> None,
  "Project" -> Automatic
};

Options[GEEComputePixels] = {
  "ImageSize" -> {512, 512},
  "FileFormat" -> "PNG",
  "Bands" -> Automatic,
  "CRS" -> "EPSG:4326",
  "VisParams" -> <||>,
  "Project" -> Automatic
};

Options[GEEImage] = {
  RasterSize -> Automatic,
  "FileFormat" -> "PNG",
  GeoRangePadding -> None,
  GeoRange -> Automatic,
  GeoCenter -> Automatic,
  GeoResolution -> Automatic,
  GeoZoomLevel -> Automatic,
  GeoProjection -> "Mercator",
  "Bands" -> Automatic,
  "VisParams" -> <||>,
  ImageSize -> Automatic,
  ColorSpace -> Automatic,
  "Project" -> Automatic
};

Options[GEEGetTile] = {
  "Bands" -> Automatic,
  "VisParams" -> <||>,
  "Project" -> Automatic
};

Options[GEEIdentify] = {
  "Bands" -> Automatic,
  "Project" -> Automatic
};

Options[GEEGetSamples] = {
  "Bands" -> Automatic,
  "Project" -> Automatic
};

Options[GEEComputeFeatures] = {
  "Properties" -> All,
  "MaxFeatures" -> 1000,
  "GeoBounds" -> None,
  "Project" -> Automatic
};

Options[GEECompute] = {
  "Project" -> Automatic
};

Options[GEEGeoGraphics] = {
  GeoProjection -> "Mercator",
  GeoRange -> Automatic,
  GeoCenter -> Automatic,
  GeoRangePadding -> Scaled[0.1],
  RasterSize -> {512, 512},
  GeoResolution -> Automatic,
  GeoZoomLevel -> Automatic,
  "FileFormat" -> "PNG",
  "Bands" -> Automatic,
  "VisParams" -> <||>,
  ImageSize -> Automatic,
  GeoBackground -> Automatic,
  ColorSpace -> Automatic,
  "Project" -> Automatic
};

(* --- Begin private context --- *)

Begin["`Private`"]

(* --- Package-level constants --- *)

$GEEBaseURL = "https://earthengine.googleapis.com/v1/";
$GEETokenURL = "https://oauth2.googleapis.com/token";
$GEEScope = "https://www.googleapis.com/auth/earthengine";
$GEETokenLifetime = 3600;

(* --- Base64url encoding --- *)

base64URLEncode[bytes_ByteArray] :=
  StringReplace[
    BaseEncode[bytes, "Base64"],
    {"+" -> "-", "/" -> "_", "=" -> ""}
  ]

base64URLEncode[str_String] :=
  base64URLEncode[StringToByteArray[str, "UTF-8"]]

(* --- JWT construction --- *)

buildJWT[email_String, privateKeyPEM_String, scope_String] :=
  Module[{header, now, claims, headerB64, claimsB64, sigInput,
      privateKey, signature, sigB64},
    header = ExportString[
      <|"alg" -> "RS256", "typ" -> "JWT"|>, "JSON",
      "Compact" -> True];
    now = UnixTime[];
    claims = ExportString[
      <|"iss" -> email,
        "scope" -> scope,
        "aud" -> $GEETokenURL,
        "iat" -> now,
        "exp" -> now + $GEETokenLifetime|>,
      "JSON", "Compact" -> True];

    headerB64 = base64URLEncode[header];
    claimsB64 = base64URLEncode[claims];
    sigInput = headerB64 <> "." <> claimsB64;

    privateKey = First[ImportString[privateKeyPEM, {"PEM", "PrivateKey"}]];
    signature = GenerateDigitalSignature[
      StringToByteArray[sigInput, "UTF-8"],
      privateKey,
      Method -> <|"Type" -> "RSA", "HashingMethod" -> "SHA256"|>
    ];

    sigB64 = base64URLEncode[signature["Signature"]];
    sigInput <> "." <> sigB64
  ]

(* --- Token refresh --- *)

refreshToken[keyData_Association] :=
  Module[{email, privateKey, jwt, body, response, json},
    email = keyData["client_email"];
    privateKey = keyData["private_key"];
    jwt = buildJWT[email, privateKey, $GEEScope];

    body = "grant_type=" <> URLEncode["urn:ietf:params:oauth:grant-type:jwt-bearer"] <>
      "&assertion=" <> URLEncode[jwt];

    response = Import[
      HTTPRequest[$GEETokenURL,
        <|Method -> "POST",
          "ContentType" -> "application/x-www-form-urlencoded",
          "Body" -> body|>],
      "RawJSON"
    ];

    If[AssociationQ[response] && KeyExistsQ[response, "access_token"],
      <|"AccessToken" -> response["access_token"],
        "Expiry" -> UnixTime[] + Lookup[response, "expires_in", $GEETokenLifetime]|>,
      $Failed
    ]
  ]

(* --- Authentication check --- *)

ensureAuthenticated[] :=
  Module[{tokenInfo},
    If[!AssociationQ[$GEEConnection],
      Return[$Failed, Module]
    ];
    If[UnixTime[] >= $GEEConnection["Expiry"] - 60,
      tokenInfo = refreshToken[$GEEConnection["KeyData"]];
      If[AssociationQ[tokenInfo],
        $GEEConnection = Join[$GEEConnection, tokenInfo],
        Return[$Failed, Module]
      ]
    ];
    $GEEConnection
  ]

(* --- Project resolution --- *)

resolveProject[Automatic] :=
  If[AssociationQ[$GEEConnection],
    $GEEConnection["Project"],
    "earthengine-legacy"
  ]

resolveProject[proj_String] := proj

(* --- URL construction --- *)

buildURL[path_String] :=
  $GEEBaseURL <> path

buildURL[path_String, project_] :=
  $GEEBaseURL <> "projects/" <> resolveProject[project] <> "/" <> path

(* --- Authenticated HTTP helpers --- *)

geeGET[path_String, project_ : Automatic] :=
  Module[{url, token},
    url = buildURL[path, project];
    token = $GEEConnection["AccessToken"];
    Import[
      HTTPRequest[url,
        <|"Headers" -> {"Authorization" -> "Bearer " <> token}|>],
      "RawJSON"
    ]
  ]

geePOST[path_String, body_Association, project_ : Automatic] :=
  Module[{url, token, bodyJSON},
    url = buildURL[path, project];
    token = $GEEConnection["AccessToken"];
    bodyJSON = ExportString[body, "JSON", "Compact" -> True];
    Import[
      HTTPRequest[url,
        <|Method -> "POST",
          "Headers" -> {
            "Authorization" -> "Bearer " <> token,
            "Content-Type" -> "application/json"
          },
          "Body" -> bodyJSON|>],
      "RawJSON"
    ]
  ]

geePOSTRaw[path_String, body_Association, project_ : Automatic] :=
  Module[{url, token, bodyJSON, resp, statusCode, bodyBytes},
    url = buildURL[path, project];
    token = $GEEConnection["AccessToken"];
    bodyJSON = ExportString[body, "JSON", "Compact" -> True];
    resp = URLRead[
      HTTPRequest[url,
        <|Method -> "POST",
          "Headers" -> {
            "Authorization" -> "Bearer " <> token,
            "Content-Type" -> "application/json"
          },
          "Body" -> bodyJSON|>]
    ];
    statusCode = resp["StatusCode"];
    bodyBytes = resp["BodyByteArray"];
    If[statusCode =!= 200,
      Module[{errorMsg},
        errorMsg = Quiet[
          With[{json = ImportByteArray[bodyBytes, "RawJSON"]},
            If[AssociationQ[json] && KeyExistsQ[json, "error"],
              json["error"]["message"],
              ByteArrayToString[bodyBytes]
            ]
          ]
        ];
        If[!StringQ[errorMsg], errorMsg = "HTTP " <> ToString[statusCode]];
        Failure["GEEAPIError",
          <|"MessageTemplate" -> errorMsg, "StatusCode" -> statusCode|>
        ]
      ],
      bodyBytes
    ]
  ]

(* --- GEE expression tree builders --- *)

wrapExpression[expr_Association] :=
  <|"result" -> "0", "values" -> <|"0" -> expr|>|>

buildImageExpression[assetId_String] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.load",
    "arguments" -> <|"id" -> <|"constantValue" -> assetId|>|>
  |>|>

buildCollectionExpression[assetId_String] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.load",
    "arguments" -> <|"id" -> <|"constantValue" -> assetId|>|>
  |>|>

buildFeatureCollectionExpression[assetId_String] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Collection.loadTable",
    "arguments" -> <|"tableId" -> <|"constantValue" -> assetId|>|>
  |>|>

buildBandSelection[imageExpr_Association, bands_List] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.select",
    "arguments" -> <|
      "input" -> imageExpr,
      "bandSelectors" -> <|
        "constantValue" -> bands
      |>
    |>
  |>|>

buildVisualization[imageExpr_Association, visParams_Association] :=
  Module[{args},
    args = <|"image" -> imageExpr|>;
    If[KeyExistsQ[visParams, "min"],
      args = Append[args, "min" -> <|"constantValue" -> {visParams["min"]}|>]
    ];
    If[KeyExistsQ[visParams, "max"],
      args = Append[args, "max" -> <|"constantValue" -> {visParams["max"]}|>]
    ];
    If[KeyExistsQ[visParams, "palette"],
      args = Append[args,
        "palette" -> <|"constantValue" -> visParams["palette"]|>]
    ];
    If[KeyExistsQ[visParams, "bands"],
      args = Append[args,
        "bands" -> <|"constantValue" -> visParams["bands"]|>]
    ];
    If[KeyExistsQ[visParams, "gamma"],
      args = Append[args,
        "gamma" -> <|"constantValue" -> {visParams["gamma"]}|>]
    ];
    <|"functionInvocationValue" -> <|
      "functionName" -> "Image.visualize",
      "arguments" -> args
    |>|>
  ]

buildGeometryPoint[lat_?NumericQ, lon_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "GeometryConstructors.Point",
    "arguments" -> <|
      "coordinates" -> <|"constantValue" -> {N[lon], N[lat]}|>
    |>
  |>|>

buildGeometryRectangle[west_?NumericQ, south_?NumericQ,
    east_?NumericQ, north_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "GeometryConstructors.Rectangle",
    "arguments" -> <|
      "coordinates" -> <|
        "constantValue" -> {N[west], N[south], N[east], N[north]}
      |>
    |>
  |>|>

buildGridSpec[{west_, south_, east_, north_}, {width_, height_}, crs_String] :=
  <|"dimensions" -> <|"width" -> width, "height" -> height|>,
    "affineTransform" -> <|
      "scaleX" -> N[(east - west) / width],
      "shearX" -> 0,
      "translateX" -> N[west],
      "shearY" -> 0,
      "scaleY" -> N[(south - north) / height],
      "translateY" -> N[north]
    |>,
    "crsCode" -> "EPSG:4326"|>

buildReduceRegion[imageExpr_Association, geometry_Association, scale_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.reduceRegion",
    "arguments" -> <|
      "image" -> imageExpr,
      "reducer" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Reducer.first",
        "arguments" -> <||>
      |>|>,
      "geometry" -> geometry,
      "scale" -> <|"constantValue" -> scale|>,
      "bestEffort" -> <|"constantValue" -> True|>
    |>
  |>|>

buildSortAndFirst[collectionExpr_Association, property_String, ascending_?BooleanQ] :=
  Module[{limited},
    limited = <|"functionInvocationValue" -> <|
      "functionName" -> "Collection.limit",
      "arguments" -> <|
        "collection" -> collectionExpr,
        "limit" -> <|"constantValue" -> 1|>,
        "key" -> <|"constantValue" -> property|>,
        "ascending" -> <|"constantValue" -> ascending|>
      |>
    |>|>;
    <|"functionInvocationValue" -> <|
      "functionName" -> "Collection.first",
      "arguments" -> <|"collection" -> limited|>
    |>|>
  ]

buildFilterBounds[collectionExpr_Association, geometry_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Collection.filter",
    "arguments" -> <|
      "collection" -> collectionExpr,
      "filter" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Filter.intersects",
        "arguments" -> <|
          "leftField" -> <|"constantValue" -> ".geo"|>,
          "rightValue" -> geometry
        |>
      |>|>
    |>
  |>|>

buildFilterDate[collectionExpr_Association, start_String, end_String] :=
  Module[{gteFilter, ltFilter, filtered},
    gteFilter = <|"functionInvocationValue" -> <|
      "functionName" -> "Filter.greaterThanOrEquals",
      "arguments" -> <|
        "leftField" -> <|"constantValue" -> "system:time_start"|>,
        "rightValue" -> <|"functionInvocationValue" -> <|
          "functionName" -> "Date",
          "arguments" -> <|"value" -> <|"constantValue" -> start|>|>
        |>|>
      |>
    |>|>;
    ltFilter = <|"functionInvocationValue" -> <|
      "functionName" -> "Filter.lessThan",
      "arguments" -> <|
        "leftField" -> <|"constantValue" -> "system:time_start"|>,
        "rightValue" -> <|"functionInvocationValue" -> <|
          "functionName" -> "Date",
          "arguments" -> <|"value" -> <|"constantValue" -> end|>|>
        |>|>
      |>
    |>|>;
    filtered = <|"functionInvocationValue" -> <|
      "functionName" -> "Collection.filter",
      "arguments" -> <|
        "collection" -> collectionExpr,
        "filter" -> gteFilter
      |>
    |>|>;
    <|"functionInvocationValue" -> <|
      "functionName" -> "Collection.filter",
      "arguments" -> <|
        "collection" -> filtered,
        "filter" -> ltFilter
      |>
    |>|>
  ]

(* --- Spatial filter for image collections --- *)

buildBBoxGeometry[{west_, south_, east_, north_}] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "GeometryConstructors.BBox",
    "arguments" -> <|
      "west" -> <|"constantValue" -> N[west]|>,
      "south" -> <|"constantValue" -> N[south]|>,
      "east" -> <|"constantValue" -> N[east]|>,
      "north" -> <|"constantValue" -> N[north]|>
    |>
  |>|>

buildSpatialFilter[collectionExpr_Association, bbox_List] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Collection.filter",
    "arguments" -> <|
      "collection" -> collectionExpr,
      "filter" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Filter.intersects",
        "arguments" -> <|
          "leftField" -> <|"constantValue" -> ".geo"|>,
          "rightValue" -> buildBBoxGeometry[bbox]
        |>
      |>|>
    |>
  |>|>

buildDateFilter[collectionExpr_Association, startDate_String, endDate_String] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Collection.filter",
    "arguments" -> <|
      "collection" -> collectionExpr,
      "filter" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Filter.dateRangeContains",
        "arguments" -> <|
          "leftValue" -> <|"functionInvocationValue" -> <|
            "functionName" -> "DateRange",
            "arguments" -> <|
              "start" -> <|"constantValue" -> startDate|>,
              "end" -> <|"constantValue" -> endDate|>
            |>
          |>|>,
          "rightField" -> <|"constantValue" -> "system:time_start"|>
        |>
      |>|>
    |>
  |>|>

(* --- Prepare image expression with optional band selection and visualization --- *)

prepareImageExpression[assetId_String, bands_, visParams_Association,
    bbox_ : None] :=
  Module[{expr, info, assetType, collExpr, endDate, startDate},
    info = Quiet[GEEGetAssetInfo[assetId]];
    assetType = If[AssociationQ[info], Lookup[info, "Type", "IMAGE"], "IMAGE"];
    If[assetType === "IMAGE_COLLECTION",
      collExpr = buildCollectionExpression[assetId];
      If[MatchQ[bbox, {_?NumericQ, _?NumericQ, _?NumericQ, _?NumericQ}],
        collExpr = buildSpatialFilter[collExpr, bbox];
        endDate = DateString[Now, "ISODate"];
        startDate = DateString[DatePlus[Now, {-3, "Year"}], "ISODate"];
        collExpr = buildDateFilter[collExpr, startDate, endDate];
      ];
      expr = <|"functionInvocationValue" -> <|
        "functionName" -> "ImageCollection.mosaic",
        "arguments" -> <|"collection" -> collExpr|>
      |>|>,
      expr = buildImageExpression[assetId]
    ];
    If[ListQ[bands],
      expr = buildBandSelection[expr, bands]
    ];
    If[Length[visParams] > 0,
      expr = buildVisualization[expr, visParams]
    ];
    expr
  ]

autoBandsForFormat[assetId_String, fileFormat_String] :=
  Module[{info, bandNames, n},
    If[!MatchQ[ToUpperCase[fileFormat], "PNG" | "JPEG" | "JPG"],
      Return[Automatic]
    ];
    info = Quiet[GEEGetAssetInfo[assetId]];
    If[!AssociationQ[info] || !ListQ[info["Bands"]],
      Return[Automatic]
    ];
    bandNames = info["Bands"][[All, "Name"]];
    n = Length[bandNames];
    Which[
      n <= 3, Automatic,
      n > 3, Take[bandNames, UpTo[3]]
    ]
  ]

(* --- Asset ID normalization --- *)

normalizeAssetId[assetId_String] :=
  StringReplace[assetId, "/" -> "/"]

assetPath[assetId_String] :=
  "assets/" <> assetId

resolveAssetProject[assetId_String] :=
  If[StringStartsQ[assetId, "projects/" | "users/"],
    Automatic,
    "earthengine-public"
  ]

(* --- Parse asset info response --- *)

stripHTML[html_String] :=
  Module[{text},
    text = StringReplace[html, {
      "<br>" | "<br/>" | "<br />" -> "\n",
      "<p>" -> "", "</p>" -> "\n\n",
      "<li>" -> "  - ", "</li>" -> "\n",
      "<ul>" | "</ul>" | "<ol>" | "</ol>" -> "\n",
      RegularExpression["<[^>]+>"] -> ""
    }];
    text = StringReplace[text, {
      "\n\n\n" .. -> "\n\n",
      RegularExpression["[ \\t]+\n"] -> "\n"
    }];
    StringTrim[text]
  ]
stripHTML[_] := ""

fetchSTACMetadata[assetId_String] :=
  Quiet@Module[{top, stacId, url, resp, stac, producers, producer},
    top = First[StringSplit[assetId, "/"], ""];
    stacId = StringReplace[assetId, "/" -> "_"];
    url = "https://storage.googleapis.com/earthengine-stac/catalog/" <>
      top <> "/" <> stacId <> ".json";
    resp = URLRead[HTTPRequest[url], "Body"];
    If[!StringQ[resp] || StringLength[resp] === 0, Return[<||>]];
    stac = ImportString[resp, "RawJSON"];
    If[!AssociationQ[stac], Return[<||>]];
    producers = Select[
      Lookup[stac, "providers", {}],
      MemberQ[Lookup[#, "roles", {}], "producer"] &
    ];
    producer = If[Length[producers] > 0, First[producers], <||>];
    <|
      "Title" -> Lookup[stac, "title", None],
      "Description" -> Lookup[stac, "description", None],
      "Provider" -> Lookup[producer, "name", None],
      "ProviderURL" -> Lookup[producer, "url", None]
    |>
  ]

fetchCollectionBandNames[assetId_String, project_] :=
  Quiet@Module[{expr, bandExpr, requestBody, result},
    expr = <|"functionInvocationValue" -> <|
      "functionName" -> "Collection.first",
      "arguments" -> <|
        "collection" -> buildCollectionExpression[assetId]
      |>
    |>|>;
    bandExpr = <|"functionInvocationValue" -> <|
      "functionName" -> "Image.bandNames",
      "arguments" -> <|"image" -> expr|>
    |>|>;
    requestBody = <|"expression" -> wrapExpression[bandExpr]|>;
    result = geePOST["value:compute", requestBody, project];
    If[AssociationQ[result] && ListQ[result["result"]],
      Map[<|"Name" -> #, "DataType" -> <||>, "Grid" -> <||>|> &,
        result["result"]],
      {}
    ]
  ]

parseAssetInfo[json_Association] :=
  Module[{assetType, bands, props, rawDesc},
    assetType = Lookup[json, "type", "UNKNOWN"];
    props = Lookup[json, "properties", <||>];
    bands = Map[
      <|"Name" -> Lookup[#, "id", ""],
        "DataType" -> Lookup[#, "dataType", <||>],
        "Grid" -> Lookup[#, "grid", <||>]|> &,
      Lookup[json, "bands", {}]
    ];
    rawDesc = Lookup[json, "description",
      Lookup[props, "description", ""]];
    <|"Type" -> assetType,
      "Name" -> Lookup[json, "name", ""],
      "Title" -> Lookup[props, "title",
        Lookup[json, "title", Lookup[json, "id", ""]]],
      "Description" -> stripHTML[rawDesc],
      "Provider" -> Lookup[props, "provider", None],
      "ProviderURL" -> Lookup[props, "provider_url", None],
      "StartTime" -> Lookup[json, "startTime", None],
      "EndTime" -> Lookup[json, "endTime", None],
      "Geometry" -> Lookup[json, "geometry", None],
      "Bands" -> bands,
      "Properties" -> props,
      "SizeBytes" -> Lookup[json, "sizeBytes", None]
    |>
  ]

(* --- Inverse Mercator projection --- *)

fromMercatorX[x_?NumericQ] := x * 180.0 / 20037508.34

fromMercatorY[y_?NumericQ] :=
  (2.0 * ArcTan[Exp[y * Pi / 20037508.34]] - Pi / 2.0) * 180.0 / Pi

(* --- GeoProjection to CRS mapping --- *)

projectionToCRS["Mercator"] := "EPSG:3857"
projectionToCRS["TransverseMercator"] := "EPSG:3857"
projectionToCRS["Equirectangular"] := "EPSG:4326"
projectionToCRS[Automatic] := "EPSG:3857"
projectionToCRS[crs_String] := crs
projectionToCRS[_] := "EPSG:3857"

(* --- Region center computation --- *)

regionCenter[region_] :=
  Module[{bbox, sw, ne},
    bbox = GeoBoundingBox[region];
    If[MatchQ[bbox, {_GeoPosition, _GeoPosition}],
      {sw, ne} = bbox;
      GeoPosition[{(sw[[1, 1]] + ne[[1, 1]]) / 2,
        (sw[[1, 2]] + ne[[1, 2]]) / 2}],
      region
    ]
  ]

(* --- Bounding box computation --- *)

computeBBox[region_, geoRange_, geoCenter_, padding_] :=
  Which[
    MatchQ[geoRange,
      {{_?NumericQ, _?NumericQ}, {_?NumericQ, _?NumericQ}}],
      Module[{sw, ne, box},
        sw = GeoPosition[{geoRange[[1, 1]], geoRange[[2, 1]]}];
        ne = GeoPosition[{geoRange[[1, 2]], geoRange[[2, 2]]}];
        box = {sw, ne};
        If[padding =!= None, GeoBoundingBox[box, padding], box]
      ],

    NumericQ[geoRange],
      Module[{center},
        center = If[MatchQ[geoCenter, _GeoPosition],
          geoCenter, regionCenter[region]];
        GeoBoundingBox[center, Quantity[geoRange, "Meters"]]
      ],

    QuantityQ[geoRange] || MatchQ[geoRange, {__Quantity}],
      Module[{center},
        center = If[MatchQ[geoCenter, _GeoPosition],
          geoCenter, regionCenter[region]];
        GeoBoundingBox[center, geoRange]
      ],

    True,
      If[padding =!= None,
        GeoBoundingBox[region, padding],
        GeoBoundingBox[region]
      ]
  ]

(* --- RasterSize from GeoResolution/GeoZoomLevel --- *)

computeRasterFromResolution[
    geoRes_Quantity,
    {west_, south_, east_, north_},
    midLat_] :=
  Module[{resMeters, widthM, heightM},
    resMeters = QuantityMagnitude[UnitConvert[geoRes, "Meters"]];
    widthM = (east - west) * 111320.0 * Cos[midLat * Pi / 180.0];
    heightM = (north - south) * 110574.0;
    {Max[1, Round[Abs[widthM / resMeters]]],
      Max[1, Round[Abs[heightM / resMeters]]]}
  ]

resolveRasterSize[rasterSize_, geoRes_, geoZoom_, bbox_, midLat_] :=
  Which[
    MatchQ[rasterSize, {_Integer?Positive, _Integer?Positive}],
      rasterSize,

    QuantityQ[geoRes],
      computeRasterFromResolution[geoRes, bbox, midLat],

    IntegerQ[geoZoom] && geoZoom >= 0,
      Module[{resMeters},
        resMeters = 156543.03 * Cos[midLat * Pi / 180.0] /
          2.0^geoZoom;
        computeRasterFromResolution[
          Quantity[resMeters, "Meters"], bbox, midLat]
      ],

    True,
      {512, 512}
  ]

(* --- Tile coordinate computation --- *)

geoToTile[lat_?NumericQ, lon_?NumericQ, level_Integer] :=
  Module[{col, row, latRad},
    col = Floor[(lon + 180.0) / 360.0 * 2^level];
    latRad = lat * Pi / 180.0;
    row = Floor[(1.0 - Log[Tan[latRad] + 1.0 / Cos[latRad]] / Pi) /
      2.0 * 2^level];
    {row, col}
  ]

tileToBBox[z_Integer, x_Integer, y_Integer] :=
  Module[{n, west, east, north, south},
    n = 2^z;
    west = x / n * 360.0 - 180.0;
    east = (x + 1) / n * 360.0 - 180.0;
    north = ArcTan[Sinh[Pi (1.0 - 2.0 y / n)]] * 180.0 / Pi;
    south = ArcTan[Sinh[Pi (1.0 - 2.0 (y + 1) / n)]] * 180.0 / Pi;
    {west, south, east, north}
  ]

(* --- Coordinate projection --- *)

projectCoords[{lat_?NumericQ, lon_?NumericQ}, "Equirectangular"] :=
  {lon, lat}

projectCoords[{lat_?NumericQ, lon_?NumericQ}, "Mercator"] :=
  {lon * 20037508.34 / 180.0,
   Log[Tan[Pi / 4 + lat * Pi / 360]] * 20037508.34 / Pi}

projectCoords[{lat_?NumericQ, lon_?NumericQ}, _] :=
  projectCoords[{lat, lon}, "Mercator"]

(* --- Project bounding box --- *)

projectBBox[{west_?NumericQ, south_?NumericQ,
    east_?NumericQ, north_?NumericQ}, proj_] :=
  Module[{sw, ne},
    sw = projectCoords[{south, west}, proj];
    ne = projectCoords[{north, east}, proj];
    {{sw[[1]], ne[[1]]}, {sw[[2]], ne[[2]]}}
  ]

(* --- Graphics directive predicate --- *)

graphicsDirectiveQ[_RGBColor | _GrayLevel | _Hue | _CMYKColor |
    _Opacity | _PointSize | _Thickness | _Dashing |
    _AbsolutePointSize | _AbsoluteThickness | _AbsoluteDashing |
    _EdgeForm | _FaceForm | _Directive] := True

graphicsDirectiveQ[Red | Blue | Green | Black | White | Yellow |
    Orange | Purple | Cyan | Magenta | Brown | Pink | Gray |
    LightGray] := True

graphicsDirectiveQ[Thick | Thin | Dashed | Dotted | DotDashed] := True

graphicsDirectiveQ[_] := False

(* --- Normalize coordinate formats --- *)

normalizeGeoCoords[coords : {{_?NumericQ, _?NumericQ} ..}] := coords

normalizeGeoCoords[coords : {__GeoPosition}] :=
  Map[First, coords]

normalizeGeoCoords[GeoPosition[coords : {{_?NumericQ, _?NumericQ} ..}]] :=
  coords

normalizeGeoCoords[GeoPosition[{lat_?NumericQ, lon_?NumericQ}]] :=
  {{lat, lon}}

normalizeGeoCoords[other_] := {}

(* --- Extract all GeoPositions from primitives --- *)

extractGeoPositions[GeoPosition[{lat_?NumericQ, lon_?NumericQ}]] :=
  {GeoPosition[{lat, lon}]}

extractGeoPositions[GeoPosition[coords : {{_?NumericQ, _?NumericQ} ..}]] :=
  GeoPosition /@ coords

extractGeoPositions[GeoMarker[pos_, ___]] :=
  extractGeoPositions[pos]

extractGeoPositions[GeoPath[coords_, ___]] :=
  extractGeoPositions[coords]

extractGeoPositions[GeoPolygon[coords_, ___]] :=
  extractGeoPositions[coords]

extractGeoPositions[Point[pos_]] :=
  extractGeoPositions[pos]

extractGeoPositions[Line[coords_]] :=
  extractGeoPositions[coords]

extractGeoPositions[Polygon[coords_]] :=
  extractGeoPositions[coords]

extractGeoPositions[GeoDisk[center_GeoPosition, radius_, ___]] :=
  Join[{center},
    Map[GeoDestination[center,
      {radius, Quantity[#, "AngularDegrees"]}] &,
      {0, 90, 180, 270}]]

extractGeoPositions[GeoCircle[center_GeoPosition, radius_, ___]] :=
  Join[{center},
    Map[GeoDestination[center,
      {radius, Quantity[#, "AngularDegrees"]}] &,
      {0, 90, 180, 270}]]

extractGeoPositions[coords : {{_?NumericQ, _?NumericQ} ..}] :=
  GeoPosition /@ coords

extractGeoPositions[list_List] :=
  Join @@ Map[extractGeoPositions, list]

extractGeoPositions[_] := {}

(* --- Sample points around a geographic circle --- *)

sampleGeoCircle[center_GeoPosition, radius_, n_Integer : 72] :=
  Table[
    First[GeoDestination[center,
      {radius, Quantity[a, "AngularDegrees"]}]],
    {a, 0, 360 - 360 / n, 360 / n}
  ]

(* --- Convert geo primitives to Graphics primitives --- *)

convertPrimitive[d_?graphicsDirectiveQ, _] := d

convertPrimitive[prims_List, proj_] :=
  Map[convertPrimitive[#, proj] &, prims]

convertPrimitive[GeoMarker[pos_GeoPosition], proj_] :=
  {Red, PointSize[0.02],
   Point[projectCoords[First[pos], proj]]}

convertPrimitive[GeoMarker[pos_GeoPosition, style_], proj_] :=
  {style, PointSize[0.02],
   Point[projectCoords[First[pos], proj]]}

convertPrimitive[GeoPath[coords_, ___], proj_] :=
  Line[Map[projectCoords[#, proj] &, normalizeGeoCoords[coords]]]

convertPrimitive[GeoPolygon[coords_, ___], proj_] :=
  Polygon[Map[projectCoords[#, proj] &, normalizeGeoCoords[coords]]]

convertPrimitive[GeoDisk[center_GeoPosition, radius_, ___], proj_] :=
  Polygon[Map[projectCoords[#, proj] &,
    sampleGeoCircle[center, radius]]]

convertPrimitive[GeoCircle[center_GeoPosition, radius_, ___], proj_] :=
  Line[Map[projectCoords[#, proj] &,
    Append[#, First[#]] &[sampleGeoCircle[center, radius]]]]

convertPrimitive[Point[pos_GeoPosition], proj_] :=
  Point[projectCoords[First[pos], proj]]

convertPrimitive[Line[positions : {__GeoPosition}], proj_] :=
  Line[Map[projectCoords[First[#], proj] &, positions]]

convertPrimitive[Polygon[positions : {__GeoPosition}], proj_] :=
  Polygon[Map[projectCoords[First[#], proj] &, positions]]

convertPrimitive[other_, _] := other

(* ================================================================ *)
(* ===              PUBLIC FUNCTION IMPLEMENTATIONS              === *)
(* ================================================================ *)

(* --- GEEConnect --- *)

GEEConnect[keyFile_String, opts : OptionsPattern[]] := Enclose[
  Module[{keyData, projectOpt, project, tokenInfo},
    ConfirmBy[keyFile, FileExistsQ,
      Message[GEEConnect::keynotfound, keyFile]
    ];

    keyData = ConfirmBy[
      Import[keyFile, "RawJSON"],
      AssociationQ,
      Message[GEEConnect::invalidkey, keyFile]
    ];

    ConfirmBy[keyData,
      KeyExistsQ[#, "client_email"] && KeyExistsQ[#, "private_key"] &,
      Message[GEEConnect::invalidkey, keyFile]
    ];

    projectOpt = OptionValue["Project"];
    project = If[projectOpt === Automatic,
      Lookup[keyData, "project_id", "earthengine-legacy"],
      projectOpt
    ];

    tokenInfo = ConfirmBy[
      refreshToken[keyData],
      AssociationQ,
      Message[GEEConnect::authfail, "token exchange failed"]
    ];

    $GEEConnection = Join[tokenInfo, <|
      "Project" -> project,
      "KeyFile" -> keyFile,
      "KeyData" -> keyData
    |>];

    <|"Project" -> project,
      "Status" -> "Connected",
      "Expiry" -> FromUnixTime[$GEEConnection["Expiry"]]|>
  ],
  Function[failure,
    If[!StringQ[keyFile] || !FileExistsQ[keyFile],
      Message[GEEConnect::keynotfound, keyFile],
      Message[GEEConnect::authfail, "authentication failed"]
    ];
    $Failed
  ]
]

GEEConnect[other___] := (
  Message[GEEConnect::authfail, InputForm[{other}]];
  $Failed
)

(* --- GEEGetAssetInfo --- *)

GEEGetAssetInfo[assetId_String, opts : OptionsPattern[]] := Enclose[
  Module[{project, json, info},
    ConfirmBy[ensureAuthenticated[], AssociationQ,
      Message[GEEGetAssetInfo::noauth]
    ];

    project = If[OptionValue["Project"] === Automatic,
      resolveAssetProject[assetId],
      OptionValue["Project"]
    ];
    json = ConfirmBy[
      geeGET[assetPath[assetId], project],
      AssociationQ,
      Message[GEEGetAssetInfo::parsefail, assetId]
    ];

    info = parseAssetInfo[json];
    If[info["Type"] === "IMAGE_COLLECTION" && info["Bands"] === {},
      info = Append[info, "Bands" -> fetchCollectionBandNames[assetId, project]]
    ];

    (* STAC catalog fallback for missing metadata *)
    If[info["Provider"] === None ||
       info["Title"] === assetId || info["Title"] === Lookup[json, "id", ""],
      Module[{stac},
        stac = fetchSTACMetadata[assetId];
        If[AssociationQ[stac] && Length[stac] > 0,
          If[info["Title"] === assetId || info["Title"] === Lookup[json, "id", ""],
            info = Append[info, "Title" -> Lookup[stac, "Title", info["Title"]]]
          ];
          If[info["Description"] === "" && StringQ[stac["Description"]],
            info = Append[info, "Description" -> stac["Description"]]
          ];
          If[info["Provider"] === None,
            info = Append[info, "Provider" -> stac["Provider"]]
          ];
          If[info["ProviderURL"] === None,
            info = Append[info, "ProviderURL" -> stac["ProviderURL"]]
          ];
        ]
      ]
    ];

    info
  ],
  Function[failure,
    Message[GEEGetAssetInfo::fetchfail, assetId];
    $Failed
  ]
]

GEEGetAssetInfo[other___] := (
  Message[GEEGetAssetInfo::fetchfail, InputForm[{other}]];
  $Failed
)

(* --- GEEListAssets --- *)

GEEListAssets[parent_String, opts : OptionsPattern[]] := Enclose[
  Module[{project, maxResults, filter, path, json, assets},
    ConfirmBy[ensureAuthenticated[], AssociationQ,
      Message[GEEListAssets::noauth]
    ];

    project = If[OptionValue["Project"] === Automatic,
      resolveAssetProject[parent],
      OptionValue["Project"]
    ];
    maxResults = OptionValue["MaxResults"];
    filter = OptionValue["Filter"];

    path = assetPath[parent] <> ":listAssets?pageSize=" <>
      ToString[maxResults];
    If[StringQ[filter],
      path = path <> "&filter=" <> URLEncode[filter]
    ];

    json = ConfirmBy[
      geeGET[path, project],
      AssociationQ,
      Message[GEEListAssets::fetchfail, parent]
    ];

    assets = Lookup[json, "assets", {}];
    Map[parseAssetInfo, assets]
  ],
  Function[failure,
    Message[GEEListAssets::fetchfail, parent];
    $Failed
  ]
]

GEEListAssets[other___] := (
  Message[GEEListAssets::fetchfail, InputForm[{other}]];
  $Failed
)

(* --- GEEComputePixels --- *)

GEEComputePixels[assetId_String,
    bbox : {_?NumericQ, _?NumericQ, _?NumericQ, _?NumericQ},
    opts : OptionsPattern[]] :=
  Enclose[
    Module[{project, imageSize, fileFormat, bands, crs, visParams,
        expr, grid, requestBody, responseBytes, img, internalFormat},
      ConfirmBy[ensureAuthenticated[], AssociationQ,
        Message[GEEComputePixels::noauth]
      ];

      project = OptionValue["Project"];
      imageSize = OptionValue["ImageSize"];
      fileFormat = OptionValue["FileFormat"];
      bands = OptionValue["Bands"];
      crs = OptionValue["CRS"];
      visParams = OptionValue["VisParams"];

      If[!ListQ[bands] && Length[visParams] === 0,
        bands = autoBandsForFormat[assetId, fileFormat]
      ];

      expr = prepareImageExpression[assetId, bands, visParams, bbox];

      (* When user provides visParams, honor their requested format.
         Otherwise use GEO_TIFF internally to preserve full dynamic range
         and let Mathematica handle display scaling. *)
      internalFormat = If[Length[visParams] > 0,
        ToUpperCase[fileFormat],
        "GEO_TIFF"
      ];

      grid = buildGridSpec[bbox, imageSize, crs];

      requestBody = <|
        "expression" -> wrapExpression[expr],
        "fileFormat" -> internalFormat,
        "grid" -> grid
      |>;

      If[ListQ[bands] && Length[visParams] === 0,
        requestBody = Append[requestBody, "bandIds" -> bands]
      ];

      responseBytes = geePOSTRaw["image:computePixels", requestBody, project];
      If[FailureQ[responseBytes],
        Message[GEEComputePixels::apierr, assetId,
          responseBytes["MessageTemplate"]];
        Confirm[$Failed]
      ];
      ConfirmBy[responseBytes, ByteArrayQ,
        Message[GEEComputePixels::fetchfail, assetId]
      ];

      If[internalFormat === "GEO_TIFF" && ToUpperCase[fileFormat] =!= "GEO_TIFF",
        (* Internal TIFF fetch: import as GeoTIFF data to get correct
           signed values, then rescale to 0-1 for display.
           Single-band: returns a 2D matrix {h, w}.
           Multi-band: returns a list of 2D matrices {band1, band2, ...}.
           Nodata values (detected as statistical outliers far below the
           data range) are clamped to the valid minimum before rescaling. *)
        Module[{rawData, stacked, flat, validMin, validMax},
          rawData = ImportByteArray[responseBytes, {"GeoTIFF", "Data"}];
          img = Which[
            Length[Dimensions[rawData]] === 2,
              Module[{arr},
                arr = N@Normal[rawData];
                flat = Flatten[arr];
                {validMin, validMax} = Quantile[flat, {0.02, 0.98}];
                arr = Clip[arr, {validMin, validMax}];
                Image[Rescale[arr], "Real32"]
              ],
            ListQ[rawData] && Length[Dimensions[rawData[[1]]]] === 2,
              stacked = MapThread[List, Normal /@ rawData, 2];
              stacked = N@stacked;
              flat = Flatten[stacked];
              {validMin, validMax} = Quantile[flat, {0.02, 0.98}];
              stacked = Clip[stacked, {validMin, validMax}];
              Image[Rescale[stacked], "Real32", ColorSpace -> "RGB"],
            True,
              Message[GEEComputePixels::notimage, Head[rawData]];
              Confirm[$Failed]
          ]
        ],
        (* User-requested format: import directly *)
        img = ImportByteArray[responseBytes,
          Switch[internalFormat,
            "PNG", "PNG",
            "JPEG" | "JPG", "JPEG",
            "GEO_TIFF" | "GEOTIFF" | "TIFF", "TIFF",
            _, "PNG"
          ]
        ]
      ];

      ConfirmBy[img, ImageQ,
        Message[GEEComputePixels::notimage, Head[img]]
      ]
    ],
    Function[failure,
      Message[GEEComputePixels::fetchfail, assetId];
      $Failed
    ]
  ]

GEEComputePixels[_String, bbox_, OptionsPattern[]] := (
  Message[GEEComputePixels::badbbox, InputForm[bbox]];
  $Failed
)

GEEComputePixels[other___] := (
  Message[GEEComputePixels::fetchfail, InputForm[{other}]];
  $Failed
)

(* --- GEEImage --- *)

GEEImage[region_, assetId_String, opts : OptionsPattern[]] := Enclose[
  Module[{geoRange, geoCenter, padding, rasterSize, fileFormat,
      geoRes, geoZoom, geoProj, bands, visParams, imgSize, colSpace,
      project, sw, ne, south, west, north, east, midLat, crs,
      img, meta},

    ConfirmBy[ensureAuthenticated[], AssociationQ,
      Message[GEEImage::noauth]
    ];

    geoRange = OptionValue[GeoRange];
    geoCenter = OptionValue[GeoCenter];
    padding = OptionValue[GeoRangePadding];
    rasterSize = OptionValue[RasterSize];
    fileFormat = OptionValue["FileFormat"];
    geoRes = OptionValue[GeoResolution];
    geoZoom = OptionValue[GeoZoomLevel];
    geoProj = OptionValue[GeoProjection];
    bands = OptionValue["Bands"];
    visParams = OptionValue["VisParams"];
    imgSize = OptionValue[ImageSize];
    colSpace = OptionValue[ColorSpace];
    project = OptionValue["Project"];

    {sw, ne} = ConfirmBy[
      computeBBox[region, geoRange, geoCenter, padding],
      MatchQ[{_GeoPosition, _GeoPosition}],
      Message[GEEImage::bboxfail]
    ];

    If[sw[[1]] === ne[[1]] &&
        (geoRange === Automatic || geoRange === All),
      {sw, ne} = GeoBoundingBox[region, Quantity[10, "Kilometers"]]
    ];

    {south, west} = sw[[1]];
    {north, east} = ne[[1]];

    crs = projectionToCRS[geoProj];

    midLat = (south + north) / 2.0;
    rasterSize = resolveRasterSize[rasterSize, geoRes, geoZoom,
      {west, south, east, north}, midLat];

    img = ConfirmBy[
      GEEComputePixels[assetId, {west, south, east, north},
        "ImageSize" -> rasterSize, "FileFormat" -> fileFormat,
        "Bands" -> bands, "CRS" -> crs, "VisParams" -> visParams,
        "Project" -> project],
      ImageQ,
      Message[GEEImage::imgfail, assetId]
    ];

    If[colSpace =!= Automatic, img = ColorConvert[img, colSpace]];

    meta = <|
      "GeoMetaInformation" -> <|
        "LonLatBox" -> {{west, east}, {south, north}},
        "GeoRange" -> {{south, north}, {west, east}},
        "GeoProjection" -> geoProj,
        "CRS" -> crs,
        "GEEAsset" -> assetId,
        "RasterSize" -> rasterSize
      |>,
      "Exif" -> <|
        "Software" -> "GoogleEarthEngineClient for the Wolfram Language",
        "Copyright" -> "Google Earth Engine imagery"
      |>
    |>;

    If[imgSize =!= Automatic,
      Image[img, MetaInformation -> meta, ImageSize -> imgSize],
      Image[img, MetaInformation -> meta]
    ]
  ],
  Function[failure, $Failed]
]

GEEImage[other___] := (
  Message[GEEImage::imgfail, InputForm[{other}]];
  $Failed
)

(* --- GEEGetTile --- *)

GEEGetTile[assetId_String, z_Integer, x_Integer, y_Integer,
    opts : OptionsPattern[]] :=
  Enclose[
    Module[{project, bands, visParams, bbox, expr, mapBody, mapResponse,
        mapName, tileURL, result},
      ConfirmBy[ensureAuthenticated[], AssociationQ,
        Message[GEEGetTile::noauth]
      ];

      project = OptionValue["Project"];
      bands = OptionValue["Bands"];
      visParams = OptionValue["VisParams"];
      bbox = tileToBBox[z, x, y];

      expr = prepareImageExpression[assetId, bands, visParams, bbox];

      mapBody = <|"expression" -> wrapExpression[expr],
        "fileFormat" -> "PNG"|>;

      mapResponse = ConfirmBy[
        geePOST["maps", mapBody, project],
        AssociationQ,
        Message[GEEGetTile::mapfail, assetId]
      ];

      mapName = ConfirmBy[
        Lookup[mapResponse, "name", None],
        StringQ,
        Message[GEEGetTile::mapfail, assetId]
      ];

      tileURL = $GEEBaseURL <> mapName <> "/tiles/" <>
        ToString[z] <> "/" <> ToString[x] <> "/" <> ToString[y];

      result = Import[
        HTTPRequest[tileURL,
          <|"Headers" -> {
            "Authorization" -> "Bearer " <> $GEEConnection["AccessToken"]
          }|>]
      ];

      ConfirmBy[result, ImageQ,
        Message[GEEGetTile::notimage, Head[result]]
      ]
    ],
    Function[failure,
      Message[GEEGetTile::fetchfail, assetId];
      $Failed
    ]
  ]

GEEGetTile[assetId_String, point_GeoPosition, z_Integer,
    opts : OptionsPattern[]] :=
  Module[{lat, lon, rowCol},
    {lat, lon} = point[[1]];
    rowCol = geoToTile[lat, lon, z];
    GEEGetTile[assetId, z, rowCol[[2]], rowCol[[1]], opts]
  ]

GEEGetTile[other___] := (
  Message[GEEGetTile::fetchfail, InputForm[{other}]];
  $Failed
)

(* --- GEEIdentify --- *)

GEEIdentify[point_GeoPosition, assetId_String,
    opts : OptionsPattern[]] :=
  Enclose[
    Module[{project, bands, lat, lon, bbox, imageExpr, geometry,
        reduceExpr, requestBody, json, result},
      ConfirmBy[ensureAuthenticated[], AssociationQ,
        Message[GEEIdentify::noauth]
      ];

      project = OptionValue["Project"];
      bands = OptionValue["Bands"];
      {lat, lon} = point[[1]];

      bbox = {lon - 0.01, lat - 0.01, lon + 0.01, lat + 0.01};
      imageExpr = prepareImageExpression[assetId, bands,
        <||>, bbox];

      geometry = buildGeometryPoint[lat, lon];
      reduceExpr = buildReduceRegion[imageExpr, geometry, 30];

      requestBody = <|"expression" -> wrapExpression[reduceExpr]|>;

      json = ConfirmBy[
        geePOST["value:compute", requestBody, project],
        AssociationQ,
        Message[GEEIdentify::parsefail]
      ];

      If[KeyExistsQ[json, "error"],
        Message[GEEIdentify::apierr,
          Lookup[Lookup[json, "error", <||>], "message", "Unknown error"]];
        Confirm[$Failed]
      ];

      result = Lookup[json, "result", <||>];
      <|"Position" -> point,
        "Values" -> If[AssociationQ[result], Values[result], {}],
        "Bands" -> If[AssociationQ[result], Keys[result], {}]|>
    ],
    Function[failure,
      Message[GEEIdentify::fetchfail, assetId];
      $Failed
    ]
  ]

GEEIdentify[point_, url_String, opts : OptionsPattern[]] := (
  Message[GEEIdentify::badpoint, InputForm[point]];
  $Failed
)

GEEIdentify[other___] := (
  Message[GEEIdentify::fetchfail, InputForm[{other}]];
  $Failed
)

(* --- GEEGetSamples --- *)

GEEGetSamples[points_List, assetId_String, opts : OptionsPattern[]] :=
  Enclose[
    Module[{bands, project, results},
      bands = OptionValue["Bands"];
      project = OptionValue["Project"];
      results = Map[
        Module[{id},
          id = GEEIdentify[#, assetId,
            "Bands" -> bands, "Project" -> project];
          If[AssociationQ[id],
            <|"Position" -> #,
              "Values" -> id["Values"]|>,
            <|"Position" -> #,
              "Values" -> Missing["Failed"]|>
          ]
        ] &,
        points
      ];
      results
    ],
    Function[failure,
      Message[GEEGetSamples::fetchfail, assetId];
      $Failed
    ]
  ]

GEEGetSamples[other___] := (
  Message[GEEGetSamples::fetchfail, InputForm[{other}]];
  $Failed
)

(* --- GEEComputeFeatures --- *)

GEEComputeFeatures[assetId_String, filter_String,
    opts : OptionsPattern[]] :=
  Enclose[
    Module[{project, properties, maxFeatures, geoBounds,
        collExpr, requestBody, json, features},
      ConfirmBy[ensureAuthenticated[], AssociationQ,
        Message[GEEComputeFeatures::noauth]
      ];

      project = OptionValue["Project"];
      properties = OptionValue["Properties"];
      maxFeatures = OptionValue["MaxFeatures"];
      geoBounds = OptionValue["GeoBounds"];

      collExpr = buildFeatureCollectionExpression[assetId];

      If[MatchQ[geoBounds,
          {_?NumericQ, _?NumericQ, _?NumericQ, _?NumericQ}],
        collExpr = buildFilterBounds[collExpr,
          buildGeometryRectangle @@ geoBounds]
      ];

      If[StringLength[filter] > 0,
        collExpr = <|"functionInvocationValue" -> <|
          "functionName" -> "Collection.filter",
          "arguments" -> <|
            "collection" -> collExpr,
            "filter" -> <|"functionInvocationValue" -> <|
              "functionName" -> "Filter.expression",
              "arguments" -> <|
                "expression" -> <|"constantValue" -> filter|>
              |>
            |>|>
          |>
        |>|>
      ];

      requestBody = <|"expression" -> wrapExpression[collExpr]|>;
      If[IntegerQ[maxFeatures],
        requestBody = Append[requestBody,
          "pageSize" -> Min[maxFeatures, 1000]]
      ];

      json = ConfirmBy[
        geePOST["table:computeFeatures", requestBody, project],
        AssociationQ,
        Message[GEEComputeFeatures::parsefail]
      ];

      If[KeyExistsQ[json, "error"],
        Message[GEEComputeFeatures::apierr,
          Lookup[Lookup[json, "error", <||>], "message", "Unknown error"]];
        Confirm[$Failed]
      ];

      features = Lookup[json, "features", {}];
      Map[
        <|"Properties" -> Lookup[#, "properties", <||>],
          "Geometry" -> Lookup[#, "geometry", None]|> &,
        features
      ]
    ],
    Function[failure,
      Message[GEEComputeFeatures::fetchfail, assetId];
      $Failed
    ]
  ]

GEEComputeFeatures[assetId_String, opts : OptionsPattern[]] :=
  GEEComputeFeatures[assetId, "", opts]

GEEComputeFeatures[other___] := (
  Message[GEEComputeFeatures::fetchfail, InputForm[{other}]];
  $Failed
)

(* --- GEECompute --- *)

GEECompute[expression_Association, opts : OptionsPattern[]] :=
  Enclose[
    Module[{project, requestBody, json},
      ConfirmBy[ensureAuthenticated[], AssociationQ,
        Message[GEECompute::noauth]
      ];

      project = OptionValue["Project"];
      requestBody = <|"expression" -> wrapExpression[expression]|>;

      json = ConfirmBy[
        geePOST["value:compute", requestBody, project],
        AssociationQ,
        Message[GEECompute::parsefail]
      ];

      If[KeyExistsQ[json, "error"],
        Message[GEECompute::apierr,
          Lookup[Lookup[json, "error", <||>], "message", "Unknown error"]];
        Confirm[$Failed]
      ];

      Lookup[json, "result", json]
    ],
    Function[failure,
      Message[GEECompute::fetchfail];
      $Failed
    ]
  ]

GEECompute[other___] := (
  Message[GEECompute::fetchfail];
  $Failed
)

(* --- GEEGeoGraphics --- *)

GEEGeoGraphics[primitives_, assetId_String, opts : OptionsPattern[]] :=
  Enclose[
    Module[{proj, geoRange, geoCenter, padding, rasterSize, imgFmt,
        geoRes, geoZoom, bands, visParams, imgSize, geoBg, colSpace,
        project, allPositions, sw, ne, south, west, north, east,
        midLat, crs, bgImage, projBBox, gfxPrims, bgElement, gfxOpts},

      ConfirmBy[ensureAuthenticated[], AssociationQ,
        Message[GEEGeoGraphics::noauth]
      ];

      proj = OptionValue[GeoProjection];
      geoRange = OptionValue[GeoRange];
      geoCenter = OptionValue[GeoCenter];
      padding = OptionValue[GeoRangePadding];
      rasterSize = OptionValue[RasterSize];
      imgFmt = OptionValue["FileFormat"];
      geoRes = OptionValue[GeoResolution];
      geoZoom = OptionValue[GeoZoomLevel];
      bands = OptionValue["Bands"];
      visParams = OptionValue["VisParams"];
      imgSize = OptionValue[ImageSize];
      geoBg = OptionValue[GeoBackground];
      colSpace = OptionValue[ColorSpace];
      project = OptionValue["Project"];

      allPositions = extractGeoPositions[primitives];
      If[allPositions === {} && geoRange === Automatic,
        Message[GEEGeoGraphics::noprims];
        Return[$Failed, Module]
      ];

      {sw, ne} = ConfirmBy[
        computeBBox[
          If[allPositions =!= {}, allPositions, GeoPosition[{0, 0}]],
          geoRange, geoCenter, padding],
        MatchQ[{_GeoPosition, _GeoPosition}],
        Message[GEEGeoGraphics::bboxfail]
      ];

      If[sw[[1]] === ne[[1]] && geoRange === Automatic,
        {sw, ne} = GeoBoundingBox[allPositions,
          Quantity[10, "Kilometers"]]
      ];

      {south, west} = sw[[1]];
      {north, east} = ne[[1]];

      crs = projectionToCRS[proj];

      midLat = (south + north) / 2.0;
      rasterSize = resolveRasterSize[rasterSize, geoRes, geoZoom,
        {west, south, east, north}, midLat];

      bgImage = If[geoBg =!= None,
        Module[{img},
          img = GEEComputePixels[assetId, {west, south, east, north},
            "ImageSize" -> rasterSize, "FileFormat" -> imgFmt,
            "Bands" -> bands, "CRS" -> crs, "VisParams" -> visParams,
            "Project" -> project];
          If[colSpace =!= Automatic && ImageQ[img],
            ColorConvert[img, colSpace], img]
        ],
        None
      ];

      projBBox = projectBBox[{west, south, east, north}, proj];

      gfxPrims = convertPrimitive[primitives, proj];

      bgElement = If[ImageQ[bgImage],
        Inset[bgImage,
          {projBBox[[1, 1]], projBBox[[2, 1]]},
          {0, 0},
          {projBBox[[1, 2]] - projBBox[[1, 1]],
           projBBox[[2, 2]] - projBBox[[2, 1]]}],
        Nothing
      ];

      gfxOpts = {
        PlotRange -> projBBox,
        AspectRatio -> Automatic,
        Frame -> True,
        FrameTicks -> None
      };
      If[imgSize =!= Automatic,
        gfxOpts = Append[gfxOpts, ImageSize -> imgSize]
      ];

      Graphics[{bgElement, gfxPrims}, Sequence @@ gfxOpts]
    ],
    Function[failure, $Failed]
  ]

GEEGeoGraphics[other___] := (
  Message[GEEGeoGraphics::bgfail, InputForm[{other}]];
  $Failed
)

End[]

EndPackage[]

(* Remove any Global` shadows created by interactive loading *)
Quiet[
  If[NameQ["Global`GEEConnect"], Remove["Global`GEEConnect"]];
  If[NameQ["Global`GEEGetAssetInfo"], Remove["Global`GEEGetAssetInfo"]];
  If[NameQ["Global`GEEListAssets"], Remove["Global`GEEListAssets"]];
  If[NameQ["Global`GEEComputePixels"], Remove["Global`GEEComputePixels"]];
  If[NameQ["Global`GEEImage"], Remove["Global`GEEImage"]];
  If[NameQ["Global`GEEGetTile"], Remove["Global`GEEGetTile"]];
  If[NameQ["Global`GEEIdentify"], Remove["Global`GEEIdentify"]];
  If[NameQ["Global`GEEGetSamples"], Remove["Global`GEEGetSamples"]];
  If[NameQ["Global`GEEComputeFeatures"], Remove["Global`GEEComputeFeatures"]];
  If[NameQ["Global`GEECompute"], Remove["Global`GEECompute"]];
  If[NameQ["Global`GEEGeoGraphics"], Remove["Global`GEEGeoGraphics"]];
  If[NameQ["Global`$GEEConnection"], Remove["Global`$GEEConnection"]];
]
