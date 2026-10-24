# 4400-GUARD-01 — 14 paper cases: access, escape and fresh restart
**2026-10-24 | PAPER ONLY, NOT PHYSICAL TESTS, NOT BLIND SCORE**

For each case separate: normal request, independent safe-state/guard-lock control, actual physical stop/hold, escape/occupancy, reset and deliberate new motion start. State an unsafe assumption, a falsifier and a safer lower-friction service design.

1. A LinuxCNC HMI offers “Unlock Gate” while the safety controller's safe-input gate has not permitted release.
2. An SDD network command requests release, but the independent S31/S41 signals are not in the permissive state.
3. A technician treats a Pilz Y32 diagnostic bit as equivalent to the two safety outputs 12/22.
4. A gate closes, automatically relocks and the normal CNC resumes the previous program.
5. A rear cell door is power-to-release; power is lost while a worker is inside.
6. A different door is power-to-lock; power is lost while the machine still has dangerous stored energy.
7. A bistable guard lock retains its prior state through loss of power; the HMI displays OFF.
8. An access-side auxiliary release is presented as an emergency inside escape.
9. An auxiliary release was used at standstill but never recommissioned.
10. A fully coded actuator is replaced; a maintenance worker assumes any RFID actuator is accepted.
11. A uniquely coded actuator reaches its learning limit during a hurried repair.
12. A green lock LED remains visible while a warning indicates locking cannot be activated/deactivated.
13. The guard is cumbersome to reinstall and technicians have begun wedging it open.
14. A guard and safety PLC work as documented, but a retrofit bypasses the downstream final-element circuit.

**Assessment gate:** do not claim physical proof from an LED, status tag or paper case. No machine-specific stopping distances, lock release timings, PL or SIL are supplied. Fresh external evaluation must use novel cases, not these learner-visible examples. Actual OpenPressBrake Y1/Y2 independent stop/hold/guard/restart UNKNOWN; G3/G4 NOT AUTHORIZED.
