# HM2-263 — Mesa encoder index request, hardware latch and acknowledgment (4000, 2026-11-06)

Status: SOURCE-CONFIRMED (LinuxCNC v2.9.10); not executed, not graduated. Priority: LinuxCNC implementation, not safety-course advancement.

## Scope and provenance
Upstream [encoder.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/encoder.c), pinned Git blob `9719d41419da9220761637e002024cdc9d17a8ba` from prior HM2-262 checkpoint; source lines cited below are from v2.9.10 raw file inspected 2026-11-06. [hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.c), particularly read path near line 108 and write path near line 165. Do not generalize to other releases or FPGA bitfiles without comparison.

## Implementation trace
1. The encoder HAL interface exports `hm2_*.encoder.NN.index-enable` as **HAL_IO**, not a passive status-only pin (encoder.c:565–566). Startup initializes it false (around 681).
2. On the HostMot2 **write** phase, `hm2_encoder_update_control_register()` reads the HAL index-enable request and sets `HM2_ENCODER_LATCH_ON_INDEX` and `HM2_ENCODER_INDEX_JUSTONCE` (50–83). `hm2_encoder_write()` compares control bits against previously written control state and forces a write on change (199–209). The command must actually reach the FPGA; a HAL bit alone is not proof of arming.
3. On the **read** phase, TRAM register data is processed by `hm2_encoder_process_tram_read()` (1097–1107). The per-instance rawcount routine first accumulates 16-bit counter differences into rawcounts (778–800). If the *previously commanded* control had LATCH_ON_INDEX and the read-back control bit is now clear, it interprets that as a hardware index event (808–813), extracts the 16-bit latched count from the high half of the control register (814–817), unwraps the count delta relative to the previous sample (818–820), sets `zero_offset = prev_rawcounts + delta` and **clears index-enable** (822–824). This is the request/acknowledgment handshake.
4. Position is calculated from the adjusted offset and configured scale (see 900–909). `index-enable` dropping is the HostMot2 acknowledgment, not an independent proof that a physical reference mark was correctly wired, nor a guarantee of absolute machine position.
5. An easily missed corner: even if the current encoder counter has not changed, the STOPPED branch explicitly processes the index request (933–949), and the MOVING/no-new-count branch does the same (1021–1026). Therefore, software is not *intentionally* waiting for a new quadrature count to process a completed index latch.
6. The read-control register also exposes A, B and index input state (129–155); `input-idx` reports input state, not equivalent to an armed-and-acknowledged index event. Index mask and polarity are separate HAL_RW parameters (639–647).

## Timing, failure and cross-subsystem boundaries
The usual servo sequence is HostMot2 read -> motion/homing -> HostMot2 write. Thus an index-enable request produced by homing in one cycle is normally written to FPGA afterward, and a later read cycle observes the latch completion. The exact motion homing code's consumer/producer semantics and SB1001 signal names remain to be traced: this source alone does **not** establish the entire homing sequence or spindle synchronized-motion behavior.

An Ethernet read skipped with -EAGAIN (HM2-262) also skips the encoder's TRAM processing that cycle. This can delay software acknowledgment of an FPGA event; it is not evidence the event did not occur. At persistent io_error, normal feedback is gated. A lost write may leave the HAL request asserted without the FPGA being armed. Avoid automatically clearing homing faults or declaring a position trusted after link recovery.

## Reproducible offline inspection
```sh
git clone --branch v2.9.10 --depth 1 https://github.com/LinuxCNC/linuxcnc.git
cd linuxcnc
grep -nE 'hm2_encoder_update_control_register|hm2_encoder_write\(|hm2_encoder_instance_update_rawcounts_and_handle_index|hm2_encoder_process_tram_read|index-enable' src/hal/drivers/mesa-hostmot2/encoder.c
sed -n '778,844p' src/hal/drivers/mesa-hostmot2/encoder.c
sed -n '919,950p' src/hal/drivers/mesa-hostmot2/encoder.c
sed -n '1015,1028p' src/hal/drivers/mesa-hostmot2/encoder.c
```
The v2.9.10 tag is an immutable intended revision for this exercise; pin its resolved commit before running tests. These commands are instructions, not executed results.

## Falsifiable worksheet (do not treat predicted results as measurements)
- **A:** request index-enable=1 with no index event: next write arms index latch; later read should not clear request until readback indicates latch completion.
- **B:** latch completes at counter value different from current count: zero offset must be computed using **latched count**, not current counter; after acknowledgment index-enable becomes 0.
- **C:** FPGA latch completes while no quadrature pulses arrive: stopped/no-count branches should still check latch completion.
- **D:** encoder input-idx toggles while request is 0: input state alone should not reset position offset through this handshake.
- **E:** Ethernet read is skipped: HAL acknowledgment may be delayed; do not infer an absent physical index.
For each, capture HAL index-enable, rawcounts, count, position, input-idx, index mask/polarity, transport io_error and servo-cycle ordering. An offline mocked TRAM fixture could inject readback words without any physical machine, but no fixture was executed here.

## Evidence ledger
| Claim | Class | Source | Limit |
|---|---|---|---|
| Index request maps to LATCH_ON_INDEX/JUSTONCE | SOURCE-CONFIRMED | encoder.c:50–83 | v2.9.10 |
| Hardware-cleared latch bit acknowledges and zeros offset at latched count | SOURCE-CONFIRMED | encoder.c:778–824 | FPGA implementation not separately inspected |
| No-count processing checks armed index | SOURCE-CONFIRMED | encoder.c:933–949,1021–1026 | runtime untested |
| Read/write phase can delay request/ack by servo cycle | INFERENCE | hostmot2.c:108,165 + encoder.c | exact homing thread order/config to verify |
| A lost Ethernet read delays HAL ack | INFERENCE | HM2-262 + encoder.c | fault-injection untested |
| Index pulse establishes trustworthy home | UNKNOWN / NOT CLAIMED | physical sensor and homing config not examined | machine-specific |

## Next dependency
Trace `src/emc/motion/homing.c` index-enable ownership and exact HAL signal hookup in the SB1001 7i76E example from LATHE-246/247; distinguish axis home index from spindle index and synchronized G33/G76 motion. Then test a pure-software TRAM latch fixture if an isolated environment offers meaningful evidence. Do not dispatch GitHub-hosted jobs. Personnel safety authority remains independent of LinuxCNC homing.
