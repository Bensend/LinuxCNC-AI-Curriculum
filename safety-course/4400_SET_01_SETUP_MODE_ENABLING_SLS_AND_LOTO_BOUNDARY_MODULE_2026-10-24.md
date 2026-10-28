# 4400-SET-01 — Guard-open setup, three-position enabling, SLS and maintenance isolation
**Level:** 4000 safety implementation | **Status:** SOURCE-READING / NOT GRADUATED | **2026-10-24**

## Prerequisites and goal
Use graduated LinuxCNC fundamentals plus the 2500 safety sequence (2520, 2530, 2570, 2580, 2590 and restart/change control). This is a **new product-specific transfer investigation**, not a replacement for 2570 or a reopening of closed 1000–3000 work.

After this module a fresh engineer must separate (1) ordinary CNC motion request; (2) safety-rated mode, guard, enabling and speed supervision; (3) independent stop and gravity holding; (4) maintenance energy isolation; (5) occupancy and reset/fresh start; and (6) eligibility for an OSHA minor-servicing exception. It must identify how a three-position switch can be working correctly while the **overall machine** remains unsafe.

## Reading order
1. [Original Rockwell/Pilz/Siemens enabling and SLS source audit](../research/4400_SETUP_ENABLING_SWITCH_SLS_MODE_TRANSITION_OEM_AUDIT_2026-10-24.md).
2. [OSHA setup/minor-servicing/LOTO applicability source audit](../research/4400_OSHA_SETUP_MINOR_SERVICING_LOTO_ALTERNATIVE_PROTECTION_SCOPE_2026-10-24.md).
3. [LinuxCNC 2.7 versus current motion.feed-inhibit/jog documentation conflict](../research/4400_LINUXCNC_FEED_INHIBIT_JOG_DOCUMENTATION_VERSION_DRIFT_2026-10-24.md).
4. Existing [2570 drives release gate](2570_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md), [2580 fluid power release gate](2580_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md), and cumulative [Safety Design Package](SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md).

## Functional chain: a reference pattern, NOT selected OpenPressBrake wiring
**Machine hazard/occupancy** -> **qualified safety mode selector** -> **verified safe-motion state and guarded access** -> **three-position enabling/hold-to-run when required** -> **independent overspeed/stop supervision and fault reaction** -> **verified physical final elements, gravity holding and access boundaries** -> **occupancy-cleared rearm** -> **fresh normal start**.

LinuxCNC/HAL/FPGA may request jog, display safety-state diagnostics, and cancel normal demand. It does not own the sole personnel-safety decision. A low commanded speed does not prove safe speed. SLS is not necessarily an independent motion source or safe stop; the actual OEM configuration and feedback path matter.

## Seven critical discriminators
1. **Switch position:** Released OFF, middle ON, panic squeeze OFF in the Pilz family. Do not conflate with a two-position pushbutton or E-stop.
2. **When monitored:** The historical Rockwell Kinetix example warns that enabling-switch monitoring is not active until the door monitor goes OFF. Identify the precise transition and do not infer universal behavior.
3. **What SLS monitors:** Safe-speed monitoring is product/feedback/configuration-specific; a Siemens 2021 encoderless example cannot directly monitor speed when its induction motor is unpowered.
4. **What happens on exceedance:** Configured coast or braking reaction is not an invented physical stopping distance or load-holding guarantee.
5. **Who may change mode:** A second operator must not restore normal mode while anyone is inside; door-closed alone is not vacancy evidence.
6. **Who restarts:** Safety reset, door reclosure, enabling release and normal CNC start are separate. A retained LinuxCNC demand must not restart motion.
7. **Which tasks require LOTO:** A mode selector or safety PLC does not create a minor-servicing exemption. Apply OSHA 1910.147 task-by-task; maintenance and gravity-loaded tooling demand physical isolation/restraint where applicable.

