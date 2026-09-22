# Safety Architecture Allocation Worksheet

Use after the safety-function fault/diagnostic worksheet and before component selection or PL/SIL arithmetic.

## Function record

- `SF-*`:
- Required physical `PROP-*`:
- Trigger / reaction / safe state:
- Applicable operating modes:
- Fault-analysis rows driving architecture (`FLT-*`):

## Architecture requirements

| ARCH ID | Fault/gap | Required architectural response | Why this response addresses the fault | Remaining UNKNOWN |
|---|---|---|---|---|
| ARCH- | | | | |

## Independence / common-cause reverse trace

For every claimed independent channel/path, list all shared dependencies.

| Path A | Path B | Shared `DEP-*` | Can shared dependency defeat both? | Control / separation / proof | Evidence |
|---|---|---|---|---|---|
| | | | | | |

Challenge power, return, connector/cable, routing, mounting/geometry, environment, network, configuration/change process, final element, feedback witness, pressure/energy source, and maintenance.

## Diagnostic-path challenge

| Diagnostic / `EVID-*` | Fault it is meant to reveal | Can it share that fault? | What proposition does it actually prove? | What does it NOT prove? | Failure-of-diagnostic reaction |
|---|---|---|---|---|---|
| | | | | | |

## Final element / physical proof

- Commanded final element(s):
- Feedback available:
- Exact proposition supported by feedback:
- Required downstream physical/process proposition:
- Separate physical witness/proof needed? Why?
- Post-maintenance/recovery re-proof trigger:

## Validation surfaces

| `VAL-*` | Challenge | Observable evidence | Acceptance criterion source | Requires physical machine? |
|---|---|---|---|---|
| | | | | |

Include input fault, logic/communication fault, final-element fault, power/recovery, reset/rearm/fresh-start, relevant common cause, and maintenance/change re-proof.

## Human factors

- Likely nuisance-trip/bypass pressure:
- Legitimate recovery path:
- How guard/safeguard use is made easier than defeat:
- Durable diagnostic/finding information available to maintenance:

## Integrity quantities — keep UNKNOWN until derived

- Category: `UNKNOWN`
- PLr / achieved PL: `UNKNOWN`
- SIL: `UNKNOWN`
- DC/DCavg: `UNKNOWN`
- MTTFd: `UNKNOWN`
- PFH/PFD: `UNKNOWN`
- CCF score/beta: `UNKNOWN`
- proof interval: `UNKNOWN`
- discrepancy/stopping time: `UNKNOWN`

Do not replace `UNKNOWN` with a number or category because the block diagram “looks redundant.”
