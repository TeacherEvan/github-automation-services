#!/bin/bash
# GitHub Issue Labels Setup Script
# Creates all labels needed for AI Issue Triage Bot

set -e

echo "🏷️  Setting up GitHub issue labels for AI automation..."
echo ""

# Type labels
echo "Creating type labels..."
gh label create "bug" --color "d73a4a" --description "Something isn't working" --force
gh label create "feature" --color "0e8a16" --description "New feature request" --force
gh label create "documentation" --color "0075ca" --description "Documentation improvements" --force
gh label create "question" --color "d876e3" --description "Question or discussion" --force
gh label create "enhancement" --color "84b6eb" --description "Enhancement to existing feature" --force

# Priority labels
echo "Creating priority labels..."
gh label create "P0-critical" --color "b60205" --description "Critical - needs immediate attention" --force
gh label create "P1-high" --color "d93f0b" --description "High priority" --force
gh label create "P2-medium" --color "fbca04" --description "Medium priority" --force
gh label create "P3-low" --color "0e8a16" --description "Low priority" --force

# Area labels
echo "Creating area labels..."
gh label create "frontend" --color "5319e7" --description "Frontend related" --force
gh label create "backend" --color "1d76db" --description "Backend related" --force
gh label create "api" --color "0052cc" --description "API related" --force
gh label create "infrastructure" --color "006b75" --description "Infrastructure/DevOps" --force
gh label create "security" --color "b60205" --description "Security related" --force
gh label create "performance" --color "fbca04" --description "Performance optimization" --force

# Status labels
echo "Creating status labels..."
gh label create "needs-triage" --color "ededed" --description "Awaiting triage" --force
gh label create "needs-info" --color "d4c5f9" --description "Needs more information" --force
gh label create "ready-for-dev" --color "0e8a16" --description "Ready for development" --force
gh label create "duplicate" --color "cfd3d7" --description "Duplicate issue" --force

echo ""
echo "✅ All labels created successfully!"
echo ""
echo "Next steps:"
echo "1. Add OPENAI_API_KEY secret: gh secret set OPENAI_API_KEY"
echo "2. Copy workflow file to .github/workflows/"
echo "3. Create a test issue to verify automation"
echo ""
