# Safety Periodic Inspection and Latent-Failure Discovery Plan

Date: 2026-09-17

## Purpose

Provide a practical architecture for periodically challenging safety functions whose dangerous failures can remain hidden during ordinary production.

Core rule:

> **Normal production without an accident is not proof that a dormant safety path will work when demanded.**

This plan does not prescribe universal inspection intervals, PL/SIL/DC values, stopping distances, pressure limits, or proof-test periods. Those remain machine-, component-, risk-, manufacturer-, and jurisdiction-specific.

## Evidence labels

Every result must retain one of the curriculum provenance labels:

- `SOURCE-CONFIRMED` — authoritative source or standard-derived requirement.
- `DOC-CONFIRMED` — machine drawing/manual/configuration record confirms the implementation.
- `TEST-CONFIRMED` — bounded physical challenge observed the claimed behavior.
- `COMMUNITY-REPORTED` — useful field experience, not design proof.
- `INFERENCE` — engineering conclusion that still requires appropriate confirmation.
- `UNKNOWN` — evidence is absent, conflicting, stale, or insufficient.

Do not silently promote an inference, software state, or diagnostic indication to physical proof.

## 1. Why periodic challenge exists

Some failures announce themselves immediately. Others can remain latent until the safety function is demanded. Examples include:

- one channel of a redundant protective input open/shorted while the other channel still permits operation;
- welded/stuck final contactor with misleading or incorrectly wired feedback;
- safety valve that commands correctly but no longer reaches the required physical state;
- guard switch actuator defeated or mechanically misaligned;
- reset circuit stuck or bridged so a deliberate manual reset is no longer required;
- STO channel/configuration mismatch hidden by ordinary drive disable;
- accumulator isolation/discharge hardware that is never challenged in normal production;
- mechanical block/restraint unavailable, damaged, or incapable of being installed as documented;
- safety-controller diagnostic path lost while ordinary HMI continues to display an old healthy state;
- firmware/configuration drift that leaves the project internally valid but mismatched to field hardware.

`INFERENCE`: a useful periodic-inspection program is therefore organized by **safety claim and hidden failure mode**, not merely by a calendar checklist of components.

## 2. Separate the evidence layers

For each safety function, record evidence separately for:

1. protective demand/input;
2. safety logic decision;
3. safety output state;
4. final-element feedback/EDM;
5. actual energy-path effect;
6. physical hazardous-effect response;
7. reset/restart/rearm behavior;
8. fault detection and lockout behavior.

A test that reaches only layer 2 or 3 does not automatically prove layers 4–6.

LinuxCNC, HAL, FPGA status, ordinary drive-enable state, or HMI indication may provide useful context but must not be the sole witness for an independent personnel-safety claim.

## 3. Safety-function inspection register

Create one row for every credited safety function.

| Safety function | Hazard controlled | Demand source | Independent safety authority | Final element(s) | Physical witness | Hidden failures to challenge | Manufacturer/standard interval basis | Machine-specific interval | Last valid result | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| E-stop | | | | | | | | | | |
| Guard/interlock | | | | | | | | | | |
| Protective device | | | | | | | | | | |
| STO / drive safety | | | | | | | | | | |
| Hydraulic safety stop/isolation | | | | | | | | | | |
| Stored-energy discharge/restraint | | | | | | | | | | |
| Reset/restart interlock | | | | | | | | | | |
| Setup/service-mode safeguard | | | | | | | | | | |

Do not populate an interval by habit. If no defensible basis is available, mark it `UNKNOWN` and create a documentation/risk-assessment task.

## 4. Challenge design

For each function write a question-driven challenge:

**Claim:** what exact safety behavior is credited?

**Hidden failure:** what dangerous condition could ordinary production fail to reveal?

**Stimulus:** what bounded action exposes that condition?

**Independent witness:** what observation proves the physical response rather than merely the command?

**Expected fault behavior:** should the system refuse reset/rearm, latch a fault, report discrepancy, or otherwise prevent hazardous operation?

**Restoration:** what must be restored/reconciled after the challenge?

**Evidence:** who observed it, with what configuration identity, and where is the result recorded?

Do not run a challenge that requires exposing a person to the hazard. Use isolation, blocking/restraint, reduced/bounded energy, remote observation, or another defensible test arrangement appropriate to the machine.

## 5. High-value latent-failure families

### Dual-channel inputs

Challenge each channel independently where the architecture/manufacturer permits it. Confirm that a single-channel fault cannot masquerade as a healthy dual-channel demand and that discrepancy/fault behavior is appropriate.

Do not infer channel independence merely because two wires or two HAL bits exist.

### Final elements and EDM

Challenge the difference between **commanded safe** and **physically achieved safe**. Verify the feedback channel can detect the dangerous final-element failure it is credited to detect.

A contactor auxiliary contact proves only what its mechanical/electrical arrangement legitimately represents. It does not prove all hazardous energy is absent.

