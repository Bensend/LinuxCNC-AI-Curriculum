# LASER-ENC-01 — enclosure, viewport, beam-inhibit and service/restart field module
**4400 safety | 2026-10-26 | PUBLIC PAPER PRACTICE | NON-GRADUATED | UNSCORED**

Read the [FDA/TRUMPF source audit](../research/4400_LASER_ENC_01_FDA_TRUMPF_EMBEDDED_CLASS_IV_VIEWPORT_INTERLOCK_AND_RESET_SOURCE_AUDIT_2026-10-26.md). This is a source-based safety curriculum exercise, **not** a recipe for building or bypassing a laser safety system. No selected OpenPressBrake laser is known.

## Objective and authority layers
Explain why **laser source class**, **assembled-product accessible-emission class**, **operating versus maintenance/service configurations**, **normal LinuxCNC beam command**, **independent protective housing/interlock/shutter**, **verified optical attenuation**, **separate mechanical motion safety**, **service isolation** and **deliberate restart** are different propositions. Do not transfer any numerical safety rating or wavelength attenuation between devices.

## Twelve public unscored technician cases
For each case provide: hazard boundary, source claim, missing machine evidence, independent physical safety function, easiest robust redesign, bypass incentive and stop/rearm proof needed. No answers/hidden oracle in this file.

| Case | Paper scenario | Required discriminator |
|---|---|---|
| LE-01 | A Class I labeled laser cutter is opened for a service alignment and its internal source is described as Class IV. | Product accessible-emission class vs internal source and service configuration. |
| LE-02 | A scratched protective window is replaced with a same-thickness clear sheet from the hardware store. | Exact optical protection, wavelength(s), process-generated radiation, marking and replacement traceability. |
| LE-03 | New polished sheet stock reflects the cutting beam toward a loading slot that was previously blocked by matte material. | Reflected path through an aperture and physical coverage validation. |
| LE-04 | A door switch shows closed on the LinuxCNC HMI; the independent laser shutter feedback is absent. | Ordinary state indication vs verified beam-inhibiting final element. |
| LE-05 | The machine's laser command is OFF but a remote laser-source controller has not confirmed radiation cessation. | Control request/acknowledgment vs independent physical safe state. |
| LE-06 | Service personnel routinely prop open an inconvenient access flap to clear scrap. | Guard defeat incentive, better access layout and independently validated enclosure. |
| LE-07 | A Class IV laser's remote interlock opens and later closes while a remembered start command remains asserted. | Exact §1040.10(f)(10) scope, manual reset vs new intentional start. |
| LE-08 | A short mains interruption causes beam emission to resume; technician quotes a generic “five-second rule.” | Actual Class IV post-1986 scope, loss-duration qualifier and selected-product reset logic; no universal timer. |
| LE-09 | A laser cutting head's fiber-delivery cable is changed, with an intact green power lamp but no connector/cover evidence. | Manufacturer-compatible connection, optical confinement and post-service checks. |
| LE-10 | Scan-mirror speed fails while CNC axis velocity still looks normal. | §1040.10(f)(9) scanned-radiation failure versus ordinary motion command. |
| LE-11 | A “laser-safe” green pane is installed without spectral protection documentation. | Manufacturer TRUMPF warns color alone is not proof; check rated viewport and full radiation spectrum. |
| LE-12 | A cell stops the laser beam but the robot arm remains powered and extraction stops during a smoldering part. | Separate beam, motion, fire, extraction and energy functions; no all-safe inference. |

**Status:** LE-01…LE-12 **PUBLIC PAPER / UNSCORED**. They are not unseen blind challenges and do not establish learner competency.

## Twelve documentary gates — all NOT RUN
| Gate | Existing evidence required before selected-system review |
|---|---|
| LE-G01 | As-built laser product/source IDs, date, wavelength(s), power/pulse regime, selected standards/laser safety authority |
| LE-G02 | Exact product accessible-emission classification in operation, maintenance and service modes, including embedded source |
| LE-G03 | Qualified beam/housing geometry including loading slots, tubes, scrap openings, mirrors and specular material |
| LE-G04 | Rated/marked viewport, protective filter and optical path across laser and collateral/process-generated wavelengths |
| LE-G05 | Exact panel/door interlock identities, independent receiver and fault response with revision provenance |
| LE-G06 | Independent physical beam attenuation/shutter/source inhibit, actual feedback and safe-state verification plan |
| LE-G07 | Remote interlock, key control, emission indication and Class IV scoped manual-reset requirements where applicable |
| LE-G08 | Service/maintenance authorization, controlled area, defeat indication, reinstall verification and LOTO |
| LE-G09 | Distinct robot/axis/ram mechanical stop, gravity hold, protective devices and independent restart |
| LE-G10 | Change-control trigger for pane, coating, fixture, stock reflectivity, cable, source, scanner and enclosure |
| LE-G11 | Operator-friendly waste removal, captive guards, inexpensive correct replacement parts and observed bypass incentives |
| LE-G12 | Independent qualified laser radiation assessment and physical validation, fire/fume extraction review, and fresh-start witness |

**Status:** LE-G01…LE-G12 **NOT RUN**. No numerical emission limits, OD, beam stop time, protective distance, PL/SIL or installed machine data invented. Do not attempt an open-beam demonstration, bypass, exposure measurement or fault injection as a classroom exercise.

## Conceptual four-authority map
- **Normal control:** LinuxCNC/HAL/FPGA commands laser and axes, logs and displays status; cannot certify radiation safety.
- **Monitoring:** shutter feedback, cover status and diagnostics support troubleshooting but require qualified provenance and are not automatically safety-rated.
- **Independent safety-related control:** evaluated protective devices and selected final elements prevent accessible hazardous radiation; machine-specific design and validation required.
- **Physical protection/energy removal:** qualified enclosure/viewport, beam attenuation, electrical maintenance isolation, mechanical motion hold and fire/extraction protection are distinct physical mechanisms.

## Human factors
Make a correctly rated window and captive enclosure easy to replace, provide accessible scrap removal without exposing the beam path, label the correct parts, keep service interlock status understandable and force an explicit post-service inspection. If legitimate daily use predictably requires defeating a guard, redesign the workflow rather than treating the bypass as an acceptable habit.

## Stop and next work
This laser branch is conditional on actual laser equipment; no laser is known on selected OpenPressBrake. For any machine lacking independently demonstrated containment and safe beam interruption, **no personnel-exposed operation**; experimental work, if independently justified, must use qualified isolated/remote controls with people outside the hazard zone and residual risks documented. **G0/G1 HOLD** for OpenPressBrake; physical and evaluator gates unexecuted.
