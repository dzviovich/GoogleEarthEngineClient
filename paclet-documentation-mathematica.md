---
description: "Wolfram Language paclet user documentation standards for Guide Pages and Symbol Reference Pages. Active for **/*.wl, **/*.wls, **/*.m, **/*.nb files."
---

# Rule: Paclet Documentation — Wolfram Language

Standards for authoring **user-facing paclet documentation** — Guide Pages and Symbol (Function) Reference Pages — using the Documentation Tools palette. This covers the notebooks that live in `Documentation/English/` and are built into the paclet's integrated help system.

This file is distinct from `clean-comments-mathematica.md` (code-level comments and usage messages) and `docs-update.md` (changelog and ADR workflow).

Minimum Wolfram Language version: **14.0+**.

---

## 1. Documentation Directory Layout

Every paclet with a `{"Documentation", "Language" -> "English"}` extension in `PacletInfo.wl` must follow this directory structure:

```
MyPaclet/
  PacletInfo.wl
  Kernel/
    MyPaclet.wl
  Documentation/
    English/
      Guides/
        MyPacletGuide.nb          (* guide page *)
      ReferencePages/
        Symbols/
          PublicFunction.nb       (* one per exported symbol *)
      Tutorials/
        GettingStarted.nb        (* tech notes / tutorials *)
```

**Rules:**
- One Guide Page per major functional area of the paclet. Small paclets need at least one.
- One Symbol Reference Page per exported (public) symbol.
- Tech Notes are optional but recommended for complex workflows.
- All documentation notebooks are authored using the **Documentation Tools** palette (`Palettes > Documentation Tools`), not created manually.
- Register the paclet with the palette via **Add Paclet...** before creating any pages.

---

## 2. Guide Pages

A guide page catalogs related functions within a paclet, provides short descriptions of each, and links to individual Symbol Reference Pages, Tech Notes, and related guides.

### 2a. Required sections (in order)

| # | Section | Purpose |
|---|---------|---------|
| 1 | **Title** | The guide page name (filled automatically on creation). |
| 2 | **Guide Abstract** | One to three sentences describing the scope of this guide. Begin with a noun phrase identifying the topic area. |
| 3 | **Function Listings** | Grouped lists of functions with one-line descriptions. |
| 4 | **Related Tech Notes** | Links to tutorial pages. |
| 5 | **Related Guides** | Links to other guide pages (within this paclet or built-in). |
| 6 | **Related Links** | Links to external resources (URLs, Wolfram Community posts, etc.). |
| 7 | **Keywords** | Comma-separated search terms (bottom of notebook, hidden cell group). |

### 2b. Guide Abstract rules

- Write in plain text (no code formatting).
- Describe **what the user can do** with the functions on this page, not implementation details.
- Do not repeat the guide title verbatim as the first sentence.

```
(* good — describes capability *)
Tools for importing, cleaning, and analyzing Google Timeline location
history data exported from Google Takeout.

(* bad — restates title *)
GoogleTimeline Guide. This is the guide page for the GoogleTimeline paclet.

(* bad — describes implementation *)
Functions implemented using Association manipulation and DateObject parsing.
```

### 2c. Function Listing rules

Functions appear in two formats, created via the palette:

| Format | Palette button | Use when |
|--------|---------------|----------|
| **1-Line Function Listing** | `1 Line Function Listing` | Primary functions deserving individual emphasis. One per cell. |
| **Inline Function Listing** | `Functions Inline Listing` | Secondary or closely related functions grouped on one line. |

**Rules:**
- Group functions by capability under descriptive subsection headers.
- Use the palette's **Delimiter** to separate groups within a section.
- Every listed function name must link to its Symbol Reference Page.
- Descriptions are short fragments (not full sentences), starting with a lowercase verb or noun.
- Use the palette formatting tools — do not hand-format function listing cells.

```
(* good — grouped by capability with fragment descriptions *)

Importing Data
  ParseTimeline       — parse Google Timeline JSON into a structured Dataset
  LoadTimelineFile    — import a JSON file and return the raw Association

Querying Locations
  LocationsByDate  DateRangeLocations  NearestLocation
    — filter, slice, and search location entries

(* bad — ungrouped flat list *)
  ParseTimeline — Parses data
  LocationsByDate — Gets locations by date
  LoadTimelineFile — Loads files
  NearestLocation — Finds nearest
```

