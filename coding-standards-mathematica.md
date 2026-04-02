---
description: "Wolfram Language coding conventions and best practices. Active for **/*.wl, **/*.wls, **/*.m, **/*.nb files."
---

# Rule: Coding Standards — Wolfram Language

Companion to `clean-comments-mathematica.md` (comment standards) and `testing-mathematica.md` (testing standards). This file covers naming, package structure, error handling, functional programming patterns, performance, and scoping.

Minimum Wolfram Language version: **14.0+**.

---

## 1. Naming Conventions

| Construct | Convention | Example |
|-----------|-----------|---------|
| Public function (exported) | PascalCase | `ParseTimeline`, `LoadData` |
| Private function (in `` `Private` `` context) | camelCase | `parseHelper`, `validateInput` |
| Local variable (`Module`/`Block`/`With`) | camelCase | `result`, `tempData`, `idx` |
| Boolean predicate function | PascalCase ending with `Q` | `ValidInputQ`, `EmptyDataQ` |
| Option name | PascalCase | `MaxIterations`, `OutputFormat` |
| Package context | PascalCase with backtick | `` GoogleTimeline` `` |
| Package-level constant | PascalCase prefixed with `$` | `$DefaultTimeout`, `$MaxRetries` |
| Iterator / index variable | Short lowercase | `i`, `n`, `x` |
| Message tag | lowercase with no spaces | `invalidarg`, `filenotfound` |

```wolfram
(* bad -- lowercase public function, looks like a local variable *)
parseTimeline[data_] := ...

(* bad -- could shadow a built-in symbol *)
List[data_] := ...

(* good -- PascalCase, specific name, no conflict *)
ParseTimeline[data_Association] := ...

(* bad -- boolean predicate without Q suffix *)
IsValid[x_] := ...

(* good *)
ValidQ[x_] := ...

(* bad -- private function using PascalCase *)
ValidateInput[x_] := ...  (* inside Begin["`Private`"] *)

(* good -- camelCase for private *)
validateInput[x_] := ...
```

---

## 2. Package Structure

A standard `.wl` package file follows this structure:

```wolfram
(* ::Package:: *)

BeginPackage["GoogleTimeline`"]

(* --- Public symbol declarations with usage messages --- *)

ParseTimeline::usage = "ParseTimeline[data] parse a Google Timeline JSON \
association and return a structured Dataset."

FormatLocation::usage = "FormatLocation[entry] format a single location \
entry as a human-readable string."

(* --- Error message templates --- *)

ParseTimeline::invalidarg = "Expected an Association, got `1`.";

(* --- Begin private context --- *)

Begin["`Private`"]

(* --- Implementations --- *)

ParseTimeline[data_Association] :=
  Module[{entries},
    entries = data["timelineObjects"];
    Dataset[Map[extractEntry, entries]]
  ]

ParseTimeline[other___] := (
  Message[ParseTimeline::invalidarg, Head[other]];
  $Failed
)

FormatLocation[entry_Association] :=
  StringJoin[entry["name"], " (", ToString[entry["lat"]], ", ", ToString[entry["lng"]], ")"]

(* --- Private helpers --- *)

extractEntry[obj_Association] :=
  <|"timestamp" -> obj["startTime"], "location" -> obj["placeName"]|>

End[]

EndPackage[]
```

**Rules:**
- Declare all public symbols with usage messages between `BeginPackage` and `` Begin["`Private`"] ``.
- All implementation goes inside the Private context.
- Define error message templates alongside or immediately after usage messages.
- End with a `___` catch-all pattern that issues a `Message` and returns `$Failed`.
- Use `.wl` extension for new packages (not `.m`).

---

## 3. Paclet Structure (`PacletInfo.wl`)

For projects distributed as paclets, include a `PacletInfo.wl` in the project root.

```wolfram
PacletObject[<|
  "Name" -> "GoogleTimeline",
  "Version" -> "1.0.0",
  "WolframVersion" -> "14.0+",
  "Description" -> "Parse and analyze Google Timeline location data.",
  "Creator" -> "Author Name",
  "Extensions" -> {
    {"Kernel", "Root" -> "Kernel", "Context" -> "GoogleTimeline`"},
    {"Documentation", "Language" -> "English"}
  }
|>]
```

**Rules:**
- Version follows Semantic Versioning (`MAJOR.MINOR.PATCH`).
- `WolframVersion` specifies the minimum compatible version.
- Increment the version number with every release.
- Canonical directory layout:

```
GoogleTimeline/
  PacletInfo.wl
  Kernel/
    GoogleTimeline.wl       (* main package, or init that loads subpackages *)
  Tests/
    testInit.wl             (* shared test setup *)
    Core_test.wlt
  Documentation/
    English/
      ...
