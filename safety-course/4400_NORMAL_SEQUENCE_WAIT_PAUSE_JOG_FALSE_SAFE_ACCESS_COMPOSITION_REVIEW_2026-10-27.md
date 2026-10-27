# 4400-COMPOSE-02 — M66, M1/M0 and feed/jog controls can all look 'stopped' without proving safe access

**Status:** NON-GRADUATED integrated source-based adversarial design review. No physical experiment, machine-specific validation, new formal exercise bank, evaluator score or simulation. **Revisions:** LinuxCNC development `c9a5a0a5034177c8db64cb44abf14d4f2eb166f7`, stable `v2.9.10` where inspected. Use with the [cumulative safety package](SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md).

## Distinct source mechanisms (not new discoveries)

- [M66 Task wait/timeout](../research/4400_LINUXCNC_M66_WAIT_TIMEOUT_AND_NONSAFETY_INPUT_AUTHORITY_AUDIT_2026-10-27.md): `L3` accepts preexisting HIGH, `L1` requires sampled low→high, Q timeout sets `#5399=-1` **without automatic G-code abort**, and the result reader obtains current status after the wait.
- [M0/M1 normal pause/resume](../research/4400_LINUXCNC_M0_M1_PAUSE_RESUME_VS_SAFE_ACCESS_SOURCE_AUDIT_2026-10-27.md): M1 can be disabled by optional-stop selection; M0 is normal trajectory pause; default M0/M1 path does not explicitly turn spindle/coolant OFF; Resume is normal motion authority.
- [Feed/jog/homing source reinspection](../research/4400_LINUXCNC_FEED_HOLD_INHIBIT_JOG_STOP_SAFETY_AUTHORITY_SOURCE_AUDIT_2026-10-27.md) and [predecessor reconciliation](../research/4400_FEED_JOG_01_PREDECESSOR_AND_WHEEL_JOG_SOURCE_CORRECTION_2026-10-27.md): M53 can disable feed-hold, feed-inhibit may let a spindle-synchronized move complete, jog-inhibit rejects new jogs, active jog-stop is separate, and joint wheel-jog uses a feed-scale guard even though current manual broadly says G-code-only. Homing-inhibit rejects **initiation**, not a proven active homing stop.
- [Existing physical safety architecture](../research/25F0_PRESS_BRAKE_PROFESSIONAL_ARCHITECTURE_TRACE_2026-09-24.md) and [actual OpenPressBrake Pilz/AKAS source delta](../research/4400_AKAS_LCII_M_PILZ_MUTING_SLOW_SPEED_OVERTRAVEL_AUTHORITY_AUDIT_2026-10-27.md) already separate ordinary CNC requests from independently qualified guard/muting/stop/hold and physical energy boundaries.

## Hypothetical adverse timeline — inference, not an installed defect

1. **Ordinary readiness check:** A program waits `M66 P0 L3 Q5` on a process 'clamped' bit. A stuck-HIGH input makes the normal wait complete. The bit is not an independent mechanical-retention witness. **SOURCE-CONFIRMED wait semantics; INFERENCE stuck-sensor consequence.**
2. **Optional inspection step:** A programmer includes `M1`, but optional stop is OFF; the program need not pause. **SOURCE/DOC-CONFIRMED.** A label 'operator inspection point' is not an interlock.
3. **Manual pause:** An operator invokes `M0` and sees PAUSED. The normal trajectory is paused, but the default branch does not explicitly stop spindle/coolant and says nothing about hydraulic gravity load, stored pressure, electrical isolation or physical guarding. **SOURCE-CONFIRMED command scope; selected hazard UNKNOWN.**
4. **Setup/jog confusion:** An HMI displays Feed Hold HIGH, but `M53 P0` may have disabled its effect. A keyboard/halui jog command has a separate `jog_inhibit` gate; a joint wheel-jog has a feed-scale gate. Neither is an independent protective stop. **SOURCE-CONFIRMED paths; runtime effects depend on mode.**
5. **Restart:** Pressing normal Resume restores trajectory state; the inspected normal source path has no independent proof of guard occupancy, AKAS OSSD, physical Y1/Y2 hold or deliberate safety rearm. **SOURCE-CONFIRMED path; safety allocation INFERENCE.**

**Causal risk proposition, not a quantitative risk calculation:** dangerous exposure requires a physical access/safeguard failure or bypass **and** hazardous energy/motion capable of injury. Normal-control misleading indications can increase the likelihood of unsafe human action but are **not themselves proof that a machine's independent safety system failed**. Do not assign probabilities, stopping distances, PL/SIL or hydraulic valve truth from this timeline.

## Practical design response (make safe access the easiest path)

A normal production HMI should visibly distinguish **Wait**, **Timed out**, **Paused**, **Feed Hold**, **Jog Inhibited**, **Protective Stop**, **Safe Access**, and **Energy Isolated**. Only the independently justified safety function and actual physical final elements can authorize protective access; a convenient safe-access procedure should not require editing G-code, unplugging a sensor, bypassing a guard or opening a cabinet. Retain normal program state if practical, but ensure physical stop/hold, guard/occupancy and deliberate restart are independently qualified. For maintenance, follow real energy isolation and gravity/mechanical restraint, not a pause bit.

**Selected OpenPressBrake evidence required:** actual Pilz/AKAS models and active program, safety sensor-to-input-to-logic-to-OSSD/final-element trace, qualified Y1/Y2 safe speed and muting, independent ram stop and gravity hold, hydraulic energy isolation, guarding/egress, deliberate reset/rearm, and physical validation. Existing [restricted OPB-D02 intake](4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md) remains the correct private route. None is supplied by these public source audits. **G0/G1 HOLD; no personnel-exposed hazardous operation.**

## Evidence ledger

**SOURCE-CONFIRMED** normal code paths at pinned revisions; **DOC-CONFIRMED** M66/M0/M1/M53 and motion pin scopes; **TEST-CONFIRMED** none; **COMMUNITY-REPORTED** none; **INFERENCE** combined human/machine failure path and anti-bypass design benefits; **UNKNOWN** actual OpenPressBrake program, hardware, physical state and evaluator. No Actions workflow, local runner, hosted compute, simulation or machine test. This is an integrated adversarial review, **not** an additional scored competency or paper-case count.
