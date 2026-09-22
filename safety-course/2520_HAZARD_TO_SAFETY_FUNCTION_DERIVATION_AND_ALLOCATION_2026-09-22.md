# 2520 — Hazard-to-Safety-Function Derivation and Allocation

Date: 2026-09-22
Status: learner-facing methodology module
Evidence discipline: `DOC-CONFIRMED`, `SOURCE-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`

## Why this module exists

The safety course already contains deep material on E-stops, guards, STO, hydraulics/pneumatics, commissioning, evidence freshness, reset/restart, common cause, maintenance, and return to service. The workflow audit exposed a more important instructional gap: a learner could encounter those mechanisms without one explicit repeatable method for deriving **what safety functions the machine actually needs** from the machine's hazards and boundaries.

This module closes that gap. It comes before selecting a safety relay, safety PLC, STO option, monitored valve, light curtain, or Performance Level/SIL architecture.

The method is:

`machine + lifecycle boundaries -> tasks/people -> hazardous energy/motion -> hazardous event -> risk-reduction strategy -> safe-state proposition -> safety-function requirement -> sensing/logic/final-element allocation -> physical proof obligation -> reset/restart rule -> validation case -> residual risk`

A device is not a safety requirement. `Use a safety relay` is not a safety function. `Use STO` is not a complete machine safe state. Begin with the hazard and required physical outcome.

## Professional evidence for the workflow

### E-2520-01 — ISO 12100-style lifecycle begins with machine limits and hazards

**DOC-CONFIRMED.** SICK's *Guide for Safe Machinery* presents the ISO 12100 risk-assessment process as machine functions/definition of limits -> hazard identification -> risk estimation/evaluation -> risk reduction, iterated for all hazards. It also presents the three-step risk-reduction hierarchy: inherently safe design first, technical protective measures second, information for use for remaining residual risks.

Source: SICK, *Guide for Safe Machinery*, 2024 edition: https://www.sick.com/media/docs/8/78/678/special_information_guide_for_safe_machinery_en_im0014678.pdf

### E-2520-02 — Safety concept follows risk assessment and spans energy domains

**DOC-CONFIRMED.** Pilz describes the machinery safety concept as following the risk assessment and considering fixed/movable guards, safety-related control, safe standstill/shutdown of electrical, hydraulic, pneumatic and other potential energy sources, worker detection, and required PLr for safety-related measures/functions.

Source: Pilz, *Safety concept for machinery*: https://www.pilz.com/en-INT/services/machinery-safety/safety-concept

### E-2520-03 — SRS bridges risk assessment to design and validation

**DOC-CONFIRMED.** Rockwell describes the Safety Functional Requirements Specification as reviewing risk-reduction recommendations from the risk assessment, defining existing/proposed safety functions, and serving as a basis for safety-system design and validation. Its safety-function guidance treats a machine safety function as multiple elements—input, logic and output—not as a single device.

Sources:
- Rockwell Automation, *Is Your Machine Safety 'On' or 'Off?'*: https://www.rockwellautomation.com/en-us/company/news/magazines/is-your-machine-safety-on-or-off-.html
- Rockwell Automation, *Safety System Development Tools*: https://www.rockwellautomation.com/en-us/capabilities/industrial-safety-solutions/safety-system-development-tools.html

### E-2520-04 — Safety-function specification must include trigger, reaction and safe state

**DOC-CONFIRMED.** Pilz's ISO 13849 guidance states that an SRS clearly describes the safety functions and records, for each function, the triggering event, reaction and safe state. Rockwell's safety-function specification guidance additionally requires field-circuit analysis, including actuator safe reaction/position on switch-off or power failure and applicable operating-mode/emergency-stop conditions.

Sources:
- Pilz, *EN ISO 13849-1 — Basis for Performance Level*: https://www.pilz.com/en-INT/support/law-standards-norms/functional-safety/en-iso-13849-1
- Rockwell Automation, *Specification of Safety Function*: https://www.rockwellautomation.com/en-id/docs/factorytalk-design-studio/current/technical-content/ftds-pm001/web_ftds-pm001-ditamap/safety-system-principles/spec-safety-function.html

### E-2520-05 — STO is an example of why component safe state is not automatically machine safe state

