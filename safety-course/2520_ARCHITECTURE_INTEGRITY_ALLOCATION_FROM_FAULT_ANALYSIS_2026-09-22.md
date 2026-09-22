# 2520 — Architecture and Integrity Allocation from Fault Analysis

## Purpose

This stage follows `2520_FAULT_ANALYSIS_DIAGNOSTIC_DESIGN_AND_RESIDUAL_PROPOSITION_2026-09-22.md`. It converts identified dangerous faults, latent faults, common causes, diagnostic gaps, and proof obligations into **architecture requirements before component selection or PL/SIL arithmetic**.

The design question is not “which safety relay/PLC should we buy?” It is:

> What architecture is required so that the safety function reaches and maintains its required physical proposition under the credible faults already identified, detects the faults that must be detected in time, and exposes enough independent proof to validate the result?

## Evidence anchors

- `DOC-CONFIRMED` — Pilz's ISO 13849-1 guidance describes Category as a structural property concerning resistance to faults and subsequent behavior, while MTTFd, diagnostic coverage (DC), and common-cause failure (CCF) are separate inputs to subsystem PL determination. It also notes that ISO 13849-1:2023 clarifies CCF consideration per subsystem. Source: Pilz, “EN ISO 13849-1 — Basis for Performance Level,” current web guidance checked 2026-09-22.
- `DOC-CONFIRMED` — Rockwell Logix SIS documentation describes redundant safety controllers as an availability/safety architecture in which both controllers execute the safety task; when redundant operation is interrupted, the remaining primary is explicitly described as a single-channel SIL 2 controller. This is useful evidence that “redundant” is not a universal synonym for an unchanged integrity claim. Source: Rockwell, “Logix SIS,” checked 2026-09-22.
- `DOC-CONFIRMED` — Pilz safety-relay guidance describes redundancy with self-monitoring and automatic checking of correct relay contact opening/closing each cycle. This is a concrete architecture pattern combining redundancy and diagnostics; it does not establish suitability for an arbitrary machine safety function. Source: Pilz, “Safety relay function,” checked 2026-09-22.

These anchors support the method. They do **not** authorize assigning a Category, PL, SIL, DC percentage, MTTFd, PFH/PFD, beta factor, or proof interval from a sketch.

## Architecture derivation method

Start from the completed fault worksheet:

`SF -> PROP -> FLT/effect -> detection requirement -> reaction -> residual PROP -> EVID/VAL`

Then derive:

`architecture requirement -> independence boundary -> diagnostic boundary -> final-element/proof boundary -> CCF controls -> validation surface`

### 1. Convert every dangerous-undetected gap into a requirement

For each `DANGEROUS-UNDETECTED` or unacceptable latent-fault row, choose and justify one or more architectural responses:

- prevent/avoid the fault by design;
- make the fault non-dangerous;
- add a genuinely independent channel/path;
- add a diagnostic capable of detecting the defined fault within the required time;
- add final-element monitoring;
- add a physical/process witness when command/status cannot prove the proposition;
- add periodic or post-maintenance proof when online diagnosis cannot cover the physical failure;
- change the safety function or machine design so the proposition no longer depends on the vulnerable element.

If none is justified, the gap remains open. Do not hide it with a component rating.

### 2. Separate four concepts that are often collapsed

**Redundancy** — more than one element/path exists.

**Fault tolerance** — the architecture can still satisfy the defined safety requirement after a specified fault.

**Diagnostic coverage** — diagnostics detect some defined dangerous failures; this is not identical to redundancy or fault tolerance.

**Physical independence** — supposedly separate channels do not share a dependency capable of defeating both in the same relevant way.

A two-channel drawing may have redundancy without meaningful physical independence. A diagnostic-rich single path may detect many faults but have no continued function after a fault. A redundant controller pair may improve availability while a single shared final element still dominates the physical proposition.

### 3. Declare independence boundaries explicitly

For every claimed independent path, reverse-trace `DEP-*` through:

- power supplies and returns;
- connectors/cables/routing;
- field-device mounting and mechanical geometry;
- communication infrastructure;
- environmental exposure;
- configuration/programming and maintenance process;
- actuators/final elements;
- feedback/witness devices;
- common pressure/energy sources;
- ordinary LinuxCNC/FPGA interfaces.

