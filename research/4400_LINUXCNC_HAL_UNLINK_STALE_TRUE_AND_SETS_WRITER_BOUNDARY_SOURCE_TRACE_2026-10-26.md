# 4400-HAL-MUTATION-01 — A disconnected HAL input can retain TRUE: pinned two-revision source trace

**Status:** SOURCE-CONFIRMED for exact LinuxCNC sources; design implications INFERENCE; no runtime/physical test, no selected-machine approval. **Date:** 2026-10-26. **Question:** If a normal-control HAL permissive is disconnected while TRUE, does the input automatically become FALSE? Can a writerless signal be manually set, and does a HAL configuration lock prove personnel safety?

## Revisions and independent documentation
- Stable **v2.9.10**: [hal_lib.c blob `0ed9b44`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/hal_lib.c), `hal_unlink` ~1263; `unlink_pin` ~3351–3407; `hal_link` ~1098–1260. [halcmd_commands.cc blob `1899082`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/utils/halcmd_commands.cc), `do_unlinkp_cmd` ~229–240, `do_setp_cmd` ~716–777, `do_sets_cmd` ~865–902.
- Development pinned commit **`062dc7c097693bb68e76192516cd92878dd5ecdf`**: [hal_lib.c blob `d5d8410`](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/hal/hal_lib.c), `hal_unlink` ~1525–1561 and `unlink_pin` ~3806–3853; [hal_lib_query.c blob `79d80d4`](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/hal/hal_lib_query.c), `hal_set_s` ~76–143, `hal_set_p` ~160–260; [halcmd_commands.cc blob `3524191`](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/hal/utils/halcmd_commands.cc), `do_unlinkp_cmd` ~180, `do_setp_cmd` ~669, `do_sets_cmd` ~748.
- [LinuxCNC stable HAL basics](https://www.linuxcnc.org/docs/stable/html/hal/basic-hal.html) and [2.9 halcmd manual](https://linuxcnc.org/docs/2.9/html/man/man1/halcmd.1.html) independently **DOC-CONFIRM** the intended `unlinkp`, `setp`, `sets` behavior; documentation is not the runtime oracle.

## End-to-end path, not just a symbol lookup
1. An ordinary HAL input is linked to a BIT/BOOL signal and receives TRUE from a writer. A HAL `unlinkp` request enters `do_unlinkp_cmd`, which calls `hal_unlink`.
2. `hal_unlink` checks that HAL is initialized, that `HAL_LOCK_CONFIG` does not block modification, locates the named pin, and calls `unlink_pin`. This is a configuration operation; it is **not** an E-stop or a safety function.
3. `unlink_pin` redirects the component's pin data pointer to its local dummy storage and **copies the current signal value into that dummy** for ordinary BIT/S32/U32/FLOAT (v2.9.10 ~3368–3384; development ~3820–3829). The special HAL_PORT path instead empties its port.
4. It decrements the original signal reader/writer/bidirectional count and clears `pin->signal`. Subsequent changes to the original signal no longer reach the unlinked pin; **the pin's initial post-unlink value is the last signal value, not a guaranteed safe FALSE**. A component may subsequently overwrite its own input/dummy or behave differently; this trace proves the HAL handoff behavior, not indefinite machine motion.
5. In v2.9.10 `do_setp_cmd` rejects a connected pin and a HAL_OUT pin; `do_sets_cmd` rejects a signal with an output writer (except HAL_PORT special case). The development `hal_set_p` and `hal_set_s` preserve the key restrictions. A **writerless** ordinary signal can be set using `sets`; this is not an independent safety channel.
6. `hal_link` enforces type and writer-count constraints, but linking an input to a writerless signal is allowed; it can copy the pin's dummy value into the signal in the no-writer/first-reader case. Reconnecting is not proof of a fresh, independently validated safety state.
7. **Optional interface only:** pinned [halrmt.cc](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/hal/utils/halrmt.cc) `setNet`, `setUnlock`, `setSetP`, `setSetS` handlers (~2048–2279) show an additional configuration surface **if the optional service is enabled**. We did not verify any listener, authentication, exposure, or installation on OpenPressBrake.

## Conditional counterexample (SOURCE-CONFIRMED semantics; NOT a runtime test)
`sensor.output=TRUE -> net permission -> ordinary_control.enable_input=TRUE`. A technician unlinks `ordinary_control.enable_input` while TRUE. The source copies TRUE into the pin's dummy, so the ordinary component may continue to see TRUE even after `sensor.output` changes to FALSE. This is a **normal-control stale-input risk**, not proof that a specific machine will move or that an actual safety channel is defeated. If the component has its own freshness/fault logic, examine it separately.

## Evidence and adversarial limits
| Proposition | Label | Evidence/limit |
|---|---|---|
| Unlink copies last scalar signal value to disconnected pin | **SOURCE-CONFIRMED** | Two pinned `unlink_pin` implementations |
| Connected input cannot be written by `setp`; writerless signal can be set by `sets` | **SOURCE-CONFIRMED; DOC-CONFIRMED** | Pinned `do_setp_cmd`, `do_sets_cmd`, development `hal_set_p/s`, HAL manuals |
| A HAL configuration lock rejects `hal_unlink` | **SOURCE-CONFIRMED** | `HAL_LOCK_CONFIG` branch in `hal_unlink` |
| HAL lock is tamper-proof, safety-rated or a physical isolation mechanism | **UNKNOWN / NOT ESTABLISHED** | No certification, independent final element or physical load witness; `halcmd` includes ordinary unlock command |
| Every HAL input stays TRUE forever after unlink | **NOT ESTABLISHED** | Component code can write/transform state; PORT behavior differs |
| OpenPressBrake uses this topology or has an enabled HAL remote service | **UNKNOWN** | No private as-built or runtime evidence |
| Physical Y1/Y2 stopping/holding, guard effectiveness, PL/SIL, safe restart | **UNKNOWN / NOT TEST-CONFIRMED** | Requires selected-machine qualified evidence |

## Safety architecture and human factors (INFERENCE)
- Never use ordinary HAL permissive, `halcmd` topology, LinuxCNC E-stop state, normal FPGA enable or `HAL_LOCK_CONFIG` as the **sole** personnel-safety authority. A separate qualified safety circuit must control the actual hazardous-energy final elements and gravity-load holding.
- For ordinary process controls, make disconnected/stale input conspicuous; verify signal **writer identity, current net topology, freshness and fallback** after commissioning/service changes. Consider explicit normal-control startup plausibility checks, not a claim of safety integrity.
- Provide a labeled, easy-to-recover service mode with a no-energy checklist and captive guards; eliminate incentives to force permissives high just to clear confusing faults.
- In a press brake, proving the HAL input low is **not** proving Y1/Y2 independently stopped/held or hydraulics isolated. In a lathe, it is not proving the spindle coasted down; in a plasma table, it is not proving arc/high voltage removed.
- Any test of these conditional paths is **simulation-only** until a separately approved, physically isolated machine-specific validation plan exists. No hazardous live fault injection authorized.

## Experiment decision and next question
Source plus official documentation adequately answer the precise software-semantic question; **no compute justified**. A bounded local-runner HAL-only test is appropriate **only** if an integration dispute later requires observing a particular component's behavior after unlink/relink. Freeze exact revision, signal/pin direction, initial state, expected observation and exit criteria first. The unresolved high-value question is whether selected OpenPressBrake normal-control diagnostics detect an unlinked/stale permissive, but this cannot be inferred without private as-built configuration. **G0/G1 HOLD; independent evaluator NOT RUN; no personnel-exposed operation.**
