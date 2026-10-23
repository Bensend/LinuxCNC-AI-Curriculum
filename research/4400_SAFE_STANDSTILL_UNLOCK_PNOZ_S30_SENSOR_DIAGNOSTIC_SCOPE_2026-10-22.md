# 4400 — Independent standstill-gated guard release: Pilz PNOZ s30 evidence and traps

Status: documentary research, not an installed machine design. Study date 2026-10-22. Source: Pilz **PNOZ s30 Operating Manual 1001715-EN-24**, official https://www.pilz.com/download/open/PNOZ_s30_Operat_Man_1001715-EN-24.pdf (inspected pages 16, 24, 100, 111–122, 123–126).

## Question

Is there an inspectable industrial architecture for allowing a guard to unlock after monitored standstill without trusting an ordinary LinuxCNC 'velocity = 0' bit? And what can still go wrong?

**DOC-CONFIRMED:** Pilz §13.4.1.1 gives an application example in which a PNOZ s30 evaluates two PNP proximity switches and, in that *example*, Rel. 1 permits safety-gate unlocking with a pushbutton when the configured standstill threshold is **≤ 2 Hz**. Rel. 2 handles a separate overspeed example; PNOZ s4 monitors the gate. This demonstrates a feasible independent monitoring *pattern*, not the performance or appropriateness of that threshold for another machine.

**Critical distinction:** a frequency below the configured 'standstill' threshold is **not logically identical to zero physical motion**. Frequency is sensor-pulse rate; translating it into residual shaft or axis movement requires actual sensor geometry, counts/rotation, transmission, coupling and response time. If a load can move by gravity with the monitored shaft stationary, even perfect shaft monitoring does not prove the load held. The actual machine's access proposition remains `UNKNOWN`.

## Documented monitoring and start behavior

- §5.3.1: the standstill output switches ON when measured value falls below the configured standstill value, and OFF if exceeded. **DOC-CONFIRMED**; no universal threshold inferred.
- §5.3.9: output start modes include automatic, monitored rising edge and monitored falling edge. **DOC-CONFIRMED**. The start mode is a configuration choice and must be recorded; it does not by itself authorize ordinary machine cycle start.
- §13.4.1: an example uses two PNP proximity switches, PNOZ s30, PNOZ s4, and feedback loops. **DOC-CONFIRMED** for the example only.
- §13.3.9 vs §13.3.10: the manufacturer separates two proximity switches with stronger diagnostics from **two proximity switches with reduced diagnostics**. The tables have different achievable subsystem characteristics. The reduced-diagnostics example lists PL d / Category 3 / SIL CL 2 for the stated sensor arrangement; stronger-diagnostic arrangements are separately tabulated. **DOC-CONFIRMED product/configuration evidence, not achieved machine PL/SIL.**
- §13.3.10.2 warns that proximity-switch supply voltage must be monitored against systematic failure; §13.3.10.3 calls out common-cause failures in the sensor subsystem. **DOC-CONFIRMED**. Two sensors sharing a sheared shaft, power supply or mounting can agree while the hazard moves.
- §11.3: the manual explains that mechanical relay contacts cannot be automatically checked while closed and gives product/claimed-integrity-specific periodic output-opening checks (its stated examples are at least monthly for SIL 3/PL e and yearly for SIL 2/PL d). **DOC-CONFIRMED manufacturer instruction for this product/context only**; do not transfer intervals to other hardware or assert this machine's required interval without the selected application and applicable instructions.
- §13.3 safety calculation notes that the **actuator subsystem is application-dependent** and must be included in the overall assessment. Sensor + monitor characteristics are not the whole safety function. **DOC-CONFIRMED**.

## Five physical contradictions the curriculum must preserve

1. **Standstill output true, beam drifting:** monitor sees no encoder pulses on a stopped pump motor, but the gravity-loaded beam descends via a hydraulic leakage path. A speed-monitor result cannot establish beam holding. Broad `PHY` fails.
2. **Two sensors agree, both wrong:** common power, broken coupling or incorrectly monitored mechanical member yields plausible low frequency while hazardous motion continues. Record `DEP` and a physical witness outside the shared failure path.
3. **Rel. 1 enables gate, run-on persists:** the threshold and total stop/access time were not validated for the machine. `VAL` remains NOT RUN; do not expose people.
4. **Guard closes, automatic-start mode selected:** monitor output may re-enable when its configured condition is satisfied. Separate safety reset and ordinary start must still be enforced by the machine architecture; retained cycle-start cannot become permission for hazardous restart.
5. **Maintenance technician treats 'standstill' as isolation:** an intact monitor output is not electrical lockout, hydraulic discharge or mechanical blocking. Maintenance energy control is a distinct `ENE/PHY/SRS/VAL` chain.

## Architecture comparison

| Layer | Proposed role | Not evidence for |
|---|---|---|
| LinuxCNC/FPGA normal motion | Requests stop/unlock, logs and presents state | Personnel-safe stop, physical standstill, safe unlock authority |
| Selected independent monitor | Evaluates documented speed/standstill sensor condition and supplies safety-related decision evidence | Gravity load restraint, all-axis standstill, trapped pressure, access geometry |
| Independent safety controller | Allocates qualified stop, gate-unlock permission, reset/rearm | Actual physical stop unless appropriate independent witnesses exist |
| Final elements / guard | Interrupt, hold, restrain and block access per validated SRS | Maintenance energy isolation unless specifically qualified |
| Physical witnesses | Measured/verified actual motion, load holding, guard/escape and residual energy | No generic machine acceptance without specific criteria |

