# ALE-12: Design card "Attack"

## Source

- Linear URL: https://linear.app/alexbech/issue/ALE-12/design-card-attack
- Issue UUID: c4efadbc-661b-48f0-8fc8-c632f35df22b
- Requirements revision: 2026-09-06T17:07:34.601Z
- Original requirement: "Design card called attack, the card cost 1 mana and inflict 1 damage"
- Repository: C:/Users/Alexandre/Documents/GameDev/RogueDeck/RogueDeck
- Base commit: a616f66200445d64a8a8013673da4bff78bb3b24
- Plan status: ready

## Objective

Define and visually present the Attack card with a mana cost of 1 and damage of 1.

## Existing behavior

Inspected README.md, AGENTS.md, docs/architecture.md, docs/game-design.md, docs/local-codex-worker.md, rogue-deck/scenes/main.tscn, scripts/main.gd, tests/test_main.gd, and the validation runner. The base has a Start/Quit menu and procedural medieval background. There are no cards, mana pools, combat targets, card gallery, or save system. No existing ALE-12 specification exists.

## Scope

Add a small typed card definition Resource, one Attack resource, a reusable visual card scene, and a directly runnable preview scene. Use original SVG sword artwork matching the medieval presentation. The resource records the specified damage for future combat integration; this design ticket does not define turn rules, targeting, mana spending, deck composition, or upgrades. Keep the main menu unchanged; other local tickets own its additions.

## Implementation plan

1. Add scripts/card_definition.gd and cards/attack.tres with stable ID attack, name Attack, mana_cost 1, and damage 1.
2. Add scripts/card_view.gd and scenes/attack_card.tscn; derive all displayed card text from its definition.
3. Add original assets/cards/attack.svg and scenes/card_preview.tscn for direct scene preview with the existing background.
4. Extend tests/test_main.gd to check resource values, visible card text, artwork loading, layout fit, and that the presentation reflects alternate resource values without mutating the original definition.
5. Document the resource and preview path in README.md and run required validation.

## Acceptance criteria

- [x] AC1: The Attack definition has ID attack, display name Attack, mana cost 1, and damage 1.
- [x] AC2: The card visibly displays Attack, 1 MANA, and Deal 1 damage. with legible artwork and no overlapping text.
- [x] AC3: The preview scene loads independently and contains the card centered within the configured 1280 x 720 viewport.
- [x] AC4: The UI derives cost and damage from the card definition; existing menu tests and startup behavior still pass.

## Validation

- AC1: resource assertions in node scripts/validate.mjs.
- AC2-4: scene assertions in node scripts/validate.mjs, including isolated alternate values to detect hardcoded presentation, visible bounds checks, and retained menu assertions.
- Required: node scripts/validate.mjs --repository; git diff --check; node scripts/validate.mjs; node scripts/build.mjs. Use the absolute GODOT_BIN resolved from the main checkout, without copying local configuration or caches.
- Human visual check: run rogue-deck/scenes/card_preview.tscn (F6) and inspect card text, artwork, contrast, and spacing. Not run yet.

## Risks

No existing scene links, saves, or deck composition change. New resources must import and be included by Windows export. Combat execution remains undefined because the repository has no combat model. Original SVG artwork adds no third-party dependency. The base architecture document contains pre-existing merge markers; repairing unrelated documentation is outside this ticket.

## Open questions

None blocking the card design. Combat integration requires a separate ticket specifying targets and resource handling.

## Implementation evidence

Implemented the planned typed definition, Attack resource, reusable card view, original SVG sword artwork, direct preview scene, README instructions, and regression checks. Godot-generated script UID and SVG import sidecars are retained. Existing menu files and the main checkout's pre-existing scene modification remain untouched.

