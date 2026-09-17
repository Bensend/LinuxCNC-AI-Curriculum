# Safety Claim Evidence Sufficiency Ladder

Status: WORKING SAFETY-COURSE ARTIFACT
Date: 2026-09-17
Lane: independent safety curriculum lane B

## Purpose

Safety work fails when evidence from one layer is silently promoted into a stronger claim. A green HMI bit, an output commanded OFF, a contactor auxiliary contact, a pressure gauge, and proof that hazardous motion is controlled are useful observations, but they are not interchangeable.

This guide creates a **claim-to-evidence ladder** for LinuxCNC/OpenPressBrake and other machines. It is intended for design reviews, commissioning, troubleshooting, maintenance and curriculum exercises. It does not assign PL/SIL/category, stopping distance, safe speed, hydraulic pressure threshold or a machine-specific valve truth table.

## Frozen rule

> Evidence is sufficient only for the claim it actually observes. Never promote controller intent, diagnostic state, or one intermediate witness into proof of the complete personnel-safety function without tracing the remaining dependencies to the physical hazard boundary.

## Provenance vocabulary

Use these labels without substitution:

- `SOURCE-CONFIRMED` — authoritative public source directly supports the statement.
- `DOC-CONFIRMED` — controlled machine/project documentation directly supports it.
- `TEST-CONFIRMED` — a defined test produced retained evidence for the specific configuration tested.
- `COMMUNITY-REPORTED` — public community report; useful lead, not authoritative proof.
- `INFERENCE` — engineering conclusion from identified premises; premises and limits must be visible.
- `UNKNOWN` — evidence is absent, contradictory, inaccessible, or insufficient for the claim.

A claim can have multiple labels at different layers. `TEST-CONFIRMED` does not erase an unresolved design/documentation `UNKNOWN` outside the tested condition.

## The evidence ladder

### L0 — command / software intent

Examples:
- LinuxCNC requests output OFF;
- FPGA writes zero command;
- safety PLC program logic evaluates a demand;
- HMI says `SAFE`, `READY`, or `ESTOP`.

This proves only the observed software/controller state. It does **not** prove output electronics, wiring, contactors, STO, valves, brakes, pressure, or motion reached a safe physical state.

### L1 — safety/control output state

Examples:
- safety relay output is deenergized;
- OSSD output is OFF;
- STO command terminals are in the demanded electrical state;
- contactor coil command is removed.

This is stronger than software intent, but it still does not prove the downstream final element responded.

### L2 — downstream final-element witness

Examples:
- positively guided contactor auxiliary contacts are in the expected state;
- drive safety status reports the expected state where the manufacturer's architecture permits that witness;
- valve spool/position switch or independent pressure witness changes as designed;
- mechanical brake state is independently sensed.

This can prove a specific final-element state to the capability and diagnostic coverage of the witness. It does not automatically prove every hazardous-energy path is controlled.

### L3 — energy-path witness

Examples:
- verified electrical isolation/deenergization for the work boundary;
- measured pressure decay or isolation at the relevant hydraulic/pneumatic boundary;
- verified DC-bus state where required by the task;
- gravity-loaded member is physically blocked/restrained;
- process energy such as laser emission, arc/high voltage or stored pneumatic energy is separately controlled.

The witness must correspond to the actual energy path. A motion command of zero is not a hydraulic-isolation witness; STO is not electrical LOTO; pump contactor dropout does not by itself prove stored accumulator energy is harmless.

### L4 — hazardous-effect / physical safety-function response

Examples:
- a protective-device demand causes the intended hazardous motion/process to cease or be prevented through the designed path;
- a deliberate EDM fault prevents restart;
- a guard demand prevents hazardous operation while the guard is open;
- a safe-motion function performs the manufacturer/design-defined response and reaches the required final state.

This is the first layer that addresses the end-to-end physical safety-function claim, but the test is valid only for the tested conditions and configuration.

### L5 — fault-path / diagnostic challenge

