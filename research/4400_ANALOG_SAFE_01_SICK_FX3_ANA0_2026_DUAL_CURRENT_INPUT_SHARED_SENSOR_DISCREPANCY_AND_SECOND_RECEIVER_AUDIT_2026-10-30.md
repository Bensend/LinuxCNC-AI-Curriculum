# 4400-ANALOG-SAFE-01 — Two analog safety inputs do not automatically mean two independent measurements
**2026-10-30 | NON-GRADUATED | original OEM documentary audit | no selected machine, no physical validation**

## Engineering question and novelty
Can a builder safely infer redundant pressure/force protection merely because a safety controller accepts two 4–20 mA channels and shows plausible readings? **No.** The number of input terminals is not the number of independent process measurements; a common sensor, common pressure tapping, correlated process failure, or another series-connected receiver can defeat that inference. This is an **INFERENCE from the OEM's explicit wiring and fault warnings**, not a finding about an installed OpenPressBrake circuit.

Before researching, directly searched the full canonical `safety-course/SAFETY_COURSE_INDEX.md`, `SAFETY_COURSE_RESEARCH.md`, `PROGRESS.md` and `CURRICULUM.md` for `FX3-ANA0`, `analog discrepancy`, `4-20 mA`, `sensor AI1`, and `memorized fault current`: zero matches. Existing 2520 SRS, 2550 integrity/CCF, 2580 hydraulic, MON-01 encoder and OUT-01 output-feedback lessons remain predecessors. **Classification: new exact OEM mechanism and analog sensor-dependency/receiver interaction; not a new scored competency.**

## Direct manufacturer evidence and edition
1. **DOC-CONFIRMED — original SICK hardware operating instructions**, `Flexi Soft Modular Safety Controller`, document **8012478/1WLY/2026-05-05**, original manufacturer-hosted PDF: https://www.sick.com/media/docs/0/60/660/operating_instructions_flexi_soft_modular_safety_controller_hardware_en_im0031660.pdf . Directly inspected text on printed pp. 39–41, 96–98, 111–112 and 129–133. The PDF currently served is **2026-05-05**, even though some search metadata describes an older edition.
2. **DOC-CONFIRMED within indexed manufacturer text; full PDF NOT independently opened due size limit** — SICK `Flexi Soft in Flexi Soft Designer`, document **8012480/T157/2025-07-30**, original SICK-hosted PDF: https://www.sick.com/media/docs/9/59/659/operating_instructions_flexi_soft_in_flexi_soft_designer_configuration_software_en_im0031659.pdf . Search-indexed excerpt of chapter 13 `Analog input module FX3-ANA0` supplies the stated delay/discrepancy/error-state figures below. Treat the edition as **2025-07-30**, not a claim that a 2026 software manual was read.
3. **DOC-CONFIRMED product-specific technical scope** — SICK FX3-ANA020012 original datasheet, **PDF footer 2026-05-07 02:54:25** (search metadata had an older date), https://www.sick.com/media/pdf/1/81/581/dataSheet_FX3-ANA020012_1112299_en.pdf ; analog inputs have specified 3.5–20.5 mA input measuring range and tolerance bands for fault detection. This is **not** a universal NAMUR NE43 implementation or machine threshold.

No LinuxCNC source or OpenPressBrake as-built analog-sensor wiring was used to claim this SICK module is installed. No certificate/selected firmware/safety project inspected.

## Findings, with exact evidence boundaries

