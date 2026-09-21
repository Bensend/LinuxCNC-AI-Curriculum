# Safety curriculum checkpoint — 2026-09-21 11:50Z session

Active level: 4000 safety course / professional machine implementation.

Completed this session:
- Traced the requested third final-element family through SMC pneumatic residual-pressure release valve monitoring, Festo pneumatic functional-safety diagnostic guidance, and Bosch Rexroth hydraulic spool/STOM evidence.
- Added a 25E0 adversarial exercise separating valve position, pressure/stored energy, motion, safety reset and ordinary demand freshness.
- Updated PROGRESS.md.

Durable result:
- Position feedback is a bounded witness, not generic proof of pressure, flow, motion, stored energy, or stopping performance.
- Supply blocking and downstream decompression are separate physical functions.
- Public authoritative valve evidence did not expose one complete universal mismatch-timeout/latch/reset/held-start state machine. The generic valve-reset branch is therefore at an information-gain stop; do not manufacture semantics by copying Siemens 3SK1 or Rockwell SBC behavior.

Exact next work:
1. Rotate to a professional 25E0 implementation combining process evidence (pressure, speed, motion, or equivalent) with final-element status and explicit restart/return-to-service behavior.
2. Prefer an implementation where disagreement between commanded final-element state and process witness has documented fault behavior.
3. Continue asking whether held reset/start/jog/cycle demand survives invalid evidence and becomes effective on recovery.
4. Keep independent personnel-safety authority separate from LinuxCNC/FPGA ordinary-control diagnostics and production gating.
5. Do not invent OpenPressBrake hydraulic thresholds, sequences, stopping distances, PL/SIL, or diagnostic coverage.

Compute: none justified. No GitHub-hosted runner used.
