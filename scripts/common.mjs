import { readFileSync, statSync } from 'node:fs';
import { dirname, resolve, relative, isAbsolute } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

export const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');

export function main(action) {
  try {
    if (Number(process.versions.node.split('.')[0]) < 22) {
      throw new Error('Repository tooling requires Node.js 22 or newer.');
    }
    action();
  } catch (error) {
    console.error(`ERROR: ${error.message}`);
    process.exitCode = 1;
  }
}

export function config() {
  const value = JSON.parse(readFileSync(resolve(root, 'config/validation.json'), 'utf8'));
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    throw new Error('Validation configuration must be an object.');
  }
  if (!Number.isInteger(value.timeoutSeconds) || value.timeoutSeconds < 1 || value.timeoutSeconds > 7200) {
    throw new Error('timeoutSeconds must be an integer between 1 and 7200.');
  }
  for (const stage of ['setup', 'test', 'build']) {
    if (value[stage] === null) continue;
    commandSpec(value[stage], stage);
  }
  if (value.engine !== null) {
    if (!value.engine || ['name', 'version', 'projectFile'].some(key => typeof value.engine[key] !== 'string' || !value.engine[key].trim())) {
      throw new Error('engine needs name, version, and projectFile strings, or must be null.');
    }
    const path = relative(root, resolve(root, value.engine.projectFile));
    if (isAbsolute(value.engine.projectFile) || path.startsWith('..') || isAbsolute(path)) {
      throw new Error('engine.projectFile must be inside the repository.');
    }
  }
  return value;
}

function commandSpec(spec, stage) {
  if (!spec || typeof spec.command !== 'string' || !spec.command.trim() || !Array.isArray(spec.args) || spec.args.some(arg => typeof arg !== 'string')) {
    throw new Error(`${stage} needs an executable command and an args array of strings, or must be null.`);
  }
}

export function run(spec, timeoutSeconds = 900) {
  commandSpec(spec, 'Command');
  const result = spawnSync(spec.command, spec.args, {
    cwd: root,
    stdio: 'inherit',
    shell: false,
    timeout: timeoutSeconds * 1000,
    windowsHide: true,
  });
  if (result.error) throw new Error(`Could not run ${spec.command}: ${result.error.message}`);
  if (result.status !== 0) throw new Error(`${spec.command} failed (exit ${result.status}, signal ${result.signal ?? 'none'}).`);
}

export function foundation() {
  for (const file of ['README.md', 'AGENTS.md', 'docs/architecture.md', 'docs/game-design.md', 'docs/development-workflow.md', 'docs/tasks/TEMPLATE.md', '.github/codex/planner.md', '.github/codex/implementer.md', '.github/codex/reviewer.md', '.github/pull_request_template.md', '.github/workflows/repository-checks.yml', 'scripts/bootstrap.mjs', 'scripts/validate.mjs', 'scripts/build.mjs']) {
    if (!readFileSync(resolve(root, file), 'utf8').trim()) throw new Error(`Empty required file: ${file}`);
  }
  config();
  console.log('PASS: Repository foundation. This does not validate a game.');
}

export function gameStage(stage) {
  const value = config();
  if (!value.engine) throw new Error('Game engine is not configured. See docs/architecture.md.');
  if (!statSync(resolve(root, value.engine.projectFile)).isFile()) throw new Error('Engine project file is missing.');
  if (!value[stage]) throw new Error(`Game ${stage} command is not configured.`);
  run(value[stage], value.timeoutSeconds);
  console.log(`PASS: Configured game ${stage} command.`);
}
