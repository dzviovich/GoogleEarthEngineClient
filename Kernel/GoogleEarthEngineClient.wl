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

GEEComputePixels::usage = "GEEComputePixels[bbox, assetId] compute pixels \
for a GEE image asset over the bounding box {west, south, east, north}. \
Return an Image.\n\
GEEComputePixels[region, assetId] compute pixels over the bounding box of \
region. Supported region types include GeoPosition, Polygon, GeoPolygon, \
GeoPath, Line, GeoDisk, GeoCircle, Entity, and any object accepted by \
GeoBoundingBox.\n\
GEEComputePixels[bbox, assetId, opts] compute with options \"ImageSize\", \
\"FileFormat\", \"Bands\", and \"CRS\".\n\
assetId can be an asset ID string or a pre-built GEE expression Association."

GEEImage::usage = "GEEImage[region, assetId] return a geo-tagged Image of \
region from the Google Earth Engine asset.\n\
GEEImage[region, assetId, opts] return an image with options \
RasterSize, GeoRange, GeoCenter, GeoResolution, GeoZoomLevel, \
GeoProjection, GeoRangePadding, \"FileFormat\", \"Bands\", ImageSize, \
and ColorSpace.\n\
assetId can be an asset ID string or a pre-built GEE expression Association."

GEEGetTile::usage = "GEEGetTile[assetId, z, x, y] fetch a map tile at \
zoom level z, tile coordinates x, y for a GEE asset. Return an Image.\n\
GEEGetTile[assetId, point, z] fetch the tile containing a GeoPosition \
or geographic Entity at the given zoom level.\n\
GEEGetTile[assetId, z, x, y, opts] fetch with options \"Bands\" and \
\"VisParams\".\n\
assetId can be an asset ID string or a pre-built GEE expression Association."

GEEIdentify::usage = "GEEIdentify[point, assetId] identify pixel values \
at a point from a Google Earth Engine image asset. Return an \
Association with keys \"Position\", \"Values\", and \"Bands\".\n\
GEEIdentify[point, assetId, opts] identify with option \"Bands\".\n\
point can be a GeoPosition, or a geographic Entity such as \
Entity[\"City\", ...], Entity[\"Mountain\", ...], etc.\n\
assetId can be an asset ID string or a pre-built GEE expression Association."

GEEGetSamples::usage = "GEEGetSamples[points, assetId] extract pixel \
values at a list of points from a GEE image asset. Return a list of \
Associations with keys \"Position\" and \"Values\".\n\
GEEGetSamples[points, assetId, opts] extract with option \"Bands\".\n\
points can be GeoPosition objects, geographic Entity objects, or a \
mix of both.\n\
assetId can be an asset ID string or a pre-built GEE expression Association."

GEEComputeFeatures::usage = "GEEComputeFeatures[assetId, filter] query \
features from a Google Earth Engine table asset matching the filter. \
Return a list of feature Associations.\n\
GEEComputeFeatures[assetId, filter, opts] query with options \
\"Properties\", \"MaxFeatures\", and \"GeoBounds\".\n\
assetId can be an asset ID string or a pre-built GEE expression Association."

GEECompute::usage = "GEECompute[expression] compute an arbitrary value \
from a Google Earth Engine expression and return the result.\n\
GEECompute[expression, opts] compute with option \"Project\"."

GEEGeoGraphics::usage = "GEEGeoGraphics[primitives, assetId] render \
geographic primitives on a background map from a GEE asset. Return a \
Graphics object.\n\
GEEGeoGraphics[primitives, assetId, opts] render with options \
GeoProjection, GeoRange, GeoCenter, GeoRangePadding, RasterSize, \
GeoResolution, GeoZoomLevel, \"FileFormat\", \"Bands\", ImageSize, \
GeoBackground, ColorSpace, and \"VisParams\".\n\
assetId can be an asset ID string or a pre-built GEE expression Association."

$GEEConnection::usage = "$GEEConnection holds the current authentication \
state as an Association with keys \"Project\", \"AccessToken\", \"Expiry\", \
and \"KeyFile\". Set by GEEConnect."

GEECollection::usage = "GEECollection[assetId] create a GEE expression \
for an ImageCollection asset."

GEELoadImage::usage = "GEELoadImage[assetId] create a GEE expression \
for a single Image asset."

GEEFilterDate::usage = "GEEFilterDate[collection, start, end] filter a \
collection expression by date range (ISO 8601 strings).\n\
GEEFilterDate[start, end] operator form for use with //."

GEEFilterBounds::usage = "GEEFilterBounds[collection, bbox] filter a \
collection expression by spatial bounds {west, south, east, north}.\n\
GEEFilterBounds[bbox] operator form for use with //.\n\
GEEFilterBounds[region] also accepts GeoPosition, Polygon, GeoPolygon, \
GeoDisk, GeoCircle, Rectangle, Entity, and other geo primitives; the \
bounding box is computed automatically via GeoBoundingBox."

GEEFilterBounds::bboxfail = "Could not compute a bounding box from `1`."

GEEFilterProperty::usage = "GEEFilterProperty[collection, property, op, \
value] filter a collection by a metadata property. op can be \
\"LessThan\", \"GreaterThan\", \"Equals\", \"LessThanOrEquals\", \
\"GreaterThanOrEquals\", or \"NotEquals\".\n\
GEEFilterProperty[property, op, value] operator form for use with //."

GEEMosaic::usage = "GEEMosaic[collection] mosaic a collection expression \
into a single image expression."

GEEMedian::usage = "GEEMedian[collection] reduce a collection to the \
per-pixel median, producing a single image expression."

GEEMean::usage = "GEEMean[collection] reduce a collection to the \
per-pixel mean, producing a single image expression."

GEESelectBands::usage = "GEESelectBands[image, bands] select bands from \
an image expression.\n\
GEESelectBands[bands] operator form for use with //."

GEEVisualize::usage = "GEEVisualize[image, visParams] apply server-side \
visualization to an image expression. visParams is an Association with \
keys \"min\", \"max\", \"palette\", \"bands\", \"gamma\".\n\
GEEVisualize[visParams] operator form for use with //."

GEESort::usage = "GEESort[collection, property] sort a collection by \
property in ascending order.\n\
GEESort[collection, property, ascending] sort with explicit direction.\n\
GEESort[property] operator form for use with //."

GEEFirst::usage = "GEEFirst[collection] get the first image from a \
collection expression."

GEELimit::usage = "GEELimit[collection, n] limit a collection to at \
most n images.\n\
GEELimit[n] operator form for use with //."

GEEFeatureCollection::usage = "GEEFeatureCollection[assetId] create a \
GEE expression for a FeatureCollection (table) asset."

GEEReduceRegion::usage = "GEEReduceRegion[image, geometry, reducer, \
scale] compute a statistic over a region. reducer can be \"mean\", \
\"min\", \"max\", \"sum\", \"first\", \"median\".\n\
GEEReduceRegion[geometry, reducer, scale] operator form for use with //."

GEEGeometry::usage = "GEEGeometry[{lat, lon}] create a GEE point \
geometry expression.\n\
GEEGeometry[{west, south, east, north}] create a GEE rectangle geometry \
expression."

GEENormalizedDifference::usage = "GEENormalizedDifference[image, {band1, \
band2}] compute (band1 - band2) / (band1 + band2) server-side.\n\
GEENormalizedDifference[{band1, band2}] operator form for use with //."

GEEClip::usage = "GEEClip[image, geometry] clip an image to a geometry.\n\
GEEClip[geometry] operator form for use with //."

GEEUpdateMask::usage = "GEEUpdateMask[image, mask] update the mask of an \
image using another image.\n\
GEEUpdateMask[mask] operator form for use with //."

GEEUnmask::usage = "GEEUnmask[image, value] replace masked pixels with \
value.\n\
GEEUnmask[value] operator form for use with //.\n\
GEEUnmask[image] replace masked pixels with 0."

