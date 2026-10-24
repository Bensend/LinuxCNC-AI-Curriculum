# 4400 — Hose-burst velocity fuse: flow-window, leakage, installation and hazardous-test transfer audit

**Source investigation:** 2026-10-24 UTC. **Status:** original 4400 documentary research, not a physical test, installed-device qualification, safety-function approval or historical archive recovery. **Selected OpenPressBrake Y1/Y2 hardware: UNKNOWN.**

## Engineering question and why this source gap matters

Does a hydraulic “hose burst safety valve” establish that a gravity-loaded press ram will remain safely held after a hose failure, including a **partial leak, minimum-load condition, blocked line, wrong orientation or valve substitution**? **No generic answer is justified.** A flow-triggered fuse can respond to a specific excess-flow event, but its ability to do so depends on the installed hydraulic circuit and an actual separation between maximum normal flow and minimum fault flow. This is a different proposition from continuous load holding, protective stopping on E-stop, isolation for servicing, or proof that a hose cannot inject fluid into a person.

This investigation adds an **OEM-specific flow-threshold blind spot** to existing 2580 fluid-power teaching and 4400 hydraulic pressure-zone/injection work; it does not repeat the generic “pump off is not safe” lesson.

## Inspected original manufacturer sources and exact scope

1. **HYDAC Technology Corporation**, online RB Series Hose Break Valve, **part 710031**, model description **RBE-SAE9/16-18-X-15LPM STD. SET**. Product page sections “Specifications”, “Recommendations”, “Sizing Hose Break Valves”, “Additional Information”: https://catalog.hydac.com/en/item/cartridge-valves/valves--hose-break-check/710031 . Direct manufacturer page inspected 2026-10-24; page publication/revision date **not stated**, so do not invent one.
2. **HIDROS Group**, **VUBA Series Hose Burst Valves** product description: https://www.hidros.com.tr/product/vuba-series-hose-burst-valves/ . Direct manufacturer page inspected 2026-10-24; publication revision **not established**. Describes VUBA as a reaction-flow fuse and explicitly says the series is **not** a load-holding or unidirectional restrictor.
3. **Winner Hydraulics**, **HB-18A-20-Y-Z** hose-burst protection product page: https://www.winnerhydraulics.com/Hose-Burst-Protection-Insert-Type/Hose-Burst-Protection-valve-HB-20/code/HB-18A-20-Y-Z.html . Direct manufacturer page inspected 2026-10-24; no edition claimed. Factory flow-setting tolerance and flow margin are **Winner product guidance**, not a substitute for HYDAC/VUBA data.
4. **OSHA 29 CFR 1910.147**, https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 , especially energy-isolating devices, residual/reaccumulating energy and verification during covered servicing. Regulatory scope is servicing/maintenance, not a fuse design manual. No hose-burst component is presumed to satisfy lockout.

**Evidence labels:** statements explicitly on these pages are **DOC-CONFIRMED for those named products**. Derived failure hypotheses are **INFERENCE**. No LinuxCNC code was newly inspected; existing pinned v2.9.10 software E-stop/command traces remain **SOURCE-CONFIRMED only for ordinary software behavior**, not hydraulic safety. No experiment or physical witness: **TEST-CONFIRMED = none**.

## Narrow physical mechanism and nontransferable OEM settings

HYDAC describes a spring-held-open flat-seat poppet. Flow from **2 → 1** beyond the selected closing flow produces enough pressure differential to close; flow **1 → 2** is free and can reopen the valve. HYDAC specifies installation **between actuator and possible rupture point**, preferably at the cylinder port or close to it. A fuse downstream of an unprotected hose segment cannot be credited for that segment.

For the specific HYDAC family, normal flow fluctuations must not trigger repeated closures. HYDAC recommends an actuating flow **at least 20% above normal maximum flow**, and its sizing discussion recommends closing flow **at least 20% below emergency flow**. Those percentages are **manufacturer-specific selection guidance**, **not** a validated press-brake criterion or an OpenPressBrake design setting. HYDAC says actual system testing at **minimum cylinder load** is relevant to determining emergency flow; it also describes deliberately opening a line or valve. **That procedure is not an instruction for an unqualified learner to perform a live rupture experiment.** Before any physical experiment, a qualified team must establish a separate isolation/remote containment plan, exclusion zone, independent mechanical support, instruments, risk assessment and abort/energy control. No live test is authorized by this course.

