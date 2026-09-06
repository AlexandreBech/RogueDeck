# Architecture and environment

## Observed state

Inspected for ALE-6 on 2026-09-06. Base commit `1d2eff53aeeabfaa198f1dbeb37c853d3d421a95` contains workflow scaffolding. Pre-existing uncommitted files add a Godot startup shell. Preserve that work; verify its presence in another checkout.

| Setting | Local configuration |
| --- | --- |
| Engine | Godot 4.7.2 stable, pinned in config/validation.json |
| Language | GDScript; dependency-free JavaScript ES modules for tooling |
| Project | rogue-deck/project.godot |
| Entry scene | res://scenes/main.tscn |
| Renderer / viewport | GL Compatibility / 1280 × 720, canvas_items stretch |
| Export | Windows Desktop x86_64, embedded PCK |
| Output | artifacts/windows/RogueDeck.exe |
| Tests | Custom SceneTree assertions in rogue-deck/tests/test_main.gd |

The engine version is an observed repository pin, not an independently verified release recommendation.

## Implementation map

- `rogue-deck/scenes/main.tscn`: startup Control UI, title, and Quit button.
- `rogue-deck/scripts/main.gd`: initial keyboard focus, quit action, smoke marker.
- `rogue-deck/tests/test_main.gd`: scene, renderer, title, button, focus, and signal assertions.
- `rogue-deck/export_presets.cfg`: Windows export, excluding tests.
- `scripts/godot.mjs`: version check, import, tests, export, and smoke launch.
- `scripts/install-godot.ps1`: pinned Windows template download and optional editor installation.
- `scripts/bootstrap.mjs`, `validate.mjs`, `build.mjs`: repository command entry points.
- `config/validation.json`: engine metadata, executable/argument arrays, 900-second timeout.
- `docs/tasks/`, `.github/codex/`: durable specifications and agent role prompts.
- `.github/workflows/`: repository foundation CI plus Godot tests and Windows build.

No gameplay state, save format, randomness strategy, or card loading architecture exists. Keep future rules separate from presentation where practical; do not invent systems from the project name.

## Setup and launch

1. Install Node.js 22+ and Git on PATH. No npm dependencies are needed.
2. Provision the pinned Godot editor. The runner resolves it in order: GODOT_BIN; the executable property in ignored config/godot.local.json; .tools/Godot_v4.7.2-stable_win64_console.exe; then godot on PATH. Keep machine paths in local configuration.
3. Provision matching Windows export templates. The helper below downloads templates into %APPDATA%/Godot/export_templates/4.7.2.stable. The optional -InstallEditor switch extracts the editor into .tools. It needs network access and writes templates outside the repository.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install-godot.ps1 -InstallEditor
```

4. Run these commands from the repository root:

```sh
node scripts/validate.mjs --repository
node scripts/bootstrap.mjs
node scripts/validate.mjs
node scripts/build.mjs
```

Open rogue-deck/project.godot in the pinned editor and run the project for visual inspection. Expect a startup screen and Quit button, not playable combat.

## Validation and limitations

Foundation validation checks repository structure and configuration only. Bootstrap checks Git and the foundation, then imports the configured project. Full validation imports, runs UI assertions expecting ROGUEDECK_TESTS_OK, and launches the scene headlessly expecting ROGUEDECK_SMOKE_OK. No gameplay regression coverage exists.

Build exports into a fresh artifacts/builds/windows-* directory, checks executable size, launches the export smoke check on Windows, and copies the result to artifacts/windows/RogueDeck.exe. Export launch is skipped on other hosts. Logs go into artifacts/logs. Missing tools, version mismatches, Godot errors, and missing expected markers fail the runner.

The local CI workflow now runs foundation checks on Ubuntu and Windows and a separate Windows game job that installs the pinned editor/templates, imports, tests, builds, and uploads the executable and logs. This workflow changed during the documentation task; its configuration was inspected, but a successful hosted run was not verified. Existing game checks cover startup only.

Preserve .uid, .import, source assets, scenes, project settings, and export presets. Ignore .godot caches, .tools, artifacts, export credentials, and local configuration. Asset provenance beyond the inspected startup files has not been established.

See docs/tasks/ALE-6.md for verification actually performed. Fresh-checkout setup, graphical playtesting, and release readiness require separate evidence.