Record the first shared dependency. If that dependency can defeat both paths, independence is not established merely because the logic channels differ.

Diversity is a possible control for some common causes, not an automatic requirement and not an automatic cure. Require a stated fault/common-cause hypothesis that the proposed diversity addresses.

### 4. Keep diagnostic paths honest

For each diagnostic ask:

1. Can the diagnostic share the fault it is intended to reveal?
2. Does it observe command/state or the physical proposition?
3. Can a stale, frozen, mis-mounted, misconfigured, or common-powered witness falsely appear healthy?
4. What happens if the diagnostic itself fails?
5. When must that diagnostic failure be detected?

Where the answer exposes a dangerous-undetected path, add an architecture/proof requirement rather than assuming the diagnostic is authoritative.

### 5. Derive final-element monitoring from the proposition

Do not add EDM/feedback simply because professional diagrams often contain it. State what must be proved.

Examples:

- A contactor auxiliary/forced-guided feedback path may support a proposition about contactor state if the device/application architecture justifies that relationship.
- Drive safe-state status may support a defined drive safety state but does not universally prove shaft standstill, gravity load holding, or downstream mechanical isolation.
- Valve spool/status or pressure feedback may support bounded hydraulic/pneumatic propositions only when placement, thresholds, failure modes, and validation establish them.
- If the proposition is physical load holding, no electronic “safe output” status alone is sufficient unless the machine architecture has established that equivalence.

### 6. Define common-cause controls before integrity arithmetic

For each shared `DEP-*`, record practical controls appropriate to the identified cause, such as separation, protected routing, independent supplies where justified, mechanical mounting independence, environmental controls, configuration/change controls, contamination control, proof inspection, or diverse sensing principles.

Do not assign a CCF score/beta factor in this stage. First prove that the design actually addresses the identified shared causes.

### 7. Define validation surfaces as part of architecture

Every architecture must expose a way to prove the required behavior. Require accessible test/proof surfaces for:

- input demand and discrepancy behavior;
- logic/communication fault reaction;
- final-element response;
- physical/process proposition where command/state is insufficient;
- power-loss/recovery and reintegration;
- reset/rearm versus fresh start;
- common-cause challenge where practical;
- maintenance/change re-proof.

An architecture that cannot be practically validated or maintained is incomplete.

### 8. Human factors are an architecture constraint

If the architecture produces predictable nuisance trips, opaque diagnostics, difficult guard realignment, or recovery steps that encourage bypass, correct the cause without weakening the safety function. Make legitimate recovery and guard use easier than defeat. Preserve durable fault/finding information so technicians do not need to suppress a safeguard to diagnose it.

## Reusable architecture requirement record

| ID | SF / PROP | Fault/gap driving requirement | Architecture requirement | Claimed independent paths | Shared DEP / CCF challenge | Diagnostic path | Final-element / physical witness | Validation surface | Integrity arithmetic still UNKNOWN |
|---|---|---|---|---|---|---|---|---|---|
| ARCH-001 | SF-... / PROP-... | FLT-... | ... | ... | ... | ... | ... | VAL-... | yes |

A row is not closed until its claimed independence has a reverse dependency trace and its proof surface is explicit.

## Stress test A — automated cut/feed cell

Assume a guard function prevents hazardous rotating-tool/feed motion during full-body access.

1. Two guard channels plus test pulses can provide wiring/channel diagnostics, but both sensors mounted to one deformable bracket share a mechanical dependency. `ARCH-GUARD-MOUNT`: either establish adequate common-cause control/independent geometry or retain a physical inspection/proof obligation after relevant mechanical disturbance.
2. Two logic channels that ultimately command one final contactor/drive path do not create two independent physical stopping paths. Reverse-trace the shared final element.
3. If external-device feedback observes final-element state, document exactly what proposition it supports. Do not promote it to “tool stopped” unless the machine architecture proves that equivalence.
4. If standstill itself is required before access, derive a standstill proof requirement rather than inferring it from “safe output off.” The sensing method, timing, integrity target, and validation remain `UNKNOWN` until derived for the machine.
5. LinuxCNC/FPGA may request normal stops, display diagnostics, and withhold ordinary demand, but independent safety authority owns the personnel-safety function.

### Shared-final-element trap

