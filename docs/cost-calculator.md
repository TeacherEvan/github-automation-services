# API Cost Calculator

How much does the AI Issue Triage Bot actually cost?

## Per-issue cost (model = `gpt-4o-mini`)

The bot sends one chat completion request per issue. Two messages: a system
prompt (~280 tokens) and the issue body (variable, typically 200–1500 tokens
combined for title + body).

| Component | Tokens | Notes |
|---|---|---|
| System prompt | ~280 | Fixed per request |
| Title | ~10–50 | One sentence |
| Body | ~150–1450 | Markdown; issues with logs/code are larger |
| JSON response | ~120 | Fixed-shape reply |
| **Total (input)** | **~440–1780** | Billed at input rate |
| **Output** | **~120** | Billed at output rate |

`gpt-4o-mini` pricing (as of the README's publication date):
- Input: $0.15 / 1M tokens
- Output: $0.60 / 1M tokens

## Worked examples

### Small team, 100 issues / month
- Avg input: 700 tokens × 100 = 70,000 tokens → **$0.0105**
- Output: 120 × 100 = 12,000 tokens → **$0.0072**
- **Monthly: ~$0.018** (essentially free)

### Mid-size team, 1,000 issues / month
- Avg input: 700 tokens × 1,000 = 700,000 tokens → **$0.105**
- Output: 120 × 1,000 = 120,000 tokens → **$0.072**
- **Monthly: ~$0.18**

### Heavy team, 10,000 issues / month
- Avg input: 700 × 10,000 = 7,000,000 tokens → **$1.05**
- Output: 120 × 10,000 = 1,200,000 tokens → **$0.72**
- **Monthly: ~$1.77**

### Pathological: a 5,000-token issue (full stack trace dump)
- Input: 5,280 × $0.15 / 1M = $0.00079
- Output: 120 × $0.60 / 1M = $0.000072
- Per issue: **$0.00086** (less than a tenth of a cent)

## Switching models

If you swap `gpt-4o-mini` for another model in the workflow's `body.model`
field, update this table:

| Model | Input $/1M | Output $/1M | Notes |
|---|---|---|---|
| `gpt-4o-mini` | 0.15 | 0.60 | Default; classification is easy |
| `gpt-4.1-nano` | 0.10 | 0.40 | Cheaper, slightly less accurate |
| `gpt-4o` | 2.50 | 10.00 | Overkill for triage; ~30× cost |
| `gpt-5-mini` | 0.25 | 2.00 | Newer; verify availability |

For most teams, `gpt-4o-mini` is the right choice — classification is a
trivial task for any frontier model and the cost difference at this volume
is rounding error.

## GitHub Actions cost

The workflow runs in ~3–8 seconds per issue on `ubuntu-latest`. Free tier
allows 2,000 minutes/month — at 8 seconds per run that's **15,000 issues**
per month before Actions minutes cost anything.

For private repos on a paid plan, 50,000 minutes/month are included.

## Total monthly cost (rule of thumb)

| Issue volume | OpenAI | Actions | Total |
|---|---|---|---|
| 100 | $0.02 | $0 | **$0.02** |
| 1,000 | $0.18 | $0 | **$0.18** |
| 10,000 | $1.77 | $0 (within free tier) | **$1.77** |
| 50,000 | $8.85 | $0 (within free tier) | **$8.85** |
| 100,000 | $17.70 | ~$0.50 (over free tier) | **~$18** |

The README's claim of "<$5/month for most teams" matches the ≤10,000
issues/month tier.

## Reducing cost further

1. **Cache the system prompt** — OpenAI's automatic prefix caching means
   repeated system-prompt prefixes do not re-bill. The bot already benefits
   from this since the prompt is identical across issues.
2. **Truncate issue bodies** before sending — issues with full stack traces
   can be clipped to the first 2,000 chars without losing classification
   signal.
3. **Skip on bot authors** — add `if: github.actor != 'dependabot[bot]'`
   to the trigger so dependency-update PRs don't generate triage requests.
