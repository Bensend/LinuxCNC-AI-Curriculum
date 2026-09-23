# 2590 — Safeguard selection, defeat, and stopping-distance map

## Purpose

Select safeguarding from the physical proposition and lifecycle task, not from a preferred sensor. Evidence classes here are `DOC-CONFIRMED`, `INFERENCE`, and `UNKNOWN`. No generic example is permission to operate a real machine.

## Safeguard-selection map

| Safeguard | Physical proposition it can support | Typical lifecycle/use fit | Important failure/defeat path | It cannot prove by itself |
|---|---|---|---|---|
| Fixed guard | Body access is physically obstructed through the guarded geometry | Routine production where frequent access is unnecessary | removal, missing/captive hardware defeated, reach-around/under/over, inadequate strength | dangerous state ended; alternate access controlled; maintenance energy isolated |
| Movable interlocked guard | Opening/position state is detected and can demand the safety function | Repeated production access after a stop can become safe soon enough | spare/simple actuator, misalignment, broken mounting, wiring fault, nuisance-trip-driven bypass | guard is locked; motion has stopped; locking force is adequate |
| Guard locking | Opening is prevented while release conditions are not satisfied | Hazards whose dangerous state persists long enough that immediate opening is unacceptable | insufficient holding force, lock/actuator damage, wrong escape/release arrangement, defeated target | complete dangerous-state cessation; every access path controlled |
| Light curtain / scanner | Entry into the validated sensing field is detected | Frequent material/operator access where no physical barrier is required and stopping before reach is demonstrable | reach-around/under, reflective/blanking/configuration errors, pass-through, stale stopping-time assumption | protected space empty; machine has stopped; maintenance isolation |
| Two-hand control | Both hands are deliberately occupied at the control locations under the validated concurrence/release logic | Single-operator cyclic tasks where keeping that operator's hands away from the hazard is an appropriate measure | tied-down actuator, one-hand/elbow defeat, wrong spacing/guarding, second person exposed | other people protected; operator cannot reach hazard after release; dangerous state ended |
| Enabling / hold-to-run | Deliberate maintained enabling condition is present for a restricted mode | Setup, teaching, recovery or observation where some safeguard is intentionally altered under a defined mode | taped/latched enable, mode-selection bypass, excessive allowed speed/force, confusing controls | unrestricted motion is safe; production guarding can be omitted; energy is isolated |

`INFERENCE`: the safest practical selection minimizes both exposure and incentive to defeat. If routine production requires constant entry, a cumbersome removable guard is likely the wrong engineering control even if it can be made compliant on paper.

## Two-hand control: concurrence is not merely two buttons

`DOC-CONFIRMED`: current Schmersal two-hand control material describes the device as requiring simultaneous use of both hands so the operator's hands remain at a defined safe location while the hazard persists. Current SRB-E-201ST/SRB-E-402ST modules explicitly monitor two-hand panels to ISO 13851. Pilz's current PNOZ X two-hand-monitor family likewise documents synchronization monitoring and offers ISO 13851 Type IIIA/IIIC variants.

Design consequence: a normal PLC expression such as `left_button AND right_button` is not equivalent evidence. A safety two-hand function must address the applicable concurrence, release/reinitiation, fault behavior, actuator arrangement and anti-defeat requirements of the selected type and application.

Freeze: **TWO BUTTONS TRUE != VALIDATED TWO-HAND SAFETY FUNCTION.**

Freeze: **TWO-HAND PROTECTION OF ONE OPERATOR != PROTECTION OF EVERY PERSON WITH HAZARD ACCESS.**

## Defeat/adversarial analysis

### Simple mechanical actuator

A conventional tongue/roller/hinge interlock can be robust and inexpensive. Its obvious adversarial question is whether the switch can remain made with the guard open using a spare actuator, loose part, adjustment or improvised fixture. Concealed mounting and actuator design can reduce foreseeable defeat, but diagnostics and good ergonomics remain important.

### Coded/non-contact interlock

Coding can make trivial substitution harder and can support high coding levels in documented products. It does not eliminate defeat: poor mounting, a retained authorized target, bypass wiring, configuration errors, deliberate maintenance overrides, or software forcing elsewhere can still defeat the intended function.

Freeze: **HIGH CODING LEVEL != DEFEAT IMPOSSIBLE.**

### Guard locking

A monitored lock adds another proposition: opening is prevented under covered conditions. Adversarial review must still ask whether the holding force is sufficient, whether mechanical mounting can tear away, whether emergency escape/release is appropriate, whether release occurs from a false stop indication, and whether nuisance locking encourages bypass.

Human-factor rule: recurring nuisance trips, difficult alignment, slow legitimate recovery, inaccessible diagnostics, and hard-to-reinstall guards are design inputs because they predictably create bypass pressure. Prefer captive hardware, tolerant alignment, clear diagnostics, obvious recovery and reset locations with useful hazard-zone visibility.

## ISO 13855-style minimum-distance reasoning

