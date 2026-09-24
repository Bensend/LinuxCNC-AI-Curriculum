# Safety restart/rearm/output-witness and architecture audit — 2026-09-24

Status: durable 4000-series curriculum engineering evidence. This is not a machine-specific certified design.

## Question

Do the reusable `SC-CORE` and `SO` templates survive adversarial restart/rearm and misleading-witness cases, and do they remain generic when checked against materially different professional safety architecture families?

## Evidence classes

Claims below use `DOC-CONFIRMED`, `INFERENCE`, or `UNKNOWN`. Product manuals establish behavior only for the cited product/family; they do not establish a universal machine design.

## Professional architecture family A — safety controller / safety logic owns reset semantics

Rockwell GuardLogix safety instructions separate safety-input validity, reset action and safety output enable. The current DCST documentation states that its output can energize only when both safety inputs are active and the correct reset actions occur. It also warns that some safety standards require monitored reset transitions and may require additional edge-checking logic. `DOC-CONFIRMED`.

Rockwell's DCM documentation is even more explicit that reset edge behavior can be a standards/application requirement rather than a generic `reset=true` level. `DOC-CONFIRMED`.

This family demonstrates that reset semantics may reside in programmable safety logic and may depend on instruction configuration/application logic. Therefore the curriculum SHALL NOT assign a universal edge, polarity, timing window, or held-reset behavior to `SC-CORE`. Those are selected-product/application facts.

## Professional architecture family B — protective device plus external restart/EDM circuitry

SICK deTec4 Core documentation states that the protective device has no internal restart interlock and that restart interlock must be implemented externally where required. It describes reset from a pushbutton outside the hazardous area after interruption of the protective field. The same manual states that EDM monitors downstream contactor status and, because deTec4 Core lacks integrated EDM, it must be implemented in external control where required. `DOC-CONFIRMED`.

This is materially different from family A: restart/EDM ownership can be external to the sensing device rather than embedded in one programmable safety instruction. Therefore the reusable templates correctly require explicit ownership instead of assuming one location.

## Professional architecture family C — configurable safety relay with monitored start and feedback loop

Pilz PNOZ s4 documentation provides an example dual-channel safety-gate architecture with cross-contact detection, monitored start and feedback-loop monitoring. `DOC-CONFIRMED`.

This third family reinforces that a compact safety relay can own input diagnostics, monitored start and feedback-loop behavior without implying GuardLogix-style software semantics or SICK-device-local behavior.

## Adversarial restart/rearm review

| Attack / misleading state | Required response in reusable contract | Evidence conclusion |
|---|---|---|
| Reset button stuck/held active | Do not assume a maintained level constitutes a fresh deliberate reset. Selected product/application must define monitored transition behavior; failure to satisfy it prevents rearm where required. | `DOC-CONFIRMED` that transition monitoring can be required; exact polarity/timing `UNKNOWN` until selection. |
| Reset located where safeguarded space cannot be seen | Do not credit reset as occupancy clearance. Require machine/site occupancy/restart strategy and reset placement evidence. | SICK shows reset outside hazardous area; visibility/occupancy remains application-specific. |
| Gate closes while a person remains inside | Gate state may satisfy an input proposition but not `space empty`. Rearm requires separately justified occupancy/restart controls where whole-body access exists. | `INFERENCE` from proposition discipline; machine-specific implementation `UNKNOWN`. |
| Reset accepted while ordinary cycle request is already asserted | Reset acceptance SHALL NOT itself be treated as a start command. Hazardous restart needs the separately authorized normal-control transition required by SRS/architecture. | Existing curriculum freeze retained: `RESET ACCEPTED != HAZARDOUS MOTION COMMANDED`. |
| EDM/contact feedback looks healthy but contactor power path is still hazardous | Credit EDM only for the supported external-device/contact state. Require physical proposition/witness at the layer demanded by SRS. | SICK documents EDM as downstream contactor-status monitoring; it does not prove every hazardous-energy proposition. |
| Feedback sensor changes but the mechanical final element does not achieve safe state | Treat as plausible-but-wrong feedback / dependency fault. Do not rearm solely from the signal. Trace sensor target, mechanism and shared dependencies. | `INFERENCE`; exact diagnostic capability product-specific. |
| STO reports active while gravity/external load can move axis | STO cannot be the sole physical witness for load restraint. Require separately justified brake/restraint/position or other physical evidence. | Existing source-audited freeze retained. |
| Safety controller loses and regains power | Power restoration SHALL NOT silently substitute for reset/rearm/start. Exact startup state must come from selected product and machine SRS. | Product/application specific; generic behavior `UNKNOWN`. |
| Final-element/pilot supply disappears and returns | Analyze whether loss itself creates, preserves or releases hazardous energy and whether restoration can cause motion. Do not infer safety from controller output state. | `INFERENCE`; machine/final-element behavior `UNKNOWN` until selection. |
| Common 24 V/0 V or shared pilot source affects actuation and feedback | Treat as `DEP-*`/CCF candidate. A matching command/feedback pair under a common dependency is not independent proof. | Consistent with prior CCF review. |
| Service/maintenance override remains active after mode transition or power cycle | Override must have explicit bounded authority, indication, exit/restoration behavior and validation. Ordinary production rearm cannot erase maintenance isolation requirements. | Existing contract retained. |
| HMI/LinuxCNC says `safe` while safety controller/final-element evidence disagrees | HMI/LinuxCNC state has diagnostic value only; it cannot override independent safety demand or establish the physical safe state. | Existing authority boundary retained. |

