# 25E0 — Acceptance-Scope Dependency Matrix and Accumulated-Change Review

Date: 2026-09-22

## Purpose

Turn composition-aware acceptance scope into a learner- and maintenance-facing tool. The matrix prevents work orders from being reviewed only component-by-component when the affected evidence actually crosses an end-to-end safety proposition.

This artifact does **not** define machine-specific acceptance thresholds. It identifies what must be re-proved and where `UNKNOWN / MACHINE-SPECIFIC` blocks a production-return claim.

## Evidence basis

### DOC-CONFIRMED — control dynamics can invalidate safety acceptance evidence

Siemens, *SINUMERIK Operate acceptance test*, Function Manual 01/2023, A5E39460574B AF, section 3.2, requires commissioning/configuration and open-/closed-loop control commissioning to be complete before the Safety Integrated acceptance test because over-travel distance can otherwise change as drive-control dynamic response changes. Each Safety Integrated function used must then be tested and documented in the acceptance report.

Source: https://support.industry.siemens.com/cs/attachments/109820809/828D_AT_fct_man_0123_en-US.pdf

This is a concrete professional example of a change outside the nominal safety component itself invalidating safety evidence: ordinary drive/control dynamics can alter the physical stopping/over-travel proposition on which safeguard effectiveness depends.

### DOC-CONFIRMED — safeguard position depends on machine stopping performance

Pilz states that safeguard safety distance depends on the machine reaction/stopping performance, and its stop-time guidance notes that stopping performance can change with brake wear, mechanical degradation, tooling, load, speed, and control-system faults.

Sources:
- https://www.pilz.com/en-US/support/law-standards-norms/iso-standards/efficiency-guards/safety-distance
- https://www.pilz.com/en-AU/company/news/articles/248042

Rockwell's Guardmaster MatGuard documentation independently requires worst-case machine response time in the safety-distance calculation and explicitly notes that response time can depend on operating mode, workplace conditions, cycle point, brake wear, and machine-control delays.

Source: https://configurator.rockwellautomation.com/api/Doc/440f-um001_-en-p.pdf

### INFERENCE — dependency consequence

If a safety proposition depends on stopping performance, then a non-safety change that can alter stopping performance is inside that proposition's acceptance dependency boundary even when no safety-rated component or safety checksum changed. The exact re-test remains application-specific.

## Learner-facing dependency matrix

Create one row per safety function/proposition. Mark every column `UNCHANGED/VALID`, `STALE`, `UNKNOWN`, or `N/A`, and attach the evidence record that justifies `UNCHANGED/VALID` after a maintenance/change set.

| Safety function / physical proposition | Input witness | Safety logic / configuration | Final element | Process / result witness | Machine dynamics / stored energy | Safeguard / access assumption | Minimum acceptance consequence |
|---|---|---|---|---|---|---|---|
| Guard opening produces the required safe machine state before access | guard channels, lock state where applicable | guard/stop function, mode and reset semantics | STO/contactors/valves/brakes as designed | actual motion/energy state required by design | stopping time, load, speed, brake/mechanical behavior | guard geometry, reach/access time, locking | local device checks **plus** end-to-end guard-to-safe-state proof when any dependency is stale |
| Safe limited speed permits reduced-risk access/setup | mode request, enabling device, safety motion witness | SLS/setup parameters and authority transitions | drive/actuator safety function | independently monitored actual speed/motion | load, gearing, tuning/dynamics where relevant | access boundary and supported setup procedure | prove monitored speed function and mode/enabling transitions; ordinary speed command is not substitute evidence |
| Gravity load remains retained when hazardous drive/pressure is removed | valve/brake/pressure/position witnesses as actually designed | retaining/isolation sequence and diagnostics | load-holding valve, brake, isolation element | load motion/position and other required physical proof | gravity, stored hydraulic/mechanical energy | personnel exposure boundary | component proof plus physical retaining/energy proposition; thresholds remain machine-specific |
| Protective device stops rotating hazard before reach | light curtain/door/device channels | stop function and reset/restart semantics | STO/contactor/brake | actual hazardous rotation stopped | spindle/load inertia, tooling, brake/control dynamics | device position, reach/access geometry | re-measure/revalidate stopping proposition if dynamics or geometry changed |
| Emergency stop produces required machine safe response | E-stop channels | E-stop function, reset/rearm | energy-removal/final elements | required process result | stored energy and stopping dynamics | zone/hazard boundary | end-to-end E-stop response for every stale dependency; reset remains separate from start |

## How to use the matrix after a change