GEESelfMask::usage = "GEESelfMask[image] mask pixels where the value is 0 \
or already masked."

GEEAddBands::usage = "GEEAddBands[image, other] add bands from other image \
to image.\n\
GEEAddBands[other] operator form for use with //."

GEERename::usage = "GEERename[image, names] rename bands of an image.\n\
GEERename[names] operator form for use with //."

GEEAdd::usage = "GEEAdd[image, other] per-pixel addition. other can be an \
image or a number.\n\
GEEAdd[other] operator form for use with //."

GEESubtract::usage = "GEESubtract[image, other] per-pixel subtraction.\n\
GEESubtract[other] operator form for use with //."

GEEMultiply::usage = "GEEMultiply[image, other] per-pixel multiplication.\n\
GEEMultiply[other] operator form for use with //."

GEEDivide::usage = "GEEDivide[image, other] per-pixel division.\n\
GEEDivide[other] operator form for use with //."

GEEExpression::usage = "GEEExpression[image, expr, bindings] evaluate a \
math expression string with band variable bindings. Supports +, -, *, \
/, ** (power), and parentheses.\n\
GEEExpression[expr, bindings] operator form for use with //."

GEEExpression::badvar = "Unknown variable `1` in expression. Check bindings."
GEEExpression::badexpr = "Could not parse expression: `1`."

GEEGreaterThan::usage = "GEEGreaterThan[image, other] per-pixel greater \
than comparison returning 0/1.\n\
GEEGreaterThan[other] operator form for use with //."

GEELessThan::usage = "GEELessThan[image, other] per-pixel less than \
comparison returning 0/1.\n\
GEELessThan[other] operator form for use with //."

GEEEquals::usage = "GEEEquals[image, other] per-pixel equality comparison \
returning 0/1.\n\
GEEEquals[other] operator form for use with //."

GEENotEquals::usage = "GEENotEquals[image, other] per-pixel inequality \
comparison returning 0/1.\n\
GEENotEquals[other] operator form for use with //."

GEEAnd::usage = "GEEAnd[image, other] logical AND of two images.\n\
GEEAnd[other] operator form for use with //."

GEEOr::usage = "GEEOr[image, other] logical OR of two images.\n\
GEEOr[other] operator form for use with //."

GEENot::usage = "GEENot[image] logical NOT of an image."

GEEWhere::usage = "GEEWhere[image, test, value] replace pixels where test \
is true with value.\n\
GEEWhere[test, value] operator form for use with //."

GEECollectionMap::usage = "GEECollectionMap[collection, func] apply a \
function to each image in a collection. func receives an image expression \
and must return an image expression.\n\
GEECollectionMap[func] operator form for use with //."

GEEQualityMosaic::usage = "GEEQualityMosaic[collection, qualityBand] \
mosaic using a quality band for best-pixel selection.\n\
GEEQualityMosaic[qualityBand] operator form for use with //."

GEEMerge::usage = "GEEMerge[collection1, collection2] merge two \
collections.\n\
GEEMerge[collection2] operator form for use with //."

GEECollectionMax::usage = "GEECollectionMax[collection] pixel-wise max \
composite of a collection."

GEECollectionMin::usage = "GEECollectionMin[collection] pixel-wise min \
composite of a collection."

GEECollectionSum::usage = "GEECollectionSum[collection] pixel-wise sum \
of a collection."

GEEToBands::usage = "GEEToBands[collection] stack all images in a \
collection into a single multi-band image."

GEEReduceStdDev::usage = "GEEReduceStdDev[collection] reduce a collection \
to the per-pixel standard deviation."

GEEReduceCount::usage = "GEEReduceCount[collection] reduce a collection \
to the per-pixel count of non-masked values."

GEEReducePercentile::usage = "GEEReducePercentile[collection, percentiles] \
reduce a collection to specified percentiles.\n\
GEEReducePercentile[percentiles] operator form for use with //."

GEETerrain::usage = "GEETerrain[image] compute slope, aspect, and hillshade \
from a DEM image using Algorithms.Terrain."

GEEReproject::usage = "GEEReproject[image, crs, scale] reproject an image to \
the given CRS at the specified scale in meters.\n\
GEEReproject[crs, scale] operator form for use with //."

GEEResample::usage = "GEEResample[image, method] set the resampling method \
for an image. method can be \"bilinear\" or \"bicubic\".\n\
GEEResample[method] operator form for use with //."

GEEFocalMean::usage = "GEEFocalMean[image, radius] apply a focal mean \
filter with the given radius in meters.\n\
GEEFocalMean[radius] operator form for use with //."

GEEFocalMax::usage = "GEEFocalMax[image, radius] apply a focal max filter \
with the given radius in meters.\n\
GEEFocalMax[radius] operator form for use with //."

GEEFocalMin::usage = "GEEFocalMin[image, radius] apply a focal min filter \
with the given radius in meters.\n\
GEEFocalMin[radius] operator form for use with //."

GEEFocalMedian::usage = "GEEFocalMedian[image, radius] apply a focal \
median filter with the given radius in meters.\n\
GEEFocalMedian[radius] operator form for use with //."

GEEConvolve::usage = "GEEConvolve[image, kernel] convolve an image with a \
kernel expression.\n\
GEEConvolve[kernel] operator form for use with //."

GEEGradient::usage = "GEEGradient[image] compute the x and y gradient of \
an image."

GEEEntropy::usage = "GEEEntropy[image, radius] compute entropy within a \
neighborhood of the given radius in meters.\n\
GEEEntropy[radius] operator form for use with //."

GEEPixelArea::usage = "GEEPixelArea[] create an image where each pixel \
value is its area in square meters."

GEEPixelLonLat::usage = "GEEPixelLonLat[] create an image with longitude \
and latitude coordinate bands."

GEEConstant::usage = "GEEConstant[value] create a constant-value image."

GEEReduceRegions::usage = "GEEReduceRegions[image, featureCollection, \
reducer, scale] reduce an image over multiple geometries at once.\n\
GEEReduceRegions[featureCollection, reducer, scale] operator form for \
use with //."

GEESample::usage = "GEESample[image, region, scale] sample pixel values \
from an image within a region at the specified scale.\n\
GEESample[region, scale] operator form for use with //."

GEEReduceToVectors::usage = "GEEReduceToVectors[image, geometry, scale] \
vectorize an image within a geometry at the specified scale.\n\
GEEReduceToVectors[geometry, scale] operator form for use with //."

GEEPow::usage = "GEEPow[image, other] per-pixel exponentiation.\n\
GEEPow[other] operator form for use with //."

GEEMod::usage = "GEEMod[image, other] per-pixel modulo.\n\
GEEMod[other] operator form for use with //."

GEEAbs::usage = "GEEAbs[image] per-pixel absolute value."

GEESqrt::usage = "GEESqrt[image] per-pixel square root."

GEELog::usage = "GEELog[image] per-pixel natural logarithm."

GEELog10::usage = "GEELog10[image] per-pixel base-10 logarithm."

GEEExp::usage = "GEEExp[image] per-pixel exponential (e^x)."

GEEPolygon::usage = "GEEPolygon[coordinates] create a GEE polygon geometry \
from a list of {lon, lat} coordinate pairs."

GEELineString::usage = "GEELineString[coordinates] create a GEE line \
geometry from a list of {lon, lat} coordinate pairs.\n\
GEELineString[{GeoPosition[{lat1,lon1}], ...}] create a GEE line \
geometry from a list of GeoPosition objects."

GEEBuffer::usage = "GEEBuffer[geometry, distance] buffer a geometry by \
distance in meters.\n\
GEEBuffer[distance] operator form for use with //."

GEECentroid::usage = "GEECentroid[geometry] compute the centroid of a \
geometry."

GEEBounds::usage = "GEEBounds[geometry] compute the bounding box of a \
geometry."

GEEArea::usage = "GEEArea[geometry] compute the area of a geometry in \
square meters."

GEEGet::usage = "GEEGet[image, property] get a metadata property value \
from an image.\n\
GEEGet[property] operator form for use with //."

