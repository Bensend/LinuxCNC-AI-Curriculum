# G84/G74 multi-spindle plane-selection acceptance — disconnected review
**2026-10-31 | ALL NOT RUN**

Read [TAP-74](../research/4400_LINUXCNC_TAP_74_G84_SELECTED_SPINDLE_DIRECTION_UV_YZ_SOURCE_AUDIT_2026-10-31.md). Compare stable v2.9.10 peeled `86cdca76fa2a36274c432caa21952b23c267989a` and development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. Official G84 is **floating-chuck tapping**, not G33.1 rigid synchronization. Use a software-only interpreter fixture with two simulated spindle direction states and a copied INI supporting G19; do not use actual spindle motors.

| Case | Initial spindle0 | Selected spindle1 | Plane | Predeclared source-level direction check |
| --- | --- | --- | --- | --- |
| TAP1 | STOPPED | CLOCKWISE | G19 YZ, G84 $1 | wrongly reads spindle0 STOPPED; reject |
| TAP2 | CLOCKWISE | STOPPED | G19 YZ, G84 $1 | wrongly reads spindle0 CLOCKWISE; check passes |
| TAP3 | STOPPED | CLOCKWISE | G17 XY, G84 $1 | reads spindle1 CLOCKWISE; check passes |
| TAP4 | CLOCKWISE | STOPPED | G17 XY, G84 $1 | reads spindle1 STOPPED; reject |
| TAP5 | STOPPED | COUNTERCLOCKWISE | G19 YZ, G74 $1 | wrongly reads spindle0 STOPPED; reject |
| TAP6 | COUNTERCLOCKWISE | STOPPED | G19 YZ, G74 $1 | wrongly reads spindle0 COUNTERCLOCKWISE; check passes |

Use fully specified valid cycle geometry, feed, R and P as required by the pinned interpreter; verify G19 configuration and spindle setup **before** scoring. Capture canonical command list, parser return/error, selected spindle index and initial direction state. A direction-check PASS does **not** prove downstream execution, correct synchronization or physical spindle motion. Do not execute on hardware. Only `[self-hosted, openpressbrake]` with independently established isolation is eligible for future compute; no GitHub-hosted Actions.
