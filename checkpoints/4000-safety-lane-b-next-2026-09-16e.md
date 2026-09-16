# 4000 Safety Lane B Checkpoint — 2026-09-16e

## Completed

Added `safety-course/GUARD_LOCKING_ESCAPE_RELEASE_RESTORATION_SEMANTICS.md`.

Traced Rockwell 440G-LZ/440G-MZ and EUCHNER CTP/TZ manufacturer evidence to separate guard-position monitoring, guard-lock monitoring, power-to-release versus power-to-lock behavior, escape release, auxiliary/manual release, safety reset and ordinary production rearm.

Frozen safety boundary: a locked guard is not proof that hazardous motion/energy has reached the required safe condition. LinuxCNC/ordinary FPGA may request access and report diagnostics, but personnel-safety unlock permission cannot be manufactured solely from ordinary software/network/HMI state. Machine-specific stopping time, hydraulic decay, gravity behavior and safe-unlock timing remain UNKNOWN pending actual evidence.

Added adversarial cases for power loss, false lock proof, stop-command-as-unlock-proof, escape-release restoration, external reachability, forgotten auxiliary release, held start, stale unlock requests, misleading HMI status, device-rating overclaim, replacement energy-principle changes and invented press-brake unlock delays.

No compute consumed; source/documentation reasoning answered the current question.

## Parallel-lane check

Immediately before the durable write, current `main` still ended at the Lane-B blanking checkpoint; no newer overlapping primary-lane files had appeared. Immediately after the study commit, current `main` contained only the new independent guard-locking study above the prior blanking checkpoint, so no concurrent file reconciliation was required.

## Next independent work

Study **maintenance/setup enabling-device architecture**, centered on three-position enabling devices and deliberate hold-to-run behavior. Trace authoritative manufacturer documentation deeply enough to distinguish released, enabled mid-position, and fully depressed/panic states; restart after release/regrip; mode selection; reduced-risk motion; and the boundary between an enabling device and an E-stop.

Do not invent a safe speed, force, pressure, stopping distance, or press-brake setup-mode truth table. If the primary lane occupies enabling-device work before the next run, rotate instead to trapped-person / whole-body-access detection and restart-prevention architecture.
