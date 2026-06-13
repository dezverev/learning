# AGENTS.md

## GitHub Workflow

- Use the GitHub CLI (`gh`) for pull request operations in this repo, including
  `gh pr create`, `gh pr view`, `gh pr checks`, and `gh pr merge`.
- Do not use the GitHub app/connector for PR creation or merge operations unless
  the user explicitly asks for it.
- Use normal `git` commands for local branch, staging, commit, and push work.
- Before opening or merging a PR, run the relevant Cargo checks and include the
  validation commands in the PR body or summary.
- If `gh` is missing or not authenticated, ask the user to install or authenticate
  it before continuing with PR operations.
