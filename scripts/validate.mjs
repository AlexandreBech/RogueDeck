import { main, foundation, gameStage } from './common.mjs';

main(() => {
  const args = process.argv.slice(2);
  if (args.length > 1 || (args.length === 1 && args[0] !== '--repository')) {
    throw new Error('Usage: node scripts/validate.mjs [--repository]');
  }
  foundation();
  if (args.length === 0) gameStage('test');
});
