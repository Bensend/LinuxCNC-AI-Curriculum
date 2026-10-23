# 4400 — GuardLink topology-change physical-proof card

**Scope:** educational worksheet based on Rockwell 432ES-IG3 manual `432ES-UM001E-EN-P`, June 2025, Chapter 5 pp. 49, 51, 58. Not a substitute for current selected manufacturer instructions or machine-specific commissioning procedure. No personnel-exposed live tests.

## Before changing the guard network

- Record `CHG-*`, original/current node order, catalog/firmware, channel, terminator location, guard-to-zone mapping and all safety program routines using node tags.
- Mark affected `DEP/ARC/VAL/PT` evidence **STALE** until reviewed. Identify people/modes/energy hazards and the minimum physical safe-state proposition.
- Read the exact selected manufacturer's topology-change instructions. A powered/hot-swappable installation capability does not eliminate verification/validation.

## Manufacturer-specific failure to recognize

Rockwell warns that appending a 432ES node without following the documented link-interruption/reconnection sequence can leave the added safety device **inactive in the safety function**. A guard can appear installed yet fail to create its intended protective demand. Do not use a healthy-looking HMI, stable `DeviceCount`, cleared fault or matching catalog label as proof that the new guard is effective.

## Commissioning evidence table — no invented results

| Evidence ID | Question | Selected device/configuration evidence | Witness / acceptance | Status |
|---|---|---|---|---|
| `CHG-*` | What changed, and which prior proofs are STALE? | | | |
| `BND/HAZ/ENE` | Who could be exposed to what energy in which mode? | | | |
| `SRS/PHY` | What actual protective action/physical state is required? | | | |
| `DEP/ARC` | Does exact guard/node/channel/terminator mapping match as-built wiring and safety logic? | | | |
| `AUTH` | Which independent safety-related control path owns demand and rearm? | | | |
| `VAL-input` | Does each added/replaced guard's demand reach its selected safety controller/output? | | | |
| `VAL-physical` | Is hazardous motion stopped/held or energy isolated as **separately** required? | | | |
| `VAL-restart` | Does deliberate rearm remain separate from ordinary start, with occupancy/visibility addressed? | | | |
| `HF` | Can a technician locate a fault and restore the guard without bypassing it? | | | |
| `UNK/RR/PT` | What remains unknown, what operational restriction applies, what inspection/proof test is required? | | | |

## Causal-test gate

Before crediting `VAL-input`, record the initial state of **all other protective demands**. If another guard is already open and the safety output is already OFF, opening the new guard does **not** prove the new guard participates. Do not mark PASS merely because `new guard open` and `output OFF` coexist. An approved isolated/low-energy test must demonstrate the new guard's own causal demand path, followed by independent final-element and physical-proposition evidence. Never bypass an active safeguard just to obtain a favorable test transition.

## Adversarial questions

1. A new rear gate is physically installed and the previous node count remains displayed. Can production resume? Explain why **not** without verifying the new gate participates in the safety function.
2. The new gate produces a correct input change, but the press-brake beam continues to descend. Which physical proposition fails, and why does an input PASS not authorize release?
3. A robot-cell gate closes and the safety controller accepts reset while a person remains inside. What occupancy and separate-start protection remains unproved?
4. A technician changes the node number while the controller is online. Which manufacturer mode/program-use restrictions and `CHG` dependencies must be reviewed?
5. A newly installed guard creates repeated nuisance trips. What inexpensive alignment, diagnostics and captive-hardware improvements reduce the foreseeable incentive to defeat it?

**Stop/release rule:** if the physical safety function is not independently established, do **not** operate with people exposed to the hazard. Experimental work requires isolation/remote control with all people outside the danger zone and explicit residual-risk controls.
