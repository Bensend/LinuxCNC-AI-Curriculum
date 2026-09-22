# 2520 — Safety-Function Composition, Conflict, and Shared Final Elements

Date: 2026-09-22
Prerequisite: `2520_HAZARD_TO_SAFETY_FUNCTION_DERIVATION_AND_ALLOCATION_2026-09-22.md`
Status: learner-facing methodology continuation

## Purpose

Deriving each safety function separately is necessary but not sufficient. Real machines combine E-stop, guard/access, setup/enabling, process-fault, safe-stop, guard-locking, and maintenance functions. Several may share the same contactor, STO channel, monitored valve, brake, safety output, power supply, network, or physical mechanism.

Composition must preserve the strongest applicable physical requirement. It must not turn several individually plausible functions into one unsafe combined state machine.

Method:

`derive functions separately -> build mode/function matrix -> build shared-final-element/dependency matrix -> identify conflicts and dominance -> define transition invariants -> prove each physical proposition -> validate combinations and transitions`

## Professional evidence

### E-COMP-01 — safety functions can be combined or switched, but transitions may not create danger

**DOC-CONFIRMED.** SICK's *Guide for Safe Machinery* explicitly discusses combining/switching safety functions. Machines can have different states/modes with different safety measures or coupled safety functions; switching modes or changing safety measures must not lead to a dangerous state. SICK gives the example that after changing between setup and normal operation, the machine is stopped and a new manual start command is required.

Source: SICK, *Guide for Safe Machinery*, section `Defining the safety functions / Combining or switching safety functions`, 2026-05-11 edition: https://www.sick.com/media/docs/8/78/678/Special_information_Guide_for_Safe_Machinery_en_IM0014678.PDF

### E-COMP-02 — one safety function spans input, logic and output

**DOC-CONFIRMED.** Rockwell's safety-function library states that E-stop, guarding and presence-sensing functions require multiple elements: sensor/input, logic and output. Its examples show different demands de-energizing contactors or controlling machine power/motion.

Source: Rockwell Automation, *Safety Functions Documents*: https://www.rockwellautomation.com/de-de/support/documentation/technical-data/functionalsafetydocum20180905-1614.html

### E-COMP-03 — SFRS should identify each function's inputs, logic, outputs, safe state and reset

**DOC-CONFIRMED.** Rockwell's SFRS guidance requires each safety function to identify triggering input devices, logic evaluation, output devices, the safe state of each output, how the system achieves the safe state, and how the user resets the function.

Source: Rockwell Automation, *Implementing Functional Safety Requirements*: https://www.rockwellautomation.com/en-tr/company/news/blogs/functional-safety-plan.html

### E-COMP-04 — setup/enabling is a deliberate exception, not a blanket bypass

**DOC-CONFIRMED.** Rockwell enabling-device guidance distinguishes partial/full-body access and warns that an enabling device should bypass only one primary safeguard rather than multiple safeguards, because the other safeguards may be needed to detect access. Pilz describes three-position enabling devices for work in a danger zone when a protective device must be suspended; release or full depression invokes the protective stop behavior.

Sources:
- Rockwell Automation, *Emergency Stop Devices Technical Data*, enabling-device application guidance: https://literature.rockwellautomation.com/idc/groups/literature/documents/td/440-td001_-en-p.pdf
- Pilz, *PITenable enabling switch*: https://www.pilz.com/en-INT/products/operating-and-monitoring/control-and-signal-devices/pitenable-enabling-switch

## 1. Compose requirements, not product outputs

Before wiring several functions to one output, keep each function independent on paper:

| Function | Demand | Required physical proposition | Mode | Reset/restart | Integrity target |
|---|---|---|---|---|---|
| `SF-ESTOP` | emergency-stop actuation | machine-specific emergency safe condition | applicable modes | reset must not start | established target or `UNKNOWN` |
| `SF-GUARD` | guard/access demand | access-safe physical condition | applicable modes | close/lock/reset/start sequence as derived | target or `UNKNOWN` |
| `SF-SETUP` | selected setup mode + enabling behavior | permitted motion only within derived setup constraints | setup only | transition requires fresh authority | target or `UNKNOWN` |
| `SF-PROC` | process fault | process-specific safe condition | modes where process exists | fault disposition before rearm as required | target or `UNKNOWN` |

Do not replace this table with `all four drop STO`. STO may be one shared final element, but the functions can require different physical outcomes.

## 2. Build the mode/function matrix

