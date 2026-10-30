# 4400-AMR-MODE-01 — Manual scanner bypass, payload stopping envelope and fresh restart
**2026-10-30 | Original Omron safety + integration manuals | NON-GRADUATED**

## Question and predecessor boundary
Does a safety laser scanner, a low speed, a fleet route, or an E-stop reset prove a mobile manipulator/cell is safe to approach? **No.** Unlike 4400-SCANNER-CASE-01 (static scanner field change) and 4400-PFL-01 (robot-arm contact), this audit traces the **mobile platform's exact operating-mode safety bypass and combined payload/braking geometry**. Original 2019 safety guide and 2023 integration guide were directly read, with key original printed pages visually inspected. No AMR or LinuxCNC mobile application is asserted installed.

## Confirmed manufacturer mechanisms
- **DOC-CONFIRMED, I616-E-06, 18393-000 Rev H (2019), printed p.27 (PDF p.26), SF4**: manual joystick's dual-channel trigger **bypasses LIDAR safety-zone detection** under operator control. This is a specific mode/safety-function description, not proof all scanners are disabled or all brands bypass identically. The same table describes SF0/SF2 as controlled deceleration, delayed removal of motor power and engagement of holding brakes. These are product claims, not machine-level stop-time measurements.
- **DOC-CONFIRMED, same printed p.27, SF1**: text states velocity-based field-zone behavior when moving **faster than 300 mm/s**. **VERSION/SCOPE CAUTION:** the later I680-E-02 integration guide's printed p.2-34 lists first activation speed 300 mm/s for LD-60 and **225 mm/s for LD-90 and LD-250**. These two documents must not be collapsed into a universal 300-mm/s activation rule; the actual model/config/firmware and field map must be identified. The 2023 table includes speeds some LD-250 versions cannot attain. No claim of an actual firmware defect or current-model unsafe gap.
- **DOC-CONFIRMED, I616 Rev H printed p.11**: after a manually released E-stop, motor enable is a separate step, followed by a documented two-second wait and possible **resumption of commanded motion** if there is space. Thus 'E-stop button released' is not 'no retained job' and even motor enable is not a machine-wide safe rearm witness. Exact current model/firmware behavior remains UNKNOWN; deliberate reset and fresh start must be designed and witnessed at the system boundary.
- **DOC-CONFIRMED, I616 Rev H printed pp.20–21**: narrow-side trapping and in-place rotation hazards exist; its text says a turning-in-place obstacle may not trigger E-stop. A scanner's forward obstacle field is not automatically a payload-swept-volume or side-clearance safeguard.
- **DOC-CONFIRMED, Omron LD-Series Integration Guide I680-E-02 (2023), printed pp.2-26–2-27 (PDF pp.59–60)**: higher payload inertia/center of gravity and maximum deceleration change stopping and stability. Overhanging payloads require increased safety zones; manufacturer advises contacting Omron for safety-zone modifications. A changed footprint, floor friction, payload/CoG or deceleration requires re-verification that the robot stops before collision at relevant speeds. A footprint drawing is not a safety-zone validation.
- **DOC-CONFIRMED, I680 printed pp.2-30–2-33**: integration checklist requires E-stop/bumper/safety-zone verification, safety-zone report if overhang, floor/dropoff inspection, loaded/unloaded and moving CoG evidence, and checks for sensor occlusion by payload. These are requirements to verify, **not completed evidence**.

Original sources: https://files.omron.eu/downloads/latest/manual/en/i616_mobile_robot_ld_safety_guide_system_manual_en.pdf?v=1 and https://www.omron.com.vn/data_pdf/mnu/i680-e-02_ld.pdf . ISO 3691-4:2023 scope https://www.iso.org/standard/83545.html (abstract only).

## Adversarial state/geometry matrix (paper-only)
| Condition | Ordinary status temptation | Missing physical witness | Required design action |
|---|---|---|---|
| Joystick/manual service mode | 'Scanner healthy' | Is SF4 bypass active? Can a person be pinned? | Mode-specific SRS, operator control and independent emergency stop, prevent unqualified access |
| Low speed near worker | 'Under 300 mm/s' | Correct edition/field set, side/rotation/swept load protection | Selected version/config trace; no generic speed-as-safe assumption |
| E-stop release and motor enable | 'E-stop cleared' | Retained mission/start request, occupancy and external machine state | Explicit system-level fresh start and zone-clear validation |
| Heavy high/offset load, slippery floor | 'Path is valid' | Measured worst-case stopping and stability | Qualified selected-load deceleration and field sizing, independent proof |
| Docking/transfer at fixed machine | 'Robot arrived' | Part securely transferred; fixture/ram/tool safe | Safety-rated selected transfer interlock and final-element witness; no automatic cycle start from arrival |
| Rotation near guard | 'Forward scanner clear' | Side payload and human crush envelope | Geometry redesign, fixed guard or independently justified sensing/clearance |

## Architecture allocation
**Normal control:** fleet route, map/localization, LinuxCNC part program and ordinary dock/handshake commands. **Diagnostics:** scanner display, pose, mode and load monitoring (no inherited safety rating). **Safety-related control:** qualified scanner/joystick/safety core and independently selected gate/transfer functions, with exact mode, fault, reset and communications contract. **Physical safe state:** stopped wheels, validated braking and load retention, no dangerous fixed-machine movement, safe egress and isolated maintenance energy. A green dashboard cannot replace any physical witness.

## Evidence classification and stop
**DOC-CONFIRMED** only within named Omron editions; **INFERENCE** proposed cross-machine SRS and bypass-resistant layout; **SOURCE-CONFIRMED** canonical predecessor comparison; **TEST-CONFIRMED none**; **UNKNOWN** selected model/firmware, actual field sets, safety PL/SIL for integrated system, stopping distances, load and friction, local/remote rearm behavior, personnel clearance, safety-rated transfer interface. No machine operation, lab or independent evaluator. **G0/G1 HOLD** for OpenPressBrake; this mobile-system study does not change those gates. Physical operation with people exposed remains unauthorized where minimum protective functions are unproven.

## Reopening condition
Only if an actual mobile machine/cell is selected: obtain exact manuals/revisions, scanner configuration export, safety circuit and interface diagram, mission/traffic version, load/CoG, site geometry and qualified stop/restart validation plan. Do not invent a stopping distance or use an unqualified person as a test obstacle.
