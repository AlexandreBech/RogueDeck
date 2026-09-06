# ALE-10: Add an option button to menu

## Source

- Linear URL: https://linear.app/alexbech/issue/ALE-10/add-an-option-button-to-menu
- Issue UUID: 0042e6f1-38a5-4f8c-b97a-c23f99a521a4.
- Requirements revision: 2026-09-06T17:00:51.429Z; title and description both read “Add an option button to menu”. No comments or linked specifications.
- Repository: C:/Users/Alexandre/Documents/GameDev/RogueDeck/RogueDeck.
- Base commit: a616f66200445d64a8a8013673da4bff78bb3b24.
- Plan status: ready; local-worker specification written before implementation.

## Objective

Add a visible Options button to the existing main menu.

## Existing behavior

`rogue-deck/scenes/main.tscn` displays a tabletop background, title, subtitle, Start, and Quit. `rogue-deck/scripts/main.gd` focuses Start and handles Quit. `rogue-deck/tests/test_main.gd` covers the existing shell. There is no settings screen or settings model. The earlier `docs/tasks/ALE-8.md` explicitly established adding a menu control without inventing an unspecified destination.

## Scope

Add Options between Start and Quit, matching their size and typography; cover its visibility, ordering, and keyboard traversal. Update the README snapshot. Options activation remains unconnected until settings behavior is specified, following the existing Start placeholder pattern. No gameplay, settings persistence, new artwork, or unrelated documentation repairs.

## Implementation plan

1. Add an Options Button to the main scene's existing VBoxContainer.
2. Extend scene tests for the visible control and focus order through all three buttons.
3. Document the current menu and the deferred activation behavior in README.
4. Run required repository, game, build, and diff checks in the isolated worktree using the main checkout's absolute Godot executable via GODOT_BIN.

## Acceptance criteria

- [x] AC1: On opening the main menu, a visible button labeled Options appears between Start and Quit with matching dimensions and typography.
- [x] AC2: Start retains initial focus; forward keyboard traversal reaches Options, then Quit, and reverse traversal reaches Options again.
- [x] AC3: Existing title/background assertions, Quit connection, main-scene smoke check, and Windows export smoke check pass.

## Validation

- AC1 and AC2: extend `rogue-deck/tests/test_main.gd`; check real control visibility/layout and dispatch keyboard navigation input.
- AC1–AC3: `node scripts/validate.mjs`, expecting all scene checks and ROGUEDECK_SMOKE_OK.
- AC3: `node scripts/build.mjs`, expecting Windows x86_64 export and executable launch smoke check.
- Required foundation: `node scripts/validate.mjs --repository`.
- Patch formatting: `git diff --check`.
- Human graphical playtest: inspect menu appearance and use keyboard/mouse navigation. Not run until explicitly recorded.

## Risks

Adding a button increases the menu height; verify layout remains inside the configured 1280 × 720 viewport. No saves, random behavior, asset IDs, or existing scene connections change. Architecture documentation already contains conflict markers at the base commit; repairing them is outside this ticket.

## Open questions

None blocking the requested button. Settings contents and activation behavior require a future ticket and are not implemented here.

## Implementation evidence

Added Options between Start and Quit with matching scene properties, added visibility/layout and Tab/Shift+Tab regression assertions, and documented the placeholder in README. No settings behavior was added.

- `node scripts/validate.mjs --repository`: passed (exit 0).
- `git diff --check`: passed (exit 0).
- `node scripts/validate.mjs`: failed (exit 1) during Godot import, before scene tests or startup smoke checks ran. GODOT_BIN resolved from the main checkout to `C:/Users/Alexandre/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe`; the reported version was `4.7.2.stable.official.ed1daf0bf`.
- Import reported `Failed to read the root certificate store`, could not save `C:/Users/Alexandre/AppData/Roaming/Godot/editor_settings-4.7.tres`, and reported `Error saving editor settings`. The validation wrapper correctly rejected these errors despite editor exit 0. The current sandbox permits worktree writes but not editor settings in AppData.
- `node scripts/build.mjs`: not run after required validation failed. Export and executable launch remain unverified.
- New acceptance checks and graphical playtest: not run. No acceptance criterion is claimed verified by runtime execution.

No automatic retry. Worktree retained at `C:/Users/Alexandre/Documents/GameDev/RogueDeck/.linear-local/worktrees/ALE-10`, branch `codex-local/ALE-10`; changes are local and uncommitted, and no PR exists. Recovery must inspect the saved worker record and resolve Godot's environment errors before resuming checks. Main checkout was not edited.

## Linear completion handoff

Owner: local scheduled worker. Completion handoff is blocked by failed required validation. No completion comment was posted and In Review is not authorized. ALE-10 was moved to Failed and verified by rereading Linear (updatedAt 2026-09-06T17:06:58.560Z). Recovery evidence is saved in `C:/Users/Alexandre/Documents/GameDev/RogueDeck/.linear-local/issues/ALE-10.json`.

## User-authorized recovery, 2026-09-06

The user requested “Move the ticket and restart the work”. After the ALE-11 worker released its lock, acquired a new owned lock and resumed the existing worktree without recreating or reimplementing the ticket. Re-read ALE-10 and confirmed unchanged requirements, assignee, codex-local label, and no delegate; moved Failed to Implementing and verified it.

The earlier failure evidence above describes the initial attempt. It is superseded by these recovery results:

- `node scripts/validate.mjs --repository`: passed, exit 0.
- `git diff --check`: passed, exit 0.
- `node scripts/validate.mjs`: passed, exit 0; `ROGUEDECK_TESTS_OK: 25 checks` and `ROGUEDECK_SMOKE_OK`. Checks cover AC1's visibility, layout, size, typography and viewport fit; AC2's initial focus and actual Tab/Shift+Tab input; and AC3's retained title/background/Quit behavior and startup.
- `node scripts/build.mjs`: passed, exit 0; fresh Windows x86_64 export and exported executable launch emitted `ROGUEDECK_SMOKE_OK`. Output: `artifacts/windows/RogueDeck.exe`.
- Runtime commands used the recorded absolute GODOT_BIN and explicitly approved execution outside this task's original sandbox. Certificate-store and settings-save errors did not recur. This validates the implementation under approved execution; it does not prove the scheduled worker has adopted the new permission profile.
- Logs: `artifacts/logs/tests.log`, `startup.log`, `export.log`, and `export-smoke.log`.
- No implementation changes were needed during recovery. Human graphical playtest and independent review remain unperformed. Options remains an intentionally unconnected placeholder, as specified.

Completion comment: `43377512-9379-4d3b-98a9-12001ec23479`, posted to ALE-10 after required checks passed. Moved the same issue to In Review and verified by rereading (updatedAt `2026-09-06T17:20:36.992Z`). Changes remain local and uncommitted on `codex-local/ALE-10`; no PR exists. A separate modification to the main checkout's `rogue-deck/scenes/main.tscn` was observed during recovery and left untouched.

## Playtest

Not run. Open `rogue-deck/project.godot`, run the main scene, confirm Start / Options / Quit appear in order and match visually, use Tab and Shift+Tab to traverse them, and confirm Quit closes the application. Options is a placeholder and currently has no activation behavior.
