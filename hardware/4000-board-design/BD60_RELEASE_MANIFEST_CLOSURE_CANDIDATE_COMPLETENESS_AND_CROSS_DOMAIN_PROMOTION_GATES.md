# BD60 — Release-Manifest Closure, Candidate Completeness, and Cross-Domain Promotion Gates

## Purpose

BD59 proved that a candidate must lock the exact current evidence it consumes. BD60 asks the board-level question that follows:

`required board claims -> claim coverage matrix -> block/connection/resource/evidence locks -> generated electrical + FPGA + LinuxCNC/HAL artifacts -> unresolved-fact closure -> cross-domain consistency gate -> candidate completeness decision -> release handoff`

A complete controller is not the average maturity of its blocks. Every release-required claim must close across the electrical, FPGA, power, connector, LinuxCNC/HAL, physical-machine, verification, and safety-boundary domains.

This lesson deliberately alternates BLOCK ENGINEERING and BOARD INTEGRATION: a reusable block can publish a correct generic contract while the board remains unreleasable because its instance count, connector, power path, FPGA allocation, HAL mapping, or installed-machine facts are not closed.

## Student-material readiness audit

Every repository file named below was opened and inspected in its CURRENT form during this run before use.

**VERIFIED_FOR_LESSON** for the bounded claims used:

- Curriculum `README.md` — provenance, reproducibility, uncertainty, experiments, and technical-handoff standard.
- Curriculum `WORK_SELECTION_POLICY.md` — evidence-gaining autonomous work selection.
- Curriculum `hardware/4000-board-design/BD59_EVIDENCE_CONSUMPTION_LOCKS_RELEASE_MANIFESTS_AND_STALE_PROOF_REJECTION.md` — candidate evidence-consumption locks and stale-proof rejection.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — board-design progress through BD59.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — truthful status, baseline versus Rev-1 distinction, concrete evidence, primitive/shared-resource ownership, maintenance, and CI limits.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block / adapter / board-integration ownership and fail-closed incompatibility classification.
- OpenPressBrake `hardware/blocks/relay_contactor_driver/integration/REV1_RESOURCE_CONTRACT.yaml` — current one-channel relay/contactor board-resource handoff.
- OpenPressBrake `hardware/blocks/relay_contactor_driver/manifest.yaml` — current reusable electrical/interface/resource/verification contract.

**ENGINEERING_REVIEW_NEEDED** as a complete current-status/evidence-discovery authority:

- OpenPressBrake `hardware/blocks/relay_contactor_driver/STATUS_CHECKLIST.md` — its current `Evidence currently present` list does not name the already-current `integration/REV1_RESOURCE_CONTRACT.yaml`. Its bounded status and engineering claims remain useful, but a board release cannot prove complete current evidence discovery from this status surface alone. This is the same class of status/evidence-index drift BD59 found in another block and is material under `STATUS_RULES.md` maintenance expectations.

No audited file establishes that the OpenPressBrake controller is production-proven.

## Learning objectives

A student must be able to:

1. derive the complete set of release-required claims from machine requirements and selected board architecture;
2. distinguish reusable-block maturity from board-candidate completeness;
3. build a cross-domain claim coverage matrix with explicit closure states;
4. prove that block, adapter, connection, FPGA, power, connector, LinuxCNC/HAL, and machine-fact authorities agree;
5. reject a candidate when one required domain is unresolved even if every selected reusable block is individually usable;
6. aggregate power/current/resource limits without converting component ceilings into board ratings;
7. preserve `VERIFY_AT_MACHINE` facts as blockers until evidence exists;
8. define a race-safe promotion gate that rechecks exact authority/evidence locks; and
9. keep ordinary controller release closure separate from independent personnel-safety authority.

## 1. Release completeness is closure, not maturity averaging

A candidate may contain ten strong blocks and one unresolved connection. It is incomplete.

A candidate may pass ERC but lack a legal FPGA pin allocation. It is incomplete.

