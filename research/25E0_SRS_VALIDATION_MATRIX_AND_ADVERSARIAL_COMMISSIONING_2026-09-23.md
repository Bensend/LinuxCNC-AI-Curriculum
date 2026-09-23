# 25E0 — SRS validation matrix and adversarial commissioning

Session start UTC: 2026-09-23T20:35:20Z

## Purpose

Convert representative safety requirements into tests that establish physical propositions rather than merely observing command/status bits. This artifact extends the canonical 25E0 entry and does not assign machine-specific PL/SIL, stopping time, pressure threshold, proof-test interval, or acceptance margin.

## Evidence status

- **DOC-CONFIRMED — Pilz safety validation guidance, accessed 2026-09-23:** validation checks implemented protective measures and safety functions; deeper validation includes safety-function tests, installation checks, fault simulation, SRS inspection and safety-related implementation review.
- **DOC-CONFIRMED — SICK stop-time measurement guidance, accessed 2026-09-23:** machine stopping time is measured from triggering a stop signal to cessation of dangerous movement and is used to determine minimum safeguard distance. Measurement is required before initial commissioning and after significant/expected usage-related changes such as brake wear.
- **INFERENCE:** therefore a software timestamp or drive status bit cannot substitute for physical stopping evidence when the SRS proposition is cessation before access to the hazard.

## SRS-to-validation matrix

| Representative SRS requirement | Preconditions / mode | Stimulus or fault | Physical proposition to establish | Required evidence | Acceptance criterion | Revalidation triggers |
|---|---|---|---|---|---|---|
| E-stop demand places machine in specified safe state and prevents unexpected restart | Defined production/setup state; hazards identified; test safely bounded | Operate each E-stop; include credible single faults where architecture requires | Hazardous motion/energy follows the specified stop strategy and remains inhibited until valid reset/rearm sequence | Independent observation/measurement of relevant motion/energy plus safety-system state; final-element feedback only for propositions it can witness | Every stated SRS response occurs within the machine-specific validated limits; release/reset alone does not initiate hazardous motion | E-stop device/wiring/logic/final-element changes; stop-strategy changes; brake/load/mechanical changes affecting stopping behavior |
| Opening movable guard invokes required protective response | Machine in each applicable operating mode | Open/interfere with guard; test plausible sensor/wiring faults | Dangerous state ceases or access remains prevented according to SRS; guard state is not treated as proof of cessation | Guard/interlock state plus independent physical evidence of cessation or validated guard locking/access prevention | Access cannot occur before the SRS-defined dangerous state is ended, or locking remains effective until release conditions are physically satisfied | Interlock/actuator mounting, guard geometry, locking logic, stop behavior, tool/load, drive/brake changes |
| STO demand prevents torque production as allocated by SRS | Drive enabled; representative relevant load/mode | Demand STO through each allocated safety channel/path | Drive cannot generate torque; any coast/gravity/backdrive residual hazard remains separately controlled | STO diagnostics plus physical motion observation/measurement and any independent restraint evidence required by hazard analysis | Torque-prevention proposition satisfied; any required cessation/restraint proposition separately satisfied | Drive/firmware/parameters, motor, feedback, load/inertia, brake/restraint, wiring or safety-controller changes |
| Fluid-power safety function reaches defined safe state | Representative pressure/load; test remotely/isolated if hazardous | Demand isolation/dump/holding function; inject only safely justified faults | Required supply isolation, decompression and/or load holding are each physically achieved as specified | Appropriate pressure/position/load-restraint evidence; command bit and valve feedback are supporting evidence only | Each SRS physical proposition is met under stated conditions; no invented generic pressure threshold | Valve/actuator/plumbing, accumulator, load, hose routing, pressure setting, restraint or maintenance-procedure changes |
| Reset/rearm restores eligibility without causing unexpected hazardous motion | Safety demand cleared; protected space verified per design | Operate reset/rearm; include power restoration | Reset acknowledges/restores eligibility only; hazardous motion requires a separate valid start command where SRS requires it | Independent observation of machine motion plus safety-state transition | No hazardous motion from reset, guard closure, field clearing, E-stop release or power restoration alone unless explicitly justified and validated | Reset location/visibility, logic, mode handling, HMI, power-up behavior, cell layout or access changes |

## Adversarial commissioning cases