Challenge credible failures that the architecture claims to detect or tolerate, such as:
- welded/stuck contactor represented through the approved test method;
- channel discrepancy;
- open/short/cross-fault where the device architecture claims detection;
- lost feedback;
- failed reset/restart-interlock sequence;
- ordinary LinuxCNC/FPGA reboot or network recovery while the safety demand remains active.

Do not inject a fault merely because it is easy. The question is: **what claimed safety dependency remains unproven without this challenge?**

### L6 — configuration/change validity

End-to-end evidence is not portable across arbitrary changes. Bind it to:
- machine identity;
- safety-controller/device identity and configuration;
- firmware where relevant;
- wiring revision;
- protective-device geometry/alignment/configuration;
- drive safety parameters;
- hydraulic/pneumatic final-element identity/configuration;
- calibration/teach data where relevant;
- test equipment/fixture identity and calibration where applicable.

A previously passing test may become `NOT APPLICABLE TO CURRENT CONFIGURATION` after a dependency changes even if the old result remains historically true.

## Claim/evidence matrix

| Claim being made | Minimum direct evidence needed | Evidence that is useful but insufficient by itself |
|---|---|---|
| LinuxCNC commanded zero | LinuxCNC/HAL trace of command | HMI icon alone |
| Safety output dropped | direct device/output evidence appropriate to design | LinuxCNC request |
| Contactor actually dropped | appropriate auxiliary/EDM or direct inspection/test evidence | coil command OFF |
| Drive torque-production authority removed as designed | manufacturer-defined STO/safe-function evidence plus required downstream validation | ordinary drive enable bit OFF |
| Hydraulic hazardous energy controlled | machine-specific hydraulic design evidence plus physical witness at relevant boundary | pump command OFF; generic valve assumption |
| Gravity hazard controlled | physical restraint/brake/holding architecture and applicable witness | axis command zero |
| E-stop function works end-to-end | physical demand through independent safety path to intended final elements/hazard response, including required reset/restart behavior | HMI ESTOP bit; LinuxCNC disabled |
| Guard/protective-device function works | physical demand at relevant access path, final-element/hazard response and restart-interlock behavior as designed | sensor LED or safety input bit |
| EDM detects failed final element | defined fault challenge or authoritative validated test showing restart is blocked | EDM input healthy during normal operation |
| Machine safe for exposed maintenance | task-specific hazardous-energy isolation/control and verification | E-stop pressed; STO active; LinuxCNC Machine-Off |
| Machine ready for production after safety-relevant repair | restoration sweep + change-impact revalidation + required physical safety-function challenges | repair completed; diagnostics green |

## SOURCE-CONFIRMED anchors

### OSHA 29 CFR 1910.147

Official source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

- 1910.147(d)(3) requires needed energy-isolating devices to physically isolate the machine/equipment from energy sources.
- 1910.147(d)(5) requires potentially hazardous stored/residual energy to be relieved, disconnected, restrained or otherwise rendered safe; verification must continue where hazardous reaccumulation is possible.
- 1910.147(d)(6) requires authorized employees to verify isolation and deenergization before servicing begins.
- 1910.147(e) separately governs restoration/release before energy is restored.

**Boundary:** these requirements establish hazardous-energy-control obligations; they do not by themselves define a machine's functional-safety architecture or prove a specific safety function's PL/SIL/category.

### OSHA Appendix A — typical minimal LOTO procedure

Official source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147AppA

Appendix A gives practical examples of verifying isolation by attempting normal controls or testing, and explicitly lists stored-energy examples including springs, elevated members, flywheels, hydraulic systems and pressure. This reinforces that verification must correspond to the physical hazard, not merely controller state.

### SICK deTec4 Core — restart interlock and EDM

Manufacturer source: https://www.sick.com/media/docs/1/11/011/operating_instructions_detec4_core_en_im0048011.pdf

The deTec4 Core instructions distinguish restart interlock from machine restart and describe EDM as monitoring downstream contactor status. Positively guided contactors are a prerequisite in the cited EDM application. This is concrete manufacturer evidence that `protective field clear`, `reset/restart-interlock released`, and `downstream contactor proven` are different claims.

