# R-SAFE-09 — Safety PLC and Safety Relay Patent Research Track

## Purpose

Treat patents as a primary engineering-learning source for the Practical Machine Safety Engineering curriculum. The goal is to mine decades of safety-controller, safety-relay, safety-I/O, and fault-detection engineering for reusable ideas, failure modes, test methods, and low-cost design patterns.

This track is ongoing. It should continue to add patent families whenever they materially teach how a safety function is implemented, monitored, fault-tested, or recovered.

Patents are evidence and design-history sources, not automatic permission to reproduce an active claimed invention. Legal-status fields from public databases are useful research metadata but should be independently verified before any commercial implementation decision. Expired/ceased families are especially useful for reconstruction and comparison, while active families remain valuable for understanding modern engineering approaches.

## Priority research themes

1. Redundant series relay contacts and independently actuated relays
2. Welded-contact detection and mirror/force-guided contact monitoring
3. Direct voltage/current sensing of relay/contact state
4. Sequential proof testing of relays without defeating the safety function
5. Dual-processor and heterogeneous processor safety PLCs
6. Cross-checking, watchdogs, heartbeat monitoring, lockstep and diverse execution
7. Safety input test pulses, cross-short detection, line-fault detection and discrepancy timing
8. Safety output modules, STO/contactor/valve driving, EDM and output readback
9. Hardware-safe-state circuits that do not depend on normal PLC software
10. Controlled-stop then forced-safe-state sequences
11. Surge suppression, arc suppression, inrush control and methods that reduce contact welding in the first place
12. Self-test and fault-injection structures for sensors, processors, memories, I/O and communications
13. Safe communications / black-channel monitoring, CRCs, counters, timing and sequence checks
14. Guard/E-stop dual-channel monitoring architectures
15. Low-cost alternatives to force-guided relays or high-cost safety modules

## Required capture fields for every patent family

For each family, record:

- patent/publication number(s)
- family/priority date
- assignee and inventors
- reported legal status and source/date checked
- problem being solved
- core architecture in plain language
- safety function(s) involved
- faults explicitly detected
- faults apparently not detected or deferred to another subsystem
- redundancy strategy
- diagnostic strategy
- proof-test strategy
- safe-state behavior
- components or ideas that appear reusable in a low-cost open design
- ideas that are only useful for understanding commercial-rated designs
- any especially useful figures/claims to reconstruct
- related prior-art patents cited by the family
- whether the family deserves a full teardown

## Initial patent families and findings

### 1. Fisher-Rosemount / Emerson — independently testable series relay contacts

**US20080079318A1 / US7582989B2** — “Safety relay having independently testable contacts”

- Priority: 2006-09-29
- Assignee: Fisher-Rosemount Systems, Inc.
- Public database status observed 2026-09-15: active; Google Patents reports adjusted expiration 2027-06-06.
- Core idea: multiple relay contacts in series, each relay coil independently controllable; controller deliberately opens individual contacts and measures an electrical characteristic such as voltage/potential/current to determine whether the selected contact actually opened.
- Explicit target: identify inoperable/welded contacts while retaining redundant series interruption.
- Why it matters: this is the closest prior art yet found to the proposed OpenPressBrake-style `K1 -> sense A -> K2 -> sense B -> K3 -> sense C` architecture.
- Deep teardown: **YES — highest priority.** Reconstruct figures 4–9 and the test-state machine. Compare sensing placement to our per-node voltage sensing.

### 2. Rockwell Automation — power-contactor weld monitoring

**US6611416B1** — “Safety relay circuit for large power contactors”

- Priority: 2002-05-10
- Assignee: Rockwell Automation Technologies, Inc.
- Public database status observed 2026-09-15: expired — lifetime.
- Core idea: monitor the main contacts and mirror/auxiliary contacts of a large power contactor and inhibit restart when the contactor state is inconsistent with the commanded state.
- Detects: welded main contacts and failures/welding in auxiliary monitoring contacts.
- Why it matters: an expired commercial safety circuit with detailed ladder-style logic is ideal for reconstruction, fault-table analysis, and comparison with direct electrical sensing.
- Deep teardown: **YES — highest priority.** Rebuild the ladder and enumerate each monitored failure path.

### 3. JTEKT — low-cost relay weld detection using ordinary relays

**US7459910B2 / US20070029286A1** — “Contact welding detecting device for relay”