GEESet::usage = "GEESet[image, properties] set metadata properties on an \
image. properties is an Association.\n\
GEESet[properties] operator form for use with //."

GEEDate::usage = "GEEDate[image] get the acquisition date of an image."

GEECast::usage = "GEECast[image, bandTypes] cast band types. bandTypes is \
an Association mapping band names to type strings.\n\
GEECast[bandTypes] operator form for use with //."

GEEToFloat::usage = "GEEToFloat[image] convert all bands to float type."

GEEToInt::usage = "GEEToInt[image] convert all bands to integer type."

GEEJoinSimple::usage = "GEEJoinSimple[primary, secondary, condition] \
perform a simple join of two collections using a filter condition."

GEEJoinInner::usage = "GEEJoinInner[primary, secondary, condition] \
perform an inner join of two collections using a filter condition."

GEEJoinSaveBest::usage = "GEEJoinSaveBest[primary, secondary, condition, \
propertyName] join and save the best match as a property.\n\
GEEJoinSaveBest[secondary, condition, propertyName] operator form for \
use with //."

GEEJoinSaveAll::usage = "GEEJoinSaveAll[primary, secondary, condition, \
propertyName] join and save all matches as a property.\n\
GEEJoinSaveAll[secondary, condition, propertyName] operator form for \
use with //."

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
GEEComputePixels::bboxfail = "Could not compute bounding box from region `1`.";
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
GEEIdentify::badpoint = "Expected a GeoPosition or geographic Entity, got `1`.";
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
  Module[{url, token, bodyJSON, resp, bodyBytes},
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
    bodyBytes = resp["BodyByteArray"];
    ImportByteArray[bodyBytes, "RawJSON"]
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
  Module[{counter, values, flatten},
    counter = 0;
    values = <||>;

    flatten[e_Association] := Which[
      KeyExistsQ[e, "functionInvocationValue"],
        Module[{fiv = e["functionInvocationValue"], newArgs},
          newArgs = Association @ KeyValueMap[
            Function[{k, v}, k -> flatten[v]],
            fiv["arguments"]
          ];
          <|"functionInvocationValue" -> <|
            "functionName" -> fiv["functionName"],
            "arguments" -> newArgs
          |>|>
        ],
      KeyExistsQ[e, "functionDefinitionValue"],
        Module[{fdef = e["functionDefinitionValue"], bodyKey, processedBody},
          counter++;
          bodyKey = ToString[counter];
          processedBody = flatten[fdef["body"]];
          AssociateTo[values, bodyKey -> processedBody];
          <|"functionDefinitionValue" -> <|
            "argumentNames" -> fdef["argumentNames"],
            "body" -> bodyKey
          |>|>
        ],
      KeyExistsQ[e, "dictionaryValue"],
        Module[{dv = e["dictionaryValue"], newVals},
          newVals = Association @ KeyValueMap[
            Function[{k, v}, k -> flatten[v]],
            dv["values"]
          ];
          <|"dictionaryValue" -> <|"values" -> newVals|>|>
        ],
      True,
        e
    ];

    flatten[other_] := other;

    AssociateTo[values, "0" -> flatten[expr]];
    <|"result" -> "0", "values" -> values|>
  ]

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
      args = Append[args, "min" -> <|"constantValue" -> visParams["min"]|>]
    ];
    If[KeyExistsQ[visParams, "max"],
      args = Append[args, "max" -> <|"constantValue" -> visParams["max"]|>]
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
        "gamma" -> <|"constantValue" -> visParams["gamma"]|>]
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

