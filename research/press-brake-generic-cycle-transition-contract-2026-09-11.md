# Generic press-brake cycle transition contract — evidence-driven draft

Date: 2026-09-11
Status: **DEPENDENCY-SAFE 4600 PREPARATION / DESIGN CONTRACT DRAFT**

Evidence inputs:

- Accurpress public cycle component and HAL chronology;
- pinned LinuxCNC motion/HAL/component behavior already established by the curriculum;
- `research/press-brake-generic-failure-ownership-matrix-2026-09-11.md`;
- `call-flows/press-brake-accurpress-bend-enable-to-pwm-disable.md`;
- `research/press-brake-cycle-timeout-ownership-2026-09-11.md`;
- M66 timeout call-flow and run079 regression evidence.

This is a **generic interface/state contract**, not a ready-to-run machine program. It intentionally contains no invented valve truth table, pressure threshold, tonnage limit, pedal timing, safety PL/SIL, or Y1/Y2 mismatch number.

## Core rule: three states must never be collapsed

A future press-brake control design must track at least three conceptually distinct states:

1. **Semantic process state** — e.g. ready, approach, bend, dwell, decompression, return, fault/recovery.
2. **Ordinary actuator authorization** — whether ordinary LinuxCNC logic is permitted to command motion/hydraulics now.
3. **Safety authorization / safe-state enforcement** — the independent safety system's permission and enforced state.

The Accurpress public source demonstrates why this separation matters: ordinary `bend-enable` can disable PID/PWM while the custom press state can remain in an active semantic state, and the shown remote-E-stop latch is not the producer of that ordinary enable signal.

A correct recovery design therefore cannot equate “actuator output is currently disabled” with “the cycle state has safely returned to READY,” and cannot equate either with “the safety system is healthy.”

## Required state record

Every multi-cycle process state should have these fields documented before implementation:

| Field | Required meaning |
|---|---|
| entry reason | exact predecessor/event that entered this state |
| entry prerequisites | ordinary process conditions that must already be true |
| commanded objective | abstract motion/process objective, not machine-specific valve bits |
| success witness | physical/process evidence that permits normal exit |
| normal next state | deterministic success transition |
| pedal/request semantics | what operator release/up/down/hold means here |
| motion/SYNC interruption | effect of ferror, side mismatch, stale feedback, final saturation/lost authority |
| hydraulic/process interruption | effect of pressure/process fault |
| ordinary authorization loss | what happens if software enable disappears while this state is active |
| safety-permission observation | diagnostic observation only; actual enforcement remains in safety architecture |
| timeout witness | bounded elapsed-state rule where a finite wait is required |
| timeout next state | explicit failure state/action, never “keep waiting forever” by accident |
| diagnostic reason | stable cause code/witness retained across recovery |
| recovery prerequisite | evidence required before leaving fault/recovery |
| restart semantics | resume, restart state, or restart whole cycle; must be explicit |

## Generic state families

### 0 — DISABLED / NOT AUTHORIZED

**Purpose:** ordinary process control has no actuator authority.

Entry examples:
- startup before ordinary prerequisites are established;
- operator ordinary-enable removed;
- machine-control fault policy removes authorization;
- return from recovery before explicit re-arm.

Requirements:
- final ordinary actuator authorization false;
- no automatic transition to active cycle solely because an old semantic target still exists;
- retained prior fault/interruption reason visible for diagnostics;
- transition to READY only after fresh prerequisites are checked.

Important boundary: safety hardware may already enforce a safe state independently. This software state does not substitute for it.

### 1 — READY / TOP / CYCLE-ARMED

Entry prerequisites should include, where applicable:
- ordinary enable valid;
- required motion/joint feedback valid/fresh;
- Y1/Y2 differential monitor healthy on tandem machines;
- final output path not reporting a fault;
- process sensors needed for the upcoming cycle plausible;
- machine-specific top/reference condition valid;
- no latched recovery requirement.

Normal exit:
- explicit operator/program cycle request -> APPROACH.

