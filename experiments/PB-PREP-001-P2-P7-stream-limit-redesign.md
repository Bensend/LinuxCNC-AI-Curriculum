# PB-PREP-001 P2–P7 atomic-stream limit redesign

Status: **FROZEN BEFORE INSPECTING RUN 067 RESULT**

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`

## Source-discovered harness constraint

During static implementation audit after launching job 067 but before reading its behavioral output, pinned LinuxCNC source was checked for the sampler element ceiling. `src/hal/hal.h` defines:

`#define HAL_STREAM_MAX_PINS (21)`

`sampler.c` allocates its realtime snapshot arrays at that bound. Therefore the 29-direct-element schema in job 067 cannot be a valid stock-sampler construction. This is an **ESSENTIAL NOW harness issue**, not evidence about architectures A/B/C.

Prediction recorded before inspecting 067 result: job 067 should fail during sampler/HAL construction or otherwise be `HARNESS INVALID`; no behavioral verdict may be taken from it.

## Revision-2 preservation rule

Behavioral constants, P2–P7 timing, architecture equations, plant equations, trajectory, U_MAX, DIFF_MAX, controller gains, Gate A–J criteria, and the rule that a missing B/P6 downstream-only saturation witness yields `INCONCLUSIVE` remain unchanged.

Revision 2 preserves a single stock `sampler` producer and all 29 **logical** witnesses but encodes them into exactly 21 physical HAL stream elements. The analyzer must decode the packed words before applying the previously frozen invariants.

## 21-element physical stream

The physical stream is:

1. `cycle` s32
2. `state_word` s32
3. `r1` float
4. `r2` float
5. `y1` float
6. `y2` float
7. `e_diff_used` float
8. `corr_req` float
9. `corr_applied` float
10. `pid1_ref` float
11. `pid2_ref` float
12. `pid1_out` float
13. `pid2_out` float
14. `prelimit1` float
15. `prelimit2` float
16. `final1` float
17. `final2` float
18. `joint1_ferror` float
19. `joint3_ferror` float
20. `disturbance_word` s32
21. `ferror_limit_word` s32

### `state_word`

- bits 0..7: phase value 2..7
- bit 8: run witness
- bit 9: stock PID1 saturated
- bit 10: stock PID2 saturated
- bit 11: final1 saturated
- bit 12: final2 saturated
- bit 13: `motion.motion-enabled`

The packing is performed in the fixture `finish()` function after stock PID calculations and final-limit calculation, so all bits describe the same producer cycle sampled immediately afterward.

### `disturbance_word`

Two unsigned 16-bit quantities:

- low 16: `plant_gain2 * 1000`
- high 16: `plant_alpha2 * 10000`

All frozen values are exactly representable by this scaling: gain 1.00/0.75/0.20 and alpha 0.05/0.025.

### `ferror_limit_word`

Two unsigned 16-bit quantities:

- low 16: `joint.1.f-error-lim * 1000`
- high 16: `joint.3.f-error-lim * 1000`

The frozen fixture's effective limits are far below the 32.767 representable upper bound. The decoder must reject overflow/out-of-range values rather than silently truncate them.

## Evidence rule

The packed representation is instrumentation only. The analyzer reconstructs the original logical fields before invariants/gates are evaluated. If packing, scaling, bit allocation, cycle continuity, producer overruns, or decoding is inconsistent, classify the run `HARNESS INVALID`.

No 067 behavioral output may be used to choose or tune this encoding; this redesign is frozen from pinned-source constraints alone.
