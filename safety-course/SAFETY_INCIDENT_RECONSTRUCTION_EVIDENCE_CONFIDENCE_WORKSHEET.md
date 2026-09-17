# Safety incident reconstruction — evidence confidence worksheet

Date: 2026-09-17
Lane: independent safety curriculum lane B

## Purpose

Provide a disciplined way to reconstruct a safety-related event from mixed safety-controller diagnostics, final-element feedback, ordinary LinuxCNC/FPGA logs, power/network discontinuities, maintenance actions and physical observations without forcing the evidence into a cleaner story than it supports.

This worksheet is deliberately separate from the primary lane's commissioning/common-cause/minimum-operate and mode-selection/EDM work. It does not assign machine-specific PL/SIL/DC, stopping distance, pressure threshold, hydraulic truth table or response-time acceptance value.

## Frozen rule

**A reconstruction is a set of evidence-bounded claims, not a story that must have a single complete ending. Conflicting, stale, missing or unsynchronized evidence stays visible. `UNKNOWN` is a valid conclusion.**

Never promote:

- ordinary LinuxCNC/HAL/FPGA command history into personnel-safety authority;
- safety-controller output state into proof that a downstream contactor, valve or drive changed state;
- EDM/auxiliary feedback into proof that every hazardous-energy path was harmless;
- a collector timestamp into exact event time when the source did not provide one;
- absence from a bounded/overflowed log into proof that an event did not occur.

## Evidence provenance labels

Use the curriculum labels on every material conclusion:

- `SOURCE-CONFIRMED` — directly supported by authoritative source/code/configuration evidence relevant to the implementation.
- `DOC-CONFIRMED` — directly supported by manufacturer/standards/official documentation.
- `TEST-CONFIRMED` — directly established by a controlled test on the relevant implementation.
- `COMMUNITY-REPORTED` — reported by a community/user source but not independently established.
- `INFERENCE` — reasoned conclusion from evidence; identify the premises and limits.
- `UNKNOWN` — evidence cannot support a stronger claim.

These labels describe provenance, not certainty by themselves. A `DOC-CONFIRMED` generic behavior may still be insufficient to prove what one particular machine physically did.

## Claim-confidence classes

For each claimed transition assign one reconstruction class:

| Class | Meaning | Minimum treatment |
|---|---|---|
| `DIRECTLY OBSERVED` | Relevant source or physical witness directly recorded/observed the claimed state or transition | Preserve source, native value, time quality and validity |
| `BOUNDED INFERENCE` | Evidence supports a limited conclusion but does not directly observe the full claim | State premises and explicitly bound what is not proven |
| `CONFLICTING` | Credible evidence sources disagree or cannot be reconciled | Preserve both; do not pick the convenient one without new evidence |
| `STALE` | Observation existed but freshness/continuity is insufficient at the claimed time | Treat current state as unknown unless another fresh witness exists |
| `UNKNOWN` | Missing, overwritten, unsynchronized, unobservable or otherwise insufficient evidence | Leave unresolved; identify evidence that could close it |

`DIRECTLY OBSERVED` does not automatically mean `safe`. It means only that the stated thing was actually observed by the identified witness.

## Case header

- Incident/case ID:
- Machine/cell ID:
- Date/time window under review:
- Investigator/reviewer:
- Machine configuration identity:
- Safety configuration/signature/checksum if available:
- LinuxCNC/HAL/FPGA build/config identity:
- Maintenance/test configuration active:
- Known temporary jumpers/forces/overrides/test fixtures:
- Known power cycles/reboots:
- Known network/logging gaps:
- Relevant physical evidence preserved:
- Evidence not available / reason:

If configuration identity cannot be established, record `UNKNOWN`; do not silently analyze the event against today's files.

## Source inventory and authority map

| Source ID | Source type | What it can actually observe | What it cannot prove | Native time/sequence? | Freshness/continuity known? | Provenance |
|---|---|---|---|---|---|---|
| | independent safety controller/device | | | | | |
| | EDM/final-element witness | | | | | |
| | drive safety diagnostics | | | | | |
| | energy/physical witness | | | | | |
| | LinuxCNC/HAL | ordinary control context only unless separately justified | personnel-safety authority | | | |
| | FPGA/controller | ordinary command/watchdog context only unless separately justified | physical hazardous-energy state | | | |
| | HMI/historian/collector | | | | | |
| | operator/maintenance testimony | | | | | |

