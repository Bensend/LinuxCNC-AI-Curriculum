# PLASMA-200 — QtPlasmaC M190 → M66 material handshake (3300, NON-GRADUATED)
Date: 2026-11-04 UTC. Evidence: SOURCE-CONFIRMED for cited development revision; TEST-CONFIRMED: none.

## Scope and provenance
LinuxCNC upstream revision `cdf957bd00bbcc4c569f01e7eed5b154422b816c`:
- [M190 userspace M-code](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/nc_files/plasmac/m_files/M190): `get_material`, `set_material`, `get_change`, `set_change`, `set_timeout`, top-level poll loop.
- [QtPlasmaC handler](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/share/qtvcp/screens/qtplasmac/qtplasmac_handler.py): `material_change_pin_changed`, `material_change_number_pin_changed`, `material_change_timeout_pin_changed`.
- [Metric upstream sample](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/nc_files/plasmac/metric_material_change.ngc): material-change sequence.
- [Conversational producer](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/lib/python/plasmac/line.py): emits same material select/wait/feed prefix.
This source revision is *development*, not evidence for all 2.9.x builds.

## Actual call and signal chain
1. The G-code emits `M190 P<n>` followed by `M66 P3 L3 Q1`, then `F#<_hal[plasmac.cut-feed-rate]>`. This is not just a file annotation: M190 is an external userspace M-code that uses `halcmd getp/setp` to communicate with the QtPlasmaC UI.
2. `M190` parses its first argument as `int(float(sys.argv[1]))`. If requested material differs from `qtplasmac.material_change_number`, it writes `qtplasmac.material_change=1` and the new number. If equal, it writes change=3. It polls while change remains 1 or 3, for at most **0.5 seconds** using wall-clock `time.time()`; on timeout it sets `qtplasmac.material_change_timeout=1`, then sets change=0. Its broad bare `except: pass` and unconditional `exit()` mean command execution returning is **not** proof of successful material selection.
3. QtPlasmaC handler's `material_change_pin_changed` sets `motion.digital-in-03=1` on change=3, then resets the change pin to 0. On change=0 it sets digital-in-03=0. The material-number callback checks existence and changes the material selector (with special pre-file/pre-single-cut handling); an unknown material returns without selecting it.
4. Timeout callback emits an operator error, restores material-change number to the currently selected material, clears timeout and sets `motion.digital-in-03=0`. Source comment explicitly asks whether timeout should stop or pause the program: **no automatic stop claim is justified**.
5. `M66 P3 L3 Q1` is a separate interpreter-level wait for rising edge of digital input 3 with a one-second timeout. The producer does not inspect `#5399` after M66. Thus neither successful M190 process return nor mere passage beyond the M66 line alone proves that the requested material is active. Confirm the exact M66 timeout/return behavior against the version-specific interpreter and runtime before making a stronger claim.

## Failure-oriented implementation exercise (review-only, not run)
Use the upstream metric sample as baseline, with a disconnected QtPlasmaC simulation only after permitted execution isolation is verified. Freeze expected event timestamps and material selection *before* running:
| Case | Stimulus | Required observations | Avoid claiming |
|---|---|---|---|
| A | Requested material already selected | change=3, digital-in-03 rising edge, M66 return and #5399 | M190 return equals material ACK |
| B | Different valid material | change=1 then new number; UI selection, change=3, digital-in-03 transition | material switch atomic with halcmd writes |
| C | Missing material number | UI rejects selection; timeout flag/error; M66 timeout/#5399 | invalid number necessarily stops interpreter |
| D | UI absent or halcmd failure | process exit, pin read/write failure, downstream M66 result | bare except propagates error |
| E | Digital input remains high from earlier program | edge behavior and transition ordering | high level guarantees a *new* rising edge |
| F | Slow UI event loop >0.5 s | M190 timeout and M66 timing | 0.5s and 1s are a single shared deadline |

**Suggested independent oracle:** log HAL pins `qtplasmac.material_change`, `material_change_number`, `material_change_timeout`, `motion.digital-in-03`, selected material display, and interpreter `#5399`; distinguish each from actual torch cut-feed-rate. No physical torch is permitted for this exercise. Do not treat a simulation's synthetic feedback as physical confirmation.

## Engineering implications
A DXF/CAM exporter should output a complete machine-specific material-select/wait/feed/torch lifecycle, not just contours. A generic postprocessor must not assume QtPlasmaC HAL pins exist on another LinuxCNC configuration. For OpenPressBrake, share geometry ingestion and provenance but do not reuse plasma M190/M66 semantics for bend sequence/backgauge transactions. Material-change handshake is a software coordination protocol, not independent personnel safety.

## Evidence ledger and remaining gaps
SOURCE-CONFIRMED: M190 polling/timeout/error swallowing; QtPlasmaC pin callbacks; upstream G-code sequence. INFERENCE: timing races between external halcmd processes and UI callbacks may produce stale edge observations. UNKNOWN: executable state/timing for each scenario, the exact 2.9.10 parity, and an inspectable independent open-source CAM postprocessor. TEST-CONFIRMED: none. No builds, workflows, self-hosted compute or machine activity.

## Adversarial comprehension
Explain why `M190` returning successfully cannot be used as an ACK; distinguish `M66 P3 L3 Q1` from an unconditional pin-level check; identify how an invalid material is handled in the handler; propose a version-pinned observable to prove the feed rate corresponds to the selected material. Answers must cite the source symbols above.
