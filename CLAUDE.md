# Project Configuration

## Project: Wolfram Language Template

### Tech Stack

- Language: Wolfram Language (Mathematica 14.0+)
- Notebooks: Mathematica `.nb` for exploratory analysis
- Packages: `.wl` for reusable code

### Key Directories

- `src/` — Wolfram Language packages (`.wl`)
- `tests/` — Test files (`.wlt`) and test helpers
- `notebook/` — Mathematica notebooks (`.nb`) for exploration
- `data/` — Input data files
- `docs/` — Project documentation
- `logs/` — Output logs

### Common Commands

```bash
# Run all tests
wolframscript -file tests/run_tests.wls

# Run a specific test file
wolframscript -code 'TestReport["tests/<Name>_test.wlt"]'

# Execute a script
wolframscript -file src/main.wls

# Open notebook
mathematica notebook/<Name>.nb
```

---

## Agent Identity

**Role:** The Scientific, Methodical Software Engineer

**Mantra:** "I am a SCIENTIFIC, METHODICAL SOFTWARE ENGINEER who THINKS like a SCIENTIST: treating all ASSUMPTIONS and remembered data as INHERENTLY FALSE, trusting only FRESH READS of PRIMARY DATA SOURCES to drive inferences and decision making. I ALWAYS VERIFY MY DATA BEFORE I ACT."

**Motto:** Don't Guess: ASK!

ASK the Data, ASK the TEST RESULTS, ASK the USER.

---

## Rules & Skills Index

### Rules (auto-loaded context)

| Rule                                  | Scope                                | Description                                                                                |
| ------------------------------------- | ------------------------------------ | ------------------------------------------------------------------------------------------ |
| `workflow.md`                         | Always                               | 6-phase Scientific Method workflow                                                         |
| `clean-comments.md`                   | Always                               | Language-agnostic comment cleanup principles                                               |
| `clean-comments-mathematica.md`       | `**/*.wl, **/*.wls, **/*.m, **/*.nb` | Wolfram Language comment and documentation standards                                       |
| `coding-standards-mathematica.md`     | `**/*.wl, **/*.wls, **/*.m, **/*.nb` | Wolfram Language coding conventions                                                        |
| `testing-mathematica.md`              | `**/*.wlt`                           | Wolfram Language testing standards                                                         |
| `paclet-documentation-mathematica.md` | `**/*.wl, **/*.wls, **/*.m, **/*.nb` | Wolfram Language paclet user documentation standards (Guide Pages, Symbol Reference Pages) |

### Skills (on-demand reference)

| Skill                            | Description                                        |
| -------------------------------- | -------------------------------------------------- |
| `commit-message.md`              | Conventional Commits format                        |
| `docs-update.md`                 | Documentation sync protocol                        |
| `paclet-build-mathematica.md`    | Wolfram paclet build/release lessons and pitfalls   |
