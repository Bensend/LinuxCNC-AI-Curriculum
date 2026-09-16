# Post-Maintenance Restoration / Proof-Test / Configuration-Change Validation

Session start: 2026-09-16T09:38:24Z

Status: active 4000 safety-course module

## Learning objective

Teach a fresh AI engineer to decide what maintenance or configuration changes invalidate previous safety evidence, what must be revalidated before production, and what a test actually proves. This module deliberately separates controller/configuration identity from field installation, final-element response, physical hazard reduction, personnel clearance, and production authorization.

## Evidence ledger

### DOC-CONFIRMED — configuration signatures identify configuration, not physical restoration

Rockwell Automation documents that each safety I/O device has a configuration signature identifying its configuration, and separately states that the signature is considered verified only after user testing. This supports using a signature as configuration-identity evidence, not as proof that field wiring, guards, contactors, valves, brakes, sensors, or other physical elements were restored correctly.

Sources:
- Rockwell Automation, *Safety I/O Device Signature*: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-device-signature.html
- Rockwell Automation, *Configuration Signature and Ownership*: https://www.rockwellautomation.com/en-tr/docs/technical/i-o/current/5034-pointmax/_online/5034-um002-ditamap/pointmax-safety-applications/use-safety-controllers/configuration-signature-ownership.html

### DOC-CONFIRMED — replacement requires functional testing of the replaced device/system

Rockwell's replacement procedures explicitly direct the user to follow prescribed procedures to functionally test the replaced safety I/O device and system and authorize it for use. The documentation also warns that, during replacement/functional testing, the safety of the system must not rely on the affected device where the referenced architecture says so.

Sources:
- Rockwell Automation, *Replace a Safety Module in a Logix 5000 System*: https://www.rockwellautomation.com/en-tr/docs/technical/i-o/current/5034-pointmax/_online/5034-um002-ditamap/pointmax-safety-applications/replace-safety-module/replace-safety-module-logix-5000-system.html
- Rockwell Automation, *Safety I/O Device Replacement*: https://www.rockwellautomation.com/en-ca/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-i-o/safety-i-o-device-replacement.html

### DOC-CONFIRMED — safety changes trigger retest/revalidation

Rockwell documents that deleting a safety signature to make safety-related changes impacts the safety functions and requires additional measures while the signature is absent; after changes, the system must be retested/revalidated at an appropriate level. This does not establish a universal test depth for every machine change; it establishes that configuration identity alone is insufficient after safety-related change.

Source:
- Rockwell Automation, *Generate the Safety Signature*: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-rm015/logix-sis-safety-reference-manual-ditamap/safety-applications/commissioning-lifecycle/generate-the-safety-signature.html

### DOC-CONFIRMED — validation includes implementation and functional behavior

Pilz describes machinery-safety validation as checking that protective measures are implemented correctly and the safety system is fully functional; its validation description includes safety-function testing and checking correct installation of safety functions/components, with deeper levels adding fault simulation. This supports a physical/function-oriented validation boundary rather than treating a software/configuration check as whole-machine proof.

Source:
- Pilz, *Safety validation for machinery safety*: https://www.pilz.com/en-US/services/machinery-safety/validation

## Core state model

Do not compress restoration into one `maintenance_complete` or `safe` bit. Track at least:

1. `work_scope_closed` — the maintenance task is administratively complete.
2. `temporary_bypass_removed` — temporary defeat/override means are accounted for and removed or returned to their engineered normal state.
3. `configuration_identity_known` — relevant controller/device configuration is identified.
4. `installation_restored` — wiring, devices, guards, plumbing/mechanical interfaces and final elements affected by the work are physically restored.
5. `functional_test_complete` — the affected safety function has been exercised through its relevant physical path.
6. `fault_detection_checked` — applicable diagnostics/fault reactions affected by the work have been challenged.
7. `residual_unknowns_bounded` — unverified machine-specific facts remain explicit.
8. `production_authorized` — a distinct decision after evidence review; it is not implied by any single preceding bit.

LinuxCNC/HAL and the ordinary OpenPressBrake FPGA may display, log, inhibit normal commands, and require ordinary rearm. They do not acquire personnel-safety authority merely because they can observe these states.

## Change-impact matrix

| Change | Prior evidence status | Minimum reasoning before reuse |
|---|---|---|
| Safety-controller logic/config changed | INVALID for affected functions until bounded retest/revalidation | Identify changed logic/data/I/O configuration; determine affected functions; retest affected paths and interactions. Do not infer universal test depth without the governing design/standard. |
| Safety I/O device replaced | REVIEW/INVALID for affected path | Verify identity/configuration plus field connection and functional response of the replaced device/system. |
| Guard switch/light curtain/scanner replaced or repositioned | INVALID for affected protective function | Configuration match alone cannot prove mounting, alignment, coverage, blind spots, response, or required geometry. Revalidate the affected physical protective function; machine-specific distances remain UNKNOWN until established. |
| Contactor/valve/brake/final element replaced | INVALID for affected hazard-interruption path | Exercise demand through the real final element and verify relevant feedback/fault detection. Command echo is insufficient. |
| Field wiring repaired/rerouted | REVIEW/INVALID for affected channels | Verify wiring and channel behavior including plausible cross-channel/open/short faults where applicable to the design. |
| Temporary bypass/jumper removed | INVALID until restoration is demonstrated | Visual removal alone is not enough when wiring/configuration or another defeat path could remain. Exercise the restored safeguard and its fault response. |
| HMI/LinuxCNC display-only change | MAY remain valid if genuinely outside safety function | Prove that the change did not alter safety authority, wiring, configuration, command paths, reset/rearm behavior, or evidence presentation relied upon for validation. |
| Ordinary FPGA firmware changed | REVIEW even when FPGA is non-safety authority | Recheck the boundary: stale/erroneous normal commands must not defeat independent safety. Any changed interface relied on by safety diagnostics requires affected evidence review. |
| Documentation/label only | MAY remain valid | Confirm no physical/configuration change was hidden inside the documentation task. |