**DOC-CONFIRMED.** Rockwell's PowerFlex safety documentation states that STO disables motor torque, while external mechanical forces such as suspended loads can still rotate the motor. This is direct evidence for keeping the physical hazard proposition separate from a device command/status.

Source: Rockwell Automation, *Safe Stop Functional Safety*: https://www.rockwellautomation.com/en-us/docs/technical/powerflex/powerflex-755t/_online/powerflex-755t-drives-information-ditamap/safe-stop-functional-safety.html

## The derivation method

### Step 1 — Define the machine boundary before naming safeguards

Record:
- intended use and reasonably foreseeable misuse;
- machine spatial boundary and danger zones;
- normal production, setup, loading/unloading, clearing, cleaning, inspection, maintenance, troubleshooting and recovery tasks;
- people who can be exposed;
- electrical, hydraulic, pneumatic, gravity, kinetic, thermal, stored spring/elastic, process/tooling and other relevant energy;
- external equipment and upstream/downstream machines that can create or receive hazardous state;
- operating modes and transitions;
- what is outside the assessment boundary.

If a boundary is unknown, write `UNKNOWN`; do not silently choose a convenient boundary.

### Step 2 — Describe hazardous events, not just hazard nouns

Weak: `hydraulics`, `spindle`, `robot`.

Useful: `During die setup with hands between tooling, unexpected downward ram motion can create a crushing event.`

Use this structure:

`TASK / EXPOSURE + HAZARDOUS ENERGY OR MOTION + INITIATING CONDITION -> HARM MECHANISM`

This makes later safeguards testable.

### Step 3 — Apply the risk-reduction hierarchy before control-system allocation

For every hazardous event ask, in order:
1. Can the hazard be eliminated or reduced by inherently safer design?
2. What technical protective measure is required for risk that remains?
3. What residual risk must be communicated or procedurally controlled after the first two steps?

Do not jump directly from `hazard found` to `install safety PLC`. Fixed geometry, mechanical restraint, lower available energy, access elimination, or process redesign may be stronger and simpler controls.

### Step 4 — Define the required physical safe-state proposition

A **safe-state proposition** is a machine-physical statement that must be true for the relevant exposure, not merely a command bit.

Examples of proposition form:
- hazardous rotation has ceased before access becomes possible;
- a gravity-supported axis cannot descend hazardously during the defined exposure;
- hazardous pneumatic pressure/force has been reduced to the defined safe condition before access;
- hazardous motion cannot initiate while a person can occupy the protected space;
- hazardous energy remains isolated while maintenance access is retained.

The examples are forms, not universal machine truths. Actual thresholds, timing, stopping distance, pressure, load-holding criteria and acceptable residual energy are design-specific and remain `UNKNOWN` until established.

### Step 5 — Derive the safety function in plain language

Use this minimum contract:

`SF-ID`
- **Hazard/event addressed:** link to hazard ID.
- **Trigger/demand:** what event demands the function?
- **Required reaction:** what must the safety-related system cause?
- **Physical safe-state proposition(s):** what must become/remain physically true?
- **Operating modes:** when is the function required?
- **Response/stopping requirement:** named criterion or `UNKNOWN`; never invent a value.
- **Restart/reset behavior:** what must *not* automatically restart, and what fresh action is required?
- **Failure behavior:** what happens on loss of power, broken wire, disagreement, communication loss, or detected internal fault?
- **Required risk reduction:** PLr/SIL/other target only when established by the applicable risk method; otherwise `UNKNOWN`.
- **Assumptions/dependencies:** environmental, mechanical, electrical, hydraulic/pneumatic and human dependencies.
- **Residual risk:** what remains after the function succeeds?

### Step 6 — Allocate the function across physical layers

Do not allocate by product name first. Allocate by roles:

`hazard witness / demand sensor -> safety-related logic -> final element(s) -> physical process/energy -> proof witness where required`

Then separately identify:
- ordinary LinuxCNC/FPGA/HMI control;
- safety-related authority;
- physical energy-removal/restraint elements;
- diagnostics/status that may be shown to LinuxCNC but do not transfer safety authority to LinuxCNC.

