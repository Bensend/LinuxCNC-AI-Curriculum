# 25E0 — SICK/Pilz Muting and Override: Intentional Safety-Exception Boundary

Date: 2026-09-21
Status: authoritative manufacturer-document trace

## Question

What separates a professionally supported temporary safety exception from an ordinary PLC/LinuxCNC bypass, and what prevents that exception from silently becoming normal production behavior?

## Evidence

### SICK deTec4 — muting-dependent override

Source: SICK, `deTec4` operating instructions, document 8021645, 2025-03-27.
https://www.sick.com/media/docs/1/41/841/operating_instructions_detec4_safety_light_curtain_en_im0079841.pdf

`DOC-CONFIRMED`:

- `Override required` is not a general operator-selected bypass. It is entered only under defined state conditions: an error occurs / muting is deactivated or ended, at least one muting signal remains active, and the ESPE is interrupted by an object.
- The operator starts the integrated override using a control switch; the system then monitors override state.
- Override duration is bounded by total muting time.
- Consecutive override statuses are counted and limited; exceeding the permitted number drives the system to lockout and an error indication.
- The counter is reset only by defined lifecycle events such as an error-free muting cycle, system start, or muting reset, depending on configuration.

This is a state-machine exception with eligibility, operator action, monitoring, bounded duration, bounded repetition, and lockout. It is not equivalent to forcing the light-curtain input TRUE.

### SICK Flexi Compact — visual inspection and explicit override transition

Source: SICK, `Flexi Compact` operating instructions, document 8026634/8026636.
https://www.sick.com/media/docs/9/79/279/operating_instructions_8026634_en_im0096279.pdf

`DOC-CONFIRMED`:

- Override is restricted to recovery when no valid muting sequence exists while the protective equipment indicates a potentially dangerous state.
- SICK requires the hazardous area to have been visually inspected, nobody to be inside, and access to be prevented while override is used.
- `Override required` is itself derived from explicit muting/protective-device states.
- A valid override command requires a defined 0-1-0 transition; out-of-window pulses are ignored.
- After the material/protective-device state returns to normal, the controller expects the next valid muting cycle rather than converting override into an indefinite production permissive.
- The number of override cycles is limited.

### Pilz PSEN opII4H — override does not command motion

Source: Pilz, `PSEN opII4H Series Operating Manual`, 1003501-EN-12, section 19.2.7.
https://www.pilz.com/download/open/PSEN_opII4H_Operat_Man_1003501-EN-12.pdf

`DOC-CONFIRMED`:

- Override is for manually clearing material after a muting error and is generally available only when at least one muting sensor has triggered and the protected field is blocked.
- **Activating override must not initiate motion. A separate control device must initiate motion.**
- Where the relevant area is visible, the documented startup patterns use hold-to-run or a bounded-time deliberate command subject to the application risk assessment.
- Where the danger zone is not directly visible from the normal location, the manual specifies additional restrictions including a spring-return key/equivalent secure control, visibility/inspection requirements, preventing access during override, and availability of emergency stop from the override location.
- Muting-dependent override ends automatically when documented exit conditions occur, including restoration of muting/protected-field state, expiry of a preset limit, release of hold-to-run, or detection of interlock state.

### Pilz muting overview — automatic material discrimination

Source: Pilz, `Muting: a simple explanation`.
https://www.pilz.com/en-INT/lexicon/muting

`DOC-CONFIRMED`:

- Muting is described as safe, automatic and temporary suspension of electro-sensitive protective equipment for a legitimate material-flow task.
- Muting sensors are arranged so that material initiates the muting sequence while a person should not be able to activate the muting sensors; sequential/cross arrangements impose sequence or concurrence semantics.
- The muting cycle is externally indicated in Pilz's illustrated pattern and normal protective operation resumes at cycle completion.

## Engineering interpretation

`INFERENCE`, bounded by the manufacturer evidence above:

A legitimate safety exception has **typed authority and lifecycle**. The exception does not erase the safety function; it defines a narrow alternate safety strategy for a specific process/recovery state.

Reusable structure:

`validated exceptional condition -> safety-rated eligibility logic -> conspicuous exceptional state -> deliberate operator/automatic sequence -> separately authorized process motion where required -> bounded time/sequence/repetition -> monitored exit/fault -> restoration of normal protective function`

An ordinary PLC/LinuxCNC bypass such as `light_curtain_ok = TRUE`, an HMI checkbox that masks a trip, or a HAL substitution lacks that evidence merely because it produces similar normal-control behavior.

## Frozen distinctions

- **MUTING != GENERIC BYPASS.** Muting is an automatic, temporary, condition-qualified safety function for a defined process task.
- **OVERRIDE ELIGIBLE != OVERRIDE ACTIVE.** Eligibility is derived from defined fault/material/protective-device conditions; deliberate action is still required.
- **OVERRIDE ACTIVE != MOTION COMMAND.** Pilz explicitly requires separate motion initiation.
- **SAFETY EXCEPTION ACTIVE != NORMAL PRODUCTION MODE.** Time/sequence/repetition monitoring and return conditions prevent indefinite inheritance.
- **MUTING SENSOR TRUE != PERSONNEL ABSENT.** Sensor arrangement/sequence is part of the safety concept; it must not be casually projected into a generic presence claim.
- **RESET/CLEAR != NEW MUTING CYCLE.** Recovery from a jam/override does not authorize arbitrary subsequent passage; the next cycle must again satisfy its normal conditions.
- **ORDINARY PLC/LINUXCNC LOGIC != SAFETY-RATED MUTING/OVERRIDE AUTHORITY** without design-specific evidence establishing the required safety integrity, diagnostics, independence, validation, and failure behavior.

## Human-factors result

This is a useful counterexample to the false choice between `never bypass anything` and `technician installs a jumper`. A foreseeable jam/recovery task is given a supported path with explicit eligibility, deliberate controls, bounded persistence, visibility/inspection requirements, separate motion command, and automatic return/lockout behavior. Making that supported path usable reduces the incentive to defeat the protective device permanently.

For LinuxCNC/OpenPressBrake teaching, normal control may display the exceptional state, guide recovery, cancel stale ordinary commands, and refuse normal automatic sequencing until the independent safety system reports the appropriate state. It must not silently become the personnel-safety authority merely because implementing the UI/sequence there is convenient.

## UNKNOWN / do not generalize

- Do not copy SICK/Pilz numeric times, override counts, sensor geometry, PL/SIL claims, or sequence windows into another machine without the applicable device/application design and validation.
- The cited muting examples are material-flow/light-curtain applications. They do not establish a press-brake hydraulic override architecture.
- They do not establish a universal rule for held LinuxCNC Start/Jog/Cycle inputs across exceptional-state exit.
- They do not prove that every machine requires a muting lamp; indication requirements are application/standard dependent.

## Curriculum consequence

The production-return checklist should treat supported exceptional modes as first-class states that must be positively exited and physically revalidated where they temporarily substitute for normal protection. The learner should ask not only `is the bypass gone?` but `what alternate safety strategy was active, what physical proposition did it rely on, what ended it, and what proves normal protection is authoritative again?`