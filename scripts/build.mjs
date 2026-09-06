import { main, foundation, gameStage } from './common.mjs';

main(() => {
  if (process.argv.length > 2) throw new Error('Usage: node scripts/build.mjs');
  foundation();
  gameStage('build');
});