A safety function may require multiple energy-domain final elements. For example, an electrical stop alone may not establish a hydraulic, pneumatic, gravity or stored-energy proposition.

### Step 7 — State proof obligations before declaring the architecture complete

For each proposition ask:
- What evidence can establish it?
- Is the evidence direct, indirect, or only command/status evidence?
- What faults can make that evidence misleading?
- What common dependencies exist?
- What makes the evidence stale?
- Is proof required continuously, on demand, at commissioning, periodically, after change, or after a finding?

Use existing repository `PROP-*`, `EVID-*`, `DEP-*`, `FIND-*`, and `VAL-*` records where appropriate.

### Step 8 — Define reset, rearm and fresh ordinary demand separately

The function specification must not collapse these states:

`hazard removed / safe proposition proved -> safety reset eligible -> safety reset/rearm -> fresh ordinary production demand -> motion/process action`

Reset acknowledges or rearms the safety function as designed. It is not itself permission to start production. A held pre-fault command must not silently become a fresh post-recovery start.

### Step 9 — Derive validation cases from the requirement, not from the chosen hardware

Validation asks whether the implemented safety function satisfies its requirement on the actual machine. Include, as applicable:
- normal demand;
- power loss/restoration;
- broken/open/shorted input paths;
- disagreement/cross-fault behavior;
- final-element failure or feedback mismatch;
- communication loss/reintegration;
- reset/restart behavior;
- mode transitions;
- stopping/process-response proof;
- maintenance/change invalidation;
- human-factors defeat pressure.

Do not claim `validated` merely because a safety relay/PLC self-test passes.

## Hazard-to-function worksheet

| ID | Required entry |
|---|---|
| `HZ-*` | task/exposure, energy/motion, initiating condition, harm mechanism |
| Boundary | lifecycle/mode/person/danger-zone assumptions and `UNKNOWN`s |
| Hierarchy | inherently safer design considered; technical protection; residual information/procedure |
| `PROP-*` | physical safe-state proposition(s) |
| `SF-*` | trigger -> reaction -> safe state -> restart behavior |
| Integrity target | established PLr/SIL/other target with source/method, or `UNKNOWN` |
| Inputs | safety demand/witnesses and failure behavior |
| Logic | independent safety-related authority; ordinary-control interface boundary |
| Final elements | physical devices that actually remove/control/restraint hazardous energy/motion |
| `DEP-*` | shared power, mechanics, environment, network, mounting, process dependencies |
| `EVID-*` | evidence proving each proposition and freshness rule |
| `VAL-*` | validation case and acceptance criterion |
| Residual risk | what remains when the safety function works correctly |
| Human factors | foreseeable bypass incentive and design response |

## Worked transfer example A — generic press / gravity-loaded axis

**Boundary:** operator setup at tooling; vertical moving member; electrical drive/control plus gravity/mechanical and possibly fluid-power energy. Machine-specific circuit/pressure truth is deliberately unspecified.

**HZ-PRESS-01:** during setup with a person exposed at the tooling, unexpected downward motion can create a crushing event.

**Derivation:**
1. Consider eliminating/reducing exposure and mechanical means before control allocation.
2. `PROP-PRESS-01`: hazardous downward motion is prevented/controlled to the defined safe condition during the exposure.
3. `SF-PRESS-01`: on protective-device demand or defined setup-state violation, cause the machine-specific final elements necessary to reach/maintain `PROP-PRESS-01`; prevent automatic restart; require the defined reset/rearm and fresh production demand.
4. Electrical torque removal may be one allocated action, but **STO alone is not accepted as proof of a gravity-load safe state**.
5. The required hydraulic/mechanical final elements, load-holding behavior, stopping criterion, integrity target and proof method are `UNKNOWN` until the actual machine design and risk assessment establish them.

**Boundary lesson:** LinuxCNC may receive status and request an ordinary stop, but it does not become the sole personnel-safety authority.

## Worked transfer example B — spindle machine with interlocked access

**Boundary:** operator opens access for a task where contact with hazardous rotating tooling/workholding is possible.

**HZ-SPINDLE-01:** access occurs while hazardous rotation persists or can restart unexpectedly.

