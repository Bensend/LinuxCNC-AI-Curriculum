# Safety-Function Proof-of-Restoration Matrix

Date: 2026-09-15
Status: safety-course architecture / evidence contract

## Purpose

A machine becoming powered, a controller reporting healthy, a safety input changing state, and a safety function being proven restored are not the same event. This worksheet prevents a maintenance, bypass, fault-recovery, or re-energization sequence from collapsing those distinct facts into one `READY` bit.

This is machine-agnostic curriculum material. It does not claim a safety category, PL, SIL, stopping distance, hydraulic truth table, or machine-specific safe pressure.

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by an authoritative source.
- **DOC-CONFIRMED** — supported by project/manufacturer documentation but not independently tested here.
- **TEST-CONFIRMED** — demonstrated by a defined test with retained evidence.
- **COMMUNITY-REPORTED** — reported by practitioners; not sufficient alone for a safety claim.
- **INFERENCE** — engineering conclusion derived from identified evidence.
- **UNKNOWN** — unresolved; must not be promoted to safe/ready by software convenience.

## Source basis

### OSHA 29 CFR 1910.147

**SOURCE-CONFIRMED:** hazardous-energy control requires specific procedures for shutdown, isolation, blocking/securing, and testing to determine and verify effectiveness of energy-control measures. Stored/residual energy must be relieved, disconnected, restrained, or otherwise rendered safe; if it can reaccumulate, verification must continue. Before work begins, an authorized employee must verify isolation and de-energization. Before release from lockout/tagout, the work area must be inspected, employees safely positioned/removed, and the lock/tag removal process completed before startup. Source: OSHA 29 CFR 1910.147(c)(4)(ii)(D), (d)(5), (d)(6), (e).

### OSHA Appendix A

**SOURCE-CONFIRMED:** a typical minimum procedure verifies isolation by attempting normal controls or otherwise testing that equipment will not operate, then returns operating controls to neutral/off. Restoration includes checking components/area, personnel position, controls neutral, lock removal/re-energization, and notification. Source: OSHA 29 CFR 1910.147 Appendix A.

## Core rule

**No single software-visible bit is proof that a safety function has been restored.**

A restoration decision must state what function is being restored, what evidence is required for that function, who/what is authoritative for each item, and what remains UNKNOWN.

LinuxCNC, an HMI, network service, ordinary PLC logic, or the normal FPGA may display or consume safety status and may impose stricter normal-control inhibition. They must not manufacture independent safety permission from their own command state.

## Evidence classes

| Evidence class | What it proves | What it does NOT prove |
|---|---|---|
| Commanded state | A command/request was issued | Device moved, contacts changed, pressure disappeared, hazard is controlled |
| Diagnostic indication | A diagnostic channel reports a state | Physical state unless the diagnostic architecture independently establishes it |
| Independent feedback | A separate feedback path agrees with expected state | All hazards are controlled; feedback itself still has defined failure modes |
| Physical inspection | Observable mechanical/electrical condition is correct | Hidden energy/state not covered by the inspection |
| Functional test | Defined behavior occurs under a controlled test | Conditions outside test scope; maintenance isolation unless explicitly verified |
| Energy-isolation verification | Identified hazardous energy source is isolated/de-energized | Other energy sources not included in the verification |
| Reset acknowledgment | Reset conditions were accepted | Permission to start or proof of restored physical protection |
| Normal-control rearm | Ordinary controller is permitted to resume command generation | Independent safety function is healthy or authorized |

## Restoration matrix template

Complete one row per safety-related function or protective layer affected by the intervention.

| Function / layer | Safe intent | Intervention that disturbed confidence | Commanded state required? | Diagnostic indication required? | Independent feedback required? | Physical inspection / energy verification required? | Functional test required? | Evidence owner | UNKNOWN blocks production rearm? | Retained evidence |
|---|---|---|---|---|---|---|---|---|---|---|
| Emergency-stop chain | Defined hazardous motion/energy response when actuated | wiring/device replacement, bypass, safety relay work | machine-specific | machine-specific | machine-specific | inspect affected device/wiring as applicable | yes, defined validation after intervention | safety system / qualified validation | YES | test record |
| Guard/interlock protective function | hazard prevented while protective condition is violated | switch/guard work, bypass, alignment | machine-specific | machine-specific | machine-specific | inspect guard/device installation | yes | safety system / qualified validation | YES | test record |
| Final switching/output removal path | remove safety-related actuator authority as designed | contactor/valve/safety-output work | machine-specific | machine-specific | feedback where design requires | inspect affected final element; verify energy state where servicing requires | yes | independent safety architecture | YES | test record |
| Hazardous-energy isolation for servicing | prevent unexpected energization/start/release of stored energy | any servicing under LOTO | isolation device state | indication alone insufficient | as procedure defines | **required verification of isolation/de-energization; stored energy addressed** | attempt/test per procedure | authorized employee / energy-control procedure | YES | LOTO/verification record |
| Ordinary FPGA watchdog | inhibit stale ordinary actuator commands | firmware/network/controller fault | LOW/inhibit | watchdog status useful | output-state feedback useful | not a substitute for physical isolation | defined watchdog/rearm test | ordinary control | YES for normal rearm; NOT safety authority | test/log |
| LinuxCNC machine-enable state | normal software control enabled | software restart/reconnect | explicit enable | software state | field feedback where useful | no safety proof by itself | normal-control test | LinuxCNC | YES for software operation only | log/test |

The first three rows are deliberately machine-specific. Their exact required channels, test procedures, and acceptance criteria must come from the actual safety design, risk assessment, device documentation, and validation plan. `machine-specific` is not permission to guess.

