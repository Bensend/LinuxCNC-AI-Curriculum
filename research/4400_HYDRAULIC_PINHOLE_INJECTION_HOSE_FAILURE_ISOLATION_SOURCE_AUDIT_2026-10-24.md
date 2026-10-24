# 4400 — Hydraulic pinhole injection, trapped hose pressure and maintenance access source audit

**2026-10-24 UTC | Original cross-source safety research | Documentary only; no pressure tests.**

## The missing physical hazard

Earlier hydraulic lessons distinguish valve feedback, a zero gauge and ram holding. A separate **direct personnel-exposure hazard** exists even when the ram does not move: a barely visible high-pressure jet from a hose, test fitting or coupler can inject fluid through skin. **No CNC fault code, E-stop, pump-off indication or mechanical ram support establishes that an isolated hose section is depressurized.**

## Original authoritative sources and narrow scope

1. **Parker Hannifin**, *Parker Safety Guide for Selecting and Using Hose, Tubing, Fittings, Connectors, Conductors, Valves and Related Accessories*, **publication 4400-B.1**, in manufacturer-hosted *Safety & Technical Information*, updated **2024-06-06**, https://www.parker.com/content/dam/Parker-com/Literature/Hose-Products-Division/Industrial-Hose-Safety-Guide.pdf . PDF p. 5, **§5.6 Hose Inspection and Failure** (printed p. 146). **DOC-CONFIRMED:** tiny pinholes can produce hard-to-see jets; never search by touch; pump-off may leave a hose pressurized because of check valves; failed hoses must be replaced rather than patched. §1.2 warns hose/fittings can fail without warning. This is manufacturer **general** guidance, not proof of installed OpenPressBrake pressure.
2. **UK Health and Safety Executive (HSE)**, *High pressure fluid injection hazards*, last page date **2024-10-24**, https://www.hse.gov.uk/agriculture/topics/machinery/fluid.htm . **DOC-CONFIRMED:** injection can cause major injury; dangerous shortcuts include hand leak searches, improvised couplings, damaged hoses and pressure not released for maintenance. HSE recommends accessible shut-off/drain features, easy-to-use mechanical supports, suitable guarding and safe maintenance layout. Agricultural examples transfer as a **hazard mechanism**, not machine-specific press-brake valve architecture.
3. **HSE safety alert FOD 4-2014**, *Hydraulic injection injury*, issued **2014-09-23**, https://www.hse.gov.uk/safetybulletins/hydraulic-injection-injury.htm . **DOC-CONFIRMED:** fatal incident from a detached grease fitting with stored energy; injection wounds need **immediate professional medical assessment** even if initially small. Its report of possible injury at 7 bar is anecdotal and **not** a safe pressure threshold, design criterion or OpenPressBrake acceptance value.
4. **Enerpac**, *Safety Handbook for Hydraulic Hoses*, manufacturer website, https://www.enerpac.com/en-US/resources/education/safety-handbook-for-hydraulic-hoses . **DOC-CONFIRMED:** hose pressure may rise due to heat; do not depressurize couplers by pushing check balls/pins; discard damaged hoses. Product-specific hose bend-radius or safety-factor examples **must not** be transferred to a different hose family.
5. **OSHA 29 CFR 1910.147**, https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 , provides the U.S. maintenance hazardous-energy control framework; selected legal applicability and machine-specific procedures require separate review.

## Why a healthy press can still be hazardous to inspect

| ID | Observation | Hazardous hidden state | Evidentiary distinction |
|---|---|---|---|
| INJ-01 | Pump OFF / motor STO | Check valve or cylinder chamber retains pressure; pinhole jet remains possible | **DOC-CONFIRMED** Parker general mechanism; actual pressure UNKNOWN |
| INJ-02 | One gauge reads zero | Other check-isolated hose, accumulator or port remains charged | **INFERENCE** from zone topology; selected ports UNKNOWN |
| INJ-03 | Ram mechanically blocked | A hose/fitting remains pressurized and can inject fluid | **INFERENCE**: mechanical load restraint does not depressurize |
| INJ-04 | Valve position switch green | Fluid leakage/pinhole can occur downstream of valve position target | **INFERENCE** from Parker + prior Bosch valve-feedback evidence |
| INJ-05 | A thin spray looks like mist or dirt | Invisible/high-velocity jet penetrates skin; searching with fingers creates exposure | **DOC-CONFIRMED** Parker/HSE |
| INJ-06 | Failed hose patched or reused | Unqualified hose/termination may fail without warning | **DOC-CONFIRMED** Parker prohibition on failed-hose patching |
| INJ-07 | Coupler won't connect after heating | Trapped fluid expands; pushing check ball to vent creates direct injection exposure | **DOC-CONFIRMED** Enerpac warning; actual pressure UNKNOWN |
| INJ-08 | Minor-looking puncture after spray | Deep tissue injury despite small entry wound | **DOC-CONFIRMED** HSE: emergency medical care, not “wait and see” |

