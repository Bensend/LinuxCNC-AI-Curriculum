# 3600 press-brake hydraulic mode transition review matrix

Date: 2026-09-11
Status: **dependency-safe architecture/review artifact; not a machine valve truth table**

## Purpose

Turn the current public press-brake and adjacent hydraulic evidence into a review surface that a future implementation can apply without pretending unavailable machine-specific behavior is known.

The matrix separates:

1. semantic press-cycle ownership;
2. abstract hydraulic/process mode;
3. ordinary actuator authorization;
4. physical/process completion witnesses;
5. timeout/abort ownership;
6. functional-safety functions, which remain separate and are not inferred from LinuxCNC software.

Evidence basis:

- Accurpress public HAL/COMP chronology: executable single-ram state and pressure-limit behavior;
- Ursviken/Pullmax diary: proposed generic `motion_type_cmd` contract including pressure dump, later successful physical Y1/Y2 bending, but final decoder source unavailable;
- 2018 two-cylinder project: community source skeleton plus field-reported stateful valve-actuator position loss under hydraulic disturbance;
- adjacent `powerchuck`: command/interlock plus `addf`-ordering warning;
- adjacent lubrication examples: command -> pressure witness -> fault, plus blocking-wait failure pattern;
- pinned LinuxCNC `timedelay.comp`: realtime qualification primitive, not policy.

## Governing rule

For each active mode, answer:

`What are we trying to do? -> what physical mode is requested? -> is it still authorized? -> did the physical plant do it? -> how do we know it finished? -> what aborts it? -> what state is safe/consistent to enter next?`

Do not replace any of those questions with a signal name.

## Transition review matrix

| Abstract mode | Semantic owner / intent | Generic command surfaces | Required ordinary authorization checked at required control rate | Physical/process witnesses | Completion predicate | Timeout/fault owner | Ordinary abort / reconciliation requirement | Machine-specific UNKNOWN that must not be invented |
|---|---|---|---|---|---|---|---|---|
| **HALT / IDLE** | cycle state machine; no active bend motion | zero/neutral motion request; decoder-defined non-driving valve state | machine-enable state; field-I/O health as required | Y1/Y2 stationary trend; pressure state where relevant | stable non-commanded state, if a transition requires proof | state/decoder layer depending on reason for halt | retain fault/stop reason; do not silently resume previous active state | exact valve neutralization, pump/relief state, pressure-retention behavior |
| **FAST APPROACH / DOWN FAST** | move ram toward change point with no bending load intended | target position/velocity + abstract fast-down mode | cycle authorization + pedal policy + fast Y1/Y2 mismatch/ferror checks + decoder/I/O health | independent Y1/Y2 scales; command saturation; relevant valve/drive witnesses | both sides reach change-point condition within allowed disagreement | motion/sync layer for fast side errors; cycle owner for process timeout | inhibit/transition according to machine hydraulic design; reconcile actual Y positions before retry | gravity-down vs powered-down valve combination, exact change-point criteria, gains/limits |
| **SLOW BEND / DOWN SLOW** | controlled working stroke | bend target/velocity + tonnage/pressure request + slow-down mode | same as above plus pressure/process validity and bend-program state | Y1/Y2 scales; pressure/tonnage sensor; actuator command/saturation witnesses | bend target/angle/position/process condition reached | realtime motion/sync for side faults; cycle/process owner for pressure-not-achieved or process timeout | stop further bend authority; machine-specific pressure release/return path; retain cause | exact proportional-valve direction, pressure limit, tonnage conversion, allowable dynamics |
| **DWELL / HOLD** | intentionally maintain bend/position/process condition for bounded time or event | hold target + abstract dwell mode | authorization must remain live; fault checks continue during dwell | position/differential; pressure where hold pressure matters | dwell timer/event satisfied while required witnesses remain valid | cycle state owns dwell timing; underlying layers own fast faults | leave dwell through explicit success or abort, never through a blocking sleep that ignores faults | whether pressure is actively held, unloaded, or compensated; legal dwell criteria |
| **PRESSURE DUMP / DECOMPRESSION** | remove stored hydraulic/tooling load before return or another mode | explicit abstract pressure-dump/decompression mode; possibly no new geometric target | authorization and field-I/O health still evaluated; exact safety/ordinary policy is machine-specific | **measured pressure decay is the primary generic process witness**; Y1/Y2 should remain observable; valve/actuator witnesses if fitted | measured pressure satisfies machine-defined decompressed condition, optionally stable for qualification time | cycle/hydraulic-process state owns completion timeout; realtime layers still own Y1/Y2/transport faults | on timeout or disagreement, enter explicit fault state and inhibit unproven next motion; on enable loss, follow machine-defined hydraulic/safety response, not an invented zero-position command | Pullmax spool truth table, relief command, target pressure, allowable decay time, whether ram motion is permitted/expected during dump |
| **RETURN / UP** | return ram after bend/decompression | target top/reference position + up mode | machine/cycle authorization; Y1/Y2 fault checks; required decompression prerequisite if machine needs it | independent Y1/Y2 scales; pressure where return mode depends on it | top/return target and required process conditions reached | motion/sync plus cycle timeout | halt/fault with actual-position reconciliation; never assume both sides returned because common target was issued | up-valve combination, pump mode, exact pressure prerequisites |
| **HOMING / REFERENCE** | establish coordinate truth, not production bend cycle | LinuxCNC homing/joint reference request or explicitly justified machine-specific mode | homing prerequisites, machine enable, feedback health | actual home/index switches/encoder index/scale feedback as appropriate | LinuxCNC or machine-specific homing completion state proves reference acquired | homing owner; do not duplicate ownership ambiguously between cycle component and MOTION | abort homing on fault/disable; referenced state must not be asserted after incomplete sequence | exact homing direction/speed/sensors; whether ram can use generic LinuxCNC homing on this hydraulic architecture |

