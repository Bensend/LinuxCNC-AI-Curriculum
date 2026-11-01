# 4000-LC-OVERRIDE-96 — M52 adaptive-feed clamp and reverse-direction handshake differ across LinuxCNC versions

**2026-11-01 | LinuxCNC-first distinct trajectory-planner continuation | NON-GRADUATED | NO RUNTIME TEST.** This examines the adaptive-feed input/trajectory planner, not the M51 mask interaction in [OVERRIDE-93/94/95](4400_LINUXCNC_OVERRIDE_93_FEED_INHIBIT_SS_BIT_COUPLING_SOURCE_AUDIT_2026-11-01.md).

## Source provenance and question

For a plasma or wire-EDM controller using `M52 P1` and `motion.adaptive-feed`, what happens when a HAL producer requests a factor above 1.0, or changes its sign while moving?

- **Stable v2.9.10:** [`control.c` lines 380–407](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c#L380-L407), blob `b6e45d590c7d11030654d8f7d13d118f581b6439`, clamps the HAL input to **[-1.0, +1.0]** before applying `fabs` as the scale. A requested factor 1.2 is therefore reduced to 1.0, irrespective of the configured user-interface maximum feed override.
- **Development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`:** [`control.c` lines 452–479](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/control.c#L452-L479), blob `7c9a35c237ba05326372294587c33d53aff1a6a9`, instead clamps to **[-`emcmotConfig->maxFeedScale`, +`maxFeedScale`]**. [`command.c` lines 2098–2102](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/command.c#L2098-L2102) updates that configuration field through `EMCMOT_SET_MAX_FEED_OVERRIDE`. [INI documentation lines 327–331](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/config/ini-config.adoc#L327-L331) describes `[DISPLAY]MAX_FEED_OVERRIDE`, e.g. 1.2.
- **M52 gating:** [Stable `motion.h` lines 423–426](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.h#L423-L426) defines `AF_ENABLED=0x04`; [development `command.c` lines 1430–1438](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/command.c#L1430-L1438) sets/clears it. [Development M-code docs lines 380–399](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/gcode/m-code.adoc#L380-L399) explicitly say the adaptive range follows `MAX_FEED_OVERRIDE` and warn that reverse-run is not extensively tested. Stable [M-code docs lines 305–323](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gcode/m-code.adoc#L305-L323) instead describe -1 to 1.
- **Reverse handshake:** Both versions' `control.c` use the sign of adaptive feed to call `tpSetRunDir` when the current direction disagrees. [Stable `tp.c` lines 3631–3647](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L3631-L3647), blob `5768d6e6880569f72156ed9a761b5eee531c9fcf`, and [development `tp.c` lines 4531–4547](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/tp.c#L4531-L4547), blob `2b4024c9ab131f708cc22760300231878c9b0fdc`, **reject direction change while `tpIsMoving`**. In that case, `control.c` sets `adaptive_feed_out=0` for the cycle to request deceleration, then retries later. This is not an instantaneous reverse.
- **Actual machine integration:** [Stable QtPlasmaC HAL lines 37–40](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/qtplasmac_comp.hal#L37-L40) connects `plasmac.adaptive-feed` to `motion.adaptive-feed` and `plasmac.feed-hold` to `motion.feed-hold`. This confirms a real upstream configuration consumer, not an observed running plasma table.

## Predicted discriminators — source arithmetic only, NOT RUN

Assume `M52 P1`, no feed-hold/inhibit, feed override 1.0, configured development `MAX_FEED_OVERRIDE=1.2`, and a valid queued G1.

| HAL adaptive-feed | Stable v2.9.10 factor | Development factor | Additional condition |
|---:|---:|---:|---|
| +0.5 | 0.5 | 0.5 | normal forward direction |
| +1.2 | **1.0** | **1.2** | development config actually loaded |
| +2.0 | **1.0** | **1.2** | both clamp |
| 0.0 | 0.0 | 0.0 | deceleration/hold, not an independent stop |
| -0.5 | 0.5 after direction accepted | 0.5 after direction accepted | if moving forward, first request returns FAIL and factor becomes 0 until stopped; then reverse can be selected |

`net_feed_scale` is also multiplied by the normal feed override when enabled; the table deliberately isolates the adaptive term. Reversal cannot be assumed to preserve all prior motion segments, synchronized trajectories, or external process outputs. [Stable `tp.c` lines 2859–2865](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L2859-L2865) rejects activating a synchronized or rigid-tap segment in reverse. Development [lines 3518–3524](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/tp.c#L3518-L3524) retains this restriction.

## Minimal reproducible exercise (software-only)

On an independently verified `[self-hosted, openpressbrake]` isolated runner, create a **disconnected QtPlasmaC-style or plain motion simulator** with `[DISPLAY]MAX_FEED_OVERRIDE=1.2`. In a tiny bounded `G21 G90 G94 F60 G1 X1` program, enable `M52 P1`; drive the adaptive HAL input through +0.5, +1.2, +2.0, 0, -0.5, then +0.5. Capture the **loaded** maxFeedScale, `AF_ENABLED` mask, effective feed scale, planner direction, commanded position and timestamped velocity. Repeat stable and development with identical INI/HAL, never a physical machine. Treat transitions as separate cases, not a single end-state comparison. Do not infer physical reverse or safe stop from a planner direction flag.

**Evidence:** SOURCE-CONFIRMED stable/development clamp and planner handshake; DOC-CONFIRMED config/M52 semantics; INFERENCE specific scale/trajectory behavior under stated inputs; TEST-CONFIRMED none. This is a distinct version-sensitive implementation question, not a new safety function, and not an automatic request to build a plasma controller.
