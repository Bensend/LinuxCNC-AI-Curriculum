# Safety Periodic-Test Failure Escalation and Trend Review

Date: 2026-09-17

## Purpose

Turn periodic safety-test failures, intermittent discrepancies, nuisance trips, maintenance observations, and repeated bypass pressure into controlled engineering decisions without inventing universal numeric alarm thresholds.

This artifact extends `SAFETY_PERIODIC_INSPECTION_LATENT_FAILURE_DISCOVERY_PLAN.md`. It does not replace immediate hazard control, LOTO, machine-specific validation, or manufacturer-required inspection intervals.

## Evidence labels

Use only: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

A safety-critical `UNKNOWN` is not silently converted to PASS because the machine subsequently completed normal production cycles.

## Frozen principle

> A safety test that fails once, passes only after reset, becomes intermittent, or repeatedly creates pressure to bypass the safeguard is an engineering signal. Do not erase the signal by counting only the final successful cycle.

The response must remain proportional to the evidence. This curriculum intentionally does **not** define a universal number of nuisance trips, discrepancy events, milliseconds, cycles, or maintenance calls that proves a dangerous trend.

## 1. Immediate failure disposition

When a required periodic challenge produces `FAIL — OUT OF SERVICE` or `UNKNOWN — NOT CLEARED`:

1. maintain or establish physical hazard control;
2. keep the affected exposed operating state out of service;
3. preserve diagnostics and physical evidence when safe;
4. identify which evidence layer failed: demand/input, safety logic, output, final element, EDM/feedback, energy path, physical response, reset/restart/rearm, or configuration;
5. do not use a power cycle, diagnostic clear, normal LinuxCNC cycle, or ordinary FPGA/HAL state as proof that the failed safety claim recovered;
6. repair or investigate under controlled maintenance conditions;
7. revalidate the affected claim and its interfaces before release.

If safe investigation cannot distinguish a transient indication from a real safety-path defect, preserve `UNKNOWN — NOT CLEARED` until evidence resolves it.

## 2. Do not normalize intermittent faults

Treat these as review triggers rather than harmless inconvenience:

- a dual-channel discrepancy that disappears after cycling the guard or E-stop;
- EDM/final-element mismatch that clears after reset or power cycling;
- safety-controller diagnostic that appears only during vibration, heat, startup, shutdown, or a particular mode;
- protective device requiring repeated alignment or cleaning beyond its established normal maintenance basis;
- safety valve or contactor whose physical witness becomes inconsistent while its command remains normal;
- reset/rearm that occasionally requires extra presses, repeated clearing, or an undocumented sequence;
- safety-network/device dropouts that leave ordinary HMI/LinuxCNC context apparently healthy;
- inspection results that remain inside an allowed range but move consistently toward a machine-specific limit;
- technicians repeatedly reporting that a safeguard is difficult to use, causes unexplained stops, or is tempting to defeat.

`INFERENCE`: intermittency can be evidence of a wiring, connector, mechanical-alignment, contamination, thermal, vibration, configuration, timing, power-quality, or component-aging problem. Do not choose among these causes without evidence.

## 3. Trend register

Keep raw observations as well as disposition.

| Date / cycle context | Safety function | Observed symptom | Evidence layer | Provenance | Configuration / hardware identity | Immediate disposition | Repeat? | Investigation link | Final status |
|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | |

Record PASS results too when they are part of a meaningful sequence. A later PASS does not delete an earlier FAIL, discrepancy, or UNKNOWN.

## 4. Escalation classes

Use qualitative classes rather than invented universal thresholds.

### Class A — isolated explained event

Evidence identifies a bounded non-dangerous cause, the affected safety claim is revalidated, and no unresolved recurrence pattern remains.

Disposition: close with retained evidence and normal machine-specific inspection schedule.

### Class B — recurrent or unexplained anomaly

The event recurs, cannot be fully explained, appears environment/mode dependent, or requires repeated reset/recovery.

Disposition: engineering review required. Increase observation or challenge depth based on the actual failure hypothesis; do not merely shorten an interval without understanding what the extra test can reveal.

### Class C — safety-function degradation or failed claim

Physical challenge shows required behavior is absent, inconsistent, no longer independently witnessed, or a safety-critical UNKNOWN cannot be closed.

Disposition: affected exposed operating state remains OUT OF SERVICE / NOT CLEARED until repair/change revalidation closes the claim.

### Class D — systemic / common-cause concern

Multiple safety functions show related anomalies, a shared supply/configuration/network/environmental dependency is implicated, or one change can invalidate multiple independent-looking witnesses.

Disposition: widen review beyond the first failed component. Revisit common-cause boundaries, configuration baseline, final-element independence, and minimum-operate gate before return to service.

## 5. Trend questions