## Cross-cutting final-output authorization matrix

Regardless of semantic mode, review the final actuator publication chain separately.

| Check | Required question | Evidence lesson |
|---|---|---|
| Producer freshness | Were physical inputs read before state/decoder evaluation? | Accurpress 2021->2022 chronology showed one-period age boundaries can be fixed by `addf` order. |
| Semantic validity | Is the requested abstract mode valid for this exact machine? | Ursviken builder proposed per-machine allowed mode lists; not every manifold supports every abstract mode. |
| Decoder validity | Did an inspectable machine-specific decoder map the abstract mode to outputs? | Final Pullmax decoder source is unavailable; therefore no truth table may be claimed. |
| Authorization | Are machine enable, relevant pedal/process permissions and ordinary fault gates applied **before** hardware write? | Powerchuck posted HAL demonstrates why a decoder after `hm2.write` produces an extra-period command-age boundary. |
| Saturation | Are final-side actuator commands bounded and is actual saturation observable? | PB-PREP-001 showed test conclusions depend on witnessing the final allocation/saturation surface, not merely upstream PID state. |
| Publication | Does hardware write publish this invocation's newly authorized command? | Same-thread membership alone is insufficient; `addf` order defines data age. |
| Completion | Is physical effect independently observed? | Lube example explicitly checks pressure after pump command; 2018 valve actuator lost commanded position under hydraulic disturbance. |
| Diagnostic retention | If the mode aborts, can the operator/diagnostic layer distinguish why? | A timeout without causal witness cannot distinguish feedback, hydraulic, interlock, transport, or process failures. |

## Decompression call-flow contract

Because decompression is the most important currently unverified mode, future source/config review should be able to instantiate this chain with real symbols:

```text
bend/hold completion
  -> press-cycle state requests DECOMPRESSION
  -> machine-specific decoder validates DECOMPRESSION is supported
  -> ordinary authorization/fault gate evaluates current inputs
  -> decoder creates final valve/relief requests
  -> final limits/saturation applied
  -> hardware write publishes the authorized request
  -> plant pressure changes
  -> pressure sensor acquired on subsequent control iterations
  -> pressure qualification checks machine-defined completion condition
      -> success: transition to RETURN (or next defined state)
      -> timeout: DECOMPRESSION_FAULT / cycle abort
      -> other fault/disable: explicit abort branch, not implicit fall-through
  -> retained diagnostic records reason and useful witnesses
```