Interruption:
- ordinary enable loss -> DISABLED;
- newly detected ordinary fault -> FAULT;
- safety-permission loss is observed diagnostically but enforcement belongs to safety system.

### 2 — APPROACH / RAPID CLOSING

Command objective:
- move toward a validated change/contact/start point under ordinary trajectory and tandem-sync authority.

Success witness:
- position/process condition that legitimately marks approach completion.

Pedal/request:
- machine mode must define whether release pauses, aborts or requests return. It may not be left implicit.

Fault exits:
- motion/SYNC fault -> FAULT;
- stale/invalid side feedback -> FAULT;
- hydraulic/process fault -> FAULT or controlled RETURN according to validated ordinary-control policy;
- ordinary authorization loss -> DISABLED/INTERRUPTED with state reason retained.

Timeout:
- if reaching the change point has a finite expected bound, a state-owned timeout must have an explicit failure exit. Do not delegate this to a GUI or non-realtime M66 if servo/process timing matters.

### 3 — WORKING / BEND STROKE

Command objective:
- controlled bend motion/process objective with reduced working speed/appropriate pressure mode as defined by machine-specific design.

Success witness:
- bend target/process completion criterion based on physical truth.

Required observations on tandem machine:
- Y1 physical feedback;
- Y2 physical feedback;
- Y1−Y2 differential witness;
- side correction;
- final side command after all correction and limiting;
- per-side/final saturation authority;
- relevant motion fault state.

Fault exits:
- differential mismatch/lost correction authority -> FAULT;
- pressure exceedance/other process fault -> explicit fault/return state;
- following error -> MOTION fault propagated into process state;
- ordinary authorization loss -> interrupted state, not silent semantic continuation.

The public Accurpress component provides a useful positive example for pressure-limit escape and a negative example for generic timeout/unused abort.

### 4 — BOTTOM / HOLD / DWELL / TWEAK

This family must state whether the machine is:
- holding position/process force;
- waiting for operator release;
- allowing an incremental correction/tweak;
- dwelling for a bounded process time;
- already beginning decompression.

Do not use one ambiguous “bottom” state if these imply materially different hydraulic authority.

Every wait needs:
- success/continue event;
- operator interruption semantics;
- process fault exit;
- ordinary-enable loss behavior;
- finite timeout if indefinite wait is not intentionally permitted.

### 5 — DECOMPRESSION / PRESSURE RELEASE

This state deserves separate treatment where the hydraulic system requires controlled pressure release before full return.

Required fields:
- physical/process witness that decompression is complete or sufficient;
- timeout/fault if that witness never arrives;
- prohibition against assuming commanded valve mode equals achieved pressure state;
- explicit transition to RETURN.

This state is generic because many hydraulic presses require process-aware reversal behavior, but the exact implementation and limits are machine-specific.

### 6 — RETURN / OPENING

Command objective:
- move toward validated top/return position under ordinary motion and tandem synchronization.

Success witness:
- physical top/return position plus any machine-specific process condition required for READY.

Pedal/request:
- define whether releasing return request pauses, completes automatically, or faults; do not inherit approach semantics accidentally.

Fault/timeout:
- motion/SYNC/process faults remain actionable while returning;
- failure to reach top within a required bound must have an explicit terminal transition if a finite expectation exists.

### 7 — FAULT / PROCESS ABORT

This is an ordinary-control state, not the safety system.

Entry reason must be latched and distinguish at least broad cause classes:
- motion following error;
- Y1/Y2 mismatch;
- stale/invalid feedback;
- final command saturation/lost synchronization authority;
- pressure/process fault;
- process timeout;
- field-I/O/transport/watchdog fault;
- internal state error;
- ordinary authorization loss requiring reconciliation.

Requirements:
- ordinary command policy explicitly defined (e.g. inhibit, controlled return only after reauthorization, etc.);
- no automatic clearing merely because the triggering input flickers healthy;
- diagnostic cause retained;
- recovery prerequisites explicit;
- transition to RECOVERY/READY only through deliberate logic.