| Proposition | Evidence | Safety interpretation |
|---|---|---|
| FX3-ANA0's AI1/AI2 form **one input pair for one process variable**, continuously compared | **DOC-CONFIRMED**, SICK hardware pp. 39–40, 96 | Two terminals are not evidence of two independent physical sensing chains. |
| A **single safe single-channel transmitter** can be wired **in series through both inputs**; the manual requires AI1− to AI2+ bridge | **DOC-CONFIRMED**, SICK hardware pp. 40, 96–97 | A single transmitter drifting in-range can present matching values to both channels. The comparison does not establish independent sensor redundancy; assess the transmitter's own safety properties and common causes. |
| Two distinct transmitters may be compared after **characteristic-curve standardization**; diverse sensors supported; systematic and CCF must be controlled | **DOC-CONFIRMED**, SICK hardware p. 40 | Correlation and common hydraulic process failure are not eliminated by separate current loops. |
| Manufacturer warns a **second controller in series** can affect the FX3-ANA0 signal because of the other receiver's **memorized fault current** | **DOC-CONFIRMED**, SICK hardware p. 98, section `Connecting the sensors to a second control` | Shared-loop receiver interactions are a real manufacturer-identified validation concern; no particular fault-current magnitude or direction inferred. |
| Measured analog values exported over gateway are **16-bit, non-synchronous, non-safe transmission** | **DOC-CONFIRMED**, SICK hardware p. 39 | LinuxCNC/HMI can use telemetry for monitoring, **not** as independent safety authority or a standstill/hold witness. |
| Configurable AI1 delay **0–252 ms** in 4-ms increments, discrepancy time **0–65,532 ms** in 4-ms increments; manufacturer warns both can extend response or impair fault detection | **DOC-CONFIRMED from indexed 2025 SICK configuration-manual excerpt**, ch. 13, p. 442; full PDF not opened | Never set wide windows merely to silence nuisance faults; these are permitted settings, **not** a recommended setting or measured machine stop time. |
| Indexed manual says out-of-range **<3.5 or >20.5 mA** or discrepancy error sets Signal range/Enable/Sensor status bits to zero; reset timing depends on configured discrepancy time | **DOC-CONFIRMED from indexed excerpt**, same | Fault bit behavior is module logic, not proof the hydraulic ram physically stops or remains held. Distinguish discrepancy-error reset timing from **deliberate machine restart/rearm**. |
| Analog-input E5 response-time table: **sensor response + 20 ms processing + 4 ms measurement cycle + (averaging cycles−1)×4 ms + AI1 delay** | **DOC-CONFIRMED**, original 2026 hardware manual, Table 105 p. 133 | This is only the **analog input path**, not total safety reaction time, and does not include independent final-element or physical motion response. |

### Why “both sensors agree” can be a dangerous false comfort
- **One sensor split into two inputs:** the two measurements are correlated by construction. A stuck but in-range transmitter could produce agreement without true pressure tracking (**INFERENCE**; not an OEM test of this exact failure).
- **Two transmitters on one blocked/tapped pressure line:** they may agree on trapped local pressure while the load path is elsewhere (**INFERENCE** requiring as-built hydraulic analysis; no actual circuit asserted).
- **Two distinct sensors, one common supply/reference/cable route:** a common-mode error can evade simple difference checking (**INFERENCE**; manufacturer explicitly requires CCF assessment).
- **Series receiver:** a second instrument's input/fault-current behavior may influence the first safety module (**DOC-CONFIRMED warning**, actual electrical behavior unknown).
- **Large discrepancy window or AI1 delay:** a transient real divergence can remain tolerated longer (**DOC-CONFIRMED parameter effect**, no calculated installed response).
- **Gateway “healthy pressure” visualization:** safe-module output and non-safe HMI numeric transport have different integrity contracts (**DOC-CONFIRMED**).

### Layered safety boundary
```text
process pressure / ram load / valve state
      -> selected pressure tap(s), transmitter(s), supply, cables
      -> independent qualified safety analog input + configured discrepancy/range logic
      -> independent safety decision, fault latch and deliberate rearm
      -> independent final elements: stop, support/hold, energy isolation
      -> qualified physical validation of the actual hazard
            |
            +-- non-safe gateway / LinuxCNC / FPGA / HMI: diagnostics only
```
Pressure feedback is **not** proof of ram position, stopped movement, mechanical support, hydraulic isolation, or absence of trapped energy. For OpenPressBrake Y1/Y2, the actual topology, safety program, sensor identity, pressures, thresholds, PL/SIL, reaction time and physical stopping/holding are **UNKNOWN**. Do not substitute an ordinary ADC or FPGA algorithm for independent safety logic.

