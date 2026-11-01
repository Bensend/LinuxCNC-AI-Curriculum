# 4000-LC-INI-106 — Stable TWOPASS Tcl sees duplicate [HAL] sections that ordinary inivar misses

**2026-11-01 | 4000 LinuxCNC INI→HAL loader integration | NON-GRADUATED / SOURCE ONLY.** This is a **consumer-specific correction/extension** of [INI-105](4400_LINUXCNC_INI_105_DUPLICATE_SECTION_HALFILE_CACHE_SOURCE_AUDIT_2026-11-01.md), not another generic duplicate-key claim.

## Exact pinned sources

- LinuxCNC v2.9.10 commit [`86cdca76fa2a36274c432caa21952b23c267989a`](https://github.com/LinuxCNC/linuxcnc/commit/86cdca76fa2a36274c432caa21952b23c267989a): [`scripts/linuxcnc.in`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/scripts/linuxcnc.in), blob `75abe58b78988cfc35287bb63f28bc46d0b8b23c`, `TWOPASS` decision and ordinary `HALFILE` loop.
- Stable [`tcl/linuxcnc.tcl.in::parse_ini`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tcl/linuxcnc.tcl.in), blob `613568137d1b87f731be8dc56f96cc9270216c2b`: standalone Tcl text parser, `upvar $section s; lappend s([string trim $k]) $v`.
- Stable/development identical [`tcl/twopass.tcl::tp::prep_the_files`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tcl/twopass.tcl), blob `1614a607a36eddd887d1b7d46c5b5ff79cd9daa6`: `foreach file_plus_args $::HAL(HALFILE)`; package `Linuxcnc` supplies `parse_ini`.
- Development `06864e23559e70463fc7112d5ce77138bcbc288c` [`tcl/linuxcnc.tcl.in::parse_ini`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tcl/linuxcnc.tcl.in), blob `10ab7d8e0ec0a74ab29cee343b18923d2a466093`: uses `emc_ini_sections/emc_ini_variables` and checks requested filename against the native parser state.

## Critical distinction

In stable 2.9.10 the ordinary `linuxcnc.in` path calls `inivar -sec HAL -var HALFILE -num N`; the C++ `IniFile::Find` stops at the second `[HAL]` header. **But stable TWOPASS does not use that C++ lookup for its file list.** Once selected, `haltcl -i "$INIFILE" twopass.tcl` invokes Tcl `parse_ini`, which iterates the *whole flattened file* and `lappend`s each matching `HALFILE` to `::HAL(HALFILE)`, including entries under later repeated `[HAL]` headers. `tp::prep_the_files` then traverses the complete Tcl list.

**Source-derived consequence:** with `TWOPASS=on` in the **first** `[HAL]` section, stable 2.9.10 may enumerate all three files in the [fixture](../examples/4000_ini_include/flattened.ini) (assuming files actually exist). Without `TWOPASS`, the ordinary `inivar` loop sees only the first. **No HAL file was loaded in this audit.**

**Important qualification:** the stable launcher itself tests for `TWOPASS` with `inivar -sec HAL -var TWOPASS -num 1`. If `TWOPASS` appears *only* in a later duplicate `[HAL]` section, the launcher can miss the switch and use the ordinary path. Thus it is incorrect to claim that enabling TWOPASS anywhere in the file always bypasses the problem.

Development Tcl `parse_ini` delegates to the native INI API, not the stable regex reader. The native parser merges duplicate sections; its filename consistency checks add a separate initialization dependency. No installed-version or runtime parity claim is made beyond inspected source.

## Commissioning discriminator

Use a **disconnected, complete simulated HAL fixture** (not the current placeholder `first.hal` names) and compare stable ordinary mode versus stable `TWOPASS` with `TWOPASS` placed first versus last. Capture `twopass:found` logs, ordered file list and actual HAL functions; do not infer physical axis enable from text parsing alone. A source-only parser query cannot prove a TWOPASS run.

**Evidence:** SOURCE-CONFIRMED independent Tcl and C++ consumers, conditional INFERENCE about loaded files, TEST-CONFIRMED none. No Tcl execution, HAL loading, LinuxCNC startup, machine operation, Actions or other compute. Graduated levels and personnel-safety gates unchanged.
