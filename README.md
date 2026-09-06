# RogueDeck

Repository foundation for a Linear → specification → implementation → GitHub review workflow.

**Current state:** no game project has been initialized. Engine, engine version, target platforms, and game rules still need to be selected. The agent pipeline is documented but not connected or running.

## Start here

Run these commands from this directory (the directory containing `.git`):

```sh
node scripts/bootstrap.mjs
node scripts/validate.mjs --repository
```

The tooling needs Node.js 22 or newer and Git. There are no package dependencies to install. Node is only the repository tooling runtime; it does not dictate the game engine or language.

Once the game is initialized and its commands are configured:

```sh
node scripts/validate.mjs
node scripts/build.mjs
```

Full validation and build intentionally fail while engine configuration is missing. A passing **Repository foundation** CI check only checks the repository scaffolding, not the game.

## Documentation

- [Agent instructions](AGENTS.md)
- [Architecture and engine setup](docs/architecture.md)
- [Game design decisions](docs/game-design.md)
- [Workflow and Linear configuration](docs/development-workflow.md)
- [Ticket specification template](docs/tasks/TEMPLATE.md)
- [Validation configuration](config/validation.json)

## Finish engine setup

1. Choose the engine, exact version, implementation language, and initial target platform.
2. Initialize its project here and commit required project settings, source assets, and stable asset identifiers.
3. Update `.gitignore` for that engine's generated caches. Do not ignore source assets or required metadata.
4. Configure the setup, test, and build commands in `config/validation.json`; document prerequisites and outputs in `docs/architecture.md`.
5. Add a meaningful gameplay regression test and a launch/scene-load smoke check.
6. Verify setup, validation, and build from a fresh checkout on the chosen runner.
7. Add a required game-validation CI job before enabling automatic implementation.

No initial commit or push is performed by these scripts.
