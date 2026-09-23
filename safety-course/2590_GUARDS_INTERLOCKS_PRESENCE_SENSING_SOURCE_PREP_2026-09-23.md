# 2590 — Guards, interlocks, presence sensing, and two-hand controls — source preparation

## Scope

2590 starts from the physical access proposition, not from a favorite sensor:

`person cannot reach/occupy the hazard while the dangerous state remains possible`

Different safeguarding technologies establish different propositions. A fixed guard, movable interlocked guard, guard lock, light curtain/scanner, two-hand control and enabling/hold-to-run device are not interchangeable merely because each can participate in a safety function.

Evidence classes used here: `DOC-CONFIRMED`, `INFERENCE`, `UNKNOWN`. No machine-specific stopping distance is asserted.

## First proposition map

| Safeguard evidence/state | Proposition it may support | It does NOT by itself prove |
|---|---|---|
| fixed guard physically present | access path is obstructed within its actual geometry/strength | every alternate reach/access path is controlled; guard cannot be removed/defeated |
| movable guard interlock reports closed | covered guard/actuator relationship is detected | dangerous motion has stopped; guard is physically locked |
| guard-locking device reports locked | covered locking mechanism is in its monitored state | holding force is adequate for this machine; dangerous state has ended |
| coded/RFID interlock | actuator identity/coding can increase defeat resistance within documented behavior | impossible defeat; correct mounting; safe stopping time |
| light curtain clear | protected field is not interrupted within device capability | nobody is inside a protected space behind the field; machine can stop before reach |
| light curtain interrupted | protective field detected intrusion | hazardous motion/energy has physically ceased |
| two-hand inputs valid | required actuators are operated according to the control's validated timing/logic | operator cannot reach hazard before dangerous state ends; other persons are protected |
| enabling/hold-to-run state valid | deliberate enabling condition exists | unrestricted hazardous motion is acceptable or all other safeguards may be ignored |

## Guard interlocking versus guard locking

**DOC-CONFIRMED:** Current Schmersal AZM400 product documentation separately classifies the interlocking function and the guard-locking function, and publishes separate safety characteristics for them. It also documents RFID coding and a high coding level according to ISO 14119 for the cited variant.

Teaching consequence: **GUARD CLOSED/INTERLOCKED != GUARD LOCKED.** The first proposition concerns detection of guard state; the second concerns preventing opening under the conditions for which locking is required.

**DOC-CONFIRMED:** Schmersal's ISO 14119 application material states that where stopping time requires an interlocking device with guard locking, required locking force remains an application/machine-manufacturer determination rather than a universal value. It also distinguishes auxiliary release, emergency release and emergency exit purposes.

Teaching consequence: **CATALOG HOLDING FORCE != APPLICATION-SUFFICIENT GUARD LOCKING BY DEFAULT.** Escape/release behavior is part of lifecycle design, not an accessory afterthought.

## Presence sensing and stopping-time dependency

**DOC-CONFIRMED:** SICK's deTec2 Core operating instructions state that ISO 13855 minimum-distance reasoning depends on machine stopping time, protective-device response time, human approach speed, detection capability/resolution, approach geometry and application parameters. The manufacturer warns that too-small distance can allow a person to reach the hazardous point before the dangerous state ends.

Teaching consequence: a light curtain is not a magic wall. Its location is coupled to the **measured/validated dangerous-state stopping behavior of the actual machine and safety function**.

A generic chain is:

`intrusion detected -> safety-related control responds -> final elements transition -> dangerous state ends -> person has not reached hazard first`

Every arrow needs evidence appropriate to the actual machine.

## Presence sensing versus presence prevention

A perimeter light curtain may detect crossing without proving the safeguarded space is empty afterward. If a person can pass through and remain behind the sensing plane, restart/reset design needs an additional occupancy/visibility/procedural architecture appropriate to the hazard.

Therefore:

- **PROTECTIVE FIELD CLEAR != PROTECTED SPACE EMPTY.**
- **RESET DEVICE OPERATED != HAZARD ZONE VERIFIED EMPTY.**
- reset placement/visibility must support the human verification expected by the design rather than reward blind reset from a convenient hidden location.

## Defeat resistance and human factors

The course treats foreseeable bypass as an engineering input. Coding, concealed mounting and non-contact sensing may make simple actuator substitution harder, but no component label eliminates foreseeable defeat.

