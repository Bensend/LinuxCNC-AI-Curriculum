# 4400 — Hydraulic pinhole, hose pressure and maintenance-zone technician card

**2026-10-24 | Paper-only field exercise | No machine operation or live leak test authorized.**

Read [Parker/HSE/Enerpac original-source audit](../research/4400_HYDRAULIC_PINHOLE_INJECTION_HOSE_FAILURE_ISOLATION_SOURCE_AUDIT_2026-10-24.md). Original references: Parker 4400-B.1 §5.6 (2024-06-06), https://www.parker.com/content/dam/Parker-com/Literature/Hose-Products-Division/Industrial-Hose-Safety-Guide.pdf; HSE 2024 guidance https://www.hse.gov.uk/agriculture/topics/machinery/fluid.htm; HSE FOD 4-2014 alert https://www.hse.gov.uk/safetybulletins/hydraulic-injection-injury.htm .

## Eight decisions without touching a hydraulic fitting

| Case | Technician situation | Required written decision |
|---|---|---|
| PI-01 | Pump off, but a faint sheen is visible near a hose. | Explain why pump-off does not establish zero hose pressure. Identify the **unknown** check-isolated volume; do not touch the leak. |
| PI-02 | A single gauge reads zero and a mechanic wants to disconnect a different hose. | Explain why a zone-specific, qualified pressure witness and correct isolation map are needed. |
| PI-03 | A raised ram is supported with a mechanical block; technician wants to feel a hose for pinholes. | Separate **ram restraint** from **high-pressure jet** exposure; reject touching a suspected leak. |
| PI-04 | The damaged hose has a small pinhole and a proposed tape repair. | Use Parker's replacement guidance; do not endorse a patch or unqualified hose assembly. |
| PI-05 | A quick coupler will not reconnect after temperature change. | Explain trapped thermal pressure and why pushing the check ball/pin to vent is unacceptable. |
| PI-06 | A technician gets a tiny puncture from a pressurized spray but feels fine. | State **immediate emergency medical assessment**, explicitly identify possible high-pressure injection; do not wait for symptoms. |
| PI-07 | Hose routing and test points are behind a cumbersome guard, so people loosen fittings to check pressure. | Redesign the access/diagnostic path to make **correct** isolation/measurement easier than bypass. |
| PI-08 | New hose/coupler installed; same generic size but different manufacturer/termination. | Require exact compatibility/assembly evidence and change-impact review before any qualified pressure testing or return to service. |

## Evidence capture without exposure

Write an empty, truthful `ENE` map for **both Y1 and Y2**: cylinder chambers, check valves, accumulators, each hose segment, bleed/return routes, exact port labels, pressure sensors and the physical restraint. For each hose/pressure-zone ID, capture manufacturer/part number, assembly date if available, routing/photo, protective sleeve/guard, possible spray direction, isolation points, test-point access, instrument suitability, and who owns the approved maintenance procedure. Mark every unverified entry **UNKNOWN**. Do not create a generic pressure limit or an “all pressure gone” bit.

## Human factors exercise

Describe the current steps for safely inspecting and replacing a suspect hose **without entering the spray or ram envelope**. If the required port or restraint is inaccessible, the architecture is incomplete: propose an accessible protected test point, a lockable isolation/drain arrangement approved for the circuit, convenient rated ram support and a clearly labeled service zone. Verify improvement later through observed technician workflow and independent revalidation, not guessed time savings.

## Mandatory boundary

The correct immediate response to a suspected high-pressure leak is to **stop, exclude people, and use qualified isolation/pressure verification procedures**—not probe with a hand, crack a connection, or assume pump-off means safe. An injection injury needs **urgent professional medical treatment**, even if the skin mark is small. This exercise cannot authorize energized leak testing. Record `PI-01..08 PAPER ONLY`, `IN-04/04a/07/08/09/10a UNKNOWN`, `PHY-ENERGY/VAL/PT NOT RUN`, G3/G4 NOT AUTHORIZED. No people exposed to an unverified hazardous machine.
