# Safety output short-to-24 V / reverse-current diagnostic boundary — 2026-09-18

## Scope and parallel-lane boundary

This is an independent Lane-B safety study. At selection time, current `main` ended at primary checkpoint `465fe293`, whose durable branch is press hydraulic/final-element authority composition and whose next work seeks a same-machine Y1/Y2 disagreement -> safety latch -> reset -> monitored hydraulic re-enable -> pressure/load witness chain. This study does **not** modify that module or its evidence package.

It also advances beyond Lane B's prior generic separate-24-V-supply/backfeed boundary by concentrating on a narrower failure mechanism documented by a safety-controller manufacturer: **short-to-24-V and reverse-current behavior at semiconductor safety outputs, especially when diagnostic test pulses are disabled.**

No OpenPressBrake wiring topology is asserted here.

## Question

When a safety controller commands an electronic safety output OFF, what prevents an external +24 V fault or reverse-current path from holding the output/load energized, and what diagnostic assumptions are lost when output test pulses are disabled?

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by cited manufacturer/source material.
- **DOC-CONFIRMED** — repository or design documentation states it for the implementation under review.
- **TEST-CONFIRMED** — a controlled test demonstrates it on the actual implementation.
- **COMMUNITY-REPORTED** — reported by a practitioner/community source but not independently verified.
- **INFERENCE** — engineering conclusion derived from evidence; not itself a manufacturer statement about OpenPressBrake.
- **UNKNOWN** — evidence is insufficient or machine-specific measurement/design is required.

## Manufacturer evidence

### SICK Flexi Soft modular safety controller

**SOURCE-CONFIRMED.** SICK Flexi Soft hardware operating instructions state, for single-channel safety outputs, that protected or separate cabling is required because although a short circuit to 24 V can be detected, there is no other means of switching off the device.

**SOURCE-CONFIRMED.** The same manual states that when safety-output test pulses are deactivated, protected or separate cabling is required because a short circuit to 24 V cannot be detected while the safety output is High.

**SOURCE-CONFIRMED.** Critically, SICK further warns that this condition can impair the ability of the *other* safety outputs to switch off due to reverse currents if an internal hardware error is detected.

**SOURCE-CONFIRMED.** For safety outputs operated without test pulses, SICK requires a periodic diagnostic action: at least annually all such outputs are switched off together for at least one second, or the Flexi Soft system is restarted by switching off its supply voltage.

Source: SICK, *Flexi Soft Modular Safety Controller — Hardware Operating Instructions*, technical-data notes, document 8012478. Public manufacturer PDF indexed at https://www.sick.com/media/docs/0/60/660/operating_instructions_flexi_soft_modular_safety_controller_hardware_en_im0031660.pdf

These statements are product-family evidence. They do not prove OpenPressBrake uses Flexi Soft or has identical semiconductor behavior.

### Pilz and Rockwell context

**SOURCE-CONFIRMED.** Pilz PNOZ safety-relay product documentation exposes device supply, safety contacts/semiconductor outputs, input circuits, start circuits, and feedback loops as distinct electrical functions. This supports treating supply state, safety-output command, and final-element feedback as separate evidence rather than one generic `24 V OK` fact.

**SOURCE-CONFIRMED.** Rockwell Guardmaster safety-relay documentation similarly exposes a 24-V control supply, safety-related outputs and feedback capability as separate device functions.

These sources are contextual only; they are not used to transfer SICK-specific reverse-current behavior to unrelated products.

## Frozen distinctions

**SAFETY LOGIC COMMAND OFF != OUTPUT TERMINAL PROVEN LOW != LOAD PROVEN DE-ENERGIZED.**

**OUTPUT TEST PULSES DISABLED != DIAGNOSTIC BEHAVIOR UNCHANGED.**

**ONE OUTPUT CAN SWITCH OFF != A DIFFERENT OUTPUT CANNOT ELECTRICALLY INTERFERE WITH THAT SHUTDOWN.**

**SHORT-TO-24-V DETECTION != INDEPENDENT PHYSICAL MEANS OF REMOVING LOAD POWER.**

**OUTPUT LED / HMI BIT OFF != EXTERNAL +24-V BACKFEED ABSENT.**

## Architecture consequence

**INFERENCE.** A safety-output review must trace actual electrical energy paths, not stop at the safety program's Boolean output state. For every semiconductor safety output relied on to remove hazardous authority, the design review should identify:

