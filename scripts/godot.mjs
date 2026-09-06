import { existsSync, readFileSync, mkdirSync, mkdtempSync, statSync, copyFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { spawnSync } from 'node:child_process';
import { root, main, config } from './common.mjs';

main(() => {
  const stage = process.argv[2];
  if (process.argv.length !== 3 || !['import', 'test', 'build'].includes(stage)) {
    throw new Error('Usage: node scripts/godot.mjs import|test|build');
  }
  const settings = config();
  const localPath = resolve(root, 'config/godot.local.json');
  const local = existsSync(localPath) ? JSON.parse(readFileSync(localPath, 'utf8')) : {};
  const toolPath = resolve(root, `.tools/Godot_v${settings.engine.version}-stable_win64_console.exe`);
  const executable = process.env.GODOT_BIN || local.executable || (existsSync(toolPath) ? toolPath : 'godot');
  const project = dirname(resolve(root, settings.engine.projectFile));
  const logs = resolve(root, 'artifacts/logs');
  mkdirSync(logs, { recursive: true });

  function invoke(binary, args, marker) {
    const result = spawnSync(binary, args, {
      cwd: root, encoding: 'utf8', shell: false, windowsHide: true,
      timeout: settings.timeoutSeconds * 1000, maxBuffer: 16 * 1024 * 1024,
    });
    const output = (result.stdout || '') + (result.stderr || '');
    process.stdout.write(output);
    if (result.error) throw new Error(`Godot execution failed: ${result.error.message}. Set GODOT_BIN to the pinned editor executable.`);
    if (result.status !== 0 || /(?:^|\n)(?:SCRIPT ERROR|ERROR):/m.test(output)) {
      throw new Error(`Godot reported an error (exit ${result.status}).`);
    }
    if (marker && !output.includes(marker)) throw new Error(`Godot did not report ${marker}.`);
    return output.trim();
  }

  const version = invoke(executable, ['--version']);
  if (!version.startsWith(`${settings.engine.version}.stable.`)) {
    throw new Error(`Expected Godot ${settings.engine.version} stable; got ${version}.`);
  }
  function editor(args, label, marker) {
    return invoke(executable, ['--headless', '--path', project, '--log-file', resolve(logs, `${label}.log`), ...args], marker);
  }
  editor(['--import'], 'import');
  if (stage === 'test') {
    editor(['--script', 'res://tests/test_main.gd'], 'tests', 'ROGUEDECK_TESTS_OK');
    editor(['--', '--smoke-test'], 'startup', 'ROGUEDECK_SMOKE_OK');
  }
  if (stage === 'build') {
    // Export into a new directory so a stale binary cannot satisfy the build check.
    const builds = resolve(root, 'artifacts/builds');
    mkdirSync(builds, { recursive: true });
    const output = resolve(mkdtempSync(resolve(builds, 'windows-')), 'RogueDeck.exe');
    editor(['--export-release', 'Windows Desktop', output], 'export');
    if (!existsSync(output) || statSync(output).size < 1024) throw new Error('Windows export did not produce a valid-size executable.');
    if (process.platform === 'win32') {
      invoke(output, ['--headless', '--log-file', resolve(logs, 'export-smoke.log'), '--', '--smoke-test'], 'ROGUEDECK_SMOKE_OK');
    } else {
      console.log('Windows executable launch was not tested on this non-Windows host.');
    }
    const destination = resolve(root, 'artifacts/windows');
    mkdirSync(destination, { recursive: true });
    copyFileSync(output, resolve(destination, 'RogueDeck.exe'));
    console.log(`Windows build: ${resolve(destination, 'RogueDeck.exe')}`);
  }
});
