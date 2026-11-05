# SPINDLE-237 — at-speed default and Task bridge evidence boundary (3100; NON-GRADUATED)

2026-11-05 UTC. Continuation of [SPINDLE-236](3100_LINUXCNC_SPINDLE_236_M3_NEXT_FEED_ATSPEED_GATE_2026-11-05.md).

## Verified baseline from pinned predecessor
SPINDLE-236 records LinuxCNC v2.9.10 immutable blobs: `interp_convert.cc` f01a359652d588d59c9e210fa441a99d2ee19598; `interp_queue.cc` dc6c35f0d5329b8f875365dbaee33fc663c16948; `emccanon.cc` 663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11; `command.c` 0b79061d39be915bbea548b2c33bb794d31ab302; `tp.c` 5768d6e6880569f72156ed9a761b5eee531c9fcf. This predecessor established a *conditional* pending-at-speed pipeline and TP gate; it did **not** establish the no-argument canonical default or the complete Task bridge.

## Attempted independent retrieval and limit
This session read START_HERE and the governing mission/level/work-selection/evaluation/compute documents, inspected the prior checkpoint, and attempted a pinned LinuxCNC source read via the GitHub connector. The external LinuxCNC repository returned NOT_FOUND; direct raw upstream fetch was unavailable. Consequently **the default argument and Task dispatch are still unverified**. Do not promote the conditional M3 behavior into an unconditional claim. This is an evidence-access block local to this question, not a course stop.

## Reproducible closure procedure (unexecuted)
At a LinuxCNC v2.9.10 checkout:
```sh
git grep -n -E 'START_SPINDLE_CLOCKWISE|START_SPINDLE_COUNTERCLOCKWISE|wait_for_atspeed' -- src/emc
git grep -n -E 'EMC_SPINDLE_ON|wait_for_spindle_at_speed|emcSpindleOn' -- src/emc/task src/emc/nml_intf src/emc/motion
git grep -n -E 'EMC_SPINDLE_OFF|atspeed_next_feed|EMC_TOOL_LOAD|EMC_TOOL_SET_NUMBER|EMC_SPINDLE_ORIENT' -- src/emc
```
1. Find the *declaration* visible to the no-argument queue call; record the exact default and overload resolution (do not infer from the implementation signature).
2. Trace Task's `EMC_SPINDLE_ON` case, fields and forwarding into `EMCMOT_SPINDLE_ON`. Distinguish queue order from execution order.
3. Follow M5 from interpreter through Task into motion and inspect whether pending `atspeed_next_feed` is reset, retained, or re-armed.
4. For M6 and M19, identify Task wait states, HAL pins, timeout/error behavior, and a complete real Mesa INI/HAL inclusion chain before teaching any automatic spindle-orient/tool-change guarantee.
5. Preserve exact version, commit SHA, file blob IDs, line ranges, and independent executable oracle when available.

## Minimal analytical prediction matrix (NOT tested)
| Sequence | Question to falsify |
| --- | --- |
| `M3 S1000; G0 X10; G1 X20 F100` | Does default spindle-on wait arm the *first feed*, not the traverse? |
| `M3 S1000; G1 X10 F100; G1 X20` | Is the pending flag consumed once? |
| `M3 S1000; M5; G1 X10 F100` | Does M5 cancel a pending wait? |
| `M3 S1000; M19; M6 T2` | What command/acknowledgement ordering is actually required? |

Do not run on a physical machine. An isolated simulation may be justified only after source closure, with a self-hosted `[self-hosted, openpressbrake]` runner; no GitHub-hosted runners.

## Evidence classification
**SOURCE-CONFIRMED (in predecessor):** conditional motion/TP at-speed flag pipeline. **UNVERIFIED:** canonical default, Task forwarding, M5 reset, M6/M19 orientation and acknowledgement. **TEST-CONFIRMED:** none in this session. No new compute or lab runtime. Independent personnel-safety authority, blind evaluation separation, and graduated gates unchanged.

## Next information-gain selection
Because upstream retrieval failed, rotate to an accessible machine-specific implementation source or resume this exact trace when the v2.9.10 source becomes accessible. Avoid another speculative spindle summary.
