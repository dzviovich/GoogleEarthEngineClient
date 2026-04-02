---
description: "Wolfram Language testing standards (TestCreate / TestReport). Active for **/*.wlt files and Wolfram Language test code."
---

# Rule: Testing — Wolfram Language

Extends `clean-comments-mathematica.md` and `clean-comments.md`. All rules here apply to any `.wlt` file and any `.wl` file whose primary purpose is testing.

Minimum Wolfram Language version: **14.0+**.

---

## 1. File Naming and Organization

| Target | Pattern | Example |
|--------|---------|---------|
| Test files | `*_test.wlt` | `Core_test.wlt`, `Utilities_test.wlt` |
| Test helper / setup | `testInit.wl` | `Tests/testInit.wl` |
| Package under test | `*.wl` | `Kernel/GoogleTimeline.wl` |

Canonical project layout:

```
GoogleTimeline/
  PacletInfo.wl
  Kernel/
    GoogleTimeline.wl
  Tests/
    testInit.wl             (* shared setup: Needs, helper functions *)
    Core_test.wlt
    Utilities_test.wlt
  Documentation/
    ...
```

**Rules:**
- Place all test files in a `Tests/` directory.
- Use `_test.wlt` suffix for test files.
- Use a shared `testInit.wl` for common setup (loading packages, defining test helpers).

---

## 2. Test Discovery and Execution

- `TestReport["Tests/Core_test.wlt"]` evaluates the file and runs all tests.
- `TestReport[FileNames["*_test.wlt", "Tests/"]]` runs all test files in the directory.
- `TestReport` only runs tests with outcome `"NotEvaluated"` — already-evaluated tests are skipped.

```wolfram
(* Run a single test file *)
report = TestReport["Tests/Core_test.wlt"]

(* Run all test files *)
report = TestReport[FileNames["*_test.wlt", "Tests/"]]

(* From the command line *)
(* wolframscript -code 'TestReport["Tests/Core_test.wlt"]' *)
```

---

## 3. `TestCreate` vs `VerificationTest`

| Context | Recommended function | Reason |
|---------|---------------------|--------|
| `.wlt` test file | `TestCreate` | Defers evaluation; enables selective execution |
| Interactive notebook exploration | `VerificationTest` | Evaluates immediately; good for quick checks |
| CI/CD pipeline test suite | `TestCreate` (via `TestReport`) | Reproducible, automated runs |

**Rules:**
- Prefer `TestCreate` in `.wlt` test files. `TestCreate` separates creation from evaluation — symbols are not evaluated at creation time, which allows `TestReport` to manage execution.
- Use `VerificationTest` only for quick, interactive smoke tests in notebooks.

```wolfram
(* bad -- VerificationTest evaluates immediately in .wlt files *)
VerificationTest[AddOne[1], 2, TestID -> "AddOne-basic"]

(* good -- TestCreate defers evaluation *)
TestCreate[AddOne[1], 2, TestID -> "AddOne-basic"]
```

---

## 4. Test Identification (`TestID`)

Every test must have a meaningful `TestID`. Without one, failure reports are unreadable.

**Convention:** `"Context-Function-Description"`

```wolfram
(* bad -- auto-generated or meaningless ID *)
TestCreate[AddOne[1], 2]
TestCreate[AddOne[1], 2, TestID -> "test1"]

(* good -- descriptive, unique ID *)
TestCreate[AddOne[1], 2, TestID -> "GoogleTimeline-AddOne-positive-integer"]
TestCreate[AddOne[0], 1, TestID -> "GoogleTimeline-AddOne-zero"]
TestCreate[AddOne[-5], -4, TestID -> "GoogleTimeline-AddOne-negative"]
```

**Rules:**
- TestIDs must be unique within a test file.
- Use the pattern `"PackageName-FunctionName-description"`.
- Use hyphens to separate parts, lowercase description words.

---

## 5. Assertions and Expected Outcomes

### Exact match (default)

The simplest form — test that `input` evaluates to `expected`:

```wolfram
TestCreate[AddOne[1], 2, TestID -> "AddOne-basic"]
TestCreate[Reverse[{1, 2, 3}], {3, 2, 1}, TestID -> "Reverse-list"]
```

### Custom comparison with `SameTest`

Use `SameTest` when exact equality is not appropriate:

