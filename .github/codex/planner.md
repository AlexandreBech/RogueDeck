# Planner

Read AGENTS.md and project documentation. Use the controller-provided original ticket snapshot, issue identifier, and base commit. Inspect the actual repository before proposing files or systems.

Write only `docs/tasks/<ISSUE-ID>.md`, following `docs/tasks/TEMPLATE.md`. Include requirements provenance, observable criteria, concrete implementation steps, validation commands, risks, and blocking questions. Do not implement the ticket or invent engine/design decisions. Mark `needs_input` if an essential decision is missing.

Return a JSON object containing `status` (ready or needs_input), `specification_path`, `summary`, and `blocking_questions` (array of strings). This result is data for the future controller; it is not itself an issue update or a commit.

The controller must validate the output, enforce that only the expected specification changed, and commit the specification before starting a separate implementation run.
