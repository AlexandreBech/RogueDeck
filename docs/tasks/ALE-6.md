# ALE-6: Build game context

## Source

- Linear URL: https://linear.app/alexbech/issue/ALE-6/build-game-context
- Requirements revision: 2026-09-06T16:11:56.497Z; fetched 2026-09-06.
- Repository: AlexandreBech/RogueDeck.
- Base commit: 1d2eff53aeeabfaa198f1dbeb37c853d3d421a95; pre-existing uncommitted Godot setup present.
- Plan status: ready.

## Objective

Give future agents durable context about game direction, current implementation, and environment setup.

Original ticket snapshot:

> Build game context to allow futur agent to know full context of where the game is at, what are we trying to achieve and how is the environment setup
>
> The game is a rogue like deck builder, each run starts with the same 20 cards, no card can be added or removed. Instead card can be upgraded with 3 different upgrade after each victorious battle. Upgrades can be multiplier/adder to existing statistics or add extra effect on the card

## Existing behavior

README, AGENTS, architecture, and game design describe an uninitialized project. Local rogue-deck files, engine scripts, configuration, and ignore rules already provide a startup shell; gameplay does not exist.

## Scope

Update the four context documents and add this specification. No runtime, engine, CI, dependency, or gameplay changes. Preserve pre-existing work.

## Implementation plan

1. Inspect the original ticket and workspace.
2. Record confirmed game rules and unresolved reward semantics.
3. Document actual setup, project paths, tests, exports, and CI limitations.
4. Update agent entry points and verify against source and repository checks.

## Acceptance criteria

- [x] AC1: README links to the genre, fixed 20-card deck, victory upgrades, and supported upgrade kinds.
- [x] AC2: Context distinguishes intended gameplay from the startup shell and uncommitted setup.
- [x] AC3: Architecture identifies engine pin, language, entry scene, prerequisites, executable resolution, commands, and output paths.
- [x] AC4: Ambiguous upgrade rewards remain open questions rather than invented rules.

## Validation

AC1/AC4: manually compare game design with the original ticket. AC2/AC3: compare documentation with project settings, main scene/script, tests, export presets, scripts, config, and CI. Run node scripts/validate.mjs --repository and git diff --check. Documentation-only scope needs no additional gameplay tests.

## Risks

The pre-existing engine setup is uncommitted and may evolve independently. Upgrade reward wording is ambiguous. The engine setup and CI changed concurrently during this task; the final context reflects the inspected Windows game job, whose hosted result is unverified. No scene, asset, save, or balance changes are made.

## Open questions

None blocking documentation. Gameplay decisions are listed in docs/game-design.md for future tickets.

## Implementation evidence

Updated README, game design, and architecture and added this specification; the concurrently updated AGENTS entry point already points to these documents and correctly describes the engine. Preserved existing engine changes. Manual comparison completed for AC1–AC4. `node scripts/validate.mjs --repository`: passed. `git diff --check`: passed (line-ending conversion warnings only). Full game validation, build, and graphical playtest were not run for this documentation-only change.

Workflow deviation: this is a local documentation change without a committed planner handoff, PR, or independent review. It does not demonstrate execution of the automated pipeline or a merged ticket.

## Playtest

Not run; documentation-only change. Future startup check: open the pinned project, run it, verify title and initial Quit focus, then activate Quit and expect closure. This checks the shell only.