```wolfram
(* Match by pattern *)
TestCreate[
  ParseEntry[rawData],
  _Association,
  SameTest -> MatchQ,
  TestID -> "ParseEntry-returns-association"
]

(* Custom predicate *)
TestCreate[
  ComputeResult[input],
  expectedOutput,
  SameTest -> (Abs[#1 - #2] < 0.001 &),
  TestID -> "ComputeResult-within-tolerance"
]
```

### Testing boolean outcomes

```wolfram
TestCreate[ValidInputQ[goodData], True, TestID -> "ValidInputQ-good-data"]
TestCreate[ValidInputQ[badData], False, TestID -> "ValidInputQ-bad-data"]
```

---

## 6. `IntermediateTest` for Multi-Step Operations

Use `IntermediateTest` to verify preconditions within a larger test. If any intermediate test fails, the outer test fails.

```wolfram
TestCreate[
  Module[{data, processed},
    data = LoadData["sample.json"];
    IntermediateTest[data =!= $Failed, TestID -> "Pipeline-load-step"];
    processed = TransformData[data];
    IntermediateTest[Length[processed] > 0, TestID -> "Pipeline-transform-step"];
    AnalyzeData[processed]
  ],
  _Association,
  SameTest -> MatchQ,
  TestID -> "Pipeline-full-integration"
]
```

**Rules:**
- Use `IntermediateTest` to keep multi-step procedures verifiable without splitting into many tiny tests.
- Each `IntermediateTest` should have its own `TestID` for clear failure identification.
- Reserve for integration-style tests; prefer separate `TestCreate` calls for unit tests.

---

## 7. Test Setup and Teardown

### Setup

All code outside `TestCreate` in a `.wlt` file runs every time the file is loaded. Place setup code at the top.

```wolfram
(* --- Setup --- *)
Needs["GoogleTimeline`"]

(* Test data *)
sampleEntry = <|"type" -> "visit", "name" -> "Home", "lat" -> 40.7, "lng" -> -74.0|>;
sampleData = {sampleEntry};
```

### Shared setup across test files

Use a `testInit.wl` file loaded by each test file:

```wolfram
(* Tests/testInit.wl *)
Needs["GoogleTimeline`"]

$TestDataDir = FileNameJoin[{DirectoryName[$InputFileName], "data"}];

loadTestFixture[name_String] :=
  Import[FileNameJoin[{$TestDataDir, name}], "RawJSON"]
```

```wolfram
(* Tests/Core_test.wlt *)
Get[FileNameJoin[{DirectoryName[$TestFileName], "testInit.wl"}]]

TestCreate[
  ParseTimeline[loadTestFixture["sample.json"]],
  _Dataset,
  SameTest -> MatchQ,
  TestID -> "ParseTimeline-sample-data"
]
```

### Teardown

Place cleanup code at the bottom of the test file. Clean up temporary files and directories.

```wolfram
(* --- Teardown --- *)
If[FileExistsQ[$tempFile], DeleteFile[$tempFile]];
```

**Critical: `TestCreate` teardown timing.** All code outside `TestCreate` in a `.wlt` file — including teardown — runs when the file is **loaded**, not when tests are **evaluated**. `TestCreate` captures expressions without evaluating them; `TestReport` evaluates them later. If teardown `Remove`s symbols that appear inside `TestCreate` expressions, those symbols become `Removed[symbolName]` before any test runs, causing every test that references them to fail.

```wolfram
(* BAD — Remove runs at load time, destroying symbols before TestReport evaluates tests *)
$TestData = {1, 2, 3};
TestCreate[Length[$TestData], 3, TestID -> "count"]
Remove[$TestData]  (* $TestData becomes Removed[$TestData] — test fails *)

(* GOOD — do not Remove symbols referenced inside TestCreate expressions *)
If[FileExistsQ[$tempFile], DeleteFile[$tempFile]];
(* $TestData persists until TestReport finishes — test passes *)
```

**Rules:**
- Never `Remove` symbols that appear inside `TestCreate` input, expected output, or `SameTest` expressions.
- `Remove` is safe only for symbols used exclusively in setup code that are not captured by any `TestCreate`.
- Temporary files and directories may be cleaned up in teardown since file I/O is immediate.

---

## 8. Test File Structure

Canonical `.wlt` template:

```wolfram
(* GoogleTimeline Core tests *)

(* --- Setup --- *)
Get[FileNameJoin[{DirectoryName[$TestFileName], "testInit.wl"}]]

