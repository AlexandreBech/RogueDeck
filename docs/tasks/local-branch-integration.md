# Local branch integration, 2026-09-06

## Source and scope

User request: "Merge all the branches and fix the conflicts". Integrate all existing local feature branches into main. This explicit request authorizes local commits and merges, superseding the earlier scheduled worker's no-commit/no-merge restriction for this operation. No push, PR, deployment, or Linear completion handoff is part of this integration request.

Base: a616f66200445d64a8a8013673da4bff78bb3b24. Preserved the existing main-scene offsets, scene UID, script UID reference, and node IDs in commit 37c8929 before merging.

The original feature work was uncommitted. Saved it on its original branches:

- codex-local/ALE-10: 352d121, Options button.
- codex-local/ALE-11: ec6577e, See Deck view and navigation.
- codex-local/ALE-12: dbdadf3, Attack card resource, artwork, and presentation.

## Conflict resolutions

Preserve all menu buttons in order: Start, Options, See Deck, Quit. Update actual Tab/Shift+Tab traversal tests for that combined order. Keep all original feature tests except assertions superseded by the combined behavior.

The original See Deck empty state conflicts with the newly designed Attack card. Display the existing reusable Attack scene in See Deck, retaining Back navigation and the planned 20-card explanation. Show no invented cards or inferred duplicate counts. Reduce deck heading/spacing so the card and Back button fit the viewport; assert bounds and canonical displayed card data on repeated navigation.

Remove pre-existing nested conflict markers in docs/architecture.md, preserving the background and startup implementation descriptions and adding the merged features. Update README and current game-design implementation notes to match the combined code.

## Validation

- Passed: node scripts/validate.mjs --repository.
- Passed: node scripts/validate.mjs, 69 checks and ROGUEDECK_SMOKE_OK. Includes merged keyboard traversal, repeated deck navigation, canonical Attack display, viewport fit, standalone card presentation, and retained background/menu checks.
- Passed: node scripts/build.mjs, fresh Windows export and exported executable ROGUEDECK_SMOKE_OK. Output: artifacts/windows/RogueDeck.exe.
- Passed: git diff --check and repository scan for conflict-marker lines.
- Runtime checks used the configured Godot 4.7.2 executable with approved normal certificate-store/settings access outside the restricted sandbox. Logs are in artifacts/logs/tests.log, startup.log, export.log, and export-smoke.log.
- Final Git ancestry, clean worktree, and unmerged-index checks are recorded in the durable local integration record under .linear-local after the merge commit.

Human playtest remains: inspect Start / Options / See Deck / Quit, open See Deck and verify the visible Attack card, use Back, and exercise mouse/keyboard navigation. Start and Options remain placeholders. No independent review is claimed.

## Historical task evidence

The per-ticket specifications retain their original run evidence and Linear statuses. Their historical statements that work was uncommitted or the deck was empty describe the individual branch runs. This integration document records the subsequent user-authorized commits and combined behavior. No independent review or human playtest is claimed.
