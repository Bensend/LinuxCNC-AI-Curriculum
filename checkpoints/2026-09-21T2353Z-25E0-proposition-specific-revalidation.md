# 25E0 continuation checkpoint — proposition-specific revalidation

UTC checkpoint: 2026-09-21T23:53Z

## Completed
Machine-tool-oriented supported-exception evidence is now sufficient for the current branch. `safety-course/25E0_MACHINE_TOOL_SAFE_LIMITED_SPEED_ACCESS_AND_RETURN_2026-09-21.md` records Rockwell Kinetix SLS + door + enabling-switch access/return behavior, Rockwell assist/production machine architecture, and Siemens SINUMERIK setup SLS evidence.

Do not repeat generic robot-teach or machine-tool safe-speed searches unless new evidence answers a concrete unresolved question.

## Exact next work
Build a proposition-specific revalidation-after-exception/change method. For each modification or exceptional state, explicitly map:

`change -> evidence/proposition invalidated -> required physical re-proof -> acceptance authority -> reset/rearm -> fresh ordinary demand`

Stress-test at minimum:
1. hydraulic/gravity axis: valve or brake replacement, hydraulic plumbing change, pressure witness change, temporary jumper/force;
2. rotating/servo machine: encoder/speed-monitor replacement or configuration change, drive/safety parameter change, guard sensor replacement, temporary simulated witness.

Separate component diagnostic health from final-element physical state, process response, stopping performance, configuration identity, and production demand freshness. A safety-critical UNKNOWN blocks the dependent acceptance claim.

No machine-specific safe speed, pressure threshold, stopping distance, PL/SIL, hydraulic truth table, or diagnostic coverage may be invented.

## Compute
No executable compute is justified by this checkpoint. Continue source/engineering work. If a later concrete question genuinely requires compute, use only `[self-hosted, openpressbrake]`; never GitHub-hosted runners.