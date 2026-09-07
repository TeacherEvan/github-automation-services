# Customization

The bot ships with sensible defaults but every part of the classification
pipeline is editable. This guide walks through the four most common
customizations.

## 1. Swap the model

The default `gpt-4o-mini` is the cheapest viable option. To switch:

```yaml
body: |
  {
    "model": "gpt-4.1-nano",   # was "gpt-4o-mini"
    "messages": [ ... ]
  }
```

Trade-offs: `gpt-4.1-nano` is cheaper but slightly less accurate on edge
cases (multi-class issues, ambiguous priority). `gpt-4o` is the most
accurate but ~30× the cost.

When to upgrade: if you see repeated misclassification of P0/P1 issues
into lower priorities.

## 2. Extend the label set

The default label vocabulary is hard-coded in the system prompt. To add
your own labels (e.g. `area: payments`, `team: platform`):

1. Edit the system prompt in `workflows/issue-triage-bot.yml`:
   ```yaml
   content: `You are a GitHub issue triage assistant. …
   Available labels:
   - Type: bug, feature, documentation, question, enhancement
   - Priority: P0-critical, P1-high, P2-medium, P3-low
   - Area: frontend, backend, api, infrastructure, security, performance,
           payments          # ← added
   - Team: platform, backend   # ← added
   - Status: needs-triage, needs-info, ready-for-dev, duplicate
   `
   ```
2. Create the new labels in your repo before running the bot:
   ```bash
   gh label create "area: payments" --color "FBCA04" --description "Payments surface"
   gh label create "team: platform" --color "0E8A16" --description "Platform team"
   ```
3. Re-open a test issue and verify the new label appears.

## 3. Custom system prompt (different triage policy)

Replace the system prompt entirely to apply a different policy. Example:
"only flag P0/P1, leave everything else as `needs-triage`":

```yaml
content: `You are a triage assistant for an enterprise monorepo.
Default to conservative prioritization — when in doubt, output P3-low
and add the label "needs-triage". Only use P0-critical for confirmed
outages in production. Respond ONLY with valid JSON:
{
  "labels": [...],
  "priority": "P0-critical|P1-high|P2-medium|P3-low",
  "comment": "..."
}`
```

Always keep the "Respond ONLY with valid JSON" instruction at the end —
the workflow parses the response with `JSON.parse` and a malformed reply
is silently dropped (no labels added).

## 4. Tune concurrency

The canonical workflow uses:

```yaml
concurrency:
  group: issue-${{ github.event.issue.number }}
  cancel-in-progress: true
```

This cancels any earlier in-progress triage run when the same issue gets
edited again — preventing duplicate-label races.

**If you want ALL issues to triage in parallel** (no cancellation, no
grouping), remove the `concurrency:` block. This is fine for low-volume
repos (<100 issues/day) but can hit OpenAI rate limits at high volume.

**If you want to serialize** (one triage at a time across the whole
repo), use:

```yaml
concurrency:
  group: ${{ github.repository }}
  cancel-in-progress: false
```

## 5. Add a custom comment template

The bot's `comment` field is included in the JSON response and posted as
a single issue comment. To prepend a footer like "— triaged by an AI
agent; escalate by replying to this issue":

After the bot's `await github.rest.issues.createComment(...)` call, add:

```js
const original = parsed.comment || '';
await github.rest.issues.updateComment({
  owner: context.repo.owner,
  repo: context.repo.repo,
  comment_id: comment.data.id,
  body: `${original}\n\n---\n_Triaged by an AI agent. Reply to this comment to escalate._`
});
```

This requires capturing the `createComment` return value as `comment`
first — see the canonical workflow for the exact pattern.

## 6. Trigger on additional events

Default trigger: `issues: [opened, edited]`. To also triage when an
issue is **reopened** or **labeled** (e.g. a human labels something as
`needs-triage`):

```yaml
on:
  issues:
    types: [opened, edited, reopened]
  # Run on explicit human request via label
  issue_comment:
    types: [created]
```

Add a guard in the script to skip when `context.payload.action !==
'labeled' || context.payload.label.name !== 'needs-triage'` so the
comment-trigger does not run on every comment.

## 7. Restrict to specific repos / branches

The bot runs in any repo that copies the workflow. To restrict the
workflow file's appearance (organization-level control), move it into a
shared `.github` repository and use `workflow_call`:

```yaml
on:
  workflow_call:
    inputs:
      openai_key:
        required: true
        type: secret
```

Then in each consumer repo:

```yaml
on:
  issues:
    types: [opened]
jobs:
  triage:
    uses: TeacherEvan/github-automation-services/.github/workflows/issue-triage-bot.yml@master
    with:
      openai_key: ${{ secrets.OPENAI_API_KEY }}
```

This requires moving the Action to a callable form — see GitHub's
"Reusable workflows" docs for the contract.
