# 4400-OPB-ARCH-AUTH-01 — Architecture intent is not installed safety proof

**2026-10-29 | Cross-repository original-source correction | NON-GRADUATED | NO MACHINE TEST.**

## Question and predecessor check

**Question:** Can the OpenPressBrake project front door imply that an independent safety system and safe board test mode are already established, when the actual installed machine and physical stopping/holding are still UNKNOWN?

**SOURCE-CONFIRMED answer: yes, as a documentation/authority ambiguity.** The former README diagram said `Existing Safety PLC -> independently controls safety functions / machine enables`; the former architecture text said `The existing safety PLC remains the independent safety system` and listed `exercise dedicated motion outputs` / `command a bounded proportional-valve test current` as service capabilities without an explicit adjacent disconnected-fixture/qualified-machine-test boundary. This is **not evidence** that anyone operated unsafely, nor that the installed safety equipment is absent.

**Predecessors retained:** [FIELD-VISIT-01](4400_FIELD_VISIT_01_OPENPRESSBRAKE_LIVE_CHECKLIST_AMBIGUITY_AND_SAFE_INVENTORY_CORRECTION_2026-10-29.md) corrected the *machine survey* instructions, not the architecture/front-door and standalone-service promise. The [Stage A A–G request](../safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) and [one-screen evidence board](../safety-course/4400_G0_BOARD_01_ONE_SCREEN_RESTRICTED_EVIDENCE_STATUS_TEMPLATE_2026-10-26.md) already mark installed proof UNKNOWN. This is a **cross-repository source/document correction and integration**, not a new hazard mechanism, a new scored competence, or another owner questionnaire.

## Exact original source surfaces and immutable evidence

| Source | Before (Git blob) | After (Git blob) | Correction |
|---|---|---|---|
| `Bensend/OpenPressBrake/README.md` | `b59365e897379d7a945e489e77104aec86b76f76` | `ab29a84075887b2b2c1c03549ce9ef113524daf9` | Changes the unqualified safety-PLC diagram to **intended independent safety system / as-built unverified**; adds prominent G0/G1 hold and bench-isolation boundary. |
| `Bensend/OpenPressBrake/docs/ARCHITECTURE.md` | `545567803c6e39f17e9bba936bfc4a15bb4b1089` | `f00ee98936c86af9b6519229e7d5c4b0893fc9c5` | Separates ordinary `SAFETY_OK` status, board hardware inhibit, independent safety authority, and hydraulic/mechanical safe state; fences motion/current service features to disconnected bench fixtures or separately qualified machine commissioning, labels the normal-control architecture diagram directly at point of use, and marks `SAFETY_OK` as a **conceptual aggregate**, not a real Rev1 net. |
| `Bensend/OpenPressBrake/hardware/REV1_MACHINE_CONFIG.yaml` | `deecc689a7d2b2cdad2061456583601a36b09337` | `2272a4e1dfd50e467d702a69a11224333be59f2b` | Preserves provisional configuration and all electrical values; comments explicitly distinguish `safe_state: zero_current` and `safe_states:` from validated hydraulic ram stop/hold. |
| `Bensend/OpenPressBrake/hardware/blocks/safety_interface/engineering.yaml` | `905d19e0cf3e70d08e15ece4a93538bfd52162eb` | unchanged | Explicit `scope` is observation/ordinary handshake; `excludes` safety decisions, safety stop, energy isolation and PL/SIL/category credit. The corrected top-level docs now agree with this deeper contract. |
| `Bensend/OpenPressBrake/docs/HYDRAULIC_PHASE_STATE_TABLE_REV0.md` | `4ddffefa16c31bab3d58411fc9e4de7d1698678a` | unchanged | Chart-derived normal sequence explicitly **not a release mapping**; not an independent Y1/Y2 hydraulic safe-state truth table. |

The configuration's original `safe_state: zero_current` and `safe_states:` keys were a second point-of-use ambiguity: an electrical inactive/default value can be misread as a physically safe machine state. [Comment-only clarification](https://github.com/Bensend/OpenPressBrake/commit/3165ff89ed603654d1aa1f201ba7c4f87aed25f8) adds explicit no-safety-credit text without changing any YAML keys or values; **no runtime/configuration test** was run.