**Practical design rule (INFERENCE):** prefer a proven dedicated safety speed/standstill monitor over repurposing an ordinary LinuxCNC encoder signal for personnel-safety release. But only after proving the sensor observes the *hazardous moving member*, and after evaluating the entire machine-specific sensor–logic–final-element–physical response chain. A dedicated product is not an automatic safety solution.

## Evidence / freeze

`MONITOR REPORTS STANDSTILL != ALL HAZARDOUS MOTION ENDED`.
`CONFIGURED LOW FREQUENCY != ZERO PHYSICAL DISPLACEMENT`.
`TWO SENSORS != INDEPENDENT PHYSICAL MEASUREMENT`.
`MONITOR PL/SIL TABLE != MACHINE SAFETY FUNCTION PL/SIL`.
`GUARD UNLOCK PERMITTED != MAINTENANCE ENERGY ISOLATION`.

No simulation justified: the open questions are selected sensor topology, motion coupling, independent stopping/holding and physical measurements. No Actions job or physical test performed.

**Visual source check:** Pilz PDF page 124 (zero-based page 123) was visually inspected: the manufacturer's example diagram shows the two PNP sensor inputs to PNOZ s30, a separate PNOZ s4 gate-monitoring unit, relays/feedback and pushbutton. The diagram does not establish any actual machine's stopping distance or holding force.

## Deeper source trace: diagnostics can be absent exactly near 'standstill'

**DOC-CONFIRMED, Pilz §§5.3.6, 8.7.5:** the two-encoder/broken-shearpin plausibility comparison is not always active. The manufacturer specifies minimum-speed and elapsed-tolerance prerequisites for the comparison, and a configurable **validation cut-off frequency** for proximity-switch encoder types. The manual states that below the configured cut-off the sensor plausibility check no longer runs (p.74). Thus **`TWO SENSORS PRESENT != TWO-SENSOR PLAUSIBILITY CURRENTLY ACTIVE`**. This is especially consequential when a learner wants to use a low-frequency standstill indication as proof of a stopped hazardous member. The safety analysis must trace the fault-detection gap and the sensor mechanical linkage, not assume redundancy from channel count.

**DOC-CONFIRMED, Pilz §5.4.1 and §5.4.3:** parameter-set selection is also safety-relevant. The manual distinguishes `None` and `1 from 4` selection modes (with documented upper product/application integrity scope) from `All 16` mode (manufacturer limits to max PL d/SIL CL 2 for the specified arrangement). In `All 16`, an open circuit on a select input can select a *lower-numbered* valid parameter set. The manual recommends ascending thresholds and locating `No 2 encoder diagnostics` in a higher-numbered set so a broken select conductor cannot inadvertently activate it. A selected machine must validate actual parameter values, input wiring, program/configuration identity and revalidation on replacement; **do not infer fail-safe parameter selection from a normal HMI mode name**.

**DOC-CONFIRMED, Pilz §§5.3.8, 13.3.1:** speed filtering increases reaction time, and the manual describes sensor-signal forced dynamization constraints for relevant encoder configurations. Product-specific examples of 8-hour signal-change expectations and corrections to PFH when extended are not generic inspection intervals; they highlight that static or seldom-moving equipment can hide latent sensor faults. The manual explicitly assigns the *reaction function* (drive shutdown, brake application, etc.) to the machine/plant developer, outside the PNOZ s30 monitoring function (§13.3.2). Hence a safety-monitor output is neither a complete stop architecture nor an independent physical witness.

**Additional adversarial gate:** with two proximity sensors showing no pulses, the monitor reports standstill; a broken mechanical link leaves both sensors stationary while the load moves. In the relevant low-frequency region, the documented plausibility logic may not be active. Do not claim this precise failure occurs on an installed machine without selected sensor/monitor configuration evidence, but carry it as a credible `DEP/VAL` fault path.

## Additional configuration trap — two defaults, not one universal standstill number

Pilz §5.4.4 lists **basic configuration 1 (two PNP proximity switches)** with a default standstill frequency of **2 Hz**, but **basic configuration 2 (encoder)** with a default standstill frequency of **100 Hz**. These are configuration defaults expressed as input-signal frequencies, not equivalent physical speeds. A technician copying the displayed 'standstill' word between sensor modes could change the meaning of the signal drastically. The correct workflow is to record the selected sensor type, signal scale, mechanical coupling, configured threshold, hysteresis/filter, parameter set and physical acceptance proposition before any access authorization.

**Visual source check (second page):** Pilz PDF page 122 (zero-based page 121) was visually inspected and shows the §13.3.10.3 reduced-diagnostics table (PL d/Cat.3, SIL CL 2) immediately above the §13.4.1 manufacturer gate-release example. This confirms the two statements but **does not** establish that the example achieves a machine-level PL d or that its 2 Hz threshold is safe for any other machine.