`SF-GUARD` and `SF-ESTOP` may have different initiators and logic yet converge on the same physical energy-removal element. Therefore:

**TWO SAFETY FUNCTIONS != TWO INDEPENDENT FINAL-ELEMENT PATHS.**

The shared element must be represented as a dependency of both functions and challenged accordingly.

## Stress test B — gravity/fluid-power axis

Required proposition example: `PROP-GRAV-01: hazardous descent is prevented during defined personnel access`.

Architecture derivation must challenge:

- two electrical command channels feeding one shared valve or brake;
- two valves sharing one pressure source or contamination mechanism;
- electrical feedback that proves coil/output state but not mechanical load holding;
- pressure sensing that shares a blocked passage or common supply and therefore may not prove the load-side state;
- stored/trapped energy after electrical isolation;
- maintenance that changes hose/valve/sensor geometry and invalidates prior proof.

If the machine-specific holding mechanism, valve behavior, brake capacity, pressure thresholds, or stopping behavior is not established, keep it `UNKNOWN`. Personnel exposure must not rely on the unproved proposition. Any experimental operation needed to learn the physics must be isolated/remote with people outside the danger zone.

## Adversarial case — perfect electronics, unproved physics

A safety controller reports both guard channels healthy. Test pulses pass. Safety network is valid. Both safety outputs transition correctly. External-device feedback reports the commanded final element changed state. LinuxCNC reports idle. No diagnostic fault exists.

During maintenance, however, the mechanical coupling between the final element and the hazardous load was changed. No post-maintenance physical proof has been performed.

Correct conclusion: the electronic architecture can be diagnostically healthy while the required process proposition remains `STALE` or `UNKNOWN`. The missing item is a physical validation/re-proof obligation, not another green diagnostic bit.

**ALL ELECTRONIC DIAGNOSTICS HEALTHY != REQUIRED PHYSICAL PROCESS PROPOSITION PROVED.**

## Integrity-allocation gate

Only after the architecture requirements above are explicit should the learner apply the chosen applicable functional-safety method to determine required integrity and demonstrate achieved integrity.

At that later stage, derive—not guess—the applicable PLr/SIL target and then use the standard's required structural/reliability/diagnostic/common-cause/systematic-fault method. Component data and arithmetic verify an already-defined safety architecture; they do not create the safety requirement.

Until that work is done, record these as `UNKNOWN`:

- Category;
- PL/PLr or SIL;
- DC/DCavg percentage;
- MTTFd;
- PFH/PFD;
- CCF score or beta factor;
- proof-test interval;
- machine-specific discrepancy/stopping time.

## Frozen distinctions

- **REDUNDANCY != FAULT TOLERANCE != DIAGNOSTIC COVERAGE != PHYSICAL INDEPENDENCE.**
- **TWO CHANNELS != TWO INDEPENDENT PATHS.**
- **TWO SAFETY FUNCTIONS != TWO INDEPENDENT FINAL-ELEMENT PATHS.**
- **DIVERSE COMPONENTS != COMMON-CAUSE CONTROL UNLESS THE DIVERSITY ADDRESSES A DEFINED CAUSE.**
- **FINAL-ELEMENT FEEDBACK != PROCESS SAFE STATE UNLESS THAT EQUIVALENCE IS ESTABLISHED.**
- **ALL ELECTRONIC DIAGNOSTICS HEALTHY != REQUIRED PHYSICAL PROCESS PROPOSITION PROVED.**
- **ARCHITECTURE SKETCH != CATEGORY / PL / SIL CLAIM.**
- **COMPONENT SAFETY RATING != MACHINE SAFETY-FUNCTION INTEGRITY.**
- **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY.**

## Exit criteria

The learner may move from architecture derivation toward integrity calculation/component selection only when they can:

1. show how every dangerous-undetected/latent gap drove an architecture or proof requirement;
2. distinguish redundancy, fault tolerance, diagnostic coverage, and physical independence;
3. reverse-trace shared dependencies for every claimed independent path;
4. state what final-element/process evidence is required beyond command/status;
5. identify and control relevant common causes without inventing a score;
6. expose practical validation/proof surfaces;
7. preserve human-factors and independent-safety-authority constraints;
8. leave Category/PL/SIL and numerical integrity quantities `UNKNOWN` until the applicable method and machine requirements justify them.