The generic curriculum deliberately leaves blank the exact spool combination, relief-current command, pressure threshold, and timeout because those are machine-specific and can be safety-significant.

## Adversarial scenario 1 — enable loss during decompression

**Scenario:** A decompression state has just commanded the hydraulic decoder. Pressure is still above the machine's completion threshold. Ordinary machine-enable then becomes false.

**Invalid reasoning:** “Set the ram position target to its current value and continue.”

**Why invalid:** geometric command and stored hydraulic energy are different state variables. Current-position hold does not prove pressure has been released or valves reached a non-driving state.

**Required reasoning:**

1. the control path must detect the authorization change at a documented rate;
2. the machine-specific decoder/safety architecture determines what output transition is permissible/required;
3. pressure remains a process witness and must not be assumed zero;
4. the cycle cannot declare decompression complete without its completion condition;
5. re-enable requires state reconciliation rather than blindly resuming the interrupted mode.

No generic software artifact here establishes the functional-safety response to actual emergency-stop/safeguard removal.

## Adversarial scenario 2 — valve command changes, pressure does not

**Scenario:** The decoder requests pressure dump; the final command witness changes as expected, but measured pressure remains approximately constant until the process timeout expires.

**Invalid reasoning:** “The output command proves the dump valve actuated; therefore the pressure sensor must be bad.”

**Competing hypotheses include:**

- output driver or field-I/O failure;
- coil fault;
- spool stuck/not mechanically following command;
- incorrect decoder truth table;
- blocked hydraulic path;
- relief/dump valve saturation/non-response;
- pressure sensor or acquisition failure;
- stale diagnostic observation.

**Required fault classification:** command accepted but physical completion unproven. Preserve command, authorization, pressure history and I/O-health witnesses. Do not select one physical cause without discriminating evidence.

The 2018 field report is specifically evidence that an intermediate valve actuator can diverge mechanically from its command, so blaming only the process sensor would be unjustified.

## Adversarial scenario 3 — dwell implemented with `sleep(2)`

**Reject for a state that must remain responsive to fast ordinary-control faults.** The adjacent lubrication Python illustrates that a blocking sleep prevents the same loop from reconsidering its predicates. A dwell should be an explicit state whose elapsed-time bookkeeping advances while required fault/authorization predicates are still evaluated at their assigned rate.

## Evidence boundary

This matrix is a **review contract / inference synthesized from public evidence**, not a ready-to-wire hydraulic design. It intentionally does not state:

- a generic press-brake coil truth table;
- a generic pressure or tonnage limit;
- generic decompression time;
- generic safe-stop valve state;
- that LinuxCNC/HAL alone is a safety-rated safeguarding system.

Those require the actual machine hydraulic/electrical design, actuator/sensor characteristics, risk assessment and applicable requirements.

## Precise next-work checkpoint

1. Use this matrix to inspect one **executable LinuxCNC state machine with a nontrivial process transition** (press-brake preferred; adjacent hydraulic/process machine acceptable if clearly labeled) and score which matrix fields are actually evidenced vs missing.
2. Prioritize an implementation where an active state continuously rechecks an interlock/fault and where a completion sensor drives a state transition, so the current blocking-wait inference can be compared against executable realtime code.
3. Trace exact function scheduling and output publication order; do not infer same-cycle behavior from shared thread membership.
4. If no stronger public hydraulic source is found after one bounded search, stop searching and move the 3600 work to a formal source-quality/evidence-gap section plus a simulation contract for generic mode ownership—not machine valve dynamics.
5. Preserve S02/E20/X01/X02 information separation; F02 remains blocked. PB-PREP-001 remains INCONCLUSIVE and must not be retuned.
