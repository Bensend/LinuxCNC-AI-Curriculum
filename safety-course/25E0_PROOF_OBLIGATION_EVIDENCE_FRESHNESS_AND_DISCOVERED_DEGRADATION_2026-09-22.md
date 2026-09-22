# 25E0 — Proof Obligation, Evidence Freshness, and Discovered Degradation

## Purpose

A safety proposition can become unsupported even when nobody changed a component, parameter, program, or drawing. Wear, drift, contamination, looseness, aging, process changes, load changes, and latent faults can make yesterday's accepted physical evidence non-representative.

This lesson extends the accepted-safety-baseline ledger with a distinct evidence-freshness review. It prevents the common but unsafe inference:

> no work order + no configuration change + no alarm = accepted physical safety baseline still valid.

That inference is not generally defensible.

## Evidence classes

Use the repository evidence vocabulary. The professional lifecycle conclusions below are `DOC-CONFIRMED`; machine-specific consequences remain `INFERENCE` until validated on the machine.

### Professional evidence trace

1. **SICK stop-time measurement — DOC-CONFIRMED.** SICK states that a protective device's effectiveness depends on minimum distance and that hazardous movement must stop before the hazardous point can be reached throughout the machine life cycle. It calls for stop-time measurement before initial commissioning, after significant changes, and after expected usage-related changes such as brake wear. Measurement results are used to determine minimum distance and permit timely corrective measures.
2. **Pilz stop-time measurement — DOC-CONFIRMED.** Pilz states that actual stopping performance is the basis for safety-device placement and that stopping performance can degrade through brake wear, mechanical degradation, tooling/load/speed changes, and control-system faults. Regular measurement can expose deterioration before it becomes an unnoticed risk.
3. **Pilz safeguard inspection — DOC-CONFIRMED.** Pilz distinguishes regular inspection from inspection following modifications or exceptional events and uses overrun measurement to verify that current safety distances still correspond to the machine values.
4. **SICK periodic protective-device inspection — DOC-CONFIRMED.** Periodic inspection includes suitability for current machine use, installation/mounting/condition, function, and detection of safety-critical deficiencies, modifications, and manipulations. Where stopping-time information is unavailable, SICK calls for measured run-down time.
5. **Rockwell safeguarding examples — DOC-CONFIRMED.** Rockwell treats total stopping performance as an input to safety-distance/access-time reasoning and requires all relevant stop-path elements to be represented. Published device reaction time alone is not equivalent to actual machine stopping performance.

These sources support the lifecycle method. They do **not** provide an OpenPressBrake stop time, press-brake safety distance, acceptable trend limit, proof interval, PL/SIL target, or hydraulic safe-state threshold.

## Four reasons evidence becomes non-current

Do not use one generic `expired` flag. Name the mechanism.

| Freshness mechanism | Meaning | Typical trigger | What it does to evidence |
|---|---|---|---|
| `TIME/USE DUE` | a required proof/inspection interval or usage limit has arrived | calendar, cycles, operating hours | evidence is no longer sufficient for the scheduled proof obligation |
| `LATENT-FAULT PROOF DUE` | a diagnostic gap requires periodic proof to reveal faults not continuously detected | proof-test interval | evidence cannot be assumed to cover latent faults beyond the justified interval |
| `DRIFT/DEGRADATION FOUND` | measurement/inspection shows physical behavior or condition no longer matches the accepted baseline | stop-time trend, wear, looseness, contamination, deterioration | affected physical proposition becomes `STALE` or `FAILED` immediately, independent of whether a work order exists |
| `CHANGE/EVENT INVALIDATION` | maintenance, configuration, exceptional state, accident, relocation, repair, or other event changes an assumption/dependency | work order or event | affected propositions require proposition-specific revalidation |

`UNKNOWN` is not a fifth kind of fresh evidence. If the machine-specific acceptance criterion or dependency is unknown, the dependent production-acceptance claim remains unknown.

