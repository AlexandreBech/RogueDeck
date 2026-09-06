# Local Linear worker

## Queue and routing

The local scheduled task polls every 10 minutes while the computer is on and the Codex desktop app is running. It uses the connected Linear plugin; a second MCP connection is unnecessary.

To queue a RogueDeck ticket in team **AlexBech (ALE)**:

1. Assign it to **alexandre bech**.
2. Clear the **Codex** delegate so cloud and local agents do not work on it together.
3. Add **codex-local** and set its status to **Ready**.

The existing `agent-ready` label does not opt a ticket into local work. Existing tickets are not automatically migrated. There are no Linear projects in the connected workspace, so this dedicated label maps ALE tickets to this repository. Use it only for RogueDeck.

Team ID: `9052fbb5-ced6-436d-8510-8426d0540aad`. Assignee ID: `ee7f1244-da6e-499c-bf09-320e20a29077`. Label ID: `7a44f52c-d944-49d0-bcee-b24d0c5b737a`.

## Execution

The saved desktop project is the parent folder. The actual Git repository is `C:/Users/Alexandre/Documents/GameDev/RogueDeck/RogueDeck`. The worker must explicitly use that repository.

The scheduled prompt is the executable operating procedure. It processes at most one ticket per run, uses a shared filesystem lock and durable per-issue records under `C:/Users/Alexandre/Documents/GameDev/RogueDeck/.linear-local`, and creates ticket worktrees under that state directory. Worktrees start from the local repository's recorded HEAD, not automatically from remote main. Uncommitted work in the main checkout is not included or changed.

The worker rechecks eligibility before claiming, records the original requirements and base commit, moves the ticket through Planning and Implementing, and writes a specification before changing implementation. This lightweight local workflow allows an uncommitted specification and implementation in the same run; the future multi-stage controller contract is separate.

Required repository checks apply. Runtime changes also require the configured game validation and Windows build. For tools installed only in the main checkout, resolve the configured Godot executable to an absolute path and supply GODOT_BIN to the worktree commands; do not copy credentials or generated caches. Missing tools or failed checks block completion.

On success, post the completion evidence to the original Linear issue, then move it to In Review and verify. Record the comment ID, worktree path, base commit, and test results. Changes stay local and uncommitted for human review. No automatic PR publishing, merging, deployment, or Done transition is enabled.

## Recovery and review

Inspect the reported worktree to review or commit the changes. In Review means required checks passed and human review remains; it does not mean independent review or playtesting passed.

Needs Input means requirements need clarification. Failed means execution or validation failed. Neither is automatically retried. The state record prevents the same ticket from being implemented twice, including after a partial Linear handoff. A stale repository lock or incomplete run requires recovery rather than starting another implementation. Ask Codex to inspect the saved record and worktree before retrying; never delete a lock while its run is active.

Remove the label or change the status to prevent future pickup. Pause the scheduled task to stop new runs. Changes to eligibility during an active run cause the worker to stop and preserve evidence before further implementation. The local lock coordinates this worker only; it does not provide an atomic claim against unrelated cloud agents or external controllers.

This setup does not migrate or cancel already running cloud tasks. To opt an existing ticket in, first ensure its cloud run has stopped, then clear its delegate and apply the queue conditions above.