For each recurrent issue ask:

- Is the frequency actually changing, or did detection/reporting change?
- Does it correlate with temperature, vibration, contamination, moisture, shift, mode, tooling, maintenance, startup, power restoration, or production phase?
- Is the same physical component involved, or only the same diagnostic code?
- Is a shared power supply, connector, cable route, safety I/O module, configuration object, network, sensor, or final element common to the events?
- Did hardware, firmware, wiring, LinuxCNC/HAL/FPGA mapping, hydraulic plumbing, guard geometry, or maintenance practice change before the trend began?
- Is the witness independent enough to distinguish command from physical response?
- Are repeated resets destroying useful evidence?
- Is a technician compensating manually for a deteriorating safety function?
- Has nuisance-stop pressure created a jumper, force, defeat, undocumented mode, widened setting, or informal workaround?

Do not assume correlation proves cause. Preserve candidate causes as `INFERENCE` until supported.

## 6. Human-factors escalation

Repeated pressure to bypass a safeguard is itself a design/maintenance signal.

Examples:

- guard or interlock interferes with legitimate routine work;
- reset location or sequence encourages blind reset or repeated button pressing;
- nuisance trips are poorly diagnosed, making defeat faster than troubleshooting;
- a service bypass is easier to apply than the approved maintenance procedure;
- required spare or test equipment is routinely unavailable;
- a safety device is physically awkward to reinstall correctly;
- production restart requires undocumented tribal knowledge.

Response should make the safe path easier: improve diagnostics without moving safety authority into LinuxCNC/FPGA, improve access/guard ergonomics, provide controlled service tools and approved spares, fix root causes, and remove obsolete workarounds.

A production target never converts an unresolved safety defect into acceptable operation.

## 7. Trend data must not become false proof

Trend logs are diagnostic evidence, not automatic safety validation.

- `0 faults recorded` is not proof the logger was alive or the safety function was challenged.
- a LinuxCNC/HAL/FPGA bit history is ordinary-control context unless the architecture legitimately credits it.
- a safety-controller output history is not automatically final-element or physical-energy proof.
- an EDM history is not proof all hazardous energy was absent.
- collector timestamps may differ from physical event time; preserve clock/source identity.
- missing records, buffer overflow, reboot, network loss, or stale data must be visible as evidence gaps.

## 8. When to widen revalidation

Widen beyond the initially failed item when evidence suggests:

- common wiring, supply, grounding, connector or environmental exposure;
- common safety-controller configuration or firmware change;
- a replacement/substitution affected interface assumptions;
- one diagnostic witness is shared by multiple final elements;
- a maintenance action disturbed adjacent channels;
- hydraulic/pneumatic contamination or plumbing changes can affect multiple valves/functions;
- guard/access modifications alter more than one protective function;
- ordinary LinuxCNC/FPGA changes altered rearm/start/stale-command behavior at the safety boundary.

Use the post-incident change-revalidation and replacement-equivalence worksheets to define the changed claim radius.

## 9. Interval adjustment rule

A worsening trend can justify reviewing the inspection interval, but interval shortening is not a substitute for repair or root-cause work.

Any interval change needs a defensible basis such as manufacturer instructions, machine risk assessment, failure history, environmental severity, diagnostic coverage, mission-time/proof-test assumptions, or newly discovered latent-failure behavior.

If the basis is missing, record `UNKNOWN`; do not invent weekly/monthly/annual periods or a universal event-count threshold.

## 10. OpenPressBrake-specific UNKNOWNs

Do not derive from trend data alone:

- acceptable stopping time/distance;
- safe speed, force, pressure, or ram position;
- hydraulic safety-valve truth table;
- accumulator discharge threshold/time;
- required PL/SIL/DC/DCavg;
- EDM/discrepancy timing limits;
- safe-drive parameters;
- allowable number of intermittent faults before shutdown.

Those require actual machine design evidence, measurement, manufacturer documentation, and applicable risk/safety requirements.

## 11. Review closeout

A trend review closes only when it records:

- the affected safety claim(s);
- preserved raw observations and provenance;
- whether the cause is confirmed, inferred, conflicting, or unknown;
- immediate hazard-control/out-of-service decisions;
- repair/change performed, if any;
- revalidation scope and results;
- any common-cause expansion;
- any inspection/maintenance/documentation change and its basis;
- any remaining UNKNOWNs and operating states they prevent.

## Minimum curriculum takeaway

Do not train maintainers to make nuisance safety faults disappear. Train them to recognize recurrence, intermittency, worsening physical evidence, and bypass pressure as information about the architecture. Preserve the history, keep ordinary LinuxCNC/FPGA diagnostics subordinate to independent safety authority, and escalate the evidence depth before a hidden failure becomes the first real demand.