A candidate may synthesize and boot LinuxCNC while its connector current path is unrated. It is incomplete.

A candidate may have a correct HAL signal name while the physical machine endpoint remains `VERIFY_AT_MACHINE`. It is incomplete for that installed-machine claim.

Therefore:

**ALL BLOCKS USABLE ≠ BOARD RELEASE COMPLETE.**

**ERC CLEAN ≠ CROSS-DOMAIN CLOSED.**

**FPGA BUILD PASSES ≠ ELECTRICAL RELEASE PASSES.**

**HAL LOADS ≠ PHYSICAL I/O MEANING IS PROVEN.**

**DEVICE RATING ≠ BOARD CHANNEL RATING.**

Release completeness is a conjunction over required claims, not a score.

## 2. Start with a required-claim inventory

Before evaluating a release candidate, enumerate the claims the candidate must make. Do not begin with filenames.

Useful claim families include:

- machine requirement and I/O semantic identity;
- reusable block selection and operating envelope;
- adapter/transformation requirement and qualification;
- board-specific instance population;
- connection block: connector family, pins, labels, physical location, harness destination;
- power source, rail, return, startup, current, fault, protection, and simultaneous-load budget;
- FPGA package ball, bank voltage, direction, electrical standard, clock capability, bus membership, and logical resource;
- LUT/register/BRAM/PLL/bus budget where applicable;
- startup/reset/default/de-energized behavior;
- watchdog and ordinary output-authority behavior;
- generated schematic/PCB connectivity and ERC/DRC evidence;
- LinuxCNC/HostMot2/LiteX-CNC/HAL semantic mapping;
- bench test and commissioning evidence;
- unresolved physical-machine facts; and
- explicit safety-boundary ownership.

Every required claim gets a stable ID. A claim that is not required must be explicitly `NOT_REQUIRED` with justification rather than silently omitted.

## 3. Cross-domain claim coverage matrix

For each claim, record at minimum:

| Field | Meaning |
|---|---|
| `claim_id` | stable semantic identity |
| `required_by` | machine requirement, block contract, board architecture, release policy, or dependent claim |
| `owner_domain` | block, adapter, connection, power, FPGA, LinuxCNC/HAL, PCB, machine, verification, safety-boundary |
| `authority_lock` | exact current authority object/digest |
| `evidence_lock` | exact eligible evidence/proof consumed |
| `consumer_artifacts` | schematic, PCB, gateware, HAL, BOM, commissioning record, etc. |
| `closure_state` | release decision for this claim |
| `negative_scope` | what the evidence does not prove |
| `dependencies` | claims/resources/facts that can invalidate it |

Recommended closure states:

- `CLOSED_CURRENT` — authority and eligible evidence are current and all required consumers agree.
- `CLOSED_CURRENT_NARROWED` — closed only inside a recorded narrower envelope that contains this candidate.
- `BLOCKED_UNKNOWN` — required fact remains unknown or `VERIFY_AT_MACHINE`.
- `MISSING_AUTHORITY` — no eligible authority owns the required claim.
- `MISSING_EVIDENCE` — authority exists but required verification evidence does not.
- `CROSS_DOMAIN_CONFLICT` — two domains disagree about the same semantic fact.
- `STALE_CONSUMER` — a generated/configured consumer uses an older authority/evidence lock.
- `SUPERSEDED_REJECT` — consumed authority is explicitly superseded.
- `NOT_REQUIRED` — outside candidate scope with durable justification.

Only `CLOSED_CURRENT`, justified `CLOSED_CURRENT_NARROWED`, and justified `NOT_REQUIRED` satisfy release closure.

## 4. Closure must traverse domains

A field output is not closed merely because its switch block is engineered. Trace the complete path:

`machine semantic -> LinuxCNC/HAL command -> FPGA logical resource -> FPGA package ball -> block command input -> block electrical output -> board connection -> connector pin -> harness -> installed load -> return path -> source/protection`