For every operating mode mark each function:
- `ACTIVE` — must be fully effective;
- `SUBSTITUTED` — one protective measure is deliberately replaced by a specifically derived alternative;
- `NOT APPLICABLE` — hazard cannot exist in that mode, with evidence;
- `UNKNOWN` — not yet established.

A mode change is itself a safety-relevant transition when the set of effective measures changes.

### Transition invariant

During a transition, never permit the machine to pass through a state in which:
1. the outgoing protection is no longer effective;
2. the incoming protection is not yet proved effective; and
3. hazardous motion/energy can be initiated or persist contrary to the required propositions.

When necessary, use an inhibited intermediate state and require a fresh demand after the transition.

## 3. Build the shared-final-element matrix

Example structure only:

| Element/dependency | SF-ESTOP | SF-GUARD | SF-SETUP | SF-PROC | What it actually proves/does |
|---|---:|---:|---:|---:|---|
| safety contactor | X | X | maybe | X | removes defined electrical power path; does not by itself prove standstill |
| drive STO | X | X | mode-specific | X | removes torque-producing capability as specified by drive; does not universally prove gravity-load hold/standstill |
| pneumatic exhaust element | maybe | X | mode-specific | X | acts on defined pneumatic path; physical exhaust proposition needs machine-specific proof |
| brake/load restraint | machine-specific | machine-specific | machine-specific | machine-specific | physical role must be derived from actual machine |
| shared 24-V safety field supply | DEP | DEP | DEP | DEP | common dependency; loss can make multiple witnesses unavailable |
| safety network | maybe | maybe | maybe | maybe | transports safety data where architecture permits; network health is not physical-process proof |

The matrix exposes common cause and prevents the false inference `four logical functions -> four independent safety paths`.

## 4. Conflict classes

### A. Safe-state conflict

Two functions can request different physical outcomes. Example form: one process function wants controlled deceleration while an emergency function requires the machine's derived emergency-stop behavior. The design must state which requirement dominates under simultaneous demand. Do not improvise priority from software convenience.

### B. Access-versus-process conflict

A process may prefer pressure, vacuum, spindle orientation, robot holding torque, or guard locking to remain active while personnel access requires a different physical condition. Separate **process protection** from **personnel protection** and derive the access condition from the hazard.

### C. Setup exception conflict

Setup mode may intentionally suspend one primary safeguard and substitute enabling/limited-motion measures. That exception must not silently suspend E-stop, unrelated access protection, or other safety functions. The bypass scope is explicit and minimal.

### D. Shared-final-element conflict

If one contactor/STO/valve is shared, a failure or maintenance change can affect several functions. Reverse `show where used` from the final element/dependency to every `SF-*`, `PROP-*`, `EVID-*`, and `VAL-*` that depends on it.

### E. Reset/restart conflict

If several functions clear at different times, the first cleared function must not cause restart while another blocker remains. The aggregate machine state remains inhibited until every required proposition/obligation is satisfied and a fresh ordinary demand is accepted.

## 5. Dominance rule

For simultaneous demands, define dominance in terms of **required physical propositions**, not function names.

A candidate combined reaction is acceptable only if it satisfies every safety proposition that remains applicable under the simultaneous condition, or if the safety requirements explicitly establish a justified substitution.

Therefore:

**E-STOP ACTIVE + GUARD OPEN** does not mean `pick E-stop logic and ignore guard logic`.

It means: determine all physical propositions required by the emergency and access conditions, then verify that the combined final-element state satisfies them. If not, the architecture is incomplete.

## 6. Adversarial shared-final-element case

Generic automated saw/feed cell, deliberately without machine-specific timing/integrity numbers:

- powered saw/spindle hazard;
- stock-feed motion;
- pneumatic clamp;
- interlocked access gate;
- E-stop;
- setup mode using an enabling device for a narrowly defined adjustment task;
- process fault for loss of clamping condition;
- common safety contactor/STO path for motor torque removal;
- pneumatic safety element for the clamp/feed subsystem.

### Derived function sketches

`SF-SAW-ESTOP`: on E-stop demand, achieve the machine's defined emergency safe condition and prevent automatic restart.

`SF-SAW-GUARD`: on access demand, establish the physical access-safe condition before/while access is possible and prevent hazardous restart.

`SF-SAW-SETUP`: only in deliberately selected setup mode, permit only the specifically derived setup motion/process while the enabling condition and all other required protections remain valid.

`SF-SAW-CLAMP`: on loss of the required clamping condition, prevent the hazardous process response derived by the risk assessment.

### Trap 1 — one shared STO output

