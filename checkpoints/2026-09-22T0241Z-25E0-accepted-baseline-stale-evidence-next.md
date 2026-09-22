# 25E0 continuation checkpoint — accepted safety baseline / stale-evidence ledger

Date: 2026-09-22

## Completed this session

- Added `safety-course/25E0_ACCEPTANCE_SCOPE_DEPENDENCY_MATRIX_AND_ACCUMULATED_CHANGE_REVIEW_2026-09-22.md`.
- Converted composition-aware acceptance scope into a learner-facing dependency matrix.
- Added authoritative non-safety-component evidence: Siemens states changed drive-control dynamics can change over-travel, so open-/closed-loop commissioning must precede Safety Integrated acceptance.
- Added independent Pilz/Rockwell support that safeguard separation depends on actual/worst-case stopping performance and can be affected by mechanical/control conditions.
- Added a three-window accumulated-change case: brake replacement + servo tuning/speed change + safeguard relocation.
- No executable compute was justified; no GitHub-hosted runner was used.

## Exact next work

1. Build a reusable safety evidence baseline / stale-evidence ledger using stable proposition IDs, evidence identity, dependency declarations, revalidation status, and reverse `show where used` lookup.
2. Stress-test it where one shared physical change invalidates evidence for two safety functions differently.
3. Trace professional lifecycle evidence distinguishing periodic/recurrent proof or inspection from event-driven revalidation after change/fault/exceptional commissioning.
4. Keep thresholds and machine physics `UNKNOWN / MACHINE-SPECIFIC` unless authoritative evidence exists.

## Frozen distinctions

- `NON-SAFETY PARAMETER != OUTSIDE SAFETY EVIDENCE BOUNDARY`.
- `WORK ORDER CLOSED != SAFETY EVIDENCE REFRESHED`.
- `NO SINGLE LARGE CHANGE != NO COMPOSED SAFETY CHANGE`.
- `CURRENT CONFIGURATION CHECKSUM != CURRENT PHYSICAL ACCEPTANCE BASELINE`.
