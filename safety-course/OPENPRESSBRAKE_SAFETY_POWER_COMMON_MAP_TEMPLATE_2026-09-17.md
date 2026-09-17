# OpenPressBrake Safety Power / Common-Cause Map Template

Date: 2026-09-17
Status: curriculum engineering template; machine-specific entries remain UNKNOWN until verified from the actual schematic, wiring, plumbing, installed hardware, and commissioning evidence.

## Purpose

Use this worksheet before claiming that redundant channels, safety devices, final elements, or feedback paths are independent. The map makes shared power, return, protection, connector, harness, reference, and feedback nodes visible so a single electrical/common-cause fault is not hidden behind a two-channel logical diagram.

This worksheet does **not** assign PL, SIL, diagnostic coverage, stopping distance, hydraulic pressure, or safe speed. Those require the applicable machine design and evidence.

## Evidence classes

Use only: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

For each shared node choose exactly one disposition:

- `SAFE CONSEQUENCE ESTABLISHED` — evidence establishes that the node's credible failure drives/maintains the relevant safety function in its required safe condition.
- `FAULT DETECTED / RESTART INHIBITED` — a credible fault is detected and the affected hazardous state cannot simply regain authority on recovery/reset.
- `EXCLUDED BY CONSTRUCTION + EVIDENCE` — the relevant common-cause path is excluded by a documented construction/wiring/protection measure and applicable evidence.
- `NOT SAFETY-RELEVANT` — failure cannot affect the claimed personnel-safety function; record why.
- `UNKNOWN — REVIEW REQUIRED` — evidence is missing or the consequence has not been established. Safety-critical UNKNOWN keeps the affected exposed operating state NOT CLEARED.

## Manufacturer evidence that motivates the map

1. `DOC-CONFIRMED` — SICK Flexi Soft requires an external 24-V supply suitable for the controller, safe isolation (SELV/PELV), EMC/overvoltage measures, and notes that inductive loads may require external output protection. This is evidence that supply quality, grounding, protection, and load transients are part of the safety-controller installation, not merely generic panel housekeeping.
2. `DOC-CONFIRMED` — SICK UE4457 distinguishes uninterrupted logic/input power `UL` from switchable safety-output power `US` while sharing common 0 V. It warns that an external short to 24 V can leave `US` energized after it is nominally switched off and requires FMEA to exclude that backfeed path where de-energizing `US` is relied upon.
3. `DOC-CONFIRMED` — SICK T4000 requires its two safety outputs to be processed separately, requires separate fusing of the +LA/+LB safety-circuit supplies, protected routing against cross-circuits, and contactor monitoring for the stated category-3 application. Logical dual channels therefore do not remove the need to inspect shared supply/protection/routing/feedback paths.
4. `DOC-CONFIRMED` — Pilz PNOZ 16S states that it does not detect shorts/shorts-across-contacts in the start/feedback loop and calls for suitable measures such as protected or separate installation. EDM/feedback wiring therefore needs its own common-cause review rather than being assumed independent because two final elements exist.

## A. Source and distribution inventory

Fill from the actual schematic and installed panel. Never infer a net because a design convention would normally use it.

| ID | Domain | Source / upstream protection | Nominal rail | Downstream loads | Return / reference | Connector / harness common point | Evidence | Disposition | Required verification |
|---|---|---|---|---|---|---|---|---|---|
| PWR-SAFE-CTRL | Safety controller logic | UNKNOWN | UNKNOWN | Safety controller | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED | Trace schematic and installed wiring |
| PWR-SAFE-IN | Protective devices / safety inputs | UNKNOWN | UNKNOWN | E-stop, guard/interlock, protective devices | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED | Trace each device branch and test source |
| PWR-SAFE-OUT | Safety output electronics | UNKNOWN | UNKNOWN | Safety output stage | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED | Determine whether output power is separable from logic power and what switching it proves |
| PWR-FINAL-A | Final element channel A | UNKNOWN | UNKNOWN | Contactor/valve/brake coil A | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED | Trace fuse, suppressor, connector and return |
| PWR-FINAL-B | Final element channel B | UNKNOWN | UNKNOWN | Contactor/valve/brake coil B | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED | Trace fuse, suppressor, connector and return |
| PWR-EDM | EDM / feedback wetting/reference | UNKNOWN | UNKNOWN | Auxiliary/position feedback | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED | Trace whether A/B feedback can be falsely asserted by one shared fault |
| PWR-FPGA | Ordinary FPGA/controller | UNKNOWN | UNKNOWN | FPGA, Ethernet, normal I/O | UNKNOWN | UNKNOWN | UNKNOWN | NOT YET CLASSIFIED | Prove ordinary-control faults cannot become sole safety authority |
| PWR-PROP-FIELD | Proportional field output | UNKNOWN | UNKNOWN | Proportional valve driver/coils | UNKNOWN | UNKNOWN | UNKNOWN | NOT YET CLASSIFIED | Trace interaction with independent safety energy-removal path |
| PWR-SENSORS | Ordinary machine sensors | UNKNOWN | UNKNOWN | Position/current/pressure/etc. | UNKNOWN | UNKNOWN | UNKNOWN | NOT YET CLASSIFIED | Classify any sensor also consumed by safety logic |
| PE-FE | PE / FE / bonding | UNKNOWN | n/a | chassis, DIN rail, shields | n/a | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED | Verify installed bonds and whether FE/0-V faults can defeat diagnostics |

## B. Shared-node common-cause register

Create one row for **every** node shared by nominally independent safety channels or by safety and ordinary control.