**Boundary:** this is evidence for the cited SICK architecture, not a universal wiring diagram for every light curtain or machine.

## LinuxCNC/OpenPressBrake authority boundary

Ordinary LinuxCNC/HAL/FPGA is valuable for diagnostics, sequencing and normal actuator authority. It may record:
- safety-ready input;
- final-element feedback made available for diagnostics;
- normal command state;
- watchdog/rearm state;
- event timing and recorder evidence.

It must not be promoted into independent personnel-safety authority merely because its diagnostics correlate with a safety response. A LinuxCNC or FPGA trace is normally L0/L1 evidence about ordinary control unless the actual independent safety architecture explicitly gives that signal a stronger, validated role.

## Press-brake application prompts

For a press brake, keep these claims separate until actual drawings/measurements close them:

1. proportional valve command is zero;
2. ordinary directional command is removed;
3. independent safety output demanded safe state;
4. hydraulic safety/holding final element changed state;
5. relevant pressure/energy path is controlled;
6. gravity/ram descent hazard is controlled;
7. Y1/Y2 hazardous motion is prevented/controlled as designed;
8. reset/restart cannot silently re-enable hazardous motion.

Do **not** infer steps 4–7 from steps 1–3. The exact valve truth table, pressure behavior, stopping distance and holding performance remain `UNKNOWN` until machine-specific evidence exists.

## Practical review procedure

For each safety claim:

1. Write the claim in physical terms: `what hazard is controlled, where, and under what demand?`
2. Identify the final element(s) and every relevant energy path.
3. Mark the strongest evidence layer actually observed.
4. Record provenance classification for each observation.
5. Identify the next unobserved dependency between that evidence and the physical hazard boundary.
6. Ask whether a credible single/common failure can invalidate the witness.
7. Define the smallest question-driven physical test or document trace that closes the gap.
8. If evidence is unavailable, retain `UNKNOWN`; do not downgrade the wording until it sounds true.

## Anti-patterns

Reject these statements unless stronger evidence is supplied:

- `The HMI says safe, therefore the machine is safe.`
- `LinuxCNC is disabled, therefore hazardous energy is isolated.`
- `STO is active, therefore electrical maintenance is safe.`
- `The pump is off, therefore the ram cannot move.`
- `The valve is deenergized, therefore its safe hydraulic state is known.`
- `EDM is healthy, therefore every hazardous-energy path is proven.`
- `The E-stop passed once, therefore all foreseeable fault paths are validated.`
- `The same software is loaded, therefore previous validation still applies after hardware/wiring changes.`

## Adversarial exercises

1. E-stop input is active, LinuxCNC Machine-On is false, and the safety relay outputs are OFF. What evidence layers are present and what physical claims remain open?
2. Both contactor EDM contacts report dropped, but a gravity-loaded vertical axis can still descend mechanically. What did EDM prove and what did it not prove?
3. A press brake pump contactor drops and a gauge near the pump reads zero, but an accumulator branch has not been traced. Can the hydraulic hazard be called controlled?
4. A light curtain clears, reset is pressed, and the machine immediately cycles without a separate start. Which restart claim needs design review?
5. A safety function passed last month, but a drive was replaced and its safety parameters restored from an unverified backup. Which evidence survives historically and which current claim becomes `UNKNOWN` pending revalidation?
6. A HAL recorder shows a perfect 20 ms response. Why is this not a stopping-distance measurement or proof of the physical safety response?

## Durable next-work checkpoint

Next independent Lane-B work: build `SAFETY_TEST_WITNESS_INDEPENDENCE_COMMON_CAUSE_REVIEW.md` focused on **whether the evidence channel can fail for the same reason as the safety path it is supposed to prove**. Cover shared power supplies, shared PLC/FPGA variables, common sensors, copied software state, common network links, contactor auxiliary-contact limitations, pressure-sensor placement, fixture-induced common cause, and when a physically independent witness is warranted. Keep it separate from the primary lane's professional-machine wiring/return-to-service work and do not invent machine-specific diagnostic coverage.