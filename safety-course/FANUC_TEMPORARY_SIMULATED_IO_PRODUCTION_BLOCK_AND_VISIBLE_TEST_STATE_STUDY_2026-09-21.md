# FANUC temporary simulated-I/O production block and visible test-state study

Date: 2026-09-21

## Why this source matters

The physical-change adversarial review identified a return-to-service loophole: commissioning may pass while temporary forces, simulations, overrides, jumpers, test fixtures, or special modes remain active. FANUC publishes a concrete production-control pattern for one member of that class.

## Source

FANUC America Tech Transfer, `FANUC Simulate I/O, Comment Code`, Jan. 19, 2023:
https://techtransfer.fanucamerica.com/tech-transfer/fanuc-simulate-i-o-comment-code

FANUC describes simulated I/O as useful for debugging when physical components are absent during startup. The training distinguishes simulated inputs/outputs from physical I/O behavior and, because simulation creates production risk, recommends enabling a **Production Check alarm to block automatic operation while simulation is active** and mapping a safety output to make the condition visible to the team.

Evidence label for the FANUC statements above: **SOURCE-CONFIRMED** from current FANUC America training material. The transfer rules below are curriculum **INFERENCE**.

## Safety-course lesson

This is stronger than a checklist reminder to `remove forces before production`. It demonstrates a practical human-factors architecture:

1. temporary commissioning authority has a machine-readable state;
2. that state can automatically inhibit a higher-risk production authority;
3. the exceptional state can be made conspicuous to other people;
4. production restoration requires clearing the exceptional condition rather than relying only on technician memory.

Freeze:

**TEMPORARY TEST STATE USEFUL != TEMPORARY TEST STATE SAFE FOR PRODUCTION.**

**TEST COMPLETED != TEMPORARY FORCE/SIMULATION CLEARED.**

**TECHNICIAN INTENDS TO CLEAR TEST STATE != PRODUCTION INTERLOCK PROVES IT CLEARED.**

**TEST STATE VISIBLE TO ONE PROGRAMMER != TEST STATE CONSPICUOUS TO THE TEAM.**

## Transfer to LinuxCNC / OpenPressBrake

Do not copy FANUC's implementation or promote ordinary LinuxCNC/FPGA software into personnel-safety authority. Instead preserve the design principle:

- commissioning/maintenance-only software states should be explicit and inspectable;
- where practical, ordinary production-cycle authority should fail closed while such a state remains active;
- the HMI should make exceptional states conspicuous rather than hiding them in a diagnostic page;
- restoration should positively verify that temporary forces/simulations/overrides are gone before ordinary production release;
- independent safety functions remain independent; an ordinary production inhibit is not a substitute for required safety-rated protection or energy isolation.

For OpenPressBrake, the exact list of forceable/simulatable signals, who may enable them, whether any such facility will exist, and what safety-rated functions remain independently active are **UNKNOWN** until the architecture is defined.

## Adversarial implications

A robust commissioning procedure should ask not merely `did the test pass?` but:

- Which temporary conditions were introduced?
- Can the machine enumerate them?
- Does any temporary condition survive mode changes, reset, reboot, configuration reload, or operator handoff?
- Is automatic/production authority blocked while a production-incompatible temporary state remains?
- Is the exceptional state visible to someone who did not create it?
- Is there a positive restoration check before production release?

If a platform cannot reliably enumerate temporary states, the release procedure must compensate with stronger configuration restoration and independent inspection; uncertainty is not permission.

## Relationship to setup-mode authority

This complements the parallel Cincinnati setup-mode evidence. A bounded setup/service mode can intentionally retain some motion authority. A temporary simulated/forced state is a different axis of machine state and can coexist with a mode selector. Therefore:

**PRODUCTION MODE SELECTED != TEMPORARY TEST STATE CLEARED.**

**SETUP MODE EXITED != FORCES/SIMULATIONS/OVERRIDES CLEARED.**

Return-to-service must reason about both operating mode and temporary commissioning state.

## Compute

No executable compute is justified. This is a source/architecture lesson, and no GitHub-hosted runner was used.
