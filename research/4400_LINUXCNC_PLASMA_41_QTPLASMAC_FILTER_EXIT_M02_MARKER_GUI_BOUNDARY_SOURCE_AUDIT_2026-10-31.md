# 4000-LC-PLASMA-41 — QtPlasmaC filter error propagation, stdout M02 sentinel and already-filtered bypass

**2026-10-31 · SOURCE/DOC-CONFIRMED conditional, NON-GRADUATED, NOT TESTED.** LinuxCNC GUI/Task integration: an upstream G-code filter can report a handled validation error, raise an uncaught Python exception, or deliberately skip filtering; these produce **different** outcomes. This extends PLASMA-39/40, not a repeat of hole geometry or torch-output timing.

## Pinned source inventory
- [QtPlasmaC v2.9.10 filter](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py), blob `4cdae156b94b607bd2514b1573baabc83f396f23`; `__init__` ~45–167, `process_file` ~169–256, `write_gcode` ~400–406, `write_errors` ~1211–1220, entrypoint line 1449.
- [Development filter](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py), blob `aeff3b6103f8c17a1e845b0f835f9ec9f30210b5`; `process_file` ~217–267, `write_gcode` ~476, `write_errors` ~1368–1376, entrypoint ~1629.
- [QtVCP stable `Action.OPEN_PROGRAM` and `FilterProgram`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/python/qtvcp/qt_action.py), blob `fe0b369842d27fbadd900fae9426228b9c26935b`; ~267–282, ~905–918, ~1060–1138.
- [Axis stable `filter_program` and `open_file_guts`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/axis/scripts/axis.py), blob `ccb7ebe5939d3ea76b1244772ce650c95309b49a`; ~1111–1145 and ~1174–1208.
- [Official filter-program specification](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gui/filter-programs.adoc), blob `f5a9044ea23d2753744f544cec4e271f6f15daec`: the INI filter receives an input filename, emits G-code to stdout; that output is previewed/executed. Stderr progress and nonzero exit are separate channels.
- [Upstream QtPlasmaC metric simulation INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/qtplasmac/qtplasmac_metric_ini.inc) maps .ngc/.nc/.tap to the filter.

## Path A — uncaught filter exception: nonzero exit, no new program load
Example: [PLASMA-39](4400_LINUXCNC_PLASMA_39_QTPLASMAC_HOLE_FILTER_COORDINATE_STATE_SOURCE_AUDIT_2026-10-31.md) G90.1+J can reach `get_axis_value('J')` with missing positional argument. If it raises an uncaught Python exception, the filter process terminates nonzero. QtVCP `FilterProgram` opens a temporary output file and captures stdout/stderr, then `finish()` shows a filter-error dialog for nonzero status. `Action.open_filter_program` supplies callback `lambda r: r or self._load_filter_result(tmp)`; for a **nonzero** r the right operand is not evaluated, so the partial temporary output is **not opened** by this path. Axis checks `exitcode` and returns before `open_file_guts(tempfile,True,...)`. The prior program may remain selected; **do not assume the controller's previous program was unloaded or stopped**. This is GUI source-confirmed for inspected stable v2.9.10, not a runtime-tested QtPlasmaC-specific GUI trace.

## Path B — filter-detected codeError: zero exit with leading M02
In stable and inspected development `Filter.__init__`, `process_file()` sets `codeError` for known invalid cases, then `write_errors()` and `write_gcode()` are called. `write_errors` prints **`M02 (end program)` to stdout first** when `codeError` is true, and opens a separate error/warning dialog. `write_gcode` subsequently prints the collected G-code lines and the filtered-file marker. The entrypoint simply constructs `Filter`; this handled-error path does **not** explicitly `sys.exit(1)`. If no unrelated exception occurs, the filter exits zero, so QtVCP/Axis can load a file whose first line is M02. That is a **different** contract from A: GUI load success is not proof of a valid, executable cut. M02 should end normal RS274 execution before later motion, but this is a source-derived expectation, not an observed Task run; a manually edited output or altered interpreter context needs separate review.

**Do not conflate:** Python stderr/exit status, QtPlasmaC's own `gcode_errors.txt` and dialog, GUI load result, RS274 parse result, and actual motion are distinct evidence channels.

## Path C — trusted already-filtered marker skips normal validation
Stable v2.9.10 scans the **entire file** for the substring `;qtplasmac filtered G-code file` (~173), sets `self.filtered`, and copies subsequent input lines without normal `parse_code` processing (omitting marker lines). Development 537cf2d765c9 instead requires the **exact marker line** `;qtplasmac filtered G-code file\n` to appear in `readlines()` (~222–227), then returns from `process_file` with the input lines copied. Both deliberately implement idempotence for already-filtered files; both can also skip ordinary material/geometry checks if a user-authored or external post file contains the accepted marker. **This is a trust/provenance boundary, not evidence of a security exploit.** The dev change narrows substring matching but does not authenticate that a file was actually filtered.

A separate early branch in both versions passes through files named exactly `rfl.ngc` without normal filtering, intended for run-from-line processing. Do not reuse that basename for generic unfiltered CAM programs.

## Source-grounded acceptance discriminators (NOT RUN)
| Fixture | Expected source path | What to record |
|---|---|---|
| G90.1+J with holes enabled | uncaught Python TypeError → nonzero exit | stderr/exit, QtVCP/Axis dialog, whether previous program remains |
| Invalid M190 P material or mathematical hole center | `codeError` → stdout starts `M02`, zero exit if dialog returns normally | filtered file first line, GUI warning, error file, Task program load |
| Valid G-code with a full-line marker in source | skip normal parse | marker handling, material/geometry changes absent |
| Marker text embedded in a longer comment | stable substring skip; development exact-line should not skip | version-specific filtered output diff |
| Filename `rfl.ngc` | early passthrough | source filename and raw output, no generic post assumption |

Do not run on connected hardware. A qualified `[self-hosted, openpressbrake]` **disconnected simulation** may provide independent evidence; capture original input, temporary filtered output, stderr, return code, GUI status, previous loaded program and exact job timestamps. Never use GitHub-hosted Actions runners.

## Engineering conclusions and limits
- **SOURCE-CONFIRMED** stable GUI nonzero exit prevents opening partial output; handled `codeError` prints M02 without explicit nonzero exit; stable/dev marker semantics differ.
- **DOC-CONFIRMED** stdout filter contract; **INFERENCE** actual TypeError and M02 Task execution outcome; **TEST-CONFIRMED none**.
- **UNKNOWN** QtPlasmaC-specific GUI override behavior, error dialog user interaction, and installed-machine state. No claim that a malformed post can physically cut, nor that all malformed posts are blocked.
- **Practical rule:** audit **both** filter return code and generated first line, and treat an already-filtered marker as an artifact provenance claim requiring independent trust. Do not promote a filter's zero exit to G-code/machine acceptance.

[Disconnected fixture guide](../guides/4000-linuxcnc-qtplasmac-cam-filter-coordinate-material-acceptance-2026-10-31.md) and [PLASMA-40 material contract](4400_LINUXCNC_PLASMA_40_QTPLASMAC_MAGIC_MATERIAL_JH_PERCENT_CROSS_UNIT_SOURCE_AUDIT_2026-10-31.md) are prerequisites. No new compute, build, simulation, physical operation, evaluator, or graduation change.
