# 2530 — Adversarial assessment: E-stop from first principles

This is learner-facing. It tests reasoning from hazards and physical propositions rather than memorized relay topologies. Do not assign a PL/SIL, stop category, stopping distance, diagnostic-coverage percentage or machine-physics value unless the scenario explicitly supplies the evidence needed to derive it.

## Scenario

A generic automated cell contains:

- an electrically driven rotating tool with unknown coast-down time;
- a vertical fluid-power axis whose load-holding behavior after electrical power loss is not supplied;
- a pneumatic workholding device with unknown trapped-energy behavior;
- an infeed conveyor and an outfeed conveyor;
- a guarded operator access area around the process;
- three fixed E-stop devices: operator station, load station, maintenance side;
- one detachable teaching pendant with an E-stop device;
- independent safety-related control hardware plus ordinary LinuxCNC/FPGA machine control;
- a normal Cycle Start button that can remain physically held;
- two final electrical contactors with mechanically associated auxiliary feedback contacts.

The design brief says only: "make E-stop safe and convenient." No stopping measurements, risk-derived integrity target, hydraulic/pneumatic truth table, guard occupancy system, or final span map is supplied.

## Part A — refuse the attractive shortcuts

For each statement classify it as `SUPPORTED`, `UNSUPPORTED`, or `CONDITIONALLY POSSIBLE`, and state the missing evidence:

1. "Use Category 0 because E-stop means remove all power immediately."
2. "Two NC channels mean the E-stop is PL e."
3. "Two contactors and EDM prove the rotating tool has stopped."
4. "LinuxCNC can latch the E-stop, so the independent safety relay is redundant."
5. "If all three fixed E-stops stop the whole line, segmentation analysis is unnecessary."
6. "If the reset button is outside the fence, pressing it proves nobody is inside."
7. "The pendant is unplugged, so its E-stop can simply remain visible and inactive."
8. "When safety permission returns, a Cycle Start that remained held can resume production."

Critical failure: accepting any of 1–8 as universally true without identifying its missing physical/integrity evidence.

## Part B — derive propositions before topology

Write separate physical safe-state propositions for at least:

- rotating-tool hazard;
- vertical-axis/gravity hazard;
- pneumatic workholding/stored-energy hazard;
- conveyor transfer/adjacent-zone hazard;
- personnel exposure during reset/rearm.

For every proposition state whether the supplied scenario can prove it. Where evidence is absent, mark `UNKNOWN` and specify the measurement, machine documentation, risk/SRS decision or physical witness required.

## Part C — stop strategy

The rotating tool might coast longer if simply de-energized; the vertical axis might require active holding; pneumatic exhaust might release a clamped part. None of those physical behaviors is supplied.

1. Explain why Category 0 versus Category 1 cannot be selected by vocabulary alone.
2. Identify which auxiliary functions may need to remain energized during an emergency reaction.
3. State what evidence would be required to decide whether controlled stopping reduces risk.
4. Explain why a controlled stop followed by energy removal still requires independent validation of the final physical proposition.

Expected reasoning property: the learner must preserve `UNKNOWN` instead of inventing deceleration, pressure, brake or valve behavior.

## Part D — fault-driven architecture

Start from one NC E-stop contact driving one ordinary controller input. For each fault below, state dangerous effect, whether the current architecture detects/tolerates it, and the narrowest justified improvement:

- contact stuck permissive;
- wire shorted to permissive supply;
- second channel shares the same damaged cable;
- safety logic output behaves correctly but one contactor main pole welds;
- both contactors report expected auxiliary feedback but tool still rotates;
- reset contact is tied down;
- common 24 V field supply fails in a way that makes several witnesses unavailable;
- post-maintenance E-stop actuator/contact geometry is misassembled while electrical continuity looks normal.

The learner must distinguish input diagnostics, logic diagnostics, final-element feedback and physical-process proof.

