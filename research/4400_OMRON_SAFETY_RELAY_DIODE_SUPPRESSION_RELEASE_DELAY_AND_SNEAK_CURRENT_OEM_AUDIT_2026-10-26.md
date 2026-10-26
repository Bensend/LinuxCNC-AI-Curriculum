# 4400-SUPPRESS-01 — Coil protection can change stopping time
**2026-10-26 | Distinct OEM-source continuation | NON-GRADUATED**

## Question
Can a correctly installed inductive surge suppressor change when a relay, solenoid or final element physically releases after the controller commands OFF? **Yes**, according to original Omron safety-relay guidance. This is **different** from LEAK-01's leakage through an open contact: suppression can prolong decay of *stored coil energy* even after supply is removed.

## Original manufacturer sources
1. OMRON Industrial Automation, *Safety Precautions of Safety Relays — Cautions for Safety Relays*, official https://www.ia.omron.com/product/cautions/16/safety_precautions.html ; directly read 2026-10-26, §§3-(1)-4 and 3-(2)-5–8, lines near 202–232 and 280–310 in web representation. Exact product family and installed circuit **UNKNOWN**.
2. OMRON, *FAQ02129 — surge-absorbing circuit for DC-load solid-state relays*, https://www.ia.omron.com/support/faq/answer/18/faq02129/ ; directly read 2026-10-26.
3. Schneider Electric, *TeSys D LC1D38BL product datasheet*, **2018-03-12**, original https://iportal2.schneider-electric.com/Contents/docs/SQD-LC1D38BL.PDF ; direct PDF pages 1–3 read. This particular model has a **built-in bidirectional peak-limiting diode suppressor**, catalog opening time **20–30 ms**, and separate mechanical-link/mirror contact descriptions. These are OEM catalog conditions **for this exact model**, not measured machine stop time or universal suppressor effect.

## Source-confirmed manufacturer propositions
**DOC-CONFIRMED — Omron safety relay cautions:** a diode across a DC inductive load recirculates coil energy and can increase release time more than the cited CR arrangement. Diode+Zener can shorten the release time relative to a plain diode; varistor and CR effects depend on circuit conditions. Omron warns against generalizing protection components without actual application checking. **Do not use the example selection numbers as a field design recipe.**

**DOC-CONFIRMED — Omron:** some CR circuits allow current across an open contact, and some incorrect capacitor arrangements can contribute to contact welding. Omron also describes leakage current into relay coils, a **sneak-current** series path that can cause a relay to hum or not release, and a coil indicator LED that reflects **coil power, not physical contact operation**. These are three distinct failure witnesses: leakage, release delay, and status ambiguity.

**DOC-CONFIRMED — Omron FAQ02129:** diode suppression helps protect a solid-state switch but can lengthen solenoid/valve release time; diode+Zener is one possible different transient/release tradeoff. It does **not** certify a valve's hydraulic safe state, diagnostic coverage or stop time.

**DOC-CONFIRMED — Schneider LC1D38BL:** datasheet's 20–30 ms opening time and built-in bidirectional suppressor are **model/condition-specific**. The catalog separately identifies a mirror NC and mechanically linked auxiliary contacts; no inference of machine-wide PL/SIL or gravity holding is permitted.

## Why it matters
An engineer may improve electrical-noise behavior by changing a suppressor, then unknowingly alter the relay/valve release time and thus a safety function's end-to-end reaction. Conversely removing suppression without analysis may damage a driver or accelerate contact wear. An OFF bit, an extinguished coil LED and a feedback contact are not interchangeable physical observations.

**INFERENCE — validation rule:** a change of suppression topology or exact coil part should reopen the relevant stopping-time budget, final-element release proof, EDM feedback/diagnostics and fresh restart. For a hydraulic press brake, valve release does not by itself prove gravity-load holding or trapped-pressure isolation. Use independent safety-related control and physical mechanisms. No generic release-time increment or safety distance is assigned.

**UNKNOWN:** OpenPressBrake coil, diode, contactor/valve, energy zones, Y1/Y2 response, measured stop time, PL/SIL, actual installed safety function. **TEST-CONFIRMED none, SOURCE-CONFIRMED new LinuxCNC none.** No simulation or physical experiment; G0/G1 HOLD.
