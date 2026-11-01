# 4000-LC-INI-105 — Repeated [HAL] sections, HALFILE enumeration and development INI cache

**2026-11-01 | 4000 LinuxCNC configuration internals; 3100/3300/3600 machine handoff | NON-GRADUATED / NO EXECUTION.** This extends [INI-104](4400_LINUXCNC_INI_104_INCLUDE_EXPANSION_VERSION_SOURCE_AUDIT_2026-11-01.md) with a **separate semantic change after include expansion**: which `[HAL]` entries the launcher can actually retrieve.

## Immutable provenance

- LinuxCNC v2.9.10 [`src/libnml/inifile/inifile.cc::IniFile::Find`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/libnml/inifile/inifile.cc), blob `73d9a66cb194a182e864bf003ca6ecc03c024510`, roughly lines 140–320.
- Development `06864e23559e70463fc7112d5ce77138bcbc288c` [`src/emc/ini/inifile.cc`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/ini/inifile.cc), blob `530f5c907f12505b0c285aea3112f0f7f05d1034`: `IniFileContent::parseLine` section merge, `IniFile::findTag/findTags`, `IniFileCache::getIniFile`.
- Stable [`scripts/linuxcnc.in`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/scripts/linuxcnc.in), blob `75abe58b78988cfc35287bb63f28bc46d0b8b23c`, `[HAL] HALFILE` enumeration `NUM=1,2,...` (and `TWOPASS` alternative); development [same script](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/scripts/linuxcnc.in), blob `9e6de5efe1a624427b113f3f6c389e32d81063f2`.
- [Stable official include demo](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/sim/axis/ini_with_includes/includes_demo.ini) confirms `#INCLUDE` is used in actual distributed simulation configs; this guide's fixture is **new illustrative input**, not that machine's HAL.

## Complete read path and non-equivalence

For an already flattened input with repeated `[HAL]` headers:

```ini
[HAL]
HALFILE = first.hal
[HAL]
HALFILE = second.hal
[HAL]
HALFILE = third.hal
```

- **Stable** `IniFile::Find(tag, section, num)` searches for the **first** matching `[HAL]` header, then stops when the next section header is encountered. Its `num` decrements for repeated tag matches *within that first section only*. `inivar -sec HAL -var HALFILE -num 1` can therefore retrieve `first.hal`; `-num 2` reaches the second `[HAL]` header and reports no matching tag. This is a source-derived prediction, not a captured CLI result.
- **Development** `IniFileContent::parseLine` logs a duplicate-section warning and sets `_currentsection` to the existing section index. Each subsequent tag is appended to that section's tag index; `IniFile::findTag` counts matching tags in this merged order. Thus `-num 1,2,3` can retrieve `first.hal`, `second.hal`, `third.hal` respectively. Again **not executed**.
- Both launchers enumerate `HALFILE` with successive `inivar -num` calls, and the ordinary path stops when an empty value is returned. The stable duplicate-section boundary can therefore **omit later HAL files** even if the top-level `#INCLUDE` was successfully expanded. **Do not infer actual physical output behavior** from this without an installed config and runtime trace.
- A stable `TWOPASS` configuration uses `haltcl` instead of the shell's ordinary HALFILE loop; the same parser's behavior must be checked at the Tcl consumer. This audit does **not** claim all HAL loading paths have identical results.

## A distinct development-only staleness contract

`IniFileCache::getIniFile(path)` stores parsed `IniFileContent*` in a process-global map keyed by the path string. A subsequent `IniFile::Open(path)` in **that same process** returns the cached object without re-reading the file or checking mtime. Editing the parent or an included file after the first read is therefore **not necessarily visible to subsequent opens in that process**. New `inivar` processes have separate caches; do not extrapolate this to a persistent cross-process cache. No file-edit/reopen test was performed.

## Versioned commissioning guidance

Prefer a **single `[HAL]` header** and keep all ordered `HALFILE =` entries in that section, even when fragments are used. This removes a source-confirmed stable/development discrepancy and makes HAL function ordering inspectable. Verify every intended HAL file in effective order; confirm `addf` read→control→write sequence in the loaded HAL, not merely its presence in an INI. Treat any in-process INI reload as a separate feature requiring explicit source/test evidence.

**Evidence:** SOURCE-CONFIRMED parser and launcher control paths, conditional INFERENCE about omitted machine wiring, TEST-CONFIRMED none. No builds, shell execution, `inivar`, HAL loading, machine operation or Actions. [Guide and fixtures](../guides/4000-linuxcnc-ini-includes-halfile-version-commissioning-2026-11-01.md).