Before chronology work, write the authority boundary. A source cannot prove a layer it does not observe merely because its timestamp is precise.

## Clock and sequence confidence

For every electronic source record:

- source-originated timestamp or collector-added?
- UTC/local/monotonic/cycle-counter/unknown basis?
- synchronization method and status known?
- boot/session identity known?
- counter rollover/reset possible?
- buffering/reordering possible?
- ring-buffer overflow/sequence gap indicated?
- collector start/stop/restart known?

### Ordering rule

Prefer a source-native monotonic sequence for ordering events from that source. Across devices, claim `A preceded B` only when synchronization, bounded latency, common witness, or other evidence actually supports that ordering. Decimal timestamp precision is not synchronization evidence.

## Transition claim worksheet

Create one row for every safety-significant claimed transition, including missing expected transitions.

| Claim ID | Claimed transition | Evidence source(s) | Native evidence/value | Time/sequence quality | Validity/freshness | Reconstruction class | Provenance | What this proves | What remains unproven |
|---|---|---|---|---|---|---|---|---|---|
| C-01 | protective demand asserted | | | | | | | | |
| C-02 | safety output removed | | | | | | | | |
| C-03 | final element responded | | | | | | | | |
| C-04 | hazardous-energy path changed | | | | | | | | |
| C-05 | hazardous physical effect stopped/prevented | | | | | | | | |
| C-06 | reset occurred | | | | | | | | |
| C-07 | normal controller rearmed | | | | | | | | |
| C-08 | deliberate START occurred | | | | | | | | |

Do not combine C-01 through C-05 into one `SAFE` transition.

## Evidence-layer reconstruction

Reconstruct in parallel layers rather than one flattened timeline.

### Layer 1 — protective demand

E-stop, guard/interlock, protective field, enabling device, mode/discrepancy or other independent protective input. Record the originating safety source where available. A LinuxCNC mirror is secondary context.

### Layer 2 — safety logic/output

Record safety-controller decisions and output transitions. If the controller says an output was commanded OFF, state exactly that; do not write `contactor opened` unless separately witnessed.

### Layer 3 — final-element feedback

Record EDM/auxiliary contacts, drive safe-function status or other downstream witnesses. Identify what physical/electrical state each feedback path actually observes and any shared/common wiring that limits independence.

### Layer 4 — hazardous-energy witness

Record real evidence of electrical isolation, hydraulic/pneumatic state, stored-energy control, gravity restraint or other relevant energy path. Exact machine thresholds remain measurement/design dependent.

### Layer 5 — physical hazardous effect

Record actual observed motion/no-motion, restraint, separation or other physical effect only when there is a legitimate witness/test/measurement. Do not derive this solely from command state.

### Layer 6 — ordinary control context

LinuxCNC state, HAL signals, FPGA watchdog, proportional-current request/measured current, commanded valve state and HMI actions can explain context. They remain ordinary-control evidence unless the independent safety architecture explicitly gives them a safety role.

### Layer 7 — recovery

Keep these distinct: demand cleared; fault cleared; safety reset permitted; safety reset; safety ready; ordinary-controller rearm; normal START; first physical actuation/motion.

## Contradiction register

| Conflict ID | Evidence A | Evidence B | Why they conflict | Possible explanations | Evidence needed to resolve | Current disposition |
|---|---|---|---|---|---|---|
| | | | | | | `CONFLICTING` / resolved |

Rules:

1. Do not delete the losing evidence after a conflict is resolved; preserve why it was rejected or reinterpreted.
2. A source with a more precise timestamp is not automatically more authoritative about physical state.
3. If both explanations remain plausible, disposition remains `CONFLICTING` or `UNKNOWN`.

## Gap and discontinuity register

| Gap ID | Source affected | Gap start/end or bounds | Cause known? | Evidence lost/possibly lost | Claims invalidated or downgraded |
|---|---|---|---|---|---|
| | | | | | |

Explicitly include power loss, controller reboot, network loss, collector restart, storage failure, buffer overflow, sequence gaps, clock reset and configuration change. A blank interval means `UNKNOWN DURING GAP`, not `no event`.

## Human-action register

Record operator and maintenance actions that can alter interpretation:

- E-stop/guard/protective-device action;
- diagnostic acknowledgement;
- history clear;
- safety reset;
- LinuxCNC reset/rearm/start;
- power cycle;
- configuration download;
- temporary jumper/force/override installation or removal;
- manual hydraulic/mechanical action;
- LOTO/isolation/blocking/restraint action;
- test fixture installation/removal.

