# 4000-LC-INI-104 — LinuxCNC INI #INCLUDE: stable launcher expansion versus development native recursion

**2026-11-01 | LinuxCNC 4000 implementation / 3100, 3300, 3600 configuration transfer | NON-GRADUATED.** Source inspection only; no machine startup, parser execution, shell execution or test verdict. This is a **new version-specific configuration-loading mechanism**, not a repetition of earlier DXF/QtPlasmaC filter research.

## Pinned source and intended contract

- Stable **v2.9.10**, commit [`86cdca76fa2a36274c432caa21952b23c267989a`](https://github.com/LinuxCNC/linuxcnc/commit/86cdca76fa2a36274c432caa21952b23c267989a): [`scripts/linuxcnc.in`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/scripts/linuxcnc.in), blob `75abe58b78988cfc35287bb63f28bc46d0b8b23c`, `handle_includes` near lines 300–350 and invocation before HAL startup; [`src/libnml/inifile/inifile.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/libnml/inifile/inifile.cc), blob `73d9a66cb194a182e864bf003ca6ecc03c024510`, `IniFile::Find`.
- Development **2026-11-01** commit [`06864e23559e70463fc7112d5ce77138bcbc288c`](https://github.com/LinuxCNC/linuxcnc/commit/06864e23559e70463fc7112d5ce77138bcbc288c): [`scripts/linuxcnc.in`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/scripts/linuxcnc.in), blob `9e6de5efe1a624427b113f3f6c389e32d81063f2`; [`src/emc/ini/inifile.cc`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/ini/inifile.cc), blob `530f5c907f12505b0c285aea3112f0f7f05d1034`, `IniFileContent::parseLine/parseContent`, `pathPush`, `IniFile::Open`.
- Stable [INI configuration docs](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/config/ini-config.adoc), blob `e3d691253f7ff94f235d9735a67f06730ece7a38`, section *Include Files*: **one level only**. Development [same docs](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/config/ini-config.adoc), blob `ed9acdbbbfe228eebe380e6f15607871c7cb1b5e`: nested includes, 16-level description, uppercase directive in column one.
- Real upstream example: [`configs/sim/axis/ini_with_includes/includes_demo.ini`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/sim/axis/ini_with_includes/includes_demo.ini), blob `f1fc23fe1c675dc55e086921f5c1c5ccfd97fc3b`, with several include files and deliberately missing directives.

## Source call flows and consequences

**Stable 2.9.10**: `linuxcnc.in` → `handle_includes "$INIFILE"` → grep lines beginning exactly `#INCLUDE` → create `<original>.expanded` → for each top-level directive, `eval echo "$b"` to form path and `cat` included file → set `INIFILE` to expanded path → `inivar -ini "$INIFILE" -sec HAL -var HALFILE -num N` → `halcmd` or `haltcl`. It is **one-pass textual inclusion**; nested directives are copied, not recursively expanded. Missing include files produce a message in the generated file and stderr, but the shell function still returns success and the launcher continues to later stages. This is **SOURCE-CONFIRMED continuation**, not proof that a complete machine startup succeeds when required settings are missing.

The stable shell uses `while read a b` and `echo "$a $b"` for ordinary lines, so its expanded output is **not a byte-preserving copy** of whitespace/formatting. It also uses `eval echo "$b"` on include names: treat machine configuration files as trusted inputs; no exploit or execution was attempted here.

**Development**: the launcher no longer has `handle_includes`; `IniFileContent::parseLine` directly recognizes `#INCLUDE ` at column one, resolves paths relative to the *containing* file, reads recursively and preserves tag source file/line metadata. Missing includes, recursive loops and excessive depth return false from parsing, so `IniFile::Open` cannot obtain a valid parsed object. **SOURCE-CONFIRMED parser rejection**, not a demonstrated GUI error or machine behavior.

**Depth detail:** `MAX_INCLUDE_DEPTH = 16`; `pathPush` pushes then returns `_pathstack.size() < 16`. The root file already occupies one entry. Consequently a chain of 14 include edges reaches stack size 15 (accepted), while the 15th reaches 16 (rejected). The docs' “up to 16 levels” wording needs this exact root-count and strict-boundary qualification; no execution has checked the boundary.

## Practical discriminators

| Fixture | Stable 2.9.10 source prediction | Development source prediction |
|---|---|---|
| Parent includes one valid file | launcher creates `.expanded`, then ordinary INI reader sees its text | native parser follows include, no launcher expansion |
| Included file itself has `#INCLUDE child.inc` | copied as a directive, **not expanded** by the stable reader | recursively parsed, subject to depth/loop guard |
| `#INCLUDE missing.inc` | error text emitted but expansion function returns 0; later startup outcome depends on other settings | parser returns failure |
| Include loop A→B→A | one-pass stable expansion; no recursive loop traversal | explicit `pathIsLoading` failure |
| 15th include edge from root | not a stable supported feature | strict stack-size check rejects |

**Evidence ledger:** stable/development source and documentation **SOURCE/DOC-CONFIRMED**; predictions about actual CLI stdout, complete startup and machine response **NOT TESTED / UNKNOWN**. No workflow or local execution; no physical I/O.

**Next:** use the [disconnected fixture guide](../guides/4000-linuxcnc-ini-includes-halfile-version-commissioning-2026-11-01.md) to compare `inivar` outputs on a qualified isolated `[self-hosted, openpressbrake]` runner only. No GitHub-hosted fallback. Closed levels and independent personnel-safety gates unchanged.
