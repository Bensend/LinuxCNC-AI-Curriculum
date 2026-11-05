# MOTION-227 — Homing servo ordering and a real Mesa 7i76e index wiring example (4000, NON-GRADUATED)

## Question
When does the homing state machine sample the bidirectional index-enable pin, and how is the handshake connected in a real HostMot2 configuration? This is a source/configuration audit, **not** a realtime execution or hardware validation. Continues [MOTION-226](4400_LINUXCNC_MOTION_226_HOMING_SWITCH_INDEX_STATE_MACHINE_2026-11-05.md).

## Immutable source provenance
- LinuxCNC **v2.9.10**, [control.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c), blob `b6e45d590c7d11030654d8f7d13d118f581b6439`, `emcmotController` lines 205–275.
- Same tag, [homing.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/homing.c), blob `13f74f43a1169606e87c7bd8d48f44a2cad6fa74`, `base_read_homing_in_pins` lines 529–537, `base_write_homing_out_pins` 540–551, `HOME_INDEX_SEARCH_START/WAIT` around 1180–1220.
- Public real-world example, [Skyfire-community/SVM2-LinuxCNC at 0fabfe4](https://github.com/Skyfire-community/SVM2-LinuxCNC/tree/0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123): [init.hal](https://github.com/Skyfire-community/SVM2-LinuxCNC/blob/0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123/init.hal) blob `84ad49cf7474e8c725e652faeed29db69a7c1c00`; [axis.hal](https://github.com/Skyfire-community/SVM2-LinuxCNC/blob/0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123/axis.hal) blob `1c7568f5bdb80aa40e47adf4e792b950e9793de4`; [Skyfire.ini](https://github.com/Skyfire-community/SVM2-LinuxCNC/blob/0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123/Skyfire.ini) blob `6f63c233875bd82b2eb426a4dfcb95b7bb612e43`. This is a repository example, not a verified running machine.

## Source-confirmed controller ordering
Within one invocation of `emcmotController`, `read_homing_in_pins(ALL_JOINTS)` occurs **before** `process_inputs()`, `do_homing()` (conditional on `EMCMOT_MOTION_FREE`), `get_pos_cmds()`, `output_to_hal()`, and finally `write_homing_out_pins(ALL_JOINTS)`. The read copies both `home-sw-in` and `index-enable` from HAL into private `H[j]` state; the write copies homing, homed, home-state and index-enable back to HAL. This makes the handshake an explicit sampled, stateful transaction, not a direct asynchronous callback.

When `HOME_INDEX_SEARCH_START` arms `H[j].index_enable=1`, the write exposes that request later in the same controller invocation. In `HOME_INDEX_SEARCH_WAIT`, the test is against the **copied** `H[j].index_enable`, not a fresh HAL read. Thus an encoder-side clear occurring **after** the controller's read cannot be observed by that controller invocation. **INFERENCE, bounded by scheduling:** the next controller invocation that samples the cleared pin can advance the homing state; the actual delay depends on HAL function order and encoder driver update timing. Do not claim an exact one-cycle latency for all configurations.

## Concrete 7i76e configuration
The public Skyfire `init.hal` registers `hm2_7i76e.0.read` at servo-thread position before `motion-command-handler`, `motion-controller`, PID calculations, and `hm2_7i76e.0.write` (lines 21–32). `axis.hal` connects `joint.0.index-enable <=> hm2_7i76e.0.encoder.02.index-enable`, joint 1 to encoder 01 and joint 2 to encoder 00. The same file routes encoder position into each joint's `motor-pos-fb` and wires home switches to `joint.N.home-sw-in`. `Skyfire.ini` sets `HOME_USE_INDEX=YES` on joints 0–2 (lines 175, 220, 265), with positive search and latch velocities. This is a coherent configuration-level example of the MOTION-226 switch-then-index path.

**Important timing distinction:** HostMot2 `read` runs before motion-controller, so any index event made visible by that read can be sampled by homing in that same servo invocation. The controller's newly armed index-enable is written to HAL before HostMot2 `write`; hardware arming and the subsequent hardware index event require additional hardware/driver timing not established by this trace. The source does not establish that HostMot2's index reset and clear occur within one cycle.

## Disconnected review exercise (NOT RUN)
Trace two servo invocations for joint 0. Cycle A: prior `index-enable=0`, state `HOME_INDEX_SEARCH_START`; controller reads 0, sets private enable=1, writes HAL=1, then hm2 write follows. Cycle B: assume hm2 read has cleared HAL enable to 0 after an index event; controller reads 0, sees `HOME_INDEX_SEARCH_WAIT`, disables free motion and transitions to index position setup. If the encoder has not cleared the pin, Cycle B remains waiting. **These are conditional oracles, not observed behavior.** Use `halcmd show funct` / `halcmd show thread` and a servo-aligned trace to verify an actual deployment; never drive a physical axis merely to validate this lesson.

## Diagnostic matrix
| Observation | Source-grounded interpretation | Still unknown |
|---|---|---|
| `home-state` in index wait, index-enable 1 | Homing request has not been observed cleared at controller read | Whether index absent, wiring wrong, encoder unarmed or delayed |
| index-enable cleared between controller reads | Next controller read can see 0 | Exact HostMot2 clear timing |
| index-enable 0 while still index-wait in userspace snapshot | Possible asynchronous snapshot of different function phases | Requires cycle-aligned capture |
| encoder position changes, index-enable remains 1 | Position feedback alone is not proof of index capture | Actual index input and mask configuration |
| home-sw-in toggles but homing not complete | Switch and index are separate stages | State, abort, limit and index behavior |

## Evidence ledger / limitations
**SOURCE-CONFIRMED:** controller read/do/write order, private HAL copies and index wait predicate, and pinned Skyfire HAL/INI text. **INFERENCE:** cycle-A/B causal illustration and timing implications. **TEST-CONFIRMED: none. UNKNOWN:** HostMot2 encoder driver exact index-enable clearing code and packet boundary; actual hardware behavior, source-version compatibility of Skyfire config, switch debounce, measured latency. The example is not a certified machine configuration. Independent personnel-safety authority is outside the LinuxCNC homed bit; do not conflate these.

## Reproduction without machine motion
```sh
git clone https://github.com/LinuxCNC/linuxcnc.git && cd linuxcnc
git checkout v2.9.10
grep -nE 'read_homing_in_pins|do_homing\(|write_homing_out_pins' src/emc/motion/control.c
grep -nE 'base_read_homing_in_pins|base_write_homing_out_pins|HOME_INDEX_SEARCH_WAIT' src/emc/motion/homing.c
# Independently fetch the three Skyfire files at 0fabfe4 and inspect addf, index-enable nets, HOME_USE_INDEX.
```
Commands are recipes, not execution evidence.

## Next investigation
Trace `hm2_encoder` index-enable arm/clear logic and hm2_eth read/write boundaries in v2.9.10, or rotate to 3000 machine-specific probing if information gain stalls. Preserve independent safety, blind evaluation, graduation, and compute gates.