```

---

## 4. Scoping Constructs

| Construct | Scope type | Use when | Example |
|-----------|-----------|----------|---------|
| `Module[{vars}, body]` | Lexical | Default choice. Mutable local variables. | `Module[{x = 0}, x++; x]` |
| `With[{x = val}, body]` | Constants | Immutable local bindings. Inject values into held expressions. | `With[{n = 10}, Table[i^2, {i, n}]]` |
| `Block[{vars}, body]` | Dynamic | Temporarily override global values. | `Block[{$RecursionLimit = 50}, f[x]]` |

**Rules:**
- Default to `Module` for function-local variables.
- Use `With` when the value is computed once and never modified.
- Use `Block` only when you intentionally need dynamic scoping (temporary global overrides).
- Never use unscoped global variables in function definitions.

```wolfram
(* bad -- unscoped global assignment pollutes the namespace *)
result = computeValue[data];
processResult[result]

(* good -- Module keeps result local *)
Module[{result},
  result = computeValue[data];
  processResult[result]
]

(* bad -- Module used for a constant *)
Module[{n = 10}, Table[i^2, {i, n}]]

(* good -- With is more appropriate for constants *)
With[{n = 10}, Table[i^2, {i, n}]]

(* good -- Block for temporary global override *)
Block[{$TimeZone = 0},
  DateString[Now]
]
```

---

## 5. Pattern Matching and Definitions

**Rules:**
- Use specific patterns, not overly generic ones. `_Integer` is better than `_` when you expect an integer.
- Use multiple definitions for different argument types (method dispatch) instead of one big `If`/`Which`.
- Use `_?testQ` or `_?(condition &)` for conditional patterns.
- Always include a catch-all `___` definition for public functions that issues a `Message` and returns `$Failed`.
- Clear old definitions before redefining during development to avoid stale `DownValues`.

```wolfram
(* bad -- overly generic pattern, no type checking *)
ProcessEntry[x_] := ...

(* bad -- procedural dispatch inside a single definition *)
ProcessData[data_] :=
  If[ListQ[data], ..., If[AssociationQ[data], ..., ...]]

(* good -- separate definitions for each pattern *)
ProcessData[data_List] := Map[processSingle, data]
ProcessData[data_Association] := processSingle[data]
ProcessData[other___] := (
  Message[ProcessData::invalidarg, Head[other]];
  $Failed
)

(* good -- conditional pattern *)
PositiveSquareRoot[x_?Positive] := Sqrt[x]
PositiveSquareRoot[___] := (Message[PositiveSquareRoot::nonpositive]; $Failed)
```

---

## 6. Functional Programming Patterns

Prefer functional constructs over procedural loops. The Wolfram Language is designed for functional and rule-based programming — procedural code misses language strengths and is typically slower.

### Prefer

| Instead of | Use |
|-----------|-----|
| `Do[..., {i, n}]` with `AppendTo` | `Map[f, list]` or `Table[f[i], {i, n}]` |
| `For[i=1, i<=n, i++, ...]` | `Map`, `Table`, `FoldList`, `NestList` |
| `If[cond, collect]` inside loop | `Select[list, condQ]` or `Cases[list, pattern]` |
| `Do[..., {i, n}]` with accumulator | `Fold[f, init, list]` |
| Nested `Map` with index | `MapIndexed[f, list]` |

```wolfram
(* bad -- procedural loop with AppendTo *)
result = {};
Do[
  If[entry["type"] === "visit",
    AppendTo[result, entry["location"]]
  ],
  {entry, data}
]

