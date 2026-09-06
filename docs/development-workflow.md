# Development workflow

## Current setup

GitHub repository: `AlexandreBech/RogueDeck`.

Linear workspace/team: AlexBech, team key `ALE`, team ID `9052fbb5-ced6-436d-8510-8426d0540aad`.

The statuses and workspace label below have been created in Linear. The [local Codex worker](local-codex-worker.md) provides scheduled opt-in pickup using Ready + codex-local + assignment to Alexandre and no cloud delegate. The controller, webhook, PR publisher, and independent review gate described below remain future work. The repository foundation CI runs only after these files are committed and pushed to GitHub.

Direct agents working on an authorized ticket must automatically post a completion comment and move that ticket to **In Review**, following AGENTS.md's Required Linear completion handoff. This is an agent instruction using connected Linear write tools, not a background trigger. If write tools are unavailable, the agent must report the handoff as incomplete and preserve the prepared comment. In future controller-managed runs, the controller is the sole writer.

## Pickup condition

For the future controller, an eligible issue must belong to the configured team/project, have status **Ready**, and carry **agent-ready**. Its project mapping still needs configuration. The active local worker instead uses the dedicated queue documented above; agent-ready alone never triggers local pickup. Existing tickets are not automatically opted in.

| Status | ID | Meaning |
| --- | --- | --- |
| Backlog | ea1c839b-1e62-410b-bf8b-5fcd854d01d9 | Ideas not ready for pickup |
| Ready | c7faf166-3037-4592-8802-291e19bfd5a4 | Eligible when labeled |
| Planning | 5d2ee1c0-cecb-4629-8038-aabbc3a8e805 | Specification being written |
| Implementing | 15cd53a3-b14c-4082-b570-051bff2f6a2a | Code and tests being changed |
| In Review | 4c5541f6-a21f-40a3-8dba-56f63bf02874 | Implementation and required checks complete; awaiting review (local work or PR) |
| Ready to Playtest | d1303cf8-5962-4ab9-ac46-8e03a8872d5a | Automated stages passed; human checks remain |
| Needs Input | 2a21468c-0621-49a7-9068-eb8899f5ed5c | Blocking requirement or decision |
| Failed | 85867fe5-5910-4f2b-ac92-b52973a9848b | Execution stopped; inspect before retry |
| Done | b805d13e-f7c1-4d12-9231-334e71504cb1 | PR merged |

Label ID: `4a384a61-5463-4d46-bd29-62579038c402`. IDs are workspace-specific and should be revalidated during integration. Existing Todo, In Progress, Canceled, and Duplicate states remain available. Failed and Needs Input use Linear's Started category; neither marks the issue complete.

## Handoff contract

1. Controller fetches the latest ticket, checks eligibility, and atomically claims the issue/revision.
2. Create an isolated checkout and branch from a recorded base commit. Snapshot original requirements.
3. Planner uses `.github/codex/planner.md` and writes `docs/tasks/ALE-123.md` for the corresponding real ticket.
4. Validate the planner result and allowed file diff. Commit the specification before implementation.
5. Start a fresh implementation conversation with `.github/codex/implementer.md`, the original snapshot, and the committed specification.
6. Run configured game validation and build, then publish one branch/PR per ticket.
   After successful implementation and required checks, the controller posts a completion comment to the original issue, moves it to In Review, and verifies the status. For direct local work, the agent performs these writes and states explicitly if there is no commit or PR. Documentation-only tickets require repository validation and a diff check rather than a gameplay test. Follow the retry, changed-requirement, and terminal-state rules in AGENTS.md. Do not advance blocked or failed work.
7. Review the exact head commit in a fresh conversation using `.github/codex/reviewer.md`.
8. If changes are required, repair the same branch and repeat validation/review, with at most two repair rounds initially.
9. Mark Ready to Playtest only with passing game checks and a current review. Mark Done on merge, not on PR creation.

## Controls to implement in the controller

- Verify webhook authenticity and freshness, durably queue deliveries, and deduplicate delivery IDs.
- Ignore the controller's own updates; keep a per-issue claim and record branch, PR, stage, revision, attempts, and reviewed commit.
- Record the completion comment reference, implementation revision, and verified In Review status. Post the comment before changing status; on partial failure resume only the missing step after checking remote state. Never report a successful handoff when either write is unverified.
- Detect requirement changes during a run and require replanning when material.
- Validate structured agent results against stage-specific schemas. Prompt instructions are not schema enforcement.
- Enforce planner path restrictions outside the agent. Load execution policy/prompts from a trusted revision.
- Keep publishing credentials out of agent execution environments. Do not execute untrusted PR code in a privileged publisher job.
- Fail on missing outputs, crashes, timeouts, unconfigured game checks, or exhausted retries.
- Invalidate review verdicts on new commits and reconcile missed deliveries with durable state.
- Start with one active implementation per repository. Keep merging and deployment manual.

## First end-to-end trial

After engine setup, run a small real ticket manually through all three prompts. Confirm a committed specification, meaningful regression test, successful build, independent findings, and playtest instructions. Then implement manual-dispatch orchestration before connecting Linear events.

## References

- [Codex repository instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [Codex GitHub Action](https://learn.chatgpt.com/docs/github-action)
- [Linear webhooks](https://linear.app/developers/webhooks)
- [GitHub workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax)
