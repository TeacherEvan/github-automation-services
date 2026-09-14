#!/usr/bin/env bash
# verify-triage-bot.sh — Hardening verification gate for the AI Issue Triage Bot
# Checks: SHA-pinned actions, least-privilege permissions, output allowlists,
#         label-set consistency between workflow and setup-labels.sh
#
# Exit: 0 = all checks pass; non-zero = at least one check failed
# Usage: scripts/verify-triage-bot.sh
# No network calls, no secrets required. Idempotent.

WORKFLOW=".github/workflows/issue-triage-bot.yml"
SETUP_SCRIPT="scripts/setup-labels.sh"

failures=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; failures=$((failures + 1)); }

echo "=== AI Issue Triage Bot — Hardening Verification Gate ==="
echo ""

# Pre-flight: required files exist
if [ ! -f "$WORKFLOW" ]; then
    echo "FATAL: workflow not found at $WORKFLOW"
    exit 1
fi
if [ ! -f "$SETUP_SCRIPT" ]; then
    echo "FATAL: setup script not found at $SETUP_SCRIPT"
    exit 1
fi

# Run all checks via python3 (robust YAML + regex parsing)
CHECKS=$(python3 << 'PYEOF'
import yaml, re, os

workflow = ".github/workflows/issue-triage-bot.yml"
setup_script = "scripts/setup-labels.sh"

with open(workflow) as f:
    wf = yaml.safe_load(f)

# --- REQ-001: SHA-pinned actions ---
uses_values = []
for step in wf['jobs']['triage']['steps']:
    if 'uses' in step:
        uses_values.append(step['uses'])

sha_issues = []
for u in uses_values:
    ref = u.split('@')[-1]
    if not re.match(r'^[0-9a-f]{40}$', ref):
        sha_issues.append(u)

if sha_issues:
    print(f"FAIL|REQ-001|Actions not SHA-pinned: {', '.join(sha_issues)}")
else:
    print(f"PASS|REQ-001|All {len(uses_values)} actions pinned to 40-char commit SHAs")

# --- REQ-002: Least-privilege permissions ---
perms = wf.get('permissions', {})
if isinstance(perms, dict):
    perm_list = list(perms.items())
else:
    perm_list = []

if perm_list == [('issues', 'write')]:
    print("PASS|REQ-002|Permissions are least-privilege (issues: write only)")
else:
    print(f"FAIL|REQ-002|Permissions mismatch: expected only issues:write, got {perm_list}")

# --- REQ-003: Output allowlists ---
script_block = ''
for step in wf['jobs']['triage']['steps']:
    if 'with' in step and 'script' in step['with']:
        script_block = step['with']['script']
        break

# ALLOWED_LABELS
m = re.search(r"ALLOWED_LABELS\s*=\s*new Set\(\[([^\]]+)\]\)", script_block, re.DOTALL)
if m:
    labels = re.findall(r"'([^']+)'", m.group(1))
    if labels:
        print(f"PASS|REQ-003|ALLOWED_LABELS exists with {len(labels)} entries: {', '.join(sorted(labels))}")
    else:
        print("FAIL|REQ-003|ALLOWED_LABELS Set is empty")
else:
    print("FAIL|REQ-003|ALLOWED_LABELS Set definition not found in workflow script")

# ALLOWED_PRIORITIES
m = re.search(r"ALLOWED_PRIORITIES\s*=\s*new Set\(\[([^\]]+)\]\)", script_block, re.DOTALL)
if m:
    priorities = re.findall(r"'([^']+)'", m.group(1))
    if priorities:
        print(f"PASS|REQ-003|ALLOWED_PRIORITIES exists with {len(priorities)} entries: {', '.join(sorted(priorities))}")
    else:
        print("FAIL|REQ-003|ALLOWED_PRIORITIES Set is empty")
else:
    print("FAIL|REQ-003|ALLOWED_PRIORITIES Set definition not found in workflow script")

# --- REQ-004: Label set consistency ---
# Compare only TYPE + AREA + STATUS labels (not priorities, which are tracked
# separately in ALLOWED_PRIORITIES and verified in REQ-003).
wf_labels = set()
m = re.search(r"ALLOWED_LABELS\s*=\s*new Set\(\[([^\]]+)\]\)", script_block, re.DOTALL)
if m:
    wf_labels = set(re.findall(r"'([^']+)'", m.group(1)))

# Priority labels live in ALLOWED_PRIORITIES, not ALLOWED_LABELS — exclude them
# from the label-set comparison so they don't trigger a false mismatch.
priority_labels = set()
m2 = re.search(r"ALLOWED_PRIORITIES\s*=\s*new Set\(\[([^\]]+)\]\)", script_block, re.DOTALL)
if m2:
    priority_labels = set(re.findall(r"'([^']+)'", m2.group(1)))

setup_labels = set()
if os.path.exists(setup_script):
    with open(setup_script) as f:
        setup_content = f.read()
    for m in re.finditer(r'gh label create "([^"]+)"', setup_content):
        setup_labels.add(m.group(1))

# Only compare non-priority labels
setup_non_priority = setup_labels - priority_labels
wf_non_priority = wf_labels  # ALLOWED_LABELS already excludes priorities

missing_in_setup = wf_non_priority - setup_non_priority
missing_in_wf = setup_non_priority - wf_non_priority

if not missing_in_setup and not missing_in_wf:
    print(f"PASS|REQ-004|Workflow labels match setup-labels.sh ({len(wf_non_priority)} non-priority labels; {len(priority_labels)} priorities tracked separately)")
else:
    if missing_in_setup:
        print(f"FAIL|REQ-004|Labels in workflow but NOT in setup-labels.sh: {', '.join(sorted(missing_in_setup))}")
    if missing_in_wf:
        print(f"FAIL|REQ-004|Labels in setup-labels.sh but NOT in workflow: {', '.join(sorted(missing_in_wf))}")
PYEOF
)

# Parse and display results
while IFS= read -r line; do
    case "$line" in
        PASS\|*)
            pass "${line#PASS|}"
            ;;
        FAIL\|*)
            fail "${line#FAIL|}"
            ;;
    esac
done <<< "$CHECKS"

echo ""
echo "=== Gate Summary ==="
if [ "$failures" -eq 0 ]; then
    echo "  Result: ALL CHECKS PASSED"
    exit 0
else
    echo "  Result: VERIFICATION FAILED ($failures failure(s))"
    exit 1
fi
