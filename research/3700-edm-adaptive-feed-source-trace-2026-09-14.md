# 3700 — EDM adaptive-feed source trace

Date: 2026-09-14
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: SOURCE

## Question

What exactly does LinuxCNC's EDM-relevant adaptive-feed path own, especially when the requested scale crosses zero and becomes negative?

## Source path

Interpreter M52 state enables/disables the canonical adaptive-feed facility. The canonical API describes it as being used for EDM adaptive moves. Task/canonical code emits an `EMC_MOTION_ADAPTIVE` command after flushing pending canonical segments, so enable-state changes are not merely a direct HAL-pin sample hidden from task state.

Realtime Motion then applies the actual `motion.adaptive-feed` value when the move's queued enable mask includes `AF_ENABLED`.

## Realtime scale law

Pinned `motion/control.c` establishes:

1. normal feed/rapid scaling is calculated first;
2. when adaptive feed is enabled, Motion reads `motion.adaptive-feed` every realtime cycle;
3. it clips the requested value to `+-MAX_FEED_OVERRIDE` (`maxFeedScale`);
4. the magnitude used in the net feed scale is `abs(adaptive_feed)`;
5. sign is interpreted as requested TP run direction;
6. if the requested sign disagrees with the current TP run direction, Motion calls `tpSetRunDir()`;
7. if TP cannot change direction yet, adaptive output is forced to zero, causing deceleration/stop before reversal;
8. after direction matches, the positive magnitude is multiplied into the net feed scale;
9. feed-hold can subsequently force scale to zero when enabled;
10. feed-inhibit is a separate later zeroing authority (with the documented spindle-sync exception).

Therefore negative adaptive feed is **not** implemented by simply multiplying planned velocity by a negative number. Direction is an explicit trajectory-planner state transition with a stop-before-reverse boundary when necessary.

## EDM implications

This is stronger infrastructure than a simple analog feed override:

`gap controller -> motion.adaptive-feed sign/magnitude -> realtime clamp -> requested TP direction -> stop/reverse transition -> net feed scale -> queued path`

For wire/sinker EDM this can support:

- forward cutting while gap conditions are healthy;
- slowing toward zero as gap degrades;
- holding at zero;
- backing up along the already-planned trajectory with negative command.

But LinuxCNC does not derive that command from gap voltage itself. The process controller remains external/custom logic.

## Important boundaries

- M52/AF enable state and the realtime adaptive-feed value are different authorities.
- `motion.adaptive-feed=0` while AF is enabled means zero adaptive speed, not AF disabled.
- negative adaptive feed changes TP run direction; it is not evidence that spark power, wire, flushing or other process outputs are automatically reversed/recovered.
- path reversal does not itself define how synchronized M62/M63/M67 process-output events should be treated during reverse traversal. That remains a later source/lab question before an EDM production playbook can depend on queued I/O while reversing.
- adaptive feed composes with ordinary feed scaling and feed hold/inhibit; a gap controller must not assume sole authority over actual velocity.

## Field reconciliation

The Sodick retrofit chronology is consistent with this architecture: the builder sought to regulate gap using measured voltage and feed, while community suggestions included reverse/adaptive path behavior. A separately referenced wire-EDM retrofit reportedly used a simpler threshold-stop approach. Neither is a universal EDM law.

## Adversarial review

1. Does a negative HAL value instantly make velocity negative? **No; TP run direction is changed explicitly and may require a stop first.**
2. Can adaptive magnitude exceed the configured maximum feed scale? **No; it is clipped.**
3. Is AF applied when M52/adaptive enable is not active for the current move? **No.**
4. Does adaptive feed bypass feed hold/inhibit? **No; those remain separate downstream scaling authorities.**
5. Does LinuxCNC calculate gap control from voltage? **No.**
6. Does reverse path automatically define reverse-safe spark/wire/flushing outputs? **No.**
7. Is this generic primitive explicitly connected to EDM in upstream source comments? **Yes.**

Adversarial result: **7/7 bounded claims survive.**

## Next source target

Trace TP reverse-run behavior across segment boundaries and queued synchronized I/O, then inspect the later Sodick chronology/config evidence for the actual gap-voltage controller. Freeze a lab only if source cannot resolve whether queued process-output events are replayed, skipped, or otherwise transformed during an adaptive reverse traversal.
