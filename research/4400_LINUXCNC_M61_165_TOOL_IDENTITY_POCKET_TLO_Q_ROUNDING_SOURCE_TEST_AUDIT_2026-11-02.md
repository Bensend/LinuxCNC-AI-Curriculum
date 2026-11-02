# 4000-LC-M61-165 — Tool identity, pocket provenance, G43 state and fractional Q validation (2026-11-02)

**Status:** LinuxCNC-first 4000 source audit, NON-GRADUATED. Transfer: 3100 mill/toolsetter, 3200 lathe/turret, 3400 router/ATC and 3600 tooling identity. **SOURCE/DOC-CONFIRMED** at pinned revisions; upstream executable *test source inspected* but **not executed this session**. Arithmetic is **INFERENCE**, not a LinuxCNC runtime observation. No physical machine, compiler, evaluator or Actions.

## Question and predecessor audit

After a controller restart with a tool already physically installed, does `M61 Qn` mean a tool-change handshake occurred, that the last tool-change pocket changed, or that the active G43 tool-length compensation follows the newly reported tool? Does `M61 Q-0.4` fail the documented nonnegative-Q check, and does `M61 Q1.6` fail as a noninteger tool ID?

Prior curriculum [M6/tool-retention](4400_LINUXCNC_PINNED_M6_IOCONTROL_TOOL_CHANGED_ACK_VS_PHYSICAL_RETENTION_SOURCE_TRACE_2026-10-25.md), [TOOL-71](4400_LINUXCNC_TOOL_71_RELOAD_RESET_ERROR_PROPAGATION_SOURCE_AUDIT_2026-10-31.md), [TOOLDB-72](4400_LINUXCNC_TOOLDB_72_DB_REFRESH_NAK_NOTIFICATION_SOURCE_AUDIT_2026-10-31.md), [TOOLIO-73](4400_LINUXCNC_TOOLIO_73_SAVE_DURABILITY_G10_OFFSET_SOURCE_AUDIT_2026-10-31.md), and the prior lesson-log M61 mention already establish **M61 is not a physical change and does not normally update G43**. The *new* evidence here is the exact stock **upstream executable M61 test**, its simultaneous identity/pocket/coordinate assertions, the **fractional/negative-Q validation ordering**, and the **RETAIN_G43 configuration-dependent exception**. Full PROGRESS/LESSON/LAB and research-filename predecessor scan performed; no claim that the basic M61 concept was unworked.

## Immutable source and test provenance

