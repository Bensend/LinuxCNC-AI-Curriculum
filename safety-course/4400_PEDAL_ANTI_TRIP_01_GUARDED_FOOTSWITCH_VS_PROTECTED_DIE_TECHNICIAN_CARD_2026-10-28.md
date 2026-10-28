# 4400-PEDAL-ANTI-TRIP-01 — A covered foot pedal is not a guarded die
**2026-10-28 | one-pass technician review; PAPER ONLY / NOT RUN.** Read the [source audit](../research/4400_PEDAL_ANTI_TRIP_01_OSHA3170_LINEMASTER_FOOTSWITCH_FALSE_ACTUATION_AND_BLANKING_AUDIT_2026-10-28.md).

**What could go wrong?** An operator aligns a small part, an offcut or boot moves the pedal, and a previously blanked light curtain no longer covers the hand path. The original OSHA 3170 press-brake incident (official indexed text, direct PDF fetch blocked) describes a historical injury of this kind. A visible guard on the pedal reduces one initiating path; it does not prove a guarded die.

| Quick field discriminator (existing Stage A B/E/F/G) | Reject this shortcut | Qualified evidence required |
|---|---|---|
| Pedal cannot be accidentally actuated? | “There is a cover,” a green HAL bit, or catalog photo. | Exact installed pedal and guard variant; anti-trip latch if present; mounting/boot fit; debris/side-entry paths; intact return and cable; maintenance usability. |
| Operator hands protected during commanded stroke? | “It takes two foot pedals,” “operator keeps a foot on it,” or pedal guard alone. | Independent front/side/rear access protection appropriate to machine and job; current sensing/guard coverage and physically demonstrated stop/hold. |
| Guard valid after a job or tool change? | A light-curtain LED or an old blanking/muting recipe. | Actual current blanked region, tool/part geometry, qualified protection at every exposed access route and change-control review. |
| Reset cannot start another stroke? | LinuxCNC reset, idle pedal input sampled once, or prior anti-repeat success. | Current physical pedal release, selected independent restart/rearm behavior, no retained cycle request, and witnessed safe state. |
| Guard remains usable rather than discarded? | “Train operators not to remove it.” | Comfortable safety-boot clearance, stable reachable placement, simple cleanout, easy reinstallation, no incentive to ride/defeat the latch. |

**Three distinct things:** (1) accidental **command prevention** by shield/latch, (2) **personnel protection** by qualified safeguarding and independent safety control, (3) **physical stopping/holding** by selected final elements. None implies the others. OSHA 1910.217(b)(4) foot-pedal language applies to its mechanical-power-press scope; **1910.217(a)(5) excludes press brakes**. Do not copy a mechanical-power-press clause as a press-brake certification claim.

**No live foot-reach, deliberate fault injection, hazardous blanking trial or energization is authorized.** Isolated visual/documentary review only until qualified Stage A and physical plan. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No machine-specific PL, stop distance, hydraulic truth table, approved guard or evaluator score is inferred.
