#!/usr/bin/env bash
set -euo pipefail

# D01 authoritative runtime execution.
# D01-005 accepted the published evidence-retention mechanism. This run is a
# separate workflow execution of the unchanged frozen D01-002 fixture. It does
# not retune P0-P8, offsets 0.020/0.200, ferror limit 0.050, topology, observer,
# command path, phase ordering, sampler ordering, or Gates A-J.
#
# The inherited 020/019 implementation still prints historical "preflight"
# labels because changing those strings is not behaviorally useful and would
# create needless divergence from the accepted harness. For this independent
# execution, authoritative scoring is performed only afterward from the
# downloaded retained artifact; no live assertion scores a gate.

REAL_WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
RUN_DIR="${REAL_WORKSPACE}/lab-results/run-${GITHUB_RUN_ID:?}-${GITHUB_RUN_ATTEMPT:?}"
mkdir -p "$RUN_DIR"

printf '%s\n' 'D01-021 AUTHORITATIVE EXECUTION: unchanged D01-002 fixture; score Gates A-J only from retained published artifact.'

# 020 redirects GITHUB_WORKSPACE so the complete package is nested under the
# workflow-uploaded run tree. Preserve that accepted publication mechanism.
bash "$REAL_WORKSPACE/lab-jobs/020-d01-clean-retention-preflight-fix2.sh"

printf '%s\n' 'D01-021 AUTHORITATIVE CANDIDATE COMPLETE: artifact-level independent scoring required.'