## Part E — span of control

Propose a *provisional* span map for the three fixed E-stops and pendant, but do not finalize it. List the evidence needed to decide whether feeder/process/outfeed can be separate spans.

Then analyze:

- material accumulation if infeed stops while process/outfeed continue;
- a person entering the guarded process area while an adjacent conveyor remains active;
- stopping one section removes a holding/cooling/braking function shared with another;
- two E-stops with different spans are mounted side by side with identical appearance;
- pendant is disconnected but visually available.

Correct reasoning must treat clear span identification and inactive-device confusion as safety-interface issues, not merely documentation polish.

## Part F — reset, rearm, restart

Construct a state sequence that keeps distinct:

`device released -> input diagnostics valid -> final-element feedback valid -> required physical propositions fresh -> reset eligible -> deliberate reset accepted -> ordinary control permitted -> fresh Cycle Start`

Explain what happens if:

- the original emergency cause remains;
- the reset operator cannot see a person-sized hidden region;
- Cycle Start remained held throughout the event;
- safety communications recover before physical-process evidence is fresh;
- power returns to ordinary control before the safety system is ready.

Critical failure: any sequence in which E-stop release or safety reset itself initiates hazardous production motion.

## Part G — LinuxCNC boundary

At pinned LinuxCNC source revision `514be4f657b2f1c432ebaaebd117ef112e3e7565`, `estop_latch` can latch software fault state, require a reset edge and provide an OK/fault/watchdog state.

1. Give three legitimate ordinary-control uses for that information.
2. Give three machine-safety propositions that the software latch cannot prove from its source behavior.
3. Explain why an external safety state may be mirrored into HAL without transferring safety authority to HAL.
4. Explain why a toggling software watchdog is not equivalent to a validated physical emergency reaction.

## Part H — commissioning/validation matrix

Create rows for at least:

- each installed E-stop device and its span;
- one covered input wiring fault;
- one uncovered/common-cause input fault;
- one welded final-element fault;
- reset tied/held behavior;
- retained Cycle Start;
- power-cycle/recovery;
- pendant connected/disconnected state;
- physical stopping proposition for rotating tool;
- physical proposition for vertical axis;
- pneumatic stored-energy proposition;
- adjacent-span interaction.

Each row must contain `requirement/PROP`, stimulus/fault, expected safety reaction, evidence/witness, pass criterion, and revalidation trigger. If the scenario lacks a numeric criterion, write `UNKNOWN — must be derived/measured`; do not fabricate one.

## Scoring dimensions

Score 0–2 each:

1. hazard/PROP derivation before topology;
2. uncertainty discipline;
3. stop-strategy reasoning from physics;
4. fault-specific diagnostic reasoning;
5. EDM/final-element evidence boundary;
6. common-cause reasoning;
7. span/adjacent-hazard reasoning;
8. reset/rearm/restart separation;
9. LinuxCNC safety-authority boundary;
10. validation/revalidation quality.

A high score requires mechanism reasoning, not terminology. Any invented machine-specific safety fact, generic PL/SIL claim from topology, or migration of sole personnel-safety authority into ordinary LinuxCNC/FPGA logic is a critical correction item regardless of total score.

## Instructor/source check

Use these learner-readable artifacts to check reasoning:

- `2530_ESTOP_FIRST_PRINCIPLES_SOURCE_PREP_2026-09-22.md`
- `2530_ESTOP_ARCHITECTURE_COMPARISON_AND_FAULT_MAP_2026-09-22.md`
- `2530_LINUXCNC_ESTOP_LATCH_BOUNDARY_TRACE_2026-09-22.md`
- `2530_ESTOP_SPAN_OF_CONTROL_AND_RESET_HUMAN_FACTORS_2026-09-22.md`
- 2520 verification/validation and fault-analysis methodology.

This assessment is adversarial curriculum material, not the still-open information-separated 2520 competency oracle.
