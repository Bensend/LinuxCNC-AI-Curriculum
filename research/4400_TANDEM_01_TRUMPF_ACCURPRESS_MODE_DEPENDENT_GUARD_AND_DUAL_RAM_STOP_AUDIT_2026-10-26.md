# 4400 TANDEM-01 — two press brakes, one workpiece: safety-zone topology and mode-switch source audit (2026-10-26)

**State:** DOC-CONFIRMED manufacturer product-family statements, engineering INFERENCE and selected-machine UNKNOWN. No selected installation, as-built safety wiring, physical test, numerical stop time, PL/SIL or blind competency result. The previously published generic cross-machine safety modules remain prerequisites; this investigation adds an **actual OEM press-brake tandem/stand-alone topology** rather than treating two machines as two independent CNC axes.

## Question frozen before source reading

When two otherwise independently usable press brakes are coupled to form one long workpiece, does an ordinary CNC tandem selector or synchronized Y motion establish (a) personnel-protection coverage across the combined length, (b) a physically safe state after either station requests a stop, or (c) safe stand-alone separation? **Predicted from architecture:** no; separate safety-zone and final-element evidence is needed. The evidence below supports the *existence* of mode-dependent guarding in one OEM product, not its detailed circuit, reaction time or fault behavior. This is a documentary prediction comparison, **not** TEST-CONFIRMED.

## Original manufacturer sources and exact scope

1. **TRUMPF, official German press release, 2017-02-02, TruBend Series 8000 tandem.** https://www.trumpf.com/de_INT/newsroom/pressemitteilungen-lokal/pressemitteilung-detailseite-lokal/release/aus-zwei-mach-eins-trumpf-bietet-tandemversion-der-trubend-serie-8000/ — section `Eilgeschwindigkeit auch im Tandembetrieb`. **DOC-CONFIRMED:** in stand-alone operation a protective door separates the machines; in tandem operation the door retracts automatically to allow full-length bending. The two machines' BendGuard systems are connected so the full bending length is monitored. Each machine can also work individually. The announcement also describes precise mechanical table joining and synchronization for bending accuracy. **Limits:** publicity source, not the circuit diagram, validation report, protective-door interlock truth table, stop-zone timing or selected machine serial.
2. **Accurpress, manufacturer HT options page, `Tandem Mode` section (accessed 2026-10-26).** https://www.accurpress.com/accurpress-ht-options — **DOC-CONFIRMED:** two or more Accell HT machines can operate as one, their controllers exchange information for synchronized forming, and an operator chooses single or tandem operation by selector. **Not documented there:** whether that selector is safety-rated, whether any E-stop/guard input withdraws both machines' hazardous energy, or how the mode is validated.
3. **TRUMPF, official TruBend 8000 brochure, original manufacturer.** https://www.trumpf.com/filestorage/TRUMPF_US/Corporate/Corporate_Brochures_and_publications/TRUMPF-bending-machines-brochure-EN.pdf — tandem and stand-alone capability corroborated for this product family; brochure is not a safety validation specification.
4. **OSHA powered press-brake machine-guarding eTool, official regulator, `Point of operation`.** https://www.osha.gov/etools/machine-guarding/presses/powered-press-brakes — official search-index excerpt reports that large stock moves up/down during bending and can create slide-front pinch exposure; its full page returned 403 in this session, so this is **DOC-CONFIRMED excerpt only**, not a complete regulatory analysis. Do not transfer mechanical-power-press requirements automatically to powered press brakes.

## New failure-path model (engineering INFERENCE; not an OEM wiring claim)

| Mode / transition | Hazardous event to prevent | Safety-related authority / physical witness to establish | False proof to reject |
|---|---|---|---|
| A stand-alone; B stand-alone | independent ram/workpiece movement, seam/access gap, neighboring station reach | validated physical separation/interlock, each station's stop/hold/guard/rearm, both sides of boundary | both HMI screens say `SINGLE` |
| A+B tandem | long sheet bridges stations; one ram stops while other moves; center seam tooling/stock damage, strike/pinch | selected-machine safe coordinated stopping/holding for BOTH rams under demand from EITHER relevant protective device, plus whole-length coverage and load behavior | matched Y positions, same LinuxCNC HAL signal, common cycle-start |
| transition SINGLE→TANDEM | barrier retracts before full-length safeguarding is ready; retained start/pedal command | physical barrier state, correct safety-zone selection, independent protective device readiness, zero dangerous motion during transition, deliberate fresh start | CNC selector changed or `BendGuard connected` in marketing |
| transition TANDEM→SINGLE | physical separation not complete; cross-station command persists; guards still mapped to wrong mode | barrier restored and verified for actual geometry, new zone mapping and fresh local operator ownership | two CNC controllers show `READY` |
| network/encoder/controller failure | only one machine stops or drifts; sheet couples machines mechanically | independent stop/hold and gravity restraint, fault handling for partial-stop/asymmetric state, qualified post-fault release | link watchdog, synchronizing control error, shared 24 V |
| one E-stop/laser/door actuation | other station remains hazardous in shared-workpiece mode | selected hazard-zone response and final-element evidence for both, with actual stopping/holding witness | one output indicator OFF |
| emergency rescue / service | trapped person or unrestrained sheet; restart by another station | multi-person lockout/energy isolation, physical ram and sheet restraint, deliberate recovery authorization and visible area-clearance | any one station's E-stop/reset or pump OFF |

