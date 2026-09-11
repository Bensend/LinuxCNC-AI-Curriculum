# Ursviken final-source search and second independent press-brake implementation

Date: 2026-09-11
Course context: dependency-safe 4600 preparation while F02 is blocked

## Purpose

Close the repeated search for the promised post-success Ursviken/Pullmax configuration, then move to an independent implementation as required by the checkpoint rather than repeatedly mining one thread.

## 1. Bounded post-July-22-2026 Ursviken search

Searches performed on 2026-09-11 covered the exact project title, `Pullmax Optima`, LinuxCNC + GitHub/config terms, and the LinuxCNC Show Your Stuff index.

The LinuxCNC forum index still identifies **22 Jul 2026 02:28** as the last post in the Ursviken Pullmax Optima thread. No later post, downloadable final Y1/Y2 configuration, or public GitHub repository matching the project was located in this bounded pass.

Evidence classification: **COMMUNITY THREAD PRESENT / FINAL SOURCE UNAVAILABLE**.

This is now a closed search result, not an invitation to repeat the same query every lesson. Revisit only if a new post, attachment, repository, or direct source pointer appears.

Important retained evidence from the thread remains bounded: the builder reported a physical bend using two position PIDs and a separate differential synchronization PID, but the final correction insertion point, saturation path, addf order, ferror ownership, process-state implementation and recovery behavior remain unavailable for source inspection.

## 2. Independent implementation: 2018 hydraulic press-brake project

The 2018 `Hydraulic press brake control` thread is independent of the Ursviken project and exposes both the machine concept and an inline LinuxCNC `comp` skeleton.

The machine owner described:

- one glass scale on each cylinder;
- one encoder on each stepper-driven hydraulic spool valve;
- two stepper-driven valves, approximately +/-60 degrees around center;
- a down command that initially opens both valves, then adjusts each valve command to keep the two cylinders synchronized;
- stop behavior intended to command both valve steppers back to zero;
- separate up/down foot inputs, cylinder home inputs, hydraulic pump output, and E-stop input.

This is **COMMUNITY-REPORTED DESIGN INTENT**, not verified LinuxCNC runtime behavior.

The posted `pressbrake` component skeleton declares inputs for emergency brake, light curtain, safety-door sensor, enable, left/right glass-scale feedback, left/right stepper feedback, oil pressure, speed and hold-time parameters. It declares outputs for left/right stepper position commands and hydraulic pump control. However, the executable state machine contains only `INIT` and `SELECT`; `INIT` checks `Enable`, `SELECT` immediately returns to `INIT`, and none of the declared safety inputs, feedback signals, pressure input, synchronization logic, dwell timing, pump logic, or valve commands participate in executable behavior.

Evidence classification: **COMMUNITY SOURCE-SKELETON**.

### Adversarial conclusion

Pin declarations are not behavior. A component can expose plausible names such as `Emergency_brake`, `Light_curtain`, `Oil-pressure`, two scale inputs and two valve outputs while implementing none of the corresponding semantics. Therefore source review for a press-brake controller must trace each claimed safety/process/control input into executed branches and final actuator authorization; interface shape alone is insufficient evidence.

## 3. Architecture comparison

| Question | Ursviken/Pullmax | 2018 project | Defensible conclusion |
|---|---|---|---|
| Independent physical Y feedback | Two physical ram feedback loops reported | Two glass scales explicitly intended | Multiple projects independently require side-specific physical truth. |
| Differential synchronization | Physical success reported with separate sync PID | Intended by adjusting two valve commands from side mismatch | Synchronization is a distinct control responsibility, but exact insertion topology is not common-source proven. |
| Hydraulic decoding | Six spool coils plus servo valves; modes include up/down/fast/slow/dwell/decompression | Stepper spool position directly represents hydraulic command | Hydraulic actuator mapping is machine-specific and must not be generalized from one project. |
| Process state | Later discussion separates press state from hydraulic behavior | Skeleton proposes state machine but does not implement it | Semantic process state should not be inferred from actuator-interface declarations. |
| Decompression | Explicitly identified as a distinct Ursviken hydraulic mode | Not implemented/shown | Decompression cannot be modeled generically as merely reverse Y motion. |
| Mid-state enable/fault handling | Final source unavailable | Not implemented | Remains an explicit 4600 verification requirement. |
| Safety authorization | Physical machine has safety-related devices, but final software source unavailable | Safety pins declared but unused | No functional-safety conclusion follows from either public software artifact. |

## 4. Generic trace contract strengthened by the comparison

A future 4600 implementation review should require an explicit trace through four separate concepts:

1. **Semantic press state** — e.g. ready, approach, working stroke, dwell, decompression, return, fault. This answers what the process believes it is doing.
2. **Abstract hydraulic/process mode** — the machine-independent request needed to realize that state, without yet naming coils or polarities.
3. **Machine-specific decoder** — translates the abstract request into the actual pump/valve/servo arrangement, including mutually exclusive or prerequisite combinations.
4. **Final ordinary actuator authorization** — combines decoded request with ordinary enable/fault permission before the hardware-facing output. Functional-safety authority remains separately justified.

For every active state, review must answer what happens on ordinary-enable loss, pedal release, stale/invalid feedback, Y1/Y2 mismatch, command saturation, pressure/process failure, timeout, and re-enable. A state machine that only defines the happy-path transition is incomplete.

## 5. Next source target

Do **not** repeat the Ursviken final-config search without new evidence. The next useful 4600 work is to find or inspect another public press/hydraulic-machine implementation that has executable state-to-actuator decoding, then trace:

`semantic state -> abstract process/hydraulic mode -> machine-specific decoder -> ordinary final actuator authorization`

Priority evidence is a source set that actually implements decompression or another nontrivial hydraulic transition plus mid-state disable/fault handling. If no mature press-brake source exists, a bounded adjacent hydraulic LinuxCNC implementation may be used for architecture evidence but must be labeled as non-press-brake evidence.

## Sources

- LinuxCNC forum, `Ursviken Pullmax Optima 130 press brake retrofit with 4 axis backgage`, NWE, last located post 22 Jul 2026: https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage
- LinuxCNC forum, `Hydraulic press brake control`, microsprintbuilder/Grotius, beginning 21 Sep 2018: https://forum.linuxcnc.org/30-cnc-machines/35266-hydraulic-press-brake-control

## Sufficiency decision

The bounded Ursviken search obligation is complete: **FINAL SOURCE UNAVAILABLE** as of 2026-09-11. The independent 2018 source skeleton is useful chiefly as negative/adversarial evidence: it demonstrates why declared pins and intended architecture must not be mistaken for executed synchronization, process, fault, or safety behavior. The next research step therefore moves away from repeated Ursviken searching and toward executable state-to-actuator decoding evidence.