**Derivation:**
1. `PROP-SPINDLE-01`: the physical condition required for safe access is established and hazardous restart is prevented for the exposure.
2. `SF-SPINDLE-01`: on guard/access demand, cause the required stop/inhibition and prevent hazardous restart until the specified release/reset/start sequence is completed.
3. Whether access may be unlocked on a timer, drive status, a safe-speed/standstill function, or another witness is **not transferable** from another machine. It depends on stopping behavior, access time, tooling inertia and the actual design.
4. A normal LinuxCNC spindle-at-speed or spindle-stopped signal is not silently promoted to safety-rated evidence.

**Transfer lesson:** the derivation method transfers; the physical safe-state criterion and evidence do not.

## Adversarial review

Reject these shortcuts:

1. **`The hazard is crushing, therefore use dual-channel E-stop.`** Incomplete. The exposure, initiating conditions, safe state, final physical elements, reset/restart behavior and validation are not derived.
2. **`The drive reports STO active, therefore the axis is safe.`** Invalid for a gravity/load case unless the required physical proposition is independently satisfied by the design and evidence.
3. **`The safety PLC is PLe capable, so every safety function is PLe.`** Invalid. Function-level architecture, devices, dependencies, calculations/assumptions and validation still matter.
4. **`The guard switch is healthy, therefore nobody is in the cell.`** Invalid unless the safety function's architecture and evidence actually establish personnel clearance/retention for the defined access pattern.
5. **`LinuxCNC can inhibit motion, so put the personnel-safety logic in HAL.`** Ordinary LinuxCNC/HAL may participate in normal control and diagnostics but must not be assigned independent personnel-safety authority without evidence supporting that role.
6. **`We do not know the stopping time, so choose a conservative distance.`** Do not invent the missing physical fact. Record `UNKNOWN`; isolate/remote operation if the missing fact prevents a basic safe-to-operate threshold from being established.

## Human-factors gate

For every derived safety function ask:
- What normal task makes this safeguard annoying?
- What recovery/maintenance task tempts bypass?
- Can visibility, access, reset placement, diagnostics, captive hardware, setup mode or legitimate recovery workflow make correct use easier?
- Does nuisance tripping indicate a design/process defect that should be fixed rather than normalized?

A safeguard whose routine use predictably drives defeat has an engineering defect even if its safety logic is technically sophisticated.

## Minimum learner deliverable

Given an unfamiliar machine, the learner must produce at least:
1. machine/lifecycle boundary;
2. task-based hazard list;
3. risk-reduction hierarchy decisions;
4. physical safe-state propositions;
5. plain-language safety functions;
6. allocation across sensor/logic/final element/process proof;
7. ordinary-control versus independent-safety boundary;
8. named `UNKNOWN`s instead of invented physical values;
9. reset/restart/fresh-demand rules;
10. validation cases and residual-risk statement;
11. human-factors defeat review.

A parts list without this chain does not pass 2520.

## Frozen teaching rules

- **HAZARD IDENTIFIED != SAFETY FUNCTION SPECIFIED.**
- **SAFETY DEVICE SELECTED != RISK-REDUCTION METHOD DERIVED.**
- **DEVICE SAFE STATE != MACHINE PHYSICAL SAFE STATE.**
- **COMMAND/STATUS EVIDENCE != PHYSICAL PROCESS PROOF unless the proposition and architecture justify it.**
- **PL/SIL-CAPABLE COMPONENT != MACHINE SAFETY FUNCTION PL/SIL.**
- **TRANSFERABLE METHOD != TRANSFERABLE MACHINE PHYSICS.**
- **RESET/REARM != ORDINARY START AUTHORITY.**
- **UNKNOWN PHYSICAL FACT != PERMISSION TO INVENT A CONSERVATIVE NUMBER.**
- **LINUXCNC/FPGA NORMAL CONTROL != INDEPENDENT PERSONNEL-SAFETY AUTHORITY.**

## Next instructional dependency

The next methodology branch should test this worksheet on a substantially different machine/cell and then teach **safety-function composition and conflict analysis**: multiple functions sharing final elements, conflicting safe states, common dependencies, and mode-dependent allocation. Do not jump directly to component selection or PL/SIL arithmetic until the learner can derive and allocate the functions coherently.