Do not infer a safety reset merely because an alarm disappeared. Do not infer physical isolation merely because an HMI command was issued.

## Competing-hypothesis table

When cause is not obvious, preserve multiple hypotheses.

| Hypothesis | Supporting evidence | Contradicting evidence | Required assumptions | Safety-relevant UNKNOWNs | Status |
|---|---|---|---|---|---|
| H1 | | | | | viable/rejected/unresolved |
| H2 | | | | | viable/rejected/unresolved |

Reject a hypothesis only because evidence contradicts it or required assumptions are disproven—not because another narrative is simpler.

## Example bounded conclusions

Acceptable:

- `DIRECTLY OBSERVED / TEST-CONFIRMED`: EDM input changed state after the safety output transition during the controlled test.
- `BOUNDED INFERENCE / INFERENCE`: evidence is consistent with the monitored contactor opening, but no witness establishes hydraulic stored energy or ram restraint.
- `STALE / UNKNOWN`: the HMI last showed safety-ready before diagnostic communication was lost; state during the gap is unknown.
- `CONFLICTING`: safety-controller sequence shows demand before output removal, while an unsynchronized historian orders the displayed events oppositely; cross-device order is unresolved.

Not acceptable without stronger evidence:

- `The machine was safe because LinuxCNC was OFF.`
- `The valve was safe because command current was zero.`
- `No E-stop occurred because it is absent from an overflowed diagnostic buffer.`
- `The contactors were open because the safety PLC commanded them off.`

## Incident conclusion structure

### Established facts

List only claims supported at the stated layer and provenance.

### Bounded inferences

List each inference with premises and explicit limits.

### Conflicts

List unresolved contradictory evidence.

### Unknowns

List evidence gaps that materially prevent stronger conclusions.

### Safety architecture lessons

Identify architecture/documentation/diagnostic improvements without treating a post-incident design recommendation as proof of what happened.

### Required follow-up

Separate:

- evidence-preservation/retrieval work;
- documentation/configuration trace work;
- controlled validation tests;
- physical machine measurements;
- design changes;
- training/procedure changes.

A future test may validate architecture behavior but cannot retroactively prove an unobserved past event occurred in the same way.

## OpenPressBrake application

For a future OpenPressBrake incident, preserve at minimum independent safety-system demand/output evidence, available EDM/final-element feedback, ordinary LinuxCNC/HAL/FPGA context, proportional-current request and measured current as electrical-control evidence, real hydraulic/mechanical witnesses where installed and validated, configuration identities, and every power/network/logging discontinuity.

Do not infer the future press brake's exact hydraulic truth table, pressure behavior, stopping distance, gravity restraint behavior or safe-motion timing from this worksheet. Those remain `UNKNOWN` until the actual design and physical evidence establish them.

## Evidence status for this artifact

- `DOC-CONFIRMED`: inherited diagnostic-history limitations and source/collector-time distinction from the preceding event-record schema's cited SICK/Pilz documentation.
- `INFERENCE`: confidence classes, layered reconstruction, contradiction/gap registers and competing-hypothesis method are engineering synthesis for curriculum use.
- `SOURCE-CONFIRMED`: no new source-code claim required.
- `TEST-CONFIRMED`: none; no machine test performed.
- `COMMUNITY-REPORTED`: none used.
- `UNKNOWN`: future machine-specific witnesses, timing quality, physical energy behavior and acceptance values.

## Compute decision

No executable verification is justified. Synthetic event ordering could demonstrate software behavior but cannot establish machine-specific safety authority or historical physical facts. No GitHub-hosted runner is to be used. The self-hosted `[self-hosted, openpressbrake]` runner remains reserved for a concrete question-driven verification need.

## Precise next independent work

Build `SAFETY_INCIDENT_EVIDENCE_PRESERVATION_FIRST_RESPONSE_CARD.md`: a compact, practical first-response card for preserving volatile diagnostics/configuration identity after a safety event while prioritizing personnel protection and hazardous-energy control. It must explicitly state that evidence preservation never outranks rescue, emergency response, isolation, blocking/restraint or making the area safe; avoid power-cycling/clearing histories when safe and practical; capture boot/config/time-quality state; quarantine changed parts/configs; and preserve UNKNOWNs without encouraging unsafe access to energized machinery.