(* ---- ParseTimeline tests ---- *)

TestCreate[
  ParseTimeline[<|"timelineObjects" -> {}|>],
  _Dataset,
  SameTest -> MatchQ,
  TestID -> "GoogleTimeline-ParseTimeline-empty-data"
]

TestCreate[
  ParseTimeline[loadTestFixture["sample.json"]],
  _Dataset,
  SameTest -> MatchQ,
  TestID -> "GoogleTimeline-ParseTimeline-sample-data"
]

TestCreate[
  ParseTimeline["not an association"],
  $Failed,
  TestID -> "GoogleTimeline-ParseTimeline-invalid-input"
]

(* ---- FormatLocation tests ---- *)

TestCreate[
  FormatLocation[<|"name" -> "Home", "lat" -> 40.7, "lng" -> -74.0|>],
  "Home (40.7, -74.)",
  TestID -> "GoogleTimeline-FormatLocation-basic"
]

(* --- Teardown --- *)
```

**Rules:**
- Group tests by function, separated by comment headers.
- Setup at top, teardown at bottom.
- Every `TestCreate` has a `TestID`.

---

## 9. Running Tests with `TestReport`

### Basic usage

```wolfram
report = TestReport["Tests/Core_test.wlt"]
```

### Inspecting results

```wolfram
(* Summary counts *)
report["TestsSucceededCount"]
report["TestsFailedCount"]
report["TestsFailedWithMessagesCount"]
report["TestsFailedWithErrorsCount"]

(* Get failed test details *)
report["TestsFailed"]

(* Get a specific test result by TestID *)
report["TestResults"]["GoogleTimeline-ParseTimeline-empty-data"]

(* All test results as a Dataset *)
report["TestResultsDataset"]
```

### CI/CD integration

Exit with non-zero status on failure:

```wolfram
(* Tests/run_tests.wls *)
#!/usr/bin/env wolframscript

report = TestReport[FileNames["*_test.wlt", FileNameJoin[{DirectoryName[$ScriptCommandLine[[1]]], "Tests"}]]];

Print["Tests passed: ", report["TestsSucceededCount"]];
Print["Tests failed: ", report["TestsFailedCount"]];

