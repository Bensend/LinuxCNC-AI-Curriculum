# 4400-TK-01 source-delta cross-check — Fortress key sequence and 2021 OSHA group LOTO adjudication
**2026-10-30 | ORIGINAL MANUFACTURER / REGULATOR SOURCE AUDIT | NON-GRADUATED | NO MACHINE TEST**

## Predecessor reconciliation — important correction
**SOURCE-CONFIRMED:** An initial exact-string search for `trapped key` missed the hyphenated **4400-TK-01/02/03** predecessors already indexed on 2026-10-25. Read [original Castell X/DOLD/OSHA TK-01 audit](4400_CASTELL_X_DOLD_STS_TRAPPED_KEY_EXCHANGE_PERSONNEL_KEY_AND_LOTO_SOURCE_AUDIT_2026-10-25.md), [Castell BEMF TK-02](4400_CASTELL_BEMF_MOTOR_STANDSTILL_AUTO_RESET_VS_HYDRAULIC_LOAD_SOURCE_AUDIT_2026-10-25.md), [Fortress LOK TK-03](4400_FORTRESS_LOK_LOCK_MONITOR_VS_PROCESS_ONLY_AND_ESCAPE_CONTACT_VARIANTS_AUDIT_2026-10-25.md), existing [TK-01 module](../safety-course/4400_TK_01_TRAPPED_KEY_EXCHANGE_PERSONNEL_KEYS_MOTOR_SENSING_AND_LOTO_MODULE_2026-10-25.md) and 22-case technician card. **This document is NOT a novel competency or new trapped-key mechanism.** Its incremental value is an independently sourced Fortress 2024/2020 comparison and the **specific May 21, 2021 OSHA interpretation** rejecting supervisor-only group lockout while accepting individual satellite lockbox control. General key sequence, personnel-key/LOTO separation, BEMF and gravity boundaries were already taught.

## Question
Does the 2021 OSHA interpretation provide a concrete discriminating example for the already taught difference between an operational trapped-key access key and each covered servicing worker's personal lock?

## Primary evidence inspected
1. **Fortress Safety, "Understanding Trapped Key Systems", 18 March 2024**, manufacturer original: https://fortress-safety.com/news/understanding-trapped-key-systems/ . The manufacturer describes isolation-key release, exchange requiring **all** source keys, access key trapped at the open guard, and optional **personnel key** removed and carried inside; all keys must be returned before the reverse sequence can complete.
2. **Fortress, "Mechanical Trapped Key Interlocks", mGard Overview Brochure, June 2020 v1.5**, original OEM PDF, printed pp.3–7: https://fortress-safety.com/wp-content/uploads/2022/06/mGard-Overview-Brochure-June-2020-v1.5-EN-QR-Download-Digital-Version.pdf . Robot-cell and double-backer examples distinguish run-down delay, voltage sensing, key exchange, access and carried personnel keys. These are illustrative **product applications**, not proof of an installed machine.
3. **ANSI official publisher scope for ISO 14119:2024**: https://webstore.ansi.org/standards/iso/ISO141192024 . The 2024 edition explicitly covers trapped-key interlocking devices/systems and foreseeable defeat; safety-control processing is separately covered by ISO 14118/13849-1/IEC 62061. **Full normative standard not acquired**; no invented clause, PL or dimensional acceptance.
4. **OSHA 29 CFR 1910.147(d)(3)–(6), (e), (f)(3)**: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 . Authorized workers must isolate *all* applicable energy sources, control stored energy, verify isolation and maintain personal control for servicing within scope.
5. **OSHA May 21, 2021 group-LOTO interpretation**: https://www.osha.gov/laws-regs/standardinterpretations/2021-05-21 . A supervisor's lone lock plus crew log did **not** satisfy the cited group-lockout requirement; a nested lockbox arrangement with each worker's own lock did.

