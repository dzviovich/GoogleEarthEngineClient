---
description: "Real-world lessons from building Wolfram Language paclets. On-demand reference for paclet creation, documentation, and release."
---

# Skill: Paclet Build — Wolfram Language

Empirical lessons learned from building Wolfram paclets. Complements `coding-standards-mathematica.md` (Section 3: Paclet Structure) and `paclet-documentation-mathematica.md` (documentation authoring standards).

---

## 1. Paclet Directory Layout (Verified)

The canonical layout that `PacletDirectoryLoad` and `PacletDocumentationBuild` expect:

```
MyPaclet/
  PacletInfo.wl
  Kernel/
    MyPaclet.wl
  Tests/
    testInit.wl
    MyPaclet_test.wlt
    run_tests.wls
  Documentation/
    English/
      Guides/
        MyPacletGuide.nb
      ReferencePages/
        Symbols/
          PublicFunction.nb
          $PublicConstant.nb
```

**Key facts:**
- The package `.wl` file must live in `Kernel/`, not `src/`. PacletInfo.wl's `"Root" -> "Kernel"` points there.
- `Tests/` (capital T) is the convention. Register with `{"Test", "Root" -> "Tests"}` in PacletInfo.wl.
- Documentation notebooks must be created with the **Documentation Tools palette** — hand-crafting notebooks with raw `Cell`/`BoxData` expressions produces files that look broken in Mathematica and may not build correctly with `PacletDocumentationBuild`.

---

## 2. PacletInfo.wl Template

```wolfram
PacletObject[<|
  "Name" -> "MyPaclet",
  "Version" -> "1.0.0",
  "WolframVersion" -> "14.0+",
  "Description" -> "Short description of what the paclet does.",
  "Creator" -> "Author Name",
  "Extensions" -> {
    {"Kernel", "Root" -> "Kernel", "Context" -> "MyPaclet`"},
    {"Documentation", "Language" -> "English"},
    {"Test", "Root" -> "Tests"}
  }
|>]
```

**Rules:**
- `"Name"` must match the context root (e.g., `"GooglePlaces"` for context `GooglePlaces``).
- `"Context"` includes the trailing backtick inside the string: `"MyPaclet`"`.
- Version follows Semantic Versioning.

---

## 3. Documentation Workflow

**Recommended approach:** Write a content specification document (`docs/DocumentationSpec.md`) with the exact text for every section of each notebook, then create the notebooks interactively using the Documentation Tools palette.

**Why not programmatic generation?** Wolfram documentation notebooks require specific cell styles (`"Usage"`, `"Notes"`, `"ExampleText"`, `"3ColumnTableMod"`, etc.) from the `DocumentationTools`` stylesheet. While these can theoretically be constructed with `Notebook[{Cell[...]}]` expressions, the resulting notebooks:
- Often have wrong or missing formatting when opened in Mathematica
- Require complex `BoxData`/`RowBox` nesting for code examples
- Are fragile and hard to maintain
- May not build correctly with `PacletDocumentationBuild`

**Workflow:**
1. Register the paclet with Documentation Tools palette via **Add Paclet...**
2. Create the Guide Page first (palette G tab)
3. Create Symbol Reference Pages (palette F tab — use **Generate Function Pages** to scaffold from usage messages)
4. Fill in content from the spec document
5. Link pages together using the palette Links menu
6. Preview each page
7. Build with `PacletDocumentationBuild["MyPaclet"]`

---

## 4. Content Specification Format

When preparing content for manual palette entry, organize by notebook and section:

```markdown
## Symbol Page: FunctionName

### Usage
| Pattern | Description |
|---|---|
| `FunctionName[arg]` | Imperative verb description ending with period. |

### Details and Options
- Bullet points describing behavior.
- Option table: name, default, description.

### Examples
#### Basic Examples
Caption: `Short description ending in colon:`
Input code block
Expected output block

### See Also
Related functions

### Keywords
comma, separated, terms
```

This format maps directly to the Documentation Tools palette sections.

---

## 5. testInit.wl Path Resolution

When the package moves from `src/` to `Kernel/`, update `testInit.wl`:

```wolfram
(* Resolve Kernel/ directory relative to this file *)
With[{kernelDir = FileNameJoin[{DirectoryName[$InputFileName], "..", "Kernel"}]},
  If[!MemberQ[$Path, kernelDir],
    PrependTo[$Path, kernelDir]
  ]
]
```

**Key:** Use `$InputFileName` in `.wl` files (set by `Get`). Use `$TestFileName` in `.wlt` files (set by `TestReport`). Both resolve to the file's own path.

---

## 6. wolframscript Path Resolution Pitfalls

| Variable | Context | Returns |
|---|---|---|
| `$ScriptCommandLine[[1]]` | `wolframscript -file script.wls` | Path to `wolframscript.exe`, **NOT** the `.wls` file |
| `$ScriptCommandLine[[1]]` | `wolframscript -code "..."` | Path to `wolframscript.exe` |
| `Directory[]` | Any | Current working directory (reliable) |
| `$InputFileName` | Inside `Get["file.wl"]` | Path to the loaded `.wl` file |
| `$InputFileName` | Top-level wolframscript | Empty string `""` |
| `$TestFileName` | Inside `.wlt` during `TestReport` | Path to the `.wlt` file |

**Recommendation:** Use `Directory[]` for scripts that should run from the project root. Use `$InputFileName` for files loaded with `Get`. Never rely on `$ScriptCommandLine[[1]]` for the script's own path.

---

## 7. TestCreate Teardown Trap

All non-`TestCreate` code in a `.wlt` file runs at **load time** — before `TestReport` evaluates any test. `TestCreate` captures expressions without evaluating them.

**Consequence:** If teardown code `Remove`s symbols that appear inside `TestCreate`, those symbols become `Removed[symbolName]` and every test referencing them fails silently.

**Fix:** Do not `Remove` symbols in `.wlt` teardown. Only clean up temporary files. See `testing-mathematica.md` Section 7 for the full rule.

---

## 8. Verification Checklist

After building a paclet:

```bash
# 1. Verify paclet metadata parses
wolframscript -code "Print[PacletObject[File[Directory[]]][\"Name\"]]"

# 2. Verify package loads via paclet
wolframscript -code "PacletDirectoryLoad[Directory[]]; Needs[\"MyPaclet`\"]; Print[\"OK\"]"

# 3. Run tests
wolframscript -file Tests/run_tests.wls

# 4. Build documentation (in Mathematica or wolframscript with FrontEnd)
PacletDocumentationBuild["MyPaclet"]
```

---

## 9. Global Shadow Cleanup Pattern

When loading a package interactively (e.g., in a notebook), symbols may already exist in `Global`` before the package loads, creating shadow warnings. Add this block after `EndPackage[]`:

```wolfram
Quiet[
  If[NameQ["Global`MyFunction"], Remove["Global`MyFunction"]];
  If[NameQ["Global`$MyConstant"], Remove["Global`$MyConstant"]];
]
```

This is a defensive pattern for interactive use. It is not needed when the package is loaded via `Needs` in a fresh kernel.
