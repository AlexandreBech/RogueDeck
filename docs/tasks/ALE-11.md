# ALE-11: Add a See Deck button

## Source

- Linear URL: https://linear.app/alexbech/issue/ALE-11/add-a-see-deck-button
- Issue UUID: 1db925b6-1ae9-40dd-a27d-611dbc8c5fe6
- Requirements revision: 2026-09-06T17:06:55.082Z
- Original requirements: Add a button on the main menu which allows to see all the 20 available card of the game, only display the card that are already design, there is non at the moment.
- Repository: C:/Users/Alexandre/Documents/GameDev/RogueDeck/RogueDeck
- Base commit: a616f66200445d64a8a8013673da4bff78bb3b24
- Plan status: ready

## Objective

Let players open a deck view from the main menu. Show only designed cards; with no card definitions currently present, show an explicit empty state and no invented cards.

## Existing behavior

The main scene contains a procedural backdrop, title, Start placeholder, and Quit button. main.gd handles initial focus and quitting. test_main.gd checks scene structure and input wiring. No card definitions, deck model, combat, or saves exist. The intended fixed deck has 20 cards, whose designs are unspecified.

## Scope

Add See Deck, an empty deck view, and Back navigation with keyboard focus. Preserve existing Start and Quit behavior and the backdrop. Card design, gameplay, deck editing, and data loading for future cards are outside this ticket.

## Implementation plan

1. Add the See Deck button and a hidden deck panel in rogue-deck/scenes/main.tscn.
2. Toggle the menu and deck panel in rogue-deck/scripts/main.gd, moving focus to Back on entry and See Deck on return.
3. Extend rogue-deck/tests/test_main.gd with navigation, visibility, empty-state, and repeat-entry checks.
4. Describe the new shell behavior in README.md.

## Acceptance criteria

- [ ] AC1: The main menu has an enabled See Deck button between Start and Quit.
- [ ] AC2: Activating See Deck displays the deck screen and hides the main menu.
- [ ] AC3: With zero designed cards, the screen states that no cards are designed yet and that the planned deck contains 20 cards. It displays no invented card entries.
- [ ] AC4: Back restores the menu and keyboard focus to See Deck; reopening works. Initial focus remains Start and Quit stays connected.

## Validation

Run node scripts/validate.mjs --repository and git diff --check. Run node scripts/validate.mjs for scene assertions covering AC1–AC4 and startup. Run node scripts/build.mjs for Windows export and executable smoke check. Set GODOT_BIN to the absolute editor path resolved from the main checkout. All required checks must pass before completion; failed or unavailable checks are incomplete.

## Risks

No assets, saves, randomness, or gameplay rules change. Actual cards need a subsequent card-definition ticket and corresponding rendering once their data exists. Keyboard focus and visual sizing require human playtesting. The base architecture document contains pre-existing conflict-marker text, outside this ticket's scope. A prior worker reported Godot environment errors; preserve evidence if they recur and do not automatically retry.

## Open questions

None. The original ticket explicitly requests the current empty state; no card designs are inferred.

## Implementation evidence

Implemented See Deck between Start and Quit, a separate empty deck panel, Back navigation, and focus restoration. Added scene assertions for AC1–AC4 including repeated entry, and updated README.md. Static inspection confirms signal connections and visibility/focus handlers; runtime acceptance remains unverified.

- PASS: node scripts/validate.mjs --repository (exit 0).
- PASS: git diff --check (exit 0).
- FAILED: node scripts/validate.mjs (exit 1), using GODOT_BIN=C:/Users/Alexandre/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe. Godot identified itself as 4.7.2.stable.official.ed1daf0bf, but import reported failure reading the Windows root certificate store and saving C:/Users/Alexandre/AppData/Roaming/Godot/editor_settings-4.7.tres. The runner correctly rejected these errors despite Godot exiting 0.
- NOT RUN: scene assertions and startup, because the required import failed first.
- NOT RUN: node scripts/build.mjs, because it requires the same failed import; no automatic retry was attempted.
- NOT RUN: graphical playtest.

Import log: artifacts/logs/import.log. Durable validation evidence: C:/Users/Alexandre/Documents/GameDev/RogueDeck/.linear-local/issues/ALE-11.json. Worktree: C:/Users/Alexandre/Documents/GameDev/RogueDeck/.linear-local/worktrees/ALE-11. Branch: codex-local/ALE-11. Changes are local and uncommitted; no PR exists. The main checkout's pre-existing scene modification is preserved. Resolve the Godot environment errors and explicitly authorize recovery using this record/worktree; do not start a fresh implementation.

## Linear completion handoff

Owner: local worker. Required validation failed. Original requirements and eligibility were unchanged before the failure handoff. ALE-11 was moved to Failed and reread to verify status at revision 2026-09-06T17:16:58.364Z. No completion comment was posted and no In Review transition occurred. Changes remain local and uncommitted; no PR exists.

## Playtest

Not run. Launch the project, use mouse and keyboard to open See Deck, check the empty-state text and absence of card entries, select Back, reopen, and verify Start/Quit remain accessible. Check layout at 1280 × 720 and a smaller window.
