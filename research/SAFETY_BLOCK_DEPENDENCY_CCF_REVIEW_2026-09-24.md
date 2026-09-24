# Safety block dependency / common-cause adversarial review — 2026-09-24

Status: curriculum engineering review; not a machine-specific safety validation.

Session start: `2026-09-24T08:33:07Z`.

## Question

Before reusable `SI-DRY2`, `SI-OSSD2`, and `FS-IF` circuits are frozen, which shared dependencies can make apparently redundant channels or layers fail together, and what evidence must a concrete implementation provide?

## Method

Attack the architecture at shared physical resources rather than counting channels. For every dependency ask:

1. Can one fault or service error make both channels appear permissive, unavailable, or diagnostically misleading?
2. Can the same dependency defeat the safety action and the witness intended to prove it?
3. Does a power/reset/configuration transition create a temporary authority gap?
4. Can ordinary maintenance/debug behavior defeat the safety boundary more easily than it can be restored correctly?
5. Is the claimed diagnostic independent of the fault it is supposed to detect?

The source-audited freezes in `research/SAFETY_INPUT_AND_FPGA_INTERFACE_SOURCE_AUDIT_2026-09-24.md` remain controlling: dual contacts alone do not establish cross-short detection; OSSD compatibility is device-pair specific; discrepancy ownership must be explicit; and FPGA inhibit status is not a physical safe-state witness.

## Adversarial dependency matrix

| Shared dependency / attack | Failure that can defeat apparent redundancy | Required design record / evidence | Credit rule |
|---|---|---|---|
| common field 24 V | supply fault can disable both input channels/device; some fault polarities may create ambiguous signal states | supply topology, loss/overvoltage behavior, input/device manuals, `VAL-*` power-fault test | two channels do not equal two supplies |
| common 0 V/reference | open/shift can move both electrical channels outside valid thresholds or create false interpretation | return topology, threshold margins, broken-reference behavior | shared reference is `DEP-*` |
| one fuse/PTC/protection device | single open/short can remove or bridge both channels | component failure effect and downstream reaction | shared protection prevents independence credit unless justified |
| shared surge/EMC/filter network | component short/open may couple A/B or suppress diagnostic pulses | per-channel/shared component map and fault analysis | filtering cannot be assumed diagnostically transparent |
| common connector body | contamination, bent pins, conductive debris, mis-mating or pin swap can affect both channels | keyed/polarized connector, pin separation, replacement check | connector is a common physical dependency |
| common cable/bundle | crush/cut can short A-B or both to 24 V/0 V | cable topology plus diagnostic coverage for relevant shorts | redundancy without short coverage is limited |
| shared test-pulse source | A-B short may become invisible when both channels carry the same source pattern | exact source assignment and manufacturer diagnostic limits | **same source != cross-short independence** |
| common input ASIC/filter/timing resource | one internal fault/config error may affect both channel interpretations | selected safety-I/O architecture and product safety manual | do not infer internal independence from two terminals |
| duplicated discrepancy checking | one layer can mask or consume evidence expected by another | single declared discrepancy owner; intentional duplicate behavior documented | ambiguous ownership blocks freeze |
| OSSD + receiver incompatible filtering | diagnostic OFF pulse can be misread as demand or dangerously filtered beyond supported semantics | device-pair pulse/filter compatibility table | no universal pulse/filter values |
| common sensor + receiver supply/reference | supply fault can affect both OSSD outputs and their interpretation | product fault behavior and supply architecture | self-testing outputs do not remove shared supply dependency |
| safety controller + FPGA shared supply | one rail fault may reset both independent-safety logic and ordinary inhibit consumer simultaneously | rail/reset sequencing and independent final-element response | logical separation is not physical independence |
| shared reset supervisor | one reset fault can hold/release multiple channels or layers together | reset-tree schematic and stuck/reset transition analysis | reset is `DEP-*`, not housekeeping |
| FPGA configuration memory/boot pins | corrupted image or boot strap can alter normal output gating and diagnostic copy together | unconfigured/config-failure behavior plus independent final-element path | FPGA-side inhibit cannot be sole safety layer if configuration can remove it |
| JTAG/debug header | technician/tool can force state or bypass gating | production accessibility, disable/remove policy, service procedure, restoration validation | bypass-capable debug is safety dependency |
| service jumper/test fixture | jumper left installed can create persistent defeat | keyed/controlled service mode, indication, bounded authority, post-service proof test | easy-to-forget bypass blocks release |
| common level shifter/isolator | single component fault can couple safety inhibit and diagnostic or force a permissive level | component-level fault analysis and independent witness | diagnostic through same failed element is not independent proof |
| common FPGA pin bank/reference | bank supply/config fault can affect inhibit input and status output together | pin-bank power/reset analysis | matching status may be common-cause-corrupted |
| shared safety-output supply | one failure can defeat multiple contactors/valves or their indication | final-element supply architecture and fault response | dual logic channels != redundant final elements |
| common hydraulic/pneumatic pilot supply | pilot loss/contamination may affect multiple valves in the same direction | machine-specific hydraulic/pneumatic evidence | remains UNKNOWN until machine circuit is known |
| shared feedback supply/sensor mechanism | final element and its witness can fail together or feedback can remain plausible | feedback independence/failure-mode analysis | EDM/position feedback proves only supported proposition |
| common mechanical linkage | two electrical channels may actuate one mechanism whose jam defeats both | physical mechanism/failure analysis | electrical redundancy cannot overcome one mechanical choke point |
| maintenance replacement | wrong device, changed OSSD pulse behavior, swapped pins or generic substitute invalidates prior evidence | part-control + `CHG-*` + stale-evidence review + restoration test | replacement is not automatically equivalent |
| firmware/configuration update | update can change filtering, reset behavior, pin mux or diagnostics | controlled revision, diff/review, revalidation trigger | safety-relevant config change makes dependent evidence STALE |

