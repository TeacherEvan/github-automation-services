# Troubleshooting

Common failure modes and fixes for the AI Issue Triage Bot.

## 1. Workflow run fails immediately with "OpenAI API key not found"

**Symptom:** Job log shows `Error: OPENAI_API_KEY is not set` or `401 Unauthorized`.

**Cause:** The `OPENAI_API_KEY` secret has not been added to the repository, or
it was added at the org level without inheritance.

**Fix:**
1. Go to **Settings → Secrets and variables → Actions → New repository secret**.
2. Name: `OPENAI_API_KEY` (exact case).
3. Paste your OpenAI API key (starts with `sk-…`).
4. Re-open an issue to trigger the workflow.

Verify with: `gh secret list --repo <owner>/<repo>` — the key must appear.

## 2. Labels are not applied to the issue

**Symptom:** Workflow succeeds but the issue has no new labels.

**Cause:** The bot tries to add labels that do not exist in the target repo.
The default label set (`bug`, `feature`, `P0-critical`, etc.) must be created
first.

**Fix:**
```bash
curl -fsSL https://raw.githubusercontent.com/TeacherEvan/github-automation-services/master/scripts/setup-labels.sh | bash
```
If running from a fork, replace the URL with your fork's raw URL.

## 3. "Resource not accessible by integration" on label add

**Symptom:** `403 Forbidden` when calling `issues.addLabels`.

**Cause:** The workflow's `GITHUB_TOKEN` lacks `issues: write` permission. This
happens when the canonical YAML's `permissions:` block is removed or overridden.

**Fix:** Keep the `permissions:` block at the top of the workflow:
```yaml
permissions:
  issues: write
  contents: read
```
Do not set a top-level `permissions: read-all` — that strips write access.

## 4. OpenAI 429 / rate-limit errors

**Symptom:** Log shows `429 Too Many Requests` or `Rate limit reached`.

**Cause:** Free-tier OpenAI keys have strict per-minute limits.

**Fix:**
- Move to a paid OpenAI account (tier 1+ removes most limits).
- Reduce concurrent issues by adding to the workflow's `concurrency:` block:
  ```yaml
  concurrency:
    group: issue-${{ github.event.issue.number }}
    cancel-in-progress: true
  ```
  The canonical copy already includes this — do not delete it.
- Switch to a smaller model in the OpenAI call (`gpt-4o-mini` → `gpt-4.1-nano`).

## 5. Workflow file does not parse after copying

**Symptom:** GitHub rejects the file as "Invalid workflow file".

**Cause:** Tab characters, smart quotes, or trailing whitespace were introduced
during copy/paste.

**Fix:**
```bash
curl -fsSL https://raw.githubusercontent.com/TeacherEvan/github-automation-services/master/workflows/issue-triage-bot.yml \
  -o .github/workflows/issue-triage-bot.yml
```
Re-fetch from `master` (not your fork) to ensure you get the pinned, hardened
copy. Validate locally with:
```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/issue-triage-bot.yml'))"
```

## 6. Bot classifies every issue as `P3-low` / `question`

**Symptom:** All issues get deprioritized — usually because the system prompt
example is treated as the only signal.

**Fix:** Open an issue with a structured body (error logs, expected vs actual,
repro steps). The model uses both title and body — a one-line title is not
enough context to assign P0/P1 confidently.

## 7. Action run hangs / never completes

**Symptom:** Job shows the yellow dot forever, no log output.

**Cause:** Either OpenAI is unreachable from the runner, or a network egress
proxy is blocking `api.openai.com`.

**Fix:** Re-run with debug logging — add `ACTIONS_STEP_DEBUG: true` to the
repository's Actions secrets. Then check whether the `fetch` call to
`api.openai.com` times out. On self-hosted runners, allow egress to
`api.openai.com:443` from the runner subnet.

## 8. Duplicate-label spam from rapid edits

**Symptom:** The same labels are added repeatedly when an issue is edited.

**Fix:** The canonical workflow already deduplicates via
`addLabels({ labels: [...new Set([...existing, ...proposed])] })`. If you have
forked and removed that block, restore it. The fix is in the system prompt
"Respond ONLY with valid JSON" — parse failures silently fall back to no-op,
which prevents partial adds.