`DOC-CONFIRMED`: SICK's deTec2 Core instructions state that minimum distance depends on machine stopping time (from triggering the sensor function until the dangerous state ends), protective-device response time, human approach speed, resolution/detection capability, approach geometry, and application-specific parameters.

A useful symbolic form is:

`S = K * T + C`

where the applicable standard/application determines `K` and `C`, while `T` must include the relevant safety-function/machine stopping chain rather than only the sensor's response time.

A decomposition for engineering review is:

`T_total = T_sensor + T_safety_logic + T_output/final_element + T_machine_to_end_of_dangerous_state`

This decomposition is pedagogical; actual validation must use the applicable standard's definitions and measured/validated machine behavior.

`DOC-CONFIRMED`: Pilz's ISO 13855 safety-distance guidance likewise identifies safeguard response time `t1`, machine response/stopping time `t2`, an undetected-approach term `C`, and approach-speed factor `K`; it gives standard-dependent example values rather than a machine-specific answer.

### Explicit sourced sample — not a machine answer

Using Pilz's published explanatory values only to demonstrate sensitivity, suppose an applicable case used `K = 2000 mm/s`, total relevant response/stopping time `T = 0.20 s`, and an application-derived `C = 100 mm`. Then the illustrative arithmetic is:

`S = 2000 * 0.20 + 100 = 500 mm`.

If measured stopping behavior later became `0.35 s` with all else unchanged, the same illustrative expression becomes `800 mm`. The point is not either distance; it is that placement validity depends on the actual validated stopping behavior and application terms. Real-machine `T`, `C`, geometry and resulting `S` remain `UNKNOWN` here.

Freeze: **DEVICE RESPONSE TIME != COMPLETE STOPPING TIME.**

Freeze: **OLD STOPPING-TIME MEASUREMENT != PERMANENTLY VALID SAFETY DISTANCE.** Brake wear, drive changes, load changes, valve changes, control changes and maintenance can trigger revalidation needs.

## Pass-through / inside-zone architecture

A perimeter protective field detects crossing, not continued occupancy behind the field. Therefore `field clear` cannot be used as proof that the protected volume is empty.

Architecture questions must include:

1. Can a person pass fully through the field and remain in the hazard zone?
2. Can reset/rearm be operated from a location with a meaningful view of the zone?
3. Are blind spots large enough to require additional presence detection, trapped-person escape or other measures?
4. Does reset merely rearm the safety function, with a separate deliberate normal-start command still required?
5. After power restoration or field clearing, can stored normal-control commands create unexpected motion?

Freeze: **PROTECTIVE FIELD CLEAR != PROTECTED SPACE EMPTY.**

Freeze: **RESET/REARM != MOTION START.**

## Enabling and hold-to-run boundary

An enabling device belongs to a defined restricted operating mode; it is not a convenient bypass key. The design must bound what motion/energy remains possible, who can be exposed, how mode selection is controlled, and what happens on release, fault or loss of enabling state. A taped or latched enabling control defeats its human-presence proposition.

Until authoritative device/type-specific evidence is attached, exact enabling-device position logic, allowed speed/force and integrity allocation remain `UNKNOWN` rather than being invented.

## Production safeguarding versus maintenance isolation

Production safeguards control access and/or demand safety-related stopping. They do not automatically establish the zero-energy or restrained state required for maintenance. Electrical isolation, hydraulic/pneumatic stored-energy control, gravity restraint, blocking and verification remain separate lifecycle propositions.

## LinuxCNC boundary

LinuxCNC/HAL/FPGA may request normal stops, display guard status, inhibit ordinary cycle commands and provide diagnostics. Without safety-rated evidence for the complete function, it is not the sole personnel-safety authority for guard, light-curtain, two-hand or enabling functions.

## Evidence provenance

- `DOC-CONFIRMED`: SICK deTec2 Core operating instructions, current manufacturer PDF surfaced 2026-09-23 — ISO 13855 minimum-distance inputs include machine stopping time, protective-device response, approach speed, resolution and approach geometry.
- `DOC-CONFIRMED`: Pilz safety-distance guidance surfaced 2026-09-23 — `t1`, `t2`, `C`, `K` framing and standard-dependent approach-speed examples.
- `DOC-CONFIRMED`: Schmersal current two-hand control panel and SRB-E monitoring-module material surfaced 2026-09-23 — simultaneous two-hand use, anti-defeat physical covers, ISO 13851 monitoring.
- `DOC-CONFIRMED`: Pilz PNOZ X current two-hand monitoring family surfaced 2026-09-23 — synchronization monitoring and ISO 13851 Type IIIA/IIIC variants.
- `INFERENCE`: selection/failure maps and adversarial questions above combine those documented boundaries with the existing 2590 source preparation.

## Remaining 2590 work

1. Add authoritative enabling-device evidence and explicitly bound three-position behavior only where sourced.
2. Build a compact adversarial assessment spanning guard defeat, pass-through, stale stopping time, two-hand defeat, reset/restart and maintenance isolation.
3. Audit syllabus coverage; if coherent, create the learner route and information-separated external evaluator handoff without self-graduating.
