# Architecture

## Observed state

The repository was empty when this foundation was prepared. No engine project, gameplay implementation, scenes, assets, or game tests exist yet.

## Decisions needed

| Decision | Current value |
| --- | --- |
| Engine and exact version | Not selected |
| Implementation language | Not selected |
| Target platforms | Not selected |
| Main scene / entry point | Not created |
| Game test framework | Not selected |
| Build artifact path | Not configured |
| Engine licensing / runner prerequisites | Not established |

## Repository map

| Path | Responsibility |
| --- | --- |
| `docs/tasks/` | Durable ticket specifications |
| `.github/codex/` | Planner, implementer, reviewer prompts |
| `.github/workflows/` | Repository foundation CI |
| `scripts/` | Dependency-free repository commands |
| `config/validation.json` | Engine metadata and explicit command argument arrays |

## Engine integration contract

After choosing an engine, update this document with actual source/scene/asset locations and their relationships. Record the startup path, gameplay state ownership, persistence format, randomness strategy, and resource loading approach only as they are implemented.

Set `engine` to an object with nonempty `name`, `version`, and `projectFile` in `config/validation.json`. `projectFile` is a repository-relative file that must exist. Set `setup` to an explicit command, or leave it null only when no automated engine setup is required. `test` and `build` must each be an object with an executable `command` and an `args` array of strings.

Commands run from the repository root without a shell, with inherited environment, and a bounded timeout. Use an actual executable such as `node`, `pwsh`, or an engine binary, not shell operators or a `.cmd` wrapper. Machine-specific executable locations should come from a consistent PATH rather than a committed user-specific absolute path. Provision the engine before running these scripts.

Add import checks, a real game test command, export/build configuration, and documented output locations. A test command must return nonzero on assertion failures and on missing tests. A build command must verify that the expected artifact was produced. Configure timeoutSeconds for the expected workload (default 900).

## Validation milestones

- Fresh checkout imports/compiles with the pinned engine version.
- A representative gameplay rule has deterministic regression coverage.
- Main scene or equivalent can be loaded in a smoke check.
- Target build produces a playable artifact.
- Save/reload and visual/input playtests are documented when those systems exist.
