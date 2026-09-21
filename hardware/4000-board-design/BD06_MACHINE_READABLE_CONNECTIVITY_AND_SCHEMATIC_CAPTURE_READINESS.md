# BD06 — Machine-Readable Connectivity and Schematic-Capture Readiness

## Purpose

A reusable hardware block is not schematic-ready because its prose sounds mature, its component family is selected, or its simulation passes. This lesson makes students prove the chain:

`semantic interface -> exact component pins/nets -> parameter/BOM authority -> machine-readable connectivity -> board-specific connection binding -> capture gate -> KiCad schematic -> ERC -> human schematic review -> revision evidence`

The adversarial question is simple: **could a different engineer capture the circuit without asking the original designer for unwritten electrical knowledge?** If not, the catalog has a defect or an explicit open gate.

This is a BLOCK ENGINEERING lesson that deliberately reaches into BOARD INTEGRATION at the connector boundary.

## Learning objectives

Students will be able to:

1. distinguish a semantic block contract from production connectivity;
2. identify the minimum authorities required before schematic capture;
3. trace every component pin, support component, enable/default network, protection return and semantic interface to an exact source;
4. keep physical field connector selection/pinout/placement/silkscreen in a board-specific connection definition rather than contaminating the reusable block;
5. detect contradictions between engineering authority, manifest metadata, BOM, connectivity and status;
6. gate KiCad capture fail-closed when exact authority is absent or contradictory;
7. distinguish generated/hand-captured schematic existence from ERC and from human electrical review;
8. preserve revision evidence so later changes can prove what authority the schematic represented.

## Hard rule

`MATURE PROSE != EXACT CONNECTIVITY != SCHEMATIC-READY != PCB-READY != QUALIFIED`

A block may be useful and well engineered while still failing the next gate.

## Capture-readiness evidence stack

Before capture, require all of the following or an explicit release blocker:

| Layer | Question that must have an exact answer |
|---|---|
| semantic contract | What electrical function crosses the reusable-block boundary? |
| ownership | Which facts belong to reusable block, board integration, machine configuration and evidence? |
| parameter authority | Which values/tolerances/ratings are frozen, and by what evidence? |
| package/pin authority | Which exact production package pins own every net? |
| support circuitry | Are decoupling, bias, enable, termination, protection and default-state parts exact? |
| return/protection authority | Where does normal current return? Where does transient/fault current return? |
| BOM authority | Are exact orderable parts and variant/DNP rules frozen? |
| connectivity authority | Is there one exact machine-readable or otherwise deterministic pin/net source? |
| board binding | Which semantic ports bind to board nets, FPGA pins and connection definitions? |
| connection definition | Which physical connector/pins, placement, label and harness destination implement the board boundary? |
| capture evidence | Does the KiCad schematic represent the frozen authority rather than a designer's memory? |
| ERC evidence | Were electrical-rule violations resolved or deliberately waived with reasons? |
| human review | Was the rendered schematic visually/electrically compared with the frozen authority? |
| revision evidence | Can a reviewer identify exactly which contract/BOM/connectivity revision the schematic implements? |

If any required row is UNKNOWN, contradictory, or dependent on unwritten knowledge, capture is blocked.

## Worked example A — differential encoder: exact reusable connectivity, capture still gated

The following current OpenPressBrake files were opened and inspected for this lesson and are `VERIFIED_FOR_LESSON` for the limited claims below:

- `hardware/blocks/differential_encoder/engineering.yaml`
- `hardware/blocks/differential_encoder/manifest.yaml`
- `hardware/blocks/differential_encoder/design/REV1_PRODUCTION_CONNECTIVITY.md`
- `hardware/blocks/differential_encoder/design/PRODUCTION_BOM_REV1.yaml`
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md`

The package is a useful positive example of **exact reusable electrical authority**. One primitive is one A/Abar, B/Bbar, Z/Zbar receiver. Production connectivity freezes AM26LV32EIPWR channel use, hard enable behavior, connector-edge pair protection to CHASSIS_PE, termination footprints/variants, local decoupling and shield-to-chassis treatment. The production BOM freezes exact MPNs and DNP behavior for terminated versus unterminated variants.

But the status file explicitly says the block remains SIMULATION-READY, not SCHEMATIC-READY. Auto-rendered schematic visual review, cable/termination selection, protected encoder +5 V field supply, abnormal-condition work, PCB integration and release gates remain open.

That is not a failure of the reusable primitive. It is the correct boundary:

`EXACT REUSABLE CONNECTIVITY + EXACT BOM` can coexist with `BOARD CAPTURE/RELEASE GATES OPEN`.

The physical connector family, mating contacts, machine harness adaptation, field-supply implementation and final termination selection remain board integration/machine configuration. Do not pull them into the reusable encoder block merely to make a schematic generator convenient.

### Encoder capture exercise

Create a capture-readiness table with one row for every U1 pin, DA/DB/DZ pin group, RTA/RTB/RTZ, CDEC and RSHIELD. For each row record:

- exact net or semantic role;
- production package/pin authority;
- BOM authority;
- variant population rule;
- normal/fault/transient return;
- whether the fact is reusable-block, board-integration or machine-configuration ownership;
- unresolved board binding, if any.

A student passes only if channel 4 remains intentionally unused rather than silently becoming an extra encoder channel, CHASSIS_PE protection current is not merged into logic GND, and termination population is not guessed.

## Worked example B — digital input: contradiction must fail the capture gate

The following current files were opened and inspected and are `VERIFIED_FOR_LESSON` specifically as an adversarial inconsistency case:

- `hardware/blocks/digital_input_24v/engineering.yaml`
- `hardware/blocks/digital_input_24v/manifest.yaml`
- `hardware/blocks/digital_input_24v/REFERENCE_REBASE.md`
- `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md`

Do **not** treat the package as finished student capture material.

The current engineering authority and reference rebase explicitly withdraw the former universal `<=500 pF total effective FGND-to-other-ground` / `6.5 pF residual PCB parasitic` release gate. The production rule is instead to preserve the TI application topology and return/isolation structure, follow manufacturer layout guidance, inspect the real PCB for material departures, and perform quantitative parasitic work only when a specific delta creates uncertainty.

However, the current manifest still contains legacy fields that state the old 500 pF / 6.5 pF limits and repeats them in placement, simultaneous-instance and board-integration verification language. The engineering file itself warns that such legacy manifest fields are superseded.

This is a catalog defect, not something a lesson or schematic author may silently reconcile.

**Readiness classification:** `ENGINEERING_REVIEW_NEEDED` for manifest reconciliation; `INCOMPLETE_NOT_STUDENT_MATERIAL` as a finished capture example.

Freeze the rule:

`ONE FILE SAYS SUPERSEDED + ANOTHER MACHINE-READABLE FILE STILL ENFORCES IT = CAPTURE BLOCKED`

A generator must not choose whichever value is easiest. A human must reconcile the authority and make the machine-readable artifacts agree before schematic capture can claim deterministic provenance.

### Digital-input defect action

Catalog action item: reconcile `hardware/blocks/digital_input_24v/manifest.yaml` with the current `engineering.yaml`, `REFERENCE_REBASE.md`, and `STATUS_CHECKLIST.md` by removing/demoting the withdrawn universal 500 pF/6.5 pF gate everywhere it still appears as a mandatory requirement. Re-run the relevant static validators after that engineering edit. Do not change the frozen 470 pF nominal CEMC component merely to perform the cleanup.

This lesson records the defect but does not modify the active engineering repository in the same curriculum commit.

## Connection blocks remain board-specific

A schematic-capture tool needs exact connector information, but that does not make connector details reusable-block properties.

The reusable block should expose semantic ports and electrical requirements. The board-specific connection definition owns, as applicable:

- connector manufacturer/family/MPN and footprint;
- exact position-to-signal mapping;
- power and return positions;
- FPGA/logical mapping;
- board edge/location/orientation and service clearance;
- silkscreen/label text;
- mating part and harness destination;
- machine wire/current/mechanical constraints;
- shield/chassis termination implementation.

The capture system binds the two artifacts. It must not merge their ownership.

## KiCad capture gate

Before creating or regenerating a schematic sheet, answer YES to each item:

1. Exact production component/package is selected for every populated part.
2. Every used package pin has one authoritative net/role.
3. Every intentionally unused pin has explicit disposition.
4. Every enable/reset/default-state pin has explicit treatment.
5. Every decoupling/reference/bias/termination/protection part has exact value and connection authority.
6. Normal, fault and transient returns are not hidden behind ambiguous `GND` naming.
7. Assembly variants and DNP behavior are deterministic.
8. Semantic block ports bind to board nets without machine-specific assumptions leaking backward into the block.
9. Physical connector facts come from the connection definition, not from reusable-block prose.
10. No current authority files contradict each other.

Any NO means **do not promote the block to schematic-ready**.

## Schematic generation is not verification

After capture or generation:

1. run KiCad ERC;
2. resolve errors, or document each intentional waiver with electrical rationale;
3. render the schematic;
4. visually compare every component, pin, net, support part, return and variant against the frozen connectivity/BOM authorities;
5. compare semantic ports against the board-specific bindings;
6. record the exact source revisions/hashes used;
7. only then advance the capture-review gate.

`ERC CLEAN != ELECTRICALLY CORRECT`.

ERC catches rule violations represented in the CAD model. It cannot prove that the CAD model matches the intended topology, that a return was assigned to the correct domain, that a connector pin matches the harness, or that a copied stale requirement was valid.

## Lab — adversarial capture-readiness audit

Choose one reusable block not used above. Do not open KiCad first.

Produce:

1. ownership table;
2. semantic-interface table;
3. exact package/pin/net table;
4. BOM/value/tolerance/variant table;
5. default/enable/unused-pin table;
6. normal/fault/transient return map;
7. board-binding and connection-definition dependency table;
8. contradiction/TODO/stale-assumption audit;
9. capture-readiness verdict using exactly one label:
   - `VERIFIED_FOR_LESSON`
   - `ENGINEERING_REVIEW_NEEDED`
   - `INCOMPLETE_NOT_STUDENT_MATERIAL`
   - `DEPRECATED_OR_SUPERSEDED`
10. if capture-ready, a KiCad capture + ERC + rendered human comparison plan; otherwise, a precise defect/action list.

The lab fails if the student fills missing physical-machine facts by assumption.

## Cross-machine transfer

The same method applies without changing the reusable-block ownership model:

- mill/lathe encoder feedback;
- plasma/router limit and process inputs;
- robot joint encoders and ordinary I/O;
- press-brake axes and valve/control I/O;
- custom automation sensor/actuator interfaces.

Machine names, connector positions and harness destinations change. The reusable electrical primitive should not silently change with them.

## Safety boundary

Machine-readable connectivity, deterministic OFF states, watchdog interfaces and exact STO/enable wiring may be essential ordinary-control engineering, but this curriculum does not assign personnel-safety credit to LinuxCNC/FPGA logic or ordinary I/O blocks. Independent safety authority requires its own safety-rated architecture and validation.

## Durable freezes from BD06

- `SEMANTIC CONTRACT != PRODUCTION CONNECTIVITY`
- `EXACT CONNECTIVITY != SCHEMATIC-READY`
- `SCHEMATIC EXISTS != ERC CLEAN`
- `ERC CLEAN != ELECTRICALLY CORRECT`
- `MACHINE-READABLE CONTRADICTION = FAIL CLOSED`
- `BOARD-SPECIFIC CONNECTOR DETAIL != REUSABLE BLOCK PROPERTY`
- `GENERATED CAD MUST BE TRACEABLE TO EXACT REVISIONED AUTHORITIES`

## Next lesson direction

BD07 should switch back to BOARD INTEGRATION and test whether independently qualified block/connection artifacts can form a complete controller without hidden joins:

`block instances -> board-specific connection blocks -> machine-readable whole-board net/resource graph -> cross-block domain/return/enable review -> kitchen-sink integration audit -> KiCad hierarchy/capture plan -> whole-board ERC/review gates`.

The main stress-test question is whether every cross-block edge has exactly one owner and whether the full board can be assembled without inventing glue logic, hidden power joins, duplicate connector authority, or undocumented FPGA/resource consumption.