The source lists approximately **0–6 in³/min** pressure-dependent leakage through the HYDAC arrangement and notes a thread-sealing concern. This is **not** proof of zero leakage or a specified safe holding duration. The manufacturer also warns that routine closure/cycling and excessive vibration can prematurely damage the fuse. No selected-machine leakage, actuation response, safe drift or stop-time acceptance is known.

HIDROS explicitly distinguishes its VUBA hose-burst fuse from a load-holding valve. This is **not a contradiction** of HYDAC's specific product statement: different product families and claimed functions must not be merged. Winner gives a different recommended flow margin and a factory setting tolerance. Treat these as evidence that **catalogue numbers and suffixes are product-dependent**, not as permission to average them into a generic setting.

## The core falsifiable flow-window condition (symbolic only)

Let `Q_N,max` be the **largest credible normal return flow** across relevant modes, temperature/viscosity and transients; `Q_B,min` the **smallest credible return flow from the fault class that the fuse is claimed to detect**, across load and circuit states; and `Q_T` the actual installed fuse trip threshold including tolerance/aging.

A necessary discrimination condition for the simple excess-flow concept is:

`Q_N,max < Q_T < Q_B,min`

This inequality is **INFERENCE from the OEM trigger mechanism**, not sufficient safety validation. If a **small rupture or slow leak** gives `Q_B <= Q_T`, closure is not established. If a **normal switching transient** gives `Q_N >= Q_T`, nuisance closure and premature damage become plausible. If viscosity/temperature, valve position, flow restrictions, low load or circuit bypass changes either bound, the margin may disappear. Actual `Q` values, trip tolerances, flow direction, load envelope and fault coverage are **UNKNOWN** for OpenPressBrake. Do not assign numerical values or declare the inequality satisfied.

**Important scope trap:** a manufacturer's example of a **full line rupture** does not prove protection against every partial leak, cylinder seal leak, downstream bypass, burst on the actuator side of the fuse, other chamber failure, structural load-path failure, or unintended powered motion. An electrical valve-status indicator and a normal LinuxCNC command are not witnesses of the fuse's physical seat, chamber pressure or beam movement.

## Adversarial fault-path table

| Case | Potentially misleading shortcut | Missing physical evidence / disposition |
|---|---|---|
| Small crack sprays oil; outflow remains below threshold | “Hose-break valve fitted, so hose is safe” | Injection hazard remains; no assured fuse trip; isolate each pressure zone for service. **HOLD**. |
| Lowest supported ram load produces lower fault flow | “It trips on our heaviest-load demo” | `Q_B,min` not established; **HOLD** for claimed rupture coverage. |
| Directional-valve switching momentarily exceeds threshold | “It is a safety trip, so repeat it every cycle” | OEM says fuse must not be a repeated switching element; correct design, not bypass/disable. |
| Fuse installed remote from cylinder | “Every hose is protected” | Map the cylinder-to-fuse exposed section and all alternate paths. |
| Correct poppet closes but leakage persists | “Zero motion forever” | Physical `PHY-HOLD` witness, leakage/thermal/gravity/other-chamber proof missing. |
| HYDAC model replaced with HIDROS/Winner lookalike | “Same name and port size = equivalent” | `CHG` requires exact family/suffix/flow/orientation and affected `DEP/VAL/PT` revalidation. |
| E-stop issued while hose intact | “Burst valve is the protective stop” | Excess-flow fuse need not actuate; independent stop/final-element architecture remains required. |
| Servicing after pump-off and indicated fuse closure | “Trapped pressure is safely isolated” | Closing fuse may retain hazardous pressure; personal isolation, bleed/verification and mechanical restraint separately required. |

## Authority, people and energy separation