### 2d. Cross-reference rules

- Add links using the palette's **Links** menu, not by hand-editing hyperlinks.
- **Tech Notes**: link to tutorials that explain workflows step-by-step.
- **Related Guides**: link to guides covering related topics.
- **Related Links**: link to external URLs (Wolfram Community, GitHub, papers).
- Every cross-reference appears in its own cell (not inline), except See Also.

### 2e. Keywords

- Lowercase, comma-separated.
- Include the paclet name, key concepts, and likely search terms.
- Keywords are case-insensitive and used by the Wolfram help search index.

```
google timeline, location history, google takeout, gps, geolocation
```

---

## 3. Symbol Reference Pages (Function Pages)

A Symbol Reference Page documents a single exported function. It is the primary user-facing reference for that symbol.

### 3a. Required sections (in order)

| # | Section | Required? | Purpose |
|---|---------|-----------|---------|
| 1 | **Usage** | Yes | Calling patterns with descriptions. |
| 2 | **Details and Options** | Yes (if function has options or non-trivial behavior) | Bullet-point behavioral notes, option tables. |
| 3 | **Examples** | Yes | Evaluated code demonstrating usage. |
| 3a | — Basic Examples | Yes | Core functionality, at least one per calling pattern. |
| 3b | — Scope | If applicable | Range of valid inputs, edge cases, type variations. |
| 3c | — Generalizations & Extensions | If applicable | Advanced or less common usage patterns. |
| 3d | — Applications | If applicable | Real-world use cases. |
| 3e | — Properties & Relations | If applicable | How this function relates to others; mathematical properties. |
| 3f | — Possible Issues | If applicable | Known gotchas, common mistakes, performance caveats. |
| 3g | — Neat Examples | Optional | Visually interesting or surprising demonstrations. |
| 4 | **See Also** | Yes | Inline-linked related symbols. |
| 5 | **Related Tech Notes** | If applicable | Links to tutorials. |
| 6 | **Related Guides** | Yes | Links to at least one guide page. |
| 7 | **Related Links** | If applicable | External URLs. |
| 8 | **Keywords** | Yes | Search index terms. |

### 3b. Usage section rules

The usage section sits in the tan-colored cell at the top of the notebook. Each calling pattern occupies its own line.

**Rules:**
- Format: `FunctionName[arg1, arg2, …]` followed by a description.
- Each usage line (pattern + text) must form a **complete sentence ending with a period**.
- Begin the description with an imperative verb: "Return", "Parse", "Convert", "Compute".
- Argument names must match the actual pattern variable names in the function definition.
- Use the palette's **Template Input** formatting for the function name (linked) and argument names (unlinked template text).
- Do not document options in the usage lines; put them in Details and Options.

```
(* good — imperative verb, complete sentence, period *)
ParseTimeline[data] parse a Google Timeline JSON association and return a structured Dataset.
ParseTimeline[data, fmt] parse using the specified output format fmt.

(* bad — third person *)
ParseTimeline[data] parses a Google Timeline JSON association.

(* bad — no period *)
ParseTimeline[data] parse a Google Timeline JSON association

(* bad — argument name mismatch with definition *)
ParseTimeline[input] parse a Google Timeline JSON association.
(* ...when the actual definition uses data_Association *)
```

### 3c. Details and Options section rules

This section appears directly below the usage cell. It contains:

1. **Behavioral notes** as a bulleted list.
2. **Option table** (if the function accepts options) as a three-column table with no header row.

**Behavioral notes rules:**
- Each bullet describes one specific behavior, constraint, or input type.
- State what the function does with different input types or structures.
- Mention relevant return types.
- Note any side effects or state changes.
- Reference related functions by linked name.

**Option table format:**

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Option name | Default value | Brief description |

```
(* good — option table *)
"OutputFormat"    "Association"    output format: "Association", "Dataset", or "List"
MaxIterations     100              maximum processing iterations
Verbose           False            print progress messages during evaluation

(* bad — no default value column *)
"OutputFormat"    output format
```

**Rules:**
- Option names that are strings use straight quotes (`"`), not curly quotes.
- One row per option.
- Rows containing only placeholder text (`XXXX`) are omitted by the build process.
- Use the palette's **Options Table** dialog to verify documented options match the function's actual `Options[...]`.

### 3d. Examples section rules