Then trace status/fault information in the reverse direction when present.

Each boundary must preserve semantic meaning, voltage/current class, direction, default state, resource ownership, and fault behavior. A missing link is a board defect, not a documentation inconvenience.

## 5. Worked OpenPressBrake case: relay/contactor driver

The current relay/contactor resource contract publishes one reusable protected 24-V external-coil channel per instance. It assigns one FPGA `COIL_COMMAND` output plus diagnostic inputs as declared by the manifest/frozen netlist. It gives a conservative `LOGIC_3V3` source-allocation bound of 4.2 mA per instance and separates field-side electronics overhead from external coil current.

Critically, the contract does **not** publish 2.4 A as the OpenPressBrake channel rating. It records 2.4 A as the IPS1025H semiconductor device ceiling and requires the released continuous channel rating to be the minimum allowed by the device envelope, PCB copper/vias/temperature rise, connector/contact/wire path, branch protection, shared 24-V source/distribution, ambient/enclosure assumptions, simultaneous population/energization, and repetitive inductive-demagnetization envelope.

The current manifest agrees: `published_controller_continuous_current_a` remains null, PCB trace/via/copper assumptions remain unresolved, connector current rating remains unresolved, and the release tests for current/repetition/simultaneity, inductive turnoff, output-short protection, repeated-cycle thermal budget, simultaneous-coil power, branch-fuse coordination, connector rating, and field return remain open.

### 5.1 What the reusable block closes

Within its stated scope, the reusable block can provide current authority for:

- one channel per primitive instance;
- protected IPS1025H high-side topology;
- deterministic command-OFF behavior;
- ordinary diagnostic semantics;
- generic `LOGIC_3V3` allocation and field-electronics overhead terms;
- separation of external load current from electronics overhead;
- generic load-acceptance rules; and
- zero personnel-safety credit.

Those are BLOCK ENGINEERING claims.

### 5.2 What the board must still close

For a concrete controller candidate, BOARD INTEGRATION must separately establish:

- actual populated channel count;
- maximum channels permitted to energize simultaneously;
- documented coil current/power or `VERIFY_AT_MACHINE` evidence for undocumented loads;
- final field connector family, pin assignment, wire size and derating;
- final PCB copper weight, trace/via geometry, ambient and allowable temperature rise;
- branch fuse/protection coordination;
- shared protected 24-V source/distribution capacity;
- actual FPGA package-ball assignments;
- connection-block labels, physical locations and harness destinations;
- LinuxCNC/HAL command and diagnostic mappings;
- generated schematic/PCB agreement with those mappings; and
- required bench/commissioning evidence.

A candidate missing any required item above cannot promote merely because the primitive remains `SIMULATION-READY`.

### 5.3 Adversarial board-candidate example

Assume a hypothetical candidate selects four relay-driver instances and every reusable primitive artifact is current. The candidate also has a legal FPGA command allocation and a syntactically valid HAL mapping.

Now suppose the installed coils are not documented and the board connection definition has not established connector contact rating, wire size, simultaneous energization, or branch-fuse coordination.

The candidate is **not release-complete**. Its relevant claims are `BLOCKED_UNKNOWN` or `MISSING_EVIDENCE`, even though the reusable block remains valid and need not be redesigned.

The correct response is to close the board/machine facts and current path. It is not to copy guessed coil values into the reusable manifest, lower the standard for the connection block, or convert the 2.4-A device ceiling into a board rating.

## 6. Connection-block closure

A board-specific connection block/mold should own, for each exposed interface:

- connector manufacturer/family and board reference;
- pin number and semantic signal name;
- power/return requirement;
- mating/harness destination;
- FPGA/logical mapping where applicable;
- physical board location/orientation;
- silkscreen/user label;
- voltage/current/contact/wire-size constraints;
- shield/chassis handling when applicable; and
- unresolved installed-machine facts.

