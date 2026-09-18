# Light-curtain muting, blanking and restart-authority boundary study — 2026-09-18

## Purpose

Advance an independent safety-course branch while the primary lane remains on gravity-axis brake/retaining proof and the preceding Lane-B work remains on trapped-key personnel retention. This study addresses electrosensitive protective equipment (ESPE): what muting and blanking actually suspend, what must remain protected, and why clearing/restoring the protective field is not ordinary machine START authority.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly supported by cited manufacturer material.
- **DOC-CONFIRMED** — behavior directly stated by an authoritative document.
- **TEST-CONFIRMED** — demonstrated by controlled test. None here.
- **COMMUNITY-REPORTED** — community observation not independently verified. None relied upon.
- **INFERENCE** — engineering conclusion derived from evidence, not a machine-specific fact.
- **UNKNOWN** — requires installed-machine design, validation, measurement or the applicable machine standard.

## Authoritative evidence

### Pilz — muting is temporary suspension, not generic bypass

**SOURCE-CONFIRMED:** Pilz defines muting as safe, automatic and temporary suspension of electrosensitive protective equipment during operation. It describes dedicated sensors whose arrangement must prevent a person from activating the muting condition, and states that dangerous movement is shut down if a person enters the protected area. Sequential and cross-muting arrangements are examples of material-discrimination logic.

Source: Pilz, *Muting: a simple explanation*: https://www.pilz.com/en-INT/lexicon/muting

### Pilz — blanking removes part of the protective field continuously

**SOURCE-CONFIRMED:** Pilz describes blanking as deactivating a defined portion of a light grid. It explicitly warns that a person must not be able to reach the danger zone undetected through the blanked section and calls for additional sensing/design measures such as covers where needed. Pilz distinguishes fixed from floating blanking.

Source: Pilz, *Blanking*: https://www.pilz.com/en-US/lexicon/blanking

### SICK — restart interlock is distinct from machine start interlock

**DOC-CONFIRMED:** SICK Flexi Classic Muting operating instructions state that hazardous movement stops when the optical protective device is interrupted and that restarting cannot occur until the operator is outside the hazardous area and operates Reset in the illustrated restart-interlock arrangement. SICK explicitly warns not to confuse restart interlock with machine start interlock: the former prevents restart after an error or beam interruption, while the latter prevents starting when the machine is switched on. The document also distinguishes internal restart interlock from a machine-external restart interlock.

Source: SICK, *Flexi Classic Muting — Modular safety controller, Operating Instructions*, chapter 5.6: https://www.sick.com/media/docs/6/26/926/Operating_instructions_Flexi_Classic_Muting_Modular_safety_controller_en_IM0026926.PDF

### SICK — automatic restart is application-limited

**SOURCE-CONFIRMED:** SICK's light-curtain guidance distinguishes automatic OSSD return when the field clears from manual reset after field clearing. It says automatic restart is only suitable in special cases where a person cannot stand behind the light curtain undetected, giving a small press with arm-only access as an example.

Source: SICK, *What exactly is a safety light curtain?*: https://www.sick.com/cl/en/what-exactly-is-a-safety-light-curtain/w/blog-definition-safety-light-curtain

### KEYENCE — muting and override are distinct functions

**SOURCE-CONFIRMED:** KEYENCE GL-R configuration guidance describes muting as automatically and temporarily disabling safety functions and separately describes override as a supplementary function used when muting cannot be enabled. This supports treating override as a separate abnormal/recovery authority rather than silently folding it into normal muting logic.

Source: KEYENCE, *GL-R Wiring Diagram Navigator — Is the Muting Function Necessary?*: https://www.keyence.com/support/user/safety/wiring_navi/gl-r/assistant/06P.jsp

## Frozen distinctions

**INFERENCE:**

`PROTECTIVE FIELD CLEAR != MUTING AUTHORIZED != MUTING ACTIVE != PERSON EXCLUDED FROM THE MUTED PATH != HAZARD ABSENT.`

`BLANKED BEAMS != UNPROTECTED OPENING ACCEPTABLE != REACH-THROUGH IMPOSSIBLE.`

`MUTING COMPLETE != ESPE FUNCTION RESTORED != RESTART INTERLOCK SATISFIED != SAFETY RELEASE != ORDINARY START AUTHORITY.`

`RESET != START.`

`LINUXCNC/HAL REQUESTS MOTION != LINUXCNC/HAL MAY AUTHORIZE ESPE DEFEAT.`

