# 3300-P2 — Real plasma machine commissioning comparison

Date: 2026-09-14

Status: **COMMUNITY / CONFIGURATION EVIDENCE PASS — P2 underway**

## Purpose

Compare real QtPlasmaC commissioning histories against the P1 source contract. Preserve chronology and failure evolution rather than teaching only the final working setting.

Community reports are evidence leads and field experience, not substitutes for pinned LinuxCNC source behavior.

---

## Machine A — Hypertherm Powermax 45XP + Mesa 7i96 + THCAD5 + external Arc OK + ohmic/THC

Thread: https://forum.linuxcnc.org/plasmac/48236-qtplasmac-2-10-arc-ok-and-thcad-troubleshooting-help-needed

Date: February 2023

Reported architecture:

- existing LinuxCNC plasma machine being upgraded to QtPlasmaC;
- Mesa 7i96;
- THCAD5 for arc-voltage/THC work and ohmic touch-off integration;
- Hypertherm Powermax 45XP;
- external Arc OK signal from the plasma source.

### Chronology

1. **Arc OK appeared correct at the HAL level, but the process still reported arc-start failure.**
   The builder could see the 7i96 input and `plasmac` Arc OK surface change, yet QtPlasmaC still behaved as though no valid transfer had occurred.

2. **Configuration mode was wrong for the chosen evidence source.**
   Review exposed QtPlasmaC `Mode = 0` even though this machine was intended to use the external Arc OK signal. Changing the QtPlasmaC preference to **Mode 1** fixed the Arc OK portion of the commissioning problem.

3. **Arc-voltage polarity/scaling remained wrong after Arc OK was fixed.**
   The builder continued seeing reversed/negative voltage behavior.

4. **Physical Hypertherm-to-THCAD wiring polarity was corrected.**
   After correcting the wiring, reported arc voltage became sensible.

5. **Commissioning then moved upstream into CAM/post behavior.**
   The builder reported a Fusion 360 program-loading issue associated with geometry handling (`merge circles`) before continuing toward ohmic touch-off.

### What this teaches

- **A live HAL input is not enough to prove the process controller is consuming it under the intended semantics.** QtPlasmaC mode selects whether Arc OK is synthesized from voltage or comes from an external input.
- **Arc OK and arc voltage are independent commissioning surfaces.** Correcting one did not correct the other.
- **Sign/polarity errors can masquerade as software scaling problems.** Physical wiring provenance belongs in the diagnostic chain.
- **CAM/post errors can become the next failure surface immediately after realtime plasma I/O is working.** A production plasma diagnosis has to preserve the boundary between process-control state and generated G-code.

Evidence class: **COMMUNITY-REPORTED**, reconciled with the P1 source contract that mode 0 derives Arc OK from voltage and modes 1/2 consume the external Arc OK input.

---

## Machine B — QtPlasmaC gantry with Mesa 7i96 and tandem Y joints

Thread: https://forum.linuxcnc.org/plasmac/42283-help-with-qtplasmac

Date: April 2021

Reported architecture:

- QtPlasmaC;
- Mesa 7i96;
- XYZ gantry table;
- tandem Y drive/joints;
- breakaway and other sensor signals visible during early HAL testing.

### Chronology

1. The builder initially could not find the tandem-axis setup path in PNCconf and selected a three-axis machine, then hand-edited HAL/INI files.
2. QtPlasmaC loaded and showed XYZ, while physical sensor inputs were visible, but jogging/commissioning was not yet correct.
3. Community guidance clarified the topology: the machine remains **three Cartesian axes (XYZ)** while Y has a **second tandem joint/step generator**. PNCconf exposes this as `Axis -> Tandem Axis -> Y2 Tandem StepGen` rather than inventing a fourth Cartesian axis.
4. Direction inversion for the second gantry motor may be required depending on mechanical orientation.

### What this teaches

- **Axis count and joint/actuator count are different state models.** A dual-motor gantry does not imply a fourth process coordinate.
- Sensor signals appearing correctly in HAL do not prove motion topology or homing/squaring is configured correctly.
- Plasma process commissioning and gantry-joint commissioning can fail independently; QtPlasmaC's process state should not be blamed for a joint topology problem merely because both appear in one GUI.

Evidence class: **COMMUNITY-REPORTED**. The general axis/joint distinction is already established by LinuxCNC source/course prerequisites; this build diary shows the practical plasma-table failure mode.

---

## Machine C — Everlast 82i + Mesa 7i96 + THCAD-2

Thread: https://forum.linuxcnc.org/plasma-laser/56110-7i96-with-thcad-2-setup-on-everlast-82i

Date: May 2025

Reported architecture:

- Everlast 82i plasma source;
- Mesa 7i96;
- THCAD-2 arc-voltage acquisition;
- internal Everlast voltage divider.

### Chronology

1. Initial QtPlasmaC arc-voltage display was negative/wrong and direct THCAD observations were unstable or unconvincing.
2. Experienced community guidance identified a hardware-interface requirement: THCAD/THCAD2 divide-by-1 is not reliable with the default 7i96 encoder configuration; use the THCAD's **1/32 frequency divide** for this integration.
3. The Everlast source also has a divider-ratio quirk that affects the effective software scaling.
4. After changing to `/32` and correcting offset/scale settings, the builder reported that voltage readings were in order and moved on to voltage/height adjustment and material data.

