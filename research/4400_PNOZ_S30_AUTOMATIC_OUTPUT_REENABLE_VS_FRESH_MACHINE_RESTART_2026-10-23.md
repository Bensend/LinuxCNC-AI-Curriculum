# 4400 — PNOZ s30 output reenable is not fresh machine restart

**2026-10-23 UTC | Original manufacturer-source trace; documentary, not a physical test or historical archive release.** Courses 2530, 2570, 2590, 25E0 and 4400. Follow [sensor/coupling coverage audit](4400_STOP_MOTION_SENSOR_COVERAGE_FAULT_AND_COUPLING_SOURCE_AUDIT_2026-10-23.md).

## Question

When a standstill monitor changes from a protective-output-open state to a permissive-output-closed state, has the *machine* been authorized to restart? What happens if a prior LinuxCNC start or motion demand is still present?

## Exact manufacturer evidence

**DOC-CONFIRMED — Pilz PNOZ s30, operating manual 1001715-EN-24**, https://www.pilz.com/download/open/PNOZ_s30_Operat_Man_1001715-EN-24.pdf :

- **§5.3.9, p. 24:** automatic start allows an assigned output to switch on automatically once the monitored speed condition is satisfied. Monitored start with rising edge requires the speed condition **and** a rising edge at S34. This describes the **monitor's output behavior**, not permission to initiate a machine cycle.
- **§7.7, p. 49:** the manual expressly warns that with automatic start the unit can start automatically when a safeguard is reset (its example is releasing E-stop) and instructs the integrator to use **external circuit measures to prevent unexpected restart**. This is direct manufacturer evidence against equating monitor-output reenable with fresh operator machine-start authority.
- **§5.4.4, pp. 35–36; §8.7.2–8.7.3, pp. 66–68:** the basic proximity and encoder configurations allocate outputs with **automatic start**. The default can differ from a separately configured monitored start. Copying a basic configuration is therefore a release/restart design decision, not merely a speed-threshold choice.
- **§8.7.4, p. 76:** start mode can be selected **per output** (automatic or monitored edge, with polarity choices). A technician must record actual selected output assignments and S34 wiring, not infer a single global reset behavior from the model name.
- **§8.5.4, p. 61:** the manual warns that transferring parameters to an **older device version** cannot guarantee identical safety-function behavior if parameters are unsupported. Version identity and revalidation are part of replacement acceptance; a matching filename or stored chip card is not a functional proof.

**DOC-CONFIRMED — Rockwell CU2-IN001, historical Issue 1**, https://literature.rockwellautomation.com/idc/groups/literature/documents/in/cu2-in001_-en-p.pdf : CU2 closes its safety outputs after sensed stopped motion plus selected delay; Y1/Y2 may monitor contactors at power-up. This is a **different device** with no universal S34-like start semantics in the reviewed sheet. Do not transfer Pilz start modes or fault codes to CU2.

## Authority and lifecycle trace (design requirement, INFERENCE)

| State/event | Standstill monitor proposition | Independent safety/rearm proposition | Ordinary LinuxCNC production demand |
|---|---|---|---|
| Hazardous motion commanded | Monitored speed exceeds selected safe criterion; output may open per configuration | Protective stopping/holding must actually be achieved | Command must be invalidated on protective stop |
| Motion stops / speed becomes low | Monitor may become permissive (possibly automatically) | Machine safe-state and guard access remain separate; output closure alone is not a fresh rearm | Prior start/move demand must remain cancelled |
| E-stop released / guard closed | Depending on selected start mode, monitor output may reclose | Independent deliberate safety reset/rearm must be defined with clear occupancy/escape/hold criteria | Still require **new** valid start action |
| Power restored | Monitor boots, restores configuration and evaluates its inputs | Hold pending selected restart, occupancy and power-loss checks | No replay of retained cycle start, pedal, G-code or motion |
| Sensor fault cleared / module replaced | Monitor fault and output may clear under product-specific rules | Revalidate changed device/config/diagnostics and physical final elements | Fresh demand only after independent rearm |
| Maintenance isolation removed | Monitor may see standstill | LOTO removal/energy reintroduction has its own authorized procedure | New production start remains separate |

**Adversarial case:** an operator's foot pedal or LinuxCNC start bit remains high when an E-stop is released. If the monitor's automatic-start output closes and the ordinary controller treats a held demand as a new command, unexpected motion can follow. **INFERENCE:** prevent this by architecture-level stale-demand cancellation and deliberate independent rearm plus a fresh ordinary demand; qualify selected devices and failure cases. Merely changing PNOZ to monitored-start mode is not proof of complete machine restart safety, because the downstream controller and energy path can still retain hazardous commands.

## Qualification worksheet

1. Identify exact PNOZ order number, firmware/device revision, manual, chip-card/CRC, selected parameter set, each output's function and start mode, S34 wiring and feedback loops. **UNKNOWN until as built.**
2. Trace output contact(s) to the **actual** independent safety controller/final elements and verify no normal FPGA/LINUXCNC route can bypass or unilaterally force them. **UNKNOWN.**
3. Freeze a mode-by-mode truth table for held/stuck pedal, E-stop release, guard close, fault clear, brownout, module replacement, maintenance return and two-operator controls. **Design required; not a tested truth table.**
4. Witness physical stopping/holding/access/escape and ensure safety reset does not itself initiate hazardous motion. **VAL/PT NOT RUN.**
5. Record operator ergonomics: obvious reset location, clear fault cause, no unnecessary multi-step nuisance trips, but no shortcut that bypasses the independent release path. **Site observations UNKNOWN.**

## Claim boundary

No LinuxCNC source behavior, machine wiring, selected PL/SIL, stop-time threshold, diagnostic coverage, or physical acceptance has been established. Product output logic and application-level machine restart are separate. **Selected-machine `IN-01..10 UNKNOWN`; `PHY` unknown; `VAL/PT NOT RUN`; `G0/G1 HOLD`, `G2 NOT RUN`, `G3/G4 NOT AUTHORIZED`, `G5 HOLD`.** External blind evaluation remains open. No hosted/local lab compute or personnel-exposed tests.
