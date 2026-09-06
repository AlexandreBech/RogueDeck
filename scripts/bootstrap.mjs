import { main, foundation, config, run } from './common.mjs';

main(() => {
  if (process.argv.length > 2) throw new Error('Usage: node scripts/bootstrap.mjs');
  run({ command: 'git', args: ['--version'] }, 30);
  foundation();
  const value = config();
  if (!value.engine) {
    console.log('Repository tooling is ready. Engine setup is pending; full validation/build will fail until configured.');
  } else if (value.setup) {
    run(value.setup, value.timeoutSeconds);
  } else {
    console.log('No automated engine setup configured. Provision the pinned engine using docs/architecture.md.');
  }
});