1. List **all** changes since the last accepted baseline, not only items on the current work order.
2. For each change, mark matrix cells whose evidence can no longer be assumed current.
3. Take the union of stale and unknown cells across the entire interval.
4. Follow each stale cell horizontally to every safety proposition that depends on it.
5. Add local component checks where required, but do not let them replace an end-to-end physical test when the proposition crosses interfaces.
6. If a dependency cannot be bounded, mark it `UNKNOWN`; broaden validation or obtain machine-specific evidence before personnel-exposed production.
7. Record acceptance authority and evidence identity. `PASS` without a named proposition, criterion, and evidence class is insufficient.
8. Clear temporary commissioning states, then perform reset/rearm and ordinary-demand freshness handling as separate return-to-production steps.

## Non-safety-component change trace

### Scenario

A guarded servo machine retains the same guard switch, safety PLC project, safety drive parameters, and safety checksum. Maintenance changes ordinary servo tuning to improve production settling time.

### Incorrect shortcut

`No safety component changed + safety checksum unchanged -> no safety acceptance impact.`

### Evidence-grounded review

Siemens explicitly warns that acceptance must follow completed open-/closed-loop commissioning because changed drive-control dynamics can change over-travel. Pilz and Rockwell independently tie safeguard placement to machine stopping response. Therefore the tuning change must be screened against every safety proposition that depends on stopping/over-travel performance.

This does **not** mean every tuning change universally requires a complete machine acceptance test. It means the learner cannot exclude it from safety acceptance scope merely because the modified parameter is not labeled safety-related.

Freeze:

**NON-SAFETY PARAMETER != OUTSIDE SAFETY EVIDENCE BOUNDARY.**

## Adversarial accumulated-change case — three maintenance windows

Baseline: a guarded servo machine has accepted evidence for guard actuation, safety motion sensing, stop behavior, safeguard placement, reset/rearm, and production restart.

### Window A — mechanical service

A brake is replaced after wear. The local brake service procedure passes. No safety project changes.

Stale review: stopping/holding performance can be stale even if the replacement component is locally healthy.

### Window B — production optimization

Servo tuning and maximum ordinary production speed are changed. The machine runs better and no safety fault appears. The safety checksum still matches.

Stale review: physical stopping/over-travel evidence may now be stale because machine dynamics changed.

### Window C — guarding work

The light curtain or guard boundary is physically relocated to improve loading ergonomics. Electrical diagnostics pass and its safety inputs remain healthy.

Stale review: physical separation/access geometry is now stale even though the sensor electronics are healthy.

### Composition trap

Each work order looks locally bounded. Taken together, however, all three changes intersect the same proposition:

`protective-device intervention -> safety response -> hazardous motion stops before a person can reach the hazard`.

The current acceptance scope therefore cannot be derived from Window C alone. The learner must compare against the last accepted baseline, union the stale dependencies from A+B+C, and revalidate the composed proposition using the machine's actual criteria and authorized procedure.

### Required learner conclusions

- Brake replacement local pass: **not** proof of current end-to-end stop performance.
- Safety checksum match: configuration-identity evidence only; **not** proof that dynamics or geometry remain valid.
- Guard/light-curtain electrical health: local device evidence only; **not** proof of adequate physical separation.
- Three closed work orders: administrative state only; **not** proof that cross-window safety evidence was revalidated.
- If prior acceptance evidence cannot be tied to the current physical/configuration baseline: mark the affected proposition `UNKNOWN` and do not manufacture a reduced test scope.

## Baseline rule

A maintenance system needs a durable **accepted safety baseline identity**, not merely a list of completed work orders. Every later change is compared against that baseline until the affected proposition has been revalidated and a new accepted baseline is established.

This prevents stale evidence from being laundered by time or by closing work orders individually.

Freeze:

**WORK ORDER CLOSED != SAFETY EVIDENCE REFRESHED.**

**NO SINGLE LARGE CHANGE != NO COMPOSED SAFETY CHANGE.**

**CURRENT CONFIGURATION CHECKSUM != CURRENT PHYSICAL ACCEPTANCE BASELINE.**

## Human-factors requirement

The safe workflow should automatically surface prior unresolved stale cells when a new maintenance action touches the same safety proposition. Requiring a technician under production pressure to remember several earlier work orders is a predictable failure mode. The system should make `show affected safety functions / outstanding revalidation` easier than bypassing the review.

## UNKNOWN handling

No generic hydraulic pressure, safe speed, stop time, separation distance, brake capacity, PL/SIL target, diagnostic coverage, or acceptance tolerance is created here. Those values require the machine-specific design, risk assessment, manufacturer requirements, measurement, and applicable standards.
