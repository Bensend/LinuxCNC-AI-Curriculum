# 4400 technician worksheet — Stop request, safe access, inside escape and restart

**Status:** LEARNER PRACTICE / NOT BLIND / NOT RUN. This is a design-review exercise, not a live-machine procedure. Read `../research/4400_NORMAL_UNLOCK_VS_ESCAPE_RELEASE_TEMPORAL_PROOF_2026-10-22.md` and the pinned manufacturer manual. Do not use this worked curriculum as a sealed external evaluator challenge.

## Generic case

A machine has a hazardous actuator, an independently controlled guard lock with an inside escape release, an ordinary LinuxCNC HMI, and stored mechanical or fluid energy. The HMI shows `GUARD OK` and `STOP REQUESTED`. The actual stopping and holding performance, gate-opening force, physical occupancy and stored-energy connectivity are UNKNOWN. The machine may be a press brake, robot cell, mill, lathe or plasma table; the physical hazards differ.

Fill this evidence matrix without inventing thresholds or assigning personnel-safety authority to ordinary LinuxCNC:

| Event/proposition | Demand/authority owner | Exact feedback target | Required physical witness | Residual hazard/UNKNOWN | `BND/SF/PHY/SRS/AUTH/DEP/VAL` IDs |
|---|---|---|---|---|---|
| Normal outside access requested | | | | | |
| Protective stop requested | | | | | |
| Final element expected state | | | | | |
| Actual hazardous motion/energy safe for access | | | | | |
| Ordinary unlock permitted | | | | | |
| Inside escape release operable without tools | | | | | |
| Physical egress possible under credible gate load | | | | | |
| Space clear/occupancy condition for restart | | | | | |
| Deliberate independent safety reset | | | | | |
| Separate ordinary cycle start | | | | | |
| Maintenance isolation/restraint and verification | | | | | |

## Three adversarial cases

**Case 1 — Escape during an incomplete stop.** A person inside actuates the mechanical escape release. The lock releases and FO outputs switch OFF, generating a stop demand. The actuator is still coasting or a vertical load can drift. Explain why this does not establish that normal outside entry should have been authorized. Identify what protection must be designed for emergency egress while motion/energy may remain.

**Case 2 — Plausible feedback, failed physical witness.** The lock monitor says locked, the standstill monitor says standstill and the HMI says safe, but an independent beam displacement observation indicates drift or the gate cannot be opened from inside. Specify which narrow diagnostic propositions can remain supported, which physical propositions are NOT ESTABLISHED, and what operation must remain blocked pending safe investigation.

**Case 3 — Power restoration and maintenance.** After power restoration, the guard is closed, the escape release has been reset and a cycle-start request remains HIGH. A pressure gauge at one tap reads zero. Explain why this does not prove the guarded space empty, safe rearm, all-zone hydraulic depressurization, or permission for servicing. Preserve individual energy-control and mechanical restraint requirements where applicable.

## Review criteria (learner-visible, not an evaluator answer key)

The design review is incomplete if it merges normal unlock with inside escape, treats a stop demand as proof of completed stopping, substitutes one pressure tap for every stored-energy zone, treats guard lock monitoring as proof of physical egress, permits retained-start restart on reset, invents numeric physical criteria, or makes LinuxCNC/HAL/ordinary FPGA the sole personnel-safety authority.

Propose two inexpensive usability improvements that reduce predictable safeguard defeat without weakening the required protection. Record new failure modes introduced by each improvement and a practical way to detect them. Carry unresolved physical evidence as `UNKNOWN` and prohibit people-exposed operation until the basic protection propositions are established.
