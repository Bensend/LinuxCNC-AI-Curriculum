# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **S07 — restart/recovery/state integrity** are **GRADUATED** at 1000 level. Phase 8 is complete. **T01 — G-code interpreter architecture** is now the highest-priority unblocked module and is **RESEARCH** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

## S07 graduation checkpoint

S07-017 attempt 3, workflow `34162408769`, completed with lab exit code `0` and `S07-017 overall=PASS`. Runtime A began `joint.0.homed=FALSE`, established TRUE, and shut down through authenticated linuxcncrsh with `SHUTDOWN ACK`. The independent barrier then proved A launcher PID gone, TCP 5007 gone, and exact `halcmd getp joint.0.homed` lookup gone before B was started. Runtime B used a distinct launcher PID, initially exposed `homed=FALSE`, re-homed to TRUE, and the INI SHA-256 was unchanged across both runtimes.

Accepted reconciliation is in `experiments/S07-017-run-34162408769-accepted.md`; fresh-AI handoff and graduation audit are in `guides/S07-fresh-ai-handoff.md`.

Central graduated teaching: process identity, HAL lifetime, LinuxCNC homing state, persistent configuration, measurement provenance, physical position truth, actuator state, and independent safety state are distinct evidence domains. A successful software restart does not prove physical-machine recovery.

### S07 promotion queue

- Absolute-encoder driver/device-specific restart provenance: **2000 / HIGH**, non-blocking because the 1000-level architecture-specific revalidation rule remains valid under the counterfactual.
- Abnormal process death and backend-specific dangling-HAL cleanup: **2000 / MEDIUM**, non-blocking because orderly teardown was independently verified and S07 explicitly forbids PID-freshness => HAL-freshness inference.

Previously recorded S04–S06 promotion items remain active in their graduated handoffs.

## Current checkpoint / exact resume point

Begin **T01 — G-code interpreter architecture** from RESEARCH, continuing the required evidence chain rather than restarting prior architecture work.

1. Establish current documented interpreter responsibilities and interfaces, including RS274/NGC parsing/execution, canonical machining functions, modal state, remap/Python boundaries, and the Task/interpreter boundary.
2. Search community/developer material for interpreter architecture traps, especially read-ahead, execution versus parsing state, remap interactions, and error propagation; treat community statements as leads.
3. At pinned revision `8bf4605ae81042248add031e94c77300406e0413`, inventory `src/emc/rs274ngc/` entry points and trace at least one behaviorally significant path from Task invoking the interpreter through parsing/execution to canonical output. Reuse A01/A03 artifacts where valid but verify T01-specific claims.
4. Create the T01 function/symbol guide and end-to-end call-flow guide before freezing an experiment. The first experiment should independently verify a representative interpreter behavior and a representative failure/error path, with prediction recorded before execution.
5. Maintain the safety boundary: interpreter correctness is machine-control behavior, not evidence of a safety-rated function.
