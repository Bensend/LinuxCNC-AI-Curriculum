# 3100 / 3400 / 4000 — LinuxCNC G73/G83 peck clearance, CAM post and canonical verification
**Audience:** mill/router integrators, CAM post authors, and source-level LinuxCNC developers. **Status:** practical source-derived walkthrough; not a certified machine program and not runtime-verified. **Read first:** [CYCLE-115](../research/4400_LINUXCNC_CYCLE_115_G73_G83_PECK_CLEARANCE_VERSION_AND_R_OVERSHOOT_SOURCE_AUDIT_2026-11-01.md) and [CYCLE-116](../research/4400_LINUXCNC_CYCLE_116_DEVELOPMENT_NEGATIVE_D_RAPID_STOCK_AND_DEFAULT_DOC_CONFLICT_SOURCE_AUDIT_2026-11-01.md).

## Controller and authority boundaries
A CAM post owns G-code units, Q peck depth, D clearance (if supported), R plane, hole geometry, fixture clearance and controller-version compatibility. The **interpreter** converts canned cycles into canonical feed/traverse segments; **Task/motion** schedules those segments; HAL and actual drive feedback determine machine behavior. A correct G-code preview is not a substitute for canonical verification, physical geometry review or independent protective authority.

| Contract | stable v2.9.10 `86cdca76fa2a` | development `06864e23559e` |
| --- | --- | --- |
| G73/G83 D word | D on these cycles rejected by inspected other-word gate | D admitted; signed real stored without positive-range guard |
| implicit metric peck clearance | 0.254 mm | 1.0 mm unless INI override |
| implicit imperial peck clearance | 0.010 inch | 0.050 inch unless INI override |
| G73 intermediate motion | feed Q, short rapid `last_depth + clearance` | same geometry with configurable clearance |
| G83 intermediate motion | feed Q, rapid to R, rapid to `last_depth + clearance` | same geometry with configurable clearance |
| G98/G99 | selects final clearance; not an intermediate-peck cap | same in inspected source |

**Geometry:** for G90 with R above bottom, first peck depth `R-Q`; intermediate rapid `R-Q+c`. If `c>Q`, that rapid rises above R. If `c<0`, it travels deeper than the previous feed bottom. G83 also visits R before the intermediate rapid. This logic is independent of spindle/fixture protection.

## Unit-switch follow-through — CYCLE-117
The [development G20/G21 peck-parameter source audit](../research/4400_LINUXCNC_CYCLE_117_G20_G21_PERSISTENT_INI_PECK_CLEARANCE_UNIT_MISMATCH_SOURCE_AUDIT_2026-11-01.md) found that the persistent G73/G83 INI/default clearance fields are **not rescaled** by `convert_length_units`. On a metric machine, the development default 1.0 mm becomes a **numeric 1.0 inch** after G20 if D is omitted, producing a potential 25.4× physical clearance change. Stable's fixed 0.010-inch constant is explicitly converted according to the current unit mode. Freeze units across the cycle; in development use a validated explicit D in the active unit mode when a unit switch is unavoidable. Source-derived only; no interpreter test executed.

## Conservative CAM-post contract
1. Pin target LinuxCNC binary/version and actual INI. Reject unknown target rather than silently selecting a version; never infer development's default from the G73/G83 G-code prose.
2. Require known G17/G18/G19 plane, G20/G21 units, G90/G91 distance mode, G98/G99 retract mode, positive feed, and known Z/R geometry. For a basic G17 metric drill, prefer explicit G17 G21 G90 G94 G40 G99, safe initial Z and explicit R/Q.
3. Validate **Q>0** and finite; ensure the full hole, retract and lateral travel paths clear tooling/fixtures. This guide adopts `0<c<=Q` as a **conservative post rule** to prevent above-R intermediate rapids and negative-clearance rapid incursion; it is **not** a native LinuxCNC validation rule.
4. Stable v2.9.10: omit D and treat c=0.254 mm / 0.010 inch. Development: emit an explicitly validated D in current programmed units **only after** verifying that installed interpreter's unit handling; otherwise inspect `[RS274NGC]` clearance values and freeze the program's unit mode. Never emit negative or zero D.
5. Avoid mixing unit modes inside a cycle. Verify tool-length offsets, retract height and real fixturing separately. G98's final retract can be above R; G99's final retract goes to R. Neither is a safety interlock.
6. Before machine commissioning, compare interpreter canonical output with predicted segments and inspect in a disconnected virtual setup. A preview alone is insufficient. Do not use these demonstration values on a connected machine.

