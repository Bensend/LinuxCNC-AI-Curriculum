# 4400-PEDAL-02 — Three-stage foot pedal: does harder pressing actually stop it?

**2026-10-26. Learner field card / NON-GRADUATED.** Read [original Schmersal source audit](../research/4400_PEDAL_02_SCHMERSAL_PRESSURE_POINT_HD_VS_SAFETY_UDR_POSITIVE_OPENING_OEM_AUDIT_2026-10-26.md) after the [PEDAL-01 guarded-pedal module](4400_PEDAL_01_ANTI_TRIP_FOOTWEAR_RELOCATION_AND_FRESH_START_FIELD_MODULE_2026-10-26.md). Do not infer installed OpenPressBrake parts.

## Three deceptively similar devices

| Device | Documented switch-level state | Incorrect inference to reject |
|---|---|---|
| Schmersal **TF 232-20HD** exact current item 151182009, 2 NO | OEM 2006 `hd` three-phase pressure-point family: `00 -> 10 -> 11`; first NO **stays on** after further depression | “Pushing harder cuts power” |
| Schmersal **TFH 232-11-üdr** safety-foot-switch brochure variant | NO actuation at pressure point; overtravel opens **positive-break NC**, mechanically latched; blue mechanical reset | “Any HD device has this NC latch” or “blue reset reauthorizes hazardous motion” |
| Schmersal **F 232 ... f** start/stop variant | OEM describes bi-stable toggle: first press ON, second press OFF | “Releasing the foot necessarily stops it” |

These are *manufacturer-documented device-level mechanisms*, not a validated hydraulic stop circuit. The original brochure is dated **04.2006**; verify exact selected-device current instructions before implementation.

## Eight PUBLIC PAPER cases — all **UNSCORED**

For each case, write expected **device contact** state where documented, separately mark ordinary command, independent safety function, physical stop/hold and rearm as UNKNOWN unless proven, and identify a safe no-energy documentary discriminator.

1. An installer sees “three-phase actuation” and labels deep press “E-stop” without checking contacts.
2. A diagram shows two NO contacts, and the programmer turns second NO into a software stop while the first NO remains ON. Identify software/safety authority boundary.
3. A salesperson says “also available as safety foot switch” while quoting exact **TF 232-20HD**. What exact evidence is missing?
4. A genuine safety-foot-switch NC opens on overtravel and latches; a supervisor immediately pushes its blue reset while the pedal is still held. Separate mechanical reset from safety rearm and deliberate new start.
5. An `f` bi-stable pedal is substituted for a momentary control. Predict the hazard of assuming foot release turns OFF.
6. A shield fits regular shoes but not the new safety boots. Propose a redesign that does not reward removal.
7. The machine's normal HMI reads “pedal OFF,” but no one has demonstrated actual independent Y1/Y2 stop or gravity retention. What can be claimed?
8. A press-brake audit cites 1910.217(b)(4) without noticing 1910.217(a)(5) exclusion. State the correct scope qualification and remaining guarding obligation.

## Eight documentary gates — all **NOT RUN**

| ID | Required evidence | No-paper shortcut |
|---|---|---|
| P2-G01 | Exact order code and device revision | “232 family” insufficient |
| P2-G02 | Correct `hd`, `f`, `üdr` contact diagram | Marketing “3 stage” insufficient |
| P2-G03 | NO/NC mechanical timing, latching and release/reset instructions | Generic Boolean table insufficient |
| P2-G04 | Qualified independent safety-input interpretation and diagnostics | LinuxCNC software edge insufficient |
| P2-G05 | Physical shield/footwear/accessibility and maintenance reassembly | Device certification alone insufficient |
| P2-G06 | Held-pedal/reset/power-loss fresh-start SRS | Blue reset button insufficient |
| P2-G07 | Y1/Y2 final-element stop, gravity load holding and isolation | Contact continuity insufficient |
| P2-G08 | Change-control, selected-machine validation and external evaluator | Public paper cases insufficient |

## Correct engineering boundary

The **positive-break NC** of a selected safety-foot-switch design can be one input to a qualified safety-related function, but only selected wiring/logic and independently demonstrated physical final elements can substantiate a personnel-safety claim. The normal LinuxCNC/FPGA control may use foot input for cycle requests, but may not be credited as the sole protective stop or load-holding function. A footswitch panic action is not automatically the machine's emergency stop.

No energized pedal experiment, motion test, stop-distance value, PL/SIL or hydraulic valve truth table is authorized here. All actual OpenPressBrake fields remain **UNKNOWN**, G0/G1 **HOLD**, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No people in the hazard zone during any experimental machine operation.
