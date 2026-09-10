#!/usr/bin/env bash
set -euo pipefail

# X02-001 separate authoritative execution.
#
# The corrected preflight artifact from workflow 34459587342 independently
# passed the frozen X02-001 Gates A-J. This wrapper deliberately executes the
# already-validated attempt-2 harness unchanged. It does not alter P0-P4,
# polling rates, selected witnesses, recorder configuration, scoring logic, or
# any behavioral prediction. The distinct workflow/artifact is the independent
# authoritative realization required by the frozen acceptance rule.
#
# The invoked 054 script retains its historical NON-AUTHORITATIVE/PREFLIGHT
# strings as provenance of the exact executable being repeated. Those labels
# are reporting text, not a change in the executable experiment. Authority is
# conferred only after this separate run's raw artifact is independently
# inspected against the frozen contract.

exec bash lab-jobs/054-x02-001-multi-surface-preflight-enable-order-fix.sh