Implemented OpenPressBrake commits: [README correction](https://github.com/Bensend/OpenPressBrake/commit/8f94cf7555ba01f98069faae960382f0b7498d92) [architecture/service correction](https://github.com/Bensend/OpenPressBrake/commit/2567b110ba4b390606f2f20397e5ecad4f2d25da), and [diagram point-of-use clarification](https://github.com/Bensend/OpenPressBrake/commit/8548a7c3b54aba7ec2a813e928af3f39ca862d74). The intermediate architecture blobs `81f6e534be833c3cb085d7856514780f25e2cff4` and `431763696383d12e4e3b8d0e67a6a0f7711d4b9e` remain in commit history; the latest blob is listed above. A final [bench-versus-remote-test boundary correction](https://github.com/Bensend/OpenPressBrake/commit/b770edaebf02ebda356b65fcfed34360d54bf546) explicitly rejects treating physically disconnected bench fixtures and qualified isolated/remote hazardous-machine tests as interchangeable; prior `92d6ccecfb2a98fb32bf5734e8902e9623c9f55b` remains in history. Subsequent [exact status-signal clarification](https://github.com/Bensend/OpenPressBrake/commit/3b9b46ebd66bddf3e93396e3574f2b3f15699d89) and [README interface clarification](https://github.com/Bensend/OpenPressBrake/commit/78e9d99fbd45127843a05d97e5b97dac683dd0a9) make explicit that the source-derived Rev1 interface has seven Pilz status inputs, six ordinary operational handshakes, wire 75 independent valve permission and wire 63 direct X-drive enable; these are **drawing-derived, not verified as installed**. Post-write direct reads confirmed the corrected README and architecture.

## Exact-signal reconciliation — do not invent a single physical SAFETY_OK

The unchanged `hardware/blocks/safety_interface/manifest.yaml` at blob `f5b483ca9b4244192131337f81f7c9ec834925ac` enumerates **7** Pilz-to-controller status inputs and **6** controller-to-Pilz ordinary handshake outputs. `hardware/REV1_MACHINE_CONFIG.yaml` additionally maps wire **75** to a Pilz valve-enable gate and wire **63** directly from Pilz to the X-drive enable terminal. **SOURCE-CONFIRMED drawing-derived allocation; UNKNOWN actual wiring, selected active Pilz logic, timing, and physical stop/hold.** A software `SAFETY_OK` aggregate could mask a stale/misinterpreted status; no safety integrity or electrical truth is inferred from its name. This is a precise interface clarification, not a new circuit design or board-development task.

## Cross-check against lower-level release status

Direct reads of OpenPressBrake `hardware/blocks/safety_interface/REFERENCE_REBASE.md` (blob `8e74e7cd11906c7ee6f0ed601034cd4e9c901b4`) and `STATUS_CHECKLIST.md` (blob `2f12be48e4b82523dbb62f11894283f49b765679`) confirm that **the seven/six Rev1 drawing composition is bounded, but the safety-interface block remains BEHAVIORAL ONLY / NOT SCHEMATIC-READY**. The reference rebase explicitly replaces a generic single status with seven named signals and reserves wire75/63 outside ordinary FPGA authority; the checklist still requires installed wiring/no-bypass/backfeed review. This prevents the opposite error of treating *every endpoint name* as unknown: the drawings establish an inspectable **source-derived electrical composition**, while installed active safety behavior and physical stop/hold remain UNKNOWN. **SOURCE-CONFIRMED**, no physical proof.

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

- **SOURCE-CONFIRMED:** exact before/after repository text, provisional configuration with comment-only correction and unchanged non-safety interface contract; two committed corrections verified by direct read.
- **DOC-CONFIRMED:** existing official [OSHA 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147) and [1910.333](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.333) distinguish energy isolation and electrical verification from control functions (jurisdiction/task applicability remains specific).
- **INFERENCE:** clearer adjacent wording and default disconnected bench fixtures reduce unsafe interpretation; no user-behavior measurement exists.
- **UNKNOWN:** actual active Pilz/AKAS configuration, independent final elements, physical Y1/Y2 stop/hold, installed wiring, guarding, energy isolation, restart, local runner isolation and machine-specific PL/SIL.
- **TEST-CONFIRMED:** none. No simulation, workflow, build, physical test, machine movement or evaluator score.
- **Gates:** G0/G1 **HOLD**; G2 **NOT RUN**; G3/G4 **NOT AUTHORIZED**; G5 **HOLD**. External 2520–25F0 competency remains **OPEN**. Zero hosted/self-hosted compute; no lab ledger change.

**Incremental physical witness:** the correction makes the need for qualified as-built **independent final-element plus physical ram stop/hold** explicit at the first architecture encounter. It does not supply that witness. Next: accept only qualified restricted Stage A A–G evidence or an independent evaluator result; otherwise select a distinct safety information-gain branch without reopening graduated levels.