## New freezes

1. **RESET INPUT ACTIVE != DELIBERATE RESET EVENT PROVED.**
2. **RESET DEVICE ACCESSIBLE != SAFEGUARDED SPACE CLEAR PROVED.**
3. **POWER RESTORED != REARM ELIGIBLE.**
4. **MATCHING COMMAND/FEEDBACK != INDEPENDENT PHYSICAL WITNESS.**
5. **FINAL-ELEMENT FEEDBACK HEALTHY != COMMON DEPENDENCY ABSENT.**

These refine rather than replace `RESET ACCEPTED != HAZARDOUS MOTION COMMANDED`.

## Template audit result

`SC-CORE_IMPLEMENTATION_SPEC_TEMPLATE.md` already requires reset type, exact selected-product sequence/timing, stuck/held behavior, reset location/visibility, occupancy proposition, fault-latch ownership and power-cycle behavior. It therefore survives the three architecture families without encoding a vendor-specific reset implementation.

`SO_FINAL_ELEMENT_IMPLEMENTATION_SPEC_TEMPLATE.md` already requires the exact energy path, final-element witness, physical hazard proposition, feedback independence/CCF, power/fault transitions, gravity/external-force analysis, rearm conditions and maintenance boundary. It survives the adversarial witness cases provided implementers do not collapse final-element feedback into physical proof.

A small strengthening is still warranted at schematic-freeze time: selected implementations must provide a concrete evidence packet rather than merely completing prose fields.

## Minimum evidence package before schematic capture

A selected safety block may advance from generic template to schematic capture only when all applicable items below exist and are traceable:

1. **Selected product identity and revision** — exact manufacturer part/family, safety manual/datasheet revision, supply/environment/interface limits and applicable configuration mode.
2. **Traceability allocation** — concrete `SRS-*`, `PHY-*`, `AUTH-*`, `DEP-*`, `ARC-*`, `VAL-*`, relevant `HF-*`/`CHG-*`, and unresolved `UNKNOWN` entries.
3. **Electrical interface evidence** — selected-device input/output thresholds, pulse/test behavior, load/current limits, de-energized state, protection and wiring constraints where applicable. No generic values substituted.
4. **State/restart semantics** — startup, power loss/restoration, reset/rearm sequence, held/stuck reset response, fault latching/clearing, mode/service transitions and separation from ordinary start.
5. **Energy-path definition** — exact hazardous-energy path affected and what remains hazardous after the block acts.
6. **Witness proposition** — each feedback signal states exactly what it proves and does not prove; required physical witness is named separately.
7. **Dependency/CCF record** — shared 24 V/0 V, protection, connector/cable, test source, processor/resource, output/pilot supply, feedback target, mechanical path, reset/configuration and service/debug dependencies reviewed.
8. **Failure-state table** — at minimum open/short/stuck where applicable, supply loss/restoration, controller reset/configuration, feedback disagreement, final-element failure and common-dependency failure.
9. **Human/service boundary** — bypass/muting/service authority, indication, restoration test, replacement constraints and safeguard restoration made practical.
10. **Validation plan** — test IDs and observable witnesses for normal demand/rearm and credible faults, with machine-specific acceptance criteria left `UNKNOWN` until justified.
11. **Integrity claim boundary** — component PL/SIL/category claims, if used, are recorded as component evidence only; achieved machine safety-function integrity is not inferred from the component label.
12. **Open-unknown disposition** — every remaining UNKNOWN is explicitly classified as schematic-blocking, machine-validation-blocking, or safely deferrable with rationale.

### Schematic-capture gate

Schematic capture is permitted only when items 1–9 are complete enough to prevent invented electrical behavior and item 10 identifies how the resulting implementation will be checked. Any UNKNOWN that can change pin/interface compatibility, fail-safe state, diagnostic behavior, reset/rearm behavior, energy-path authority, or a safety-critical dependency is **schematic-blocking**.

Passing this gate authorizes engineering capture, not machine operation, certification, achieved PL/SIL, or machine-level validation.

## Compute decision

No executable question remained after source/architecture reasoning. No simulation, build, synthesis, benchmark or test suite is justified by this audit. Future compute must answer a concrete selected-device implementation question and must use `[self-hosted, openpressbrake]` only.

## Next work

1. Fold the five new freezes and evidence-package gate into the reusable implementation contracts/templates where they improve enforcement.
2. Build a learner-facing selected-block qualification worksheet/checklist from the minimum evidence package.
3. Then choose one non-machine-specific, inspectable professional safety input/core/output reference architecture only as a **worked qualification example**, not as the generic design; keep its product-specific values fenced from reusable requirements.
4. Do not freeze a generic safety schematic.
