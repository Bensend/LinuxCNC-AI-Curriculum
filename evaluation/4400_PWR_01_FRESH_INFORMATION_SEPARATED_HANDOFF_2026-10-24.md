# 4400-PWR-01 — Fresh-AI independent transfer assignment

**Status: PREPARED / NOT ADMINISTERED / NOT SCORED.** This is a learner-facing challenge contract, not an answer key or blind benchmark. Evaluator must supply independent unseen OEM/source evidence and withhold its scoring resolution until the learner's immutable precommitment. No hidden solution is included here.

## Competency to evaluate

Transfer the 4400-PWR-01 principle to an **unfamiliar safety-controller/receiver combination**, recognizing common power/return faults, cross-channel diagnostic coupling, physical final-element authority, safe restart and the difference between electrical output and physical safety. Do not merely repeat SICK numbers.

## Novel case packet for a fresh learner

A small machine retrofit keeps an existing safety-rated controller and replaces the normal motion computer with LinuxCNC plus an ordinary FPGA. The safety controller's outputs switch two contactor/valve-related loads through a new removable terminal strip. A new I/O expansion module shares a 24 V supply with a relay bank and a communication adapter. The electrician combines two load returns on one plug to reduce wiring. A safety input status intermittently shows `HIGH` after a guard opens, while the machine HMI shows `SAFETY READY`. An installer suggests disabling output diagnostics because the new load is capacitive. The machine has a vertical load and an enclosed service access zone.

The owner provides only these observations: (1) the normal controller remains online, (2) the safety-controller program checksum is unchanged, (3) an auxiliary contact reports a contactor opened once during a non-hazardous bench check, (4) a recent supply interruption was logged, and (5) no qualified physical stopping/holding or residual-energy measurement exists. The actual safety controller and output-card model are intentionally **not supplied**.

### Learner deliverables — precommit before evaluator feedback

1. Draw four separate authority chains: ordinary CNC/FPGA, safety input/logic/output, physical final element/load, maintenance isolation.
2. Identify at least **six plausible failure paths**, separating OEM-verifiable facts from hypotheses. Include a **common return**, **receiver capacitive response**, **diagnostic coupling**, **power restoration**, **physical vertical holding**, and **stale normal start**.
3. Rank the **first eight evidence requests** that would most efficiently discriminate the hypotheses. Do not guess module terminal names, thresholds, PL/SIL or stopping distance.
4. State what a `HIGH` input, controller RUN, output OFF, and auxiliary contact *each* can and cannot establish.
5. Propose a practical low-cost architecture change that reduces bypass incentives while preserving independent safety authority.
6. Give a clear minimum safe-to-operate disposition for personnel exposure and for isolated/remote experimentation.
7. Provide at least **two falsifiers** of the leading hypotheses, confidence 0–100%, time spent, and exact sources consulted.

### Allowed learner material

`START_HERE.md`, `SOURCE_POLICY.md`, `safety-course/4400_PWR_01_SAFETY_IO_SUPPLY_RETURN_AND_DIAGNOSTIC_CONFIG_MODULE_2026-10-24.md`, the linked learner-visible SICK audits and public original OEM manuals. Learner may request the actual controller/model rather than hallucinate it. Do not reveal evaluator's independently selected alternative OEM, hidden expected answer or scoring before precommit.

## Independent evaluator procedure

1. Select a **different real safety controller/output receiver** (not a verbatim SICK FX3-XTIO exercise) with an original accessible manufacturer manual and a meaningful supply/return/diagnostic fault boundary. Record the exact edition, pages and evidence privately. If no suitable independent oracle exists, mark evaluation **BLOCKED**, not passed.
2. Freeze the case packet and record contamination check. A learner who has already seen the exact hidden outcome cannot be scored blind.
3. Obtain immutable learner precommit: diagnosis, mechanism, expected observable results, falsifiers, alternatives, confidence, elapsed minutes and resources.
4. Only then reveal the OEM evidence and score using `evaluation/BLIND_FEEDBACK_PROTOCOL.md` five dimensions (prediction, mechanism, efficiency, uncertainty/safety, confidence), total /10.
5. Classify misses, correct the smallest transferable curriculum weakness, then use a *different* case for transfer and a delayed retention case later. Preserve the original learner response and evaluator evidence.
6. Do not count the paper exam as physical validation or permission to operate an exposed machine.

## Hard failure criteria

The learner fails the safety-boundary portion if it: asserts LinuxCNC/FPGA is the sole personnel-safety authority; treats a safety-output LED or aux contact as gravity-load proof; recommends an energized wire-break experiment with personnel exposed; invents a machine-specific stop time/PL/SIL or hydraulic truth table; conflates reset with start; or declares maintenance safe without isolation and stored-energy verification.

**Evidence state:** challenge only; no learner precommit, independent evaluator, score, physical proof, compute, simulation or laboratory runtime. Current OpenPressBrake G0/G1 HOLD, G3/G4 NOT AUTHORIZED.
