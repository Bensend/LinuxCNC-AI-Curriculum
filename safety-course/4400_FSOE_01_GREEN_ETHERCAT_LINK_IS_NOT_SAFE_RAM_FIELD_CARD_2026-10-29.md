# 4400-FSOE-01 — A green EtherCAT link is not a safe ram
**Technician safety architecture card | 2026-10-29 | DOC-CONFIRMED, NOT TESTED, NON-GRADUATED**

**Question:** Can the ordinary LinuxCNC/FPGA/EtherCAT controller transport safety traffic? **Yes, potentially**, when qualified FSoE safety endpoints and a separately validated safety application own personnel-safety decisions. The normal controller must **not** become the safety authority simply because it can see the packets.

| Indication | What it means | What it does not prove |
|---|---|---|
| **NETWORK CONNECTED** | Ordinary EtherCAT link/process communication is present | FSoE connection valid or protective function safe |
| **SAFETY CONNECTION VALID** | Selected safety endpoints' FSoE protocol checks accept traffic | Safety logic permits motion or physical stop/hold |
| **SAFETY FUNCTION PERMITTED** | Independently validated safety application permits a defined function | No stored energy or gravity-loaded ram held during maintenance |
| **PHYSICAL STOP/HOLD VERIFIED** | Qualified, machine-specific physical evidence for the actual hazard and stop/hold mechanism | Permission to bypass isolation, guarding or deliberate restart |

**Original-source examples:** ETG explains that the standard EtherCAT transport is a *black channel*; Beckhoff's TwinCAT Safety PLC manual distinguishes **invalid connection ID**, **invalid CRC**, **watchdog expired**, and **failsafe value active**. Pilz sells a dedicated PNOZ m EF EtherCAT FSoE fieldbus module for use with its safety controller. These are **different layers**, not interchangeable proof of a complete machine's safety performance.

**Maintenance scenarios (paper-only):** If a network cable disconnects, the safety endpoint must perform its qualified fault response, not wait for LinuxCNC to notice. If a module is replaced, recheck the safety address/connection identity, application configuration and deliberate rearm. If a safety output drops but a valve sticks or a gravity load can move, the network diagnostics cannot substitute for physical stopping and load-holding proof. A restart after fault clearance must not initiate hazardous motion.

**Make the safe path the easy path:** use proven safety logic/I/O, documented change control, separate normal diagnostics, readable fault messages, accessible guards, and a deliberate fresh-start procedure. Do not solve repeated faults by bypassing a guard or jumpering a safe input. A simple hardwired safety chain may be more appropriate than networked safety for a small machine; choose by hazard and maintainability, not feature count.

**Sources:** [full ETG/Beckhoff/Pilz source audit](../research/4400_FSOE_01_ETG_BECKHOFF_PILZ_BLACK_CHANNEL_IS_NOT_SAFETY_CONTROLLER_SOURCE_AUDIT_2026-10-29.md), [ETG FSoE overview](https://www.ethercat.org/safety/), [Beckhoff original safety manual](https://download.beckhoff.com/download/document/automation/twinsafe/TcSafetyPLC_en.pdf), [Stage A evidence request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md).

**OpenPressBrake EtherCAT/FSoE installation UNKNOWN. No physical test, no certified machine safety function, no external evaluator. G0/G1 HOLD. No personnel-exposed hazardous operation.**
