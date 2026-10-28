# 4400 HYD-DRAIN-01 — Shared pilot/tank drain surges can shift a spool without a new CNC command
**Session:** 2026-10-28T08:31:37.518Z | **Status:** original manufacturer documentary audit, NON-GRADUATED; physical machine UNKNOWN.

## Question and novelty check
Could a common hydraulic return/drain pressure surge cause an unexpected directional-valve spool shift even if LinuxCNC has not issued a new motion command? **The inspected Parker manufacturer manual explicitly warns of this possibility for its directional-valve family.** Earlier HYD-SURGE-01 establishes missed transient peaks; HYD-INT-01 establishes blocked rod-side intensification; CP-01..06 cover pilot/relief; PWR/RST and COIL-SUP cover electrical stop/restart. **New discriminator:** *shared hydraulic drain line as an unintended actuation path*, plus exact detent behavior on power/pilot loss and a catalog-defined external-drain mitigation. This does not prove an installed OpenPressBrake fault.

## Original primary evidence
Parker Hannifin, [Directional Control Valves Series D111VW, Catalog MSG14-2500/US, installation information printed A257](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Valve-Division/hydraulicvalve/Catalog-sections-for-websphere/Industrial-Directional-Control/Catalog---Static-Files/D111VW.pdf), original PDF p.11 (zero-based page 10) directly opened and page image inspected on 2026-10-28. The inspected pages do not state a publication year; preserve catalog number rather than guessing.

| ID | Class | Exact manufacturer statement / implication | Scope |
|---|---|---|---|
| **DRAIN-01** | **DOC-CONFIRMED** | Shared tank/drain-line flow surges can cause **unexpected spool shift**; detent styles are most susceptible; separate tank and drain lines are recommended where surges are expected (A257). | Family-specific installation warning, not a measured fault. |
| **DRAIN-02** | **DOC-CONFIRMED** | On electrical/pilot-pressure failure, spring-offset/centered styles move to their spring-held position; **detented styles remain at last held position**; if main flow persists, actuators may continue undesirable movement/sequence (A257). | Printed installation table and style definitions must be matched to exact ordered SKU. Do not assume every D111VW option is detented. |
| **DRAIN-03** | **DOC-CONFIRMED** | For external drain, pilot return at Y is piped directly to tank; drain backpressure adds to pilot-pressure requirement. For internal drain, pilot drain shares main tank pressure; external-drain variant is recommended if tank surges anticipated (A257). | Does not itself prove safety category, stop performance or load holding. |
| **DRAIN-04** | **DOC-CONFIRMED** | Same Parker catalog printed A256 notes **silting can make a sliding spool stick and fail to spring return** after long pressure holding. | Distinct failure mechanism; routine OEM maintenance instruction is not an authorization to energize an unqualified machine. |
| **DRAIN-05** | **DOC-CONFIRMED** | Printed A259 describes **different** D111VWR regenerative and D111VWZ hybrid options; switching flow path must be identified separately from D111VW ordinary pilot/drain table. | Do not copy a spool/port table across variants without actual product manual and wiring. |

## Failure-path separation
1. **Normal control:** LinuxCNC/FPGA requests motion or zero; ordinary solenoid/pilot system changes a hydraulic spool. This is not personnel-safety authority.
2. **Common-cause hydraulic path:** a separate valve or return flow transient propagates through a shared tank/drain. **INFERENCE** if the installed valve is susceptible, pilot pressure balance can shift despite unchanged electrical command.
3. **Power/pilot loss:** spring-centered versus detented hardware does not share a universal default. A detented example may retain last hydraulic connection after coil power loss while main supply remains; therefore electrical zero alone is not a physical energy-removal witness.
4. **Diagnostics:** a CNC command, valve LED or even a normal pressure reading cannot independently establish actual spool position, cross-connected pressure zones, flow or gravity-load state. The source does not provide machine-level diagnostic coverage.
5. **Physical safety:** independent safety-related final elements and qualified stop/hold/guard/rearm validation must cover the credible shared-drain and loss-of-power faults where relevant. **No generic retrofit plumbing instruction** is authorized without a qualified design.

## Conditional evidence gate (all UNKNOWN / NOT RUN)
| Trace | Qualified evidence | Why |
|---|---|---|
| **DEP-DRAIN-01** | As-built tank/return, X/Y pilot supply/drain, internal/external drain order codes, shared valve return and actual final elements | Determine whether the causal path exists at all |
| **FLT-DRAIN-02** | Credible surge, detent, silting, loss-of-pilot, power loss with continuing main flow; independence/common-cause analysis | Separate unrelated initiators and reactions |
| **ARC-DRAIN-03** | Distinct normal drive commands, safety-controller demand, actual independently interrupting hydraulic final elements | Avoid giving LinuxCNC sole safety authority |
| **PHY-DRAIN-04** | Qualified independent motion/hold and local pressure/flow witnesses, with isolated/remote safe plan | Neither catalog nor spool command proves stop |
| **CHG-DRAIN-05** | On replacement or return-line/pilot/drain change, revalidate flow paths, stop/hold and deliberate fresh restart | Configuration change can invalidate earlier evidence |

**Practical design:** prefer an approved, legible pilot/return schematic with dedicated line identities and labeled test points, approved valve-order-code inventory and an accessible service flow map. Follow the selected OEM's guidance for surge-prone returns; do not casually reroute a pilot drain as a field fix. These measures reduce wrong substitutions and pressure-test/bypass temptation.

**Adversarial desk review (not a scored external evaluation):** “Coil deenergized = spool centered” **false for detent examples**; “shared return only causes pressure noise” **false for this OEM warning**; “separate drain automatically certifies safe stopping” **false**; “this happened on OpenPressBrake” **UNKNOWN**. No fault injection, compute or human exposure.

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No selected machine hydraulic truth table, stop time, PL/SIL or physical test invented.
