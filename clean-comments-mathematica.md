---
description: "Wolfram Language comment and documentation standards. Active for **/*.wl, **/*.wls, **/*.m, **/*.nb files."
---

# Rule: Clean Comments — Wolfram Language

Extends `clean-comments.md` with Wolfram Language-specific rules. When this file conflicts with the general rule, this file wins.

---

## 1. Block Comments `(* ... *)`

Block comments precede the code they describe, at the same indentation level.

**Rules:**
- Delimit with `(* ` and ` *)` (single space inside each delimiter).
- Multi-line block comments: opening `(*` on the first line, closing `*)` on the last, each intermediate line indented to align with the text.
- Wolfram Language supports nested comments: `(* outer (* inner *) outer *)`. Use nesting sparingly — primarily to temporarily disable code blocks that already contain comments.
- One blank line above a block comment (unless it is at the top of a block).

```wolfram
(* bad -- no spaces inside delimiters *)
(*check connection before retry*)

(* bad -- inconsistent spacing *)
(*  check connection before retry *)

(* good *)
(* Check the connection before retry. The Wolfram Cloud may return
   a timeout on the first attempt during cold starts. *)
If[!connectionAliveQ[conn],
  reconnect[conn]
]
```

---

## 2. Inline Comments

Inline comments appear on the same line as a statement, after the expression.

**Rules:**
- Format: `expr (* comment *)` with at least two spaces before `(*`.
- Use sparingly — only when the line is genuinely non-obvious.
- Never restate what the code does.

```wolfram
(* bad -- restates the code *)
x = x + 1  (* increment x *)

(* good -- explains why *)
x = x + 1  (* offset by 1; API expects 1-based index *)
```

---

## 3. Usage Messages

Usage messages are the Wolfram Language equivalent of docstrings. They are the primary documentation mechanism for public symbols, retrieved with `?SymbolName` and displayed in the front end.

### 3a. When to write a usage message

| Construct | Usage message required? |
|-----------|----------------------|
| Public function (exported via `BeginPackage`) | Yes |
| Public option symbol | Yes |
| Private function (inside `` Begin["`Private`"] ``) | No — only if non-obvious |
| Local variable inside `Module`/`Block`/`With` | No |
| Package-level constant (`$Name`) | Optional — only if exported |

### 3b. Syntax and format

Define usage messages between `BeginPackage` and `` Begin["`Private`"] ``.

**Rules:**
- Syntax: `SymbolName::usage = "SymbolName[args] description."`.
- Begin with the calling pattern showing argument names.
- Follow the calling pattern with an imperative verb phrase: "Return ...", "Parse ...", "Convert ...".
- End with a period.
- Argument names in the usage string must match the argument names in the definition patterns.
- For multiple calling patterns, separate with literal `\n` (newline) within the string.

```wolfram
(* bad -- missing calling pattern *)
ParseTimeline::usage = "Parse a Google Timeline JSON file."

(* bad -- third person instead of imperative *)
ParseTimeline::usage = "ParseTimeline[data] parses a Google Timeline association."

(* bad -- missing period *)
ParseTimeline::usage = "ParseTimeline[data] parse a Google Timeline association"

(* good *)
ParseTimeline::usage = "ParseTimeline[data] parse a Google Timeline JSON \
association and return a structured Dataset."

(* good -- multiple calling patterns *)
FormatLocation::usage = "FormatLocation[entry] format a single location \
entry as a human-readable string.\n\
FormatLocation[entry, fmt] format using the specified format string fmt."
```

### 3c. Message definitions

Error and warning messages use the same `::` mechanism. Define them alongside usage messages for public functions, or near the function definition for private functions.

```wolfram
(* good -- message templates defined near the function *)
LoadData::filenotfound = "File `1` not found or unreadable.";
LoadData::invalidformat = "File `1` is not valid JSON.";
```

---

## 4. Section Comments in Package Files