prepareImageExpression[expr_Association, bands_, visParams_Association,
    bbox_ : None] :=
  Module[{result = expr},
    If[ListQ[bands], result = buildBandSelection[result, bands]];
    If[Length[visParams] > 0, result = buildVisualization[result, visParams]];
    result
  ]

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
      "&amp;" -> "&", "&lt;" -> "<", "&gt;" -> ">",
      "&quot;" -> "\"", "&apos;" -> "'", "&nbsp;" -> " ",
      RegularExpression["&#(\\d+);"] :> FromCharacterCode[FromDigits["$1"]],
      RegularExpression["&#x([0-9a-fA-F]+);"] :> FromCharacterCode[FromDigits["$1", 16]]
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
  Quiet@Module[{path, json, assets, firstImage, bands,
      expr, bandExpr, requestBody, result},
    (* Try listing one child image to get full band metadata *)
    path = assetPath[assetId] <> ":listAssets?pageSize=1";
    json = geeGET[path, project];
    assets = If[AssociationQ[json], Lookup[json, "assets", {}], {}];
    If[Length[assets] > 0,
      firstImage = First[assets];
      bands = Map[
        <|"Name" -> Lookup[#, "id", ""],
          "DataType" -> Lookup[#, "dataType", <||>],
          "Grid" -> Lookup[#, "grid", <||>]|> &,
        Lookup[firstImage, "bands", {}]
      ];
      If[Length[bands] > 0, Return[bands]]
    ];
    (* Fallback: compute band names via EE expression *)
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
      Map[<|"Name" -> #|> &, result["result"]],
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
      "Title" -> stripHTML[Lookup[props, "title",
        Lookup[json, "title", Lookup[json, "id", ""]]]],
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

(* Convert any geo primitive to {west, south, east, north} bbox *)
toBoundingBox[bbox : {_?NumericQ, _?NumericQ, _?NumericQ, _?NumericQ}] :=
  bbox

toBoundingBox[region_] :=
  Module[{result, sw, ne},
    result = Quiet[GeoBoundingBox[region]];
    If[MatchQ[result, {_GeoPosition, _GeoPosition}],
      {sw, ne} = result;
      {sw[[1, 2]], sw[[1, 1]], ne[[1, 2]], ne[[1, 1]]},
      $Failed
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
            info = Append[info, "Title" -> stripHTML[Lookup[stac, "Title", info["Title"]]]]
          ];
          If[info["Description"] === "" && StringQ[stac["Description"]],
            info = Append[info, "Description" -> stripHTML[stac["Description"]]]
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

GEEComputePixels[bbox : {_?NumericQ, _?NumericQ, _?NumericQ, _?NumericQ},
    assetId : (_String | _Association),
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

      If[StringQ[assetId] && !ListQ[bands] && Length[visParams] === 0,
        bands = autoBandsForFormat[assetId, fileFormat]
      ];

      expr = prepareImageExpression[assetId, bands, visParams, bbox];

      (* When visParams are provided, Image.visualize produces byte data;
         use PNG to preserve the 8-bit range correctly.
         Without visParams, use GEO_TIFF to preserve full dynamic range
         and rescale client-side. *)
      internalFormat = If[Length[visParams] > 0, "PNG", "GEO_TIFF"];

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

      If[internalFormat === "PNG",
        (* Image.visualize applied server-side; PNG preserves 8-bit range *)
        img = ImportByteArray[responseBytes, "PNG"],
        If[ToUpperCase[fileFormat] =!= "GEO_TIFF",
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
                  arr = Reverse[N@Normal[rawData]];
                  flat = Flatten[arr];
                  {validMin, validMax} = Quantile[flat, {0.02, 0.98}];
                  arr = Clip[arr, {validMin, validMax}];
                  Image[Rescale[arr], "Real32"]
                ],
              ListQ[rawData] && Length[Dimensions[rawData[[1]]]] === 2,
                stacked = MapThread[List, Reverse /@ (Normal /@ rawData), 2];
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
          (* User explicitly requested GEO_TIFF: import directly *)
          img = ImportByteArray[responseBytes, "TIFF"]
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

GEEComputePixels[region_, assetId : (_String | _Association), opts : OptionsPattern[]] :=
  Module[{result, sw, ne, south, west, north, east},
    result = Quiet[
      Check[computeBBox[region, Automatic, Automatic, None], $Failed]
    ];
    If[!MatchQ[result, {_GeoPosition, _GeoPosition}],
      Message[GEEComputePixels::bboxfail, InputForm[region]];
      Return[$Failed]
    ];
    {sw, ne} = result;
    {south, west} = sw[[1]];
    {north, east} = ne[[1]];
    If[south == north || west == east,
      result = Quiet[GeoBoundingBox[region, Quantity[1, "Kilometers"]]];
      If[!MatchQ[result, {_GeoPosition, _GeoPosition}],
        Message[GEEComputePixels::bboxfail, InputForm[region]];
        Return[$Failed]
      ];
      {sw, ne} = result;
      {south, west} = sw[[1]];
      {north, east} = ne[[1]]
    ];
    GEEComputePixels[{west, south, east, north}, assetId, opts]
  ]

GEEComputePixels[other___] := (
  Message[GEEComputePixels::fetchfail, InputForm[{other}]];
  $Failed
)

(* --- GEEImage --- *)

GEEImage[region_, assetId : (_String | _Association), opts : OptionsPattern[]] := Enclose[
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
      GEEComputePixels[{west, south, east, north}, assetId,
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

GEEGetTile[assetId : (_String | _Association), z_Integer, x_Integer, y_Integer,
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

GEEGetTile[assetId : (_String | _Association), point_GeoPosition, z_Integer,
    opts : OptionsPattern[]] :=
  Module[{lat, lon, rowCol},
    {lat, lon} = point[[1]];
    rowCol = geoToTile[lat, lon, z];
    GEEGetTile[assetId, z, rowCol[[2]], rowCol[[1]], opts]
  ]

GEEGetTile[assetId : (_String | _Association), point_Entity, z_Integer,
    opts : OptionsPattern[]] :=
  Module[{pos},
    pos = Quiet[GeoPosition[point]];
    If[MatchQ[pos, _GeoPosition],
      GEEGetTile[assetId, pos, z, opts],
      Message[GEEGetTile::fetchfail, InputForm[point]];
      $Failed
    ]
  ]

GEEGetTile[other___] := (
  Message[GEEGetTile::fetchfail, InputForm[{other}]];
  $Failed
)

(* --- GEEIdentify --- *)

GEEIdentify[point_GeoPosition, assetId : (_String | _Association),
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

GEEIdentify[point_Entity, assetId : (_String | _Association),
    opts : OptionsPattern[]] :=
  Module[{pos},
    pos = Quiet[GeoPosition[point]];
    If[MatchQ[pos, _GeoPosition],
      GEEIdentify[pos, assetId, opts],
      Message[GEEIdentify::badpoint, InputForm[point]];
      $Failed
    ]
  ]

GEEIdentify[point_?(!MatchQ[#, _Entity] &), url_String, opts : OptionsPattern[]] := (
  Message[GEEIdentify::badpoint, InputForm[point]];
  $Failed
)

GEEIdentify[other___] := (
  Message[GEEIdentify::fetchfail, InputForm[{other}]];
  $Failed
)

(* --- GEEGetSamples --- *)

GEEGetSamples[points_List, assetId : (_String | _Association), opts : OptionsPattern[]] :=
  Enclose[
    Module[{bands, project, results},
      bands = OptionValue["Bands"];
      project = OptionValue["Project"];
      results = Map[
        Module[{pt, id},
          pt = If[MatchQ[#, _Entity],
            Quiet[GeoPosition[#]], #];
          id = GEEIdentify[pt, assetId,
            "Bands" -> bands, "Project" -> project];
          If[AssociationQ[id],
            <|"Position" -> id["Position"],
              "Values" -> id["Values"]|>,
            <|"Position" -> pt,
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

GEEComputeFeatures[assetId : (_String | _Association), filter_String,
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

      collExpr = If[StringQ[assetId],
        buildFeatureCollectionExpression[assetId],
        assetId
      ];

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

GEEGeoGraphics[primitives_, assetId : (_String | _Association), opts : OptionsPattern[]] :=
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
          img = GEEComputePixels[{west, south, east, north}, assetId,
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

(* --- Expression builder helpers --- *)

GEECollection[assetId_String] :=
  buildCollectionExpression[assetId]

GEELoadImage[assetId_String] :=
  buildImageExpression[assetId]

GEEFilterDate[collection_Association, start_String, end_String] :=
  buildDateFilter[collection, start, end]

GEEFilterDate[start_String, end_String] :=
  Function[collection, buildDateFilter[collection, start, end]]

GEEFilterBounds[collection_Association,
    bbox : {_?NumericQ, _?NumericQ, _?NumericQ, _?NumericQ}] :=
  buildSpatialFilter[collection, bbox]

GEEFilterBounds[bbox : {_?NumericQ, _?NumericQ, _?NumericQ, _?NumericQ}] :=
  Function[collection, buildSpatialFilter[collection, bbox]]

GEEFilterBounds[collection_Association, region_] :=
  Module[{bbox},
    bbox = toBoundingBox[region];
    If[bbox === $Failed,
      Message[GEEFilterBounds::bboxfail, InputForm[region]];
      $Failed,
      buildSpatialFilter[collection, bbox]
    ]
  ]

GEEFilterBounds[region_] :=
  Module[{bbox},
    bbox = toBoundingBox[region];
    If[bbox === $Failed,
      Message[GEEFilterBounds::bboxfail, InputForm[region]];
      $Failed,
      Function[collection, buildSpatialFilter[collection, bbox]]
    ]
  ]

GEEFilterProperty[collection_Association, property_String,
    op_String, value_] :=
  Module[{filterName},
    filterName = Switch[op,
      "LessThan", "Filter.lessThan",
      "GreaterThan", "Filter.greaterThan",
      "Equals", "Filter.equals",
      "LessThanOrEquals", "Filter.lessThanOrEquals",
      "GreaterThanOrEquals", "Filter.greaterThanOrEquals",
      "NotEquals", "Filter.notEquals",
      _, "Filter.lessThan"
    ];
    <|"functionInvocationValue" -> <|
      "functionName" -> "Collection.filter",
      "arguments" -> <|
        "collection" -> collection,
        "filter" -> <|"functionInvocationValue" -> <|
          "functionName" -> filterName,
          "arguments" -> <|
            "leftField" -> <|"constantValue" -> property|>,
            "rightValue" -> <|"constantValue" -> value|>
          |>
        |>|>
      |>
    |>|>
  ]

GEEFilterProperty[property_String, op_String, value_] :=
  Function[collection,
    GEEFilterProperty[collection, property, op, value]]

GEEMosaic[collection_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.mosaic",
    "arguments" -> <|"collection" -> collection|>
  |>|>

GEEMedian[collection_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.reduce",
    "arguments" -> <|
      "collection" -> collection,
      "reducer" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Reducer.median",
        "arguments" -> <||>
      |>|>
    |>
  |>|>

GEEMean[collection_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.reduce",
    "arguments" -> <|
      "collection" -> collection,
      "reducer" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Reducer.mean",
        "arguments" -> <||>
      |>|>
    |>
  |>|>

mapSelectBands[collectionExpr_Association, bands_List] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Collection.map",
    "arguments" -> <|
      "collection" -> collectionExpr,
      "baseAlgorithm" -> <|"functionDefinitionValue" -> <|
        "argumentNames" -> {"_MAPPING_VAR_0_0"},
        "body" -> <|"functionInvocationValue" -> <|
          "functionName" -> "Image.select",
          "arguments" -> <|
            "input" -> <|"argumentReference" -> "_MAPPING_VAR_0_0"|>,
            "bandSelectors" -> <|"constantValue" -> bands|>
          |>
        |>|>
      |>|>
    |>
  |>|>

GEESelectBands[expr_Association, bands_List] :=
  Module[{fn},
    fn = Lookup[
      Lookup[expr, "functionInvocationValue", <||>],
      "functionName", ""];
    If[StringMatchQ[fn, "Collection.*" | "ImageCollection.load" |
        "ImageCollection.merge"],
      mapSelectBands[expr, bands],
      buildBandSelection[expr, bands]
    ]
  ]

GEESelectBands[bands_List] :=
  Function[expr, GEESelectBands[expr, bands]]

GEEVisualize[image_Association, visParams_Association] :=
  buildVisualization[image, visParams]

GEEVisualize[visParams_Association] :=
  Function[image, buildVisualization[image, visParams]]

GEESort[collection_Association, property_String, ascending_?BooleanQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Collection.limit",
    "arguments" -> <|
      "collection" -> collection,
      "limit" -> <|"constantValue" -> 10000|>,
      "key" -> <|"constantValue" -> property|>,
      "ascending" -> <|"constantValue" -> ascending|>
    |>
  |>|>

GEESort[collection_Association, property_String] :=
  GEESort[collection, property, True]

GEESort[property_String] :=
  Function[collection, GEESort[collection, property, True]]

GEESort[property_String, ascending_?BooleanQ] :=
  Function[collection, GEESort[collection, property, ascending]]

GEEFirst[collection_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Collection.first",
    "arguments" -> <|"collection" -> collection|>
  |>|>

GEELimit[collection_Association, n_Integer?Positive] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Collection.limit",
    "arguments" -> <|
      "collection" -> collection,
      "limit" -> <|"constantValue" -> n|>
    |>
  |>|>

GEELimit[n_Integer?Positive] :=
  Function[collection, GEELimit[collection, n]]

GEEFeatureCollection[assetId_String] :=
  buildFeatureCollectionExpression[assetId]

GEEReduceRegion[image_Association, geometry_Association,
    reducer_String, scale_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.reduceRegion",
    "arguments" -> <|
      "image" -> image,
      "reducer" -> <|"functionInvocationValue" -> <|
        "functionName" -> Switch[reducer,
          "mean", "Reducer.mean",
          "min", "Reducer.min",
          "max", "Reducer.max",
          "sum", "Reducer.sum",
          "first", "Reducer.first",
          "median", "Reducer.median",
          _, "Reducer." <> reducer
        ],
        "arguments" -> <||>
      |>|>,
      "geometry" -> geometry,
      "scale" -> <|"constantValue" -> scale|>,
      "bestEffort" -> <|"constantValue" -> True|>
    |>
  |>|>

GEEReduceRegion[geometry_Association, reducer_String, scale_?NumericQ] :=
  Function[image, GEEReduceRegion[image, geometry, reducer, scale]]

GEEGeometry[{lat_?NumericQ, lon_?NumericQ}] :=
  buildGeometryPoint[lat, lon]

GEEGeometry[{west_?NumericQ, south_?NumericQ, east_?NumericQ, north_?NumericQ}] :=
  buildGeometryRectangle[west, south, east, north]

(* --- Tier 1 expression builder helpers --- *)

wrapImageArg[x_Association] := x
wrapImageArg[x_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.constant",
    "arguments" -> <|"value" -> <|"constantValue" -> x|>|>
  |>|>

GEENormalizedDifference[image_Association, bands : {_String, _String}] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.normalizedDifference",
    "arguments" -> <|
      "input" -> image,
      "bandNames" -> <|"constantValue" -> bands|>
    |>
  |>|>

GEENormalizedDifference[bands : {_String, _String}] :=
  Function[image, GEENormalizedDifference[image, bands]]

GEEClip[image_Association, geometry_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.clip",
    "arguments" -> <|
      "input" -> image,
      "geometry" -> geometry
    |>
  |>|>

GEEClip[geometry_Association] :=
  Function[image, GEEClip[image, geometry]]

GEEUpdateMask[image_Association, mask_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.updateMask",
    "arguments" -> <|
      "image" -> image,
      "mask" -> mask
    |>
  |>|>

GEEUpdateMask[mask_Association] :=
  Function[image, GEEUpdateMask[image, mask]]

GEEUnmask[image_Association, value_] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.unmask",
    "arguments" -> <|
      "input" -> image,
      "value" -> wrapImageArg[value]
    |>
  |>|>

GEEUnmask[value_?NumericQ] :=
  Function[image, GEEUnmask[image, value]]

GEEUnmask[image_Association] :=
  GEEUnmask[image, 0]

GEESelfMask[image_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.selfMask",
    "arguments" -> <|"image" -> image|>
  |>|>

GEEAddBands[image_Association, other_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.addBands",
    "arguments" -> <|
      "dstImg" -> image,
      "srcImg" -> other
    |>
  |>|>

GEEAddBands[other_Association] :=
  Function[image, GEEAddBands[image, other]]

GEERename[image_Association, names_List] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.rename",
    "arguments" -> <|
      "input" -> image,
      "names" -> <|"constantValue" -> names|>
    |>
  |>|>

GEERename[names_List] :=
  Function[image, GEERename[image, names]]

GEEAdd[image_Association, other_] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.add",
    "arguments" -> <|
      "image1" -> image,
      "image2" -> wrapImageArg[other]
    |>
  |>|>

GEEAdd[other_] :=
  Function[image, GEEAdd[image, other]]

GEESubtract[image_Association, other_] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.subtract",
    "arguments" -> <|
      "image1" -> image,
      "image2" -> wrapImageArg[other]
    |>
  |>|>

GEESubtract[other_] :=
  Function[image, GEESubtract[image, other]]

GEEMultiply[image_Association, other_] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.multiply",
    "arguments" -> <|
      "image1" -> image,
      "image2" -> wrapImageArg[other]
    |>
  |>|>

GEEMultiply[other_] :=
  Function[image, GEEMultiply[image, other]]

GEEDivide[image_Association, other_] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.divide",
    "arguments" -> <|
      "image1" -> image,
      "image2" -> wrapImageArg[other]
    |>
  |>|>

GEEDivide[other_] :=
  Function[image, GEEDivide[image, other]]

GEEExpression[image_Association, expr_String, bindings_Association] :=
  Module[{bandExprs, parsed, toGEE, preparedExpr},
    bandExprs = Association @ KeyValueMap[
      #1 -> <|"functionInvocationValue" -> <|
        "functionName" -> "Image.select",
        "arguments" -> <|
          "input" -> image,
          "bandSelectors" -> <|"constantValue" -> {#2}|>
        |>
      |>|> &,
      bindings
    ];

    toGEE[Plus[a_, b__]] :=
      Module[{terms = {a, b}, positives, negatives, result},
        positives = Cases[terms, Except[Times[-1, _]]];
        negatives = Cases[terms, Times[-1, x_] :> x];
        result = If[positives =!= {},
          Fold[
            <|"functionInvocationValue" -> <|
              "functionName" -> "Image.add",
              "arguments" -> <|"image1" -> #1, "image2" -> #2|>
            |>|> &,
            toGEE[First[positives]], toGEE /@ Rest[positives]
          ],
          toGEE[0]
        ];
        Fold[
          <|"functionInvocationValue" -> <|
            "functionName" -> "Image.subtract",
            "arguments" -> <|"image1" -> #1, "image2" -> #2|>
          |>|> &,
          result, toGEE /@ negatives
        ]
      ];
    toGEE[Times[a_, b__]] :=
      Fold[
        <|"functionInvocationValue" -> <|
          "functionName" -> "Image.multiply",
          "arguments" -> <|"image1" -> #1, "image2" -> #2|>
        |>|> &,
        toGEE[a], toGEE /@ {b}
      ];
    toGEE[Power[a_, -1]] :=
      <|"functionInvocationValue" -> <|
        "functionName" -> "Image.divide",
        "arguments" -> <|"image1" -> wrapImageArg[1], "image2" -> toGEE[a]|>
      |>|>;
    toGEE[Power[a_, Rational[-1, n_]]] :=
      <|"functionInvocationValue" -> <|
        "functionName" -> "Image.divide",
        "arguments" -> <|
          "image1" -> wrapImageArg[1],
          "image2" -> toGEE[Power[a, Rational[1, n]]]
        |>
      |>|>;
    toGEE[Power[a_, b_]] :=
      <|"functionInvocationValue" -> <|
        "functionName" -> "Image.pow",
        "arguments" -> <|"image1" -> toGEE[a], "image2" -> toGEE[b]|>
      |>|>;
    toGEE[Rational[a_, b_]] := toGEE[N[a / b]];
    toGEE[n_?NumericQ] := wrapImageArg[n];
    toGEE[sym_Symbol] :=
      With[{name = SymbolName[sym]},
        If[KeyExistsQ[bandExprs, name],
          bandExprs[name],
          Message[GEEExpression::badvar, name]; $Failed
        ]
      ];
    toGEE[other_] := (
      Message[GEEExpression::badexpr, InputForm[other]]; $Failed
    );

    (* Preprocess: replace ** with ^ for Wolfram parsing *)
    preparedExpr = StringReplace[expr, "**" -> "^"];
    parsed = Quiet[ToExpression[preparedExpr, InputForm]];
    If[FailureQ[parsed] || parsed === Null,
      Message[GEEExpression::badexpr, expr]; $Failed,
      toGEE[parsed]
    ]
  ]

GEEExpression[expr_String, bindings_Association] :=
  Function[image, GEEExpression[image, expr, bindings]]

(* --- Tier 2 expression builder helpers --- *)

buildComparison[fnName_String][image_Association, other_] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> fnName,
    "arguments" -> <|
      "image1" -> image,
      "image2" -> wrapImageArg[other]
    |>
  |>|>

GEEGreaterThan[image_Association, other_] :=
  buildComparison["Image.gt"][image, other]

GEEGreaterThan[other_] :=
  Function[image, GEEGreaterThan[image, other]]

GEELessThan[image_Association, other_] :=
  buildComparison["Image.lt"][image, other]

GEELessThan[other_] :=
  Function[image, GEELessThan[image, other]]

GEEEquals[image_Association, other_] :=
  buildComparison["Image.eq"][image, other]

GEEEquals[other_] :=
  Function[image, GEEEquals[image, other]]

GEENotEquals[image_Association, other_] :=
  buildComparison["Image.neq"][image, other]

GEENotEquals[other_] :=
  Function[image, GEENotEquals[image, other]]

GEEAnd[image_Association, other_] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.and",
    "arguments" -> <|
      "image1" -> image,
      "image2" -> wrapImageArg[other]
    |>
  |>|>

GEEAnd[other_] :=
  Function[image, GEEAnd[image, other]]

GEEOr[image_Association, other_] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.or",
    "arguments" -> <|
      "image1" -> image,
      "image2" -> wrapImageArg[other]
    |>
  |>|>

GEEOr[other_] :=
  Function[image, GEEOr[image, other]]

GEENot[image_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.not",
    "arguments" -> <|"input" -> image|>
  |>|>

GEEWhere[image_Association, test_Association, value_] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.where",
    "arguments" -> <|
      "input" -> image,
      "test" -> test,
      "value" -> wrapImageArg[value]
    |>
  |>|>

GEEWhere[test_Association, value_] :=
  Function[image, GEEWhere[image, test, value]]

GEECollectionMap[collection_Association, func_] :=
  Module[{bodyExpr},
    bodyExpr = func[<|"argumentReference" -> "_MAPPING_VAR_0_0"|>];
    <|"functionInvocationValue" -> <|
      "functionName" -> "Collection.map",
      "arguments" -> <|
        "collection" -> collection,
        "baseAlgorithm" -> <|"functionDefinitionValue" -> <|
          "argumentNames" -> {"_MAPPING_VAR_0_0"},
          "body" -> bodyExpr
        |>|>
      |>
    |>|>
  ]

GEECollectionMap[func_] :=
  Function[collection, GEECollectionMap[collection, func]]

GEEQualityMosaic[collection_Association, qualityBand_String] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.qualityMosaic",
    "arguments" -> <|
      "collection" -> collection,
      "bandName" -> <|"constantValue" -> qualityBand|>
    |>
  |>|>

GEEQualityMosaic[qualityBand_String] :=
  Function[collection, GEEQualityMosaic[collection, qualityBand]]

GEEMerge[collection1_Association, collection2_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.merge",
    "arguments" -> <|
      "collection1" -> collection1,
      "collection2" -> collection2
    |>
  |>|>

GEEMerge[collection2_Association] :=
  Function[collection1, GEEMerge[collection1, collection2]]

GEECollectionMax[collection_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.reduce",
    "arguments" -> <|
      "collection" -> collection,
      "reducer" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Reducer.max",
        "arguments" -> <||>
      |>|>
    |>
  |>|>

GEECollectionMin[collection_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.reduce",
    "arguments" -> <|
      "collection" -> collection,
      "reducer" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Reducer.min",
        "arguments" -> <||>
      |>|>
    |>
  |>|>

GEECollectionSum[collection_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.reduce",
    "arguments" -> <|
      "collection" -> collection,
      "reducer" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Reducer.sum",
        "arguments" -> <||>
      |>|>
    |>
  |>|>

GEEToBands[collection_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.toBands",
    "arguments" -> <|"collection" -> collection|>
  |>|>

GEEReduceStdDev[collection_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.reduce",
    "arguments" -> <|
      "collection" -> collection,
      "reducer" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Reducer.stdDev",
        "arguments" -> <||>
      |>|>
    |>
  |>|>

GEEReduceCount[collection_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.reduce",
    "arguments" -> <|
      "collection" -> collection,
      "reducer" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Reducer.count",
        "arguments" -> <||>
      |>|>
    |>
  |>|>

GEEReducePercentile[collection_Association, percentiles_List] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "ImageCollection.reduce",
    "arguments" -> <|
      "collection" -> collection,
      "reducer" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Reducer.percentile",
        "arguments" -> <|
          "percentiles" -> <|"constantValue" -> percentiles|>
        |>
      |>|>
    |>
  |>|>

GEEReducePercentile[percentiles_List] :=
  Function[collection, GEEReducePercentile[collection, percentiles]]

(* --- Tier 3 expression builder helpers --- *)

(* Terrain, Projection, Resampling *)

GEETerrain[image_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Terrain",
    "arguments" -> <|
      "input" -> image
    |>
  |>|>

GEEReproject[image_Association, crs_String, scale_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.reproject",
    "arguments" -> <|
      "image" -> image,
      "crs" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Projection",
        "arguments" -> <|"crs" -> <|"constantValue" -> crs|>|>
      |>|>,
      "scale" -> <|"constantValue" -> scale|>
    |>
  |>|>

GEEReproject[crs_String, scale_?NumericQ] :=
  Function[image, GEEReproject[image, crs, scale]]

GEEResample[image_Association, method_String] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.resample",
    "arguments" -> <|
      "image" -> image,
      "mode" -> <|"constantValue" -> method|>
    |>
  |>|>

GEEResample[method_String] :=
  Function[image, GEEResample[image, method]]

(* Focal operations *)

buildFocal[fnName_String][image_Association, radius_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> fnName,
    "arguments" -> <|
      "image" -> image,
      "radius" -> <|"constantValue" -> radius|>,
      "units" -> <|"constantValue" -> "meters"|>
    |>
  |>|>

GEEFocalMean[image_Association, radius_?NumericQ] :=
  buildFocal["Image.focalMean"][image, radius]
GEEFocalMean[radius_?NumericQ] :=
  Function[image, GEEFocalMean[image, radius]]

GEEFocalMax[image_Association, radius_?NumericQ] :=
  buildFocal["Image.focalMax"][image, radius]
GEEFocalMax[radius_?NumericQ] :=
  Function[image, GEEFocalMax[image, radius]]

GEEFocalMin[image_Association, radius_?NumericQ] :=
  buildFocal["Image.focalMin"][image, radius]
GEEFocalMin[radius_?NumericQ] :=
  Function[image, GEEFocalMin[image, radius]]

GEEFocalMedian[image_Association, radius_?NumericQ] :=
  buildFocal["Image.focalMedian"][image, radius]
GEEFocalMedian[radius_?NumericQ] :=
  Function[image, GEEFocalMedian[image, radius]]

(* Convolution, Gradient, Entropy *)

GEEConvolve[image_Association, kernel_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.convolve",
    "arguments" -> <|
      "image" -> image,
      "kernel" -> kernel
    |>
  |>|>

GEEConvolve[kernel_Association] :=
  Function[image, GEEConvolve[image, kernel]]

GEEGradient[image_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.gradient",
    "arguments" -> <|
      "input" -> image
    |>
  |>|>

GEEEntropy[image_Association, radius_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.entropy",
    "arguments" -> <|
      "image" -> image,
      "kernel" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Kernel.circle",
        "arguments" -> <|
          "radius" -> <|"constantValue" -> radius|>,
          "units" -> <|"constantValue" -> "meters"|>
        |>
      |>|>
    |>
  |>|>

GEEEntropy[radius_?NumericQ] :=
  Function[image, GEEEntropy[image, radius]]

(* Pixel utilities *)

GEEPixelArea[] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.pixelArea",
    "arguments" -> <||>
  |>|>

GEEPixelLonLat[] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.pixelLonLat",
    "arguments" -> <||>
  |>|>

GEEConstant[value_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.constant",
    "arguments" -> <|
      "value" -> <|"constantValue" -> value|>
    |>
  |>|>

(* Advanced queries *)

GEEReduceRegions[image_Association, featureCollection_Association,
    reducer_String, scale_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.reduceRegions",
    "arguments" -> <|
      "image" -> image,
      "collection" -> featureCollection,
      "reducer" -> <|"functionInvocationValue" -> <|
        "functionName" -> "Reducer." <> reducer,
        "arguments" -> <||>
      |>|>,
      "scale" -> <|"constantValue" -> scale|>
    |>
  |>|>

GEEReduceRegions[featureCollection_Association, reducer_String,
    scale_?NumericQ] :=
  Function[image, GEEReduceRegions[image, featureCollection, reducer, scale]]

GEESample[image_Association, region_Association, scale_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.sample",
    "arguments" -> <|
      "image" -> image,
      "region" -> region,
      "scale" -> <|"constantValue" -> scale|>
    |>
  |>|>

GEESample[region_Association, scale_?NumericQ] :=
  Function[image, GEESample[image, region, scale]]

GEEReduceToVectors[image_Association, geometry_Association,
    scale_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.reduceToVectors",
    "arguments" -> <|
      "image" -> image,
      "geometry" -> geometry,
      "scale" -> <|"constantValue" -> scale|>
    |>
  |>|>

GEEReduceToVectors[geometry_Association, scale_?NumericQ] :=
  Function[image, GEEReduceToVectors[image, geometry, scale]]

(* Additional image math *)

GEEPow[image_Association, other_] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.pow",
    "arguments" -> <|
      "image1" -> image,
      "image2" -> wrapImageArg[other]
    |>
  |>|>

GEEPow[other_] := Function[image, GEEPow[image, other]]

GEEMod[image_Association, other_] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.mod",
    "arguments" -> <|
      "image1" -> image,
      "image2" -> wrapImageArg[other]
    |>
  |>|>

GEEMod[other_] := Function[image, GEEMod[image, other]]

buildUnaryImageOp[fnName_String][image_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> fnName,
    "arguments" -> <|
      "value" -> image
    |>
  |>|>

GEEAbs[image_Association] := buildUnaryImageOp["Image.abs"][image]
GEESqrt[image_Association] := buildUnaryImageOp["Image.sqrt"][image]
GEELog[image_Association] := buildUnaryImageOp["Image.log"][image]
GEELog10[image_Association] := buildUnaryImageOp["Image.log10"][image]
GEEExp[image_Association] := buildUnaryImageOp["Image.exp"][image]

(* Geometry builders *)

GEEPolygon[coordinates_List] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "GeometryConstructors.Polygon",
    "arguments" -> <|
      "coordinates" -> <|"constantValue" -> {coordinates}|>
    |>
  |>|>

GEELineString[geoPositions:{__GeoPosition}] :=
  GEELineString[{#[[1, 2]], #[[1, 1]]}& /@ geoPositions]

GEELineString[coordinates_List] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "GeometryConstructors.LineString",
    "arguments" -> <|
      "coordinates" -> <|"constantValue" -> coordinates|>
    |>
  |>|>

GEEBuffer[geometry_Association, distance_?NumericQ] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Geometry.buffer",
    "arguments" -> <|
      "geometry" -> geometry,
      "distance" -> <|"constantValue" -> distance|>
    |>
  |>|>

GEEBuffer[distance_?NumericQ] :=
  Function[geometry, GEEBuffer[geometry, distance]]

GEECentroid[geometry_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Geometry.centroid",
    "arguments" -> <|
      "geometry" -> geometry
    |>
  |>|>

GEEBounds[geometry_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Geometry.bounds",
    "arguments" -> <|
      "geometry" -> geometry
    |>
  |>|>

GEEArea[geometry_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Geometry.area",
    "arguments" -> <|
      "geometry" -> geometry
    |>
  |>|>

(* Property / Metadata *)

GEEGet[image_Association, property_String] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.get",
    "arguments" -> <|
      "object" -> image,
      "property" -> <|"constantValue" -> property|>
    |>
  |>|>

GEEGet[property_String] :=
  Function[image, GEEGet[image, property]]

GEESet[image_Association, properties_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.set",
    "arguments" -> Join[
      <|"object" -> image|>,
      Association[KeyValueMap[
        #1 -> <|"constantValue" -> #2|> &,
        properties
      ]]
    ]
  |>|>

GEESet[properties_Association] :=
  Function[image, GEESet[image, properties]]

GEEDate[image_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.date",
    "arguments" -> <|
      "image" -> image
    |>
  |>|>

GEECast[image_Association, bandTypes_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.cast",
    "arguments" -> <|
      "image" -> image,
      "bandTypes" -> <|"constantValue" -> bandTypes|>
    |>
  |>|>

GEECast[bandTypes_Association] :=
  Function[image, GEECast[image, bandTypes]]

GEEToFloat[image_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.toFloat",
    "arguments" -> <|
      "value" -> image
    |>
  |>|>

GEEToInt[image_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Image.toInt",
    "arguments" -> <|
      "value" -> image
    |>
  |>|>

(* Joins *)

buildJoinFilter[condition_Association] :=
  condition

GEEJoinSimple[primary_Association, secondary_Association,
    condition_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Join.simple",
    "arguments" -> <|
      "primary" -> primary,
      "secondary" -> secondary,
      "condition" -> condition
    |>
  |>|>

GEEJoinInner[primary_Association, secondary_Association,
    condition_Association] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Join.inner",
    "arguments" -> <|
      "primary" -> primary,
      "secondary" -> secondary,
      "condition" -> condition
    |>
  |>|>

GEEJoinSaveBest[primary_Association, secondary_Association,
    condition_Association, propertyName_String] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Join.saveBest",
    "arguments" -> <|
      "primary" -> primary,
      "secondary" -> secondary,
      "condition" -> condition,
      "propertyName" -> <|"constantValue" -> propertyName|>
    |>
  |>|>

GEEJoinSaveBest[secondary_Association, condition_Association,
    propertyName_String] :=
  Function[primary, GEEJoinSaveBest[primary, secondary, condition, propertyName]]

GEEJoinSaveAll[primary_Association, secondary_Association,
    condition_Association, propertyName_String] :=
  <|"functionInvocationValue" -> <|
    "functionName" -> "Join.saveAll",
    "arguments" -> <|
      "primary" -> primary,
      "secondary" -> secondary,
      "condition" -> condition,
      "propertyName" -> <|"constantValue" -> propertyName|>
    |>
  |>|>

GEEJoinSaveAll[secondary_Association, condition_Association,
    propertyName_String] :=
  Function[primary, GEEJoinSaveAll[primary, secondary, condition, propertyName]]

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
  If[NameQ["Global`GEECollection"], Remove["Global`GEECollection"]];
  If[NameQ["Global`GEELoadImage"], Remove["Global`GEELoadImage"]];
  If[NameQ["Global`GEEFilterDate"], Remove["Global`GEEFilterDate"]];
  If[NameQ["Global`GEEFilterBounds"], Remove["Global`GEEFilterBounds"]];
  If[NameQ["Global`GEEFilterProperty"], Remove["Global`GEEFilterProperty"]];
  If[NameQ["Global`GEEMosaic"], Remove["Global`GEEMosaic"]];
  If[NameQ["Global`GEEMedian"], Remove["Global`GEEMedian"]];
  If[NameQ["Global`GEEMean"], Remove["Global`GEEMean"]];
  If[NameQ["Global`GEESelectBands"], Remove["Global`GEESelectBands"]];
  If[NameQ["Global`GEEVisualize"], Remove["Global`GEEVisualize"]];
  If[NameQ["Global`GEESort"], Remove["Global`GEESort"]];
  If[NameQ["Global`GEEFirst"], Remove["Global`GEEFirst"]];
  If[NameQ["Global`GEELimit"], Remove["Global`GEELimit"]];
  If[NameQ["Global`GEEFeatureCollection"], Remove["Global`GEEFeatureCollection"]];
  If[NameQ["Global`GEEReduceRegion"], Remove["Global`GEEReduceRegion"]];
  If[NameQ["Global`GEEGeometry"], Remove["Global`GEEGeometry"]];
  If[NameQ["Global`GEENormalizedDifference"], Remove["Global`GEENormalizedDifference"]];
  If[NameQ["Global`GEEClip"], Remove["Global`GEEClip"]];
  If[NameQ["Global`GEEUpdateMask"], Remove["Global`GEEUpdateMask"]];
  If[NameQ["Global`GEEUnmask"], Remove["Global`GEEUnmask"]];
  If[NameQ["Global`GEESelfMask"], Remove["Global`GEESelfMask"]];
  If[NameQ["Global`GEEAddBands"], Remove["Global`GEEAddBands"]];
  If[NameQ["Global`GEERename"], Remove["Global`GEERename"]];
  If[NameQ["Global`GEEAdd"], Remove["Global`GEEAdd"]];
  If[NameQ["Global`GEESubtract"], Remove["Global`GEESubtract"]];
  If[NameQ["Global`GEEMultiply"], Remove["Global`GEEMultiply"]];
  If[NameQ["Global`GEEDivide"], Remove["Global`GEEDivide"]];
  If[NameQ["Global`GEEExpression"], Remove["Global`GEEExpression"]];
  If[NameQ["Global`GEEGreaterThan"], Remove["Global`GEEGreaterThan"]];
  If[NameQ["Global`GEELessThan"], Remove["Global`GEELessThan"]];
  If[NameQ["Global`GEEEquals"], Remove["Global`GEEEquals"]];
  If[NameQ["Global`GEENotEquals"], Remove["Global`GEENotEquals"]];
  If[NameQ["Global`GEEAnd"], Remove["Global`GEEAnd"]];
  If[NameQ["Global`GEEOr"], Remove["Global`GEEOr"]];
  If[NameQ["Global`GEENot"], Remove["Global`GEENot"]];
  If[NameQ["Global`GEEWhere"], Remove["Global`GEEWhere"]];
  If[NameQ["Global`GEECollectionMap"], Remove["Global`GEECollectionMap"]];
  If[NameQ["Global`GEEQualityMosaic"], Remove["Global`GEEQualityMosaic"]];
  If[NameQ["Global`GEEMerge"], Remove["Global`GEEMerge"]];
  If[NameQ["Global`GEECollectionMax"], Remove["Global`GEECollectionMax"]];
  If[NameQ["Global`GEECollectionMin"], Remove["Global`GEECollectionMin"]];
  If[NameQ["Global`GEECollectionSum"], Remove["Global`GEECollectionSum"]];
  If[NameQ["Global`GEEToBands"], Remove["Global`GEEToBands"]];
  If[NameQ["Global`GEEReduceStdDev"], Remove["Global`GEEReduceStdDev"]];
  If[NameQ["Global`GEEReduceCount"], Remove["Global`GEEReduceCount"]];
  If[NameQ["Global`GEEReducePercentile"], Remove["Global`GEEReducePercentile"]];
  If[NameQ["Global`GEETerrain"], Remove["Global`GEETerrain"]];
  If[NameQ["Global`GEEReproject"], Remove["Global`GEEReproject"]];
  If[NameQ["Global`GEEResample"], Remove["Global`GEEResample"]];
  If[NameQ["Global`GEEFocalMean"], Remove["Global`GEEFocalMean"]];
  If[NameQ["Global`GEEFocalMax"], Remove["Global`GEEFocalMax"]];
  If[NameQ["Global`GEEFocalMin"], Remove["Global`GEEFocalMin"]];
  If[NameQ["Global`GEEFocalMedian"], Remove["Global`GEEFocalMedian"]];
  If[NameQ["Global`GEEConvolve"], Remove["Global`GEEConvolve"]];
  If[NameQ["Global`GEEGradient"], Remove["Global`GEEGradient"]];
  If[NameQ["Global`GEEEntropy"], Remove["Global`GEEEntropy"]];
  If[NameQ["Global`GEEPixelArea"], Remove["Global`GEEPixelArea"]];
  If[NameQ["Global`GEEPixelLonLat"], Remove["Global`GEEPixelLonLat"]];
  If[NameQ["Global`GEEConstant"], Remove["Global`GEEConstant"]];
  If[NameQ["Global`GEEReduceRegions"], Remove["Global`GEEReduceRegions"]];
  If[NameQ["Global`GEESample"], Remove["Global`GEESample"]];
  If[NameQ["Global`GEEReduceToVectors"], Remove["Global`GEEReduceToVectors"]];
  If[NameQ["Global`GEEPow"], Remove["Global`GEEPow"]];
  If[NameQ["Global`GEEMod"], Remove["Global`GEEMod"]];
  If[NameQ["Global`GEEAbs"], Remove["Global`GEEAbs"]];
  If[NameQ["Global`GEESqrt"], Remove["Global`GEESqrt"]];
  If[NameQ["Global`GEELog"], Remove["Global`GEELog"]];
  If[NameQ["Global`GEELog10"], Remove["Global`GEELog10"]];
  If[NameQ["Global`GEEExp"], Remove["Global`GEEExp"]];
  If[NameQ["Global`GEEPolygon"], Remove["Global`GEEPolygon"]];
  If[NameQ["Global`GEELineString"], Remove["Global`GEELineString"]];
  If[NameQ["Global`GEEBuffer"], Remove["Global`GEEBuffer"]];
  If[NameQ["Global`GEECentroid"], Remove["Global`GEECentroid"]];
  If[NameQ["Global`GEEBounds"], Remove["Global`GEEBounds"]];
  If[NameQ["Global`GEEArea"], Remove["Global`GEEArea"]];
  If[NameQ["Global`GEEGet"], Remove["Global`GEEGet"]];
  If[NameQ["Global`GEESet"], Remove["Global`GEESet"]];
  If[NameQ["Global`GEEDate"], Remove["Global`GEEDate"]];
  If[NameQ["Global`GEECast"], Remove["Global`GEECast"]];
  If[NameQ["Global`GEEToFloat"], Remove["Global`GEEToFloat"]];
  If[NameQ["Global`GEEToInt"], Remove["Global`GEEToInt"]];
  If[NameQ["Global`GEEJoinSimple"], Remove["Global`GEEJoinSimple"]];
  If[NameQ["Global`GEEJoinInner"], Remove["Global`GEEJoinInner"]];
  If[NameQ["Global`GEEJoinSaveBest"], Remove["Global`GEEJoinSaveBest"]];
  If[NameQ["Global`GEEJoinSaveAll"], Remove["Global`GEEJoinSaveAll"]];
]
