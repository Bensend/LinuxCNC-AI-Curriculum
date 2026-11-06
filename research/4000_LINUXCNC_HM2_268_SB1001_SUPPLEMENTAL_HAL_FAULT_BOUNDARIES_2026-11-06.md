# HM2-268 — SB1001 supplemental HAL: actual fault paths, pendant, and feedback authority (4000; 2026-11-06)

**Classification:** CONFIG-CONFIRMED at immutable public commit; source interpretation only, **NON-GRADUATED / NOT TESTED**. No execution, machine operation, compute, or Actions.

## Reproducible fixture and provenance

Public [kentavv/kvvcreates SB1001 directory](https://github.com/kentavv/kvvcreates/tree/d7c083e9a78e70a67d34068ac4fc39745c7944b5/linuxcnc/configs/sb1001_lathe/mesa/configs/my_LinuxCNC_machine) at commit `d7c083e9a78e70a67d34068ac4fc39745c7944b5`. The INI blob is `bc293509da3681d5f22ef9b5d6e51dbceff2aac7`; main HAL `4278606c5d65510291c60230d4176e040397c65a`. Supplemental blob identifiers: `custom.hal` `61036d9340b9e22995cad4e44ef9e87ea52ee255`; `vc-p4s.hal` `59ce54568754b87f50361f9198bc840d184733b1`; `buttons.hal` `206793547a5a552311cfce163b48f41924bb947a`; `postgui_call_list.hal` `c048069bdfda958de2c6ac8cbe94e2514056bb7a`; `custom_postgui.hal` `49524691a28c780c1cf75b9d026efe801475392a`; `vc-postgui.hal` `ae766a56863b40ee0edaf233eac1d2fd26268893`; `shutdown.hal` `8766c9e72e6bd9a8f2fc157089699f02a5c64992`. All eight files were fetched at the pinned commit, not inferred from filenames.

## What the supplemental files actually change

**CONFIG-CONFIRMED:** `custom.hal` and `shutdown.hal` contain only placeholder comments. `postgui_call_list.hal` sources `custom_postgui.hal`. The latter adds AXIS/PyVCP displays, jog-to-manual-mode request logic, a Chronos camera trigger, and velocity logging from `x-vel-cmd`/`z-vel-cmd`; these are commanded velocities, not measured physical axis velocities. `vc-postgui.hal` links pendant maximum-velocity controls to INI HAL parameters; it does not replace joint motor feedback. `vc-p4s.hal` routes pendant jog, override, MDI, machine and program commands through HALUI; it does not add independent X/Z encoders.

**CONFIG-CONFIRMED:** The main HAL still defines `x-pos-fb` from `hm2_7i76e.0.stepgen.00.position-fb` to `joint.0.motor-pos-fb` (lines 178–179) and `z-pos-fb` from stepgen.01 to joint.1 (228–229). The supplemental files inspected here do **not** override those feedback nets. Thus HM2-267's feedback-authority conclusion holds for this *selected complete INI-listed file set*: generated-step accumulation is not independent motor position sensing. This does **not** establish the actual machine's as-installed wiring, servo-drive internals or accuracy.

## Newly recovered fault / control graph

Main HAL line 131 connects `hm2_7i76e.0.7i76.0.0.input-10-not` to `spindle-good` and `motion.enable`; line 132 uses complementary `input-10` for `spindle-0-alarm`. Line 136 connects `input-11-not` to `axes-alarm`. In `buttons.hal`, `spindle-0-alarm` and `axes-alarm` enter OR stages `or2.stop0` and `or2.stop1`; `debounce.1.0` (configured 5 servo cycles, nominal 5 ms) feeds `estop_latch.fault.fault-in`. The latch fault output contributes to `or2.stop`, then `or2.stop2`, `run-disable`, and a `oneshot.fault` request to `halui.program.stop`. A distinct `spindle-0-torque-stallwatch` enters `and2.stallwatch-pause` gated by `run-on`, then the pause-request OR network. These are **external digital alarm/status and software program-control paths**, not physical position feedback.

The alarm signal names indicate intended semantics, **not proven drive fault coverage or physical response**. In particular, neither `axes-alarm` nor `spindle-0-alarm` is evidence that an undetected lost-step event will always be detected. No inspection of drive firmware, external wiring, machine logs, or fault injection occurred. `motion.enable` wiring may change behavior on a spindle-good loss; exact runtime behavior and precedence need a version-matched motion source trace or nonmoving test. The fault latch and program stop are not independent personnel-safety authority.

## Distinct spindle feedback

Main HAL lines 315–317 connect `hm2_7i76e.0.encoder.00.position`, `.velocity`, and `.index-enable` to spindle revolution, velocity and index nets. This is a **separate spindle encoder path**, not an X/Z axis encoder. Keep threading spindle feedback and X/Z step-generated feedback separate when interpreting following errors and G33/G76 performance.

## Inspectable diagnostic exercise (not executed)

1. At the pinned revision, inspect the INI `[HAL]` HALFILE and POSTGUI_HALFILE ordering; follow `postgui_call_list.hal` to `custom_postgui.hal` before concluding all files have been covered.
2. In a separately authorized nonmoving LinuxCNC session, `halcmd show sig x-pos-fb`, `halcmd show sig z-pos-fb`, `halcmd show sig axes-alarm`, `halcmd show sig spindle-0-alarm`, `halcmd show sig motor-alarm`, and `halcmd show sig spindle-revs`; compare producer/consumers, not merely labels.
3. Observe `halcmd show pin 'hm2_7i76e.0.7i76.0.0.input-1*'` and the corresponding alarm signals **without** commanding motion or injecting faults. Do not treat the observed logic polarity as proof of physical fault-chain correctness.
4. Distinguish three hypotheses: (A) a motor physically stalls but FPGA step counts advance; (B) a drive reports an axis alarm; (C) spindle encoder stops updating. Predict distinct observable HAL signatures before any authorized simulation.

**Falsifiable predictions:** No supplemental file replaces X/Z motor-pos-fb. `axes-alarm` can reach the software fault latch without altering X/Z stepgen position-fb. `spindle-revs` originates from encoder.00, not the X/Z stepgens. `x-velocity-upm` represents scaled command, not independent tachometry. A drive that never asserts the mapped alarm may not be detected by this alarm path.

## Evidence and next work

The supplemental-file audit closes the concrete HM2-267 question. **UNKNOWN:** physical drive alarms, active machine revision, whether external hardware implements a separate safe stop, and exact motion enable runtime response. **Next high-value rotation:** inspect a real LinuxCNC mill probing configuration and the motion/interpreter probe-result lifecycle, including how G38.x success/failure is surfaced; do not repeat the already closed SB1001 feedback argument. Preserve graduated levels, blind separation and independent personnel-safety gates. No hosted Actions.