## Failure-path / adversarial review
| Fault or shortcut | What a naive designer may assume | Required review / documentary discriminator |
|---|---|---|
| Single sensor feeds both inputs | “Two green channels = redundant sensing” | Draw actual sensing element count and independent fault paths; inspect transmitter safety manual. |
| Sensors share pressure tapping | “Agreement proves both cylinders safe” | Trace physical ports, isolation valves, blocked taps, separate Y1/Y2 load paths and all operating modes. |
| AI1 delayed to match lagging sensor | “No discrepancy means instant protection” | Export exact configuration, filter/delay, worst-case response-time calculation and final-element timing. |
| Discrepancy tolerance widened after nuisance trips | “Fewer trips means better safety” | Record cause of nuisance event; fix sensor installation or pressure dynamics, do not suppress diagnostics casually. |
| Second PLC/DCS wired into same current loop | “Monitoring cannot affect safety input” | Compare both receiver OEM input circuits and failure behavior; use OEM-qualified isolation/architecture. |
| Loop faults or out-of-range | “Fault LED means machine stopped” | Confirm safety logic consumes fault state, final elements actuate, actual load is held, and reset is deliberate. |
| HMI gateway value matches setpoint | “Pressure is safe because displayed value is normal” | Confirm non-safe gateway path cannot authorize motion, guard unlock or release. |
| Service technician bridges an input to eliminate faults | “Temporary fix for commissioning” | Block hazardous personnel exposure; diagnose from unpowered/isolated records and restore approved sensor arrangement. |

## Practical, low-defeat design lessons
Choose a validated, manufacturer-supported input/sensor topology with labeled sensor identities and accessible, protected test points **outside the hazard zone**. Keep a one-page wiring/port map and a legible fault message that distinguishes sensor disagreement, out-of-range, common-supply loss and actual machine stop/hold status. Make it easier to replace the failed transmitter or connector correctly than to short, bridge or disable a channel. A service bypass that permits exposed hazardous motion is not a maintenance mode; prevent operation until the approved protection is restored and independently checked. A safe-to-operate threshold requires real independent safety decisions and physical safe-state proof, not only analog readings.

## Qualified verification plan — NOT RUN
**Desk gates:** exact sensor/model/firmware and safety manual; 1-vs-2 sensing-element drawing; process taps and common-cause map; approved FX3-ANA0 wiring and second receiver; safety project/version and thresholds; AI1 delay/averaging/discrepancy; worst-case input-to-final-element response calculation; error-state and deliberate rearm; documented electrical/hydraulic/mechanical final elements; qualification/maintenance change controls.

**Only if an independent qualified reviewer later authorizes a bounded isolated/remote validation:** with people outside the danger zone, verify specified single-channel and common-cause fault responses, second-receiver interactions, failure-to-safe-state, deliberate reset, physical stop/hold and stored-energy isolation against the *selected machine's* SRS. No machine movement, pressure manipulation or fault injection is authorized by this paper.

## Evidence classification and status
- **DOC-CONFIRMED:** original SICK 2026 hardware manual and 2025 indexed configuration excerpts, as individually labeled.
- **SOURCE-CONFIRMED:** none about LinuxCNC code or installed machine in this audit.
- **TEST-CONFIRMED:** none.
- **COMMUNITY-REPORTED:** none relied on.
- **INFERENCE:** correlated sensing, shared tapping, nuisance-bypass and machine transfer failure paths.
- **UNKNOWN:** selected machine hardware/firmware, measured pressure/stop/hold, actual safety program, achieved PL/SIL, qualified evaluator and any runtime.
- **Compute:** 0 GitHub-hosted, 0 self-hosted; no workflow, build, simulation, physical test or machine operation. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.**


