# Press-Brake Brake-Monitor Deterioration Lockout and Worst-Case Setup Trace

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Question

What durable architecture lesson can be extracted from a real press brake/press brake-monitor implementation about deterioration of stopping performance, safeguard distance, lockout, and return-to-service authority without inventing OpenPressBrake stopping values?

## Evidence labels

- **DOC-CONFIRMED** — directly stated in cited manufacturer/product documentation.
- **SOURCE-CONFIRMED** — directly supported by a primary regulatory/source document.
- **INFERENCE** — engineering conclusion drawn from the confirmed evidence and explicitly not a quoted machine fact.
- **UNKNOWN** — OpenPressBrake-specific fact requiring design authority or physical measurement.

## Primary implementation evidence — PressCommander

Source: Press Room Electronics, *PressCommander* operation/installation documentation, current web-accessible PDF located 2026-09-20.

### DOC-CONFIRMED

The PressCommander documentation describes stop-time monitoring as a means to establish the safety distance for electronic guarding and to shut the press down when stopping performance deteriorates beyond the value allowed by that safety distance.

It documents two thresholds:

1. a **WARN** setpoint intended to provide notification before repair is required; and
2. a **FAIL** setpoint that automatically prevents a successive stroke when stopping time has deteriorated beyond the permitted value.

The documented FAIL state is not merely an HMI warning. The machine is prevented from making the next stroke, and the fault requires a keyswitch action to clear.

The manual also states that the stored WARN/FAIL setpoint pair must be established for the **worst-case situation**, explicitly naming the heaviest tool, fastest speed, and a 90-degree stop test.

The documentation further warns that a monitoring method that evaluates deterioration at the end of the machine cycle can require additional safety distance because stopping performance can deteriorate during the closing portion of a cycle before that later monitor point detects the adverse change.

### Architecture freeze

**BRAKE MONITOR HEALTHY != SAFEGUARD DISTANCE INHERENTLY VALID.**

The monitoring architecture, where in the cycle it observes stopping performance, and what deterioration can occur before detection are part of the safety-distance evidence.

**WARNING THRESHOLD REACHED != FAILURE THRESHOLD REACHED, BUT WARNING != ACCEPTANCE OF UNBOUNDED DEGRADATION.**

A warning is maintenance information. A fail threshold is a production-authority boundary in this implementation.

**FAIL LATCH CLEARED != STOPPING PERFORMANCE RESTORED.**

The keyswitch is a reset/clear mechanism. It is not physical evidence that the brake/hydraulic stopping path has recovered.

**WORST-CASE SETPOINT CONFIGURED != CURRENT PHYSICAL STOPPING PERFORMANCE PROVED.**

Configuration establishes an acceptance boundary; the actual machine must still remain within it.

## Independent regulatory context

OSHA's machine-guarding eTool for press-brake two-hand controls describes interruption/release of the safeguarding control causing the slide to stop and treats physical control placement relative to the hazard as part of safeguarding. This supports preserving the distinction between a control demand and the machine's physical ability to stop before access can reach the hazard.

This trace does **not** copy a mechanical-power-press formula or threshold into OpenPressBrake. The applicable OpenPressBrake safeguard-distance method remains design- and application-specific.

## Failure-path analysis

### Case A — stopping performance degrades but remains below warning

- monitor remains below WARN;
- this alone does not prove every other safeguard assumption;
- ordinary controller status remains subordinate to the safety function.

### Case B — warning threshold reached

- maintenance attention is demanded by the implementation;
- do not reinterpret the warning as permission to move a guard closer or relax another safeguard;
- trend/history can be useful diagnostic evidence but does not replace a physical acceptance test.

### Case C — fail threshold reached

- next stroke is inhibited by the documented implementation;
- ordinary LinuxCNC/FPGA/CNC demand must not override this safety disposition;
- production authority remains absent until the fault cause is corrected and the required stopping/safeguard evidence is re-established.

### Case D — operator clears FAIL without correcting deterioration

This is a deliberate commissioning challenge, not an approved operating method.

Expected safety lesson: **RESET/CLEAR != REPAIR != REVALIDATION != PRODUCTION RELEASE.** A curriculum lab or commissioning procedure should verify that the architecture does not turn fault acknowledgement into proof of restored physical performance.

### Case E — tooling/speed configuration changes

