#!/usr/bin/env bash
# Run from a terminal where `gh auth status` succeeds (api.github.com reachable).
set -euo pipefail
REPO="${REPO:-stevecookLOB/megadev}"

gh issue create -R "$REPO" \
  --title "parser: shared month-first date parse flips day-first tenant bookings (379 reports from #4471)" \
  --body "$(cat <<'EOF'
## Problem
`parser` — the shared date parser reads every date month-first. Day-first tenants get bookings on the wrong day.

## Coverage
**379** unique reports merged into support ticket **#4471** (of 412).

## How counted
`#lib/kb/causes` `causeOf`: day-first tenant + channel is not the booking-v3 MM-hint form path → `parser`.
Channels in this group: app, email, and booking-v2 form traffic.

## Related
Sibling cause in the same merge: `hint` (33 reports) — separate ticket.
EOF
)"

gh issue create -R "$REPO" \
  --title "hint: booking-v3 MM/DD hint mismatches day-first tenants (33 reports from #4471)" \
  --body "$(cat <<'EOF'
## Problem
`hint` — booking-v3 prints `MM/DD/YYYY` under the date field while the tenant locale is day-first. People type what the hint says; the form reads the value the tenant’s way. Same wrong-day symptom as the parser bug, different mechanism.

## Coverage
**33** unique reports merged into support ticket **#4471** (of 412).

## How counted
`#lib/kb/causes` `causeOf`: day-first tenant + `channel === 'form'` + booking-v3 MM hint → `hint`.

## Related
Sibling cause in the same merge: `parser` (379 reports) — separate ticket. Fixing the shared parser alone will not clear these.
EOF
)"

echo "Created issues. List:"
gh issue list -R "$REPO"