Muting/blanking parameters alter the protective function itself. Where they are safety-relevant, their authority and validation belong on the safety side of the architecture. LinuxCNC, an ordinary FPGA, or HMI may display state or request a process action, but must not be treated as the sole personnel-safety authority simply because it knows the machine cycle.

## Failure-path analysis

| Failure / misuse | Dangerous assumption | Required validation question |
|---|---|---|
| Person can actuate muting sensors | Sensor sequence equals material identity | Can a person/body/object reproduce the valid muting sequence? |
| Muting sensor stuck active | Active sensor means material is present | Does the safety function detect or safely bound an implausible/stale muting state? |
| Muting remains active after material clears | Muting naturally ends with process flow | What independent condition terminates muting and what happens on timeout/disagreement? |
| Blanked opening allows reach-around/reach-through | Only intended workpiece occupies blanked beams | Can any body part reach the hazard undetected through or around the blanked region? |
| Floating blanking accepts too much obstruction | Configured beam count remains harmless | Does obstruction beyond the validated blanking allowance force the protective response? |
| Ordinary PLC/LinuxCNC bit directly creates muting | Cycle state is safety evidence | What safety-side evidence discriminates permitted material flow from personnel access? |
| Field clears and OSSD returns automatically | Clear field means nobody can remain in hazard | Can a person stand behind/pass beyond the ESPE without continued detection? |
| Reset button visible/available from wrong location | Reset means area is clear | Does reset location/procedure support actual area-clear verification for the application? |
| Reset also starts motion | One button is convenient | Is safety restoration separated from fresh ordinary START intent? |
| Power cycle during muting | Reboot state is equivalent to known safe state | Does restart require re-establishing valid ESPE/muting state rather than restoring stale authority? |
| Muting indication fails | Operator indication is the safety function | Is the safety decision independent of indication, and is required indication itself monitored/validated where applicable? |
| Override becomes routine production mode | Override is just another muting path | Is override restricted to the documented recovery purpose with deliberate authorization and restoration? |

## Question-driven commissioning worksheet

1. Identify the exact ESPE protective field, hazard(s) it initiates a stop for, and every path by which a person can pass beyond or around it.
2. Record whether each configured exception is **muting**, **fixed blanking**, **floating blanking**, **override**, or another documented function. Do not call all of them bypass.
3. For muting, trace every initiating sensor and required sequence. Challenge person-like activation, stuck sensors, wrong order, incomplete sequence and material stopped halfway through.
4. For blanking, physically challenge the resulting opening for reach-through, reach-over, reach-around and access beside the intended object. Add fixed guarding/additional sensing where the validated design requires it.
5. Challenge clearing the optical field while a person could remain behind it. If undetected presence is possible, automatic restart is not justified merely because the field is clear.
6. Trace `field restored -> restart interlock/reset -> safety release -> fresh ordinary START` as distinct states. Verify stale START/JOG/ENABLE cannot become motion when safety authority returns.
7. Power-cycle the ordinary controller/HMI in each relevant ESPE state during validation. Safety authority must not depend on LinuxCNC/HAL remembering the pre-cycle state.
8. Power-cycle or fault the safety-side device only under the manufacturer's validated commissioning procedure. Verify no stale muting/blanking/override authority silently reappears.
9. Change one muting/blanking parameter and treat it as a safety-function configuration change requiring appropriate revalidation of the affected protective field.
10. Record all UNKNOWN physical parameters rather than substituting generic distances, timings or press behavior.

## OpenPressBrake boundary

The curriculum may teach that an OpenPressBrake implementation must preserve an independent safety authority around any ESPE function. It may not claim which light curtain, resolution, mounting distance, stopping time, muting/blanking function, reset location, hydraulic response, performance level/category/SIL or safe-distance calculation applies to the actual machine until the installed architecture and measurements exist.

In particular, this study **does not calculate a safety distance**. That requires the actual protective-device characteristics, machine stopping behavior and applicable requirements. No generic stopping number is substituted.

## Compute decision

No simulation, synthesis, benchmark or executable test is justified. The current evidence gap is architectural and physical: installed geometry, person-detection coverage, device configuration and actual machine stopping behavior. No GitHub-hosted or self-hosted Actions compute was used.

## Precise next independent work

Find an authoritative professional press or press-brake ESPE commissioning example that exposes **protective field -> muting/blanking configuration -> person/material discrimination -> stop output -> restart interlock/reset -> separate machine START**, including at least one failed/stuck muting-sensor or invalid blanking case. Preserve stopping distance/timing as UNKNOWN unless the source provides a complete worked example, and never transfer its numbers to OpenPressBrake without measurement.