# Safety Evidence Conflict Adjudication Worksheet

Date: 2026-09-16
Status: durable independent safety-curriculum artifact
Scope: LinuxCNC / OpenPressBrake safety evidence when observers disagree

## Purpose

A safety review becomes most valuable when the evidence does **not** agree. This worksheet prevents a convenient controller status, HMI indication, log entry, or previous PASS from silently overruling a conflicting physical witness.

Core rule:

> **Conflict is evidence. Do not average it away, vote it away, or choose the observer that makes the machine look safest.**

A conflict must be decomposed into exact claims, observers, independence, freshness, configuration identity, and physical scope. Until the conflict is resolved, the stronger safety claim remains `UNKNOWN` and the affected safety function must not be promoted as validated.

This worksheet does not establish PL, SIL, Category, PFHd, stopping distance, protective distance, hydraulic thresholds, proof-test intervals, or machine suitability.

## Provenance vocabulary

Use only these labels for conclusions/evidence:

- `SOURCE-CONFIRMED` — verified directly in inspectable source/code/configuration.
- `DOC-CONFIRMED` — supported by authoritative documentation.
- `TEST-CONFIRMED` — demonstrated by a recorded test within its tested boundary.
- `COMMUNITY-REPORTED` — reported by a community/user source but not independently verified here.
- `INFERENCE` — reasoned conclusion whose premises are stated.
- `UNKNOWN` — evidence is absent, contradictory, stale, unbound, or insufficient.

Never relabel an unresolved conflict as `TEST-CONFIRMED` merely because one channel passed.

## Conflict record

For every disagreement record:

| Field | Entry |
|---|---|
| Conflict ID | |
| Exact physical claim | |
| Hazard / safety function | |
| Observer A and value | |
| Observer B and value | |
| Additional observers | |
| Commanded state | |
| Configuration / revision | |
| Session / boot identity | |
| Freshness / timestamp evidence | |
| Independence relationship | |
| Raw artifacts retained | |
| Immediate bounded conclusion | |
| Remaining `UNKNOWN` | |
| Required discriminating test | |
| Restart / rearm restriction pending resolution | |

## Adjudication sequence

1. **Write the claim physically.** Replace `E-stop works` with claims such as `safety output de-energized`, `contactor main poles opened`, `valve command/current was removed`, `ram motion stopped`, or `stored energy was rendered safe`.
2. **Separate command from observation.** A command bit, LinuxCNC state, FPGA register, safety-logic output, contactor auxiliary contact, pressure indication, encoder trace, and direct physical observation are different witnesses.
3. **Check freshness before truth.** A plausible but stale value is not present-state evidence.
4. **Check configuration binding.** Evidence from a previous wiring, firmware, guard, hydraulic, or safety-logic configuration cannot automatically settle a current conflict.
5. **Map common cause.** Two agreeing software displays derived from the same bit are one logical witness, not two independent votes.
6. **Prefer the witness closest to the disputed physical fact, but only within its demonstrated scope.** A mechanically linked mirror contact may be stronger evidence of contactor state than a command echo; it still does not prove downstream hazardous energy is harmless.
7. **Treat unsafe disagreement conservatively.** If any credible independent witness indicates the hazardous state may remain, do not clear the safety claim by majority vote.
8. **Design a discriminating test.** Challenge the point where the hypotheses differ, using an observer independent enough to distinguish them.
9. **Test recovery separately.** Resolving the original discrepancy does not automatically authorize reset, rearm, restart, or release of a guard.
10. **Preserve the conflict.** Keep raw contradictory evidence and the resolution trail; do not delete the losing observation from the record.

## Conflict classes

### A. Command says OFF; final-element feedback says ON

Examples: LinuxCNC/FPGA command removed but contactor feedback remains made; safety output low but valve-current witness remains energized.

Immediate conclusion:
- command-path de-energization may be `TEST-CONFIRMED` if directly observed;
- final-element safe state is `UNKNOWN` or contradicted;
- hazardous physical state remains `UNKNOWN` unless independently observed.

Do not reset/rearm simply because software commanded OFF. Investigate welded/stuck final element, wiring error, feedback inversion/failure, stale feedback, or measurement error without assuming which one occurred.

### B. Feedback says SAFE; physical behavior disagrees

Examples: contactor mirror reports open while hazardous motion remains; zero-pressure switch reports safe while a supported load can still move; guard status is safe while access remains possible.

The feedback device proves only what its architecture and validation establish. Physical contradictory evidence prevents promotion to `hazard removed`. A safe-indicating sensor is not allowed to overrule credible hazardous physical behavior.

### C. Two sensors disagree

Do not implement `2-of-3` or choose the median by curriculum habit unless the actual safety architecture requires and validates that behavior. Record each sensor's independence, failure modes, diagnostics, range, wiring, freshness, and physical quantity. Until resolved, the physical quantity is `UNKNOWN` unless another qualified witness bounds it.

### D. Current test contradicts an older validated baseline

Do not preserve the older PASS by declaring the new test an outlier. First check configuration identity, instrumentation, procedure, environment, and raw artifacts. If the current credible test exposes a previously unseen failure, prior evidence is narrowed or invalidated for that condition.

### E. Raw artifact conflicts with transformed/exported evidence

Raw trace and derived CSV/report disagreeing is a chain-of-custody problem. Freeze both artifacts. Reconstruct filtering, unit conversion, sample selection, dropped channels, timebase conversion, cropping, spreadsheet formulas, and export scripts. Do not silently regenerate the report and discard the discrepancy.

### F. Wall-clock order conflicts with causal order