Examples are the most important part of a Symbol Reference Page. They are evaluated code cells with output, preceded by descriptive text.

**General rules for all example subsections:**
- Begin each example group with a short text cell ending in a colon.
- Each text description must be one sentence maximum.
- One concept per example — do not combine multiple features in a single example.
- Use the palette's **Insert Delimiter** to separate groups within a subsection.
- Use the palette's **Insert Text** to add descriptive captions.
- The **Examples Initialization** cell must contain the `Needs["MyPaclet`"]` statement.

**Basic Examples rules:**
- At least one example per calling pattern defined in the Usage section.
- Start with the simplest possible demonstration.
- Progress from simple to moderately complex.
- Show both the input and the evaluated output.

**Scope rules:**
- Demonstrate the range of valid input types (lists, associations, strings, etc.).
- Show behavior with edge cases (empty input, single element, large input).
- Group related scope examples with delimiters.

**Applications rules:**
- Show realistic, practical use cases.
- May combine the function with other functions in a pipeline.
- Brief context sentence explaining the real-world scenario.

**Properties & Relations rules:**
- Show equivalences with other functions or alternative approaches.
- Demonstrate mathematical or logical properties.
- Compare with built-in Wolfram Language functions where relevant.

**Possible Issues rules:**
- Document known gotchas and common mistakes.
- Show the wrong usage and explain why it fails or gives unexpected results.
- Include workarounds where they exist.

**Neat Examples rules:**
- Optional. Include only when there is a genuinely compelling visualization or surprising result.
- Do not force this section — omit it if there is nothing noteworthy.

```
(* good — basic example with text caption *)
Parse a simple timeline association:
  ParseTimeline[<|"timelineObjects" -> {<|"startTime" -> "2025-01-15", ...|>}|>]
  (* evaluated output shown below *)

(* good — scope example showing edge case *)
An empty timeline returns an empty Dataset:
  ParseTimeline[<|"timelineObjects" -> {}|>]
  Dataset[{}]

(* bad — no descriptive text *)
  ParseTimeline[data]
  (* output *)

(* bad — multiple concepts in one example *)
Parse and filter and sort the timeline:
  ParseTimeline[data] // Select[...] // SortBy[...]
```

### 3e. See Also rules

- List related function names as an inline listing (horizontal, comma-separated).
- Use the palette's **Inline Listing Toggle** to format and link the symbols.
- Include both functions from the same paclet and relevant built-in Wolfram Language functions.
- Order: most closely related first.

### 3f. Keywords

Same rules as Guide Page keywords (Section 2e).

---

## 4. Placeholder and Build Rules

The Documentation Tools palette generates notebooks with placeholder cells containing `XXXX`.

**Rules:**
- Placeholder cells are **automatically excluded** from the built documentation.
- Replace placeholders with real content or leave them as `XXXX` to omit the section.
- Never leave partially filled placeholders — either complete the content or leave the full `XXXX`.
- Table rows where every cell is `XXXX` are omitted from the build.
- Use the **Preview** button to verify the built output before finalizing.

---

## 5. Formatting Rules

### 5a. Text content

- Use plain text in description cells. No code formatting in prose.
- Use the palette's **Template Input** to format function names and parameter variables when referencing them in text.
- Use **Insert > Hyperlink** for external URLs in text cells.

### 5b. Code cells

- All example code must evaluate cleanly without errors.
- Include the `Needs["MyPaclet`"]` call in the Examples Initialization cell.
- Do not include `Print` statements in examples unless demonstrating `Verbose` behavior.
- Show complete input/output pairs — do not suppress output with `;` unless the output is irrelevant.

### 5c. Linking

- Create all cross-links using the palette's **Links** menu.
- Never hand-edit `ButtonBox` or `Hyperlink` expressions in the notebook.
- Link types available: Guide, Tech Note, Function, URL, System Symbol.
- Every function name mentioned outside its own page should be linked.

---

## 6. Content Quality Standards

### 6a. Writing style

| Aspect | Standard |
|--------|----------|
| Voice | Imperative for usage lines ("Return", "Parse"). Declarative for details ("The function returns..."). |
| Tense | Present tense throughout. |
| Person | No first or second person. Describe the function, not the user. |
| Jargon | Define domain-specific terms on first use or link to a Tech Note. |
| Length | Usage descriptions: one sentence. Detail bullets: one to two sentences. Example captions: one sentence fragment ending in a colon. |