`INVALID` here means previous evidence cannot be reused as proof for the affected claim without new validation; it does not mean the machine is necessarily physically unsafe.

## Proof-test ladder: what evidence actually proves

A valid restoration test should climb only as high as its observer supports:

- **Command/request observed**: proves the command path produced a request; does not prove an output changed.
- **Controller I/O state observed**: proves controller-visible state; does not prove field wiring/final-element motion.
- **Electrical final-element feedback (for example appropriately specified EDM/mirror feedback)**: can support the bounded state of the monitored switching element; does not prove all hazardous energy is gone.
- **Independent physical witness**: motion, pressure, current, position, speed, etc. can support the specific measured physical claim when the sensor/instrument and measurement are suitable; it does not automatically prove personnel clearance or complete machine safety.
- **Protective-function challenge through the complete path**: strongest functional evidence when the initiating device, safety logic, output path, final element, diagnostics and reset/restart behavior are exercised under the tested configuration.

Never promote an HMI screenshot, LinuxCNC pin, FPGA register, safety-controller tag, configuration signature, or command echo into proof of a physical state it does not independently observe.

## Restoration test pattern

For each affected safety function, record:

1. exact function and hazard bounded by the test;
2. exact maintenance/change that may have invalidated evidence;
3. configuration identity/version and physical configuration identity available;
4. pre-test safe condition and alternate protection used during testing;
5. initiating safety demand;
6. expected output/final-element response without inventing unsourced numerical limits;
7. independent witness(es) and what each actually proves;
8. diagnostic/fault challenge relevant to the changed elements;
9. reset/restart/rearm behavior, including no unintended restart after demand clear or power restoration;
10. bypass/temporary-means accounting;
11. result, evidence artifacts, provenance class and explicit UNKNOWNs;
12. authorization decision kept separate from test execution.

## Adversarial cases

### A — replacement module reports healthy immediately

A replacement safety I/O module accepts configuration and establishes communication. Reject the claim `replacement validated`. Configuration/connection evidence does not prove field installation or the complete protective function. Require the prescribed functional test of the affected device/system.

### B — same safety signature after maintenance

The signature matches the pre-maintenance record. A guard switch was physically replaced. Reject `no retest required`: signature identity does not prove mounting, actuator alignment, wiring or physical function.

### C — HMI E-stop lamp changes correctly

The learner presses E-stop and sees LinuxCNC/HMI state change. Reject `E-stop function passed` unless the required hazard-interruption path, final elements, feedback, reset/restart behavior and other design-specific requirements are actually evidenced.

### D — jumper visually removed

A technician photographs the removed jumper. Treat this as restoration evidence only for the narrow visual claim. Require a functional challenge of the restored safeguard before production authorization where that safeguard was affected.

### E — final element replaced, command echo passes

Reject. Command echo can coexist with a wiring fault, stuck/welded final element, incorrect replacement or mechanical/hydraulic failure. Require appropriate final-element/physical witness evidence.

### F — nuisance safeguard repaired

Do not stop at `works again`. Confirm the repair did not preserve the ergonomic/process defect that predictably caused bypass. Restoration should make correct safeguard use the easy normal path.

### G — machine-specific stopping time requested without measurement/design evidence

Record `UNKNOWN`. Do not invent a stopping time, protective distance, hydraulic decay time, pressure threshold, diagnostic coverage, PL/SIL or proof-test interval.

## Human-factors rule

Restoration paperwork that is so burdensome that technicians routinely pencil-whip it is itself a weak architecture. Make the required evidence path obvious and short: task-specific checklist, automatic capture of useful configuration identity/logs where available, clear physical witness points, conspicuous bypass accounting, and a small number of deliberate tests tied to the actual change. Do not reduce required evidence; remove pointless friction.

## Minimum safe-to-operate boundary

If maintenance has affected a personnel-protective function and the affected physical safety path cannot be shown restored to the required design state, do not operate with people exposed to that hazard. Experimental operation, if technically necessary for diagnosis, must use an isolated/remote arrangement with people outside the danger zone and residual risk stated plainly.

## Evaluation prompts

A learner passes this module only if it can:

- explain why a matching safety/configuration signature is not whole-machine validation;
- identify which prior evidence is invalidated by a described change;
- select an observer appropriate to the physical claim;
- separate test completion from production authorization;
- reject controller-state-only proof for physical hazard claims;
- preserve `UNKNOWN` for unsourced numerical/design-specific facts;
- propose a practical restoration process that discourages bypass and pencil-whipping;
- preserve the independent safety boundary around LinuxCNC and ordinary FPGA control.

## No-compute decision

No simulation/build/test-suite compute is justified for this module. The unresolved questions are evidence/validation-boundary questions adequately advanced by authoritative manufacturer documentation and engineering reasoning. A future lab should be frozen only for a concrete behavior not resolvable from those sources.

## Next work

Build a cross-machine **configuration/change invalidation worksheet** for press brake, mill, lathe, plasma table, robot and automated cell. It should force the learner to identify what changed, which safety claims/evidence are invalidated, which physical witness is required, and which facts remain machine-specific UNKNOWNs. Do not invent hydraulic truth tables, stopping distances, pressure thresholds or performance levels.