Practical design tests include:

- Is normal loading/unloading faster with the guard used correctly than with it defeated?
- Can alignment tolerate ordinary door sag/vibration without nuisance trips?
- Are approved release/recovery mechanisms obvious enough that operators do not improvise bypasses?
- Can a removed guard be reinstalled quickly with captive hardware/alignment features?
- Does diagnostics identify the actual open/misaligned device rather than forcing repeated guard cycling?
- Can reset be performed only with adequate view/control of the hazardous area, or is separate presence detection needed?

A safeguard whose nuisance behavior predictably teaches operators to defeat it has a design defect even if the component itself is safety-rated.

## Initial failure questions

For any guard/interlock/presence-sensing design ask:

1. Can the hazard be reached over, under, around or through the safeguard?
2. Can a person enter and remain undetected behind a protective field?
3. Does opening the guard merely issue a stop command, or is dangerous-state cessation actually established?
4. If stopping takes long enough, must the guard remain locked until release is safe?
5. Can the actuator/sensor be defeated with a spare target, loose magnet, tape, software forcing or misadjustment?
6. What happens on broken wire, short, misalignment, loss of power and diagnostic disagreement?
7. Does reset/rearm cause restart or merely permit a separate start command?
8. Are escape/emergency-release needs addressed if a person can be inside the guarded space?
9. Is safeguard positioning based on actual stopping behavior and approach geometry rather than catalog response time alone?
10. Does maintenance require a different energy-isolation state from production guarding?

## Initial freezes

- **GUARD CLOSED != DANGEROUS STATE ENDED.**
- **GUARD INTERLOCKED != GUARD LOCKED.**
- **GUARD LOCKED != APPLICATION-SUFFICIENT HOLDING FORCE PROVED.**
- **LIGHT CURTAIN INTERRUPTED != MACHINE PHYSICALLY STOPPED.**
- **PROTECTIVE FIELD CLEAR != PROTECTED SPACE EMPTY.**
- **DEVICE RESPONSE TIME != COMPLETE MACHINE STOPPING TIME.**
- **SAFETY DISTANCE != A CATALOG CONSTANT.**
- **HIGH-CODING INTERLOCK != DEFEAT IMPOSSIBLE.**
- **SAFETY RESET != MACHINE START AUTHORIZATION.**
- **ORDINARY LINUXCNC/FPGA GUARD LOGIC != PERSONNEL-SAFETY AUTHORITY.**

## Evidence deliberately UNKNOWN

For a generic machine: required guard strength/geometry, guard-lock holding force, measured stopping time, minimum distance, approach geometry, light-curtain resolution, scanner field, interlock PL/SIL allocation, reset location, escape requirements and permissible setup-mode behavior remain `UNKNOWN` until application evidence exists.

## Required next work

1. Build a safeguard-selection map that distinguishes fixed guards, interlocked movable guards, guard locking, presence sensing, two-hand controls and enabling/hold-to-run controls by physical proposition and lifecycle use.
2. Add a defeat/adversarial analysis for common interlock technologies, including simple mechanical targets versus coded/non-contact devices, while avoiding claims that coding makes defeat impossible.
3. Teach ISO 13855-style stopping-distance reasoning symbolically and with one explicitly sourced sample; do not reuse a sample as a machine-specific answer.
4. Trace the pass-through/inside-zone problem and reset visibility/presence-detection options.
5. Add two-hand anti-tie-down/concurrent-operation reasoning from authoritative documentation.
6. Preserve maintenance isolation as separate from production safeguarding.

## Source provenance

- Schmersal AZM400 current product documentation, surfaced 2026-09-23: separate interlocking and guard-locking functions, RFID/high coding, holding-force/application data.
- Schmersal *Safety in system* / ISO 14119 application material, surfaced 2026-09-23: stopping-time relationship to guard locking, application-specific holding-force determination, auxiliary/emergency release and emergency exit distinctions.
- SICK deTec2 Core operating instructions, 2023-03-22, surfaced 2026-09-23: ISO 13855 minimum-distance inputs and warning regarding reaching the hazard before the dangerous state ends.

Claims above are DOC-CONFIRMED where explicitly marked; proposition/failure decompositions are engineering INFERENCE grounded in those boundaries. No executable lab is justified yet.