## Restoration state model

Use explicit states rather than a single READY flag:

1. `INTERVENTION_ACTIVE`
2. `INTERVENTION_COMPLETE_UNVERIFIED`
3. `PHYSICAL_RESTORATION_CHECK`
4. `SAFETY_FUNCTION_VALIDATION_PENDING`
5. `SAFETY_FUNCTION_VALIDATED`
6. `NORMAL_CONTROL_REARM_PENDING`
7. `PRODUCTION_READY`
8. `FAULT_UNKNOWN`

### Required transitions

- Completing maintenance does not jump directly to `PRODUCTION_READY`.
- Re-energizing does not prove `SAFETY_FUNCTION_VALIDATED`.
- A safety reset does not prove `NORMAL_CONTROL_REARM_PENDING` has completed.
- LinuxCNC reconnect or FPGA reboot does not restore a bypassed or physically disturbed protective function.
- Any required evidence becoming stale, contradictory, or UNKNOWN moves the affected restoration claim to `FAULT_UNKNOWN` or an explicitly non-ready state.
- Re-arm must start ordinary command generation from a defined benign state; stale motion/valve commands must not be replayed merely because communications or power returned.

## Proof hierarchy

For each function, ask in order:

1. **What physical hazard is this function intended to control?**
2. **What was disturbed?** A wire, guard, valve, contactor, relay, sensor, safety controller, configuration, software-only component, energy-isolating device, etc.
3. **Which evidence can actually detect an incorrect restoration of that disturbed item?**
4. **Is the evidence independent enough for the claim being made?** A command echoed back by the same software is not independent physical feedback.
5. **Does a defined test exercise the failure direction?** A lamp showing green is weaker than a test that deliberately violates the protective condition and confirms the intended response.
6. **Does servicing require hazardous-energy verification separately?** Functional safety behavior is not a replacement for LOTO where LOTO applies.
7. **What evidence is retained?** Date, intervention, tester/authorized role, function tested, result, unresolved limitations.

## Human-factors rules

- The UI should say **what is not proven**, not merely `NOT READY`.
- A maintenance screen should make the required restoration evidence easier to complete than to bypass.
- Do not hide active bypass/override state behind a diagnostics submenu.
- Do not allow production mode to silently clear restoration requirements.
- Power cycling must not convert an unresolved restoration state into a clean state merely because volatile flags disappeared.
- If an intervention changes the hazard boundary or protective-device geometry, previous validation evidence is not automatically reusable.

## Safety Sandbox acceptance cases

### RST-01 — Command echo masquerades as feedback
Controller commands a final element OFF and reads its own command register back as OFF.

**Expected:** command echo is not accepted as independent feedback; restoration remains unproven where feedback is required.

### RST-02 — Green HMI after reboot
HMI/controller reboots with all software diagnostics green, but a physical protective device was left bypassed before power loss.

**Expected:** reboot cannot clear restoration/bypass evidence requirements; production rearm remains blocked.

### RST-03 — Functional safety restored, LOTO verification missing
A protective device passes a functional test, but servicing energy-isolation verification is incomplete.

**Expected:** the functional test does not substitute for hazardous-energy verification; servicing state remains unsafe/unverified.

### RST-04 — Isolation verified, protective function not revalidated
Energy isolation was correctly verified during maintenance and locks are removed under procedure, but a disturbed interlock has not been functionally validated.

**Expected:** energy restoration may follow the authorized procedure, but production-ready claim remains blocked pending protective-function validation.

### RST-05 — Contradictory feedback
Commanded safe state and one diagnostic agree, but independent final-element feedback disagrees.

**Expected:** `FAULT_UNKNOWN`; no production rearm.

### RST-06 — Stale command replay
Network/FPGA recovers after restoration and the last pre-fault actuator command is still buffered.

**Expected:** ordinary output authority remains inhibited until explicit rearm; stale command/integrator state is discarded or reinitialized to the defined benign state.

### RST-07 — Reset held during restoration
Reset input is held while a protective condition transitions back to healthy.

**Expected:** no automatic transition to production-ready solely from held reset; reset/restart semantics remain explicit and architecture-specific.

### RST-08 — Changed protective geometry
A guard/interlock mounting position changes during repair, while electrical diagnostics remain healthy.

**Expected:** prior validation is insufficient for the changed geometry; physical inspection and defined validation are required before production-ready status.

### RST-09 — Unknown treated as false
A feedback channel is unavailable and software maps missing data to `false`, then a higher layer interprets the aggregate as harmless.

**Expected:** missing required evidence remains explicit UNKNOWN and blocks the restoration claim.

### RST-10 — Ordinary watchdog passes
FPGA watchdog and LinuxCNC command freshness tests pass after maintenance.

**Expected:** this proves only ordinary control fault-containment behavior. It cannot by itself validate E-stop, guard, final switching, or physical energy isolation.

## Curriculum completion criterion for this artifact

A learner/agent should be able to inspect a proposed `machine_ready` or `safety_ok` signal and decompose it into the separate claims required to justify it. It should reject architectures where command state, diagnostic state, physical state, hazardous-energy isolation, safety reset, and ordinary controller rearm are silently collapsed together.

## Next independent work

Build a **commissioning / periodic-validation evidence worksheet** that turns each safety function into a repeatable test record: prerequisite state, deliberate stimulus, expected safe response, independent observation, fault-injection cases where appropriate, restoration/restart behavior, evidence provenance, and retest triggers after hardware/configuration changes. Keep machine-specific acceptance numbers unresolved until authoritative design data exists.
