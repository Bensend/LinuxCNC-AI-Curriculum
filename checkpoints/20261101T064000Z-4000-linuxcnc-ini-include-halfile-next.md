# 2026-11-01 ~06:40Z — LinuxCNC INI/HALFILE versioned loading checkpoint

**Active:** 4000 LinuxCNC implementation / 3100-3300-3600 configuration transfer, NON-GRADUATED. Mandatory START_HERE, mission, levels/selection, curriculum, source/template, progress, lesson log, blind protocol/score, lab ledger and prior [PLASMA-102/103 checkpoint](20261101T053300Z-4000-linuxcnc-plasma-kerf-units-next.md) inspected. Prior DXF/ezdxf candidate rejected as duplicate of DXF-01/CAM-02; selected previously unworked INI include/parser/HALFILE version boundary instead.

## New durable work

- [INI-104](../research/4400_LINUXCNC_INI_104_INCLUDE_EXPANSION_VERSION_SOURCE_AUDIT_2026-11-01.md): stable v2.9.10 launcher one-pass `.expanded` include handling versus development `06864e23559e70463fc7112d5ce77138bcbc288c` native recursive parser, invalid include behavior, source strict stack-size 16/root counting and stable `eval echo` trust boundary.
- [INI-105](../research/4400_LINUXCNC_INI_105_DUPLICATE_SECTION_HALFILE_CACHE_SOURCE_AUDIT_2026-11-01.md): stable first `[HAL]`-section-only lookup versus development merged duplicate sections, actual `HALFILE` enumeration in both launchers, development per-process parsed INI cache.
- [INI-106](../research/4400_LINUXCNC_INI_106_TWOPASS_TCL_DUPLICATE_SECTION_CONSUMER_SOURCE_AUDIT_2026-11-01.md): source-closed stable TWOPASS exception: Tcl `parse_ini` merges duplicate `[HAL]` sections while ordinary `inivar` does not; TWOPASS activation itself is still first-section-limited. No HAL execution.
- [Disconnected walkthrough](../guides/4000-linuxcnc-ini-includes-halfile-version-commissioning-2026-11-01.md) and [parent](../examples/4000_ini_include/parent.ini), [fragment](../examples/4000_ini_include/fragment.inc), [flat](../examples/4000_ini_include/flattened.ini) fixtures. Seven distinct discriminators all **NOT RUN**.

## Next highest-value unblocked action

1. If an independently qualified isolated `[self-hosted, openpressbrake]` runner exists, run only the six **read-only** `inivar` fixture queries first. Preserve stdout, stderr, exit code, exact LinuxCNC version, fixture bytes and job runtime. If source predictions fail, correct the audits before any HAL loader simulation. Never use GitHub-hosted Actions.
2. Stable `TWOPASS` Tcl consumer is now **SOURCE-CONFIRMED distinct** in INI-106. If justified, verify the ordinary/TWOPASS branch difference in disconnected HAL simulation and investigate development same-process INI reload. Do not claim runtime PASS from source inspection.
3. If qualified compute remains unavailable, rotate to a **different** source-grounded LinuxCNC implementation topic (e.g. motion/HAL, real mill/lathe configs, EtherCAT, kinematics) rather than accumulating another unexecuted INI test bank.

**Evidence:** SOURCE/DOC-CONFIRMED static, conditional INFERENCE, TEST-CONFIRMED none. No shell execution, `inivar`, build, simulation, physical machine, evaluator or Actions compute. `LAB_COMPUTE_LOG.md` and `evaluation/FEEDBACK_SCORE_LOG.md` unchanged. 1000/2000/F02/3000 graduated CLOSED; independent personnel-safety G0/G1 HOLD unchanged. Hourly curriculum task stays enabled.
