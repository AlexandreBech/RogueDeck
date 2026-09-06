# Game design

## Confirmed direction

Source: [ALE-6 — Build game context](https://linear.app/alexbech/issue/ALE-6/build-game-context), updated 2026-09-06T16:11:56.497Z. These are intended requirements, not implemented gameplay.

- RogueDeck is a roguelike deck builder.
- Each run starts with the same 20 cards.
- Cards cannot be added to or removed from the deck.
- Cards can be upgraded after each victorious battle. The ticket specifies “3 different upgrade” without defining how they are selected or applied.
- Upgrades can multiply existing statistics, add to existing statistics, or add extra effects to cards.

The progression direction is improving the fixed starting deck through battle rewards. Card acquisition or removal would require an explicit design change.

## Examples and boundaries

Two runs must start with the same card composition; specific card definitions and initial draw order are unspecified. An upgrade changes statistics or effects while preserving deck membership and count. Adding a twenty-first card or permanently removing a starting card violates the fixed-deck rule.

Drawing, discarding, exhausting, and temporary copies are not defined. Do not assume a pile transition means permanent deck removal. Defeat rewards, upgrade persistence across runs, and calculation order are unspecified.

## Current implementation

The local Godot project contains a startup UI and Quit action only. No card definitions, combat, deck/pile model, rewards, upgrade calculations, run progression, or saves exist. Existing tests cover the shell, not these intended rules.

## Decisions for subsequent tickets

These questions do not block documentation but must be answered before their systems are implemented:

- Does “3 different upgrade” mean choosing one of three options, applying three upgrades, or something else? Which cards receive them, and how many cards are upgraded per victory?
- What are the 20 starting cards, duplicate counts, statistics, and effects?
- How do turns, draw rules, resources, targets, damage, enemies, and victory/defeat work?
- How do modifiers stack, round, cap, and interact with effects? Do upgrades last for one run only?
- What defines encounters, run completion, loss, and progression between runs?
- What input, visual direction, asset provenance, saves, accessibility, and performance targets are required? Windows export is configured; other targets are unspecified.

## Maintaining context

Record approved rules with source tickets, examples, edge cases, and rationale when supplied. Separate proposals from confirmed requirements. Seed random tests; use observable acceptance criteria and human playtests for subjective feel.
