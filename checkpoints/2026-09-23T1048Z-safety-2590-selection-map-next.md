# Safety curriculum checkpoint — 2590 safeguard selection map next

## Durable state

2580 passed its learner-facing coverage audit and is READY FOR EXTERNAL/FRESH EVALUATION with a canonical route and no-solution evaluator handoff. Do not self-score it.

2590 source preparation now separates physical guard, interlock, guard lock and presence-sensing propositions. Manufacturer evidence anchors separate interlocking/guard-locking functions, application-specific locking force, escape/release distinctions, and ISO 13855-style dependence on actual stopping behavior and approach geometry. Pass-through/inside-zone occupancy, reset visibility and foreseeable defeat are explicit design concerns.

## Exact next work

1. Build a safeguard-selection map for fixed guards, movable interlocked guards, guard locking, light curtains/scanners, two-hand controls and enabling/hold-to-run controls.
2. For each, state the physical proposition, appropriate lifecycle/use case, important failure/defeat path, and what the device cannot prove by itself.
3. Add authoritative two-hand concurrent-operation/anti-tie-down evidence and enabling-device evidence.
4. Add an adversarial defeat analysis comparing simple mechanical actuators with coded/non-contact devices without claiming coding makes defeat impossible.
5. Teach minimum-distance reasoning symbolically and with one sourced example; actual machine stopping distance remains UNKNOWN without measurement/validation.
6. Treat pass-through/inside-zone occupancy and reset visibility/restart prevention as architecture questions.
7. Preserve maintenance isolation as separate from production safeguarding and LinuxCNC/FPGA as ordinary control/diagnostics rather than sole safety authority.

## Compute

No executable compute is currently justified. Do not use GitHub-hosted runners. Any future justified compute must target `[self-hosted, openpressbrake]` only.
