# List-of-Primitives Documentation Updates

Tracking doc for refreshing user-facing documentation after the kernel
fix that lets all bbox-driven entry points accept a `List` of geo
primitives (combined bounding box).

The kernel fix and unit tests are done. This file enumerates what's
left to update in the docs, file by file.

## Background

The kernel fix in `Kernel/GoogleEarthEngineClient.wl` (new private
helpers `safeGeoBBox` / `mergePrimitiveBBox`) makes the following
public functions reliably accept a `List` of geo primitives in their
region / `geoPrimitive` argument — the combined bounding box is used:

- `GEEComputePixels[region, ...]`
- `GEEImage[region, ...]`
- `GEEFilterBounds[region]`, `GEEFilterBounds[collection, region]`
- `GEEGeometry[geoPrimitive]`
- `GEEGeoBounds[geoPrimitive]`

(`GEEGeoGraphics[primitives, ...]` always took a list — its public
contract is unchanged.)

The `::usage` strings in the kernel package have been updated. Tests
covering the new behavior are in
`tests/GoogleEarthEngineClient_test.wlt` under the
`"List-of-primitive regions"` section.

## Canonical wording

To keep phrasing consistent across files, use one of these snippets
(adapt `—` ↔ `\[LongDash]` for `.md` ↔ `.nb`):

**Region-form bullet** (for `GEEComputePixels`, `GEEImage`,
`GEEFilterBounds`):

> *region* can be a `GeoPosition`, `GeoPath`, `GeoPolygon`, `GeoDisk`,
> `GeoCircle`, `Entity`, or any primitive accepted by
> `GeoBoundingBox`. A `List` of such primitives is also accepted —
> the combined bounding box is used.

**Bbox-of-primitive bullet** (for `GEEGeometry`, `GEEGeoBounds`):

> Accepts any geographic primitive (`Entity`, `GeoDisk`, `GeoCircle`,
> `GeoPolygon`, `GeoPath`, `Polygon`, `Line`, …) or a `List` of such
> primitives — the combined bounding box is returned.

## Files that need updating

### 1. `Documentation/English/ReferencePages/Symbols/GEEComputePixels.nb`

**What:** Notes cell (around lines 336–357) currently describes
`bbox`, `assetId`, and image-handling rules but never enumerates the
region types accepted by the `region`-form overload.

**Action:** Add a bullet at the top of the Notes cell, before the
existing `bbox` bullet:

> - *region* can be a `GeoPosition`, `GeoPath`, `GeoPolygon`,
>   `GeoDisk`, `GeoCircle`, `Entity`, or any primitive accepted by
>   `GeoBoundingBox`. A `List` of such primitives is also accepted
>   \[LongDash] the combined bounding box is used.

