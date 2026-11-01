# 4000 LinuxCNC — M51 / feed and spindle inhibit cross-coupling acceptance

**2026-11-01 | 4000 implementation | ALL CASES NOT RUN.** Purpose: independently discriminate the source-derived `SS_ENABLED` bit interaction and spindle-selection loss, without hardware, independent evaluation contamination, or physical motion.

## Fixture and evidence contract

Use a **disconnected, software-only** LinuxCNC simulation with one spindle first, then a two-spindle configuration. Execute only on a verified isolated runner bearing **both** `self-hosted` and `openpressbrake` labels; never dispatch to GitHub-hosted runners. No Mesa, EtherCAT, VFD, GPIO, actual actuator, or energized spindle. Pin stable `v2.9.10` and development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`; record commit, INI/HAL, G-code, stdout/stderr, interpreter output, Task command mode/spindle, motion `enables_new`/`enables_queued`, and HAL `motion.feed-upm`, `spindle.0.speed-out`, `spindle.0.on`. A standalone interpreter or canonical log **cannot** prove realtime behavior. Preserve all output, failures, and actual job runtime. **No case is a personnel-safety test.**

Source anchors: [OVERRIDE-93](../research/4400_LINUXCNC_OVERRIDE_93_FEED_INHIBIT_SS_BIT_COUPLING_SOURCE_AUDIT_2026-11-01.md), [OVERRIDE-94](../research/4400_LINUXCNC_OVERRIDE_94_SPINDLE_INHIBIT_SS_BIT_SPEED_ON_SOURCE_AUDIT_2026-11-01.md), [OVERRIDE-95](../research/4400_LINUXCNC_OVERRIDE_95_M51_SELECTED_SPINDLE_DROPPED_AT_TASK_SOURCE_AUDIT_2026-11-01.md). Predecessors [FEED-JOG-01](../research/4400_LINUXCNC_FEED_HOLD_INHIBIT_JOG_STOP_SAFETY_AUTHORITY_SOURCE_AUDIT_2026-10-27.md) and [OVERRIDE-SCOPE-01](../research/4400_OVERRIDE_SCOPE_01_LINUXCNC_2910_M48_M49_M51_DOLLAR_SELECTION_SOURCE_DOC_CONFLICT_2026-10-29.md).

## Predeclared cases

| ID | Isolated input/state | Source-derived prediction | Discriminator to retain |
|---|---|---|---|
| O93-01 | Default `M51 P1`, `motion.feed-inhibit=1`, non-synchronized G1 | `SS_ENABLED=1`; net feed scale forced 0 | Actual mask, feed-upm, commanded position versus time |
| O93-02 | `M51 P0`, `motion.feed-inhibit=1`, new G1 | `SS_ENABLED=0`; feed-inhibit branch does **not** force zero | Distinguish motion scaling from interpreter/canonical output |
| O93-03 | `M50 P0`, `M51 P1`, feed-inhibit=1 | FS disabled but SS enabled; inhibit branch still zeroes scale | Prove mask tests bit 0, not bit 1 |
| O93-04 | `M51 P0`, feed-inhibit=1, `M53 P1`, feed-hold=1 | Feed-hold independently zeroes scale despite missing SS bit | Isolate FH_ENABLED and avoid false negative |
| O94-05 | `M3 S1200`, SS enabled, spindle inhibit=1 | Speed-out commanded zero; `spindle.0.on` may remain true | Both pins and commanded speed, not measured RPM |
| O94-06 | `M3 S1200`, `M51 P0`, spindle inhibit=1 | Inhibit branch bypassed; nonzero speed-out expected absent other gates | Status `SS_ENABLED`, `net_scale`, speed-out |
| O94-07 | Restore `M51 P1` while inhibit=1 | Next effective mask enables zeroing again | Segment boundary, queued/current mask distinction |
| O95-08 | Two spindles; `M51 P0 $1` | Interpreter/canon target 1; Task discards spindle field; motion/status use global SS bit | Capture **both** NML spindle field and Task call; both status entries |
| O95-09 | Two spindles; `M51 P0 $0` | Interpreter rejects selector zero (predecessor) | Parser error, no motion inference |
| O95-10 | `M49` then `M48` across separate queued moves | Global SS bit toggles, and both inhibit gates follow its bit-0 state | Confirm ordering, no stale queued-mask confusion |

## Minimal program outlines (adapt to qualified sim)

For O93-02, run a bounded program sequence with `G21 G90 G94`, `M51 P0`, `F60`, `G1 X1`, and `M2`. Assert the HAL feed-inhibit input **before** the G1 starts, and compare against O93-01 with `M51 P1`. Keep travel tiny and disconnected. For O94-06, use `M3 S1200` and observe the HAL spindle command in a simulated spindle circuit only. For O95-08, configure `[TRAJ]SPINDLES=2` (verify exact syntax against pinned INI docs), issue `M51 P0 $1`, and capture interpreter and Task separately. Never infer physical rotation from `spindle.on`.

## Expected static truth table

```text
SS_ENABLED = 0x01; FS_ENABLED = 0x02; FH_ENABLED = 0x08
default mask = 0x0b
feed_inhibit_gate = (mask & (feed_inhibit ? 1 : 0)) != 0
spindle_inhibit_gate = (mask & (spindle_inhibit ? 1 : 0)) != 0
mask 0x0b, inhibit 1 -> both gates true
mask 0x0a, inhibit 1 -> both gates false
mask 0x09, inhibit 1 -> both gates true
```

These arithmetic predictions are from source inspection, **not executed test outputs**. A proposed upstream correction must first preserve intentional spindle-synchronized completion behavior and avoid changing jog/override semantics by accident. Reproduce before claiming a confirmed defect or submitting a fix.

## Result ledger

All O93-01..O95-10: **NOT RUN**. No builds, simulations, source execution, physical operations, or Actions compute performed. Host/self-hosted Actions consumed 0/0 minutes. Independent personnel-safety authority, closed levels and evaluation gates unchanged.
