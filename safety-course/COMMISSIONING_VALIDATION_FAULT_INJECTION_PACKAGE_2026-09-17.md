# Commissioning / validation / fault-injection package — 2026-09-17

Session start UTC: `2026-09-17T01:35:30Z`

## Purpose

Convert the preceding safety architecture work into a bounded, inspectable commissioning method. This is a curriculum artifact, not a machine-specific validation certificate and not a substitute for the applicable machine risk assessment, product standard, required PLr/SIL determination, or competent-person validation.

## Evidence basis

### DOC-CONFIRMED — validation is lifecycle work, not a one-time green-light check

Pilz's current machinery-safety validation material states that validation checks whether protective measures were implemented correctly and whether the safety system is fully functional. Its detailed/comprehensive validation scope includes safety-function tests, checking correct installation of safety functions/components, checking specified PL implementation, and at the comprehensive level fault simulation plus review of safety requirements and safety-related software. Source: Pilz, *Safety validation for machinery safety*, accessed 2026-09-17: https://www.pilz.com/en-US/services/machinery-safety/validation

SICK's Safeguard Detector commissioning instructions require thorough validation before commissioning, after safety/configuration changes, after mounting/alignment/electrical changes, and after exceptional events including detected manipulation, machine modification, or component replacement. Source: SICK, *Safeguard Detector* operating instructions, 8019465, commissioning/validation section: https://www.sick.com/media/docs/8/88/588/operating_instructions_safeguard_detector_flexi_soft_variant_en_im0064588.pdf

### DOC-CONFIRMED — test plans need expected results and traceable records

Pilz's machinery safety compendium describes validation-by-testing as requiring test specifications, expected results, test chronology and traceable records, then comparison of observed results with the predefined specification. It also states that safety functions should be validated in all machine operating modes. Source: Pilz safety compendium, validation-by-testing section: https://www.pilz.com/mam/pilz/content/editors_mm/safety_compendium_en_2017_12_low.pdf

### DOC-CONFIRMED — reset is not start

SICK Flexi Soft documentation states that after a protective-device stop, the stopped state is maintained until reset; reset restores monitoring/restart readiness and must not itself initiate movement. A separate start command follows. Source: SICK, *Flexi Soft Modular Safety Controller*, 8012478: https://www.sick.com/media/docs/0/60/660/operating_instructions_flexi_soft_modular_safety_controller_hardware_en_im0031660.pdf

## Validation rule

For each safety function, prove the complete chain twice:

1. **Control trace:** initiating device -> safety logic -> safety output -> final element -> feedback/EDM -> restart interlock.
2. **Physical hazard trace:** energy source -> energy-controlling element -> actuator/load -> hazardous motion or other hazardous effect.

A software bit changing state is not sufficient proof of the physical hazard boundary.

## Required pre-test record

Before executing a test, record:

- safety function identifier and hazard controlled;
- applicable operating mode(s);
- initiating device(s);
- safety logic/channel path;
- physical final elements;
- feedback/EDM expected;
- energy sources that remain present;
- stored/gravity energy and required restraint;
- expected safe state;
- expected restart/reset/rearm behavior;
- measurement or observation method;
- pass/fail criterion derived from the machine safety requirements;
- test personnel and environmental/test conditions where relevant.

Do **not** invent stopping distance, pressure, safe speed, PL/SIL, diagnostic coverage, response time or other design-specific acceptance numbers. If the requirements specification does not supply a justified criterion, mark it `UNKNOWN / REQUIREMENT NEEDED` rather than manufacturing one.

## Commissioning sequence

### Stage A — de-energized inspection

Verify wiring against released drawings; device identity and contact/channel allocation; protective-device mounting; guard/interlock mechanical integrity; final-element feedback wiring; fuse/protection selection; grounding/bonding; hydraulic/pneumatic line identity; mechanical restraints; labels; and that temporary commissioning jumpers/forces are absent unless explicitly controlled by the current test step.

### Stage B — safety logic powered, hazardous actuator energy withheld where practical

Exercise E-stop, guard, light curtain/protective field, reset, mode selector and enabling controls while observing safety-controller diagnostics and final-element commands. Verify channel discrepancy/fault behavior without allowing hazardous motion where the test can be completed at this lower-energy boundary.

### Stage C — final-element proof

With an appropriately controlled test state, prove that contactors, STO interfaces, hydraulic/pneumatic safety elements, holding/braking devices and their feedback reach the expected state. Do not infer physical operation solely from controller LEDs or LinuxCNC/HAL signals.

### Stage D — bounded energized functional validation

Only after A-C are satisfactory, test each safety function in every applicable operating mode. Personnel must remain outside the danger zone unless the validated safety concept explicitly permits access under a safety-related setup function. If the machine cannot yet meet the minimum safe-to-operate threshold, energized experimental operation is isolated/remote with people outside the danger zone.

### Stage E — restart/restoration validation

For every relevant safety demand, prove that clearing the demand does not itself create hazardous motion. Exercise manual reset/restart interlock and then the separate normal START. Also exercise mains restoration, safety-24-V restoration, ordinary CNC/FPGA reboot while safety remains powered, and communications loss/recovery. No ordinary software/network recovery may silently manufacture personnel-safety permission.

