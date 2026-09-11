# Issue Triage Bot - Setup Guide

## Overview
Automatically analyze, label, and prioritize GitHub issues using AI. Saves 5-10 hours/week for busy repositories.

## Features
- ✅ **Automatic Labeling:** Categorizes issues by type (bug/feature/docs)
- ✅ **Priority Assignment:** P0-critical → P3-low based on severity
- ✅ **Area Detection:** Identifies affected components (frontend/backend/API)
- ✅ **Duplicate Detection:** Flags potential duplicate issues
- ✅ **Team Routing:** Suggests which team should handle the issue
- ✅ **Smart Comments:** Adds AI analysis directly to the issue

## Value Proposition
**Time Saved:** 5-10 hours/week on manual triage  
**Cost Savings:** $500-$1,000/month in developer time (at $100/hr)  
**Response Speed:** Issues categorized in <30 seconds vs hours/days  
**Consistency:** Every issue gets the same quality analysis

## Installation

### Prerequisites
- GitHub repository with Issues enabled
- OpenAI API key (get free tier at platform.openai.com)
- GitHub Actions enabled

### Step 1: Add Workflow File
The canonical, hardened deployment copy lives at `.github/workflows/issue-triage-bot.yml` in this
repo. The `workflows/issue-triage-bot.yml` file in this repo is the upstream template.

1. In your own repo, create `.github/workflows/` if it doesn't exist
2. Copy `.github/workflows/issue-triage-bot.yml` from this repo into your `.github/workflows/`
3. (Optional) Customize the system prompt, model, or allowlist for your team — see Customization
4. Commit and push to your default branch

### Step 2: Configure Secrets
1. Go to repo Settings → Secrets and variables → Actions
2. Add `OPENAI_API_KEY` with your OpenAI API key
3. (GitHub token is automatically provided)

### Step 3: Create Labels
Run this script to create all required labels:

```bash
# Bug/Feature types
gh label create "bug" --color "d73a4a" --description "Something isn't working" --force
gh label create "feature" --color "0e8a16" --description "New feature request" --force
gh label create "documentation" --color "0075ca" --description "Documentation improvements" --force
gh label create "question" --color "d876e3" --description "Question or discussion" --force
gh label create "enhancement" --color "84b6eb" --description "Enhancement to existing feature" --force

# Priorities
gh label create "P0-critical" --color "b60205" --description "Critical - needs immediate attention" --force
gh label create "P1-high" --color "d93f0b" --description "High priority" --force
gh label create "P2-medium" --color "fbca04" --description "Medium priority" --force
gh label create "P3-low" --color "0e8a16" --description "Low priority" --force

# Areas
gh label create "frontend" --color "5319e7" --description "Frontend related" --force
gh label create "backend" --color "1d76db" --description "Backend related" --force
gh label create "api" --color "0052cc" --description "API related" --force
gh label create "infrastructure" --color "006b75" --description "Infrastructure/DevOps" --force
gh label create "security" --color "b60205" --description "Security related" --force
gh label create "performance" --color "fbca04" --description "Performance optimization" --force

# Status
gh label create "needs-triage" --color "ededed" --description "Awaiting triage" --force
gh label create "needs-info" --color "d4c5f9" --description "Needs more information" --force
gh label create "ready-for-dev" --color "0e8a16" --description "Ready for development" --force
gh label create "duplicate" --color "cfd3d7" --description "Duplicate issue" --force
```

### Step 4: Test
1. Create a test issue in your repo
2. Watch the Actions tab - workflow should trigger automatically
3. Issue should be labeled and commented within 30-60 seconds

## Customization

### Adjust AI Behavior
Edit the `system` prompt in `issue-triage-bot.yml` lines 38-56 to:
- Add/remove label categories
- Change priority thresholds
- Modify team routing logic
- Add custom business rules

### Change AI Model
Line 61: Replace `gpt-4o-mini` with:
- `gpt-4o` for better accuracy (more expensive)
- `gpt-3.5-turbo` for lower cost
- `claude-3-5-sonnet-latest` if using Anthropic

### Filter Specific Issues
Add conditions to only triage certain issues:

```yaml
on:
  issues:
    types: [opened]
    # Only triage issues with specific labels
    # or from specific users, etc.
```

## Cost Analysis

### OpenAI API Costs (GPT-4o-mini)
- **Input:** ~$0.15 per 1M tokens
- **Output:** ~$0.60 per 1M tokens
- **Per Issue:** ~500 tokens average = $0.0003 per issue
- **Monthly (100 issues):** ~$0.03

**Total Monthly Cost:** < $1 for most repos (vs $500-1,000 in time saved)

## Troubleshooting

### Workflow Not Triggering
- Check Actions tab for error messages
- Verify workflow file is in `.github/workflows/`
- Ensure file name ends in `.yml` or `.yaml`

### API Key Errors
- Verify `OPENAI_API_KEY` secret is set correctly
- Check API key has sufficient credits
- Ensure key starts with `sk-`

### Labels Not Applied
- Verify labels exist in repo (run setup script)
- Check workflow has `issues: write` permission
- Review Actions logs for specific errors

### AI Analysis Quality Issues
- Increase `temperature` (line 62) for more creative responses (0.3 → 0.7)
- Switch to `gpt-4o` for better accuracy
- Refine system prompt with repo-specific context

## Advanced Features

### Integration with Project Boards
Add this to automatically add triaged issues to projects:

```yaml
- name: Add to Project Board
  if: contains(steps.analyze.outputs.labels, 'ready-for-dev')
  run: |
    gh issue edit ${{ github.event.issue.number }} \
      --add-project "Development Pipeline"
```

### Slack/Discord Notifications
Add webhook integration:

```yaml
- name: Notify Team
  if: contains(steps.analyze.outputs.priority, 'P0-critical')
  env:
    SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
  run: |
    curl -X POST $SLACK_WEBHOOK \
      -d '{"text":"🚨 Critical issue: #${{ github.event.issue.number }}"}'
```

### Auto-Assignment
Automatically assign issues to team members:

```yaml
- name: Auto-assign
  run: |
    if [[ "${{ steps.analyze.outputs.labels }}" == *"backend"* ]]; then
      gh issue edit ${{ github.event.issue.number }} \
        --add-assignee "backend-team"
    fi
```

## Support & Customization

Need help setting this up? We offer:
- **DIY Package:** $99 - Workflow + documentation (you set it up)
- **Managed Setup:** $500 - We configure everything in your repo
- **Full Service:** $1,500 setup + $100/month - Setup + ongoing optimization + custom features

Contact: [Your contact info here]

---

## License
MIT License - Free to use and modify

## Credits
Built with ❤️ using GitHub Actions + OpenAI API