The **workpiece is a mechanical coupling**, not a safety-rated interlock. Even when the two machines have independent electrical controls, a bridging sheet can transfer load and create a shared hazardous region. A single synchronized CNC command does not prove the combined safety function.

## Authority allocation and anti-shortcut design

- **Normal control:** LinuxCNC, HM2/FPGA, CNC selector, trajectory sync and HMI request `SINGLE`/`TANDEM`; useful for production, never the sole personnel-safety boundary.
- **Monitoring:** mode annunciation, door position, laser diagnostics, Y1/Y2 readings, link health and event timestamps; useful evidence but may be stale/common-cause.
- **Independent safety-related control:** selected qualified architecture owns permissible mode, guard/door protective-device coverage, stop-demand propagation, restart inhibit and actual final-element command; exact mode truth table is **UNKNOWN** until selected OEM/qualified design evidence.
- **Physical safe state:** BOTH actual ram/load stopping and gravity retention, relevant hydraulic/electrical energy isolation for service, workpiece/support stability and access control. Physical witness is distinct from a safety-controller output.
- **Human factors:** clear large `SINGLE A` / `SINGLE B` / `TANDEM` status at **both** stations; unambiguous local command ownership, accessible E-stops, protected/visible barrier, no automatic restart on mode change, easy-to-use guarded setup. If safe changeover takes more work than bypassing a door or using a temporary jumper, redesign the changeover.

## Evidence ledger

| Claim | Class | Scope and limitation |
|---|---|---|
| TRUMPF tandem has stand-alone separating door, auto retraction in tandem, interconnected BendGuard | **DOC-CONFIRMED** | TRUMPF Feb 2017 announcement, **TruBend 8000** product family only |
| Accurpress supports tandem controller exchange and simple selector | **DOC-CONFIRMED** | Accell HT manufacturer options, not safety-rated selector proof |
| An asymmetric physical stop may threaten people via bridging stock | **INFERENCE** | credible mechanical coupling hazard; machine-specific geometry/load and risk analysis required |
| CNC sync or one station's safety status proves combined stop | **NOT ESTABLISHED** | no qualified electrical/hydraulic as-built or physical proof |
| LinuxCNC source contains a safety-rated tandem machine protection function | **UNKNOWN** | no new pinned LinuxCNC source trace performed; ordinary control assumed non-safety |
| OpenPressBrake is a tandem installation | **UNKNOWN** | do not open tandem-specific Stage B unless private Stage A confirms |
| Exact PL/SIL, stopping time/distance, hydraulic valve states, pressure, shared-stop truth table | **UNKNOWN** | do not invent values |
| Independent physical validation and external competency | **NOT RUN** | no TEST-CONFIRMED result, no blind score |

**Evidence classes:** SOURCE-CONFIRMED new LinuxCNC **none**; DOC-CONFIRMED OEM statements above; TEST-CONFIRMED **none**; COMMUNITY-REPORTED **none relied on**; INFERENCE safety architecture/failure paths; UNKNOWN selected-machine and validation facts.

## Bounded follow-up / information-gain stop

The product-level question is answered: a real tandem OEM explicitly changes a **physical separating guard and linked safeguarding topology** between modes. The selected-machine question cannot be closed without qualified as-built topology, exact guard and safety-controller manuals, both hydraulic final-element/ram support paths, fault response and physical proof. Do not create a simulated `tandem E-stop` lab without those facts; a toy success would be non-authoritative. Instead use the [TANDEM-01 field module](../safety-course/4400_TANDEM_01_DUAL_PRESS_MODE_GUARD_STOP_AND_FRESH_START_FIELD_MODULE_2026-10-26.md) and independent handoff. **G0/G1 HOLD; no personnel-exposed hazardous operation.**


## 2026-10-28 TANDEM-02 original-manual source-depth correction
[Direct Cincinnati EM-519 2019 pp. 8-6–8-10 addendum](4400_TANDEM_02_CINCINNATI_MASTER_ONLY_LIGHT_GUARD_SLAVE_FOOTSWITCH_AND_TONNAGE_DISPLAY_SOURCE_DELTA_2026-10-28.md) establishes a **specific counterexample to assuming a visible slave protective device remains active in TANDEM mode**: its p. 8-9 says a light guard connected to the slave **will not be active**; the required full-length guard connects to the master. The manual separately makes slave footswitch/palm commands inactive while keeping slave E-stop among active controls. It also warns that diagnostic/programmed tonnage does not equal actual tonnage for short bends. This **does not invalidate** TANDEM-01's hazard-zone model; it makes selected input authority and diagnostic proxy review more precise. No assertion that OpenPressBrake has a tandem option, no circuit truth table or physical test. G0/G1 HOLD.
