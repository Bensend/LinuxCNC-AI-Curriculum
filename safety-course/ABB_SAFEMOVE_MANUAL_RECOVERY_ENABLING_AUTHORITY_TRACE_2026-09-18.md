# ABB SafeMove manual-recovery / enabling-authority trace

Date: 2026-09-18

## Scope

Professional same-machine example for the safety-course setup/recovery branch. This is an evidence trace from ABB robot-controller/SafeMove documentation, not an OpenPressBrake design specification. Robot-specific values and behavior must not be copied into a press brake without machine-specific risk analysis and validation.

## Sources

1. ABB, `Application manual - Functional safety and SafeMove`, 3HAC066559-001 (current public ABB Library copy inspected 2026-09-18): https://library.e.abb.com/public/2d31714bc8f5461a9ea4abd694b6c43e/3HAC066559%20AM%20Functional%20safety%20and%20SafeMove%20for%20OmniCore-en.pdf
2. ABB IRC5/FlexPendant operating-manual family, manual-mode/enabling-device behavior. The professional implementation is used only for the behavior explicitly documented below.

## Same-machine recovery chain

### Safety supervision violation

**DOC-CONFIRMED.** ABB SafeMove documents distinct recovery behavior after a safety supervision function has triggered. For position/orientation violations in Automatic mode, the documented recovery path requires switching the controller to Manual mode and jogging the robot back to a position that no longer triggers the supervision function.

For a position/orientation violation already in Manual mode, ABB requires release and re-activation of the three-position enabling device before jogging back to a non-violating position.

This is valuable because it exposes a real professional chain in which a safety violation does not simply clear because an ordinary motion command disappears.

### Unsynchronized state

**DOC-CONFIRMED.** ABB separately documents recovery from an unsynchronized state: pressing Motors On permits movement at reduced speed, followed by a synchronization operation. This demonstrates that `MOTORS ON` and `VALID SAFETY POSITION/SYNCHRONIZATION STATE` are separate claims.

Do not generalize ABB's exact recovery sequence or speed value to another machine.

### Manual-mode enabling device

**DOC-CONFIRMED.** ABB's IRC5/FlexPendant documentation describes manual reduced-speed operation with the three-position enabling device held in its center-enabled position. Release or full compression removes the enabling condition. In manual full-speed program execution, ABB requires both the center-enabled device and a hold-to-run/Start action. ABB also resets the initial permitted speed after the enabling device has been released or fully compressed before it is re-initiated.

This provides the complete-machine distinction sought by the previous checkpoint:

`MODE SELECTED`

`!= SAFETY SUPERVISION STATE ACCEPTABLE`

`!= THREE-POSITION DEVICE VALID`

`!= MOTORS/SAFETY MOTION AUTHORITY AVAILABLE`

`!= SEPARATE JOG / HOLD-TO-RUN / START INTENT`

`!= PHYSICAL MOTION`.

## Frozen lesson

A professional implementation can require **mode transition + deliberate enabling-device re-initiation + corrective manual motion + restored supervision state** rather than treating return of an enable input as automatic recovery.

Freeze:

**SAFETY VIOLATION CLEARED AT INPUT != SAFETY RECOVERY COMPLETE != ENABLING DEVICE RE-INITIATED != CORRECTIVE MOTION AUTHORIZED != SUPERVISED STATE RESTORED != AUTOMATIC/PRODUCTION AUTHORITY != FRESH ORDINARY START.**

The important OpenPressBrake transfer is architectural, not numerical: safety recovery must preserve a distinction between permission to perform bounded recovery motion and permission to resume normal production.

## Adversarial failure paths

### Stale jog/start survives the violation

ABB's documented requirement to release/re-activate the enabling device in manual recovery is evidence that recovery can require a new human enabling transition. It does **not** prove how a future OpenPressBrake ordinary command should be latched. For the curriculum, a stale LinuxCNC/HAL/FPGA `JOG`, `DOWN`, `START`, or `ENABLE` surviving safety recovery remains unacceptable as assumed fresh intent; the actual implementation must be validated.

