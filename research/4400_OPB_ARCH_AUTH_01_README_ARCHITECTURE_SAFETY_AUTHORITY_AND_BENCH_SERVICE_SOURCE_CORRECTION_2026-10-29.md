# 4400-OPB-ARCH-AUTH-01 — Architecture intent is not installed safety proof

**2026-10-29 | Cross-repository original-source correction | NON-GRADUATED | NO MACHINE TEST.**

## Question and predecessor check

**Question:** Can the OpenPressBrake project front door imply that an independent safety system and safe board test mode are already established, when the actual installed machine and physical stopping/holding are still UNKNOWN?

**SOURCE-CONFIRMED answer: yes, as a documentation/authority ambiguity.** The former README diagram said `Existing Safety PLC -> independently controls safety functions / machine enables`; the former architecture text said `The existing safety PLC remains the independent safety system` and listed `exercise dedicated motion outputs` / `command a bounded proportional-valve test current` as service capabilities without an explicit adjacent disconnected-fixture/qualified-machine-test boundary. This is **not evidence** that anyone operated unsafely, nor that the installed safety equipment is absent.

**Predecessors retained:** [FIELD-VISIT-01](4400_FIELD_VISIT_01_OPENPRESSBRAKE_LIVE_CHECKLIST_AMBIGUITY_AND_SAFE_INVENTORY_CORRECTION_2026-10-29.md) corrected the *machine survey* instructions, not the architecture/front-door and standalone-service promise. The [Stage A A–G request](../safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) and [one-screen evidence board](../safety-course/4400_G0_BOARD_01_ONE_SCREEN_RESTRICTED_EVIDENCE_STATUS_TEMPLATE_2026-10-26.md) already mark installed proof UNKNOWN. This is a **cross-repository source/document correction and integration**, not a new hazard mechanism, a new scored competence, or another owner questionnaire.

## Exact original source surfaces and immutable evidence

| Source | Before (Git blob) | After (Git blob) | Correction |
|---|---|---|---|
| `Bensend/OpenPressBrake/README.md` | `b59365e897379d7a945e489e77104aec86b76f76` | `bcce5564478960b4eabd94c7bff1e611ed4045cb` | Changes the unqualified safety-PLC diagram to **intended independent safety system / as-built unverified**; adds prominent G0/G1 hold and bench-isolation boundary. |
| `Bensend/OpenPressBrake/docs/ARCHITECTURE.md` | `545567803c6e39f17e9bba936bfc4a15bb4b1089` | `81f6e534be833c3cb085d7856514780f25e2cff4` | Separates ordinary `SAFETY_OK` status, board hardware inhibit, independent safety authority, and hydraulic/mechanical safe state; fences motion/current service features to disconnected bench fixtures or separately qualified machine commissioning. |
| `Bensend/OpenPressBrake/hardware/REV1_MACHINE_CONFIG.yaml` | `deecc689a7d2b2cdad2061456583601a36b09337` | unchanged | Explicitly **provisional**, with `VERIFY_AT_MACHINE` fields; retained Pilz/AKAS equipment is design/source intent, not installed-program proof. |
| `Bensend/OpenPressBrake/hardware/blocks/safety_interface/engineering.yaml` | `905d19e0cf3e70d08e15ece4a93538bfd52162eb` | unchanged | Explicit `scope` is observation/ordinary handshake; `excludes` safety decisions, safety stop, energy isolation and PL/SIL/category credit. The corrected top-level docs now agree with this deeper contract. |
| `Bensend/OpenPressBrake/docs/HYDRAULIC_PHASE_STATE_TABLE_REV0.md` | `4ddffefa16c31bab3d58411fc9e4de7d1698678a` | unchanged | Chart-derived normal sequence explicitly **not a release mapping**; not an independent Y1/Y2 hydraulic safe-state truth table. |