Because the source explicitly uses worst-case tooling/speed conditions when setting the monitor, a change capable of invalidating that worst case must trigger impact analysis. Do not assume the previous monitor/safeguard evidence remains valid solely because the monitor reports healthy.

## Four-class validation mapping

Using `SAFETY_VALIDATION_EVIDENCE_CLASS_AND_RETURN_TO_SERVICE_MATRIX_2026-09-20.md`:

- **A — normal-demand functional test:** challenge the applicable safeguard and observe the intended stop/inhibit path.
- **B — abnormal/fault challenge:** verify the monitor's warning/fail disposition or an approved equivalent test mechanism; do not create a hazardous degradation merely to test it.
- **C — quantitative physical performance:** measure actual stopping performance under the justified machine condition and compare against the approved acceptance basis.
- **D — periodic/proof lifecycle:** establish how deterioration is detected over time and what maintenance/retest event follows warning/failure.

A maintenance change need only repeat the evidence classes it can invalidate, but a reset bit, configuration checksum, or monitor `OK` indication cannot substitute for Class C when the change can affect physical stopping performance.

## OpenPressBrake applicability

### INFERENCE

A future OpenPressBrake architecture should represent at least these concepts separately if its safeguarding depends on stopping performance:

- safety demand;
- physical stop-performance acceptance;
- monitor warning/maintenance state, if implemented;
- monitor failure/production-inhibit state, if implemented;
- safeguard geometry/distance acceptance;
- fault acknowledgement/reset;
- revalidation complete;
- fresh ordinary production start.

LinuxCNC, HAL, the FPGA, or the normal HMI may display these states, but personnel-safety authority must remain in the qualified safety architecture.

### UNKNOWN — do not invent

The following remain unknown until the OpenPressBrake machine/design supplies evidence:

- whether a continuous brake/stop monitor is required;
- applicable stopping-time or stopping-distance limits;
- monitor sensing method and measurement point;
- worst-case ram speed, load/tooling condition, oil temperature, valve state, or other physical test condition;
- safeguard distance or field geometry;
- warning/fail thresholds;
- periodic test interval;
- PL/SIL/category/DC/CCF claims;
- hydraulic stop truth table;
- exact production-release procedure.

## Commissioning / return-to-service worksheet

For a machine whose safeguard placement depends on stopping performance:

1. identify the physical hazard and the safeguard whose validity depends on stopping performance;
2. identify the approved stopping-performance acceptance basis;
3. identify the worst-case machine/setup conditions relevant to that basis;
4. challenge the safeguard and verify the actual safety demand reaches the intended final elements;
5. quantitatively measure physical stopping performance when required;
6. verify installed safeguard distance/geometry remains valid for the accepted result;
7. deliberately verify warning/failure disposition using an approved test method rather than unsafe degradation;
8. after maintenance affecting the stop path, repeat the evidence invalidated by that maintenance;
9. verify a fault-clear/reset action cannot be treated as the physical acceptance witness;
10. restore/requalify safeguards;
11. require a separate fresh ordinary START/CYCLE action for production.

## Durable curriculum lesson

A useful press-brake safety architecture has two different boundaries that must not be collapsed:

1. **deterioration detection / production inhibit**, and
2. **physical stopping-performance + safeguard-position acceptance**.

The first can stop a machine from continuing after unacceptable degradation is detected. It does not retroactively prove that the physical safeguard distance was valid, nor does clearing its latch prove the stopping system was repaired.

## Source-limit / next work

This source materially adds a real press-brake production-inhibit mechanism, warning/fail separation, explicit worst-case setup language, and the timing-location caveat missing from the generic stop-time lifecycle studies.

Next Lane-B target: find an OEM/manufacturer maintenance procedure that closes the remaining downstream sequence in one trace: **brake/hydraulic repair -> quantitative stop test -> failed result remains out of service OR passed result -> safeguard distance/position rechecked -> production release**. Prefer a press/press-brake source. If unavailable, rotate to another independent safety branch rather than repeatedly cataloging stop-time formulas.

## Sources

- Press Room Electronics, *PressCommander* operation/installation manual, web PDF: https://pressroomelectronics.com/wp-content/uploads/2021/03/PressCommanderDualStop_28-131r3-6.pdf
- OSHA, Machine Guarding eTool — Presses — Two-Hand Controls: https://www.osha.gov/etools/machine-guarding/presses/two-hand-controls
