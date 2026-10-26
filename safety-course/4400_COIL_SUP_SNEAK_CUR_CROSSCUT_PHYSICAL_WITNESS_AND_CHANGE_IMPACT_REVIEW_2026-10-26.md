# COIL-SUP-01 × SNEAK-CUR-02 — adversarial final-element proof review
**4400 cross-module integration, 2026-10-26. DOCUMENTARY REVIEW ONLY, NOT RUN AS A MACHINE TEST.** Companion evidence: [suppression/dropout audit](../research/4400_COIL_SUP_01_ROCKWELL_OMRON_DC_COIL_SUPPRESSION_DROPOUT_STOP_TIME_SOURCE_AUDIT_2026-10-26.md), [leakage/backfeed audit](../research/4400_SNEAK_CUR_02_OMRON_SAFETY_RELAY_LEAKAGE_SNEAK_CURRENT_AND_SUPPRESSOR_LOCATION_SOURCE_AUDIT_2026-10-26.md). This is an architecture/failure-path review, **not** an additional public competency score or physical validation gate.

## Why these mechanisms must be separated
**A. Valid output OFF, delayed downstream release:** suppression recirculates energy already stored in the coil. The safety output may be electrically open and a finite coil-decay interval may still precede contactor/valve actuation. Evidence question: how long, in the selected worst case, from independent protective demand to **hazard cessation**?

**B. Output OFF, unintended alternate current:** current may reach a coil through a contact-bypass CR, shared return, lamp, parallel device or series sneak path. Evidence question: can the selected alternate path actually supply enough current to hold or re-energize the load under relevant fault and temperature conditions? **Never infer hold from a schematic path alone**; never infer isolation from a high-impedance voltmeter or OFF bit.

**C. Coil OFF, final element or hazard remains dangerous:** welded contactor, stuck valve spool, blocked hydraulic return, stored pressure, gravity and a second power feed can defeat the physical safe state independently of A/B. Evidence question: which independent physical witness addresses each failure?

## Qualitative fault tree — not a selected-machine design
Top event: **a person can reach hazardous motion or energy despite a demanded protective stop**.

| Branch | Initiating fault/change | Why an HMI or safety-output bit may look reassuring | Discriminating qualified evidence | Status |
|---|---|---|---|---|
| A1 | Plain diode replaces OEM suppressor | Output turns OFF normally; contactor release may be slower | Exact OEM coil/suppressor and selected stop-time physical witness | DOC mechanism; machine UNKNOWN |
| A2 | Coil plug replaced by built-in suppressor variant | Same connector shell, changed current decay | Exact part/wiring and change-impact validation | INFERENCE; machine UNKNOWN |
| B1 | CR network bridges open contact | Logic says OFF; branch may pass current | Exact impedance, selected load pickup/dropout, fault analysis | DOC mechanism; machine UNKNOWN |
| B2 | Shared return creates sneak path | Main switch open; second circuit backfeeds | As-built return/supply and alternate path trace | DOC mechanism; machine UNKNOWN |
| B3 | Suppressor fails short or supply cross-feed | Normal command is not actual isolation | Selected component failure modes, redundancy, output diagnostics | INFERENCE; machine UNKNOWN |
| C1 | Main contact welded | Coil may be OFF; auxiliary feedback has limited scope | Qualified contactor final-element design and independent energy interruption | DOC general principle; machine UNKNOWN |
| C2 | Hydraulic valve spool fails to shift | Coil voltage falls, pressure/load may persist | Actual valve position/pressure zones and mechanical load support | INFERENCE; machine UNKNOWN |
| C3 | Independent Y1/Y2 holding unavailable | Drive/pump stopped, gravity still acts | Independent physically verified gravity-load restraint | UNKNOWN |
| C4 | Held pedal or stale command survives rearm | Safety outputs recover but ordinary command persists | Deliberate new-start safety/normal control boundary | UNKNOWN |

## Physical-witness chain (each link independently scoped)
1. **Input** — protective device actually detects a hazard; qualified safety input/logic responds.
2. **Safety output** — independently allocated logic withdraws authorization; report and measure within its approved scope.
3. **Electrical final element** — qualified feedback of contactor/valve-drive state; do not equate EDM with energy absence.
4. **Fluid/mechanical final element** — valve spool/flow/pressure/load support as appropriate to actual hydraulic topology; no generic safe de-energized state.
5. **Hazard** — actual Y1/Y2 motion ceases, no dangerous restart or gravity drift; guarded access and maintenance isolation remain distinct.
6. **Restart** — deliberate fresh command after qualified reset, physical safe-state/occupancy checks, and fault recovery; power return or HMI acknowledgment alone insufficient.

A generic paper model cannot validate any of these physical links. An independent final element may still share 24 V, 0 V, pilot pressure, return plumbing, enclosure water ingress, connector harness or service override; record each common cause.

## Change impact and practical anti-defeat
- **CHG trigger:** any coil, diode, suppressor module, DIN plug, valve, contactor, safety output card, indicator lamp, wire/return route, fuse, firmware, guard/maintenance access or restart-mode change. Mark dependent SRS/DEP/PHY/VAL/PT evidence **STALE**, identify the affected physical function, and obtain qualified revalidation before credit.
- **Low-friction default:** keyed/captive prewired OEM plugs, clear part labels, protected but accessible connectors, matching stocked spares, no hidden ad-hoc diode, maintenance disconnect and guard restoration that are easier than bypass.
- **Diagnostic UX:** separate labels for `SAFETY DEMAND`, `OUTPUT OFF`, `CONTACTOR/VALVE FEEDBACK`, `MOTION STOPPED`, `LOAD HELD`, `MAINTENANCE ISOLATED`, `REARM REQUIRED`; never collapse them into one green SAFE indicator.
- **Unsafe shortcut:** adding a second ordinary LinuxCNC/FPGA disable bit cannot cure an unqualified shared coil/final-element path.

## When to freeze a bounded laboratory question
**Not now.** Manufacturer documentation resolves the generic mechanisms; OpenPressBrake Stage A and selected as-built topology are missing. A future lab may be justified **only** for a precise unresolved selected-device question (e.g. a manufacturer-specified suppressor/coil combination whose timing or off-state behavior cannot be established by reliable qualified evidence), with predeclared input, fault, independent witness, stop criterion, and no personnel exposure. If software-only compute becomes necessary, use only self-hosted `[self-hosted, openpressbrake]`; no hosted fallback. A software simulation can verify an electrical model's assumptions but cannot release a press brake.

**No new SOURCE-CONFIRMED LinuxCNC, TEST-CONFIRMED or COMMUNITY-REPORTED claims.** Twenty public paper scenarios across the two modules remain UNSCORED; twenty documentary gates remain NOT RUN. Selected Stage B ten fields UNKNOWN, independent evaluator PREPARED/NOT RUN. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.**
