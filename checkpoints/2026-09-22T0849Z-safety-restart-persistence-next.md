# 4000 Safety checkpoint — restart persistence / next

Completed this session:

- Added `safety-course/OPEN_SAFETY_OBLIGATION_HANDOFF_RECORD.md`.
- Added `safety-course/25E0_RESTART_PERSISTENCE_AND_DIAGNOSTICS_VS_PHYSICAL_PROOF_2026-09-22.md`.
- Traced Rockwell Guardmaster/SC300/POINTMax and Pilz feedback-loop/PZE evidence establishing that healthy safety logic/output diagnostics do not automatically prove external final-element or downstream physical process propositions.
- Stress-tested ordinary LinuxCNC/HMI reboot with an open stale physical proposition.
- No executable compute was justified; no GitHub-hosted runner was used.

Next work:

1. Authoritative restart/recovery behavior after safety-controller or safety-I/O power loss: separate diagnostic recovery, acceptance/re-proof, reset/rearm, and fresh ordinary production demand.
2. Learner exercise comparing independent safety-controller state, durable maintenance/safety ledger state, and volatile LinuxCNC/HMI state.
3. Extend physical-proof boundary to a professional drive/brake/valve example rather than assuming contactor EDM proves process safety.

Hard boundary: missing persistent state is `UNKNOWN`, not implicit clearance. Preserve machine-specific physics and do not invent PL/SIL, stop distance, pressure, proof interval, or hydraulic truth-table values.