- Priority: 2005-07-13
- Assignee: JTEKT Corporation
- Public database status observed 2026-09-15: expired — fee related.
- Stated motivation: conventional mechanically safe/force-guided relays make output modules larger and more expensive; goal is to obtain comparable contact-welding examination while preserving smaller size and lower price.
- Core idea: use ordinary relay/contact arrangements plus potential-difference detection to determine whether contacts have welded.
- Why it matters: directly aligned with the curriculum mission of replacing expensive assumptions with measurable diagnostics where appropriate.
- Deep teardown: **YES — highest priority.** Reconstruct the sensing network and compare its fault coverage against force-guided contacts and our A/B/C node sensing.

### 4. Rockwell Automation family — dual-mode safety input sensing and test pulses

**US11029660B2 / US20180329385A1** — “Safety input system for monitoring a sensor in an industrial automation system”

- Priority: 2017-05-15
- Public database status observed 2026-09-15: active; reported expiration 2038-09-27.
- Core idea: two different detection methods monitor the same sensor signal (for example voltage-threshold and current/voltage-threshold paths), with outputs supplied to separate processors. Each processor can inject test signals for the other path to observe.
- Includes periodic pulse testing and cross-comparison.
- Published discussion explicitly targets fault tolerance, over-voltage robustness and Category 3 / PL d style architecture for a single channel.
- Why it matters: excellent source for designing cheap active-tested E-stop/guard/proximity-sensor inputs and understanding why simple duplicated GPIOs are not enough.
- Deep teardown: **YES — very high priority.** Reconstruct the two dissimilar front ends, test-pulse timing and cross-check behavior.

### 5. Chinese Academy of Sciences — heterogeneous ARM + FPGA safety PLC

**CN108073105B** — “Safety PLC device based on heterogeneous dual-processor redundant structure and implementation method”

- Priority: 2016-11-18
- Assignee: Shenyang Institute of Computing Technology, Chinese Academy of Sciences
- Public database status observed 2026-09-15: active; anticipated expiration 2036-11-18.
- Core idea: ARM processor plus FPGA-hosted soft-core RISC processor independently execute safety-relevant real-time PLC logic; a safety diagnosis circuit cross-checks outputs/intermediate state and watchdogs/selection logic handle failures.
- Why it matters: highly relevant to the proposed inexpensive dedicated safety brain beside the main OpenPressBrake FPGA/controller. It is also a concrete example of processor diversity rather than simply duplicating identical CPUs.
- Deep teardown: **YES — high priority.** Map its architecture to a low-cost MCU + FPGA or MCU + independent watchdog/supervisor design.

### 6. Phoenix Contact — force-guided relay mechanism

**EP2645400B1 / DE102012006450A1 family** — “Relay with force-guided contacts”

- Priority: 2012-03-30
- Assignee: Phoenix Contact GmbH & Co. KG
- Public database status observed 2026-09-15: active in EP; anticipated expiration 2033-03-27.
- Core idea: mechanical construction of a relay with positively/force-guided NO and NC contacts so contradictory feedback states are mechanically prevented.
- Why it matters: lets the curriculum compare what a force-guided relay physically guarantees against what electrical node sensing and active proof testing can infer.
- Deep teardown: **YES — medium/high priority.** Focus on the mechanical guarantee and failure modes that electrical diagnostics cannot reproduce.

### 7. Phoenix Contact — multi-channel safety-device control

**EP2017869B1** — “Safety device using multiple channels to control a safety device”

- Priority family traces to 2005–2006 filings.
- Assignee: Phoenix Contact GmbH & Co. KG
- Public database status observed 2026-09-15: ceased in EP.
- Core subject: multi-channel control of safety devices, including E-stop, safety-door and two-hand control use cases.
- Why it matters: older multi-channel safety architecture with potentially reusable input/output diagnostic concepts.
- Deep teardown: **YES — medium priority**, especially because the EP status is ceased and the family contains several earlier German priority filings that may reveal additional useful prior art.

### 8. Phoenix Contact — bistable safety relay with self-test

**EP2546852B1** — “Bi-stable security relay”

- Priority: 2011-07-14
- Assignee: Phoenix Contact GmbH & Co. KG
- Public database status observed 2026-09-15: active; anticipated expiration 2032-07-03.
- Core subject: buffered bistable electromechanical safety switching device and a test method for monitoring the device.
- Why it matters: useful for power-loss behavior, energy-buffering questions and relay proof-testing without conventional continuously energized coils.
- Deep teardown: **YES — medium priority.** Determine whether any test method can improve our low-power or fail-safe output blocks.