Unsynchronized clocks, reboot time jumps, buffering, network delay, and log flush order can create false sequences. Prefer monotonic/session-local ordering where available. If event order is material and cannot be reconstructed, causal order is `UNKNOWN`; do not claim a required reaction time or sequence.

### G. Configuration signature matches; physical installation disagrees

A matching software/safety signature can support configuration identity within that signature mechanism's scope. It cannot overrule evidence of changed field wiring, swapped devices, altered guards, hydraulic changes, mechanical blocking changes, or other facts outside that signature.

## Conflict severity gates

Use these qualitative gates; do not assign a numerical score.

- **STOP-CLAIM** — credible evidence directly contradicts the proposed safety claim. Do not validate or rearm on that claim until resolved.
- **HOLD-FOR-REVIEW** — conflict may be provenance/freshness/configuration related, but resolution is required before the affected conclusion is accepted.
- **BOUNDED-NONCONFLICT** — apparent disagreement is explained and both observations can coexist because they concern different layers or times; record the bounded conclusions separately.

`BOUNDED-NONCONFLICT` is not permission to call the whole machine safe.

## Discriminating-test design

A useful conflict-resolution test answers one question that separates competing explanations. Record:

- disputed physical fact;
- hypothesis A and hypothesis B;
- stimulus that makes their predicted observations differ;
- independent witness used;
- why that witness is independent enough;
- test configuration identity;
- raw data to retain;
- safe test boundary / isolation needed;
- expected bounded conclusion for each possible result;
- recovery and rearm steps after the test.

Do not energize hazardous equipment merely to produce evidence. Where a physical challenge cannot be performed safely, preserve the conflict as `UNKNOWN` and design the required controlled commissioning test instead.

## Adversarial cases

1. HMI shows `ESTOP`; safety-controller output says OFF; contactor auxiliary remains ON.
2. LinuxCNC reports amplifier disabled but encoder shows continued axis motion.
3. FPGA watchdog removes proportional-valve command but measured coil current does not decay as expected.
4. Two pressure sensors disagree after pump shutdown.
5. Guard interlock reports closed while a physical inspection shows the actuator is not fully engaged.
6. Safety log records reset after guard closure, but video indicates a person remained inside the safeguarded space.
7. Old commissioning trace passed; current identical procedure fails after an undocumented cable replacement.
8. CSV report shows a stop before access, while raw monotonic trace shows access input changed first.
9. Safety signature matches archived value, but a contactor was replaced with different auxiliary-contact wiring.
10. A sensor returns `safe` immediately after controller reboot while its freshness/session identity is not established.
11. Three UI screens agree because all subscribe to the same stale network value; an independent physical witness disagrees.
12. Maintenance record says hydraulic pressure was relieved, but the only pressure evidence was a controller tag derived from a commanded dump-valve state.

## LinuxCNC / ordinary FPGA authority boundary

LinuxCNC and the ordinary OpenPressBrake FPGA may:

- expose command/feedback disagreement;
- timestamp and preserve observations;
- inhibit ordinary production commands;
- invalidate stale data;
- require explicit ordinary-control rearm;
- help execute a controlled diagnostic procedure.

They do **not**, merely by implementing these functions, become personnel-safety authority. Their agreement does not prove a safety-rated final element, energy isolation, physical stopping performance, space clearance, or lockout condition.

## Stored-energy boundary with the primary lane

The primary safety lane is currently advancing stored-energy / zero-energy versus safe-energy teaching. This worksheet deliberately does **not** define machine-specific zero-energy criteria, pressure limits, discharge times, gravity-blocking capacities, or acceptable energized-maintenance states.

When evidence conflicts about stored energy, this worksheet only governs adjudication: identify the physical quantity, observers, independence and freshness, then defer the actual safe/zero-energy criterion to the applicable authoritative procedure and machine-specific validation.

## Authoritative documentation notes

- `DOC-CONFIRMED` — OSHA 29 CFR 1910.147 defines energy-isolating devices as physical devices preventing energy transmission/release and explicitly excludes pushbuttons, selector switches, and other control-circuit devices from being energy-isolating devices.
- `DOC-CONFIRMED` — OSHA 29 CFR 1910.147(d)(5) requires potentially hazardous stored/residual energy to be relieved, disconnected, restrained, or otherwise rendered safe, with continued verification when hazardous reaccumulation is possible.
- `DOC-CONFIRMED` — OSHA 29 CFR 1910.147(d)(6) requires an authorized employee to verify isolation and deenergization before work.
- `DOC-CONFIRMED` — OSHA's 2012 interpretation states that relying solely on an LED indication does not satisfy the affirmative verification requirement. This supports the general curriculum rule that an indication is bounded evidence, not automatic proof of the underlying physical condition.

## Open OpenPressBrake facts

Keep `UNKNOWN` until the final machine is measured/designed/documented:

- actual safety-controller and final-element architecture;
- hydraulic stored-energy behavior and reaccumulation paths;
- ram/gravity/load-retention behavior;
- stopping time and protective distance;
- sensor types, independence and diagnostic assumptions;
- acceptable physical thresholds and tolerances;
- required PL/SIL/Category and quantitative reliability values;
- proof-test intervals and calibrated instrumentation requirements.

## Precise next independent work

If still independent of the primary lane, build a **sensor/feedback independence and common-cause worksheet**: trace shared power, wiring, reference, network, software derivation, mechanical linkage, environmental exposure and configuration dependencies so multiple agreeing channels are not falsely counted as independent evidence. Include stale/frozen common-mode cases and explicitly avoid inventing diagnostic-coverage percentages.