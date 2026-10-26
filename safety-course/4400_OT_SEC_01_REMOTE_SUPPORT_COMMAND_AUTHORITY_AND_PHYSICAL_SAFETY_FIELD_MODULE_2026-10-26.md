# 4400 OT-SEC-01 — Remote support is not a safety authorization

**Prerequisites:** 2520 safety-function derivation; 2530 E-stop/rearm; 2540 independent final elements; 25F0 cross-machine capstone; existing 4400 E-stop first-scan and stale-diagnostic modules. **Status:** learner-facing DOCUMENTARY module, not graduation or machine release. [Primary-source audit](../research/4400_OT_SEC_01_NIST_800_82R3_IEC_TS_63074_REMOTE_HMI_SAFETY_AUTHORITY_AUDIT_2026-10-26.md).

## Learning objective

Given a network-connected machine, distinguish (A) who is allowed to log in, (B) who may request ordinary motion, (C) who may modify safety configuration, (D) what independent physical safety system actually prevents hazardous motion, and (E) who is permitted to verify and deliberately rearm after intervention. Explain how a cyber event can become a physical hazard **without claiming ordinary LinuxCNC/FPGA is safety-rated**.

## Five-layer practical pattern

1. **Remote access:** default OFF; only needed access for approved purpose, with identity, time limit, visible status, audit and local rapid disconnect. Remote session ≠ local machine-clear authorization.
2. **Ordinary control:** LinuxCNC, HAL, web HMI and FPGA may request, coordinate and diagnose. They must not be the sole personnel-safety barrier.
3. **Safety-related control:** selected independent safety inputs, logic, output monitoring and reset/rearm behavior; changes require controlled, authenticated engineering process and qualified revalidation.
4. **Physical safe state:** stop Y1/Y2 and retain gravity load using the selected physical mechanisms; identify residual hydraulic/electrical energy, guards and escape. Loss of network or display is not evidence of these physical propositions.
5. **Maintenance:** isolate, restrain, verify zero hazardous energy where applicable, then restore deliberately. Network disconnection is **not** LOTO.

A cheap implementation can start with **no remote command path at all**, local access only and a documented service procedure. Remote telemetry can be added as a separately assessed read-only path; do not silently turn it into remote actuation.

## Eight public PAPER scenarios — all UNSCORED

| ID | Scenario | What a learner must discriminate |
|---|---|---|
| OTSEC-P1 | Vendor authenticated via VPN requests ram jog while a person changes tooling | VPN identity vs local clearance vs independent physical safeguard |
| OTSEC-P2 | Web UI displays `E-stop clear` after losing its diagnostic connection | Freshness/validity of display vs physical safe-state proof |
| OTSEC-P3 | Service laptop connected to ordinary CNC Ethernet and safety controller engineering port | Cross-zone compromise/change authority vs separate safety logic |
| OTSEC-P4 | Security patch reboots panel mid-cycle while hydraulic load remains suspended | Computer state vs physical stop/hold/energy retention |
| OTSEC-P5 | Remote session expires while CNC has queued a motion request | Session expiry vs cancellation of outstanding commands and deliberate rearm |
| OTSEC-P6 | Remote-support feature defaults to always-on after service | Usability-driven unsafe persistence; simple local OFF and time limit |
| OTSEC-P7 | Technician copies a previous safety-controller project file after changing a valve | Configuration provenance, change impact, revalidation and rollback |
| OTSEC-P8 | Network cable is unplugged and operator interprets screen blackout as safe maintenance | Independent isolation/verification and mechanical restraint, not HMI darkness |

For each scenario require **hazard/exposure**, **ordinary command path**, **safety-related authority**, **physical final element**, **fault detection**, **reset/restart**, **foreseeable bypass**, **UNKNOWN**, and **what evidence would falsify the proposed protection**. No answer key or score is embedded here.

## Ten documentary qualification gates — all NOT RUN

| Gate | Documentary evidence requested | State |
|---|---|---|
| OTSEC-G1 | As-built ingress inventory: panel Ethernet, USB, wireless, remote desktop, update path | UNKNOWN / NOT RUN |
| OTSEC-G2 | Roles and explicit authorization for read, jog, reset, program edit, safety-logic edit | UNKNOWN / NOT RUN |
| OTSEC-G3 | Network trust boundaries and physically separate safety paths, or justified equivalent | UNKNOWN / NOT RUN |
| OTSEC-G4 | Local operator awareness and quick disable of remote access | UNKNOWN / NOT RUN |
| OTSEC-G5 | Time-limited remote session, logging, approved access and revoke path | UNKNOWN / NOT RUN |
| OTSEC-G6 | Loss-of-network and loss-of-panel behavior, with separate physical safe-state witnesses | UNKNOWN / NOT RUN |
| OTSEC-G7 | Safety-controller project identity, change approval, backup and qualified revalidation | UNKNOWN / NOT RUN |
| OTSEC-G8 | Reset/restart/rearm not accepted solely from remote UI or restored connection | UNKNOWN / NOT RUN |
| OTSEC-G9 | Maintenance isolation/lockout and gravity restraint independent of network | UNKNOWN / NOT RUN |
| OTSEC-G10 | Security/availability controls do not degrade safety response; responsible reviewer sign-off | UNKNOWN / NOT RUN |

These are **paper evidence requests**, not energized test instructions. A missing item is not a fail verdict for a hypothetical machine; it is a HOLD for a selected machine until qualified evidence exists.

## Cross-machine transfer

- **Press brake:** independent Y1/Y2 stop/hold and hydraulic pressure zones, tooling change and guard rearm.
- **Mill/lathe:** spindle energy, chuck/workholding and door locking; STO alone may leave kinetic motion.
- **Plasma/laser:** torch/beam/process energy and fume/ventilation interlocks; no inference from CNC stop bit.
- **Robot/cell:** local teach enabling, access/occupancy and restart control; remote engineer login cannot attest the cell is empty.

## Human-factors acceptance

If a technician must leave a permanent remote connection enabled to obtain support, the support architecture should be redesigned. Prefer simple locally controlled, clearly indicated service access that **expires automatically**. Treat repeated unsafe workarounds as design feedback; do not merely tell workers to be more careful.

## Source and scope

NIST SP 800-82r3 (September 2023) §§4.2.2, 5.3.1, 6.2.10, original PDF https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-82r3.pdf ; IEC TS 63074:2023 official **abstract only** https://webstore.iec.ch/en/publication/69228 ; LinuxCNC io/halui official docs as cited in [audit](../research/4400_OT_SEC_01_NIST_800_82R3_IEC_TS_63074_REMOTE_HMI_SAFETY_AUTHORITY_AUDIT_2026-10-26.md). **DOC-CONFIRMED** guidance; **INFERENCE** proposed design patterns; **UNKNOWN** selected OpenPressBrake machine. **No SOURCE-CONFIRMED machine security architecture, TEST-CONFIRMED physical proof or independent evaluator score.** G0/G1 HOLD; no personnel-exposed operation.
