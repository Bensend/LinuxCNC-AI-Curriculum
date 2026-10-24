# 4400 — Press-brake optical guarding: do not transplant mechanical-power-press rules or mistake late detection for protection
**2026-10-24 | OSHA original regulations and official interpretation indexed | SOURCE-READING / NOT SELECTED-MACHINE APPROVAL**

## Question
A retrofit designer reads a mechanical-power-press light-curtain example, selects a compact laser guard just below a press-brake upper die, and claims compliance because the device changes state when a hand reaches the die. Which propositions are actually supported?

## Governing scope: two different machine classes
1. **29 CFR 1910.217(a)(5)** explicitly **excludes press brakes** (also hydraulic and pneumatic power presses) from that mechanical-power-press section. Original OSHA regulation:
https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217
2. **29 CFR 1910.212(a)(1), (a)(3)(ii)** is the applicable general point-of-operation guarding obligation for press brakes in OSHA's documented interpretation:
https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212
3. OSHA **CPL 02-01-025, February 14, 1997**, *Guidelines for Point of Operation Guarding of Power Press Brakes*:
https://www.osha.gov/enforcement/directives/cpl-02-01-025
   It gives a **conditional, narrow** safe-distance work-practice alternative when physical devices/barriers are not feasible, with additional program, training and inspection conditions. This is not an unrestricted replacement for guarding, nor a light-curtain sensor-to-hazard distance calculation.
4. OSHA **February 11, 2004**, *Use of laser guarding systems with hydraulic press brakes*:
https://www.osha.gov/laws-regs/standardinterpretations/2004-02-11
   In the proposed **specific** laser position under the cutting/bending blade, OSHA found detection would occur only after a hand had entered the hazardous point, too late to protect. The indexed official letter references then-current ANSI B11.3-2002 effective sensing field and actual stopping; **do not generalize the rejection to every possible laser-based press-brake safeguard**.

**Provenance:** The 1910.217 and 1910.212 regulation text and OSHA 1997/2004 indexed full-text excerpts were inspected via official OSHA search results. Direct retrieval of the OSHA 2004 letter and 1997 directive returned 403 in this session; their conclusions are **DOC-CONFIRMED from OSHA-indexed text**, not independently inspected original rendered pages. The historical 1997 directive and 2004 letter are not a claim about the latest ANSI B11.3 edition or any site's adopted rules. Confirm current jurisdiction, consensus-standard edition, equipment and application before acceptance.

## Two distinct distances that must not be conflated
| Distance | What it addresses | Why a shortcut fails |
|---|---|---|
| Light-curtain protective separation distance | Hazard reach before effective stop, including actual device/controller/final-element response, measured stopping behavior, geometry and **effective resolution**. | A small number in an unrelated OEM example, old machine setting, or “14 mm physical” label is not a selected-machine calculation. |
| OSHA 1997 press-brake **safe-distance work-practice exception** | Conditional trained-operator finger/hand positioning where physical guarding is shown infeasible under directive conditions. | It is **not** permission to remove a feasible guard or to substitute a 4-inch work-practice value for the protective distance of a sensor. |

Do not carry the mechanical-power-press-specific PSDI, muting or press-stroke requirements in 1910.217(h) over to a hydraulic press brake by title similarity. Likewise, exclusion from 1910.217 **does not remove** 1910.212 guarding, energy control, or a hazard-specific risk assessment.

## Timing and authority failure paths
- Optical OSSD goes OFF after hand enters a blade-mounted sensing plane: **detection can be too late**; actual beam stopping/holding must be independently proven before the hazard is reached.
- Correct SICK/Rockwell blanking configuration and green OSSD: **field geometry may have a deliberately undetected aperture**. Apply the exact device manual and physical reach geometry.
- LinuxCNC E-stop or FPGA inhibit commanded: not a qualified personnel-safety output; must not substitute for safety-rated logic/final element or independent physical stop.
- Sensor detects one finger, but backgauge/rear/side access, gravity load, workpiece whip-up, tooling fragments or hydraulic pressure remain hazardous: the light curtain cannot prove these other safe states.
- Press-brake mode/stock/tooling changes: protection must be reassessed at the *actual* hazardous stage, including late-cycle muting and residual motion. A mode name alone does not establish safe motion.
- “Stop” feedback green after repair: separate deliberate reset, safeguarded-space inspection, and fresh ordinary start still required.

## Machine-neutral verification method
**Document-only phase:** Identify exact machine class and applicable law/standard; enumerate hazards and accessible sides; select exact optical family/firmware/configuration; map effective sensing field and all blanked areas; identify independent safety controller, output and final energy-removal/holding path; determine what physical evidence is missing.

**Qualified isolated physical phase (NOT PERFORMED):** With hazardous motion isolated and personnel outside danger zone, check actual beam/test-object coverage per exact OEM and all modes, including blanked zones and reach-around; separately establish stopping/holding and restart with qualified instrumentation and machine-specific acceptance criteria. Do not have a person put a hand in a moving press as a test. Do not invent stop distances, approach speeds or hydraulic pressure thresholds.

## Evidence classifications
- **DOC-CONFIRMED:** 1910.217(a)(5) exclusion, 1910.212 point-of-operation guarding, indexed OSHA 1997 conditional directive and 2004 late-detection interpretation.
- **INFERENCE:** design transfer to modern LinuxCNC press-brake retrofit; the hypothetical fault chains.
- **UNKNOWN:** selected OpenPressBrake machine class details, guard/laser model, actual field, configuration, ram stop/hold, Y1/Y2, operator geometry, current adopted consensus edition, and machine-specific release gates.
- **TEST-CONFIRMED:** NONE. No machine operation, lab or safety evaluation authorized.
