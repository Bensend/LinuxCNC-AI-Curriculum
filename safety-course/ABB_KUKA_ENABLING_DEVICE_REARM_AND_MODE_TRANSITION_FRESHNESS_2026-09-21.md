# ABB/KUKA enabling-device rearm and mode-transition freshness study

Session start: 2026-09-21T07:33:51Z

## Scope

25C0/25E0 professional implementation trace following the PlantPAx demand-freshness work. This branch asks a different question: when safeguarding is suspended for manual/setup motion, what prevents a held/stale enabling condition or mode transition from becoming fresh authority for hazardous motion?

## Authoritative evidence

### ABB AC500-S SF_EnableSwitch / SF_EnableSwitch_2

Evidence class: DOC-CONFIRMED.

ABB's safety function-block documentation summarizes IEC 60204-1 enabling-control requirements and implements a three-position enabling device. The enabling function is valid only in the middle position; release and overtravel are stop conditions. Critically, when returning from position 3 (fully pressed/panic) toward position 2, enabling is not reactivated merely by passing through the middle position. ABB's SF_EnableSwitch_2 further states that suspension of safeguarding can only become enabled after a transition from position 1 to position 2; other switching directions/positions may not establish the enabling condition. It also requires the relevant operating mode to be selected outside the enabling-switch block and says automatic operation must be disabled in that mode by appropriate measures.

This is direct professional evidence that **physical control position alone is not sufficient authority**: transition history/freshness matters.

### ABB SF_SafetyRequest

Evidence class: DOC-CONFIRMED.

ABB's safety documentation for suspension of safety functions/protective measures requires other operating modes to be disabled, hazardous operation to require hold-to-run or equivalent control positioned for sight of the hazardous elements, operation to be restricted to reduced-risk conditions, and voluntary/involuntary machine-sensor action not to initiate hazardous functions. This reinforces that setup authority is a constrained safety mode, not ordinary automatic production with a safeguard bit bypassed.

### KUKA Sunrise Cabinet Med

Evidence class: DOC-CONFIRMED.

KUKA documents a three-position enabling switch for T1/T2/CRR. Motion is possible only while an enabling switch is in the center position; releasing all center-position enabling switches or fully depressing one produces a safety stop 1. KUKA separately warns against defeating/manipulating the enabling switch and calls for visual inspection/removal of foreign bodies. Its default operator-safety signal prevents T2 and automatic operation when the physical safeguard signal is absent; T1/CRR are separate modes with different safeguard treatment.

This provides a second industrial implementation separating mode authority, enabling-device state, safeguard state, and motion command.

## Durable engineering freezes

1. **ENABLING DEVICE IN CENTER POSITION != FRESH MOTION AUTHORITY.** Transition history can be safety-significant; an overtravel/panic event must not simply re-enable while the device mechanically passes back through center.
2. **ENABLING DEVICE HELD != START COMMAND.** An enabling device permits a separate motion/start command; it is not itself the command to move.
3. **SETUP MODE SELECTED != SAFEGUARD SUSPENSION VALID.** Mode selection, safety-mode confirmation, enabling-device sequence, and the permitted reduced-risk motion contract are separate conditions.
4. **RETURN TO AUTOMATIC MODE != PRODUCTION START.** Mode transition must not consume stale manual/setup demand as fresh production demand.
5. **SAFEGUARD SUSPENDED FOR SETUP != SAFEGUARD DEFEATED FOR PRODUCTION.** The setup state must disable incompatible operating modes and constrain hazardous operation.
6. **VISIBLE/HMI MODE STATE != PERSONNEL-SAFETY AUTHORITY.** Ordinary LinuxCNC/FPGA logic may display or gate normal production, but independent safety-related hardware/logic owns the personnel-safety mode/enabling function when required by the design.

## Demand-freshness consequence

The prior PlantPAx work established that command-source transfer can preserve or track latent demand. ABB's enabling-device implementation shows the complementary safety pattern: a safety-related permission may deliberately require a particular **new transition** rather than accepting a level that happens already to be true.

For curriculum reviews, every manual/setup -> automatic transition must therefore identify at least:

- which safety-related permissions must be newly established;
- which ordinary motion/cycle requests are cancelled on mode exit;
- which held inputs are ignored until released/reasserted or otherwise proven fresh;
- whether an enabling-device panic/overtravel requires return to the fully released state before new enable authority;
- how automatic production requires a distinct deliberate start after personnel/safeguard conditions are restored.

Do not universalize ABB's exact function-block state machine to every machine. The reusable lesson is the need for explicit transition/freshness semantics; the exact safe mode, stop category, speed/force limit, PL/SIL, and restart sequence remain machine/design specific.

## OpenPressBrake boundary

For OpenPressBrake teaching, a future setup/jog architecture must not be represented as `setup_mode && deadman = motion_allowed`. The design must separately define the independent safety-mode selection/enabling path and the ordinary LinuxCNC motion request. LinuxCNC may request jog motion only inside the permission envelope; it does not become the personnel-safety authority. No machine-specific reduced speed, stopping time, hydraulic state, or performance level is inferred here.

## Sources

- ABB AC500-S `SF_EnableSwitch` and `SF_EnableSwitch_2` safety function-block documentation, accessed 2026-09-21.
- ABB AC500-S `SF_SafetyRequest` safety function-block documentation, accessed 2026-09-21.
- KUKA Sunrise Cabinet Med operating instructions, issued 2021-11-26, accessed 2026-09-21.

## Evidence status

DOC-CONFIRMED: manufacturer-documented enabling/mode behavior above.
INFERENCE: curriculum/OpenPressBrake architecture consequences explicitly identified as reusable design reasoning.
UNKNOWN: OpenPressBrake-specific safe mode, stop category, reduced-risk limits, hydraulic truth table, diagnostic coverage, PL/SIL, and measured stopping performance.