### Hydraulic/pneumatic final elements

Confirm the safety demand reaches the credited valve/final element and obtain an appropriate physical/energy-path witness. Do not invent valve truth tables, pressure thresholds, stopping performance, or gravity-load behavior.

Where the physical response cannot yet be safely established, record `UNKNOWN`; do not substitute coil de-energization as proof of hydraulic state.

### Guards and protective devices

Challenge real access geometry and plausible defeat/misalignment paths, not just an electrically operated sensor on the bench. Confirm opening/tripping causes the intended safety demand and that clearing the device does not itself restart hazardous motion.

### Reset, restart, rearm

Confirm a cleared protective demand is distinct from safety reset, ordinary controller rearm, and normal START. Challenge stuck reset inputs, held buttons, power restoration, LinuxCNC/FPGA reboot, network reconnection, and stale ordinary commands as applicable.

### Stored and gravity energy

Inspect and physically challenge the documented means for discharge, isolation, blocking, or restraint where appropriate. A zero command or electrical disconnect does not prove stored hydraulic, pneumatic, spring, capacitive, or gravitational energy is controlled.

## 6. Inspection is not maintenance authorization

Periodic testing does not suspend hazardous-energy-control requirements.

If a test requires entering a danger zone, opening a guarded enclosure, disconnecting safety wiring, forcing a channel, or manipulating a final element, use the applicable maintenance/isolation procedure. Any temporary force, jumper, test plug, bypass, external supply, removed guard, or diagnostic firmware must be positively reconciled before release.

A test fixture must not become an easy permanent bypass.

## 7. Detect evidence decay

At every periodic review compare the present machine against the validated baseline:

- electrical/hydraulic/mechanical drawing revision;
- safety-controller project/signature/CRC where applicable;
- safety I/O and device identity;
- drive safety firmware/parameters;
- final-element part identity and feedback arrangement;
- protective-device model/configuration;
- LinuxCNC/HAL/FPGA interface behavior relevant to safety boundaries;
- guard/access geometry;
- known repairs, substitutions, firmware changes, overrides, or incident-driven modifications.

A previous passing test is stale if a relevant change invalidated its claim.

## 8. Result states

Use explicit states:

- `PASS — TEST-CONFIRMED` — the defined challenge and required physical witness passed for the recorded baseline.
- `PASS — LIMITED SCOPE` — only the named evidence layer was established; stronger claims remain open.
- `FAIL — OUT OF SERVICE` — required safety behavior failed or dangerous discrepancy was observed.
- `UNKNOWN — NOT CLEARED` — required evidence could not be obtained or interpreted.
- `NOT APPLICABLE` — only with documented rationale.

Never convert `UNKNOWN` into `PASS` because production needs the machine.

## 9. Failure response

When a periodic challenge fails:

1. maintain or establish the required physical hazard control;
2. place the affected exposed operating state OUT OF SERVICE / NOT CLEARED;
3. preserve useful diagnostics/evidence when safe to do so;
4. identify whether the failure is input, logic, output, final element, feedback, energy path, physical response, or configuration;
5. repair under controlled maintenance conditions;
6. apply the change-revalidation matrix to affected claims;
7. repeat the failed challenge plus any newly affected interface/fault-path tests;
8. release only when evidence supports the affected safety claims.

A diagnostic reset, power cycle, or successful normal cycle is not a substitute for closing the failed safety challenge.

## 10. Interval-selection rule

This curriculum intentionally does **not** set a universal weekly/monthly/annual interval.

Establish the interval from, as applicable:

- component manufacturer instructions and mission-time/proof-test assumptions;
- machine builder documentation;
- applicable safety standard/risk assessment;
- environmental/duty severity;
- failure history and maintenance evidence;
- whether a failure is automatically diagnosed or can remain latent;
- consequences of the dangerous undetected failure;
- changes that invalidate prior evidence.

If those inputs are unavailable, record the interval basis as `UNKNOWN` and resolve it before claiming a quantitative safety performance dependent on periodic testing.

## 11. Open OpenPressBrake requirements

Do not invent the following for the current machine:

- required PL/SIL/DC or diagnostic coverage;
- proof-test/inspection interval;
- acceptable stopping time or distance;
- safe speed/force/pressure;
- hydraulic safety-valve truth table;
- accumulator discharge threshold/time;
- gravity-restraint capability;
- exact EDM timing/discrepancy limits;
- safe-drive parameter values.

Convert each into a source/documentation or physical-verification task tied to the actual machine.

## 12. Minimum curriculum takeaway

A professional safety system needs a way to discover dangerous failures that ordinary production may hide. Periodic inspection should therefore ask **which credited safety claim could silently decay, what bounded challenge reveals that decay, and what independent physical evidence proves the result?**

The ordinary LinuxCNC/FPGA control system may assist with test sequencing or recording, but it does not become personnel-safety authority by doing so.