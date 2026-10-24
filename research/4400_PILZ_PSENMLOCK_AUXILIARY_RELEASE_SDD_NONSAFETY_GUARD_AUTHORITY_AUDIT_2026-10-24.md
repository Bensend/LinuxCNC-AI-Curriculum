# 4400 — Guard locking, non-safety diagnostics and auxiliary release are different authorities
**2026-10-24 | Original manufacturer-source audit | Source reading, NOT selected-machine validation**

## Question
When a CNC retrofit adds a guarded access door, can a standard fieldbus command unlock it, does an auxiliary release provide an emergency escape function, and can the door's green LED be used as permission to restart motion? The exact answers depend on the **selected device, its safety inputs and physical hazard**. The general safety principle is to separate access request, independently permitted release, guard-closed/locked monitoring, inside escape, and deliberate motion rearm.

## Directly inspected original Pilz manual
**Pilz PSENmlock mini, PSEN mlm 1 ba 1.1/2.1/2.2, Operating Manual 1005801-EN-05**, original 72-page manufacturer PDF, retrieved 2026-10-24, [PDF](https://www.pilz.com/download/open/PSEN_mlm_1_ba_1_12_12_2_1005801-EN-05.pdf). **DOC-CONFIRMED for exactly these variants:**
- Section 5.7, printed pp.18–21: without SDD, guard locking is controlled through safety inputs **S31/S41**. In *active* Safety Device Diagnostics (SDD) mode, an SDD command can request unlocking only in combination with appropriate S31/S41 state. The manual explicitly says the **SDD fieldbus is not safety-related**; safety requirements remain assigned to the safety inputs. Therefore a LinuxCNC/PLC Ethernet request may be an *access request*, not a personnel-safety authority.
- Section 5.7.1.2, p.20: a documented operating mode automatically **relocks** the guard when it closes; safety outputs then become high. This is not evidence that the entire hazard area is clear or that normal CNC motion should automatically resume.
- Sections 5.8 and 6, pp.22, 25: **12/22 are safety outputs**, while **Y32 is a signal/diagnostic output** and Y1 is diagnostic input. Do not treat a Y32 status bit or LED as a dual-channel safety permission.
- Section 5.9, pp.23–24: **auxiliary release** is for unlocking from the *access side* and may only be used when the machine is at standstill. Pilz explicitly states it **is not a safety function**. Operating it drives 12/22 low and produces a warning, not a device fault. It requires deliberate restoration and a qualified functional test on recommissioning. It must not be described as an emergency **inside escape** feature merely because it can unlock the gate.
- Section 7.1, p.27: the evaluation device must monitor dual-channel plausibility including transitions through the unlocked state; it must establish that the plant is in a safe condition before commanding solenoid operation. The product's OSSD outputs are not proof of physical stopping, which remains machine-specific.
- Section 7.2, pp.28–29: two different manufacturer connection patterns are illustrated for specific PL d category cases; the single-channel pattern relies on protected cable layout and short-circuit exclusions. **Do not assign a PL/category** to a custom installation by copying a diagram without the full system design and fault analysis.
- Section 8, p.31: actuator coding variants differ. The coded 1.1 accepts matching actuators; fully-coded 2.1 permits up to eight learn procedures; uniquely-coded 2.2 permits only one. Replacement procedure and resistance to substitution are product-specific, not merely “RFID means tamper-proof.”
- Section 10/11, pp.51–53: a green lock indicator can coexist with an inability to activate/deactivate locking in a warning condition; routine checks and post-fault inspection are required. An indicator color alone cannot close a hazard-release proof.

## Other manufacturer context
**Rockwell Guardmaster 442G Multifunctional Access Box**, [official product page](https://www.rockwellautomation.com/en-us/products/hardware/safety-products/442g-multifunctional-access-box.html) and [original manufacturer product profile](https://literature.rockwellautomation.com/idc/groups/literature/documents/pp/442g-pp001_-en-p.pdf): manufacturer distinguishes **power-to-release and power-to-lock** variants, offers an **optional escape release**, and markets the device for full-body access. Product page/profile are **DOC-CONFIRMED product descriptions**, not physical validation or an installation-specific selection. The large 442G-UM001 user-manual PDF could not be opened in full due reader size limit; no unseen internal wiring or timing claims are made.

**Pilz PSENmlock mini manufacturer product page** [official product page](https://www.pilz.com/en-NZ/products/sensor-technology/safety-switches-with-guard-locking/psenmlock-mini-safety-locking-devices): describes **bistable guard locking that retains its prior locked/unlocked state on power loss**. This is an OEM product-family claim, not proof that a selected installed device behaves that way. Never assume loss of power always unlocks, or always locks, a guarded access.

## Failure paths and human factors
| Condition | Misleading assumption | Real engineering requirement |
|---|---|---|
| SDD unlock request accepted | Standard network command is safety-rated | Verify independent S31/S41 safety input gate and physical safe state |
| Guard closes and lock LED becomes green | Nobody remains inside | Occupancy/inside-escape assessment, deliberate restart and no automatic queued motion |
| Auxiliary release used to open access | This is emergency escape or safety-rated stop | Stop/standstill before use; distinct inside escape and recommissioning |
| Power removed to guard lock | Door must unlock for escape | Determine exact power-to-lock, power-to-release or bistable mechanism and power-failure egress |
| Actuator replaced | Any RFID tag is equivalent | Verify coding/teach-in variant, authorized replacement and post-replacement function test |
| Y32 reports gate closed | Dual-channel guard safety function proven | Qualified safety output 12/22 and independent final-element stop/hold proof |
| Mechanical guard is difficult to reinstall | Technician bridges switch | Redesign with captive fasteners, visible alignment, accessible maintenance and monitored safe recovery |

**INFERENCE:** A practical guarded press-brake rear-access design should make the protected gate easy to open under qualified stopped/isolated conditions, easy to relatch, and impossible to confuse with an HMI software stop. If whole-body entry is possible, evaluate escape release, trapped-person and restart prevention. This is a design method, not a claim about the actual OpenPressBrake.

## Authority / release boundary
- **Normal control:** LinuxCNC/FPGA may request door unlock and show a warning, but cannot bypass safety controller S31/S41 or independent stop/hold.
- **Safety-related control:** selected validated dual-channel interlock/guard lock logic, safety inputs/outputs and fault monitoring.
- **Physical safety:** guard geometry, lock mechanics, access/escape route, final contactor/valve/load-holding and independent stop.
- **Maintenance:** electrical/hydraulic energy isolation, deliberate auxiliary release and qualified recommissioning. Do not confuse auxiliary release with LOTO or emergency escape.
- **UNKNOWN:** installed OpenPressBrake guard-lock brand, variant, rear gate, inside escape, lock power-loss behavior, physical Y1/Y2 stop/hold/rearm.
- **TEST-CONFIRMED:** none; no physical or simulated tests.
- **Personnel-exposed operation:** NOT AUTHORIZED while selected machine safe-state evidence is missing.

## Precise next evidence
For any installed rear/side gate: identify model/firmware, coding/actuator, safety-output versus diagnostic pin mapping, power-loss lock state, inside escape provision, guarded geometry, safe-unlock predicate, qualified stop/hold, auxiliary-release maintenance procedure and deliberate restart witness. If no guard lock exists, device-specific witness N/A after inventory; actual guarding/stop/hold still mandatory.
