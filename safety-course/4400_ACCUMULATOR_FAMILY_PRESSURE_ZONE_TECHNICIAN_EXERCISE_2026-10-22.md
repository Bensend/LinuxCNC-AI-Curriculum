# 4400 technician exercise — The green accumulator light and the wrong gauge

**Status:** development exercise with disclosed reasoning, **not** a blind evaluator challenge. Do not include this worked exercise in the sealed external challenge bank.

## Scenario (all machine facts hypothetical)

A hydraulic machine has a pump, an accumulator, an independently controlled safety valve, a hydraulic load and a pressure gauge. The HMI shows `SAFE VALVE = OK`, `PUMP OFF` and `PRESSURE = 0`. A maintenance worker wants to disconnect a load-side hose. The only gauge is behind a fixed guard and its tap location is missing from the service drawing. A colleague proposes temporarily energizing a valve to discharge the accumulator, then resuming hose removal without rechecking the isolation.

### Tasks

1. Identify the **minimum missing facts** before assigning any meaning to the HMI's zero pressure or the green safety status. Separate the gauge tap, accumulator fluid side, accumulator gas side, load-side chamber, gravity load and pilot circuit.
2. Contrast the selected-product requirements in HAWE D 7969 rev 1.10 p.31 with D 7571 rev 1.1 pp.11 and 18. Can the same accumulator relief-valve statement be copied between families? Why not?
3. Distinguish overpressure relief, protective stop, maintenance isolation, discharge and mechanical restraint. Which does `PUMP OFF` prove?
4. If a separate physical witness contradicts the valve feedback, write the `PHY/VAL/DEP/UNK` status and release decision. What becomes `STALE` if the gauge is moved to another port?
5. Propose two low-cost design changes that reduce the incentive to bypass a guard during pressure verification, without transferring personnel-safety authority to LinuxCNC or the normal FPGA.
6. Explain why the colleague's temporary energized diagnostic cannot justify immediate servicing without renewed energy control, and why the manufacturer's example of actuating a valve is not an authorization to expose personnel.

## Teaching review — not a hidden answer key

A competent response refuses to treat a single zero gauge, an HMI bit or a valve-position sensor as proof that every trapped volume is safe. It requires the exact component family and revision, fluid/gas separation, actual hydraulic connectivity, all relevant pressure/force zones, suitable physical witnesses, isolation/reaccumulation protection, and load restraint when needed. D 7969 and D 7571 contain different scoped safety-valve statements. Any contradictory physical evidence blocks the broader `PHY` proposition and personnel-exposed release. A moved gauge changes witness meaning and can invalidate `VAL`/`PT` evidence through `CHG`. Practical improvements include clearly labeled accessible approved test points and guard access that can be restored easily, with independent protective functions and qualified maintenance isolation. Temporary testing is a controlled exception that requires a fresh isolation/verification transition before exposed servicing resumes.

## Scoring dimensions for later external *novel* transfer only

Check proposition accuracy, manufacturer scope, energy-zone completeness, contradiction handling, authority separation, human factors and unknown preservation. This exercise itself is **not** scored as an external blind pass.

Sources: HAWE D 7969 (06-2022 rev 1.10) pp.31–32; D 7571 (03-2024 rev 1.1) pp.11–12, 18; B 5488 (10-2024 rev 3.1) pp.8, 17, 19; OSHA 29 CFR 1910.147(d)(5)–(6), (f)(1). Product facts DOC-CONFIRMED; machine scenario INFERENCE; physical verification UNKNOWN; no TEST-CONFIRMED evidence.