## Make the safe path easier than the shortcut

**INFERENCE / design recommendation, not a validated installation:** group and label **zone-specific** OEM-approved test/bleed points outside ram and hose-spray danger envelopes; provide fixed splash/shielding where appropriate; make isolation valves lockable and drains accessible with suitable capture; retain mechanically rated supports at point of use; route vulnerable hoses away from occupied/service areas and protect them from abrasion; record complete hose/fitting compatibility and replacement identity. Avoid a procedure that requires reaching across a pressurized line to read a gauge, loosening a fitting to “see whether it has pressure,” or removing guards merely to find a hidden test port. Keep guards simple to reinstall. Treat shields/PPE as supplementary, **not** substitutes for isolation and zone verification.

**Never prescribe a generic “crack the fitting” or “probe the leak” test.** Qualified maintenance must use the actual machine's manufacturer-approved isolation, residual-pressure verification and load-restraint procedures. Where safe-to-operate basics are not established, no people exposed; any experimental machine operation isolated/remote with residual risk explicitly documented.

## Evidence chain and intake changes

- `BND/HAZ`: add high-pressure jet, flying fitting and hose whip during production and maintenance, distinct from ram crush.
- `ENE`: map **each trapped hose segment** and accumulator, check valve, thermal expansion and bleed path; a global “hydraulic off” label is insufficient.
- `SF/SRS/AUTH`: normal LinuxCNC/FPGA E-stop, valve command or pump status are **not** physical pressure isolation or lockout.
- `PHY-ENERGY`: qualified zone-specific pressure verification and mechanical restraint; do not rely on a single remote gauge.
- `HF`: identify why maintainers might use fingers, loosen fittings or bypass guards; redesign for access without exposure.
- `CHG/VAL/PT`: after hose/fitting/valve replacement, revalidate compatibility, pressure boundary and affected safety functions using an independently approved plan.
- `IN-04/04a/07/08/09/10a`: capture complete hose identity, routing, damage, spray exposure, all isolated pressure volumes, qualified test points, replacement records and emergency response.

## Adversarial reviewer questions

1. Can the hose remain pressurized after pump-off? Which **actual** check/accumulator/cylinder port proves or refutes it?
2. Is a zero gauge physically connected to the suspected hose **at that moment**? Which valve can isolate it?
3. What makes a technician tempted to use a finger or loosen a fitting, and how does the redesign remove that incentive?
4. Which replacement hose assembly and coupling have exact compatibility evidence? What change makes prior proof stale?
5. If a worker reports a pinprick after spray, why is **immediate emergency medical evaluation** required?
6. Does a correctly rated mechanical support eliminate hose-injection exposure? **No**; separate energy proposition.
7. Does HSE's anecdotal 7-bar figure establish any safe-to-touch pressure? **No.** No numeric safe threshold inferred.

## Evidence status / boundary

**DOC-CONFIRMED:** the above manufacturer and HSE statements within their actual product/task scope. **INFERENCE:** transfer of general physical hazards and design recommendations to OpenPressBrake. **UNKNOWN:** actual Y1/Y2 hose types, pressure zones, safe bleed methods, spray exposure, guard routing, as-built drawings and qualified isolation. **TEST-CONFIRMED:** none. No live leak checks, hydraulic tests, simulations, hosted/self-hosted compute, injury experiments or selected safety acceptance. `IN/PHY UNKNOWN`, `VAL/PT NOT RUN`, G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Historical archive backlog unchanged; do not misrepresent this new research as an exact archived release.
