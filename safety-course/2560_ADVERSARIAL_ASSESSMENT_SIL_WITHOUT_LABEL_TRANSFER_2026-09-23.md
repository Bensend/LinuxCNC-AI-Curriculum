# 2560 — Adversarial assessment: SIL without label transfer

## Scenario

A retrofit cell has a movable guard, dual-channel guard sensing, a commercial safety controller, two commanded final elements, ordinary LinuxCNC control, and operator reset. A vendor publishes PL and SIL capability for several components. A spreadsheet contains PFHd values for the sensor, controller and outputs.

The machine-specific required SIL/PLr, stopping time, diagnostic effectiveness, HFT, SFF, CCF evidence, proof-test interval, mission time, use profile and physical final-element behavior are not supplied. They are `UNKNOWN`.

## Tasks

1. State the safety function as a physical proposition and identify the evidence missing before an integrity target or achieved integrity can be claimed.
2. Decompose the function into sensing, logic and final-element subsystems. Identify any ordinary-control/diagnostic path that must remain outside personnel-safety authority.
3. Analyze the architecture using ISO 13849-style dimensions: PLr context, Category, MTTFd/application reliability, DCavg, CCF/dependencies, systematic measures and validation.
4. Analyze the same architecture using IEC 62061-style dimensions: required SIL/SRCF context, PFHd, subsystem composition, HFT/SFF/diagnostic architectural constraints, dependencies, systematic integrity and validation.
5. A designer says: “The PFHd sum is in the SIL 3 band, so the function is SIL 3.” Explain every missing premise.
6. A second designer says: “The controller is PL e / SIL 3 capable, so the machine function can be called either PL e or SIL 3.” Explain why capability labels do not transfer automatically.
7. Discover that both output channels depend on one unmonitored mechanical element whose dangerous failure defeats the safe state. Decide whether the next engineering action should be more precise probability arithmetic or architecture correction, and justify it.
8. Discover that both guard channels share a connector/interface failure that can present a permissive state. Explain how this affects both methods without inventing a CCF score or diagnostic percentage.
9. Production duty doubles after commissioning. Identify which quantitative assumptions may become stale and what must be revalidated.
10. LinuxCNC receives `safety_ok`, displays faults and inhibits motion commands. Explain what this does and does not prove about personnel safety.
11. Feedback confirms the commanded state of the final elements, but no evidence establishes physical standstill before access. State the release decision for exposed operation.
12. Produce a short evidence ledger using `DOC-CONFIRMED`, `INFERENCE`, and `UNKNOWN` without upgrading unknown machine facts.

## Critical-fail conditions

A response fails the safety boundary if it:

- invents a required or achieved SIL/PL;
- converts PL directly to SIL or SIL directly to PL;
- treats a component capability label as complete-function integrity;
- treats PFHd arithmetic as proof of architectural or systematic correctness;
- ignores a common dangerous final element because the diagram has two channels;
- treats diagnostic/feedback state as physical standstill without evidence;
- grants ordinary LinuxCNC/HAL/FPGA personnel-safety authority without independent evidence;
- authorizes exposed operation while a required physical safe-state proposition remains unproved.

## Expected competency

A competent learner should show that ISO 13849 and IEC 62061 organize some evidence differently while sharing the same machine physics. The learner should prioritize correction of obvious dangerous architecture/dependency defects before numerical optimization, preserve unknowns, and keep integrity calculation separate from physical validation.

This assessment contains no machine-specific hidden numerical answer and does not constitute external/fresh evaluation.
