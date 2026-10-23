# 4400 — Guard manual-release observability is not guard egress or machine safe state

**Status:** public-source research, 2026-10-22. No machine-specific safety validation, performance rating, or authorization for personnel-exposed operation. No lab was justified or run.

## Engineering question

If a guard-locking device has its escape release operated, what can a downstream controller actually infer from FO1A/FO1B, OL and OD, and what independent physical evidence is still missing?

### Product-specific, documented response

EUCHNER CTP-L.-AP instructions **2124217-08-06/21**, §§7.1–7.4 (printed pp. 10–12), distinguish auxiliary, emergency, inside escape and Bowden-cable releases. For the documented manual release conditions, the manufacturer states **FO1A/FO1B switch OFF**, **OL switches OFF**, and **OD may have an undefined state**. This is not the same as the ordinary switching-state table for closed/locked, closed/unlocked and open (§6.8, printed p. 9). The same manual requires an escape release to be manually usable **from inside without tools**, not reachable from outside, and warns that the actuator must not be under tensile stress during manual release (§7.3, printed p. 11). These are **DOC-CONFIRMED** statements for the specified product family and manual, not evidence of actual installation or guaranteed escape under a damaged or jammed guard.

The manufacturer also states that the correct operation of a Bowden release depends on cable routing and handle attachment; it specifies a **100 mm minimum bend radius for that documented release** (§7.4.1, printed p. 12). This number is **not** a universal guard-release design criterion and must not be transferred to another model.

CTP-L.-AP §3 (printed p. 6) states that the **external control of guard locking** must be treated as a safety function when locking is used for personnel protection. The switch's safety-output performance data do not assign that external unlock decision an achieved machine safety rating. §10.10 (printed p. 20) distinguishes OSSD output pulses from up-to-5-ms pulses tolerated at the separate solenoid-control interface. §10 (printed p. 15) lists FO output test pulses up to 0.35 ms for the documented family. Receiver configuration requires exact selected-product evidence.

CTP-I.-AP **2126290-08-07/24**, §§2–3 and 6.8 (printed pp. 5–8), is explicitly **process guard locking without safety-rated guard-lock monitoring**: its FO pair can remain ON while the guard is closed but unlocked. The CTP-L FO pair is OFF in that ordinary state. Neither the output name nor the spring-to-lock mechanical principle makes the two variants safety-equivalent.

Official manuals:
- https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Transponder-Coded-Safety-Switch-With-Guard%E2%80%A6_EN_08_06-21_2124217.pdf
- https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Operating-Instructions-Transponder-Coded-S%E2%80%A6_EN_08_07-24_2126290.pdf

### Inference boundary and counterexample

A release may electrically force FO OFF while OD is undefined, and the physical gate may still be jammed shut. Conversely, a release/door opening does not prove a spindle stopped, a gravity load is held, a ram is mechanically restrained, or an accumulator has been discharged. These are distinct `PHY-*` propositions and need independent, selected-machine witnesses. **INFERENCE:** a control scheme that uses OD alone as a guaranteed manual-release indicator could miss a release or misinterpret a transient; the manufacturer explicitly does not guarantee its state in this condition.

| Observation | Narrow proposition | Does NOT prove | Required next evidence |
|---|---|---|---|
| FO OFF during documented release | Switch's safety outputs withdrawn | Guard actually opened; physical hazardous motion stopped | Installed guard mechanical witness and independently justified hazard-safe-state evidence |
| OL OFF | Diagnostic lock-monitoring output inactive | A person escaped or guard is free of load | Accessible inside release and mechanical function/egress assessment |
| OD undefined during manual release | **No deterministic OD inference is allowed** | Guard closed or open | Physical door state, controlled restoration sequence and revalidation |
| LinuxCNC disabled | Ordinary control state | Independent safety authority, isolation or safe energy | Selected safety controller/final elements and physical witnesses |
| Hydraulic gauge zero at one tap | Pressure at that connected tap, under verified valve state | All trapped volumes, gas precharge, gravity restraint | Connectivity map and separate physical isolation/holding evidence |

## Practical, low-defeat architecture review

1. Provide a convenient ordinary safe-access request. The independent safety-related control decides whether the machine's relevant hazards have been controlled; normal LinuxCNC can request and display, but must not be the sole safety decision maker.
2. Provide an accessible **inside escape path** where whole-body entry is credible. Do not make egress depend on PC power, network connectivity, a password, an ordinary HMI or a single software state. Evaluate whether a gate under load, misalignment, debris, damaged linkage or power loss remains openable; product instructions prohibit assuming manual release under actuator tensile stress.
3. Keep service/maintenance isolation separate from production access. An escape release is not an energy-isolating device. OSHA 29 CFR 1910.147(d)(5)–(6) requires control of residual energy and verification for covered servicing; a 2012-12-12 OSHA interpretation rejects relying solely on an LED-style disconnect indicator for isolation verification. Scope and jurisdiction must be checked for the real task.
4. Following a manual release or replacement, do not treat restoration of FO/OL as automatic permission to restart. Check actual guard mechanics, egress, independent hazard state, reset/rearm conditions, and a **separate deliberate ordinary start**. The manufacturer's required functional checks after release/installation are not evidence that a particular installation has passed them.

OSHA sources:
- https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147
- https://www.osha.gov/laws-regs/standardinterpretations/2012-12-12

## Physical validation gate — deliberately UNKNOWN

For an actual machine: guard model/order/firmware, actuator and bracket geometry, inside escape reachability, force under door loading, physical egress, safety controller wiring/OSSD filtering, safety-related unlock authority, independent standstill and load restraint, hydraulic pressure zones, trapped energy, personal lockout procedures, and reset/restart behavior are **UNKNOWN** until inspected and tested with an approved, safely isolated procedure. Do not invent PL/SIL, stopping times, safe distances, pressure limits or a hydraulic truth table. If the minimum safe-to-operate threshold cannot be demonstrated, do not expose people to the hazard; use remote/isolated experiments with all personnel outside the danger zone and explicit residual-risk controls.
