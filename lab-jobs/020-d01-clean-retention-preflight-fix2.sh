#!/usr/bin/env bash
set -euo pipefail

# D01 clean retention lineage attempt 3.
# Attempt 2 proved the complete package existed locally but wrote it outside
# lab-runner.yml's uploaded run-${id}-${attempt} tree. This correction changes
# only publication placement. Runtime fixture, frozen values, P0-P8 semantics
# and D01-002 Gates A-J remain unchanged and UNSCORED.

REAL_WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
RUN_DIR="${REAL_WORKSPACE}/lab-results/run-${GITHUB_RUN_ID:?}-${GITHUB_RUN_ATTEMPT:?}"
mkdir -p "$RUN_DIR"

# 018/019 derives its evidence output root from GITHUB_WORKSPACE. Point that
# root beneath the already-uploaded run directory without changing cwd or any
# LinuxCNC/runtime behavior. The resulting nested lab-results/d01-018-evidence
# directory is intentionally inside RUN_DIR and therefore uploaded recursively.
export GITHUB_WORKSPACE="$RUN_DIR"

printf '%s\n' 'D01-020: clean retention lineage attempt 3; publication-path-only correction; frozen runtime semantics unchanged; Gates A-J remain UNSCORED.'
exec bash "$REAL_WORKSPACE/lab-jobs/019-d01-clean-retention-preflight-fix1.sh"
