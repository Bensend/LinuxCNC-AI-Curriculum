# 4400-LOTO-TEAM-01 — Keep every maintenance worker protected across shifts

**Status:** learner-facing safety course, NON-GRADUATED; 2026-10-25. Prerequisites: 2520 hazard/SRS, 2530 E-stop versus isolation, 2580 hydraulic energy, 4400 BLOCK-01 ram support. Source audit: [OSHA original-authority investigation](../research/4400_OSHA_GROUP_LOTO_SHIFT_CHANGE_REACCUMULATION_AND_TEST_POSITION_AUDIT_2026-10-25.md).

## Learning outcome
Given a multi-person press-brake service job, a fresh learner can draw the *physical energy path* and *personal protection path* separately; explain shift handoff, stored-energy reaccumulation, temporary energized testing, and independent ram restraint; and identify when the machine must stay out of service. This is not a certification or permission to work on energized equipment.

## Four distinct authorities
1. **Normal control:** LinuxCNC/HAL/FPGA can request idle, hold, stop or controlled positioning. It is not a maintenance isolator.
2. **Safety-related control:** independently allocated safety devices may demand protective stop and inhibit restart, with function-specific verified behavior.
3. **Physical energy control:** lockable supply disconnects, hydraulic isolators, verified bleed paths, suitable mechanical ram supports and other machine-specific means control energy. STO alone does not dissipate trapped pressure or arrest a gravity-loaded ram.
4. **Individual personnel control:** each exposed authorized worker's own lock/tag, named group coordinator, contractor coordination and continuous shift protection prevent one person's convenience from unilaterally restoring hazardous energy.

**Rule:** A green HMI, safety relay READY, servo disabled, hydraulic pump stopped, or locked *box* does not prove the selected Y1/Y2 ram is held, pressure is absent at every hazardous point, or every exposed worker is accounted for.

## Practical group-lockbox pattern (conceptual, not a machine wiring design)
A qualified authorized worker inventories each energy source, physically isolates and secures it, controls stored energy, verifies isolation, then places controlled keys into a group lockbox. Each exposed worker attaches their personal lock/tag before work. The designated primary maintains exposure status; each participant has the opportunity to verify personally. A job lock or equivalent preserves protection through shift changes while incoming workers attach their protection and incoming shift verifies effective isolation. Do not assume a group lockbox automatically addresses a pressure pocket or ram weight.

**Human factors:** Provide one clearly labeled lockbox at the machine, unambiguous isolation-point IDs, captive/visible ram-support storage, readable zone maps, and a one-page handoff board. A routine requiring workers to hunt for tools, keys, instructions or a supervisor invites shortcuts; fix the workflow rather than normalize bypass.

## Temporary energized testing is not maintenance mode
1910.147(f)(1) establishes a sequence for necessary test/position: clear tools/materials, clear personnel, remove LOTO devices under required removal procedure, energize for bounded test/position, then deenergize and reapply LOTO before resuming hands-on service. Do not 'partially unlock for a moment' while another person remains exposed. A guarded, remotely supervised test may still require additional safeguards, risk assessment and selected-machine proof. Never infer that 'slow jog' is safe near a press-brake ram.

## Failure-to-safe reasoning
- **Shift turnover:** crew A departs, crew B sees a signed card. The card alone is not a fresh verification. Incoming shift must preserve physical isolation and perform effective verification before starting.
- **Hydraulic reaccumulation:** a gauge reading at one port is not proof that another isolated cavity is safe. Reverification/monitoring is required when hazardous reaccumulation is possible; design-specific zones and intervals remain UNKNOWN.
- **Shared key:** one worker removes a supervisor lock while another is inside. Personal locks and a coordinated group procedure prevent a single routine action from defeating another person's protection.
- **Test interrupted:** powered positioning ends but personal locks are not reapplied. Hands-on work remains prohibited until deenergization, reapplication and verification are complete.
- **Rescue:** manual emergency lowering may release the very load being restrained. Rescue requires an engineered, qualified, isolated method; do not improvise a hydraulic release around trapped personnel.

## Selected-machine release gate — all NOT RUN
A qualified evaluator must identify machine and hazard zone; obtain actual Y1/Y2 load paths and independent supports; map electrical feeds and hydraulic pressure zones; verify installed isolators/bleeds; establish exact personnel/contractor shift handoff; confirm independent stopping/holding and guarding; validate return-to-service reset and *fresh* motion command. Record real physical measurements only after safe authorized commissioning. Until then: **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD**. No people-exposed operation.

## Transfer to other machines
A mill may have spindle/coast and pneumatic drawbar energy; a lathe has rotating work and hydraulic chuck; plasma has high-voltage and stored capacitor energy; a robot cell has gravity-loaded axes and multiple access points. Group personal control and shift continuity transfer; exact physical isolators, holding devices, test procedures and applicable machine standards **do not**.

## Evidence and graduation
**DOC-CONFIRMED (indexed official OSHA):** 1910.147(f)(1)–(4), (d)(5)–(6), OSHA 2023/1999 interpretations. **INFERENCE:** proposed user-friendly lockbox/handoff layout. **UNKNOWN:** OpenPressBrake as-built facts and independent evaluation. **SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. External evaluator NOT RUN; this module is not graduated. Never claim any PL/SIL, hydraulic threshold, stopping distance or safety release from this paper exercise.
