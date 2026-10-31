# 2026-10-31T05:40:07Z — LinuxCNC-first absolute-encoder and bounded-homing checkpoint

**Active:** 4000 NON-GRADUATED. Prior spindle G33/G33.1 source branch reached information-gain stop; rotated to LinuxCNC homing after checking START_HERE, governance, progress, source policy, evaluation ledger, compute ledger and previous spindle checkpoint.

## New durable artifacts

- [HOMING-24 absolute encoder rehome](../research/4400_LINUXCNC_HOMING_24_ABSOLUTE_ENCODER_REHOME_OFFSET_REGRESSION_SOURCE_TEST_AUDIT_2026-10-31.md): v2.9.10 accumulates absolute HOME_OFFSET on a re-entered homing path; development adds motor-offset normalization (upstream fix 0d3e4ad, 2026-09-13). Upstream regression `tests/home-absolute-encoder` covers fixed feedback, stale POSITION_FILE, repeated individual home/unhome and feedback changes. **Source-confirmed; upstream test inspected, not run.** A distinct Home All `-1` path clears H[0].homed and is absent from that regression's test calls.
- [HOMING-25 bounded failure](../research/4400_LINUXCNC_HOMING_25_BOUNDED_SEARCH_RETURN_GANTRY_ABORT_SOURCE_TEST_AUDIT_2026-10-31.md): development adds HOME_SEARCH_DIST/HOME_LATCH_DIST, differentiated search-stop versus latch/index-return, synchronized negative-sequence return, and fixed array indexing in abort. `tests/home-dist` inspects dead/stuck/intermittent switches and gantry pair. **Development-only, upstream tests inspected not run; v2.9.10 lacks bounds.**
- [HOMING-26 index IO timing](../research/4400_LINUXCNC_HOMING_26_INDEX_ENABLE_HAL_IO_HOSTMOT2_ORDER_SOURCE_AUDIT_2026-10-31.md): motion reads index-enable at servo start, arms the IO flag during homing, and HostMot2 clears it when its FPGA index latch reports an event. Development writes the IO pin on internal edges; stable v2.9.10 rewrites every servo. HostMot2 `no-clear-on-index` and LinuxCNC `HOME_INDEX_NO_ENCODER_RESET` must describe the same encoder reset behavior. **SOURCE-CONFIRMED, timing/physical outcome UNKNOWN.**\n- [Practical acceptance guide](../guides/4000-linuxcnc-absolute-and-bounded-homing-acceptance-2026-10-31.md) with version matrix and isolated simulation discriminators.

## Precise next unblocked work

1. Source trace `base_do_home_joint(-1)` → `do_homing_sequence` → `HOME_START` and Task command path for Home All; determine whether upstream test `home(0)` misses a meaningful rehome coverage gap. If isolated compute is justified and independently verified, adapt the upstream fixture for `home(-1)`, record exact branch and outputs; **never use GitHub-hosted Actions**.
2. HOMING-26 has now traced the index-enable IO/HostMot2 source path. Next inspect a real pinned Mesa INI/HAL with `HOME_USE_INDEX`, compare `no-clear-on-index` against `HOME_INDEX_NO_ENCODER_RESET`, and check exact addf order; only if a genuinely new question remains. Otherwise rotate to trajectory planning or tool-change implementation.
3. Do not claim a stable 2.9 backport from development issue closure; verify exact installed source. No reopening graduated levels or routine safety-course advancement.

## Evidence / gates

**SOURCE-CONFIRMED** pinned LinuxCNC v2.9.10/development code and upstream test source; **COMMUNITY-REPORTED** issue #3717 and #4572 observations; **UPSTREAM-TEST-DEFINED** fixtures; **TEST-CONFIRMED here none**. No workflow, simulation, build, physical motion, blind evaluator or authoritative job runtime; GitHub-hosted/self-hosted Actions 0/0 min; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Runner access and isolation UNKNOWN. 1000/2000/F02/3000 CLOSED, G0/G1 HOLD, independent evaluator OPEN. Recurring hourly task remains enabled. Actual session end and overlap recorded in LESSON_LOG.md.
