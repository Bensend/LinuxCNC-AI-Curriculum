# LATHE-244 — G33/G76 spindle-index handshake, LinuxCNC v2.9.10
**Scope:** 3200 Lathes / turning centers; NON-GRADUATED, source-confirmed only. 2026-11-05 UTC. No machine operation or executable tests.

## Engineering question
How does a G33/G76 synchronized cut become a phase-locked motion, and why is spindle-at-speed feedback *not* a substitute for encoder index acknowledgement?

## Pinned source and provenance
All paths below were fetched from `LinuxCNC/linuxcnc` at tag `v2.9.10`; blob SHA is the immutable identifier. Line references are 1-based in that revision.
- `src/emc/rs274ngc/interp_convert.cc` blob `f01a359652d588d59c9e210fa441a99d2ee19598`, lines 4888–4898, 4923–4935, 5020–5065.
- `src/emc/task/emccanon.cc` blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`, lines 1247–1266.
- `src/emc/motion/command.c` blob `0b79061d39be915bbea548b2c33bb794d31ab302`, line 989.
- `src/emc/tp/tp.c` blob `5768d6e6880569f72156ed9a761b5eee531c9fcf`, lines 2795–2844, 2925–2940.
- `src/emc/motion/control.c` blob `b6e45d590c7d11030654d8f7d13d118f581b6439`, lines 1979–1995.
- `src/emc/motion/motion.c` blob `febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841`, lines 707 and 733.

## Source-level execution chain
1. **Interpreter:** G33 validates a selected spindle (including optional `$` selection) and that the interpreter's spindle state is turning. It emits `START_SPEED_FEED_SYNCH(active_spindle, K, 0)`, one `STRAIGHT_FEED`, then `STOP_SPEED_FEED_SYNCH`. The interpreter's turning-state check is not an encoder-health test.
2. **G76 cycle:** `convert_threading_cycle` calls `threading_pass`; each pass uses a positioning traverse, disables feed override, starts position synchronization with the pitch, emits its cutting feed(s), stops synchronization, retracts, and restores override. Entry/exit taper changes the synchronized pitch for the angled segments. This is *not* merely a repeated unsynchronized G1 sequence.
3. **Canonical queue:** `START_SPEED_FEED_SYNCH` flushes buffered segments, queues `EMC_TRAJ_SET_SPINDLESYNC` with spindle, converted feed-per-revolution and `velocity_mode=false`, and marks the canonical spindle synchronized. `STOP_SPEED_FEED_SYNCH` queues a zero-pitch synchronization message.
4. **Motion command:** `EMCMOT_SET_SPINDLESYNC` calls `tpSetSpindleSync` with spindle, pitch, and flags. Exact Task forwarding from the queued `EMC_TRAJ_SET_SPINDLESYNC` to this motion command is an **open link** for the next investigation; do not infer an independently verified end-to-end dispatch from the two endpoints.
5. **Trajectory planner:** when activating a `TC_SYNC_POSITION` segment and `spindleSync` is not already set, `tpActivateSegment` records `waiting_for_index=tc->id`, sets the selected spindle's internal `spindle_index_enable=1`, resets spindle offset and returns `TP_ERR_WAITING`.
6. **HAL handshake:** `control.c` asserts the bidirectional `spindle.N.index-enable` HAL pin on the internal request's rising edge. It clears the internal request only after the HAL pin transitions from 1 to 0. The encoder/driver must participate in this handshake; wiring only the speed or revolutions feedback cannot substitute for the index acknowledgement.
7. **Resume:** `tpCheckAtSpeed` checks index enable on the *selected* spindle; while asserted it returns `TP_ERR_WAITING`. When cleared it sets `spindleSync=1`, clears `waiting_for_index`, sets `tc->sync_accel=1`, and zeros the planner's spindle revolution accumulator. This is a distinct gate from the earlier `waiting_for_atspeed` test, which checks at-speed across *all* configured spindles.

## HAL integration implications
`motion.c` declares `spindle.N.index-enable` as `HAL_IO` and `spindle.N.revs` as `HAL_IN`. A real configuration must connect the index-enable handshake to an encoder index-enable capable interface and provide valid revolution feedback. For Mesa/HostMot2, verify the actual exported encoder pin names from the loaded firmware/driver and inspect the complete INI/HAL inclusion chain; do not invent a specific hm2 pin or assume a generic encoder has an index channel. In a servo-thread schedule, the order of Mesa read, encoder processing, motion-controller and Mesa write affects when the handshake becomes visible. A wiring audit must also check direction, encoder scale, index polarity, noise, and loss-of-index behavior before machine use.

## Discriminating predictions (NOT RUN)
A. G33 with spindle turning according to interpreter but no index acknowledgement: queued synchronized feed remains waiting at the index gate. The exact runtime outcome and timeout policy require simulation.
B. An index-enable pulse that returns low should release the gate; verify the encoder resets position consistently on the intended physical index edge, not merely by forcing HAL low.
C. A spindle-at-speed signal held true with no index pulse cannot by itself release `waiting_for_index`.
D. For repeated G76 passes, check whether each newly activated synchronized pass requires index reacquisition; do not assume this from the single-segment trace without observing `spindleSync` reset.
E. A wrong spindle selection (`$`) should be rejected when out of range; verify actual multi-spindle behavior independently.

## Reproducible source-inspection exercise
```sh
git clone --filter=blob:none https://github.com/LinuxCNC/linuxcnc.git
cd linuxcnc && git checkout v2.9.10
git grep -n 'START_SPEED_FEED_SYNCH' -- src/emc/rs274ngc src/emc/task
git grep -n 'EMCMOT_SET_SPINDLESYNC\|tpSetSpindleSync' -- src/emc
git grep -n 'waiting_for_index\|spindle_index_enable' -- src/emc/tp src/emc/motion
git ls-tree v2.9.10 src/emc/tp/tp.c
```
Read-only inspection is safe; any executable fixture must use simulation/isolated self-hosted `[self-hosted, openpressbrake]` only, with no machine outputs, a bounded timeout, and predeclared pass/fail criteria.

## Evidence classification and dependencies
**SOURCE-CONFIRMED:** G33 canonical synchronization call, G76 per-pass synchronization, canonical queue message, motion command handler, TP index gate, HAL_IO edge handshake, distinct index and at-speed gates. **INFERRED/OPEN:** exact Task message forwarding; complete spindle revolution scaling/phase math; actual Mesa lathe wiring; behavior of a lost index in a running simulation; per-pass G76 index reacquisition. **TEST-CONFIRMED:** none newly obtained. This lesson neither graduates 3200 nor changes safety or blind-evaluation gates. Prior lab ledger was inspected; no new compute dispatched.

## Practical diagnostic order
Inspect interpreter spindle selection and K pitch → confirm canonical/Task sync command path → inspect `spindle.N.index-enable` and encoder index handling → check `spindle.N.revs` sign/scale and thread function order → distinguish `waiting_for_index` from `waiting_for_atspeed` → inspect a pinned real Mesa lathe HAL/INI chain → run bounded simulation before physical commissioning.