`LinuxCNC / normal FPGA` → ordinary Y1/Y2 motion command and telemetry **only**. `Independent safety controller` → safety demand and qualified final elements. `Fuse (if actually fitted)` → *conditional passive flow-triggered closure* for its defined fault class. `Mechanical restraint + verified zone-specific isolation` → separate maintenance protection. `Independent beam/pressure/flow witnesses` → proof of the actual required physical propositions. Do not credit any one of these as all the others.

For a selected press brake, preserve distinct `PHY-STOP`, `PHY-HOLD`, `PHY-ENERGY`, `PHY-ACCESS`, `PHY-RESTART` and `PHY-HOSE-INJECTION`. If basic protection against exposed personnel cannot be demonstrated, **no personnel-exposed hazardous operation**. Research with an energized hazard would require a separately approved isolated/remote design with all people outside the danger zone and residual risks recorded; this note is **not** that approval.

## Evidence request and future proof plan (non-executable)

Before any test design: obtain as-built Y1/Y2 cylinder/chamber and hose map; exact fuse **part number/suffix**, orientation, physical location, protected segment, other chamber/check/relief/accumulator paths; OEM dated datasheet; normal flow envelope; credible fault-flow envelope including **minimum load** and partial leakage; operating fluid/temperature; approved load restraint; physical zone-specific pressure taps and safe observation points. Obtain independent safety stop/holding requirements and qualified physical witness plan. Record every unavailable datum as `UNKNOWN`, not zero or a default.

**Information-gain stop:** documentary mechanism and failure hypotheses are established. Without selected hardware and an approved safe test plan, neither trip margin nor load-holding effectiveness can be validated. No simulation is warranted merely to plot an invented `Q` window. Next source gap should be chosen elsewhere if hardware is unavailable.

## Anti-overclaim and provenance ledger

| Claim | Classification | Narrow source | What it does NOT establish |
|---|---|---|---|
| HYDAC RB fuse closes on excess 2→1 flow and reopens with 1→2 pressure | DOC-CONFIRMED | HYDAC 710031 product page, description/specifications/additional information | Any OpenPressBrake installation or response |
| HYDAC 20% flow margins and minimum-load fault flow test recommendation | DOC-CONFIRMED | HYDAC 710031 recommendations/sizing | Safe field test instructions or universal numeric thresholds |
| HYDAC leakage and no-routine-cycling warning | DOC-CONFIRMED | HYDAC 710031 additional information/recommendations | Leak-tight holding or certified drift |
| HIDROS VUBA not a load-holding device | DOC-CONFIRMED | HIDROS VUBA product page | Statement about all hose-burst devices |
| Winner setting tolerance and distinct selection guidance | DOC-CONFIRMED | Winner HB-18A-20 product page | HYDAC settings or installed-machine threshold |
| Small leak may never trip a velocity fuse | INFERENCE | Excess-flow trigger + missing lower fault-flow bound | Actual failure of any selected installed fuse |
| Selected Y1/Y2 protected against rupture/slow leak | UNKNOWN | No as-built or physical witness | No personnel-exposed release |


## 2026-10-24 SAME-SESSION CRITICAL CORRECTION — manufacturer port-direction conflict

**Do not generalize the HYDAC US catalogue's 2→1 closing direction.** Subsequent inspection of **HYDAC International EN 5.174.14/10.21** pp. 1–2 found the **same part number 710028 / RBE-R1/2-X-75** described as closing **1→2**, opposite to HYDAC's US official 710028 product listing (**2→1**). Original PDF cutaway labels protected consumer at port 1. The conflict is **DOC-CONFIRMED between two original manufacturer sources**, while actual installed part behavior is **UNKNOWN**. Read the [dedicated same-part contradiction audit](4400_HYDAC_RBE_710028_OPPOSITE_PORT_DIRECTION_OEM_CONFLICT_2026-10-24.md). The earlier `2→1` discussion is **only** the narrow US online catalogue claim for the identified listing, **not** an installation rule or physical truth. Manufacturer written clarification plus selected part/port evidence is a blocking gate; no line-open experiment.