Do not invent one universal actuator action for every fault: some machines can safely permit controlled return after certain ordinary faults, while others require different hydraulic handling. The state contract must separate the decision from machine-specific output decoding.

### 8 — RECOVERY / RECONCILIATION

Purpose:
- resolve the difference between software semantic state, actual physical state, and restored actuator authority after an interruption.

Required questions:
- Are physical Y1/Y2 positions fresh and plausible?
- Is the machine at a known/referenceable geometry?
- Are planner/trajectory internal positions reconciled with feedback?
- Are PID integrators/output states reset as intended?
- Are final outputs demonstrably disabled before re-arm?
- Has field-I/O transport recovered with fresh evidence rather than merely reconnected?
- Has the original fault cause cleared and remained cleared for the required ordinary qualification interval?
- Does the safety system independently permit operation?
- Is resume-in-place allowed, or must the cycle restart/return home?

The public Accurpress `bend-enable` topology makes this state especially relevant: disabling PID/PWM can remove ordinary authority without forcing `press.state` back to zero. Re-enable semantics therefore need explicit reconciliation even if the original implementation does not provide it.

## Timeout architecture

Timeouts must be owned by the layer whose causal evidence and timing requirement match the failure:

- servo-period side mismatch/stale feedback -> realtime SYNC/feedback layer;
- semantic process wait -> process state machine;
- non-time-critical G-code/supervisory event -> Task/interpreter M66 may be acceptable;
- functional-safety response -> validated safety system.

`M66 Q` is explicitly non-realtime in LinuxCNC documentation and on the pinned revision also has a TEST-CONFIRMED timeout→following-G4 stale-state defect. It is therefore inappropriate as the primary Y1/Y2/process-protection mechanism.

## State-transition review checklist

Before accepting a press-cycle implementation, adversarially ask every active state:

1. What exact physical/process condition proves success?
2. What happens if that condition never arrives?
3. What happens if the operator releases/changes the request?
4. What happens if a joint faults?
5. What happens if Y1/Y2 disagreement grows?
6. What happens if correction saturates downstream?
7. What happens if pressure is missing or excessive?
8. What happens if ordinary actuator enable disappears?
9. What state remains latched after outputs are disabled?
10. What happens if field I/O reconnects after stale data?
11. What diagnostic reason is retained?
12. What exact evidence permits re-enable/recovery?
13. Which action is ordinary control and which is independently safety-enforced?

Any answer of “the signal exists” or “the GUI will notice” is insufficient without tracing the executed path.

## Evidence corrections learned from Accurpress

- A declared `abort` pin is not an abort implementation when the realtime function never reads it.
- An `interlock` input checked only in READY does not define active-cycle interlock-loss behavior.
- A downstream PID/PWM enable can remove ordinary actuator authority even while the semantic process state remains active.
- `estop_latch` being loaded does not prove its `ok-out` gates motion; the net must be traced.
- `simple_tp.enable=false` makes its requested velocity zero but the internal `current_vel` ramps toward zero at `maxaccel`; downstream PID/PWM disable may dominate actual command output.
- Pressure-limit escape can be executable ordinary control without being functional-safety evidence.
- State-machine timeouts suggested in community discussion can remain absent years later; design intent is not implementation evidence.

## Open questions / next work

1. Look for a public mature press-brake implementation that explicitly latches process fault reasons and reconciles state after ordinary enable loss; do not keep mining one source if unavailable.
2. Trace a public implementation of decompression/pressure-release sequencing if available.
3. When the 4600 track is formally activated, turn this contract into an executable simulation with fault injection for at least: pedal release, process timeout, side mismatch, final saturation, ordinary-enable loss and recovery.
4. Keep machine-specific valve mapping and safety circuit design outside this generic public artifact unless supported by public evidence.

## Sufficiency decision for this lesson

The state-transition contract is now specific enough to audit future public implementations without inventing machine constants. It incorporates both positive and negative source evidence and explicitly handles the state/authority split exposed by the Accurpress config. Further progress should come from an independent implementation or later executable 4600 simulation, not from repeatedly rereading the same Accurpress files.