### 9. Phoenix Contact — modular safety switching apparatus

**US11294345B2 / US20190049911A1** — “Safety switching apparatus”

- Priority: 2016-02-08
- Assignee: Phoenix Contact GmbH & Co. KG
- Public database status observed 2026-09-15: active; adjusted expiration 2037-06-21.
- Core subject: safety switching apparatus for safely operating/controlling multiple electrical devices using modular safety switching structures.
- Why it matters: likely useful for learning how modern commercial modules partition safety switching, expansion and diagnostic functions.
- Deep teardown: **YES — medium priority.** Focus on module partitioning and how faults are prevented from propagating across channels.

## Search/classification leads

Do not rely only on keyword searches. Mine patent classification trees and cited prior art.

Particularly useful classification leads already observed:

- **H01H47/002** — monitoring or fail-safe relay circuits
- **H01H47/004** — monitoring/fail-safe circuits using plural redundant serial relay-operated contacts
- **H01H47/005** — safety control circuits, including relay chains mutually monitoring one another
- **G05B19/048** — monitoring / safety in program-control systems
- safety PLC / redundant control classifications under G05B and related CPC subclasses

For every strong patent, inspect both “cited by” and “family cites” lists. Older patents frequently contain simpler circuits that are more useful for low-cost reference designs than the later commercial refinement.

## Deep-teardown order

### Tier 1 — reconstruct now

1. US7582989B2 — independently testable series relays
2. US6611416B1 — expired Rockwell contactor weld monitor
3. US7459910B2 — expired JTEKT low-cost weld detection
4. US11029660B2 — safety sensor input with dual/dissimilar sensing and pulse tests
5. CN108073105B — ARM + FPGA heterogeneous safety PLC

### Tier 2 — study after Tier 1

6. EP2645400B1 — force-guided relay physical mechanism
7. EP2017869B1 — multi-channel safety control
8. EP2546852B1 — bistable safety relay test method
9. US11294345B2 — modular safety switching apparatus

## Required teardown format

For each Tier-1 family, produce a standalone note with:

1. one-page plain-language architecture
2. reconstructed block diagram / ladder / state machine
3. component-level or logic-level operation
4. complete single-fault table where the patent gives enough information
5. what the patent assumes is handled elsewhere
6. what prevents a dangerous failure versus what merely diagnoses one
7. how restart is inhibited after a latent fault
8. whether the architecture survives one welded relay/contact
9. whether it survives two failures and under what assumptions
10. common-cause weaknesses
11. surge/inrush/contact-welding considerations
12. cheapest modern implementation that preserves the underlying idea
13. comparison against our low-/mid-/high-/gold-tier safety architecture
14. explicit list of ideas suitable for open educational reference designs
15. status note distinguishing technical learning from any IP/commercial-use question

## Ongoing discovery queries

Repeatedly search combinations of:

- safety PLC patent redundant processor
- safety PLC heterogeneous processor FPGA
- safety input test pulse patent
- safety output module patent welded contact
- force guided relay patent monitoring
- redundant series relay patent
- contactor weld detection patent
- safety relay proof test patent
- safety relay independently testable contact
- safety relay surge suppression contact welding
- safety controller watchdog cross check
- safety controller discrepancy timing
- dual channel E-stop test pulse patent
- safe torque off monitor patent
- monitored valve safety output patent
- black channel safety communication patent

Also search major assignees directly: Pilz, Siemens, Rockwell/Allen-Bradley, Phoenix Contact, Omron, Schneider, ABB/Jokab, SICK, Keyence, Pepperl+Fuchs, Weidmüller, Emerson/Fisher-Rosemount, Mitsubishi, Beckhoff and safety-IC vendors.

## Relationship to the low-cost safety design effort

The patent track should continuously feed R-SAFE-06 low-cost reference safety blocks. Each discovery should be tagged as one of:

- **directly reusable principle** — generic engineering idea that can inform an open reference design
- **commercial-grade refinement** — useful mainly to understand what higher-cost/rated systems add
- **diagnostic trick** — test pulse, voltage/current measurement, timing, state comparison, etc.
- **common-cause mitigation** — diversity, separate power, watchdog, independent authority
- **contact-life / anti-weld technique** — suppression, inrush limitation, sequenced switching
- **human-factors / restart behavior** — manual reset, discrepancy, restart inhibit
- **deep teardown required**

The research should always ask: **what actual risk reduction does this idea buy, what does it cost, and can the same benefit be achieved more simply without hiding a residual hazard?**