## Causal sequence (design example only; NOT a selected machine truth table)
| Step | Mechanical key proposition | What it does **not** prove |
|---|---|---|
| 0 — normal operation | Isolation key is trapped; guard-access key unavailable. | Selected contactors, valves, brake or ram hold meet a performance target. |
| 1 — isolate | Each *identified* source is switched to its designated isolation position, releasing its coded key. | A control-circuit switch is a true energy isolator; all sources are included; residual hydraulic pressure, gravity, capacitors or flywheel energy is gone. |
| 2 — exchange | Correct exchange block requires every required source key before releasing access key(s). | Keys are unique, never duplicated, unmodified, correctly mapped to as-built isolators or physically impossible to bypass. |
| 3 — enter | Guard access key is trapped at open gate; whole-body personnel key(s) can be removed and carried, preventing key-chain restoration. | Every entrant carries a key, all personnel have exited, escape routes work, or servicing LOTO obligations are fulfilled. |
| 4 — return | Personnel keys returned, gate shut, access keys exchanged, isolation keys restored. | The hazard is automatically safe to restart; deliberate reset and separate start, occupancy clearance, and machine-specific validation remain necessary. |

**DOC-CONFIRMED**: OEM key sequence and examples; OSHA personal-lock/group-lockout duties; official ISO edition/scope. **INFERENCE**: the table's failure paths and cross-machine application. **UNKNOWN**: selected components, coded key register, number of entrants, actual isolators, residual energy, release timing, machine performance, wiring, and physical validation. **TEST-CONFIRMED none.**

## Adversarial failure-path review
- **Unisolated second source**: pump motor electrically isolated, hydraulic accumulator still pressurized or gravity-loaded ram unsupported. The correct electrical key can still be released; a **separate qualified energy/positive-support witness** is required. Never invent valve truth tables.
- **Two people, one personnel key**: one returns the key while the other remains inside. Whole-body access needs enough individually controlled personnel protection and/or an independently validated occupancy/escape strategy. A single shared key is not an OSHA personal lock by declaration.
- **Duplicate/master key**: unauthorized duplicate or wrong-code lock defeats the logical sequence. Maintain a controlled site key-code/issue register, restricted spare storage, independent audit and post-maintenance requalification.
- **Run-down timer**: fixed delay may be shorter than changed spindle inertia, gravity motion or failed braking; an OEM example showing a timer or voltage sensing is not measured standstill/zero pressure.
- **Maintenance shortcut**: one key ring hung on the machine, long walks to the exchange block, no convenient service lock point and frequent jam clearing predictably invite defeat. Place accessible, captive, labeled devices at actual task locations, provide a practical protected service path, and treat bypass frequency as a design defect.
- **Power restoration**: key return must not by itself command motion. Keep personnel-clear, independent rearm and fresh deliberate start separate from ordinary LinuxCNC/HAL/FPGA run permission.

## Practical application boundary
For a press brake, the actual ram stop, independent gravity holding, stored hydraulic energy and tooling/guard access are separate safety propositions. For a mill or robot cell, spindle/coast, pneumatic tool release and retained loads may dominate. For a plasma cell, electrical isolation does not automatically prove fumes, heat or pressure safe. **No selected OpenPressBrake trapped-key system is asserted.**

## Qualification packet and next evidence
Require exact OEM device/option/revision, site key-transfer diagram and key-code registry, energy-isolator classification and inventory, stored-energy dissipation/restraint, multi-person access/escape and personal-LOTO procedure, qualified stop/hold witness, override/spare-key control, change management and fresh restart test plan. The qualified reviewer must own actual machine validation; do not ask the owner to energize or expose personnel for photos. Public Stage A A–G receipt remains UNKNOWN, G0/G1 HOLD.

**No simulation justified:** manufacturer sequence and OSHA group-LOTO question are answerable from primary documentation. Actual machine safe-state claims require as-built physical evidence, not synthetic software tests. No workflow dispatched; hosted/self-hosted compute 0/0 minutes.
