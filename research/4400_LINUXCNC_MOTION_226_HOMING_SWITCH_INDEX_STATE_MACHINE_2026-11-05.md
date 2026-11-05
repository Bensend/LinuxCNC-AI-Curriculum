# MOTION-226 — LinuxCNC v2.9.10 homing switch/index state machine (4000, NON-GRADUATED)

## Question and evidence boundary
How does a joint progress from an untrusted coordinate to a switch- or encoder-index-referenced home, and what does HAL actually report? This is an **upstream source/config documentation inspection**, not a hardware or runtime test. Pinned tag: LinuxCNC **v2.9.10**. No build, simulator, Actions, or machine run was performed.

## Source provenance
- [homing.c at v2.9.10](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/homing.c): state enum around lines 70–103; exported HAL pins 228–255; decision tree 770–832; switch search 875–953; switch latch 1020–1110; index 1148–1248; final move 1250–1319.
- [homing.h at v2.9.10](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/homing.h): HOME_USE_INDEX=2, HOME_INDEX_NO_ENCODER_RESET=128; per-servo functions `read_homing_in_pins`, `do_homing`, `write_homing_out_pins`.
- [INI homing documentation at v2.9.10](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/ini-homing.adoc): search/latch sign conventions, HOME_OFFSET, HOME, index-enable HAL wiring, final move and sequencing.
These are tag-pinned references; commit SHA / blob SHA and real-machine configuration are not established in this lesson.

## Verified mechanism
The homing component exports `joint.N.home-sw-in` (HAL_IN), `joint.N.index-enable` (HAL_IO), `joint.N.homing`, `joint.N.homed` and `joint.N.home-state` (outputs). The state machine is not merely a timer or one home-switch edge. The code first distinguishes absolute encoder, no-search/no-latch immediate home, index-only, and switch-search branches. With a nonzero SEARCH_VEL and zero LATCH_VEL it rejects the configuration; with zero SEARCH_VEL, nonzero LATCH_VEL and no USE_INDEX it rejects it.

For switch search, `HOME_INITIAL_SEARCH_START` waits for prior motion to stop and a 0.100-second HOME_DELAY, backs off if the switch is already active, and starts a free joint move at SEARCH_VEL. `HOME_INITIAL_SEARCH_WAIT` stops that move when the switch is sampled active and enters `HOME_SET_COARSE_POSITION`. This first coordinate reset shifts `pos_cmd`, `pos_fb` and free trajectory position and adjusts `motor_offset`; it explicitly does **not** move the motor. The product SEARCH_VEL × LATCH_VEL selects the latch direction: positive => back off then rising-edge latch; negative => falling-edge latch while moving off the switch. This is not an unconditional second rising-edge search.

With USE_INDEX, after the latch edge, `HOME_INDEX_SEARCH_START` sets the joint's index-enable flag and transitions to `HOME_INDEX_SEARCH_WAIT`. The waiting state tests **whether index-enable has been cleared** by the encoder-side handshake, not a separate direct `index-pulse` HAL pin. It then disables free motion and enters `HOME_SET_INDEX_POSITION`. The ordinary branch sets motor offset using HOME_OFFSET and motor feedback; HOME_INDEX_NO_ENCODER_RESET selects a separate offset correction. Therefore an index-enable connection and encoder driver's behavior are part of the coordinate contract, not optional diagnostic wiring.

Finally `HOME_FINAL_MOVE_START` commands free trajectory to the configured HOME location at HOME_FINAL_VEL if positive (capped at joint limit), otherwise at the joint velocity limit. HOME and HOME_OFFSET are distinct. Negative HOME_SEQUENCE uses a synchronization readiness check before final moves. The final wait checks arrival and limit handling; source inspection does not prove how a particular physical switch or encoder behaves.

## Reproducible disconnected inspection
```sh
git clone --filter=blob:none https://github.com/LinuxCNC/linuxcnc.git
cd linuxcnc
git checkout v2.9.10
grep -nE 'HOME_INITIAL_SEARCH_WAIT|HOME_SET_COARSE_POSITION|HOME_RISE_SEARCH_WAIT|HOME_FALL_SEARCH_WAIT|HOME_INDEX_SEARCH_WAIT|HOME_FINAL_MOVE_START' src/emc/motion/homing.c
grep -nE 'home-sw-in|index-enable|home-state' src/emc/motion/homing.c
grep -nE 'HOME_USE_INDEX|HOME_INDEX_NO_ENCODER_RESET' src/emc/motion/homing.h
```
The commands are a **recipe**, not evidence that they were executed here. Inspect exact version before applying conclusions to another release.

## Practical review fixture (no motion)
For a joint with SEARCH_VEL=+10 and LATCH_VEL=-1, predict initial movement toward switch at positive speed, then latch on **release** while moving negative; if USE_INDEX=YES, the encoder clears index-enable after the subsequent index event. Contrast SEARCH_VEL=+10 and LATCH_VEL=+1: the latch search follows a backoff and approaches the switch in the positive direction. Predict failure for SEARCH_VEL=+10, LATCH_VEL=0, and for SEARCH_VEL=0, LATCH_VEL=-1, USE_INDEX=NO. These are source-grounded review oracles, not executed tests.

## Diagnostics and failure boundaries
1. Record `joint.N.home-state`, `joint.N.home-sw-in`, `joint.N.index-enable`, `joint.N.homing`, `joint.N.homed`, joint position feedback and following-error status together on a servo-cycle-aligned trace. Userspace polling alone cannot establish edge timing.
2. If waiting for index never finishes, distinguish an encoder that never clears index-enable from an upstream switch/search failure; inspect HAL net direction and encoder configuration. Do not infer a missing index pulse solely from the state bit.
3. If the switch is already asserted at search start, initial backoff is expected; if the switch polarity is wrong, state transitions can be misleading.
4. Never use software homed status as independent personnel-safety authority. Homing relies on actual feedback, wiring, limits and mechanics, none validated here.

## Evidence ledger
- SOURCE-CONFIRMED (v2.9.10): exported homing pins, branch validity checks, switch/latch sign routing, index-enable clear handshake, coordinate offset update and final move.
- DOCUMENTED (v2.9.10): INI meanings and expected encoder index-enable wiring.
- ANALYTICAL / UNEXECUTED: two sign-direction fixtures and invalid-configuration predictions.
- UNKNOWN: real encoder index-enable implementation, actual servo ordering of read/do/write in motmod, switch debounce/edge sampling effects, a real machine's homing HAL/INI wiring, and version differences.

## Next high-value work
Trace the motmod per-servo call order for `read_homing_in_pins` / `do_homing` / `write_homing_out_pins`, then inspect an actual upstream Mesa/encoder HAL configuration with index-enable and its INI. Establish whether the encoder clear becomes visible in the same or next servo cycle; do not guess from this file alone. Rotate to a machine-specific 3000 topic if no new evidence is available. Preserve existing graduation, blind evaluation and physical safety gates.