- Stable [LinuxCNC v2.9.10 peeled commit `86cdca76fa2a36274c432caa21952b23c267989a`](https://github.com/LinuxCNC/linuxcnc/tree/86cdca76fa2a36274c432caa21952b23c267989a), annotated tag dated 2026-07-02; development [`67437d8865e431a9a33f74cee912dbf891d3b4c5`](https://github.com/LinuxCNC/linuxcnc/tree/67437d8865e431a9a33f74cee912dbf891d3b4c5), commit date 2026-11-01. Date first audited here: 2026-11-02; neither upstream revision is represented as published today.
- Stable [`interp_convert.cc` lines 3416–3434 and 5688–5725](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) blob `f01a3596`; [`interp_internal.hh` lines 49–52](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_internal.hh); [`interp_check.cc` Q allowance](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_check.cc) blob `ee5164c8`.
- [`emccanon.cc` lines 2148–2156](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emccanon.cc) blob `663e9b7e`; [`emctaskmain.cc` lines 864–869, 1556–1563, 2097–2100](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emctaskmain.cc) blob `7292a172`; [`taskclass.cc` lines 748–756](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/taskclass.cc).
- [`ioControl.cc` lines 541–596, 635–658, 1032–1056](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/iotask/ioControl.cc) blob `09cbd6ff`; [`ioControl_v2.cc` lines 494–548, 1185–1209](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/iotask/ioControl_v2.cc) blob `9f09844a`.
- Official [M61 and M6 docs](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/m-code.adoc), [tool-compensation/pocket docs](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/tool-compensation.adoc), [RETAIN_G43 INI docs](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/config/ini-config.adoc).
- Independent **upstream test fixture, not this session's runtime**: [`tests/toolchanger/m61/test-ui.py`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/toolchanger/m61/test-ui.py) blob `ca29beb5`, [`m61-test.ini`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/toolchanger/m61/m61-test.ini) blob `163485f1`, [`test.sh`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/toolchanger/m61/test.sh) blob `5d77bede`, and [`simpockets.tbl.original`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/toolchanger/simpockets.tbl.original) blob `4b427daa`. The fixture sets `[EMCIO]RANDOM_TOOLCHANGER=0`, inch units, and does not enable RETAIN_G43.

## Actual execution chain and three different truths

1. `M61 Q10` reaches interpreter `Interp::convert_m` group 6. It rounds the Q word, looks up the tooldata **index** using `find_tool_index`, sets `current_pocket` and `toolchange_flag`, emits `CHANGE_TOOL_NUMBER(index)`, and refreshes `#5400...` tool parameters. The canonical message is `EMC_TOOL_SET_NUMBER`, **not** `EMC_TOOL_LOAD` or an M6 `START_CHANGE`.
2. Task queues `EMC_TOOL_SET_NUMBER`, schedules interpreter synchronization, and waits for IO (not the M6 motion+IO precondition). `emcTaskIssueCommand` calls `emcToolSetNumber`; `Task::emcToolSetNumber` sends the IO command. An MDI completion means the command path finished, **not** that a tool was physically installed or clamped.
3. In stable stock `ioControl.cc`, `EMC_TOOL_SET_NUMBER` calls `load_tool(idx)` to copy the selected tooldata into spindle index 0 for a nonrandom changer, updates `emcioStatus.tool.toolInSpindle` and `iocontrol.0.tool-number`. For a **nonzero** new tool it does **not** rewrite `iocontrol.0.tool-from-pocket`; for Q0 it resets that pocket provenance to zero. The normal M6 handshake separately updates `tool-from-pocket` from the actually prepared pocket. `ioControl_v2.cc` has the analogous tool-number/load_tool path, but the stock v2 pin surface differs; do not assume the same pocket HAL pin exists there.
4. `load_tool(idx)` is **bookkeeping**, not actuator motion. On a nonrandom changer it copies a tool entry into spindle index 0 and may issue `SPINDLE_LOAD` to DB_PROGRAM. On a random changer it swaps spindle/pocket tooldata and notifies DB_PROGRAM, despite M61 issuing no physical changer handshake. External database notification is not a verified physical or durable acknowledgment (see TOOLDB-72).
5. **Tool data versus applied TLO:** the interpreter updates `#5403` (new tool's table Z length) while the *currently applied* G43 offset remains the old one with default `[RS274NGC]RETAIN_G43=0`. Explicit `G43` applies the current tool length. `G43 Hn` may instead select a different tool's offset by design; do not equate tool number and offset solely from GUI labels.

## Concrete upstream executable oracle (read, not run)

The upstream `m61/test-ui.py` first executes `T1 M6` using a simulated `tool-prepared/tool-changed` handshake and applies `G43`. Its tool table gives T1 Z+1 inch and T10 Z+3 inches. The subsequent `M61 Q10` expects **all** of these together:

| Observable | Upstream test's expected value immediately after M61 Q10 |
|---|---|
| `iocontrol.0.tool-number`, `linuxcnc.stat().tool_in_spindle`, `#5400` | **10** |
| `iocontrol.0.tool-change` and `tool-prepare` | **0**; no M6 handshake |
| `iocontrol.0.tool-from-pocket` | **1**, unchanged from prior T1 M6, **not T10's P3** |
| `#5403` (current tool table Z) | **3** inches |
| `#5422` (current Z in fixture, after prior G43 T1) | **-1** inch, not -3 |
| `#5422` after a separate `G43` | **-3** inches |

The test then checks `T0 M6`, `M61 Q1`, and `M61 Q0` tool-number transitions. These are **expected assertions in upstream test source**, not evidence that we executed the test or that all revisions pass. The distinction is high-value for toolsetter/ATC screens: **reported identity, pocket-of-last-physical-change, tool-table metadata, applied offset, and physical tool** are five separate facts.

## Additional Q-word validation finding (165B)

Stable `interp_check.cc` allows a Q word on M61 but does not require it to be integral/nonnegative there. `round_to_int` calls `std::nearbyint`; the builtin M61 branch then checks **the rounded integer** for negativity. Under ordinary nearest-integer rounding, `M61 Q-0.4` becomes 0 and passes the negative check, **contrary to the documented error for negative Q**. Likewise `M61 Q1.6` becomes tool number 2 rather than failing as a noninteger; it can succeed if T2 exists. `M61 Q-0.6` becomes -1 and is rejected. These are **SOURCE-CONFIRMED validation order plus arithmetic INFERENCE**, not observed interpreter output; floating-point rounding mode and parser/runtime still require an isolated test. `Q-1` collides with the absent-Q sentinel and rejects, so it is not a good discriminator.

A [review-only stable patch candidate](../examples/4000_m61_165/stable_2910_m61_q_validation_review.patch) checks negative **before** rounding and rejects Q more than 0.0001 away from an integer. It is **NOT APPLIED, NOT COMPILED, NOT RUN**; the 0.0001 near-integer tolerance is a candidate engineering choice, not a documented M61 requirement. Development `interp_convert.cc` at pinned commit `67437d8` lines 4191–4209 retains the same round-before-sign-check path, so the issue is not assumed stable-only.

## RETAIN_G43 version/configuration exception (165C)

The ordinary M61 docs warn that TLO is not changed and to issue G43. That is correct for the upstream test's default configuration, **not a universal statement for all configurations**. Stable [`rs274ngc_pre.cc` lines 886–889](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/rs274ngc_pre.cc) defaults `RETAIN_G43` **off**. With the option enabled, stable `convert_m` lines 3445–3458 can reapply G43 when G43 is active and `selected_pocket > 0`, otherwise calls G49. `convert_tool_length_offset` uses `current_pocket` while `toolchange_flag` is set. Development `67437d8` lines 4220–4235 also handles G43.4. Whether an M61 after a particular T/M6 sequence reapplies an offset depends on active G43, selected pocket and configuration. **No RETAIN_G43 M61 runtime case was run or located in the upstream fixture.** Do not silently transfer the default -1-inch expectation to an opt-in configuration.

## Frozen disconnected verification matrix

The [commissioning guide](../guides/3100-3200-3400-4000-linuxcnc-m61-tool-identity-and-tlo-commissioning-2026-11-02.md) freezes A–J with exact captures. Most efficient first check is the **existing upstream m61 test**, not a newly manufactured parallel harness. Proposed **new** cases: Q-0.4, Q1.6 with an existing T2, Q-0.6 negative control, M61 Q0 pocket reset, RETAIN_G43=1 active-G43 and inactive-G43 branches, random changer database side effects. All are **NOT RUN**. Physically disconnected simulator only, never live turret/toolchanger or OpenPressBrake.

## Evidence ledger / engineering boundary

| Finding | Evidence | Remaining limit |
|---|---|---|
| M61 identity change is not M6 tool movement | stable+dev interpreter/canonical/Task/IO SOURCE | no installed-tool witness |
| M61 nonzero leaves stock IO `tool-from-pocket` unchanged | stable IO SOURCE + upstream test EXPECTATION | upstream test not executed here; v2 HAL surface differs |
| New `#5403` can coexist with old applied G43 | SOURCE + upstream test EXPECTATION | runtime not run; RETAIN_G43 may alter |
| Negative fractional Q can round to accepted zero | stable+dev SOURCE + arithmetic INFERENCE | exact interpreter runtime not tested |
| Tool DB `l/u` notification can accompany M61 without physical move | IO SOURCE + DB docs | DB durable state/ACK not proven |
| Installed tool/clamp, actual tool length, physical axis clearance | UNKNOWN | qualified independent physical verification required |

No LAB_COMPUTE_LOG row (zero new authoritative runtime); no FEEDBACK_SCORE_LOG change; no blind learner/evaluator contamination. Graduated 1000/2000/F02/3000 levels remain CLOSED; independent personnel safety and OpenPressBrake G0/G1 remain HOLD. **Next:** run MOTION-144 first if qualified isolated self-hosted compute becomes available; otherwise rotate to another distinct LinuxCNC internals question. M61 fractional-Q and RETAIN_G43 tests are a second-priority bounded source-to-runtime gap, not a reason to dispatch an unqualified runner.