Package files sometimes use cell markers for structure:
`(* ::Section:: *)`, `(* ::Subsection:: *)`, `(* ::Text:: *)`.

**Rules:**
- In `.wl` and `.m` files, prefer clear function grouping over section banners. Let the package structure (`BeginPackage`, `Begin`, `End`, `EndPackage`) provide the top-level organization.
- In `.nb` files, use proper Section and Subsection cell styles instead of comment-based banners.
- Do not fake section headers with ASCII art.

```wolfram
(* bad -- ASCII art banner *)
(* ============================================================ *)
(* SECTION: Data Processing                                      *)
(* ============================================================ *)

(* acceptable in .wl -- cell marker for front-end rendering *)
(* ::Section:: *)
(* Data Processing *)

(* preferred in .wl -- let function grouping speak for itself *)
(* --- Data Processing --- *)
```

---

## 5. Notebook Text Cells (`*.nb` files)

**Rules:**
- In `.nb` files, use Text cells for prose documentation instead of code comments. Text cells support rich formatting, hyperlinks, and mathematical typesetting.
- Comments inside Code cells in notebooks follow the same `(* ... *)` rules as `.wl` files.
- Do not put lengthy documentation in code comments when a Text cell is more appropriate.

---

## 6. Wolfram Language-Specific Anti-Patterns to DELETE

### Usage messages that restate the function name

```wolfram
(* bad *)
ProcessData::usage = "ProcessData processes data."
```

### Redundant labels next to `End[]` and `EndPackage[]`

The code structure is already self-documenting. These comments rot when the package is reorganized.

```wolfram
(* bad *)
End[]  (* End Private Context *)
EndPackage[]  (* End MyPaclet Package *)

(* good -- no comment needed *)
End[]
EndPackage[]
```

### Commented-out `Print` statements from debugging

```wolfram
(* bad *)
(* Print["debug: data = ", data]; *)
result = ProcessData[data]
```

### Redundant comments restating `Needs` calls

```wolfram
(* bad *)
(* Load required packages *)
Needs["DatabaseLink`"]
Needs["GeneralUtilities`"]

(* good -- no comment needed; Needs is self-documenting *)
Needs["DatabaseLink`"]
Needs["GeneralUtilities`"]
```

### TODO/FIXME that should be in an issue tracker

```wolfram
(* bad *)
(* TODO: handle edge case where data is empty *)
```

### Changelog comments inside package files

```wolfram
(* bad *)
(* 2026-01-15: updated for new API format *)
(* 2025-11-02: initial implementation *)
```

---

## 7. Cleanup Checklist (Wolfram Language)

Apply _in addition to_ the checklist in `clean-comments.md`:

| Check | Action |
|-------|--------|
| Block comment missing space inside `(* *)`? | Fix: add spaces |
| Usage message missing calling pattern? | Fix: add `SymbolName[args]` pattern |
| Usage message missing period? | Fix: add period |
| Usage message uses third person ("Returns")? | Fix: rewrite in imperative ("Return") |
| Usage message restates the function name? | Delete and rewrite |
| Redundant comment next to `End[]` or `EndPackage[]`? | Delete |
| Redundant comment above `Needs` call? | Delete |
| Commented-out `Print` statement? | Delete |
| ASCII art section banner? | Delete (restructure code or use cell markers) |
| TODO/FIXME comment? | Delete (file a ticket if needed) |
| Changelog comment? | Delete |

---

## 8. Reference

- [Wolfram Function Repository Style Guidelines](https://resources.wolframcloud.com/FunctionRepository/style-guidelines)
- [Wolfram Language Specification Style Guide](https://wltools.github.io/LanguageSpec/Contributing/Style-Guide/)
- [Some General Notations and Conventions](https://reference.wolfram.com/language/tutorial/SomeGeneralNotationsAndConventions.html)
- [Package Development — Wolfram Documentation](https://reference.wolfram.com/language/guide/PackageDevelopment.html)