If[report["TestsFailedCount"] > 0,
  Print["\nFailed tests:"];
  Scan[Print["  ", #["TestID"], ": ", #["Outcome"]] &, Values[report["TestsFailed"]]];
  Exit[1],
  Exit[0]
]
```

---

## 10. Numerical Testing and Tolerances

Never use exact comparison for floating-point results.

```wolfram
(* bad -- exact comparison may fail due to floating-point *)
TestCreate[Sin[Pi], 0, TestID -> "Sin-Pi-exact"]

(* good -- SameTest with tolerance *)
TestCreate[
  Sin[Pi],
  0,
  SameTest -> (Abs[#1 - #2] < 10^-10 &),
  TestID -> "Sin-Pi-tolerance"
]

(* good -- Chop for near-zero results *)
TestCreate[
  Chop[Sin[Pi]],
  0,
  TestID -> "Sin-Pi-chop"
]

(* good -- relative tolerance for larger values *)
TestCreate[
  ComputeArea[params],
  expectedArea,
  SameTest -> (Abs[#1 - #2] / Max[Abs[#2], 1] < 10^-6 &),
  TestID -> "ComputeArea-relative-tolerance"
]
```

**Rules:**
- Use `SameTest` with an absolute or relative tolerance function for all numerical comparisons.
- Use `Chop` only for results expected to be near zero.
- Document the tolerance rationale in a comment if the tolerance is unusually large or small.

---

## 11. Testing Error Handling

### Testing `$Failed` returns

```wolfram
TestCreate[
  LoadData["nonexistent.json"],
  $Failed,
  TestID -> "LoadData-missing-file-returns-Failed"
]
```

### Testing that a function generates a message

Use the `ExpectedMessages` option:

```wolfram
TestCreate[
  LoadData["nonexistent.json"],
  $Failed,
  {HoldForm[LoadData::filenotfound]},
  TestID -> "LoadData-missing-file-emits-message"
]
```

### Testing `Failure` objects

```wolfram
TestCreate[
  SafeDivide[1, 0],
  _Failure,
  SameTest -> MatchQ,
  TestID -> "SafeDivide-zero-divisor-returns-Failure"
]
```

---

## 12. Test Isolation

Every test must pass in any order and in isolation.

| Concern | Correct approach |
|---------|-----------------|
| Global symbol pollution | Use `Remove` in teardown or test in fresh kernel |
| File system artifacts | Create temp files with `CreateFile`/`CreateDirectory`; clean up in teardown |
| Network calls | Mock with custom definitions or use recorded test fixtures |
| Random results | Seed with `SeedRandom[42]` before the test |
| Order dependence | Each test must be independently runnable |
| Loaded packages | Use `Needs` (idempotent), not `Get` (re-evaluates) |
| Time-dependent logic | Use `TimeObject` / `DateObject` with fixed values in test data |

```wolfram
(* bad -- test depends on state from previous test *)
(* Test 1 *)
TestCreate[(globalData = LoadData["file.json"]; Length[globalData]), 10,
  TestID -> "Load-data"]
(* Test 2 -- depends on globalData from Test 1 *)
TestCreate[ProcessData[globalData], _Dataset, SameTest -> MatchQ,
  TestID -> "Process-data"]

(* good -- each test is self-contained *)
TestCreate[
  Module[{data = LoadData["file.json"]},
    Length[data]
  ],
  10,
  TestID -> "Load-data"
]
TestCreate[
  Module[{data = LoadData["file.json"]},
    ProcessData[data]
  ],
  _Dataset,
  SameTest -> MatchQ,
  TestID -> "Process-data"
]
```

---

## 13. Anti-Patterns to Avoid

| Anti-pattern | Problem |
|-------------|---------|
| Missing `TestID` | Auto-generated IDs make failure reports unreadable |
| Using `VerificationTest` in `.wlt` files | Evaluates immediately, preventing selective execution |
| Floating-point comparison without tolerance | Intermittent failures from rounding |
| Tests that depend on evaluation order | Fragile; fails when tests run in parallel or selectively |
| Overly broad `SameTest` (e.g., `(True &)`) | Always passes — useless as a test |
| Testing built-in functions | `TestCreate[Plus[1, 1], 2]` tests Wolfram, not your code |
| `Print` statements left in test files | Noise in test output |
| Duplicate `TestID` values | Only one result reported; silent test loss |
| Loading packages with `Get` instead of `Needs` | Re-evaluates package on each test file, causing symbol conflicts |
| Testing implementation, not behavior | Brittle tests that break on refactoring |
| `Remove` in teardown of symbols used in `TestCreate` | Symbols become `Removed[...]` before `TestReport` evaluates any test; all referencing tests fail |
| Using `$ScriptCommandLine[[1]]` for script path in `wolframscript` | Returns `wolframscript.exe` path, not the `.wls` file; use `Directory[]` or `$InputFileName` instead |

---

## 14. Cleanup Checklist (Wolfram Language Tests)

Apply _in addition to_ the checklists in `clean-comments-mathematica.md` and `clean-comments.md`:

| Check | Action |
|-------|--------|
| Test missing `TestID`? | Fix: add descriptive ID |
| Using `VerificationTest` in `.wlt` file? | Fix: convert to `TestCreate` |
| Floating-point comparison without tolerance? | Fix: add `SameTest` with tolerance function |
| Test depends on global state from another test? | Fix: make self-contained with `Module` |
| `Print` statements left in test file? | Delete |
| Duplicate `TestID` values? | Fix: make unique |
| Test file missing `Needs` for package under test? | Fix: add `Needs` at top or load `testInit.wl` |
| Test file missing teardown for temp files? | Fix: add cleanup at bottom |
| Testing a built-in function instead of project code? | Delete or rewrite to test project code |

---

## 15. Reference

- [Using the Testing Framework — Wolfram Documentation](https://reference.wolfram.com/language/tutorial/UsingTheTestingFramework.html)
- [TestCreate — Wolfram Documentation](https://reference.wolfram.com/language/ref/TestCreate.html)
- [TestReport — Wolfram Documentation](https://reference.wolfram.com/language/ref/TestReport.html)
- [VerificationTest — Wolfram Documentation](https://reference.wolfram.com/language/ref/VerificationTest.html)
- [Systematic Testing and Verification — Wolfram Documentation](https://reference.wolfram.com/language/guide/SystematicTestingAndVerification.html)
- [Write Unit Tests — Wolfram Documentation](https://reference.wolfram.com/language/workflow/WriteUnitTests.html)