This is intentionally separate from reusable circuitry. If a boundary requires real translation, isolation, conditioning, or protection, apply `BLOCK_ADAPTER_INTEGRATION_RULES.md`: qualify a reusable adapter rather than hiding circuitry in the connection definition.

## 7. Power and return closure

Board power closure is more than summing nominal currents. Required claims may include:

- rail source and tolerance;
- maximum operating and startup demand;
- simultaneous-load assumptions;
- regulator/converter efficiency where cross-rail power is translated;
- local decoupling and bulk demand;
- fault current and branch-clearing behavior;
- connector/contact/wire/copper limits;
- return-current paths and domain boundaries;
- thermal assumptions; and
- de-energized/default state.

Do not add milliamps from unlike voltage rails as if they were one current budget. Do not multiply a semiconductor absolute/device ceiling by channel count as a default load model. Aggregate actual declared load terms through the actual power-conversion topology.

## 8. FPGA/resource closure

A board candidate must prove both semantic allocation and physical legality. Depending on architecture, close:

- package ball and I/O bank;
- bank voltage/electrical standard;
- input/output/bidirectional direction;
- differential pair membership;
- clock-capable pin requirements;
- reset/configuration default;
- shared SPI/I2C/UART/bus membership and chip-select/address ownership;
- encoder/stepgen/PWM/driver-enable resource identity;
- LUT/register/BRAM/PLL budgets where relevant;
- timing/resource evidence when required; and
- one-to-one agreement with generated gateware and board connectivity.

A resource spreadsheet that is not consumed by gateware is not closure. A successful synthesis against a different pin/resource authority is not closure either.

## 9. LinuxCNC/HAL closure

The software/control side must map the same semantic identities used by the board:

`machine function -> HAL signal/pin -> driver/gateware resource -> FPGA logical endpoint -> physical ball -> electrical block -> connector -> machine endpoint`

Check direction, units/scaling, polarity, enable/default state, watchdog behavior, diagnostic meaning, and startup/shutdown state. Do not accept a mapping because names merely look similar.

HostMot2 or LiteX-CNC implementation evidence must be version-pinned and must correspond to the actual gateware/resource plan consumed by the candidate.

## 10. Cross-domain consistency gate

Before candidate promotion, run a semantic join across all required claims. Examples of failures that must stop promotion:

- schematic connector pin says `COIL_COMMAND_3` but FPGA allocation drives another instance;
- FPGA bank is 1.8 V while the selected block requires 3.3-V logic;
- HAL mapping calls a signal active-high while the generated gateware/board contract implements the opposite semantic state;
- BOM/assembly populates termination or protection inconsistent with the connection contract;
- power aggregation assumes two simultaneous loads while machine behavior permits four;
- connector contact rating is below the released current-path requirement;
- board file uses a superseded block variant;
- physical machine destination is guessed rather than verified;
- a normal-control watchdog is represented as personnel-safety authority.

The gate must report the exact claim IDs and domains in conflict. `cross-domain check failed` without semantic localization is poor engineering evidence.

## 11. Candidate completeness algorithm

For a release candidate:

1. freeze candidate identity;
2. derive the required-claim inventory from machine requirements and architecture;
3. resolve reusable block and adapter authority for every selected function;
4. resolve board-specific connection and population authority;
5. resolve power/return and shared-resource claims;
6. resolve FPGA logical and physical resource claims;
7. resolve generated schematic/PCB/BOM identities;
8. resolve LinuxCNC/HostMot2/LiteX-CNC/HAL mappings;
9. resolve required physical-machine facts and commissioning prerequisites;
10. attach eligible evidence/proof locks from BD55–BD59;
11. construct the claim coverage matrix;
12. reject any required claim not in a release-satisfying closure state;
13. run cross-domain semantic consistency checks;
14. generate/revalidate only the affected artifacts when closure changes;
15. re-open/recheck all student/release authorities actually consumed;
16. re-read repository/dependency heads immediately before promotion; and
17. promote only if the complete required-claim set remains closed.

