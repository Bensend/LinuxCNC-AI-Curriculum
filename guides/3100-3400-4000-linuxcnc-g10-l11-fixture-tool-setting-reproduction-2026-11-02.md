# 3100 / 3400 / 4000 — G10 L11 fixture tool-setting reproduction card (168)

**Scope:** LinuxCNC mill/router tool calibration; isolated interpreter and disposable simulated tool table **only**. Pinned stable **v2.9.10**; development comparison **67437d8865e431a9a33f74cee912dbf891d3b4c5**. SOURCE/DOC-CONFIRMED; **NOT EXECUTED**.

## Mechanism to teach
`G10 L10 P1 Z...` calculates a tool-table value in the **currently active work coordinate system**, including G92; `G10 L11 P1 Z...` calculates using **G59.3 as a fixed tool-setting fixture**, excluding active G92. Neither selects G59.3 nor inherently executes a tool move. The stored tool table (`#5403`) and applied tool compensation (`#5083`) are distinct. An explicit G43 reload is part of the calibration workflow when needed. Reference [source audit](../research/4400_LINUXCNC_G10L11_168_FIXTURE_TOOL_CALIBRATION_AND_UPSTREAM_ORACLE_SOURCE_AUDIT_2026-11-02.md).

## Reproduce the existing upstream oracle (pending qualified isolated compute)
1. Use a **disconnected** LinuxCNC run-in-place environment built at v2.9.10; no access to motion hardware. Copy upstream `tests/interp/g10/g10-l11/` to a disposable directory. The upstream `test.tbl` contains one tool: `T1 P1 X0 Y0 Z0 ;`.
2. Inspect `test.ngc`, `test.sh`, `expected` **before** executing; no blind scoring is claimed. Do not use an operator's real `tool.tbl`.
3. From that directory with the run-in-place `rs274` on PATH:
   ```bash
   ./test.sh > actual
   rc=$?
   printf 'rs274/test.sh exit=%s\n' "$rc"
   test "$rc" -eq 0 && diff -u expected actual
   ```
   Preserve full stdout, exit status, diff, LinuxCNC binary version, Git SHA, environment, start/end timestamps, and actual self-hosted job duration if a job is dispatched.
4. The frozen expected canonical trace contains tool Z=-3 for `G10 L11 P1 Z0` at machine Z=-30/G59.3 Z=-27; Z=-4 for Z1. The same pair repeats after G92 is enabled and active G54/G55 are changed. **This is inspected upstream expected output, not our runtime observation.**
5. Do not interpret the `STRAIGHT_TRAVERSE` canonical messages as proof of machine movement. Do not run the upstream G-code on hardware.

## New extension to justify a separate test only if evidence gain remains
**A: fixture rotation.** In a disposable copy, set `G10 L2 P9 X... Y... R30` (G59.3 rotation) and choose a known nonzero X/Y tool offset. Compare `G10 L11 P1 X0` against `G10 L11 P1 X0 Y0`. Freeze numerical expected values using an independently reviewed coordinate transform **before** running. Verify that X-only preserves the tool component along *rotated fixture Y*; not merely the original unrotated Y. Use fresh interpreter/tool-table state per case.

**B: stored versus applied.** In a simulated machine fixture (not `rs274` alone), explicitly load T1/G43, capture `#5403` and `#5083`, edit L11, capture both again, then reload G43 and capture again. Confirm the tool-table edit and applied-offset update are not conflated. Verify no motion is implied by a tool-table mutation. Mark status UNKNOWN until executed.

**C: development-only tilted-plane rejection.** On pinned development, set up valid G68.2 tilted work plane and attempt L11; inspect the exact error. Stable lacks this explicit guard, but do not assume a stable tilted-plane runtime equivalence.

## Technician interpretation / failure triage
If a tool's measured length changes with active G54/G55 or G92, first inspect whether the macro used L10 instead of L11, and verify G59.3 fixture origin and its rotation. If the stored offset changed but the machine still uses an older value, compare `#5403` with `#5083` and G43 state. Confirm units, loaded-tool identity and table persistence. Do not apply a real probe or motion until machine-specific commissioning and independent personnel safety are established.

**Status:** A/B/C NOT RUN; upstream source/expected inspected, no local LinuxCNC execution, no Actions, no compute. Previously graduated course levels and external safety/evaluator gates unchanged.