(* good -- functional with Select *)
result = Select[data, #["type"] === "visit" &][All, "location"]

(* good -- using Cases with pattern *)
result = Cases[data, entry_ /; entry["type"] === "visit" :> entry["location"]]
```

### Pure functions

- Use `#` and `&` for short inline operations (one line or less).
- Use `Function[{args}, body]` for multi-argument or multi-line pure functions.
- Do not nest pure functions deeply — extract to named helpers.

```wolfram
(* bad -- deeply nested pure functions *)
Map[Function[x, Map[# + x &, list2]], list1]

(* good -- named helper *)
addToAll[x_] := Map[# + x &, list2]
Map[addToAll, list1]
```

### Pipeline style

Use `//` postfix notation for pipeline-style code that reads top-to-bottom.

```wolfram
(* good -- pipeline reads naturally *)
rawData //
  ImportJSON //
  Select[#["type"] === "visit" &] //
  Map[ExtractLocation] //
  SortBy[#["timestamp"] &]
```

---

## 7. Error Handling

| Mechanism | Use when | Introduced |
|-----------|----------|-----------|
| `Enclose` / `Confirm` | Default for structured error handling in functions | v12.2 |
| `Message` | User-facing warnings and errors | v1.0 |
| `Failure[...]` objects | Structured error data to return to callers | v10.3 |
| `$Failed` | Simple failure sentinel | v1.0 |
| `Throw` / `Catch` | Non-local exit; legacy exception handling | v1.0 |

**Rules:**
- Prefer `Enclose`/`Confirm` for new code.
- Use `Message` for all user-facing error reporting.
- Return `Failure[...]` or `$Failed` on error — never return `Null` silently.
- Define message templates for each error condition with `Symbol::tag = "template"`.

```wolfram
(* bad -- silent failure, returns Null *)
LoadData[path_String] :=
  Module[{data},
    data = Import[path, "RawJSON"];
    If[data === $Failed, Return[]];
    processData[data]
  ]

(* good -- Enclose/Confirm with Message *)
LoadData::filenotfound = "File `1` not found or unreadable.";
LoadData::invalidformat = "File `1` is not valid JSON.";

LoadData[path_String] := Enclose[
  Module[{raw},
    raw = ConfirmBy[
      Import[path, "RawJSON"],
      AssociationQ,
      Message[LoadData::invalidformat, path]
    ];
    processData[raw]
  ],
  Function[failure,
    Message[LoadData::filenotfound, path];
    failure
  ]
]
```

---

## 8. Performance

**Rules:**
- Prefer vectorized operations over element-by-element manipulation.
- Use packed arrays for large numerical data. Check with `Developer`PackedArrayQ`.
- Do not mix symbolic and numerical computation in tight loops — this prevents optimization.
- Avoid `AppendTo` in loops — use `Map`, `Table`, or `Reap`/`Sow`.
- Use `Association` for key-value lookups instead of searching lists.
- Use specific patterns in function definitions — generic patterns are slower to dispatch.

```wolfram
(* bad -- AppendTo in a loop, O(n^2) *)
result = {};
Do[AppendTo[result, f[x]], {x, largeList}]

(* good -- Map, O(n) *)
result = Map[f, largeList]

(* good -- Reap/Sow for conditional collection *)
result = Reap[
  Do[If[conditionQ[x], Sow[f[x]]], {x, largeList}]
][[2, 1]]

(* bad -- repeated list search *)
Do[
  pos = Position[data, x];
  ...,
  {x, queries}
]

(* good -- build an Association for O(1) lookup *)
lookup = AssociationThread[data -> Range[Length[data]]];
Map[lookup, queries]
```

---

## 9. File Types and When to Use Each

| Extension | Format | Use for |
|-----------|--------|---------|
| `.wl` | Wolfram Language (plain text) | Packages, modules — modern default |
| `.wls` | Wolfram Language Script | Command-line scripts with `#!/usr/bin/env wolframscript` |
| `.m` | Mathematica Package (legacy) | Legacy packages only; use `.wl` for new code |
| `.nb` | Notebook | Interactive exploration, prototyping, presentation |
| `.wlt` | Wolfram Language Test | Test files for `TestReport` |
| `PacletInfo.wl` | Paclet metadata | One per paclet root directory |

**Rules:**
- Use `.wl` for all new package files.
- Use `.wls` for scripts intended to be run from the command line.
- Use `.nb` for exploratory analysis and presentation — not for production logic.
- Keep production code in `.wl` files; reference or call it from notebooks.
- Use `.wlt` for all test files.

---

## 10. Option Handling

Use `OptionsPattern[]` and `OptionValue` for functions with options.

**Rules:**
- Define defaults with `Options[SymbolName] = {...}`.
- Use PascalCase for option names.
- Reuse built-in option names when semantically appropriate (`Method`, `MaxIterations`, `Verbose`).
- Accept options with `opts:OptionsPattern[]` as the last argument pattern.

```wolfram
Options[ProcessData] = {
  "OutputFormat" -> "Association",
  MaxIterations -> 100,
  Verbose -> False
};

ProcessData[data_Association, opts:OptionsPattern[]] :=
  Module[{fmt, maxIter, verbose},
    fmt = OptionValue["OutputFormat"];
    maxIter = OptionValue[MaxIterations];
    verbose = OptionValue[Verbose];
    If[verbose, Print["Processing with format: ", fmt]];
    (* ... *)
  ]

ProcessData[data_Association] := ProcessData[data, Sequence @@ Options[ProcessData]]
```

---

## 11. Anti-Patterns

| Anti-pattern | Example | Problem |
|-------------|---------|---------|
| Unscoped global assignment | `x = 5; f[x]` | Namespace pollution, unpredictable state |
| `AppendTo` in loop | `Do[AppendTo[res, ...], ...]` | O(n^2) performance |
| Overly generic pattern | `f[x_] := ...` when `f[x_Integer] := ...` suffices | No input validation, slower dispatch |
| Nested pure functions | `Map[Function[x, Map[# + x &, list2]], list1]` | Unreadable, error-prone with `#` slot confusion |
| Procedural when functional exists | `For[i=1, i<=n, i++, ...]` | Misses language strengths, typically slower |
| Silent failure (return `Null`) | Function returns nothing on error | Callers cannot detect errors |
| `$RecursionLimit = Infinity` | Global setting override | Stack overflow risk |
| Mixing symbolic and numeric | `Sin[x] + 0.5` inside a numerical loop | Prevents compilation and packed-array optimization |
| `Get` instead of `Needs` | `` Get["MyPackage`"] `` | Re-evaluates package on every call |
| Mutable state across definitions | Separate `Set` calls building up state | Fragile, order-dependent, hard to test |

---

## 12. Coding Standards Checklist

| Check | Action |
|-------|--------|
| Public symbols have usage messages? | Fix: add usage messages (see `clean-comments-mathematica.md`) |
| Definitions use specific patterns (not bare `_`)? | Fix: add type constraints (`_Association`, `_String`, etc.) |
| Functions use `Module`/`With`/`Block` for locals? | Fix: wrap in appropriate scoping construct |
| Options use `OptionsPattern[]` / `OptionValue`? | Fix: use standard option mechanism |
| Error cases return `$Failed` or `Failure`? | Fix: add error returns |
| Error messages defined with `::` syntax? | Fix: add message templates |
| No `AppendTo` in loops? | Fix: use `Map`, `Table`, or `Reap`/`Sow` |
| Package uses `BeginPackage` / `EndPackage`? | Fix: wrap in proper package structure |
| New files use `.wl` extension (not `.m`)? | Fix: rename to `.wl` |
| Boolean predicates end with `Q`? | Fix: rename |
| Public functions have catch-all `___` definition? | Fix: add catch-all with `Message` and `$Failed` |
| No unscoped global assignments in function bodies? | Fix: wrap in `Module` or `With` |

---

## 13. Reference

- [Wolfram Function Repository Style Guidelines](https://resources.wolframcloud.com/FunctionRepository/style-guidelines)
- [Package Development — Wolfram Documentation](https://reference.wolfram.com/language/guide/PackageDevelopment.html)
- [Creating Paclets — Wolfram Documentation](https://reference.wolfram.com/language/PacletTools/tutorial/CreatingPaclets.html)
- [Robustness and Error Handling — Wolfram Documentation](https://reference.wolfram.com/language/guide/RobustnessAndErrorHandling.html)
- [Modularity and the Naming of Things — Wolfram Documentation](https://reference.wolfram.com/language/tutorial/ModularityAndTheNamingOfThings.html)
- [Scoping Constructs — Wolfram Documentation](https://reference.wolfram.com/language/guide/ScopingConstructs.html)
- [Functional Programming — Wolfram Documentation](https://reference.wolfram.com/language/guide/FunctionalProgramming.html)
- [Some General Notations and Conventions](https://reference.wolfram.com/language/tutorial/SomeGeneralNotationsAndConventions.html)
