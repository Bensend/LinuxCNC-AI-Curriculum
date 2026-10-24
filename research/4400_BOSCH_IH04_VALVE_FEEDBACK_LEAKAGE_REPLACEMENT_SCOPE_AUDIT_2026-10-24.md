# 4400 — Bosch Rexroth IH04 valve feedback, leakage, replacement and source-scope trap (2026-10-24)

**Status:** original public-source audit; paper-only engineering transfer. **No selected OpenPressBrake component identified, no physical tests, no acceptance or personnel-exposed operation.**

## Question and why this source was selected

Can a safety-valve position switch, a machine OFF command, or a newly installed same-type valve justify the conclusion that a gravity-loaded press slide is physically safe? And may a manufacturer's published leakage-velocity value be reused as a general press-brake criterion?

**Answer: no.** Two inspectable Bosch Rexroth manuals establish different, deliberately limited propositions. This audit treats their part numbers, applications and measurement conditions as part of each claim, not as interchangeable examples.

## Original manufacturer documents and provenance

1. **Bosch Rexroth RE 63124-B**, *Press modules for hydraulic presses, Type IH04*, general operating instructions, edition **08.2021**, 56 printed pages. Manufacturer-authored PDF retained by an independent distributor: https://www.kraemer24.shop/media/c6/6b/c7/1754488661/RE%2063124-B_2021-08.pdf . Relevant printed pp. 5, 8, 11, 24–25, 30–32, 35, 38–40. The manual explicitly covers **IH04C, IH04D, IH04E and IH04N**, but refers to type-specific documents for actual configuration.
2. **Bosch Rexroth RE 63129-MON**, *Press module for die cushion, Type IH04E*, assembly instructions, edition **09.2022**, 48 printed pages. Manufacturer-authored text reproduced by ManualsLib: https://www.manualslib.com/manual/2958602/Bosch-Rexroth-Ih04e.html . Relevant printed pp. 8, 23–29 and 39. **This is a lower die-cushion hydraulic module for presses, not evidence that an OpenPressBrake Y1/Y2 beam uses the same module or circuit.**
3. **ISO 6909:2026**, *Machine tools — Safety — Press brakes*, ISO publisher scope: https://www.iso.org/standard/83403.html . Public scope includes several press-brake drive families and excludes machines manufactured before publication; this does **not** establish uninspected normative clauses or a legal conclusion. The existing course note is `research/ISO_6909_PUBLIC_SCOPE_NOTE_2026-10-11.md`. The publicly indexed 2026 contents identify separate topics for stopping-response time, hydraulic examples, gravity fall, trapped-person release and isolation; their **requirements and acceptance methods are not assumed without the full text**.

**Source status:** the PDFs are original OEM-authored manuals but the retrieved copies are hosted by third-party archives; edition/title/page provenance was inspected. OEM direct-hosted copies were not recovered. No OEM product is claimed to be installed on the selected machine.

## Claims ledger

| ID | Claim and exact scope | Evidence | Class | Non-transfer boundary |
|---|---|---|---|---|
| IH-01 | General IH04 manual identifies the module as a system component; the machine builder must evaluate integration hazards independently. | RE 63124-B pp. 5, 8 | DOC-CONFIRMED | Module documentation != machine risk assessment or validation. |
| IH-02 | The general manual disallows using **analog actual-value signals from valve electronics** as the means of switching off safety-related machine functions. | RE 63124-B p. 30, electrical connections | DOC-CONFIRMED | Normal valve electronics/HAL telemetry cannot become the independent stop channel by convenience. |
| IH-03 | General manual describes a **5 mm/s leakage-speed condition** when opening the measuring port on the load-supporting side, in its installation context. | RE 63124-B p. 11 | DOC-CONFIRMED | **Not** a general acceptable drift, press-brake safe-speed, or stop-time limit. |
| IH-04 | General manual says some hydraulic lines remain pressurized in the **OFF** operating mode and calls for the relevant measurement points before disassembly. | RE 63124-B pp. 38–40 | DOC-CONFIRMED | OFF != all trapped volumes depressurized; one gauge is not all zones. |
| IH-05 | After replacement of a safety-relevant valve, the general manual calls for checking **reaction time of all safety-related valves**, and restricts replacement to the specified type because credited fault exclusions depend on component design. | RE 63124-B pp. 38–39 | DOC-CONFIRMED | Same connector/coil/footprint or one healthy switch != return-to-service. |
| IH-06 | The general manual requires a physically secure gravity-load state or mechanical restraint for service; during commissioning with guards unavailable, it requires restraint or fall-proof position. | RE 63124-B pp. 11, 25, 32, 41 | DOC-CONFIRMED | No mechanical restraint capacity is established for another machine. |
| IH-07 | The **IH04E die-cushion** manual calls for separate evaluation of valve limit switches during the press cycle, rejects further dangerous motion on mismatches and requires valve safe-position indications at standstill. | RE 63129-MON p. 27 | DOC-CONFIRMED | Switches observe valve-related state, not every fluid/mechanical failure. Its published DC figure is not a generic design target. |
| IH-08 | The IH04E manual explicitly lists **cylinder-seal leakage, valve leakage, relief-valve leakage, fittings and manifold cracking** as faults not necessarily detected by valve-limit-switch evaluation. | RE 63129-MON p. 28 | DOC-CONFIRMED | Healthy limit switches != no slide/die-cushion drift. |
| IH-09 | IH04E commissioning/testing includes **<1 mm/s** movement limits for its specified leakage checks; a different **5 mm/s** figure appears for certain fault cases. | RE 63129-MON pp. 23, 28–29, 39 | DOC-CONFIRMED | Different **component, failure condition, test method and motion direction** from IH-03. Never substitute either value into OpenPressBrake acceptance. |
| IH-10 | IH04E p. 39 specifies separate leakage checks with **valve .145** and **valve .140** opened and pump pressure absent, and says not to operate if its test limit is exceeded. | RE 63129-MON p. 39 | DOC-CONFIRMED | Descriptive source trace **only**. Do not execute on an unqualified machine or under human exposure. |
| IH-11 | ISO 6909:2026 is the newly published **press-brake** type-C source; its public abstract cannot prove a specific circuit/criterion. | ISO publisher abstract | DOC-CONFIRMED | Do not apply a general hydraulic-press or die-cushion OEM criterion to a press-brake beam. |
| IH-12 | A separate physical-motion witness and a safety-related stop/hold mechanism must remain distinct from normal LinuxCNC/FPGA telemetry and the valve's own feedback. | IH-02, IH-04, IH-07–10; course `PHY/AUTH/DEP` | INFERENCE | Must be designed/validated for the actual load, energy paths and final elements. |