1. source/sink topology and external load supply;
2. whether output test pulses are enabled;
3. what short-to-24-V, short-to-0-V and cross-output faults the selected device can diagnose;
4. whether disabling pulses changes diagnostic coverage or requires protected/separate cabling;
5. whether one output or shared load can feed another output by a reverse-current path;
6. whether a single-channel output has another independent physical shutdown path;
7. what external contactor/STO/valve feedback actually proves;
8. how a detected output fault latches and what deliberate reset/rearm is required;
9. what periodic proof test is required by the selected manufacturer's manual;
10. what remains energized after the safety output changes state.

For OpenPressBrake, LinuxCNC/HAL/ordinary FPGA may report safety diagnostics or consume a permissive, but **INFERENCE:** ordinary control must not be inserted as the sole element that filters, regenerates, validates, or removes personnel-safety output authority.

## Failure-path matrix

| Injected/assumed fault | Required question | Evidence needed before claiming safe response |
|---|---|---|
| Safety output conductor shorted to +24 V | Can the load remain energized despite an OFF command? | Selected safety-output manual + actual wiring + physical test where appropriate |
| Output test pulses disabled | Which short diagnostics are lost? | Exact device/configuration manual and configured parameter evidence |
| Two outputs feed a shared/interconnected load network | Can reverse current defeat the other channel's OFF state? | Device output topology, load schematic, cable/suppressor/indicator paths |
| One semiconductor output fails internally | Is there another independent means to remove hazardous authority? | Architecture and final-element trace; do not infer from dual Boolean channels |
| Output OFF but EDM/feedback remains healthy | Is feedback monitoring the actual hazardous element or only an intermediate device? | Contact type/function, final-element mapping, commissioning fault injection |
| +24 V field supply remains on while safety controller supply is removed | Can an external node energize an unpowered safety output/load path? | Actual supply-domain and reverse-current documentation |
| Pulse-free output never exercises OFF during normal production | How is latent output inability-to-switch-off revealed? | Manufacturer proof-test requirement and maintenance record |
| LinuxCNC says `safe-output=false` | Is that command/status merely informational? | Independent physical witness at safety controller/final element |

## Commissioning / validation questions

Do not inject faults on an operating hazardous machine with personnel exposed. A safe commissioning setup should isolate/remove hazardous energy or substitute a benign representative load where the question can be answered electrically.

Question-driven checks, once actual hardware exists:

- With hazardous energy controlled, command the safety output OFF and independently measure the load/output node rather than trusting software state.
- Verify the selected safety controller's documented reaction to a safely introduced output-to-24-V fault if the manufacturer's procedure permits it.
- Verify whether the fault is detected in both High and Low commanded states; do not assume symmetry.
- If test pulses are disabled for receiver compatibility, document exactly what diagnostic claim is lost and what compensating wiring/proof-test rule applies.
- Test one output fault while observing whether another output can still remove its load; this is specifically aimed at the reverse-current/common-path concern.
- Verify that reset/rearm does not become available until the output fault and final-element disagreement are cleared according to the selected architecture.
- Record physical measurements and device diagnostics separately from LinuxCNC/HMI status.

No executable verification is required at this source-study stage. When real hardware/configuration makes one of these questions concrete, use the local self-hosted `[self-hosted, openpressbrake]` runner only for executable verification that actually benefits from it; electrical fault injection itself requires an appropriately controlled physical setup, not CI compute.

## OpenPressBrake status

The following remain **UNKNOWN** until actual design/device evidence exists:

- selected safety controller and safety-output technology;
- whether outputs use test pulses;
- pulse timing/filter compatibility;
- number of independent shutdown channels;
- cable routing/protection;
- output/load supply-domain topology;
- suppressor, indicator, relay/contactor, STO or valve-interface reverse-current paths;
- exact diagnostic coverage;
- proof-test interval/procedure;
- reset/rearm semantics;
- PL/SIL/category/DC claims;
- physical stopping, hydraulic or gravity-load behavior.

No machine-specific values are created by this study.

## Precise next independent work

Find one authoritative professional implementation/manual set that exposes the complete chain:

**safety semiconductor output -> diagnostic pulse configuration -> short-to-24-V/reverse-current fault -> second shutdown path or protected wiring -> final element -> feedback/EDM -> restart inhibition/proof test.**

Prefer a worked wiring example rather than another generic product feature page. If the primary lane moves into this exact evidence package before the next Lane-B run, rotate instead to an independent safety topic such as gravity-axis mechanical brake/load-retention sequencing or safety-network communication-loss/reintegration authority.