### What this teaches

- **THCAD raw frequency configuration is part of the measurement contract.** The controller cannot infer correct volts if the frequency interface itself is outside the expected range.
- Plasma-source divider, THCAD divider and LinuxCNC scale/offset must be treated as a provenance chain rather than one mysterious 'voltage scale' number.
- A bad voltage display does not by itself prove the plasma arc, QtPlasmaC state machine or THC algorithm is defective.

Evidence class: **COMMUNITY-REPORTED**. The report includes guidance from experienced LinuxCNC/Mesa contributors and a same-machine follow-up that the changes corrected the reading, but this pass does not promote it to generic hardware truth beyond the reported combination.

---

## Cross-machine comparison

| Boundary | Machine A | Machine B | Machine C | General lesson |
|---|---|---|---|---|
| Process semantics | External Arc OK required Mode 1 | Not the primary problem | Voltage acquisition under commissioning | Select process mode from actual evidence sources, not GUI appearance |
| Motion topology | Conventional table context | Tandem Y joints on XYZ gantry | Conventional table context | Cartesian axes and physical joints/actuators are distinct |
| Arc-voltage chain | THCAD5 polarity/wiring error | not established in inspected chronology | THCAD-2 divide + scale/offset issue | preserve physical divider -> converter -> FPGA/encoder -> scale provenance |
| HAL observation | Arc OK visible but process failed | sensors visible but motion failed | encoder/voltage inspection used diagnostically | a changing pin proves observation, not correct system-level interpretation |
| Upstream workflow | Fusion post/geometry issue emerged after I/O fix | configuration generation/editing issue | material data became next task | process, motion config, CAM/post and recipe provenance are separate layers |

## Reconciliation against P1 source

The field reports reinforce, without redefining, the pinned-source model:

`physical source/sensor -> electrical interface -> Mesa/encoder/GPIO -> HAL signal -> QtPlasmaC mode/config interpretation -> plasmac process state -> external-offset request -> Motion applied offset -> machine motion`

Failures can occur at every boundary.

A correct value at one layer does not certify the next layer:

- Arc OK GPIO can toggle while QtPlasmaC is configured to derive Arc OK from voltage instead;
- arc voltage can have valid process physics but wrong physical polarity or conversion scaling;
- breakaway/probe inputs can be visible while tandem motion topology remains unusable;
- a working realtime plasma loop can still receive defective CAM/post output.

## Failure classes promoted into the plasma playbook

1. **Mode/evidence mismatch** — controller configured for synthesized Arc OK while hardware supplies external Arc OK, or vice versa.
2. **Polarity/sign mismatch** — plasma divider/THCAD wiring reverses voltage sign.
3. **frequency/scaling mismatch** — THCAD divider or encoder setup produces invalid scaling/range.
4. **joint-topology mismatch** — tandem gantry represented incorrectly as an additional Cartesian axis or incompletely configured joint.
5. **false confidence from HAL visibility** — observed signal transitions are treated as proof of downstream process-state correctness.
6. **postprocessor handoff failure** — realtime machine is healthy but generated G-code/process commands are invalid for the controller workflow.

## Adversarial review — 6/6 passed

1. **'Arc OK is visible in halmeter, therefore QtPlasmaC must accept it.'** Rejected: Machine A demonstrated a mode/evidence mismatch.
2. **'Negative arc volts are always a QtPlasmaC scale-sign bug.'** Rejected: Machine A's physical wiring polarity was wrong; Machine C had a different acquisition/divider problem.
3. **'A dual-motor Y gantry is an XYZA plasma machine.'** Rejected: Machine B remained XYZ with tandem Y joints.
4. **'Once plasma I/O works, the rest of commissioning is controller-only.'** Rejected: Machine A immediately encountered CAM/post geometry behavior.
5. **'THCAD scaling is just one software multiplier.'** Rejected: Machine C exposed converter frequency divide and plasma-source divider as upstream provenance.
6. **'One build's working settings define the generic QtPlasmaC architecture.'** Rejected: the three builds differ materially in Arc OK, voltage chain and motion topology; only source/documentation define generic software semantics.

## P2 state / remaining evidence

This pass satisfies the requirement to inspect differing real implementations and preserves meaningful commissioning chronology, but P2 should continue before being considered mature.

Highest-value next evidence:

1. an inspectable/downloadable QtPlasmaC config that combines **ohmic + float fallback** so real HAL wiring can be compared with P1 probing source;
2. a **Powermax RS485 / `pmx485`** implementation with communication-loss experience and the distinction between non-realtime power-source telemetry and realtime cutting authority;
3. if available, a later stage of a tandem-gantry build showing homing/squaring and normal cutting after the early PNCconf problems;
4. attachments/configs from the threads above if accessible and useful.

## Lab decision

No lab launched. These field failures add independent evidence that a synthetic fixture would not: real mode selection, wiring polarity, frequency-divider/scaling and gantry-topology commissioning mistakes.

The likely first plasma lab remains a bounded external-offset cleanup/freshness test only if source + real configurations leave a consequential uncertainty after P2/P3.
