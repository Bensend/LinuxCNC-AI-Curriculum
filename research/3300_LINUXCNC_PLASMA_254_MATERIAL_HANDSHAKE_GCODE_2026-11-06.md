# PLASMA-254 — QtPlasmaC material handshake is part of the CAM contract (2026-11-06)

**Status:** SOURCE-CONFIRMED for generator output, INFERENCE for downstream runtime handshake, NON-GRADUATED. No machine operation, simulator, build or hosted runner.

## Why this is the next useful LinuxCNC question
PLASMA-252/253 established the geometric DXF-to-G-code boundary. Geometry alone is insufficient: a correct contour can still run at the wrong plasma cut feed, pierce settings or material. Inspect the *actual generated G-code* before inventing a new postprocessor. This investigation isolates the material-to-motion boundary rather than claiming turnkey nesting or QtPlasmaC integration.

## Immutable source evidence
LinuxCNC **v2.9.10**, `lib/python/plasmac/circle.py`, Git blob **f22a91d119d120fa3123628b482df3c6e6750ed6**, function `preview`, approximately lines 136–191: [pinned source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/python/plasmac/circle.py).
QtVCP caller `lib/python/qtvcp/lib/qtplasmac/conv_circle.py`, blob **0f4c9d356ec8037bf84f2deca53f4dcb30f09ce0**, `preview`: passes selected material number and name plus kerf width, leads, small-hole parameters: [pinned source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/python/qtvcp/lib/qtplasmac/conv_circle.py).
The generator source was read at the pinned tag; blob SHA from the GitHub contents API. The caller was read at the same tag and its blob SHA from the pinned directory listing.

## Source trace: generated program contract
The generator emits, **in this order**, a comment identifying the selected material, `M190 P<material number>`, `M66 P3 L3 Q1`, and `f#<_hal[plasmac.cut-feed-rate]>` before rapid approach and `m3 $0 s1` torch start. It then emits G2 for external circular contours, G3 for internal ones, and `m5 $0` after the contour. For small holes it can emit `M67 E3 Q<smallHoleSpeed>` after torch start and `M68 E3 Q0` after torch stop. For certain internal overcuts it emits `m62 p3` before extra G3 motion. These are **observed emitted tokens**, not a general claim that every external G-code program must use identical commands.

**Key inference:** `M190` selection followed by `M66` waiting and HAL-derived feed is a process synchronization boundary. A DXF postprocessor that merely emits `F1000` and `M3` omits this generator's material-dependent feed behavior. Conversely, inserting a hardcoded `F` after the HAL-derived feed may override it. The exact `M190` implementation, `M66 P3` signal source and timing, and QtPlasmaC filter acceptance remain **OPEN** until inspected separately. Do not assert that one-second Q1 always suffices or that all material changes complete.

**Potential source defect to verify, not assume:** In the internal-overcut branch, the code assigns `Torch = False` (uppercase) but later tests lowercase `torch`, initialized `True`. The post-overcut `m65 p3` recovery branch therefore appears unreachable along this path in the inspected source. This is a SOURCE-CONFIRMED spelling difference and an INFERENCE about resulting control flow, **not** an executed machine defect; validate intended digital-output semantics and upstream tests before escalating. It may be deliberate behavior or a defect, and must not be silently patched in curriculum evidence.

## Practical offline integration exercise
Given material 17, a valid closed DXF contour and millimeter units, compare a proposed external post against the following **ordered token contract** (not a complete program):
```ngc
;using material #17: EXAMPLE
M190 P17
M66 P3 L3 Q1
f#<_hal[plasmac.cut-feed-rate]>
g0 x10 y20
m3 $0 s1
; valid contour motion here
m5 $0
```
The example name, coordinates and material ID are illustrative, **not** a machine-ready cut file. Acceptance: explicit material ID; material-ready wait preceding feed retrieval; cut feed from HAL; torch off after contour; no second kerf compensation; proper unit mode and arc center convention. Negative tests: missing M190, wait after M3, hardcoded feed override, missing M5, small-hole override without reset, output-state restoration after overcut. A parser can inspect tokens without starting LinuxCNC; such inspection would validate formatting, **not** realtime behavior.

## Provenance ledger and unresolved dependencies
| Claim | Class | Evidence | Remaining verification |
|---|---|---|---|
| Material number is passed from QtVCP to geometry generator | SOURCE-CONFIRMED | conv_circle.py `preview` | Runtime UI selection |
| M190 → M66 → HAL feed → torch start sequence | SOURCE-CONFIRMED | plasmac/circle.py ~136–160 | Interpreter/filter and HAL behavior |
| Small-hole feed override and reset tokens | SOURCE-CONFIRMED | plasmac/circle.py ~150–191 | Hardware output behavior |
| Internal-overcut `Torch`/`torch` mismatch | SOURCE-CONFIRMED spelling; INFERENCE control flow | plasmac/circle.py ~176–194 | Independent executable regression |
| External DXF/CAM can use this as a compatibility baseline | INFERENCE | generator trace | Actual imported G-code and simulation |

## Next precise checkpoint
1. Trace the **actual** QtPlasmaC `M190` and `M66 P3` implementation, including named HAL signal, material reload and error/timeout behavior, from pinned v2.9.10 source/config; distinguish LinuxCNC core `M66` from QtPlasmaC conventions.
2. Inspect a real open-source nesting implementation (algorithm, license, geometry representation, holes and islands) before proposing a binding to DXF geometry.
3. If source is available, add a tiny *offline* token fixture with explicit expected results; do not call it a LinuxCNC simulation. Rotate to HostMot2/4000 if evidence gain stalls.
4. Preserve graduated levels, independent personnel-safety authority, blind gates, self-hosted-only compute policy and hourly cadence.
