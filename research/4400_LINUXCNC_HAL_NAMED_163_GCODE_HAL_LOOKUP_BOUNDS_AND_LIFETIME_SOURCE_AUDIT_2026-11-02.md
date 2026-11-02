# HAL-NAMED-163 — G-code HAL named-parameter readback, read-ahead and stable lookup bounds

**2026-11-02 | 4000 LinuxCNC-first | 3300 plasma / 3100 mill / 3400 router transfer | NON-GRADUATED | source-only, NOT RUN.**

## Question, novelty, and scope

What exactly does `#<_hal[name]>` read, when is it read, how does it differ from cached `#<_ini[...]>`, and does the stable interpreter safely handle HAL names near the documented maximum? This is a distinct cross-layer G-code/HAL/CAM interface, **not** a rerun of M66-138/140, QtPlasmaC M190, or the prior M1XX-162 external-helper audit. Full PROGRESS/LESSON keyword scan found the existing `F#<_hal[plasmac.cut-feed-rate]>` consumer, but no earlier named-parameter copy-length analysis. Negative indexed code search is not proof of absence.

## Pinned provenance

- Stable LinuxCNC **v2.9.10**, annotated tag `4e7abeab3e764a42ef9def932333a1d4004e547b` → commit `86cdca76fa2a36274c432caa21952b23c267989a`; [`interp_namedparams.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_namedparams.cc), blob `0237a565dca843b720e66806ef1a6de49b8092ce`; [`hal.h`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/hal.h), blob `5480d937fc3310e5a87482acabd9ea551683bcdb`; [`interp_read.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_read.cc), blob `93333860904996732f9fa96f239263c991b2dfd6`.
- Development master commit `67437d8865e431a9a33f74cee912dbf891d3b4c5`; [`interp_namedparams.cc`](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/rs274ngc/interp_namedparams.cc), blob `6efa911a465241ca6b9fbfc03e3bbbbe5281a1c2`; [INI documentation](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/config/ini-config.adoc), blob `ed9acdbbbfe228eebe380e6f15607871c7cb1b5e`; [G-code overview](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/gcode/overview.adoc), blob `3aeb7ba083e7d95b7ffbd41b6998ddb41efa2149`.
- Real upstream [plasma metric-line program](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/nc_files/plasmac/metric_line.ngc), blob `26c7f2885e10bfb831ff451bbad6ff329b483874`: `F#<_hal[plasmac.cut-feed-rate]>` before torch M3 and G1 cut.
- [Official G-code overview](https://linuxcnc.org/docs/html/gcode/overview.html) documents read-only HAL lookup, read-ahead caveat and M66 E0 L0 as a synchronization technique. Retrieval 2026-11-02. This is documentation, not runtime evidence.

## End-to-end implementation path

1. **G-code parse (userspace interpreter):** `Interp::read_named_parameter` calls `read_name` and `find_named_param`. `read_name` in stable `interp_read.cc` accepts names within `LINELEN` and terminates at `>`; it does not impose a HAL-name-specific length bound. The `EXISTS[...]` form uses the same lookup with `check_exists`.
2. **Global name lookup:** `find_named_param` searches the global frame for leading `_`. When absent, `FEATURE(HAL_PIN_VARS)` and the `_hal[` prefix dispatch to `fetch_hal_param`. A successful HAL read returns a value **without inserting it in the named-parameter map**. By contrast, `_ini[` is cached as `PA_GLOBAL|PA_READONLY|PA_FROM_INI`. Both inspected versions preserve this difference.
3. **Stable HAL attach:** stable `fetch_hal_param` lazily calls `hal_init("interp<PID>")` and `hal_ready` once via static component ID. Development explicitly removed this implicit attachment and checks `hal_is_init()`; the **embedding program** must attach to HAL before querying. This is a versioned integration contract, not evidence that every GUI preview fails.
4. **Lookup precedence:** stable calls `hal_get_pin_value_by_name`, then `hal_get_signal_value_by_name`, then `hal_get_param_value_by_name`. Development calls `hal_get_p` as pin, then `hal_get_s` as signal, then `hal_get_p` as param. Thus a named item is not necessarily a pin. Both convert bit/integer/float-like HAL values to G-code `double`. Neither read establishes whether a source is fresh, physically valid, or safe.
5. **Time boundary:** source performs the lookup when the interpreter evaluates the expression; it does **not** cache a HAL named parameter. Nevertheless Task/interpreter may read ahead of execution. Official docs explicitly warn that a value may reflect program-start/read-ahead state rather than the instantaneous realtime state at the downstream cut/move. M66 E0 L0 is a documented synchronization technique, but its exact Task behavior and historical M66 state bugs must be assessed separately; see [M66-140 predecessor](4400_LINUXCNC_M66_140_HISTORICAL_RUNTIME_ORACLE_RECONCILIATION_2026-11-01.md). A synchronized read is still not a safety-rated freshness witness.

## Stable-only length defect: source-confirmed copy exceeds local destination

Stable `hal.h` defines `HAL_NAME_LEN = 47`. Stable `fetch_hal_param` allocates `char hal_name[HAL_NAME_LEN]` (47 bytes) and computes `closeBracket = s - nameBuf`. For a HAL name with **N** characters, `_hal[` contributes five, so `closeBracket = 5 + N`. It then calls:

```c
strncpy(hal_name, &nameBuf[5], closeBracket);
hal_name[closeBracket - 5] = '\0';
```

The copy length is **5+N**, not **N**. With **N=43**, it attempts to copy **48 bytes into a 47-byte destination**, before any HAL lookup. This length is below the nominal HAL maximum of 47 characters. For **N=47**, it attempts 52 bytes and writes the terminator at index 47, itself out of bounds. Shorter names also copy five unnecessary bytes beyond the closing bracket; no claim is made that they necessarily crash.

| HAL name length N | Stable copy count 5+N | 47-byte destination | Expected source-level classification |
|---:|---:|---:|---|
| 1 | 6 | in bounds, overreads past closing bracket | redundant copy |
| 42 | 47 | fits, terminator at index 42 | in bounds |
| 43 | 48 | exceeds by 1 | out-of-bounds write mechanism |
| 47 | 52 | exceeds by 5; terminator at index 47 | out-of-bounds write mechanism |
| 48 | 53 | exceeds by 6 | invalid HAL-name length and out-of-bounds mechanism |

**Evidence:** SOURCE-CONFIRMED static copy-length arithmetic and array sizes; **INFERENCE** for any crash, observable corruption or exploitability. No malicious G-code, memory sanitizer, LinuxCNC process, or machine was executed. Do not use live machine control to test the boundary.

Development instead uses `std::string hal_name = nameBuf + 5`, searches `]`, truncates with `erase`, and queries via HAL API. The specific stable stack-array copy is absent there; development has its own independent HAL-attachment contract. This is not a claim that all development input validation is complete.

## Minimal stable repair candidate

[Review-only patch](../examples/4000_hal_named_163/stable_2910_hal_name_bounded_copy.patch) makes the destination `HAL_NAME_LEN+1`, derives the exact name length from `s - &nameBuf[5]`, rejects names exceeding 47, and copies only the actual name bytes. It does not change lookup precedence, data type conversion, HAL initialization or read-ahead behavior. Patch **NOT APPLIED upstream, NOT COMPILED, NOT TESTED**. Review `CHKS` error-path behavior and real HAL naming limits before upstream submission.

## Reproducible acceptance and predictions (all NOT RUN)

The [disconnected commissioning guide](../guides/3300-4000-linuxcnc-hal-named-gcode-readback-commissioning-2026-11-02.md) and [no-motion NGC fixture](../examples/4000_hal_named_163/read_hal_signal.ngc) define: (A) HAL signal lookup, (B) absent name with EXISTS, (C) INI flag off, (D) HAL/INI cache distinction, (E) read-ahead and M66 barrier, (F) stable name lengths 42/43/47/48 under isolated AddressSanitizer, (G) corrected stable behavior, (H) development caller-not-attached error, (I) pin/signal/param precedence, (J) real QtPlasmaC post feed source. Do not infer a TEST-CONFIRMED result from the guide.

## Machine/CAM transfer and limits

For plasma nesting/postprocessing, `F#<_hal[plasmac.cut-feed-rate]>` is a legitimate upstream pattern, but **units, material selection, timing of parameter update, tool/torch state and feed override** must be established separately. For mills/routers, a named HAL parameter is a process-setting interface, not a realtime feedback channel. For press brakes, the G0/G1 machine restriction and independent personnel-safety authority remain unchanged; no press motion is authorized by this research.

## Adversarial / fresh-AI handoff questions (not scored as blind)

1. **Misleading premise:** “HAL parameters are cached like INI parameters.” Show the two branches of `find_named_param` and refute.
2. A 43-character signal name is legal under the HAL header. Compute the stable copy length and identify the first out-of-bounds operation.
3. Why can an `F#<_hal[...]>` line still use an old value if `fetch_hal_param` does not cache?
4. An embedded preview using development `rs274ngc` fails to read HAL. Which `hal_is_init` contract should be checked before blaming the signal name?
5. **Novel transfer:** A router post changes a HAL feed setting immediately after starting a long queued program. Specify a bounded, no-motion observation that distinguishes parse-time snapshot from execution-time value without claiming machine safety.

**Status:** SOURCE/DOC-CONFIRMED for implementation and documentation; conditional numerical and timing consequences INFERENCE; **TEST-CONFIRMED none**. No new external evaluator or retention score. Promotion: software-only ASan original-versus-patched check when qualified physically disconnected compute exists (HIGH, does not reopen graduated levels); installed QtPlasmaC feed freshness/units (MEDIUM, machine-specific and not proved here).

## Same-session follow-through — development Python HAL attachment path (HAL-NAMED-163B)

The development source's new `hal_is_init()` guard has an inspectable *caller-side* counterpart. At pinned master `67437d8865e431a9a33f74cee912dbf891d3b4c5`, [`src/hal/halmodule.cc`](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/hal/halmodule.cc) blob `9510653fe7c5ad98ff5dbeca45b543ec8ef872cd`, `PyInit__hal` invokes `hal_lib_init()` and registers `Py_AtExit(hal_lib_exit)`. [`src/hal/hal_lib.c`](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/hal/hal_lib.c) blob `d5d84107e8cfbaf970d91030b66f0753695f150e` confirms `hal_lib_init` reference-counts its initialization and maps HAL shared memory; `hal_lib_exit` decrements the count and releases resources when eligible. This makes a Python embedding that **successfully imports the native `_hal` module in the same process** a plausible supported attachment route. It does **not** establish that every G-code preview/Task invocation imports that module or that merely importing an unrelated Python package is sufficient. Before diagnosing a development-only `#<_hal[...]>` failure, inspect the actual process's HAL initialization and import sequence, not just the signal's spelling. **SOURCE-CONFIRMED API path, runtime behavior NOT RUN.**