- `node scripts/validate.mjs --repository`: passed, exit 0.
- `git diff --check`: passed, exit 0.
- `node scripts/validate.mjs`: passed, exit 0; 35 checks including all card acceptance assertions and retained menu checks, plus startup smoke. Logs: artifacts/logs/tests.log and startup.log.
- `node scripts/build.mjs`: passed, exit 0; fresh Windows x86_64 export and exported executable smoke. Logs: artifacts/logs/export.log and export-smoke.log. Output: artifacts/windows/RogueDeck.exe.
- Runtime checks used Godot 4.7.2 via absolute GODOT_BIN `C:/Users/Alexandre/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe`, with approved execution outside the restricted sandbox. No retry was needed.
- `node artifacts/render-preview.mjs`: passed, exit 0; a hidden Godot OpenGL render saved artifacts/attack-preview.png. Agent inspected the 1280 x 720 result: centered card, correct readable title/cost/effect, sword artwork, and no text overlap. This is visual inspection, not independent review or a human playtest.
- No scope deviations. Combat integration, mana spending, targets, upgrades, and deck composition remain unimplemented, as documented in the plan.

Worktree: C:/Users/Alexandre/Documents/GameDev/RogueDeck/.linear-local/worktrees/ALE-12. Branch: codex-local/ALE-12. Changes are local and uncommitted; no PR exists.

## Linear completion handoff

Owner: local worker, run token 4e8f6790-ccdf-4f7a-8527-7f6cfaa2b6dc. Handoff blocked: automatic approval review rejected the completion comment because it contains internal implementation details, absolute local paths, branch/base-commit metadata, and validation artifacts. Comment ID: none. Re-read confirms Implementing; In Review was not requested because the required comment did not succeed. User approval is needed to publish the prepared payload. Do not reimplement or blindly retry. Changes remain local and uncommitted; no PR exists.

Prepared completion comment (also saved at artifacts/completion-comment.md):

```markdown
Implemented ALE-12: Attack card design.

- Added a typed card definition and Attack resource with ID attack, name Attack, mana cost 1, and damage 1.
- Added a reusable card view, original sword SVG, and a directly runnable card_preview.tscn scene. Displayed cost/damage derive from the resource.
- Acceptance coverage: identity and statistics; visible Attack / 1 MANA / Deal 1 damage.; artwork loading; centered preview and non-overlapping text; alternate-resource checks; retained menu tests.
- Passed: `node scripts/validate.mjs --repository`; `git diff --check`; `node scripts/validate.mjs` (35 checks and startup smoke); `node scripts/build.mjs` (fresh Windows export and exported executable smoke).
- Godot 4.7.2 checks used the existing absolute GODOT_BIN with approved execution outside the restricted sandbox. No retries were needed.
- Passed `node artifacts/render-preview.mjs`; agent inspected the rendered 1280 x 720 preview at artifacts/attack-preview.png for correct text, layout, and artwork.
- Limitations: this implements the card design and base statistics. Combat, mana spending, targets, deck composition, upgrades, and menu navigation to cards do not exist in this base and are outside this ticket.
- Human playtest and independent review remain: open rogue-deck/scenes/card_preview.tscn in Godot, press F6, and inspect text/contrast/spacing; run the main scene to check Start focus and Quit.

Specification: `docs/tasks/ALE-12.md`.
Absolute worktree: `C:/Users/Alexandre/Documents/GameDev/RogueDeck/.linear-local/worktrees/ALE-12`.
Branch: `codex-local/ALE-12`.
Base commit: `a616f66200445d64a8a8013673da4bff78bb3b24`.
Build: `artifacts/windows/RogueDeck.exe` within the worktree.
Validation logs: `artifacts/logs/tests.log`, `startup.log`, `export.log`, and `export-smoke.log`.

Changes are local and uncommitted. No PR exists. Ready for human review; no independent review or human playtest is claimed.
```

## Playtest

Not run. Open rogue-deck/scenes/card_preview.tscn in Godot and press F6. Expect one centered Attack card, sword illustration, 1 MANA, and Deal 1 damage. Run the main project separately and verify Start retains initial focus and Quit exits.