## Same-session source-depth: process-area selection and discrepancy recovery are distinct transitions
**DOC-CONFIRMED from the directly inspected 2026 hardware manual (printed p. 39):** FX3-ANA0 supports up to **15 configured process areas** (each with upper/lower limits), and the monitored process area **can be selected during ongoing operation**. When a configured process limit is violated, the module sets its release bit to zero. **UNKNOWN:** who selects the active area in any particular machine and whether that selection is safety-authorized. **INFERENCE / design-review requirement:** a safety requirement must define permitted mode/area transitions and what happens when a normal-control recipe requests a less restrictive area. Do not allow a recipe, LinuxCNC HAL bit, or HMI screen to become personnel-safety authority merely because a safety controller supports changing an area.

**DOC-CONFIRMED from manufacturer-indexed 2025 configuration-manual chapter 13 (full PDF not opened):** discrepancy error **recovery time** is not simply the same as discrepancy detection allowance. The indexed Table 212 says discrepancy time **0 ms → reset time 65,532 ms**; discrepancy time **4–200 ms → reset time 1,000 ms**; **204–13,104 ms → five times the discrepancy time**; **13,108–65,532 ms → reset time 65,532 ms**. This is the manufacturer's **module discrepancy-error reset timing**, not permission to restart hazardous motion and not a recommended safety setting. **INFERENCE:** maintenance personnel might misinterpret a long diagnostic recovery as a defective sensor and bridge it; provide a clear fault/recovery display and preserve deliberate restart authority. Never tune the discrepancy interval merely to speed up fault clearing without SRS analysis.

**Open qualified questions:** identify the selected safety program's process-area selector source, whether mode changes are permitted with hazards active, how range faults are latched/acknowledged, and whether a fault reset can rearm a physical final element without an independent fresh start. No selected OpenPressBrake controller, process-area wiring or machine operation is established.


## Critical PDF edition/provenance reconciliation — mixed visible page footers
A later **visual inspection** of the manufacturer's PDF at the same URL exposed a **source-version discrepancy that the text extraction had hidden**: the cover/text extraction and printed p. 97 screenshot show footer **8012478/1WLY/2026-05-05**, whereas screenshots of printed **pp. 98–99** show **8012478/1YG3/2026-10-01**. The second-controller memorized-fault-current warning is on printed p. 98. Both screenshots visibly contain the same relevant section and the 2026-10-01 p. 98 warning; however **the exact edition of the full 196-page resource cannot be asserted as uniformly 2026-05-05** from this mixed evidence. This may reflect PDF version/cache inconsistency, but the cause is **UNKNOWN**. Preserve both witnessed footer IDs, URLs, page numbers and retrieval date; do not silently normalize them or assume edition-to-edition equivalence. The *warning's existence* is visually **DOC-CONFIRMED** in the observed 2026-10-01-footer page; the single-sensor bridge figure is visually **DOC-CONFIRMED** in the 2026-05-05-footer page. An edition-stable, locally hash-pinned complete original would be needed to certify that all cited pages belong to one coherent revision. No machine safety inference changes.


## Same-session original datasheet verification: input burden is additive in series
The original SICK **FX3-ANA020012** six-page PDF was opened directly and shows **2026-05-07 02:54:25** in its printed footer (superseding older search metadata). Printed p. 3 lists **50 Ω input resistance** per analog input, **3.5–20.5 mA** measuring range and model-specific fault-detection tolerance bands. **Derived arithmetic only:** if one transmitter current flows through two 50-Ω inputs in series as in the OEM Figure 57, the nominal input burden is **100 Ω**, corresponding to **2.0 V at 20 mA** across those two inputs (not including wire, supply and any other receiver). An additional series-connected receiver adds its own burden and fault behavior. This does **not** prove an actual supply compliance failure or current distortion; verify the *selected transmitter* compliance-voltage specification, cable and receiver impedances, worst-case alarm-current ability and wiring. The product's advertised SIL/PL is **module-level**, not proof of an achieved machine safety function.
