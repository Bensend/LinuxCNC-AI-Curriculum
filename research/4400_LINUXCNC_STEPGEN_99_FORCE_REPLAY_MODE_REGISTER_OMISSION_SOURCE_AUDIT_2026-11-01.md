# STEPGEN-99 — HostMot2 forced replay does not explicitly restore stepgen mode registers
**4000 LinuxCNC implementation, NON-GRADUATED. 2026-11-01 UTC. Distinct continuation of STEPGEN-97/98 and WD-84.**

## Question
Does HostMot2's recovery-time **forced configuration replay** necessarily restore a step generator's selected `step_type`, index/probe latch flags and swap mode, or only timing and DDS configuration?

## Pinned source trace
- LinuxCNC stable v2.9.10 peeled commit [`86cdca76fa2a36274c432caa21952b23c267989a`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/stepgen.c), `stepgen.c` blob `8eb43d9a7d8e42573ef653cb82460609d2864ae4`; `hostmot2.c` blob `75619ae3f6925087a6693c5421bbf629f4459d94`; `watchdog.c` blob `73b1a34d2410295f8903118bf0cfd9e00d7166e6`.
- Development [`537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/stepgen.c), `stepgen.c` blob `4daaa54f3fb63b6af2dc2d83a31ebfbb7b47ca23`, `hostmot2.c` blob `f83e48fad84639eb1c095335ce908b4d408a4d38`, `watchdog.c` blob `e65129d4635f10078c0c74e06f7dbf48699cf4d6`.
- Relevant symbols/lines in development: `hm2_watchdog_write` lines 250–288; `hm2_force_write` `hostmot2.c` lines 1818–1830; `hm2_stepgen_force_write` `stepgen.c` lines 661–672; `hm2_stepgen_write` lines 505–565; `hm2_stepgen_update_mode` around lines 406–500. Stable has the same forced-mode omission near `stepgen.c` lines 641–650 and conditional normal writes near 485–545.

## Call flow and exact omission
1. `hm2_watchdog_write` enters recovery on `needs_reset || needs_soft_reset`, calls `hm2_force_write`, checks `io_error`, and then may clear reset bookkeeping. See predecessor [WD-84](4400_LINUXCNC_HM2_WD_84_SOFT_PACKET_RECOVERY_REPLAY_ACK_SOURCE_AUDIT_2026-10-31.md) for the **separate** transport acknowledgment gap.
2. `hm2_force_write` invokes `hm2_stepgen_force_write` along with other modules. **SOURCE-CONFIRMED.**
3. `hm2_stepgen_force_write` explicitly comments out `hm2_stepgen_force_write_mode(hm2)` and instead writes direction setup/hold, pulse width/space, master DDS, and DPLL timer. The mode-register replay is **not performed by this forced stepgen function** in either inspected revision. **SOURCE-CONFIRMED.**
4. The ordinary `hm2_stepgen_write` path writes `mode_addr` only when it detects a change in `step_type`, table hash, supported swap setting, index/probe enable or polarity compared to its host-side `written_*` state. A hardware-side register reset **without a host-side state change** does not itself satisfy that condition. **SOURCE-CONFIRMED conditional.**

## Scope and unresolved hardware semantics
This is **not proof** that a Mesa board loses mode state after every Ethernet timeout, that a watchdog bite resets its mode register, or that a machine produces incorrect steps. The FPGA watchdog's exact effect on the mode register, firmware revision, initial mode value and subsequent writes must be established separately. If hardware retains mode, the missing forced write may be harmless; if it loses mode and the host-side shadow remains unchanged, an ordinary unchanged-parameter cycle need not restore it. That distinction is the precise hypothesis.

A simple example to discriminate is `step_type=2` (quadrature output) or a firmware-supported index/probe latch mode. Do **not** test by moving physical motors. A disconnected LLIO mock that records writes to `mode_addr` can compare a normal mode change with a forced recovery and unchanged host shadow. Assert what was actually written, not just whether the recovery log says success. Qualify only `[self-hosted, openpressbrake]` before any executable lab.

## Relation to prior work
Unlike [WD-84](4400_LINUXCNC_HM2_WD_84_SOFT_PACKET_RECOVERY_REPLAY_ACK_SOURCE_AUDIT_2026-10-31.md), this concerns **which stepgen registers are in the replay set**, independent of packet delivery. Unlike [STEPGEN-97](4400_LINUXCNC_STEPGEN_97_MESA_POSITION_FEEDBACK_VS_PHYSICAL_AXIS_MR1_SOURCE_AUDIT_2026-11-01.md), it concerns output mode state, not feedback provenance.

**Evidence:** SOURCE-CONFIRMED omission and change-gated ordinary write in both pinned revisions; FPGA reset/installed behavior UNKNOWN; TEST-CONFIRMED none; no Actions, build, simulation, hardware or independent evaluator. Personnel-safety authority remains independent.