| Shared node | Paths that depend on it | Credible fault | Can both channels agree falsely? | Can hazardous energy remain/reappear? | Detection / restart inhibit | Construction exclusion | Evidence | Disposition |
|---|---|---|---|---|---|---|---|---|
| 24-V source | UNKNOWN | loss / sag / surge / internal fault | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED |
| 0-V return | UNKNOWN | open / high resistance / unintended bond / short | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED |
| upstream fuse/breaker | UNKNOWN | open / wrong rating / bypass / common trip | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED |
| distribution terminal | UNKNOWN | loose conductor / bridge / wrong jumper | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED |
| multipole connector | UNKNOWN | pin bridge / miswire / partial unplug / conductive contamination | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED |
| shared cable/harness | UNKNOWN | crush / abrasion / heat / cross-short | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED |
| suppression network | UNKNOWN | short / open / wrong replacement | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED |
| EDM common/reference | UNKNOWN | short to asserted state / open / common conductor fault | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED |
| safety/ordinary-control interface | UNKNOWN | backfeed / wrong mapping / shared reference / stale state | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN — REVIEW REQUIRED |

## C. Cross-domain questions

A `YES` answer does not automatically mean unsafe; it means the consequence must be established.

- Do safety controller logic and safety output power share one source, fuse, return, connector, or distribution block?
- Do channel-A and channel-B final-element coils share upstream protection or a common return conductor?
- Can ordinary FPGA/controller 24 V backfeed a safety-output or final-element rail through I/O protection, pullups, interface modules, USB/service wiring, Ethernet shields, or another field device?
- Can a short in a multipole connector bridge two nominally independent channels or bridge output power to a switched-off safety rail?
- Are dual safety-input test sources actually independent where the claimed diagnostic architecture requires them to be?
- Do two EDM channels share a conductor, wetting source, connector pin group, PLC mapping, or synthesized status bit capable of making both appear healthy from one fault?
- Can a suppressor/TVS/RC network fail short and defeat de-energization or create a common fuse trip affecting both channels?
- Does loss and restoration of a shared supply require deliberate safety reset and separate ordinary-control rearm, or can stale commands regain actuator authority?
- Does opening a safety output actually remove the physical energy needed for hazardous motion, or only remove an ordinary command signal?
- Are protective-earth / functional-earth / shield / 0-V connections installed as documented, and can an unintended bond create a diagnostic bypass or backfeed path?

## D. Final-element and physical-energy correspondence

For every safety function, map both the electrical control chain and the physical hazard chain.

| Safety function | Protective device | Safety logic | Output power path | Final element A | Final element B | EDM/feedback | Physical energy interrupted/restrained | Shared nodes | Status |
|---|---|---|---|---|---|---|---|---|---|
| Emergency stop | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | NOT CLEARED |
| Guard/protective device demand | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | NOT CLEARED |
| Setup/service protective function | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | NOT CLEARED |
| Unexpected-restart prevention | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | NOT CLEARED |

Do not mark a row CLEARED from a HAL bit, FPGA register, safety-controller LED, or coil command alone. The physical energy consequence must be established.

## E. Fault challenges for commissioning

Only perform energized challenges under an approved machine-specific commissioning plan. Where a basic minimum-safe-to-operate threshold is not established, keep personnel outside the danger zone and use isolated/remote experimental operation if testing is justified.

1. Remove safety-controller logic supply: record final-element state and restart behavior.
2. Remove only safety-output/final-element supply where architecture permits: prove no alternate/backfeed source maintains hazardous authority.
3. Open channel-A coil branch, then channel-B: prove discrepancy/EDM response and restart inhibition.
4. Open or fault each EDM path individually; then assess credible common EDM faults without defeating safeguards in an exposed operating state.
5. Cycle ordinary FPGA/controller power independently from safety power: prove ordinary reboot/recovery cannot create safety reset or hazardous restart.
6. Cycle shared upstream power: prove restoration does not combine safety reset, ordinary-control rearm, and START.
7. Inspect connector/harness faults by de-energized continuity/isolation methods before considering any live fault injection.
8. Verify installed fuses/protection against drawing/BOM identity; a substituted fuse, jumper, suppressor, or terminal bridge is a configuration change requiring impact review.

## F. Design-review acceptance gate

The safety power/common map is acceptable for the reviewed safety function only when:

- every safety-relevant source, return, protection element, connector/harness common point, final-element coil branch, and EDM reference is identified;
- every shared node has an evidence-backed disposition;
- no `UNKNOWN — REVIEW REQUIRED` remains on a path whose failure could preserve or restore hazardous energy while people are exposed;
- ordinary LinuxCNC/HAL/FPGA power and command paths are not the sole personnel-safety authority;
- reset, ordinary-control rearm, and START remain distinct after every relevant power-restoration case;
- the physical hazardous-energy consequence has been verified, not merely the logical output state;
- installed-state evidence matches the drawing/configuration baseline.

## Handoff to board-design automation

The board-design lane should fill this template from the actual schematic/netlist rather than redesigning the safety architecture here. It should return unresolved shared nodes as explicit questions/evidence gaps. It must not infer machine hydraulic behavior, safe stopping values, PL/SIL/DC, or personnel-safety performance from the controller board alone.

## Sources

- SICK, *Flexi Soft Modular Safety Controller — Hardware Operating Instructions*, current published manual retrieved 2026-09-17.
- SICK, *UE4457 IP67 Safety Remote I/Os and Safety Remote Controller for DeviceNet Safety*, power-supply installation section; warning concerning external 24-V short/backfeed to switched output supply.
- SICK, *T4000 Standard Operating Instructions*, 2024-10-02, dual-channel/isolated safety-output connection guidance.
- Pilz, *PNOZ 16S Operating Manual*, 1003518-EN-12, feedback-loop/start-loop short-circuit limitation and protected/separate-installation guidance.
