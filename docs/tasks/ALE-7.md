# ALE-7: Add a medieval battle background

## Source

- Linear issue: ALE-7 — Add background for battle, inspired by a middle age version of hearstone.
- Requirements snapshot: supplied with the implementation request on 2026-09-06.
- Repository and base commit: current `work` branch at implementation start.
- Plan status: ready.

## Objective

Add a scalable battle backdrop with a warm medieval card-table atmosphere. The visual may evoke a hand-built fantasy tavern table, but must use original shapes and composition rather than copying another game's protected artwork or interface.

## Existing behavior

Only the title screen exists. `rogue-deck/scenes/main.tscn` previously rendered labels and a Quit button over the default clear color; there is no battle scene or gameplay system to decorate.

## Scope

- Add an original, reusable battle-background scene and drawing script.
- Display the backdrop behind the existing title-screen controls so the art is immediately observable.
- Add structural regression coverage for the background scene and its placement.
- Do not add combat, cards, deck behavior, navigation, or save data.

## Implementation plan

1. Draw a resolution-independent stone, timber, parchment, and candlelit tabletop backdrop with Godot primitives.
2. Package it as a mouse-transparent full-rect Control scene.
3. instance it behind the existing title content and extend scene tests.
4. Run repository, game, build, and diff validation; record limitations and playtest needs.

## Acceptance criteria

- [ ] AC1: Given the project starts, when the main scene is shown, then an original medieval-styled backdrop fills the viewport behind the existing controls.
- [ ] AC2: Given the viewport size changes, when the background redraws, then it continues to cover the available area without intercepting UI input.
- [ ] AC3: Given future battle presentation needs the art, when a scene is composed, then the backdrop is available as a standalone reusable scene.
- [ ] AC4: Existing title, focus, Quit behavior, startup smoke check, and configured export remain functional.

## Validation

- AC1–AC3: load the background and main scenes in `rogue-deck/tests/test_main.gd`; assert the reusable full-rect Control, drawing script, mouse filtering, and first-child layering.
- AC4: run `node scripts/validate.mjs` and `node scripts/build.mjs` with Godot 4.7.2 and matching export templates.
- Run `node scripts/validate.mjs --repository` and `git diff --check` for repository integrity.
- Human playtest: launch the project at 1280 × 720 and at a resized aspect ratio; inspect readability, backdrop coverage, visual quality, focus, and Quit.

## Risks

- The project has no battle scene, so the reusable background is demonstrated on the title screen without implying implemented combat.
- Procedural vector drawing avoids new binary provenance and scales cleanly, but final art direction remains subjective and requires human review.
- No save format, gameplay rules, randomness, or resource serialization changes are involved.

## Open questions

None blocking this visual foundation. A future battle-scene ticket must define battle layout and interaction requirements.

## Implementation evidence

Added the reusable `battle_background.tscn` and original procedural artwork in `battle_background.gd`, then instanced it as the first child of the existing main scene. Extended the scene test to cover reuse, viewport anchors, input pass-through, and render ordering. No third-party assets or save-format changes were introduced.

- `node scripts/validate.mjs --repository` with Node.js 22.22.2: passed.
- `node scripts/bootstrap.mjs`, `node scripts/validate.mjs`, and `node scripts/build.mjs` with Node.js 22.22.2: attempted but blocked before Godot execution because the pinned Godot editor is not installed (`spawnSync godot ENOENT`). These are not passes.
- `git diff --check`: passed before commit.
- Graphical playtest: not run because Godot is unavailable in this environment.

AC1 and AC4 require configured-engine validation and human visual review, so they remain unverified locally. AC2 and AC3 have structural regression assertions but likewise could not be executed without the engine.

## Original implementation handoff (historical)

Incomplete: required game validation and build could not run without Godot, and no connected Linear read/write tools are available in this session. No ticket comment or status change was attempted; ALE-7 must not move to In Review while required checks remain blocked.

Prepared comment for a future handoff owner: “Implemented an original reusable medieval battle backdrop (procedural stone, timber, felt, banner, and candlelight), displayed behind the startup UI, with structural scene coverage. Specification: `docs/tasks/ALE-7.md`. Repository validation and diff check pass. Full Godot validation, Windows export, and graphical playtest remain required because Godot 4.7.2 and export templates were unavailable in the implementation environment. Changes are not yet ready for In Review.”

## Playtest

Not run. Launch the project, resize the window, verify the medieval tabletop fills the view behind legible controls, confirm Quit begins focused, and activate Quit.

## Windows verification follow-up — 2026-09-06

Re-read the connected ALE-7 issue before handoff: its title matches the original request and its description is empty; no changed requirements were found.

All seven expected changed/new files are present: this specification, the architecture map, the background scene, drawing script and `.gd.uid` sidecar, main-scene integration, and scene tests. Resource loading and export succeeded. The implementation is local and uncommitted on `main` at base `07ea65d2e05de62b1a9e77d19ffff76c2c75ce31`; the previously reported `93f205e` commit is absent from this checkout. No PR exists for this local work.

Using portable Node.js 22.22.2 in ignored `.tools`, Git 2.50.1, installed Godot `4.7.2.stable.official.ed1daf0bf`, and matching Windows templates:

- `node scripts/validate.mjs --repository`: passed.
- `node scripts/bootstrap.mjs`: passed on retry with approved access to the installed editor's settings. The initial sandboxed attempt failed on certificate-store/settings access and was not counted as a pass.
- `node scripts/validate.mjs`: passed, `ROGUEDECK_TESTS_OK: 13 checks` and `ROGUEDECK_SMOKE_OK`.
- `node scripts/build.mjs`: passed, Windows x86_64 export and executable smoke launch (`ROGUEDECK_SMOKE_OK`). Output: ignored `artifacts/windows/RogueDeck.exe`.
- `git diff --check`: passed.

AC1: background presence and ordering pass automated checks; source contains the original medieval artwork. AC2: full-parent anchors and mouse-input pass-through pass; resize redraw is wired in source. AC3: standalone scene loading and Control root pass. AC4: title, focus, Quit signal wiring, startup, export, and executable smoke checks pass. These checks do not visually assess artwork or simulate a mouse click on Quit. Human review still needs the 1280 × 720 and resized-window visual/input playtest above. No implementation code changed during this verification.

## Current Linear completion handoff

Completed on 2026-09-06. Posted verification comment `6e8ced54-2408-4faa-9735-051d62e20cd2` on [ALE-7](https://linear.app/alexbech/issue/ALE-7/add-background-for-battle-inspired-by-a-middle-age-version-of), then moved that exact issue (UUID `34147fdb-75cc-4d74-98fe-ab5389e14eae`) to the team's **In Review** status (`4c5541f6-a21f-40a3-8dba-56f63bf02874`). A subsequent issue read confirmed **In Review**. Required automated checks passed; human visual/input playtest remains as described above. This evidence update is also local and uncommitted.