### Deliberately adversarial source comparison

- **Numerical collision:** 5 mm/s in the **general** manual's load-side measuring-port condition is not the 5 mm/s **fault-case** reference in the **die-cushion** manual, and neither replaces its separate 1 mm/s commissioning/test statements. Same unit does not mean same hazard, circuit, or purpose.
- **Diagnostic blind spot:** IH04E's valve-switch discrepancy checking may identify an electrical/valve-position fault, but its own manual identifies physical leakage paths that the switches cannot detect. A plausible switch state and actual motion can disagree without contradiction.
- **Replacement trap:** same-type replacement preserves only a candidate configuration; source still demands reaction-time verification. A replacement can change contamination, sealing, adjustment, pilot paths, wiring and the actual response.
- **Lifecycle trap:** the OEM's OFF position, E-stop, control-electronics power and measured port are not interchangeable with full isolation, discharge, physical load restraint and deliberate restart.
- **Machine-class trap:** IH04E controls a die cushion; a press-brake Y1/Y2 beam has different load geometry and may use different safety architecture. ISO 6909 scope must be reviewed separately from EN ISO 16092 and from the selected installation's manufacture date.

## Machine-specific evidence intake — no powered experiment authorized

For **each actual Y1 and Y2 actuator** and each guard/restart path, request an as-built dated hydraulic schematic with port identifiers; installed valve/manifold nameplates, revision and fail-position documentation; pilot/accumulator/trapped-volume boundaries; load-bearing hose/pipe routing; mechanically independent support/restraint design; valve-switch electrical pin/logic identity; ordinary valve-electronics telemetry mapping; independent safety logic/final-element ownership; physical motion witness point and instrument calibration; safety-stop demand origin and timing; reset/rearm/start ownership; and a validated machine-specific acceptance document. Record `UNKNOWN` for absent evidence.

**Do not** infer a hydraulic truth table, diagnostic coverage, required PL/SIL, permissible leakage/creep, safe speed, pressure, stopping distance, or time from these manuals. `IN-01..10 / OPT / PHY UNKNOWN`; `VAL/PT NOT RUN`. No personnel-exposed operation until independent minimum safeguards are demonstrated. Any R&D motion without that proof requires isolation/remote operation with all persons outside the hazard zone, and residual hazards documented.

## Paper-only falsification cases (not machine tests)

1. Limit switches all show safe but beam drifts: IH-08 means feedback is insufficient; inspect load-side physical witness and leakage/holding path.
2. OFF selected and a gauge at one test port reads zero: IH-04 means unmeasured pressure zones remain possible; do not disconnect lines.
3. A valve was replaced with the same model: IH-05 still requires affected reaction-time and physical function revalidation before return to service.
4. A designer copies 1 mm/s or 5 mm/s into a Y1/Y2 acceptance sheet: reject as a scope transfer until the selected design and applicable standards establish it.
5. Normal analog valve position looks healthy during a stop request: IH-02 forbids using this normal electronics value as the safety shutdown mechanism in the documented product context; require independent safety function.

## Evidence state / next

`DOC-CONFIRMED` only for the OEM statements above; `INFERENCE` for transfer architecture; `UNKNOWN` for actual OpenPressBrake hydraulic/safety implementation; `TEST-CONFIRMED` **none**. Paper cases are not physical proof. The 2520–25F0 external/fresh evaluations remain open. No new lab question survives source reading, so **no GitHub-hosted or self-hosted compute is justified**. Next highest-value evidence is the selected machine's as-built valve/switch/port/ram-restraint and physical stop/holding path; otherwise inspect a distinct manufacturer safety architecture with exact product scope.