Implemented OpenPressBrake commits: [README correction](https://github.com/Bensend/OpenPressBrake/commit/8f94cf7555ba01f98069faae960382f0b7498d92) and [architecture/service correction](https://github.com/Bensend/OpenPressBrake/commit/2567b110ba4b390606f2f20397e5ecad4f2d25da). Post-write direct file reads confirmed both new blobs.

## Safety authority decomposition — do not collapse the four layers

| Layer | Legitimate role | What it cannot prove |
|---|---|---|
| LinuxCNC/HMI, HAL, FPGA, ordinary Ethernet control | Commanded Y1/Y2/X motion, state display, logs, diagnostics | Personnel protection, qualified safe stop, safe restart, physical load restraint |
| `SAFETY_OK` and other observed Pilz/status signals | Normal-control inhibit/monitoring, **if** electrical truth and freshness are established | That the selected safety program is correct, that a contactor/valve moved, or that the ram stopped/held |
| Independent selected safety logic and rated output/final-element chain | Hazard-specific protective decisions and withdrawal of hazardous energy under the qualified SRS | Physical Y1/Y2 gravity holding without actual selected hydraulic/mechanical architecture and witness |
| Physical hydraulic/mechanical/electrical state | Actual stopped/held ram, stored-pressure control, isolation, access safety | A universal state from a coil command, a single gauge, an HMI icon or an unverified drawing |

**Adversarial paths (paper-only INFERENCE, not machine observations):** a valve driver is commanded to zero but the ram can descend under gravity; a safety-status wire remains plausible while an output contact sticks; a test firmware or bench tool energizes an output through a connected harness; a machine-connected panel PC running a self-hosted job reaches I/O despite a nominal software inhibit; power restoration or a retained pedal command creates a new motion request. Each requires the appropriate *independent* hazard-specific physical/logic witness, not another normal-control boolean.

## Practical implementation and human factors

1. Make **disconnected, labelled bench loads** the default and easiest test configuration. Keep machine harnesses physically separated; never treat a software mode or workflow label as isolation.
2. In project front-door documents, use **design intent / UNKNOWN / verified** explicitly. Do not allow an attractive architecture diagram to be mistaken for an as-built safety validation certificate.
3. The seven Stage A packets remain the only initial qualified evidence request; do not add another owner form. Existing dated drawings and safe passive evidence first; intrusive or energized work stays deferred.
4. A qualified selected-machine reviewer must establish exact safety program/revision, actual safety final elements and hydraulic/physical Y1/Y2 stop/hold, guard coverage, stored-energy isolation, fresh restart and a no-exposure physical proof method. No blanket claim about coil-off, contactor-open, Pilz healthy or encoder zero can close these.
5. If minimum protections are not established, **do not operate with people exposed**. Any later experimental operation needs a separately approved isolated/remote qualified plan, people outside the danger zone and explicit residual risk.

## Evidence classification and gates

- **SOURCE-CONFIRMED:** exact before/after repository text, unchanged provisional configuration and non-safety interface contract; two committed corrections verified by direct read.
- **DOC-CONFIRMED:** existing official [OSHA 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147) and [1910.333](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.333) distinguish energy isolation and electrical verification from control functions (jurisdiction/task applicability remains specific).
- **INFERENCE:** clearer adjacent wording and default disconnected bench fixtures reduce unsafe interpretation; no user-behavior measurement exists.
- **UNKNOWN:** actual active Pilz/AKAS configuration, independent final elements, physical Y1/Y2 stop/hold, installed wiring, guarding, energy isolation, restart, local runner isolation and machine-specific PL/SIL.
- **TEST-CONFIRMED:** none. No simulation, workflow, build, physical test, machine movement or evaluator score.
- **Gates:** G0/G1 **HOLD**; G2 **NOT RUN**; G3/G4 **NOT AUTHORIZED**; G5 **HOLD**. External 2520–25F0 competency remains **OPEN**. Zero hosted/self-hosted compute; no lab ledger change.

**Incremental physical witness:** the correction makes the need for qualified as-built **independent final-element plus physical ram stop/hold** explicit at the first architecture encounter. It does not supply that witness. Next: accept only qualified restricted Stage A A–G evidence or an independent evaluator result; otherwise select a distinct safety information-gain branch without reopening graduated levels.
