# 4400-CELL-01 source audit — Universal Robots safety I/O, occupancy and cross-machine reset
**2026-10-25 | direct official OEM HTML inspection | DOC-CONFIRMED only for cited models/software | TEST NOT RUN**

## Falsifiable question
Can a safety-rated robot safeguard input, apparently healthy output and closed perimeter be treated as proof that a person cannot remain inside a cell or that a connected machine cannot restart? **No.** The exact interface/mode and occupancy/restart architecture determine the result; a PL claim for one subsystem does not validate the integrated cell.

## Original manufacturer documents directly inspected
1. Universal Robots, **UR10e / PolyScope X SW10_15**, "Safety I/O": https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/complianceUR10e/PolyX_SW/polyX-SafetyIO.htm (sections "Control Box Inputs", "Control Box Outputs", accessed 2026-10-25).
2. Universal Robots, **g-Series SW10_15**, "Safety I/O": https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/complianceG7/H_g5_sections/SafetyIO_v2/psx_safetyIO_v2.htm (same named sections, accessed 2026-10-25).
3. Universal Robots, **g-Series SW10_15**, "Safeguard Stop": https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/complianceG7/H_g5_sections/SafetyIO_v2/Safeguards_stop.htm (automatic resume vs external reset).
4. Universal Robots application article, **2020-04-04**, "Connecting an Emergency Stop Device vs. a Safeguard Protective Device": https://www.universal-robots.com/articles/ur/application-installation/connecting-an-emergency-stop-device-vs-a-safeguard-protective-device/ (scope **CB/e-Series at 2020 edition**, not a substitute for current exact-model manual).

## OEM-supported causal findings
| ID | DOC-CONFIRMED exact-source statement | What it does **not** prove |
|---|---|---|
| UR-01 | UR10e SW10_15 distinguishes ordinary **Safeguard** (stop category 2 in all modes) from **Automatic Mode Safeguard Stop** (category 2 in **Automatic only**, configured with three-position enabling device). Manual mode uses its own enabling and risk controls. | A generic label "safeguard" guarantees stop in every mode. |
| UR-02 | When default **Safeguard Reset is disabled**, clearing the protective input can automatically reset; OEM warns against this if a person may pass the field and remain undetected. | A light curtain clear proves cell empty. |
| UR-03 | SW10_15 safeguard reset input uses a **rising edge**. g-Series installation "Safeguard Stop" describes two-channel external reset and warns that auto resume is inappropriate where a person can remain inside. | An HMI software acknowledgment is a verified personnel-clear reset. |
| UR-04 | UR10e SW10_15 explicitly warns that an **I/O/fieldbus program start can move from the current robot position** without a manual first-waypoint move. | A resumed queued program must return to a known home before motion. |
| UR-05 | UR10e SW10_15 **System Stop** goes LOW on relevant stop/fault conditions and can return HIGH on release of an upstream external E-stop; the OEM warns a downstream machine may therefore clear its E-stop state **without a new robot-operator action** and must require its own manual action to resume. | Release of upstream E-stop is deliberate restart authorization for a press brake, feeder or conveyor. |
| UR-06 | UR10e SW10_15 describes System Stop anti-deadlock behavior: if stopped by System Stop input, corresponding LOW output is withheld. | Simply cross-wiring two robot/machine stop outputs creates a correct shared safety function. |
| UR-07 | UR 2020 application note distinguishes E-stop category 1 (joint power removed after controlled stop; brake engages) and safeguard category 2 (powered monitored standstill); e-Series vs CB-series safeguard category also differs. | Stop category 2 is energy isolation, mechanical load restraint or universal current model behavior. |
| UR-08 | UR SW10_15 safety I/O capability is described as paired Category 3 PLd per function. | Whole robot-cell risk reduction, external valve/press brake PL, human detection, physical stopping time, or machine safety certification. |

**Edition caution:** The 2020 application article is historical, while SW10_15 online manual is an identified software-family page. Do not splice CB3 Category 2, e-Series Category 3 and g-Series characteristics into a single hypothetical installed robot. Exact selected firmware, wired function, device variant and validated integration must be recorded.

## Failure-path analysis (INFERENCE, conditional on wiring)
**F1 — walk-through:** operator breaks light curtain -> robot stops -> operator stands beyond curtain -> beam clears -> automatic reset restores safety permission; if queued program auto-resumes, person is exposed. A reset pushbutton outside the cell and verified absence/occupancy design are distinct defenses; button alone cannot see hidden alcoves.

**F2 — mode bypass:** installer connects a perimeter device only to "Automatic Mode Safeguard Stop"; a technician selects Manual; that specific stop function does not act in Manual. Required manual enabling/mode safeguarding must be independently designed and validated. This is not proof that all robot safeguards disappear.

**F3 — chained output:** an upstream E-stop is released; System Stop rises; connected feeder/press brake safety input re-arms; a stale normal start remains asserted. The connected machine must independently demand a deliberate fresh start and prove its own safe physical state.

**F4 — cross-wired stop loop:** reciprocal System Stop interfaces create deadlock/ambiguous reset; the OEM documents a special exception. A safety integrator must design the actual multi-machine stop hierarchy, avoid circular assumptions and test each direction.

**F5 — false hold inference:** category 2 monitored standstill keeps robot drive power; independent process hazards (gripper dropping part, spindle coasting, hydraulic ram lowering, conveyor motion) persist unless addressed.

## Human-factors countermeasure
Prefer a clearly labeled **outside-cell RESET** with sightline/zone-clear confirmation, separate **START**, a visible mode indicator and an accessible inside escape/emergency means appropriate to the cell. Design gates to latch/reinstall quickly and reliably, put jam-clear tools outside the hazard when practical, and make the intended access procedure faster than defeating a sensor. A remote HMI/phone is not evidence that the operator can see every hidden space.

## Evidence ledger
- **DOC-CONFIRMED:** UR-01..08, within exact cited software/model/article editions.
- **SOURCE-CONFIRMED:** none; no UR firmware or LinuxCNC source inspected.
- **TEST-CONFIRMED:** none; no machine/PLC/lab run.
- **COMMUNITY-REPORTED:** none.
- **INFERENCE:** F1..F5 integration failure scenarios and proposed safeguards.
- **UNKNOWN:** selected robot existence, selected cell wiring, reset topology, stop performance, safe holding, actual occupancy sensing and restart.

**Safety boundary:** do not use LinuxCNC/HAL, normal FPGA outputs, HMI state, fieldbus command or a green status bit as personnel-safety authority. No exposed-person operation without qualified proof; fault experiments only isolated/remote after risk review. No numeric stopping-distance, PL/SIL or hydraulic state invented.
