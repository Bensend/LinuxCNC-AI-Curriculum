# 4000 LinuxCNC INI include and HALFILE version-compatibility walkthrough

**Audience:** LinuxCNC integrators building mills, plasma gantries, routers and press-brake controllers. **Status:** practical disconnected source-based walkthrough; **NOT RUN**, no machine commissioning authorization.

## Why this is worth testing

[INI-104](../research/4400_LINUXCNC_INI_104_INCLUDE_EXPANSION_VERSION_SOURCE_AUDIT_2026-11-01.md) traces stable launcher `.expanded` textual inclusion versus development's native recursive parser. [INI-105](../research/4400_LINUXCNC_INI_105_DUPLICATE_SECTION_HALFILE_CACHE_SOURCE_AUDIT_2026-11-01.md) traces a *different* failure mode: stable `IniFile::Find` only sees the first `[HAL]` section, while development merges repeated sections. The consequence is that a syntactically present `HALFILE` can fail to reach the actual HAL loader. This is a **versioned source prediction**, not a reproduced missing output.

## Inspectable fixture (no executable machine config)

- [`parent.ini`](../examples/4000_ini_include/parent.ini) — three `HALFILE` references distributed across repeated `[HAL]` sections and one include.
- [`fragment.inc`](../examples/4000_ini_include/fragment.inc) — second `[HAL]` section.
- [`flattened.ini`](../examples/4000_ini_include/flattened.ini) — manually flattened equivalent for testing the **stable parser without starting LinuxCNC**.

These are intentionally **incomplete** LinuxCNC machine configurations. The named `.hal` files do not exist; never launch a controller from them.

## Source-level walkthrough

1. Read the pinned [stable launcher](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/scripts/linuxcnc.in) `handle_includes` and `HALFILE` loop. Distinguish the shell-created `.expanded` file from the raw parent INI.
2. Read stable [`IniFile::Find`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/libnml/inifile/inifile.cc) through the *next-section stop* and `--num`-equivalent counter. Explain why a repeated section is not the same as a repeated tag.
3. Read development [`parseLine`, `findTag` and `IniFileCache`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/ini/inifile.cc). Trace include resolution, merged tag index, cache lifetime and invalid-input return.
4. Check the official [stable include docs](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/config/ini-config.adoc) against [development docs](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/config/ini-config.adoc). Explain one-pass versus recursive behavior and the strict stack bound.

## Disconnected commands to run only on qualified isolated compute

The following commands **read INI data only**. They do not invoke `linuxcnc`, `halcmd`, realtime threads, motion or a machine. Run each command against a matching installed version, from the fixture directory, on a qualified isolated `[self-hosted, openpressbrake]` runner. Capture stdout, stderr, exit status, executable version and immutable fixture hashes.

```sh
# Stable 2.9.10: use manually flattened file, because standalone
# inivar does NOT call the linuxcnc.in shell include expander.
inivar -ini flattened.ini -sec HAL -var HALFILE -num 1
inivar -ini flattened.ini -sec HAL -var HALFILE -num 2
inivar -ini flattened.ini -sec HAL -var HALFILE -num 3

# Development: native parser reads the parent and its include directly.
inivar -ini parent.ini -sec HAL -var HALFILE -num 1
inivar -ini parent.ini -sec HAL -var HALFILE -num 2
inivar -ini parent.ini -sec HAL -var HALFILE -num 3
```

**Predicted source-derived observations:** stable `flattened.ini`: `first.hal`, then no second/third match; development `parent.ini`: `first.hal`, `second.hal`, `third.hal`. Actual CLI output remains **UNKNOWN** until run. Do not score a case PASS from this prediction alone.

## Bounded acceptance matrix (all NOT RUN)

| ID | Discriminator | Capture / verdict boundary |
|---|---|---|
| I104-1 | Stable flat repeated sections | `inivar -num 1..3`, stdout/stderr/exit; distinguish empty from error |
| I105-1 | Development native merged sections | same three queries against parent+fragment |
| I104-2 | Nested `#INCLUDE` | stable launcher source expansion versus development parser; no controller launch |
| I104-3 | Missing include | capture parser/expander diagnostic and return; do not assume machine startup |
| I104-4 | Include cycle/depth 14 versus 15 edges | development parser error and root-count; no recursion in stable shell |
| I105-2 | Development same-process open→edit→reopen | use a **separate** bounded C++ harness, not two independent `inivar` processes |
| I105-3 | Duplicate `[HAL]` in `TWOPASS` | trace Tcl consumer and capture loaded HAL list in a disconnected simulation only |

**Production configuration review:** Keep one `[HAL]` section; repeat `HALFILE =` keys there in desired order. Explicitly verify the loaded HAL thread order and actual I/O provenance. For EtherCAT/Mesa and press-brake dual-axis control, missing `HALFILE` may remove a required feedback or enable path, but this guide proves no installed-machine fault. Preserve separate physical interlocks and independent personnel-safety authority.

**Dependencies:** [earlier HAL ordering evidence](../research/4400_LINUXCNC_STEPGEN_97_MESA_POSITION_FEEDBACK_VS_PHYSICAL_AXIS_MR1_SOURCE_AUDIT_2026-11-01.md) is about *what feedback means after a net exists*; this guide concerns *whether the intended HAL file is loaded*. No test or hardware result, no graduation, no safety/evaluator gate change.
