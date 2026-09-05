# Security Policy

## Supported Versions

| Component                                | Supported          |
|------------------------------------------|--------------------|
| `.github/workflows/issue-triage-bot.yml` | latest             |
| `workflows/issue-triage-bot.yml`         | upstream template  |

## Secrets Used by This Workflow

The `AI Issue Triage Bot` workflow reads the following secrets:

| Secret          | Source                            | Purpose                                              |
|-----------------|-----------------------------------|------------------------------------------------------|
| `OPENAI_API_KEY`| repo Settings → Secrets → Actions | authenticates Chat Completions calls to OpenAI        |
| `GITHUB_TOKEN`  | auto-provided per run             | authenticates GitHub REST calls (`issues.*`)         |

`GITHUB_TOKEN` is scoped by the workflow's `permissions:` block to `issues: write` only.
The workflow does NOT request `contents: read` (it does not read repo contents) and does NOT
request any write to `contents`, `pull-requests`, `packages`, `id-token`, or other scopes.

## Output Validation (Label Injection Mitigation)

LLM-generated output is treated as untrusted. Before the workflow calls `issues.addLabels`:

1. Every label returned by the model is filtered through `ALLOWED_LABELS` (a closed set defined
   inline in the workflow). Any label outside the set is silently dropped.
2. The `priority` field is filtered through `ALLOWED_PRIORITIES` (`P0-critical`, `P1-high`,
   `P2-medium`, `P3-low`). A disallowed priority causes the run to fail with `core.setFailed`.

This prevents a compromised or hallucinating model from injecting arbitrary label slugs into
the issue tracker.

## Action Pinning

All third-party actions are pinned to a 40-character commit SHA (`actions/checkout`,
`actions/setup-node`, `actions/github-script`). Mutable major-version tags (`@v4`, `@v7`) are
NOT used — see `.github/workflows/issue-triage-bot.yml`.

## Reporting a Vulnerability

Please open a private security advisory on GitHub:

  https://github.com/TeacherEvan/github-automation-services/security/advisories/new

Or email the maintainer: see the GitHub profile for the address on file.

Please DO NOT file a public issue for suspected vulnerabilities.
