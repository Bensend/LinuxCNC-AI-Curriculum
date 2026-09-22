# 2520 — Fault Analysis, Diagnostic Design, and Residual Physical Proposition

## Purpose

This stage sits after safety-function derivation/composition and before component selection or integrity arithmetic. Its job is to ask, for every allocated safety function: **how can the claimed function become unavailable, wrong, late, misleading, or falsely appear healthy, and what evidence would actually reveal that?**

Do not start with a favorite relay, PLC, OSSD device, STO input, valve, or diagnostic feature. Start with the required physical proposition and allocated function.

## Evidence vocabulary

Use the repository evidence classes exactly: `DOC-CONFIRMED`, `SOURCE-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`.

### Professional evidence anchors

- **DOC-CONFIRMED — Pilz test pulses:** appropriately wired test-pulse outputs apply defined pulses to inputs so shorts across contacts can be detected. This proves a particular diagnostic mechanism; it does not prove every wiring fault, the field device's mechanics, or the machine's physical safe state. Source: Pilz, “Test pulse output,” https://www.pilz.com/en-US/support/lexicon/articles/072903
- **DOC-CONFIRMED — Rockwell safety input discrepancy:** Rockwell safety I/O supports transition/discrepancy timing and input-error latching. Dual-channel monitoring can detect channels remaining inconsistent beyond a configured interval. Where discrepancy is monitored changes diagnostic information; it does not automatically change the safety rating. Sources: Rockwell 5069 Safety Discrete input operation/point parameters.
- **DOC-CONFIRMED — Rockwell MSR57P:** documented input faults include channel-to-24-V, channel-to-ground, channel-to-channel shorts, overcurrent, and dual-channel discrepancy. The relay also retains a fault history. Source: Rockwell 440R-UM004D-EN-P.

These examples establish that professional systems deliberately design diagnostics around **specific fault hypotheses**. They do not justify assuming that any diagnostic status is complete physical proof.

## Core method

For each `SF-*`, work outward from its physical proposition and allocation:

`SF -> required PROP -> allocated input/logic/final element -> DEP -> credible fault -> effect -> detection mechanism -> detection time requirement -> diagnostic reaction -> residual PROP -> EVID -> VAL`

### Step 1 — Name the proposition that must remain true

Example form:

- `PROP-GUARD-01`: hazardous motion is prevented while full-body access is possible.
- `PROP-GRAV-01`: the gravity-driven load is physically prevented from hazardous descent under the defined access condition.

Do not substitute “safety output is off” for a physical proposition unless the architecture has already established that equivalence.

### Step 2 — Enumerate faults by allocated element and dependency

At minimum challenge:

1. **Input/sensor faults** — stuck state, short to supply/return, cross-short, open circuit, mechanical displacement, common mounting movement, contamination, loss of field power.
2. **Logic/communication faults** — invalid data, lost connection, stale data, configuration mismatch, loss/restart of safety authority, diagnostic masking.
3. **Final-element faults** — welded/stuck contact, actuator/valve/drive command not producing the required physical state, mechanical binding, stored energy, failed brake/load-holding path.
4. **Dependency/common-cause faults** — shared field supply, common connector/cable, common mechanical mount, shared network infrastructure, shared final element, environmental insult, maintenance error.
5. **Latent faults** — a fault that can remain hidden during normal operation and matters when another fault or demand occurs.

Do not invent failure rates, diagnostic coverage percentages, PL/SIL targets, proof intervals, hydraulic truth tables, or stopping criteria.

### Step 3 — State the effect before choosing detection

Ask: if this fault exists, what claim becomes false, unavailable, stale, or unknown?

A useful effect taxonomy:

- `SAFE-DETECTED`: function moves/holds safe and the fault is visible.
- `DANGEROUS-DETECTED`: safety capability is impaired and detection must cause an appropriate safe/inhibited reaction.
- `DANGEROUS-UNDETECTED`: the architecture currently has no adequate witness; this is a design gap, not permission to assume low probability.
- `EVIDENCE-UNAVAILABLE`: the physical state may be unchanged but required evidence cannot currently be obtained.
- `PROPOSITION-STALE`: prior accepted evidence is no longer valid for the present physical configuration/condition.
- `UNKNOWN`: evidence does not support a stronger classification.

### Step 4 — Define what must detect the fault, and when

Detection timing is part of the requirement. Distinguish:

- continuously/on-line;
- on every demand;
- before reset/rearm;
- at startup/reintegration;
- periodic proof/inspection;
- after maintenance/change;
- before personnel exposure.

A discrepancy timer is not automatically the right answer. Its acceptable value is application-specific and remains `UNKNOWN` until derived from the function and machine timing constraints.

### Step 5 — Map diagnostic to the proposition it actually supports

Examples:

- pulse-test fault -> supports a wiring-integrity proposition for the covered circuit;
- dual-channel discrepancy -> supports channel-consistency/change-behavior propositions;
- safety-network valid -> supports transport/data-validity proposition;
- EDM/feedback -> may support an external-device-state proposition;
- pressure switch -> may support a bounded pressure-state proposition if architecture, placement, thresholds and failure behavior justify it;
- encoder standstill monitor -> may support a defined motion proposition if the safety architecture and validation establish it.

None of these automatically proves personnel clear, guard geometry, stored energy removed, gravity load held, stopping distance acceptable, or the entire machine safe.

### Step 6 — Specify diagnostic reaction separately from production behavior

For each detected fault state:

- what safety output/reaction occurs;
- what remains inhibited;
- whether reset is blocked;
- what evidence must be reacquired;
- whether a fresh ordinary start is required;
- what durable `FIND-*` or maintenance obligation is created;
- whether remote/isolated diagnosis is required because minimum safe-to-operate conditions are not met.

Ordinary LinuxCNC/FPGA/HMI may display and assist diagnosis but must not become personnel-safety authority merely because it has convenient state information.

### Step 7 — Challenge common cause and diagnostic independence

For every pair of supposedly independent channels/witnesses ask `show where used` on `DEP-*` records. Two sensors sharing one moving bracket, one field supply, one connector, one pressure source, one network device, or one final element may not provide the independence implied by a block diagram.

A diagnostic can also share the failure it is intended to diagnose. Record that explicitly.

### Step 8 — Treat nuisance trips as engineering evidence

Repeated nuisance faults create predictable bypass pressure. Do not weaken discrepancy checking, suppress safety faults in LinuxCNC, or defeat a guard simply to restore production. Investigate whether the cause is bad geometry, timing derived incorrectly, contamination, poor wiring, wrong device/application choice, unstable power, process behavior, or an unsuitable operating mode. Make legitimate operation easier than defeat.

## Compact worksheet

| ID | SF / required PROP | Allocated element or DEP | Credible fault | Effect on proposition | Detection mechanism | Must detect when? | Diagnostic reaction | Residual PROP after reaction | Required EVID / VAL | Evidence class / UNKNOWN |
|---|---|---|---|---|---|---|---|---|---|---|
| FLT-001 | SF-... / PROP-... | DEP-... | ... | ... | ... | ... | ... | ... | ... | ... |

For each row, add a reverse trace to every other function that uses the same `DEP-*`.

## Worked adversarial example — automated cut/feed cell

Assume the previously derived generic cell has a guard function, E-stop function, setup/enabling function, rotating tool, feed motion, and pneumatic tooling.

1. **Guard channel cross-short.** Test pulses may detect the covered cross-contact wiring fault (`DOC-CONFIRMED` mechanism). The diagnostic supports wiring integrity, not guard-door mechanical alignment and not personnel-clear state.
2. **Both guard sensors move with the same bent bracket.** Channel agreement can remain perfect. `INFERENCE`: dual-channel agreement alone cannot expose a common mechanical displacement that preserves agreement. The affected guard-geometry proposition becomes stale/unknown until physically checked.
3. **Shared 24-V field supply is lost.** Several inputs may simultaneously become unavailable/safe-state depending on their documented architecture. Reverse trace the shared `DEP-24V-*`; do not treat the resulting multiple channel changes as independent evidence.
4. **Final contactor/drive path does not reach the required physical state.** Input diagnostics can remain healthy. A separate final-element/process witness is required if the safety proposition depends on that physical state.
5. **LinuxCNC reports machine idle.** This is ordinary-control evidence only. It cannot clear the safety fault or substitute for independent proof.

## Gravity/fluid-power stress test

For a generic vertical/gravity-loaded axis, do **not** invent valve states, brake capacity, pressure limits, or stopping distances.

Start with a physical proposition such as `PROP-GRAV-01: hazardous descent is prevented during defined personnel access`.

Challenge at least:

- command path reaches safe command but load-holding element mechanically fails;
- pressure/position witness fails high or remains stale;
- two electrical channels share one hydraulic/mechanical final element;
- trapped/stored fluid energy remains after electrical isolation;
- common contamination or maintenance error affects multiple valves/witnesses;
- diagnostic status is healthy while the physical load-holding proof is stale.

If no evidence establishes how the particular machine holds the load, the correct conclusion is `UNKNOWN`; people must not be exposed while relying on an unproved assumption. Experimental operation, if necessary, must be isolated/remote with people outside the danger zone and residual risk explicit.

## Frozen distinctions

- **FAULT DETECTED != PHYSICAL SAFE STATE PROVED.**
- **DUAL-CHANNEL AGREEMENT != COMMON-CAUSE INDEPENDENCE.**
- **DIAGNOSTIC COVERAGE FEATURE PRESENT != APPLICATION DIAGNOSTIC COVERAGE ESTABLISHED.**
- **DISCREPANCY TIMER CONFIGURED != DISCREPANCY TIME JUSTIFIED.**
- **PULSE TEST HEALTHY != SENSOR MECHANICS / GUARD GEOMETRY VALIDATED.**
- **SAFETY NETWORK HEALTHY != FINAL ELEMENT / PROCESS RESPONSE PROVED.**
- **DIAGNOSTIC RESET != FAULT CAUSE CORRECTED != RETURN-TO-SERVICE ACCEPTED.**
- **NUISANCE TRIP != PERMISSION TO WEAKEN SAFETY DIAGNOSTICS.**
- **TWO CHANNELS != TWO INDEPENDENT PHYSICAL WITNESSES.**
- **UNKNOWN DIAGNOSTIC SUFFICIENCY != PERMISSION TO INVENT A NUMBER.**

## Exit criteria

Before moving to architecture/component selection, the learner must be able to:

1. trace every important `SF-*` through credible faults and shared dependencies;
2. state what each diagnostic actually proves and does not prove;
3. identify dangerous-undetected and latent-fault gaps without hiding them behind component ratings;
4. define diagnostic reaction and re-proof obligations;
5. identify common-cause paths with reverse dependency tracing;
6. preserve `UNKNOWN` for design-specific timing/integrity/physical facts not yet established;
7. keep ordinary LinuxCNC/FPGA control separate from independent safety authority.
