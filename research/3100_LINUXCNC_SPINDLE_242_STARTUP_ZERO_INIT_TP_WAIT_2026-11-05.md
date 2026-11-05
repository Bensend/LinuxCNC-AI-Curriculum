# SPINDLE-242 — spindle pending-at-speed initialization and TP wait semantics (2026-11-05)

**Track:** 3100 mill spindle; 3200 lathe transfer. **Status:** SOURCE-CONFIRMED for pinned implementation; **INFERENCE** for end-to-end M3→M5→G1 outcome. NON-GRADUATED. No machine or executable test.

## Question and source provenance
SPINDLE-241 established that M5 and EMCMOT_ABORT do not directly clear `emcmotStatus->atspeed_next_feed`. Does startup or TP behavior invalidate a stale-wait hypothesis? Inspected LinuxCNC tag **v2.9.10**, specifically:
- [motion.c L825–850](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c#L825-L850) (predecessor recorded blob `febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841`).
- [command.c L493–531, L1016–1051, L1577–1659](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1577-L1659) (blob `0b79061d39be915bbea548b2c33bb794d31ab302`).
- [tp.c L2792–2828, L2890–2902](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L2792-L2828), read as tag-pinned raw text; **new immutable blob SHA not yet obtained**.

## Findings
1. **SOURCE-CONFIRMED startup:** motion.c L844 performs `memset(emcmotStruct, 0, sizeof(emcmot_struct_t))` before assigning `emcmotStatus = &emcmotStruct->status` (L848). Thus the status field begins zero at motion startup. This is **not** a reset between M3 and M5 in an already-running process.
2. **SOURCE-CONFIRMED TP entry:** tp.c L2890–2902 computes `needs_atspeed = tc->atspeed || (tc->synchronized == TC_SYNC_POSITION && !emcmotStatus->spindleSync)`. If true, it checks **every configured spindle** and returns `TP_ERR_WAITING` when any `at_speed` is false; it records the waiting segment id. This check has **no exception for commanded spindle speed zero**.
3. **SOURCE-CONFIRMED TP continuation:** tp.c L2819–2827 also loops over all spindles when an existing wait id is valid, returning `TP_ERR_WAITING` until all report at-speed. A mismatch of expected segment id clears the old wait with an error (L2810–2817); this is not an M5-specific cancellation.
4. **SOURCE-CONFIRMED flag propagation (SPINDLE-241):** M3 default requests pending=1, M5 does not directly reset it, and the next eligible feed passes the flag into the TP. The observed TP logic is consistent with a blocked first feed if the at-speed HAL input remains false.
5. **INFERENCE, not a reproduced bug:** an M3→M5→G1 program *can plausibly* enter a wait even though the spindle was commanded off. End-to-end Task ordering, interpreter lookahead, other state transitions, and at-speed HAL configuration still require execution. Some real HAL comparators may assert at-speed at zero, masking the wait; others may not. Neither behavior should be assumed universal.

## Minimal independent experiment (not executed)
Use an isolated LinuxCNC sim configuration with no physical outputs, and only a runner labeled **both** `self-hosted` and `openpressbrake` if compute is justified. Capture command order and `motion.spindle-at-speed` input with HAL sampling, TP/motion state, and position. Prepare four fixtures with identical homed machine, feed rate, positions and timeouts:
- A: `M3 S1000; M5; G1 X1 F100`, force spindle-at-speed FALSE.
- B: same as A, force TRUE.
- C: `M3 S1000; G1 X1 F100; M5`, force FALSE (control for initial spindle-on wait).
- D: `M5; G1 X1 F100`, force FALSE (control without pending M3).
Record whether the first G1 actually begins within a bounded interval; do **not** infer TP activation from command queue completion alone. Stop cleanly at timeout. Freeze the expected comparison **before** executing: A should wait and B should proceed *if* pending survives; D should proceed; C should wait. A non-waiting A falsifies the simple stale-pending model and requires examining Task sequencing, TP queue, and implicit resets.

## Reproducible source audit
```sh
git checkout v2.9.10
git grep -n 'atspeed_next_feed' -- src/emc
sed -n '825,850p' src/emc/motion/motion.c
sed -n '2792,2828p;2890,2902p' src/emc/tp/tp.c
git grep -n -E 'spindle-at-speed|atspeed_next_feed' -- tests configs
```

## Evidence and boundaries
**SOURCE-CONFIRMED:** startup zeroing; TP all-spindle gate without zero-speed exemption; TP wait-id continuation; earlier M5 no direct flag clear. **INFERENCE:** M3→M5→G1 could wait. **UNKNOWN:** actual program behavior, alternate resets in other files, effects of HAL spindle-ready generation and interpreter lookahead. No test, build, compute, Actions, or physical-machine operation. The prior historical compute ledger was inspected; no new authoritative runtime result was introduced. No graduation or safety-gate changes.

## Next checkpoint
Prioritize a real, complete Mesa ATC HAL/INI example demonstrating `iocontrol.0.tool-change`, `tool-changed`, spindle orient request/ack, and relevant servo ordering; compare actual wiring with iocontrol's documented handshake. If a credible source is unavailable, rotate to 3200 G33/G76 spindle index/phase implementation. Retain this bounded M3→M5 sim fixture for a justified future self-hosted test, rather than repeatedly speculating about it.