## Ledger extension

For each `EVID-*`, record:

- evidence identity and revision;
- proposition(s) supported;
- observation/test method;
- acceptance criterion and its authority;
- measured result where applicable;
- machine state and operating envelope represented;
- physical/configuration dependencies;
- date/cycle/use basis if applicable;
- latent-fault proof obligation if applicable;
- trendable quantity and baseline if applicable;
- invalidation events;
- current freshness state: `CURRENT`, `DUE`, `STALE`, `FAILED`, or `UNKNOWN`;
- next required action;
- reverse `show where used` links.

A checksum may establish configuration identity. It does not refresh a physical measurement.

## Discovered-degradation propagation rule

When inspection or periodic proof discovers degradation, treat the **finding itself as a new safety-relevant event** even if there was no preceding maintenance record.

Use this chain:

`new finding -> identify changed physical fact -> mark old evidence non-representative -> reverse show-where-used -> mark dependent propositions stale/failed -> determine affected safety functions -> establish corrective action -> re-prove affected propositions -> acceptance authority -> reset/rearm -> fresh ordinary demand`

Do not wait for a repair work order before invalidating evidence. The measurement that proves the old baseline false is already enough to invalidate claims that depended on that baseline.

## Stress test — degraded stopping performance with no recorded change

### Accepted baseline

Assume a generic guarded machine has:

- `SF-GUARD-STOP`: opening/interrupting a protective device causes hazardous motion to stop before a person can reach the hazard;
- `PROP-STOP-PERF`: measured total stopping performance remains within the machine-specific accepted criterion;
- `PROP-SEPARATION`: installed protective-device position is adequate for the accepted stopping performance and access assumptions;
- `EVID-STOP-001`: prior measured stop-time evidence;
- `EVID-GEOM-001`: recorded safeguard geometry.

No numerical stopping time or distance is supplied here.

### Periodic proof result

A scheduled stop-time measurement produces a worse result than the accepted baseline. There is no maintenance work order, safety-program change, checksum change, or active diagnostic alarm.

### Required reasoning

1. The new measurement is not merely a maintenance suggestion. It challenges `PROP-STOP-PERF`.
2. `EVID-STOP-001` is now non-representative for claims that require the old stopping performance.
3. Reverse lookup from `PROP-STOP-PERF` reaches `SF-GUARD-STOP` and any other safety function using that stopping-performance assumption.
4. `PROP-SEPARATION` must be reconsidered because safeguard adequacy depends on actual stopping performance, not merely unchanged physical mounting.
5. A safety-rated input device can remain electrically healthy while the complete protective function is no longer adequately supported by the old stopping evidence.
6. Resetting an alarm, clearing an inspection task, or recording the new measurement does not itself restore the safety proposition.
7. Corrective action is machine-specific: repair, adjustment, altered safeguard geometry, altered operating envelope, or another engineered measure may be appropriate, but the curriculum must not invent which one.
8. After correction, revalidation scope follows the propositions and dependencies actually affected.

### Access proposition nuance

Do not automatically invalidate every access function in the same way. An access-release function based on independent safe standstill evidence may have a different dependency from one based on a time delay derived from expected stopping behavior. Use the ledger. Shared machine motion does not imply identical proof obligations.

## Adversarial cases

### Case A — green diagnostics, bad physics

The guard switch reports healthy dual channels. The safety PLC reports no fault. The drive safety configuration checksum matches. Periodic measurement shows materially degraded stopping performance relative to the accepted machine criterion.

**Correct conclusion:** diagnostics/configuration evidence remains useful for what it actually proves, but it does not overrule the contradictory physical stopping evidence. The dependent stopping/separation proposition is not accepted until disposition and revalidation are complete.

### Case B — proof interval not yet due, degradation discovered anyway

A technician observes abnormal brake behavior and an authorized measurement confirms deterioration months before the scheduled periodic proof date.