If all functions can drop motor STO, the design is still incomplete. Guard access may require proof of standstill before unlocking; E-stop may not require unlocking at all; pneumatic clamp energy may remain; setup may require a different constrained motion state. Shared STO does not collapse those propositions.

### Trap 2 — setup bypass wired globally

If `setup enable` bypasses the entire guard/E-stop chain to make commissioning convenient, the composition fails. Professional enabling-device guidance supports narrowly scoped substitution, not blanket suspension of multiple safeguards.

### Trap 3 — clamp fault clears while guard remains open

Restoring clamp pressure/feedback must not re-enable hazardous process motion while access protection remains demanded. Aggregate blockers dominate restart.

### Trap 4 — mode changes while Cycle Start is held

Changing setup -> automatic must not cause motion because the ordinary demand remained held. Use an inhibited transition and require the derived fresh post-transition demand.

### Trap 5 — shared field supply fails

A single supply loss can make guard, enabling, valve-feedback and other witnesses unavailable simultaneously. Treat the supply as `DEP-*` and reverse-trace every affected proposition/function. Do not count the logical channels as independent evidence merely because their input tags differ.

## 7. Allocation/dependency worksheet

For every function fill:

| Chain | Entry |
|---|---|
| `HZ-*` | hazardous event |
| `PROP-*` | required physical safe-state proposition |
| `SF-*` | demand -> reaction -> reset/restart |
| Input | safety demand/witness |
| Logic | independent safety-related authority |
| Final element | device acting on physical hazard/energy |
| `DEP-*` | shared supply/network/mechanics/environment/process dependency |
| `EVID-*` | evidence that the proposition is true |
| `VAL-*` | validation case + acceptance criterion |
| Ordinary control | LinuxCNC/FPGA/HMI role, explicitly non-authoritative for personnel safety unless proven otherwise |

Then perform two reverse lookups:
1. **final element -> all functions/propositions using it**;
2. **dependency -> all evidence/propositions/functions invalidated or made unavailable by its loss/change**.

## 8. Human-factors composition review

Composition can create bypass pressure even when individual safeguards are usable. Check:
- Does setup require defeating three unrelated safeguards just to perform a common adjustment?
- Does a nuisance process fault force a full cell reset when a safe localized recovery could be designed?
- Is guard locking retained longer than the physical hazard requires, encouraging defeat?
- Are diagnostics clear enough to tell which safety function is blocking rearm?
- Can a legitimate recovery be performed without improvised jumpers, magnets, taped switches, or software overrides?

The answer is not to weaken the safety function. Redesign mode allocation, diagnostics, access, recovery, or physical process so the safe path is practical.

## 9. Pass/fail assessment

A learner passes this stage only if they can take at least four previously derived safety functions and:
1. keep their physical propositions separate;
2. map applicable functions by operating mode;
3. identify shared final elements and common dependencies;
4. identify simultaneous-demand conflicts;
5. define a safe dominance/transition rule without inventing machine physics;
6. preserve independent safety authority from ordinary LinuxCNC/FPGA control;
7. reverse-trace one shared-element failure;
8. require proposition-specific proof/validation;
9. preserve reset/rearm versus fresh-start separation;
10. identify one composition-created bypass incentive and redesign it.

## Frozen teaching rules

- **MULTIPLE SAFETY FUNCTIONS != INDEPENDENT PHYSICAL PATHS.**
- **SHARED FINAL ELEMENT != SHARED SAFE-STATE PROPOSITION.**
- **ONE OUTPUT OFF != EVERY SAFETY FUNCTION SATISFIED.**
- **MODE EXCEPTION != GLOBAL SAFEGUARD BYPASS.**
- **SIMULTANEOUS DEMANDS REQUIRE COMPOSED PHYSICAL PROPOSITIONS, NOT SOFTWARE PRIORITY BY CONVENIENCE.**
- **FIRST FAULT CLEARED != AGGREGATE SAFETY BLOCKERS CLEARED.**
- **MODE TRANSITION != PERMISSION TO REVIVE A HELD ORDINARY DEMAND.**
- **LOGICAL CHANNEL SEPARATION != INDEPENDENCE FROM SHARED POWER/MECHANICS/NETWORK/ENVIRONMENT.**

## Next work

Use this composition method to build one compact machine-level SRS exercise spanning electrical plus fluid/mechanical energy and require a learner to derive the validation matrix directly from the SRS. Then audit whether the next missing workflow stage is **fault-analysis/diagnostic design before architecture selection** or **verification/validation planning**, rather than adding more recovery notes.
