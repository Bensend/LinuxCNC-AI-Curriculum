# HAL-NAMED-163 — disconnected G-code HAL readback commissioning

**Scope:** LinuxCNC 2.9.10 vs pinned development; no motion, no torch, no machine-connected runner. All cases **NOT RUN**. Companion [source audit](../research/4400_LINUXCNC_HAL_NAMED_163_GCODE_HAL_LOOKUP_BOUNDS_AND_LIFETIME_SOURCE_AUDIT_2026-11-02.md).

## Setup / provenance

Use a **physically disconnected** LinuxCNC simulation, not an OpenPressBrake panel PC with live I/O. Identify the exact executable build SHA, INI, interpreter and HAL backend. Configure `[RS274NGC] HAL_PIN_VARS = 1` (documented default is 1). Preserve the stdout/stderr and NGC debug messages. Verify that the intended signal is not connected to any real outputs. Do **not** dispatch GitHub-hosted Actions; any future justified automated test must use independently qualified isolated `[self-hosted, openpressbrake]`.

The upstream plasma program [metric_line.ngc](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/nc_files/plasmac/metric_line.ngc) provides a real `F#<_hal[plasmac.cut-feed-rate]>` example, **not** a generic pin available in every simulation.

For a generic simulation, after the HAL session starts and before executing the fixture, create a test-only signal in the same HAL instance:

```sh
halcmd newsig curriculum-feed float
halcmd sets curriculum-feed 1234.5
halcmd gets curriculum-feed
```

Then load [read_hal_signal.ngc](../examples/4000_hal_named_163/read_hal_signal.ngc) in the simulation. The fixture contains **no G0/G1/G2/G3 or external M-codes**.

## Frozen predictions and acceptance matrix

| ID | Test | Predeclared expected evidence | Limits |
|---|---|---|---|
| A | Signal exists, value 1234.5 | `EXISTS` true; debug value 1234.5 | Exact debug rendering may differ; HAL signal has no writer |
| B | Omit `newsig` | `EXISTS` false; no numeric read on else branch | Error formatting/version differences possible |
| C | `HAL_PIN_VARS=0` | Lookup is not available; `EXISTS` false | Verify actual INI consumed by Task |
| D | Compare `#<_ini[...]` with `#<_hal[...]` after source update | INI value cached on first read; HAL value not cached in named map | Read-ahead can hide change |
| E | Set signal between blocks, with and without documented `M66 E0 L0` synchronization | A state synchronization should move the HAL read nearer the execution boundary | Existing M66-138/140 findings mean this is not a universal freshness guarantee |
| F | Isolated ASan build of **actual stable** `fetch_hal_param`, lengths 42,43,47,48 | N=42 in-bounds; N>=43 enters OOB write mechanism | Build/harness must isolate interpreter/HAL, not a live machine |
| G | Same exact inputs after applying review-only patch | <=47 accepted by length guard, >47 rejected without stack write | Success of HAL lookup depends on actual named object |
| H | Development embedding without HAL attach | `hal_is_init` guard reports missing HAL initialization | Test only an isolated caller; native Python `_hal` module initialization calls `hal_lib_init` and registers `hal_lib_exit` at process exit, but standard Task/GUI attachment must be checked in the actual process |
| I | Pin, signal, parameter of unique names | Value conversion and lookup path match pinned source | Do not assume identical names can coexist |
| J | QtPlasmaC feed from real sample | Post uses `F#<_hal[plasmac.cut-feed-rate]>` before M3 | Material/unit/torch correctness remains separately unproved |

**Evidence collection:** exact LinuxCNC commit and build flags; HAL/INI configuration; input files; timestamps; observed stdout/stderr; ASan output for F/G; predicted-vs-observed table; process exit codes. A successful process exit alone is insufficient for F/G. Mark each case PASS/FAIL/HARNESS INVALID/NOT RUN. Preserve raw traces and do not turn source predictions into TEST-CONFIRMED claims.

## Stable patch review

[Patch](../examples/4000_hal_named_163/stable_2910_hal_name_bounded_copy.patch) replaces the unbounded `strncpy` count with a bounded exact-name copy. For the static arithmetic oracle, if `nameBuf="_hal[" + N chars + "]"`, then `closeBracket=5+N`. The original destination has 47 bytes; the old copy writes 5+N bytes. The corrected destination has 48 bytes and copies exactly N bytes after checking N<=47.

Before upstream submission, validate source-context match against stable blob `0237a565...`, compile with appropriate HAL headers, run the actual C function under a memory sanitizer in a disconnected fixture, and verify that a 47-character HAL name is accepted without truncation. This patch has not been applied to a real installation.

## Practical CAD/CAM / plasma contract

A postprocessor may emit a symbolic HAL feed parameter rather than a literal F word, but it must document **which HAL name, source unit system, material library selection, synchronization point, fallback if absent, and which controller version**. Do not use the symbolic read as a realtime measurement of torch voltage, contact, probe position or any independent personnel-safety function.

## Next

MOTION-144 remains the first executable test only after independent physical runner isolation qualification. If that cannot be established, investigate a distinct LinuxCNC interpreter/GUI implementation question. No GitHub-hosted runners.