**Correct conclusion:** the future due date does not preserve acceptance after contrary evidence appears. Event/finding-triggered revalidation starts now.

### Case C — periodic proof passes after unrelated change

A scheduled stop-time test passes, but a guard interlock was relocated yesterday without revalidating mounting/actuation geometry.

**Correct conclusion:** the passed periodic stopping test does not clear the separate event-triggered interlock proposition. The two obligation lanes coexist.

### Case D — measurement changes but acceptance criterion is missing

A fresh stop-time result is slower than last year, but the repository contains no authoritative machine-specific criterion, validated safety-distance calculation, or acceptance owner.

**Correct conclusion:** record the trend and classify the dependent acceptance proposition `UNKNOWN`; do not invent a percentage-degradation threshold.

## Learner review algorithm

For every safety-relevant inspection, proof test, trend or observation:

1. Name exactly what physical/configuration fact was observed.
2. Identify the stable `EVID-*` record it confirms, contradicts, or supersedes.
3. Identify every `PROP-*` using that evidence.
4. Determine whether the finding is `CURRENT`, `DUE`, `STALE`, `FAILED`, or `UNKNOWN` against an authoritative acceptance criterion.
5. Reverse-trace each affected proposition to its `SF-*` safety functions.
6. Keep unaffected evidence current only when its assumptions genuinely remain intact.
7. Block dependent production acceptance on safety-critical `FAILED` or `UNKNOWN` propositions.
8. Define corrective/revalidation scope from dependencies, not from work-order boundaries.
9. Preserve the new measurement as evidence; never overwrite the historical baseline.
10. Require production return to complete exceptional-state clearance, acceptance, reset/rearm, and fresh ordinary-demand rules already established by 25E0.

## Human-factors design implication

A proof program that generates measurements but makes trend comparison, stale-evidence propagation, or corrective disposition cumbersome invites paperwork closure without engineering closure. Make the safe workflow easy:

- automatically show the last accepted result beside the new result;
- expose every safety proposition that uses the measured quantity;
- make `FAILED/UNKNOWN` impossible to silently relabel `CURRENT`;
- make corrective evidence attach directly to the stale proposition;
- avoid forcing technicians to rediscover dependency chains from drawings and memory.

## Freezes

- **NO RECORDED CHANGE != PHYSICAL BASELINE UNCHANGED.**
- **PERIODIC TEST PERFORMED != DEPENDENT SAFETY PROPOSITION ACCEPTED.**
- **GREEN DIAGNOSTICS != PHYSICAL STOPPING PERFORMANCE PROVED.**
- **CONFIGURATION CHECKSUM MATCH != PHYSICAL EVIDENCE FRESH.**
- **PROOF DUE DATE IN FUTURE != CONTRARY EVIDENCE MAY BE DEFERRED.**
- **DEGRADATION FOUND != WAIT FOR MAINTENANCE CHANGE BEFORE INVALIDATING EVIDENCE.**
- **ONE DEGRADED PHYSICAL FACT != EVERY SAFETY FUNCTION FAILS IDENTICALLY.**
- **NEW MEASUREMENT != NEW ACCEPTANCE unless an authoritative criterion and acceptance decision exist.**

## What remains UNKNOWN

Machine-specific proof intervals, acceptable stop-time drift, stopping distances, approach/separation calculations, brake wear limits, hydraulic thresholds, access-delay semantics, PL/SIL targets, and diagnostic coverage remain `UNKNOWN` unless established by the applicable machine design/risk assessment and authoritative evidence.

## Next evidence target

Trace a professional example where a periodic proof or inspection finds a defect and the required response broadens beyond repeating the same test. Then extend the ledger with explicit `finding -> containment -> root cause/corrective action -> affected-proposition revalidation -> closure` semantics. Stress-test a common-cause degradation that affects two apparently independent safety functions through a shared physical element or environmental condition.
