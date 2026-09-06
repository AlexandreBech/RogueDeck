# RogueDeck

RogueDeck is a roguelike deck builder built around upgrading a fixed deck. Each run starts with the same 20 cards; cards cannot be added or removed. Victory rewards can upgrade card statistics or add effects. The exact meaning of “3 different upgrade” needs clarification before implementation.

## Start here

Read [game design](docs/game-design.md), [architecture and setup](docs/architecture.md), [agent instructions](AGENTS.md), and the relevant [ticket specification](docs/tasks/ALE-6.md).

Workspace snapshot, 2026-09-06: a local Godot startup screen, Start, Options, and Quit buttons, scene tests, and Windows export configuration exist. Options is a menu placeholder; no settings screen or activation behavior is implemented yet. The Start button has no gameplay destination because combat, cards, upgrades, runs, and saves are not implemented. The engine setup was already uncommitted when ALE-6 began; base commit `1d2eff5` contains workflow scaffolding only. Verify the checkout before relying on this snapshot.

Use Node.js 22+, Git, and the configured Godot 4.7.2 stable editor. Run from the repository directory containing AGENTS.md and .git:

```sh
node scripts/validate.mjs --repository
node scripts/bootstrap.mjs
node scripts/validate.mjs
node scripts/build.mjs
```

Foundation validation checks repository structure only. Bootstrap imports the configured project. Full validation checks startup UI and scene loading, not gameplay. Build exports Windows x86_64; setup details and limitations are in architecture.

The intended workflow is Linear ticket → specification → implementation → independent GitHub review → human playtest. The [local Codex worker](docs/local-codex-worker.md) polls tickets assigned to Alexandre with Ready + codex-local and no cloud delegate. It prepares local changes in a separate worktree for human review. The [future controller workflow](docs/development-workflow.md) remains separate; publishing and merging remain manual.

After finishing an authorized ticket and its required checks, the agent automatically comments on the Linear ticket with the changes and validation evidence, then moves it to **In Review**. This uses connected Linear write tools; unavailable access or failed updates must be reported explicitly. Background pickup is limited to the local queue described above.

Next gameplay tickets must define card data, combat, and upgrade reward semantics. The local CI workflow now includes Godot tests and a Windows build; a successful hosted run has not been verified for this ticket.