### Stage F — return-to-service reconciliation

Reconcile temporary jumpers, lifted wires, test plugs, external supplies, forced I/O/HAL/PLC states, diagnostic FPGA/software, parameter changes, bypasses, mechanical blocks, removed guards, temporary hydraulic/pneumatic connections and service tooling. A successful functional test does not prove restoration completeness.

## Fault-injection matrix

Fault injection is question-driven and should first use the least hazardous method capable of answering the question.

| Fault / disturbance | Expected principle | Evidence to capture | Boundary |
|---|---|---|---|
| Open one channel of a dual-channel protective input | Safety function remains safe or detects discrepancy according to specified architecture | controller diagnostics, output state, final-element state, reset behavior | No invented diagnostic time |
| Simulate welded/stuck downstream contactor via EDM test method | Restart inhibited when commanded and feedback states disagree | output command, positively guided feedback/EDM, restart attempt | Do not physically defeat power contacts merely to create drama |
| Disconnect/withhold final-element feedback | Defined diagnostic/restart inhibition occurs | safety fault, EDM state, rearm requirements | Must match device/application documentation |
| Remove ordinary LinuxCNC/FPGA command while safety remains healthy | Normal control loses authority without being mistaken for safety reset | normal enable, safety-ready, actuator command | Demonstrates independence, not PL/SIL |
| Reboot LinuxCNC/FPGA | Reboot cannot automatically create personnel-safety permission or motion | safety state before/during/after, normal rearm/start | Network recovery included where applicable |
| Remove/restore safety-controller supply | Restoration follows specified cold-start/restart policy | final elements, feedback, reset/start requirements | Test only with hazardous energy controlled initially |
| Open guard / interrupt protective field in each applicable mode | Required safety function occurs for that mode | final elements and physical hazard response | Setup mode is tested separately, not treated as bypass |
| Hold reset or START device actuated through demand clearing/power restoration | No unintended restart if architecture requires a new deliberate action | reset/start edge behavior, outputs, motion | Tests anti-tie-down/restart assumptions where specified |
| Detect/manufacture a controlled safeguard manipulation condition supported by device test facilities | Manipulation response is visible and return-to-service validation is triggered | diagnostic, lockout/restart behavior, inspection record | Prefer vendor-supported test method |
| Remove mechanical/gravity restraint during controlled restoration sequence | The safety/holding function that takes over is already proved available | holding state, feedback, energy state | Never remove restraint merely to discover whether the ram/load falls |

## Adversarial review questions

Before release, answer from evidence:

1. What single ordinary LinuxCNC/HAL/FPGA failure could command motion, and which independent safety element still prevents exposure from becoming injury?
2. What happens if the safety output says OFF but a contactor or valve does not physically change state?
3. What proves the final element changed state?
4. Which hazards remain after E-stop: mains, DC bus, hydraulic pressure, gravity, pneumatics, thermal, tooling, stored electrical energy?
5. Can any reset, boot, network reconnect or power restoration create motion without a separate deliberate start where one is required?
6. Can setup/service mode be selected unintentionally, and is it a constrained safety mode rather than a guard bypass?
7. Can a worker remain hidden in the hazard zone when another person resets/restarts?
8. What temporary commissioning artifact could remain installed and silently weaken protection?
9. Which safety function has not been tested in every mode in which it is claimed to protect?
10. What acceptance criterion is still UNKNOWN because a machine-specific requirement or measurement is missing?

Any unanswered question capable of materially changing the safety conclusion remains an open validation item.

## LinuxCNC / OpenPressBrake boundary

- Ordinary LinuxCNC, HAL, realtime components, Ethernet communication and the normal FPGA controller may provide normal control, diagnostics, state display and requests.
- FPGA watchdog/current-loop trips remain useful fault containment, but are not promoted to personnel-safety authority without independent evidence of a safety-rated architecture.
- Personnel-safety demand processing, restart interlock and required safety-related final-element authority remain independent.
- Diagnostics should make bypasses and faults obvious, but diagnostic visibility is not a substitute for the independent physical safety function.

## Human-factors rule

Commissioning procedures must make the safer path easier than improvisation. Provide accessible test points/diagnostics, explicit test modes where justified, clear restoration checklists, obvious bypass indication and a short route back to normal guarding. If technicians routinely need to defeat a safeguard to perform a normal adjustment, treat that inconvenience as a design defect and redesign the task/safeguard interface where the risk assessment permits.

## Promotion / unknowns

- `UNKNOWN`: exact validation acceptance criteria for any specific OpenPressBrake machine until its risk assessment, safety requirements specification, hydraulic/electrical architecture and measured stopping/energy behavior exist.
- `UNKNOWN`: achieved PL/SIL and diagnostic coverage of any future OpenPressBrake safety implementation until component architecture/calculation and validation support it.
- `INFERENCE`: the staged low-energy-to-energized sequence reduces commissioning exposure and improves diagnostic isolation; it is an engineering synthesis from the cited lifecycle/validation principles, not a quoted universal standard sequence.

## Compute decision

No simulation/build/test compute is justified for this module. The present work is requirements/evidence/test-design work; executing synthetic software tests would not prove physical final-element or machine safety behavior. No GitHub-hosted runner or self-hosted runner was used.
