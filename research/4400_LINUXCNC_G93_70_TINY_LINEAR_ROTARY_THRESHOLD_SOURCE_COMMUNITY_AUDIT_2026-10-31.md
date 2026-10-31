# 4000-LC-G93-70 — Tiny linear displacement + rotary G93: historical fix and remaining cross-layer threshold
**2026-10-31; active 4000 / NON-GRADUATED. Evidence: historical COMMUNITY-REPORTED with upstream resolution; SOURCE-CONFIRMED current thresholds; runtime regression NOT RUN.**

## Distinct question / predecessor
[G93-67](4400_LINUXCNC_G93_67_INVERSE_TIME_ZERO_FEED_CUTTER_COMP_SOURCE_AUDIT_2026-10-31.md) traced exact-zero-length fallback and F0 omission. [FEED-68](4400_LINUXCNC_FEED_68_DEVELOPMENT_FEED_AXES_CANON_MOTION_METRIC_SOURCE_AUDIT_2026-10-31.md) traced development FEED_AXES. This audit instead tests whether **interpreter and canonical layer agree on whether a nearly-zero XYZ displacement makes a rotary move a mixed linear/rotary move**. Full PROGRESS novelty scan before the session had no prior G93/axisKinds coverage.

## External field report, not this lesson's test
Upstream [LinuxCNC issue #2410](https://github.com/LinuxCNC/linuxcnc/issues/2410), opened **2023-03-28**, describes a G93 rotary A move whose nominal speed was correct, then adding a Z displacement of 0.0002 caused the move to run at an axis limit. The report identifies a reproducible sim-axis-axis9axis configuration. A maintainer's [2023-03-29 comment](https://github.com/LinuxCNC/linuxcnc/issues/2410#issuecomment-1488222174) relays a PathPilot precedent: interpreter/canonical/motion disagreed about when XYZ was small enough to ignore. On **2023-05-09**, the maintainer traced the old `std::max(0.1, length*F)` floor to a nonzero but short linear move and [closed the issue with commit `b244b375`](https://github.com/LinuxCNC/linuxcnc/commit/b244b375ddee0fc684d9ce8341d81f92ad366b42). This is **COMMUNITY-REPORTED prior reproduction and SOURCE-CONFIRMED historical fix**, not a newly executed test. The current stable/development `interp_inverse.cc` applies 0.1 **only when calculated length == 0**.

## Remaining pinned-source distinction
| Layer | Stable v2.9.10 | Pinned development `537cf2d...` |
|---|---|---|
| Interpreter | [`interp_find.cc::find_straight_length`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_find.cc#L644) `tiny = 1e-7`; XYZ included only if `fabs(delta) > tiny` | [same function](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_find.cc#L769) uses `tiny = 1e-7`, moving-bit mask then `axisKindsMeasured` |
| Canonical threshold | [`emccanon.cc::applyMinDisplacement`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L583) zeros linear delta if **less than** `FROM_EXT_LEN(CART_FUZZ)` | [`getStraightSpan`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emccanon.cc#L734) zeros if **less than** same threshold |
| CART_FUZZ definition | [`src/libnml/posemath/posemath.h`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/libnml/posemath/posemath.h#L717) = **1e-8** | [`include/posemath_types.h`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/include/posemath_types.h#L172) = **1e-8** |

For a **metric machine with program G21 and external mm units**, the interpreter cutoff is **1e-7 mm** and the canonical cutoff is **1e-8 mm**. A move from Z0,A0 to **Z0.00000005,A90** (5e-8 mm Z) is therefore classified **rotary-only by the interpreter** but **linear+rotary by canonical** (assuming configured axes, no other filtering, and that numerical coordinates survive). With G93 F5, the interpreter's rotary length 90 degrees gives `rate = 450` in its feed units, while canonical sees a very short XYZ path. The **requested 12-second duration is not established** by this inconsistent metric; actual motion depends on Task, trajectory constraints and numerical handling.

In an inch-program machine, interpreter's 1e-7 is in *program inches*, while canonical threshold is derived from external user units via `FROM_EXT_LEN`. The numeric boundary must be recalculated with the installed units; do not reuse the mm example blindly.

**Additional version nuance:** Stable `applyMinDisplacement` compares B/C against `tiny_linear` rather than `tiny_angular`, whereas development `getStraightSpan` selects the threshold by configured axis TYPE. This is a source difference; an actual B/C symptom is not demonstrated.

## Minimal isolated discrimination (NOT RUN)
Run each in a fresh sim with A and Z configured, G21, G90, G93, high enough axis limits to separate the feed algorithm from clipping:
```ngc
G21 G90 G94 G17
G0 Z0 A0
G93
G1 Z0.00000005 A90 F5
G94 F100
M2
```
Compare three variants: `Z0` (pure rotary); `Z0.00000005` (between cutoffs); `Z0.0000002` (above interpreter cutoff). Freeze exact string, parser/canon feed rate, canonical cartesian/angular classification, trajectory commands, actual simulated duration and status. Use a fourth historical fixture with Z0.0002 to confirm that the old floor regression is **not** present in the pinned version. Note that near-submicron position resolution or rounding can invalidate a fixture; log numeric values actually reaching each layer. Do not use a physical machine or infer safety from simulation.

## Verdict / next
- **SOURCE-CONFIRMED:** thresholds 1e-7 versus 1e-8 and their classification rules in both inspected versions; historical lower-bound change.
- **COMMUNITY-REPORTED:** 2023 original short-Z G93 speedup, upstream fix.
- **INFERENCE, unverified:** residual between-threshold rotary/linear mismatch could distort intended timing. It is **not** a demonstrated regression of the closed 2023 issue.
- **TEST-CONFIRMED:** none this session. Next high-value test is the four-variant independent canonical-versus-motion trace on qualified isolated compute.