## Minimal **disconnected-only** fixture plan
Use a fresh disposable interpreter configuration, no hardware HAL, and record the exact binary SHA/tag. The following *source-derived sequences* are **not** a ready-to-run physical machine program. For each sequence, establish G17/G21/G90/G94/G40/G99, current Z=5, F100, R2, Z0, Q0.5, one hole X0 Y0, then G80. Run G73 and G83 **separately** with clean interpreter state.

- **Stable fixture A:** `G73 X0 Y0 Z0 R2 Q0.5` (no D). Expected first feed Z1.5, intermediate rapid Z1.754. Repeat as G83: feed Z1.5, rapid R2, rapid Z1.754.
- **Development fixture B, implicit clearance:** same G-code and a verified absence of INI overrides. Expected first feed Z1.5, intermediate rapid Z2.5; G83 also rapids to R2 before Z2.5.
- **Development fixture C, explicit positive D:** `G73 X0 Y0 Z0 R2 Q0.5 D0.25` and separate G83. Expected first feed Z1.5, intermediate rapid Z1.75 (G83 visits R2 first). Verify that D uses the expected unit context.
- **Development fixture D, invalid D:** D=-0.5 with Q1, R2, bottom Z-1 is a *source-only negative test*, not a physical fixture. Freeze prediction: source suggests parser acceptance and an intermediate traverse below the last fed bottom. Use only a disconnected interpreter; treat unexpected error/rejection as a correction to the source audit, not as proof of safe physical behavior.

**Expected output vs observed:** All four cases **NOT RUN**. Record exact interpreter version and commit, INI content, command line, stdout/stderr, exit code, canonical `STRAIGHT_FEED`/`STRAIGHT_TRAVERSE` coordinates and first divergence. Do not promote source-derived arithmetic to TEST-CONFIRMED without an actual run. If no qualified isolated runner is available, leave these pending and rotate to another LinuxCNC topic.

## Existing upstream tests to reuse, not duplicate
The upstream [G17 G98 G81 test](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/interp/g81/g17/g98/test.sh#L1) and [G17 G99 G81 fixture](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/interp/g81/g17/g99/g17-g99-g81.ngc#L1) already cover the shared initial/final canned-cycle R-plane semantics. They do **not** verify the new G73/G83 clearance or D behavior. Reuse them for the shared macro baseline and add only the three or four distinguishing peck cases if a qualified environment is actually available. No GitHub-hosted Actions runners; no dispatch until independently qualified `[self-hosted, openpressbrake]` isolation is established.

## Developer handoff / adversarial checks (unscored)
A fresh implementer should explain why `G99` does not prevent a development G73 Q0.5 rapid to Z2.5 when R2; why stable rejects G73 D0.25 while development accepts it; how G83's two intermediate rapids differ from G73; and why a negative D is more consequential than a positive D>Q. Proposed change: add a **postprocessor** check `if c<=0 or c>Q: reject` with a message naming controller revision, units, Q, c and INI provenance. Verify the rule does not pretend to replace physical collision protection.

**Evidence/dependencies:** Interpreter source and official manuals pinned in CYCLE-115/116; upstream G81 fixture is a shared-path comparator only. Actual interpreter tests, physical toolpath, independent evaluator and safety-course G0/G1 remain unchanged and unverified here.