### 6b. Completeness checklist — Guide Page

| Check | Required |
|-------|----------|
| Guide abstract describes the functional area? | Yes |
| Every exported symbol appears in a function listing? | Yes |
| Functions grouped by capability with subsection headers? | Yes |
| Every listed function links to its Symbol Reference Page? | Yes |
| At least one Related Guide link? | Yes (link to built-in guide if no other paclet guide exists) |
| Keywords populated? | Yes |
| Preview builds without errors? | Yes |

### 6c. Completeness checklist — Symbol Reference Page

| Check | Required |
|-------|----------|
| Usage line for every calling pattern? | Yes |
| Usage lines are complete sentences ending with periods? | Yes |
| Usage lines begin with imperative verbs? | Yes |
| Argument names match actual definition patterns? | Yes |
| Details and Options section present (if function has options)? | Yes |
| Option table has three columns (name, default, description)? | Yes |
| At least one Basic Example per calling pattern? | Yes |
| Examples Initialization contains `Needs` call? | Yes |
| Every example has a descriptive text caption? | Yes |
| All example code evaluates without errors? | Yes |
| See Also lists related functions? | Yes |
| At least one Related Guide link? | Yes |
| Keywords populated? | Yes |
| Preview builds without errors? | Yes |

---

## 7. Workflow

1. **Register the paclet** with the Documentation Tools palette via **Add Paclet...**.
2. **Create the Guide Page** first (palette `G` tab > New Guide Page).
3. **Create Symbol Reference Pages** for each exported symbol (palette `F` tab > New Function Page, or use **Generate Function Pages** to scaffold all at once from usage messages).
4. **Author content** following the section rules above.
5. **Link pages together**: Guide → Symbol Pages, Symbol Pages → Guide, Symbol Pages ↔ See Also.
6. **Preview** each page using the palette's Preview button.
7. **Build** the documentation with `PacletDocumentationBuild`.
8. **Verify** the built output by loading the paclet and accessing help via `?SymbolName`.

---

## 8. Anti-Patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| Hand-crafting documentation notebook cells | Breaks build process; wrong cell styles | Always use Documentation Tools palette |
| Usage line without a period | Inconsistent with Wolfram documentation standards | Add period |
| Usage line with third-person verb ("Returns") | Inconsistent with Wolfram style | Rewrite in imperative ("Return") |
| Example without a text caption | User cannot scan to understand what the example demonstrates | Add one-sentence caption ending in a colon |
| Multiple concepts per example | Harder to learn; harder to find specific behavior | Split into separate examples, one concept each |
| Guide page with flat, ungrouped function list | Does not help the user navigate | Group by capability with subsection headers |
| Missing `Needs` in Examples Initialization | Examples fail when opened independently | Add `Needs["MyPaclet`"]` |
| Suppressing example output with `;` | User cannot see what the function returns | Remove `;` and show the output |
| Hand-editing hyperlinks in notebook | Links break across paclet versions and builds | Use palette Links menu |
| Empty sections left as partially edited `XXXX` | Confuses build process; may render garbage | Complete the content or leave full `XXXX` to omit |
| No Possible Issues section when gotchas exist | Users hit known problems without warning | Document known issues with workarounds |
| Describing implementation in Guide Abstract | Users need capabilities, not internals | Describe what the user can do |

---

## 9. Reference

- [Authoring Guide Pages Using Documentation Tools](https://reference.wolfram.com/language/DocumentationTools/tutorial/AuthoringGuidePagesUsingDocumentationTools.html)
- [Authoring Symbol Pages Using Documentation Tools](https://reference.wolfram.com/language/DocumentationTools/tutorial/AuthoringSymbolPagesUsingDocumentationTools.html)
- [Create a New Guide Page](https://reference.wolfram.com/language/DocumentationTools/workflow/CreateANewGuidePage.html)
- [Documentation Tools Quick Start](https://reference.wolfram.com/language/DocumentationTools/tutorial/DocumentationToolsQuickStart)
- [Creating Paclets](https://reference.wolfram.com/language/PacletTools/tutorial/CreatingPaclets.html)
- [Wolfram Function Repository Style Guidelines](https://resources.wolframcloud.com/FunctionRepository/style-guidelines)
- [DocumentationTools Guide](https://reference.wolfram.com/language/DocumentationTools/guide/DocumentationTools.html)
