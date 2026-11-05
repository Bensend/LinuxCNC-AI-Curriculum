# MOTION-228 — HostMot2 index latch and HAL clear (4000, NON-GRADUATED)

## Engineering question
What *actually* clears the bidirectional `joint.N.index-enable` after Mesa encoder index homing, and is the clear an FPGA write, a driver HAL write, or a motion-controller action? Extends [MOTION-227](4400_LINUXCNC_MOTION_227_HOMING_SERVO_MESA_INDEX_HANDSHAKE_2026-11-05.md), without repeating its motion-controller ordering.

## Immutable provenance
LinuxCNC **v2.9.10**, [HostMot2 encoder.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/encoder.c), Git blob `9719d41419da9220761637e002024cdc9d17a8ba`. Independently inspected full file, particularly lines 53–116, 199–311, 563–571, 766–840, 930–945, 1010–1030, 1098–1112. Prior pinned [homing controller source](4400_LINUXCNC_MOTION_227_HOMING_SERVO_MESA_INDEX_HANDSHAKE_2026-11-05.md) and Skyfire 7i76e example supply the other side of the HAL net. These findings are version-scoped.

## Verified mechanism
1. The encoder exports `encoder.%02d.index-enable` as **HAL_IO**, not a read-only status pin (around line 568). The HostMot2 encoder control-register construction reads that HAL pin and sets `HM2_ENCODER_LATCH_ON_INDEX` when enabled; it also sets `HM2_ENCODER_INDEX_JUSTONCE` when index or probe latch is requested (lines 53–85).
2. `hm2_encoder_write` recomputes desired control bits and compares them to prior control bits; changed controls cause `hm2_encoder_force_write`, which writes the latch/control register through `llio->write` and updates `prev_control` (lines 199–311). **Important:** arming the HAL pin and programming the FPGA register are separate operations.
3. After TRAM data is read, `hm2_encoder_instance_update_rawcounts_and_handle_index` checks whether the **previously written control** had `HM2_ENCODER_LATCH_ON_INDEX` set, then examines the returned latch/control register. If that bit has become zero, the driver interprets this as an index event, reconstructs the latched count/zero offset, and explicitly writes `*e->hal.pin.index_enable = 0` (lines 811–829). Thus **the LinuxCNC HostMot2 driver clears the HAL handshake pin upon detecting the FPGA's cleared latch-on-index bit**. It is not solely an asynchronous FPGA mutation of HAL memory.
4. The encoder TRAM processing path calls `hm2_encoder_read_control_register` and then each instance's `hm2_encoder_instance_process_tram_read` (lines 1098–1112). Even when ordinary counts do not change, the process path contains a special case to process index/probe latch requests (around lines 1019–1027). This avoids mistaking an unchanged position count for proof that the index event was ignored.
5. Following the pin clear, the next encoder write can remove index-latch request bits from its desired control word. The prior MOTION-227 control read then observes the HAL pin's cleared value and can advance the homing state. **Do not assign a fixed number of servo cycles** without inspecting the exact Ethernet transport and machine thread scheduling.

## Practical causal timeline (INFERENCE, not a hardware trace)
| Phase | HAL / driver / FPGA | Consequence |
|---|---|---|
| Motion homing enters INDEX_SEARCH_START | Motion sets HAL index-enable = 1 | Request exists in shared HAL memory |
| HostMot2 encoder write | Driver sets latch-on-index / just-once control bits and issues register write | FPGA is requested to latch an index event |
| FPGA detects qualified index | Returned latch/control image no longer has latch-on-index bit set | Hardware event indication is available for a later read |
| HostMot2 TRAM read processing | Driver sees previously armed control and cleared returned bit; updates zero offset and sets HAL index-enable = 0 | Shared bidirectional signal acknowledges capture |
| Motion-controller samples homing input | Copies zero to private homing state | HOME_INDEX_SEARCH_WAIT can progress |

This timeline is conditional on correct FPGA firmware, index polarity/mask, valid I/O transactions and thread order. A physical index input changing does not itself prove qualified latch capture.

## Disconnected reproduction and diagnostic exercise — NOT RUN
```sh
git clone https://github.com/LinuxCNC/linuxcnc.git
cd linuxcnc && git checkout v2.9.10
grep -nE 'hm2_encoder_update_control_register|hm2_encoder_force_write|LATCH_ON_INDEX|index_enable = 0|hm2_encoder_process_tram_read' src/hal/drivers/mesa-hostmot2/encoder.c
```
For an existing **disconnected** Mesa HAL configuration, review `halcmd show thread`, `halcmd show pin *index-enable*`, `halcmd show pin *input-index*`, and encoder `index-invert`, `index-mask`, `index-mask-invert` parameters. Record actual pin names from `halcmd` rather than assuming the generic names map to a particular card. Do not force or toggle a linked HAL_IO pin on a moving machine.

### Distinguishing failure cases
- Index-enable remains 1, rawcounts change: the encoder may be moving but a qualified index latch was not observed; check mask/polarity, HAL thread order, and hardware I/O health.
- Index-enable clears but homing waits: inspect sampling phase, joint net identity, and whether motion is in the expected free/homing state; userspace snapshots can cross function phases.
- Index input is visibly active but index-enable never clears: `input-index` is an instantaneous input observation, **not** the latch completion handshake.
- HostMot2 read fails or is stale: driver-visible latch/control image may be invalid or old. This investigation does not establish how `hm2_eth` reports failures to motion; do not equate a stuck HAL pin with missing physical index.

## Evidence ledger and dependency
**SOURCE-CONFIRMED:** HAL_IO export, index arm bits, control-register write-on-change, readback-bit test, explicit driver HAL clear, unchanged-count index handling. **INFERENCE:** phase timeline and troubleshooting hypotheses. **TEST-CONFIRMED:** none. **UNKNOWN:** firmware internal edge/filter implementation, version-specific Ethernet packet acknowledgement, failed-read behavior, measured capture/ack latency, physical switch/index accuracy. The earlier EtherCAT stale-buffer question remains separate and unresolved.

## Next checkpoint
High-value remaining HostMot2 question: trace `hm2_eth.c` read transaction success/failure and TRAM buffer update boundaries; distinguish FPGA event latch from host delivery. If source investigation stalls, rotate to 3100 mill probing or 4000 tool-change source/config study. Preserve existing graduated levels, independent safety authority, blind evaluation separation and physical-machine HOLD. No hosted Actions; compute only on justified self-hosted [self-hosted, openpressbrake].