### A — E-stop bits look perfect, contactor power path remains hazardous
Safety controller sees the E-stop, outputs go false and EDM appears healthy, but an incorrectly selected/wired witness contact does not represent the actual power pole. **Result:** software evidence passes; physical energy-removal proposition fails. Validate the final physical effect and witness-contact relationship.

### B — Guard-open status is correct, spindle still coasts through access time
Interlock status and stop command are correct, but actual coast time has increased with changed tooling/inertia or degraded braking. **Result:** logic passes; access-before-cessation requirement can fail. Re-measure stopping behavior when the relevant physical assumptions change.

### C — STO status is asserted, gravity axis moves
Drive reports STO active and torque production is disabled, but gravity/backdrive can move the load. **Result:** STO proposition may pass while the machine safe-state proposition fails. Validate required holding/restraint independently.

### D — Dump command and valve feedback pass, trapped pressure remains
Controller commands a dump valve and receives expected feedback, but an accumulator, blocked branch or trapped volume retains hazardous energy. **Result:** valve-state evidence passes; decompression proposition fails. Measure the relevant physical state and trace trapped-energy paths.

### E — Reset state machine passes, reset station has a blind zone
Reset does not directly issue cycle start, but the operator cannot see a person remaining inside the protected space and subsequent normal start is possible. **Result:** Boolean reset semantics pass while occupancy/restart architecture is inadequate. Validate visibility/occupancy assumptions and the complete restart sequence.

## Stopping-time lifecycle rule

SICK's current stop-time material states that protective distance depends on actual machine stopping behavior throughout machine life and explicitly identifies brake wear as a change that stop-time measurement can reveal. Therefore:

- establish baseline stopping evidence before initial commissioning where the safety function depends on it;
- repeat measurement after significant changes or expected usage-related changes that can alter stopping behavior;
- preserve machine state, load/tooling/mode, measurement method and instrument identity with the result;
- do not create a universal calendar interval or margin without the machine's SRS, manufacturer assumptions and applicable standard/design evidence.

Freeze: **STOPPING TIME ON COMMISSIONING DAY != STOPPING TIME PROVED FOR ALL FUTURE MACHINE STATES.**

Freeze: **STATUS BIT TIMING != PHYSICAL CESSATION TIMING.**

## Exceptional-mode / muting / override reconciliation

Existing 25E0 exception-state material is specialist validation evidence, not an alternate core syllabus. Any intentional exception must be validated as a state transition with at least:

1. entry eligibility and authority;
2. the exact normal safeguard being suspended or altered;
3. the alternate protective strategy and its physical proposition;
4. bounded duration/persistence and mode restrictions;
5. fault behavior while exceptional mode is active;
6. exit conditions and behavior on loss of enabling conditions;
7. power-cycle/restart behavior;
8. explicit return-to-production checks proving normal safeguards are restored;
9. recorded change/revalidation consequences if the exception logic, sensors, timing or physical process changes.

Freeze: **MUTING/OVERRIDE COMMAND ACCEPTED != EXCEPTIONAL MODE SAFELY VALIDATED.**

Freeze: **RETURN TO NORMAL SOFTWARE STATE != PRODUCTION SAFEGUARDS PHYSICALLY RESTORED.**

## Proof-test interval reasoning

A proof-test interval is not selected because monthly/annual testing sounds prudent. Start with the latent dangerous failure assumed by the architecture or integrity calculation, identify the test that can actually expose it, then use applicable manufacturer/integrity assumptions, demand/usage, environment and change history to justify the interval. If those inputs are unavailable, the interval remains **UNKNOWN** rather than being invented.

## LinuxCNC / FPGA boundary

LinuxCNC and the ordinary FPGA may log commands, timestamps, diagnostics and test context. Those records are useful corroborating evidence but cannot be the sole witness for a personnel-safety physical proposition controlled by the same ordinary system. Independent physical evidence remains necessary where the SRS concerns actual motion, isolation, pressure, restraint or access.

## Next work

1. Perform the 25E0 line-by-line syllabus/competency coverage audit against the safety-course syllabus.
2. Inspect existing exceptional-mode artifacts by exact filename and link them into the canonical learner route without duplicating solution content.
3. If a genuine gap exists, fill only that gap; otherwise create the canonical learner route/release gate and a separate information-separated no-solution evaluator handoff.
4. Keep machine-specific stopping limits, proof-test intervals and quantitative integrity claims UNKNOWN until justified evidence exists.
5. No executable compute is justified by this artifact.