# 4400-ACC-SAF-01 — Power-off accumulator bleed is a variant-specific proposition

**Status:** NON-GRADUATED 4400 safety learner module, 2026-10-25. **Prerequisites:** 2520 hazard-to-SRS, 2530 E-stop versus isolation, 2580 fluid power, 4400 BLOCK-01 ram support and 4400 LOTO-TEAM-01. [Original HYDAC/Parker audit](../research/4400_HYDAC_SAF_2021_VARIANT_DEENERGIZED_BLEED_AND_PARKER_DUAL_ENERGY_AUDIT_2026-10-25.md).

## Competency target

A fresh engineer can identify an actual accumulator bleed block's complete order code, explain why **E/M** and **Y/Z** substitutions are safety-relevant, distinguish hydraulic from nitrogen gas energy, draw the independent load-holding boundary, and specify what would constitute a physical witness **without** inventing a press-brake hydraulic circuit.

## A worked documentary counterexample

Two hypothetical SAF blocks have identical appearance and ordinary HMI “BLEED” status. One is HYDAC **SAF...E...Y**, the other **SAF...E...Z**. Original HYDAC 4.21 H5 defines the former as a **normally-open** solenoid bleed and the latter as **normally-closed**. If a safety argument assumes “remove coil power -> open bleed -> accumulator discharged,” the Z substitution breaks its first premise. Even with Y, a blocked return, wrong port mapping or failed valve can break physical discharge. Neither arrangement proves the elevated ram is held.

**Do not turn this into a universal recommendation for Y.** The machine may need stored accumulator energy to complete a protective cycle, and the safe physical reaction depends on selected machine hydraulics. The point is to freeze the **required safety function first**, then select and verify the correct variant.

## Four layers of authority

| Layer | May establish | Must not be promoted to |
|---|---|---|
| Ordinary LinuxCNC/HAL/FPGA | commanded idle, hydraulic-pump request, “bleed” command, logs and HMI pressure display | Independent personnel-safety stop, physical isolation, zero pressure or ram holding |
| Safety-related control (selected and validated) | independent demand to the selected bleed/shutoff/final elements, diagnostics and reset inhibit | Proof that hydraulic energy is actually gone or the ram cannot descend |
| Physical energy control | lockable isolation, correctly routed bleed, separate fluid pressure-zone measurement, qualified vessel service and mechanical load support | A generic safe-state claim absent machine-specific witnesses |
| Human/service control | qualified LOTO, captive supports, labeled gauges/ports, access/escape, personal control and deliberate rearm | Automatic authorization to move after a reset |

## Proposed proof contract (not a machine test)

**SRS-ACC-1 (conditional):** If a hazard assessment establishes a need to discharge an accumulator on a specified protective demand, identify the exact installed variant, required deenergized state, required discharge path and its dependencies. Confirm with manufacturer schematic and qualified physical verification.

**SRS-ACC-2:** Treat **fluid-side depressurization**, **gas-side vessel pressure**, **other trapped hydraulic cavities**, and **gravity-loaded ram restraint** as separate hazard propositions. A single pressure gauge is not a substitute for the others.

**SRS-ACC-3:** A maintenance isolator must be appropriately lockable, identified, and independently verified. A manual bleed is not itself a personal lock; a solenoid bleed is not necessarily a physical energy-isolating device.

**SRS-ACC-4:** After fault, power restoration, valve replacement, gas service, hydraulic plumbing work, or reset, invalidate affected physical witnesses and require qualified change review, safe-state proof, guard/occupancy verification and a **new intentional motion command**. “Safety READY” is not cycle-start.

**SRS-ACC-5:** If the accumulator supports protective movement or gravity holding, determine the safe ordering of protective stop, isolation and discharge from the selected design; do not dump blindly or assume all pressure should be removed during an emergency stop.

## Low-friction human factors

Keep an exact order-code photograph and port map in a labeled pocket on the machine; use conspicuous service labels for fluid/gas/ram energy, accessible lockable disconnects and manual bleeds, and provide the correct gauge/test fitting without forcing technicians to loosen pressure lines. A support should be easy to fit and store where it is needed. If normal maintenance requires defeating a guard to reach a bleed, redesign access rather than relying on discipline.

## Fault and transfer exercise

Draw the energy path for an accumulator-equipped press, then replace the assumed E/Y block with M or E/Z. Mark which claims become **STALE**, what physical evidence is missing, and why a green HMI remains only diagnostic. Transfer to a lathe hydraulic chuck (clamp force), robot counterbalance axis, or injection-molding machine; do not transfer the same bleed timing or safe state.

## Evidence, release and next step

**DOC-CONFIRMED:** HYDAC 4.21 model code and optional devices; Parker HY10-2300-M1 distinct hydraulic/gas maintenance steps. **INFERENCE:** SRS decomposition and practical interface pattern. **UNKNOWN:** installed OpenPressBrake accumulator, port map, pressure/holding/stopping behavior and safety integrity. **SOURCE-CONFIRMED new LinuxCNC:** none; **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none relied upon.

Work the [14 public PAPER cases](4400_ACC_SAF_01_FOURTEEN_VARIANT_ENERGY_AND_RESTART_TECHNICIAN_CASES_2026-10-25.md) and [12-gate blank documentary witness](4400_ACC_SAF_01_TWELVE_GATE_NO_ENERGY_VARIANT_AND_PRESSURE_ZONE_REVIEW_2026-10-25.md). They are **UNSCORED/NOT RUN**, not blind competency or physical machine validation. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** If basic safe-to-operate threshold cannot be shown, **no personnel-exposed operation**; any authorized experiment must be isolated/remote with people outside the hazard and residual risk stated.
