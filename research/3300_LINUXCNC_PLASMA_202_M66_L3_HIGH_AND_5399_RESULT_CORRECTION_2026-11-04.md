# PLASMA-202 — Correct M66 L3 semantics and trace #5399 to QtPlasmaC (non-graduated)

**Priority correction to PLASMA-201:** `M66 P3 L3 Q1` waits for **HIGH level**, NOT a rising edge. LinuxCNC M66 L1=RISE, L2=FALL, L3=HIGH, L4=LOW. The previous lesson incorrectly applied the L1 low-then-high Task behavior to the QtPlasmaC L3 program. Do not teach that a preexisting high level necessarily times out for L3. **SOURCE-CONFIRMED for stable 2.9.10**; no execution. This correction supersedes PLASMA-201's QtPlasmaC held-high conclusion, not its accurate L1 edge-state analysis.

## Pinned source and exact symbols
LinuxCNC 2.9.10 peeled commit `86cdca76fa2a36274c432caa21952b23c267989a`:
- [M66 reference](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/m-code.adoc): M66 modes and documented timeout `#5399=-1`; source blob `bd388ccd0da40c9a2df2910037ce34de1e47c820`.
- [emctaskmain.cc](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emctaskmain.cc), `EMC_TASK_EXEC_WAITING_FOR_DELAY` around lines 2742–2785: `WAIT_MODE_HIGH` accepts nonzero `synch_di[index]` immediately upon Task observation, clears `input_timeout`, and marks DONE; `WAIT_MODE_RISE` is a separate state requiring observed low followed by high.
- [interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) blob `f01a359652d588d59c9e210fa441a99d2ee19598`, `convert_m` M66 branch around 3350–3375 calls `WAIT(...,type,timeout)`, sets `input_flag/input_index/input_digital` when valid.
- [rs274ngc_pre.cc](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/rs274ngc_pre.cc) blob `479ae221bfec932dea4e6addd358f2da993d8ca2`, `read_inputs` around 1459–1471: after queue empties, writes `settings->parameters[5399] = GET_EXTERNAL_DIGITAL_INPUT(index,...)`, then clears `input_flag`.
- [emccanon.cc](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emccanon.cc) blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`, `GET_EXTERNAL_DIGITAL_INPUT` around 3081: invalid index or `task.input_timeout==1` returns -1, otherwise samples motion `synch_di[index]` as 0/1. `WAIT` around 3279 defines 1 rise, 2 fall, 3 high, 4 low.
- [interp_parameter_def.hh](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_parameter_def.hh) blob `ed08f802d6f93df004c50b160d4a54f219534700`, `M66_RESULT=5399` volatile.
- QtPlasmaC development `cdf957bd` [line.py](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd/lib/python/plasmac/line.py) around 282–285 emits `M190 P{matNumber}`, `M66 P3 L3 Q1`, then feed and torch start. No `#5399` check exists in this inspected producer sequence. Other producers and QtPlasmaC handler runtime are not established by this narrow inspection.

## Interpretation and failure boundary
**SOURCE-CONFIRMED:** An already-high digital input can satisfy L3 on its first sampled check. An L3 timeout is marked DONE rather than automatically EXEC_ERROR by the Task branch; later interpreter `read_inputs` obtains -1 via `GET_EXTERNAL_DIGITAL_INPUT` if `input_timeout==1`. Thus a subsequent program line may need to inspect `#5399` to distinguish successful HIGH from timeout. The observed upstream conversational snippet does not contain such a check. **INFERENCE, NOT TESTED:** without an independent handler/program abort, a failed material-change handshake may allow subsequent cutting instructions. Do not assert a physical torch actually fires.

**Important distinction:** `#5399` is populated when the interpreter consumes the queued result, not by Task directly writing an interpreter parameter. There is a queue-buster/read-back boundary. Avoid promising that an arbitrary same-block expression observes the completed wait.

## Disconnected verification exercise (NOT RUN)
Use an isolated LinuxCNC simulation and HAL-controlled `motion.digital-in-03` with no torch/physical outputs; only verified `[self-hosted, openpressbrake]` compute if allowed. Compare:
1. L3, input HIGH before wait: expect level success `#5399=1` (source prediction).
2. L3, LOW then HIGH before Q: expect success `#5399=1`.
3. L3, LOW throughout Q: expect `#5399=-1` after queue read-back.
4. L1, HIGH throughout Q: expect timeout unless low/high observed.
5. L1, sampled LOW then HIGH: expect success.
6. Consecutive waits after timeout: inspect stale status, compare historical M66-140 runtime first.
7. QtPlasmaC M190 material unavailable: inspect actual handler abort and interpreter progression before claiming torch-start behavior.
Capture exact binary, HAL trace, Task status, interpreter parameter, G-code progression, timestamps and source revision. These are **predictions, not test results**.

## Integration guidance and constraints
For an external CAM postprocessor, retain M190/M66 and machine-specific material contract, but investigate a validated post-wait timeout guard (e.g. a conditional abort using `#5399`) in a disconnected QtPlasmaC sim before deploying. A G-code timeout guard is **not** an independent personnel-safety authority. Preserve graduated course/evaluator gates and OpenPressBrake G0/G1 HOLD.

**Next:** Inspect development QtPlasmaC handler's explicit material-change failure/abort path, then trace G-code interpreter conditional `#5399` use and validate only if isolated self-hosted compute is proven. Do not repeat source-only M66 analysis without new evidence.
