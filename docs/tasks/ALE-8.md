# ALE-8: Add a start button to main menu

## Source

- Linear issue: ALE-8, “Add a start button to main menu” (snapshot supplied with this request on 2026-09-06).
- Repository: AlexandreBech/RogueDeck.
- Base commit: 07ea65d9cce6dc119b320a319dc859c17c0b1296.
- Plan status: ready.

## Objective

Add a clearly labeled Start button to the existing main menu so the primary action is visible and receives initial keyboard focus.

## Existing behavior

`rogue-deck/scenes/main.tscn` contains the RogueDeck title, a subtitle, and a Quit button. `rogue-deck/scripts/main.gd` gives initial focus to Quit. No gameplay scene or run-starting system exists.

## Scope

- Add a Start button before Quit in the main menu's existing vertical layout.
- Give Start initial keyboard focus and cover its presence and focus with the existing scene test.
- Preserve the existing Quit behavior and startup smoke marker.
- Do not invent a gameplay destination or implement run-starting behavior; button activation is intentionally deferred until such a destination is specified.

## Implementation plan

1. Add the Start control to the main scene using the existing button sizing and typography.
2. Move initial focus from Quit to Start.
3. Extend the scene assertions for the new primary action and retained Quit connection.
4. Update current-state documentation and run repository, game, and build validation.

## Acceptance criteria

- [x] AC1: Given the main menu opens, when its controls render, then a button labeled “Start” appears before the Quit button.
- [x] AC2: Given keyboard or controller navigation, when the main menu opens, then Start has initial focus.
- [ ] AC3: Given the menu change, when automated scene checks run, then the existing title, Quit action, and startup smoke behavior remain valid.

## Validation

- AC1–AC3: `node scripts/validate.mjs`; expect all scene assertions and startup smoke checks to pass with Godot 4.7.2 stable configured.
- Export regression: `node scripts/build.mjs`; expect a Windows x86_64 executable, with launch smoke-testing limited to Windows hosts.
- Repository and patch checks: `node scripts/validate.mjs --repository` and `git diff --check`.
- Manual: run the project, confirm Start appears above Quit with visible initial focus, and use keyboard navigation to reach Quit.

## Risks

The ticket does not identify a gameplay scene or behavior to invoke. Connecting Start to an invented destination would misrepresent the currently implemented game, so this ticket provides the menu control and defers activation behavior. The scene change does not affect saves, randomness, assets, or serialization beyond the added node.

## Open questions

None blocking the requested menu control. A future gameplay ticket must specify what activating Start does.

## Implementation evidence

Added the Start button before Quit, moved initial focus to Start, retained the Quit connection and smoke marker, and expanded the scene regression test. Updated README and architecture descriptions without claiming that gameplay exists.

- `/root/.nvm/versions/node/v22.22.2/bin/node scripts/validate.mjs --repository`: passed.
- `git diff --check`: passed.
- `node scripts/bootstrap.mjs`, `node scripts/validate.mjs`, and `node scripts/build.mjs` with Node 22 first on `PATH`: failed because the pinned Godot executable is not installed (`spawnSync godot ENOENT`). AC3 therefore remains unverified, and the runtime checks and Windows export did not run.
- Manual graphical playtest: not run because Godot is unavailable.

There was no implementation deviation. The original ALE-8 title and supplied issue context were re-read after the change; the requested Start control is present, while activation behavior remains outside the underspecified ticket.

## Linear completion handoff

Incomplete. No Linear read/write tool is connected in this session, and required game validation and build could not run without Godot, so no ticket comment was posted and ALE-8 was not moved to In Review.

Prepared comment (not posted):

> Added a Start button above Quit on the main menu, gave it initial keyboard focus, and added scene assertions for its label, ordering, and focus while retaining the Quit connection and startup smoke behavior. Updated current-state docs; specification: `docs/tasks/ALE-8.md`. Repository validation and `git diff --check` pass. Configured game validation, Windows export, and graphical playtest remain required because Godot 4.7.2 is unavailable in this environment (`spawnSync godot ENOENT`). Start activation intentionally remains unimplemented because no gameplay destination exists or was specified. Changes are local; commit and PR details were not yet available when this evidence was recorded.

## Playtest

Not run. Open the project, confirm Start is visible above Quit and initially focused, press the down navigation action to focus Quit, and verify Quit still closes the application. Start activation has no behavior until a gameplay destination is specified.
