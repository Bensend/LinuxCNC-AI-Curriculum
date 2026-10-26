# ACC-SEQ-02 field module — When is pressure needed to stop, and when must it be removed?
**PUBLIC PAPER ONLY; 10 scenarios UNSCORED; 10 documentary gates NOT RUN; NON-GRADUATED.** [Source audit](../research/4400_ACC_SEQ_02_PARKER_HYDAC_RESERVE_ENERGY_VS_AUTOMATIC_BLEED_SAFE_STOP_SOURCE_AUDIT_2026-10-26.md). Do not assume installed OpenPressBrake accumulator, valve truth, load or stopping distance.

## Learner task
Distinguish four states: **ordinary motion request inhibited**, **hazardous motion physically stopped**, **gravity load independently retained**, and **all relevant hazardous energy isolated/verified for maintenance**. Some accumulator designs store energy to perform a safe completion cycle; others discharge during shutdown. Neither is universal. No pressure/valve/PL/SIL numbers may be invented.

## Ten adversarial paper cases — UNSCORED
1. Power fails halfway through Y1/Y2 descent. Identify the two competing accumulator roles; what as-built evidence selects the correct one?
2. E-stop is wired to instantly dump every accumulator. Explain why that may be correct in one architecture and unsafe in another.
3. E-stop leaves accumulator pressure available indefinitely. Identify the separate unexpected-motion and maintenance risks.
4. HYDAC SAF model M versus model E: what does the exact OEM product description establish, and what remains unproven?
5. A solenoid coil loses voltage, HMI reports bleed ON, pressure sensor is upstream of a closed valve. What physical witnesses are missing?
6. A stopped ram drifts with pump off. Which gravity/holding propositions fail even if a pressure indicator is green?
7. Technician opens a maintenance cover while another person restores power. What independent interlocks, LOTO and fresh-start gates must be evaluated?
8. An accumulator is replaced by a different model with nominally identical volume. Which stopping and service evidence becomes stale?
9. A second pressure source is discovered beyond a check valve. How does this change the zone map and proof plan?
10. A guard is repeatedly defeated because the bleed valve and gauge are inaccessible. Propose a maintainable redesign without lowering physical safety.

Each response must name: **hazard**, **energy path**, **normal controller role**, **independent safety role**, **physical final element and witness**, **unknowns**, **HOLD criterion**. Do not prescribe a circuit from the paper cases.

## Ten desk verification gates — NOT RUN
| ID | Documentary/qualified evidence to collect | Status |
|---|---|---|
| ACC-SEQ-V01 | Dated confirmation of accumulator presence or N/A | NOT RUN |
| V02 | Full as-built hydraulic circuit and all energy zones | NOT RUN |
| V03 | Actual stop/hold requirement per machine mode | NOT RUN |
| V04 | Pressure reserve required during stop? independent analysis | NOT RUN |
| V05 | Exact valve block part, bleed type and de-energized state | NOT RUN |
| V06 | Final-element and shared-pilot/return common-cause review | NOT RUN |
| V07 | Independent Y1/Y2 stop and load retention witness plan | NOT RUN |
| V08 | Trapped-pressure/maintenance LOTO and reaccumulation | NOT RUN |
| V09 | Deliberate restart after power/guard/pressure restore | NOT RUN |
| V10 | Qualified validation, change control and operator usability | NOT RUN |

No physical test, pressurization, discharge, machine motion or bench simulation authorized by this lesson. **G0/G1 HOLD.** No personnel-exposed hazardous operation until independently qualified physical safety case; isolated/remote experimentation only under a separately approved controlled plan.
