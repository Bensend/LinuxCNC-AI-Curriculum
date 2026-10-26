# 4400-FDI-01 — A fault lamp is not a physical stop

**Status:** learner-facing 4400 safety module, PAPER ONLY / NON-GRADUATED. Prerequisites: 2530 E-stop, 2540 final elements, 2570 drive safe-motion, 2580 hydraulic energy, 2520 hazard-to-SRS. [Original S210 manufacturer audit](../research/4400_SIEMENS_S210_FDI_ASYMMETRIC_DISCREPANCY_FAULT_TO_STO_SOURCE_AUDIT_2026-10-26.md).

## What the learner must be able to explain

A two-channel safety input has **polarity, filtering, discrepancy detection, stop timing, diagnostic output and restart semantics**. A fault appearing in the drive is not equivalent to torque removal, motor standstill, gravity-load restraint, physical energy isolation, or a machine-wide safe state. An apparently symmetrical pair of contacts can produce *asymmetric* reactions depending on which state was active before the fault.

## Source-backed mechanism (Siemens S210 07/2021 only)

- **Both LOW → one HIGH:** STO starts active. Persistent mismatch can issue F01611/F30611 after p9651 debounce and p9650 discrepancy. The OEM explicitly describes a window in which the other input becoming HIGH **before p9658 expires** can deselect STO despite the internal event.
- **Both HIGH → one LOW:** the drive initiates SS1 or STO after debounce depending on p9652; a later discrepancy fault is **not** proof that STO is already active. The manual explicitly permits motor operation while the fault is present and STO is not yet active.
- **STO → SBC → SBT:** torque suppression, brake actuation, and diagnostic torque-testing are separate functions. SBC cannot detect mechanical wear; SBT **actively generates torque** and must never be used as a casual hands-on maintenance test.
- **Rearm:** S210's documented ON/OFF1 positive-edge restart is a drive-level behavior, not proof of whole-machine occupancy, guards, Y1/Y2 physical holding, pressure isolation or fresh cycle permission.

Reference: [Siemens original manual A5E47011139B AC, §§5.1.1–5.2.6 and 9.3.2](https://cache.industry.siemens.com/dl/files/295/109801295/att_1077953/v1/S210_MC_SI_commiss_man_0721_en-US.pdf). Exact firmware and parameter values remain UNKNOWN for the selected machine.

## Four distinct authorities and physical witnesses

| Layer | May know/do | Cannot prove |
| --- | --- | --- |
| Ordinary LinuxCNC / FPGA | Request motion, read drive fault/status, clear its own queued cycle | Personnel exclusion, qualified stop, physical ram hold |
| Independent safety-related control | Interpret protective inputs and drive/final-element safety responses, enforce fresh safety rearm | That a mechanically disconnected load stopped solely from a motor bit |
| Physical stop/hold elements | Remove hazardous drive energy, restrain load when qualified and independently witnessed | That trapped hydraulic energy is safe for service |
| Personal maintenance energy control | Lock isolators and verify each relevant electrical, hydraulic, gas, gravity energy zone | A substitute for production safeguarding or emergency rescue |

**The safety state must be a proposition about the hazard, not an HMI bit.** If no independent physical witness exists, keep the machine out of personnel-exposed service.

## Minimal practical design pattern

1. Define hazardous element and who can reach it; draw the input-to-final-element path and any gravity/pressure backfeed.
2. Use a qualified independent safety function for the actual hazardous motion, with explicit state/timeout/fault responses. Do not rely on LinuxCNC HAL fault handling as the personnel-safety channel.
3. Treat **fault detected**, **STO requested**, **STO active**, **load stopped/held**, **isolation verified**, **rearm allowed**, and **fresh motion commanded** as separate recorded states.
4. Put visible, reachable reset and diagnostics where they can be used correctly; prevent stale start commands from becoming new motion. If the workflow tempts workers to bridge a switch, redesign the inconvenience.
5. Record physical witnesses and change triggers for exact drive replacement, parameter edits, input polarity, debounce/discrepancy time, stop delays, brakes, guards and hydraulic load path.

## Machine transfer

A mill Z axis may need independent fall protection despite drive STO; a lathe spindle can coast; a robot can move under gravity even with motor torque off; a press brake needs separate Y1/Y2 and hydraulic holding proof; a plasma table's power and extraction hazards are not resolved by drive STO. The Siemens timing specifics are **not** generic rules for those machines.

## Training / release

Complete [12 paper scenarios](4400_FDI_01_TWELVE_ASYMMETRIC_INPUT_AND_STOP_PAPER_CASES_2026-10-26.md) and use [12-gate documentary worksheet](4400_FDI_01_TWELVE_GATE_INPUT_TO_PHYSICAL_STOP_DOCUMENTARY_REVIEW_2026-10-26.md). These are **not** blind external evaluation, physical tests, acceptance, or a machine release. No numerical p965x values or stop distances are provided. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.**