## Worked cross-machine decisions
| Machine | Setup exposure | Critical difference |
|---|---|---|
| Mill/VMC | Guard-open tool touch-off/jog | Spindle coast and tool ejection; enabling and SLS do not guarantee shaft stopped. |
| Lathe | Chuck access at low spindle speed | Centrifugal workholding risk; slow speed may still be hazardous and requires independent qualified protection. |
| Robot/cell | Teach pendant and multiple entrants | Three-position enabling may not protect a second entrant; mode selection and occupancy must be controlled. |
| Plasma table | Setup near moving gantry and cutting energy | Safe travel speed does not make arc, fumes or stored energy safe. |
| Press brake | Die setup near gravity-loaded Y1/Y2 | Independent ram support, hydraulic isolation and point-of-operation protection remain essential; electric-drive SLS examples do not establish hydraulic behavior. |

## Practice and validation
Complete [18 paper technician cases](4400_SETUP_MODE_SLS_ENABLE_AND_RESTART_TECHNICIAN_CARD_2026-10-24.md). Use [blank selected-machine witness](4400_SETUP_MODE_AS_BUILT_WITNESS_BLANK_2026-10-24.md) **only** with real qualified as-built/physical evidence. No person-in-zone tests, invented safe speed, stop time or PL/SIL. A fresh independent evaluation handoff is [prepared](../evaluation/4400_SET_01_FRESH_MODE_TRANSFER_HANDOFF_2026-10-24.md) but **NOT RUN/NOT SCORED**.

## Evidence ledger and graduation
**DOC-CONFIRMED:** exact original Rockwell 2013, Siemens 2021 manuals; Pilz product page; official LinuxCNC docs; OSHA indexed official text (direct OSHA pages 403). **SOURCE-CONFIRMED:** LinuxCNC v2.7.15 control.c net_feed_scale -> command.c JOG_CONT/JOG_INCR acceptance differs from master commit 062dc7c097693bb68e76192516cd92878dd5ecdf, which gates these jogs on separate jog_inhibit. See source appendix in drift audit; no runtime or physical stop proof. **TEST-CONFIRMED:** none. **INFERENCE:** machine-neutral human-factors and failure paths. **UNKNOWN:** actual OpenPressBrake mode circuit, installed safety devices, Y1/Y2 physical stop/hold, occupancy, machine standard, external evaluator and performance levels. **NOT GRADUATED**. Selected IN-04v UNKNOWN, physical VAL/PT NOT RUN, G0/G1 HOLD, G3/G4 NOT AUTHORIZED; no personnel-exposed operation.

## Higher-level queue
Trace LinuxCNC versioned jog/feed-inhibit behavior at exact commits only if selected software revision and question justify it. Obtain exact OEM current manuals/configuration if a real SLS device is selected. Neither uncertainty may be silently promoted to a claim that the selected machine is safe.


**Source-depth caution:** Pinned master joint wheel-jog code in control.c lines 1125–1185 checks net_feed_scale, unlike keyboard/halui EMCMOT_JOG_CONT/INCR command.c checks of jog_inhibit. A universal "feed-inhibit never affects jogs" claim would overread the current manual. Which wheel state yields net_feed_scale zero requires further enables-mask tracing; no runtime evidence. See linked source audit.


## 2026-10-28 SET-FLUID-01 original DGUV/IFA hydraulic implementation source-depth
[Original DGUV/IFA FBHM-058 2019 reduced-speed audit](../research/4400_SET_FLUID_01_DGUV_FBH058_FIXED_ORIFICE_MONITORED_HYDRAULIC_REDUCED_SPEED_SOURCE_ADDENDUM_2026-10-28.md) and [one-page technician review](4400_SET_FLUID_01_HYDRAULIC_SLOW_JOG_IS_NOT_SAFETY_LIMITED_SPEED_TECHNICIAN_CARD_2026-10-28.md) add **fixed physical restriction, monitored high-speed bypass and higher-level stop** to this existing SET-01 mode/enabling/LOTO framework. The DGUV source warns that ordinary flow-control valves/controllable pumps normally do not meet the safety-reduced-speed function; vertical load and cylinder size affect physical speed, prolonged throttling can heat fluid. Its historical example PL/speed values are **not** machine-specific criteria or mandatory circuits. No OpenPressBrake as-built or physical test, G0/G1 HOLD; no new examination bank.