### Position remains outside the supervised envelope

A successful enabling-device transition is not proof that the axis is back in a permitted region. ABB explicitly describes jogging back until the supervision condition is no longer violated. Therefore `ENABLING VALID != SUPERVISED POSITION VALID`.

### Enabling device release/full squeeze during corrective motion

The professional manual-mode behavior removes enabling authority at either extreme. The installed machine must separately validate final-element reaction and actual motion cessation. Device-state evidence alone is not physical stopping proof.

### Loss of synchronization

ABB's separate synchronization recovery shows that a machine can have a motion-enabling state while another safety-relevant state remains not yet restored. A future machine must not collapse feedback validity/synchronization and actuator permission into one HMI bit.

### Mode change or power restoration

The inspected ABB evidence does not establish a generic OpenPressBrake power-cycle state machine. Exact mode persistence, reset requirements, channel discrepancy behavior, hydraulic final-element behavior and restart semantics remain **UNKNOWN** for OpenPressBrake.

## Commissioning transfer card

For a machine using setup/recovery motion, challenge these separately:

1. trigger a validated safety supervision fault;
2. prove normal/automatic motion authority is removed;
3. select the permitted recovery/setup mode;
4. prove no motion occurs from mode selection alone;
5. establish the required enabling-device state;
6. prove enabling alone does not create an unintended stale ordinary motion command;
7. issue deliberate bounded corrective jog/start intent;
8. release the enabling device during corrective motion;
9. fully squeeze the enabling device during corrective motion;
10. restore enabling after either protective transition and verify required re-initiation/rearm semantics;
11. prove the actual supervised condition becomes valid rather than trusting an HMI acknowledgement;
12. prove return to normal/automatic authority requires the intended reset/rearm path;
13. prove production motion still requires separate fresh ordinary START intent;
14. repeat with feedback/synchronization unavailable or contradictory;
15. repeat applicable cases across power restoration and communications restoration.

Where a gravity-loaded or hydraulically retained axis is involved, add physical load-retention and final-element proof; ABB robot enabling behavior does not establish press-brake hydraulic safety.

## Evidence ledger

- SafeMove recovery distinguishes automatic-mode and manual-mode recovery after supervision violations: **DOC-CONFIRMED**.
- Manual recovery from position/orientation violation requires enabling-device release/reactivation before corrective jog: **DOC-CONFIRMED**.
- Corrective motion continues until the supervision condition is no longer violated: **DOC-CONFIRMED**.
- Unsynchronized-state recovery separately requires Motors On and synchronization: **DOC-CONFIRMED**.
- ABB manual mode uses a three-position enabling device and separates enabling from hold-to-run/Start for applicable program execution: **DOC-CONFIRMED**.
- Transfer rule separating safety recovery authority from LinuxCNC ordinary motion intent: **INFERENCE**, grounded in the professional architecture and repository safety boundary.
- OpenPressBrake safe speed, force, stopping time/distance, hydraulic state, exact mode logic, channel discrepancy timing, reset/rearm, PL/SIL/category/DC: **UNKNOWN**.
- Physical OpenPressBrake runtime evidence: **TEST-CONFIRMED: none**.
- Community evidence: **COMMUNITY-REPORTED: none used**.

## Information-gain result

This closes the previous product-level gap with a same-machine professional recovery example that exposes mode selection, safety-supervision violation, three-position-device re-initiation, bounded corrective jog, and restoration of the supervised state. It still does not expose a press-brake hydraulic final-element chain or a complete enabling-channel discrepancy/power-cycle truth table.

Next high-value branch: return to the primary retaining-function priority and seek a professional dual-retaining-element or hydraulic/mechanical disagreement implementation with physical load-safe disposition and re-proof before production restart. Do not spend another session collecting generic enabling-device product pages unless a wiring/evaluation manual exposes new channel-fault behavior.

No simulation, synthesis, build, benchmark, test suite, or GitHub-hosted Actions compute was justified or used.