## Cross-layer adversarial cases

### CCF-01 — both input channels look independent but share one test source

A field short A-B can cause both inputs to follow the same source. Manufacturer evidence already shows that some safety-input architectures cannot detect a cross-short when both channels use the same test source.

**Required outcome:** the implementation either assigns diagnostically independent sources as supported by the selected product or explicitly declines cross-short diagnostic credit. `DUAL DRY CONTACT != CROSS-SHORT DETECTION` remains frozen.

### CCF-02 — diagnostic copy shares the failed FPGA element

An inhibit enters a level shifter/FPGA bank and the status returned to LinuxCNC is generated from the same internal resource. A common pin-bank, configuration, or logic fault can corrupt both action and report.

**Required outcome:** LinuxCNC status is never used as proof of physical safety. Validation follows the authority chain to an independent final-element/physical witness appropriate to `PHY-*`.

### CCF-03 — controller and FPGA reset together

A shared supply or reset supervisor drops both the safety controller interface and normal FPGA. If the physical final element requires maintained power or pilot energy to reach/hold the safe response, simple de-energization cannot be assumed safe.

**Required outcome:** selected final-element physics determine the safe response. Until then, loss-of-power behavior is UNKNOWN; no generic fail-safe claim is allowed.

### CCF-04 — service bypass survives maintenance

A JTAG force, manufacturing fixture or service jumper makes troubleshooting convenient but remains fitted after service.

**Required outcome:** bypass-capable paths require bounded authority, visible indication where applicable, controlled accessibility, explicit restoration and a post-service `VAL-*` proof test. If correct restoration is harder than leaving the bypass, the design fails the human-factors gate.

### CCF-05 — OSSD replacement is electrically similar but diagnostically different

A replacement 24 V PNP safety sensor has different diagnostic-pulse or leakage behavior. Existing receiver filtering may nuisance-trip or may suppress behavior outside the qualified pair.

**Required outcome:** replacement of the selected OSSD family/device is a `CHG-*` event unless equivalence is supported. The compatibility table and affected validation evidence become STALE until reviewed.

### CCF-06 — final-element and feedback share one energy source

A contactor/valve and its feedback circuit share a supply or mechanism such that one failure can both defeat actuation and leave plausible feedback.

**Required outcome:** record the shared dependency and bound what the feedback proves. `EDM HEALTHY != PHYSICAL SAFE STATE PROVED` and `VALVE POSITION EXPECTED != RAM SAFE STATE PROVED` remain controlling.

## Human-factor release test

A concrete design does not pass this review merely because faults are documented. It must make correct use/restoration practical:

- normal troubleshooting must not require defeating the safeguard;
- connectors and labels should make channel swaps and generic substitutions difficult;
- diagnostic access should expose useful channel/fault state without granting bypass authority;
- service/programming bypasses should be controlled, conspicuous where practical, and included in post-service proof testing;
- replacement instructions must identify device-pair compatibility assumptions, not merely nominal voltage;
- guards and protective devices should be easier to reinstall correctly than to discard or jumper.

## Schematic-freeze verdict

**Generic family schematics remain NOT FROZEN.** The new implementation-spec templates are ready to instantiate, but a concrete circuit still requires selected products/resources and application evidence.

Before any concrete `SI-DRY2` schematic is credited, complete `hardware/SI-DRY2_IMPLEMENTATION_SPEC_TEMPLATE.md` with the selected input architecture, test-source assignment and diagnostic coverage.

Before any concrete `SI-OSSD2` schematic is credited, complete `hardware/SI-OSSD2_IMPLEMENTATION_SPEC_TEMPLATE.md` for the exact OSSD/receiver pair.

Before any concrete `FS-IF` schematic is credited, complete `hardware/FS-IF_IMPLEMENTATION_SPEC_TEMPLATE.md` naming the exact inhibited FPGA resource and independent final-element authority chain.

## Remaining UNKNOWNs / next work

No generic PL/SIL target, diagnostic-coverage number, discrepancy time, OSSD threshold/pulse/filter, stopping limit, hydraulic truth table, valve fail state, pressure threshold or proof-test interval is established here.

The next highest-value implementation work is to source-audit the `SC-CORE` and `SO` family boundaries, especially reset/rearm semantics, EDM/contact feedback limits, STO final-element claims, valve/dump feedback, and loss-of-power behavior. That work should produce corresponding implementation-spec templates before any reusable safety-controller/output schematic is frozen.

No executable question survived engineering/source reasoning in this review; no simulation/build/test compute is justified by this artifact.