**Optional polish:** Usage cell (lines 240–262) is inconsistent — the
second template uses *primitives* ("uses the same primitives as
GeoGraphics"), the third uses *region*. Pick one and unify.

---

### 2. `Documentation/English/ReferencePages/Symbols/GEEImage.nb`

**What:** Line 708 currently reads:

```
" can be a GeoPosition, GeoPath, GeoPolygon, or list of geo elements.\n- ",
```

The phrase "list of geo elements" is vague and predates the explicit
list-merge support.

**Action:** Replace the string with:

```
" can be a GeoPosition, GeoPath, GeoPolygon, GeoDisk, GeoCircle, \
Entity, or any primitive accepted by GeoBoundingBox. A List of such \
primitives is also accepted \[LongDash] the combined bounding box \
is used.\n- ",
```

---

### 3. `Documentation/English/Tutorials/GEEExpressionBuilders.nb`

Two updates in this file.

#### 3a. `GEEGeometry` Subsection (around lines 1500–1530)

**What:** The DefinitionBox only shows the `{lat, lon}` and
`{west, south, east, north}` forms.

**Action:** Add the geo-primitive and list forms to the signatures
column:

```
GEEGeometry[{lat, lon}]
GEEGeometry[{west, south, east, north}]
GEEGeometry[geoPrimitive]
GEEGeometry[{geoPrimitive1, geoPrimitive2, ...}]
```

Update the description to:

> Create a GEE geometry expression. A 2-element list creates a point;
> a 4-element list creates a rectangle. A geographic primitive
> creates a rectangle from its bounding box. A `List` of primitives
> creates a rectangle from the combined bounding box.

Add an example beneath the existing one:

```wolfram
point = GEEGeometry[{30.25, -97.75}]
rect  = GEEGeometry[{-97.8, 30.2, -97.7, 30.3}]
country = GEEGeometry[Entity["Country", "France"]]
multi = GEEGeometry[{
  Entity["AdministrativeDivision", {"Georgia", "UnitedStates"}],
  Entity["AdministrativeDivision", {"Virginia", "UnitedStates"}]}]
```

#### 3b. New `GEEGeoBounds` subsection (currently absent)

**What:** `GEEGeoBounds` is exported by the package but has no
section in this tutorial.

**Action:** Add a new Subsection inside the "Geometry" section (right
after `GEEGeometry`), with the same DefinitionBox + example pattern
used elsewhere in the tutorial:

Signatures:

```
GEEGeoBounds[geoPrimitive]
GEEGeoBounds[{geoPrimitive1, geoPrimitive2, ...}]
```

Description:

> Return the bounding box of a Wolfram geographic primitive in
> `{west, south, east, north}` order \[LongDash] the format expected
> by `GEEComputePixels` and `GEEGeometry`. Accepts any region
> accepted by `GeoBounds` (`Entity`, `GeoPosition`, `GeoDisk`,
> `GeoCircle`, `GeoPolygon`, `GeoPath`, `Polygon`, `Line`, etc.) or a
> `List` of such primitives \[LongDash] the combined bounding box is
> returned.

Example:

```wolfram
GEEGeoBounds[Entity["AdministrativeDivision",
  {"Georgia", "UnitedStates"}]]
(* ⇒ {-85.6, 30.4, -80.9, 35.0} *)

GEEGeoBounds[{
  Entity["AdministrativeDivision", {"Georgia", "UnitedStates"}],
  Entity["AdministrativeDivision", {"Virginia", "UnitedStates"}]}]
(* ⇒ {-85.6, 30.4, -75.2, 39.5} *)
```

---

### 4. `docs/GEEImage-Reference.md`

**What:** Line 30:

```markdown
- `region` can be a `GeoPosition`, `GeoPath`, `GeoPolygon`, or list of geo elements.
```

**Action:** Replace with:

```markdown
- `region` can be a `GeoPosition`, `GeoPath`, `GeoPolygon`, `GeoDisk`,
  `GeoCircle`, `Entity`, or any primitive accepted by
  `GeoBoundingBox`. A list of such primitives is also accepted —
  the combined bounding box is used.
```

---

### 5. `docs/GEEExpressionBuilders-Reference.md`

#### 5a. `GEEGeometry` section (lines 307–321)

**Action:** Replace the entire `#### GEEGeometry` block with:

````markdown
#### GEEGeometry

```wolfram
GEEGeometry[{lat, lon}]
GEEGeometry[{west, south, east, north}]
GEEGeometry[geoPrimitive]
GEEGeometry[{geoPrimitive1, geoPrimitive2, ...}]
```

Create a GEE geometry expression:

- A 2-element list `{lat, lon}` creates a point.
- A 4-element list `{west, south, east, north}` creates a rectangle.
- A geographic primitive (`Entity`, `GeoDisk`, `GeoCircle`,
  `GeoPolygon`, `GeoPath`, `Polygon`, `Line`, etc.) creates a
  rectangle from its bounding box.
- A list of such primitives creates a rectangle from the combined
  bounding box.

```wolfram
point = GEEGeometry[{30.25, -97.75}]
rect  = GEEGeometry[{-97.8, 30.2, -97.7, 30.3}]
country = GEEGeometry[Entity["Country", "France"]]
multi = GEEGeometry[{
  Entity["AdministrativeDivision", {"Georgia", "UnitedStates"}],
  Entity["AdministrativeDivision", {"Virginia", "UnitedStates"}]}]
```
````

#### 5b. Add `GEEGeoBounds` section (currently missing)

**Action:** Insert immediately after the new `GEEGeometry` block, before
`### Statistics` (around line 323):

````markdown
#### GEEGeoBounds

```wolfram
GEEGeoBounds[geoPrimitive]
GEEGeoBounds[{geoPrimitive1, geoPrimitive2, ...}]
```

Return the bounding box of a Wolfram geographic primitive in
`{west, south, east, north}` order — the format expected by
`GEEComputePixels` and `GEEGeometry`. Accepts any region accepted by
`GeoBounds` (`Entity`, `GeoPosition`, `GeoDisk`, `GeoCircle`,
`GeoPolygon`, `GeoPath`, `Polygon`, `Line`, etc.) or a list of such
primitives — the combined bounding box is returned.

```wolfram
GEEGeoBounds[Entity["AdministrativeDivision",
  {"Georgia", "UnitedStates"}]]
(* ⇒ {-85.6, 30.4, -80.9, 35.0} *)

GEEGeoBounds[{
  Entity["AdministrativeDivision", {"Georgia", "UnitedStates"}],
  Entity["AdministrativeDivision", {"Virginia", "UnitedStates"}]}]
(* ⇒ {-85.6, 30.4, -75.2, 39.5} *)
```
````

---

### 6. (Optional) `Documentation/English/Guides/GoogleEarthEngineClientGuide.nb`

**What:** The top-level guide does not currently enumerate accepted
region types.

**Action:** Where region-driven functions are introduced, add a single
sentence:

> Region-driven functions (`GEEComputePixels`, `GEEImage`,
> `GEEFilterBounds`, `GEEGeometry`, `GEEGeoBounds`) accept a single
> geographic primitive or a `List` of primitives \[LongDash] the
> combined bounding box is used.

This is purely a discoverability nicety; skip if the guide is meant
to stay terse.

## Files already up to date (no action)

- `Kernel/GoogleEarthEngineClient.wl` — `::usage` strings refreshed
- `tests/GoogleEarthEngineClient_test.wlt` — `BeginTestSection["List-of-primitive regions"]` covers the public surface
- `Documentation/English/ReferencePages/Symbols/GEEGeographics.nb` — `primitives` already documented as a list
- `docs/GEEComputePixels-Reference.md` — line 26 already covers it
- `docs/GEEGeoGraphics-Reference.md` — covered
- `docs/GoogleEarthEngineClient-Cookbook.md` — high-level prose, no signature edit needed
- `docs/DocumentationSpec.md` — line 533 already mentions list of geo elements
- `docs/cookbook/chapter-04-terrain-geophysical.md` (and `.nb`)
- `docs/cookbook/chapter-08-advanced-techniques.md` (and `.nb`)
- `docs/cookbook/chapter-09-appendices.md` (and `.nb`)

## Practical notes

- For `.nb` files, prefer editing in the Mathematica front-end and
  saving — the boxed cell text in the file is generated by the FE,
  and line-level patches risk mismatched cell `ExpressionUUID`s.
- `docs/expression builders conversion.nb` is currently uncommitted
  and appears to be a working draft of the tutorial notebook; it
  already mentions list-of-primitives in places. If you merge that
  draft into `Documentation/English/Tutorials/GEEExpressionBuilders.nb`,
  items 3a/3b may end up partially or fully addressed.
- This tracker can be deleted once the listed updates are in.
