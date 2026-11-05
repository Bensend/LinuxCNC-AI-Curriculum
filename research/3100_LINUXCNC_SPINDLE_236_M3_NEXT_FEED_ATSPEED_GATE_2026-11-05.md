# SPINDLE-236 — M3/M4 spindle-on to next-feed at-speed gate (3100; NON-GRADUATED)

2026-11-05 UTC. Continuation of SPINDLE-235. **Source inspection only**, LinuxCNC tag `v2.9.10`; no runtime or machine tests.

## Source provenance (immutable file blobs)

- [interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc), blob `f01a359652d588d59c9e210fa441a99d2ee19598`, lines 3467–3517: M3/M4 dispatch to `enqueue_START_SPINDLE_CLOCKWISE/COUNTERCLOCKWISE`, M5 to stop.
- [interp_queue.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_queue.cc), blob `dc6c35f0d5329b8f875365dbaee33fc663c16948`, lines 156–179 and 515–520: spindle start is immediate if queue empty, otherwise queued and replayed in order.
- [emccanon.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc), blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`, lines 1870–1915: canonical spindle-start builds `EMC_SPINDLE_ON` and transfers `wait_for_atspeed` to `wait_for_spindle_at_speed`.
- [command.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c), blob `0b79061d39be915bbea548b2c33bb794d31ab302`, lines 1016–1052, 1082–1109, 1517–1520, 1622–1627: motion sets `atspeed_next_feed` from spindle-on, consumes it only for feed-type linear moves (or next circle), restores it on trajectory-add failure; non-feed linear motion with CSS can re-arm it; rigid tap clears pending flag and has its own synchronized at-speed behavior.
- [tp.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c), blob `5768d6e6880569f72156ed9a761b5eee531c9fcf`, lines 1795–1800, 2798–2830, 2891–2902, 3445: at-speed flag makes segment a stop boundary and the TP can wait before activation. Prior SPINDLE-235 documents all-configured-spindles predicate.

## Mechanism and consequences

**SOURCE-CONFIRMED:** The gate is not a blanket condition on every `G1`. A spindle-on command carries an explicit wait flag into motion. Motion stores that flag as `atspeed_next_feed`; when the next eligible feed segment is admitted it sets that segment's `atspeed` flag and clears the pending flag. The TP then checks the actual sampled spindle-ready bits when the flagged segment activates. A `G0` does not consume the pending flag through the feed-type branch. A circular segment has a corresponding consume-and-restore path. An unsuccessful segment insertion restores the pending wait flag rather than silently losing it. A position-synchronized move can separately demand spindle readiness even without a queued spindle-start flag.

**SOURCE-CONFIRMED:** The code explicitly treats CSS non-feed moves specially: if the spindle's `css_factor` is nonzero, a non-feed linear move sets `atspeed_next_feed`. This is a useful lathe transfer case, not evidence that all traverses wait.

**UNKNOWN:** The precise default value of the canonical `wait_for_atspeed` argument for the no-argument calls in `interp_queue.cc` was not yet pinned to its declaration. Do not claim every M3 automatically waits without resolving this header/default and the Task spindle-on forwarding path. M5 clearing/re-arming semantics, spindle orientation and toolchange handshake remain separate open questions.

## Reproducible source inspection

At a checkout of LinuxCNC v2.9.10:
```sh
git checkout v2.9.10
rg -n 'enqueue_START_SPINDLE|START_SPINDLE_CLOCKWISE|wait_for_spindle_at_speed' src/emc
rg -n 'atspeed_next_feed|issue_atspeed|tpCheckAtSpeed' src/emc/motion src/emc/tp
rg -n 'EMC_SPINDLE_ON|wait_for_atspeed' src/emc/task src/emc/rs274ngc src/emc/nml_intf
```
Trace the default argument declaration and Task `EMC_SPINDLE_ON` dispatch before asserting which G-code sequences arm the flag.

## Analytical review fixtures (not executed)

1. `M3 S1000; G0 X10; G1 X20 F100`: inspect whether spindle-on wait flag survives the traverse and attaches to the feed; confirm default wait argument first.
2. `M3 S1000; G1 X20 F100; G1 X30`: first eligible segment consumes the pending flag; second is not automatically flagged by this mechanism.
3. Simulate `tpAddLine` returning an error on the first eligible feed: verify pending at-speed flag is restored for a retry.
4. A CSS lathe traverse after a feed: inspect the special re-arm branch and explain why it is not ordinary mill behavior.
5. `M3; G33`: inspect independent synchronized-move readiness logic; do not equate this with ordinary G1 flag handling.

## Evidence ledger and limits

SOURCE-CONFIRMED: code paths and flag transfer listed above. INFERENCE: the intended M3→first-feed behavior follows from the explicit flag pipeline, conditional on the actual default argument and Task forwarding. UNKNOWN: effective no-argument default, Task handling, exact M5 reset, real spindle startup latency. TEST-CONFIRMED: none. No compute, Actions or physical machine operations.

## Next

Resolve the canonical default argument and Task `EMC_SPINDLE_ON` forwarding, then inspect M6 spindle-stop, tool-change acknowledgement and M19 orientation using real Mesa configuration. Rotate to lathe G33 or plasma if toolchange evidence is exhausted. No graduation/evaluation/safety gates changed.
