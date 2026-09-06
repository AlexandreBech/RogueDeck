# RogueDeck

RogueDeck is a roguelike deck builder built around upgrading a fixed deck. Each run starts with the same 20 cards; cards cannot be added or removed. Victory rewards can upgrade card statistics or add effects. The exact meaning of “3 different upgrade” needs clarification before implementation.

## Start here

Read [game design](docs/game-design.md), [architecture and setup](docs/architecture.md), [agent instructions](AGENTS.md), and the relevant [ticket specification](docs/tasks/ALE-6.md).

Workspace snapshot, 2026-09-06: a Godot startup screen offers Start, Options, See Deck, and Quit. Start and Options are placeholders; combat and settings screens are not implemented. The first card design, Attack, is available in the deck view. Upgrades, runs, and saves remain unimplemented.

**See Deck** displays the designed **Attack** card and explains that the planned starting deck contains 20 cards. **Back** returns to the menu and restores keyboard focus. Undesigned cards are not displayed; the full deck composition is still unspecified.

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

ALE-12 adds the first card definition: **Attack**, costing **1 mana** and dealing **1 damage**, in `rogue-deck/cards/attack.tres`. Its reusable view is `rogue-deck/scenes/attack_card.tscn`. Open See Deck from the menu, or open `rogue-deck/scenes/card_preview.tscn` and press F6 in Godot to inspect the design. The sword SVG is original project artwork. The card records base statistics and displays them; combat, mana spending, and deck composition remain future work. See [ALE-12 specification](docs/tasks/ALE-12.md) for its original validation evidence and [merge integration](docs/tasks/local-branch-integration.md) for the combined result.