This is a closure proof, not a checklist popularity vote.

## 12. Race-safe promotion

BD59's race remains active at board scale:

`close claims -> generate artifacts -> review -> dependency changes -> promote stale candidate`

Immediately before promotion, compare the exact authority/evidence/dependency heads used by the candidate with current heads. If a relevant dependency changed, classify it through BD56–BD59 rather than assuming the candidate remains valid.

Unrelated repository churn does not force a redesign. Claim-relevant drift does force preservation proof, targeted revalidation, regeneration, or rejection.

## 13. Catalog stress-test result

The current relay/contactor resource handoff is useful precisely because it refuses to pretend the device ceiling is a board rating and explicitly hands board-owned facts to integration. That is good reusable-block behavior.

The stress test also exposes two infrastructure needs:

1. **Status/evidence indexing:** the current relay-driver status checklist does not yet name the newly current resource contract, so current evidence discovery still requires manual reconciliation.
2. **Board-level closure model:** the catalog has increasingly strong per-block resource contracts, but a release needs a normalized claim coverage matrix that joins block authority, connection blocks, shared resources, FPGA allocations, generated electrical artifacts, LinuxCNC/HAL mappings, physical-machine facts, evidence locks, and release state.

Classification: **ENGINEERING_REVIEW_NEEDED** for machine-readable board-level closure infrastructure with stable semantic claim IDs, cross-domain joins, reverse Show Where Used, explicit `VERIFY_AT_MACHINE` blockers, exact consumer locks, candidate completeness gates, and race-safe promotion.

OpenPressBrake remains read-only in this lesson because relay-driver integration/resource-contract work has just advanced on current main. Do not race active engineering work merely to repair its evidence index.

## 14. Lab — close a four-channel output candidate

Build a hypothetical four-channel ordinary-process-control output candidate from four relay-driver primitive instances. Do not assume any first-machine values not established by evidence.

Submit:

- required-claim inventory;
- four board-specific connection definitions;
- FPGA logical and physical resource allocation;
- `LOGIC_3V3` aggregate allocation;
- field-side electronics overhead and external-load budget kept as separate terms;
- simultaneous-load assumption and its authority;
- connector/current-path/protection closure states;
- LinuxCNC/HAL command and diagnostic mapping;
- unresolved machine facts;
- claim coverage matrix;
- cross-domain conflict report; and
- final `PROMOTE` or `REJECT` decision.

Then inject these defects one at a time:

1. one undocumented coil;
2. one connector pin swapped in the schematic;
3. one FPGA output moved to an incompatible bank;
4. simultaneous-load assumption changes from two to four;
5. HAL polarity disagrees with the gateware semantic contract;
6. the status checklist is updated without changing engineering authority;
7. an unrelated curriculum file changes; and
8. a reviewer proposes treating the ordinary watchdog as the independent safety function.

For each defect identify affected claim IDs, preserved evidence, stale/blocked evidence, minimum corrective work, and promotion result.

## 15. Completion standard

A student passes BD60 only if they can demonstrate release closure across a complete controller path rather than presenting individually mature blocks. They must reject a candidate with one unresolved required claim, preserve unaffected evidence, keep block and connection ownership separate, and explain exactly why the final promotion gate is or is not satisfied.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification is required for this methodology or the audited relay-driver resource/status finding. No GitHub-hosted compute is authorized. If a future candidate claim genuinely requires executable verification, use only `[self-hosted, openpressbrake]`.

## Safety boundary

BD60 concerns completeness of ordinary board-design/controller release claims. It does not establish PL/SIL/category, stopping performance, independent safety diagnostic coverage, final-element validation, or personnel-safety authority. Ordinary LinuxCNC/FPGA watchdogs, inhibits, diagnostics, STO interfaces, and status monitoring receive zero personnel-safety credit unless a separate safety-rated design and validation explicitly establishes that authority.
