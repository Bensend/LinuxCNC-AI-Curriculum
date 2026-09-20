# 4000 safety checkpoint — unmasked primary/secondary stop witness

## Durable advance

Added `safety-course/PRESS_BRAKE_PRIMARY_SECONDARY_STOP_UNMASKED_PHYSICAL_WITNESS_TRACE_2026-09-20.md`.

FoldSafe PB-series documentation closes an important dynamic-proof gap: its secondary stop test deliberately keeps the normal Down valve open while closing the secondary safety valve or stopping the pump, then measures actual beam stopping distance. This is a real press-brake example of preventing the normal path from masking a redundant-path failure and using a physical motion witness.

Freeze:

`SECONDARY STOP COMMAND != NORMAL PATH MASKED OUT != SECONDARY FINAL ELEMENT ACTED != BEAM PHYSICALLY STOPPED != STOP DISTANCE ACCEPTABLE != NORMAL OPERATION AUTHORIZED`.

Also preserve:

`UNMASKED DYNAMIC SECONDARY-STOP PASS != STATIC LOAD-RETENTION PASS != SERVICED HOLDING-VALVE INDIVIDUALLY LOAD-PROVED`.

## Exact next work

1. Keep the primary hydraulic post-service lane active: locate a press-brake OEM/manifold procedure naming a serviced holding/safety valve and requiring an individual post-reassembly retaining/load challenge with companion masking controlled, physical ram/load witness, pass/fail disposition, and rearm/return-to-production sequence.
2. Use the FoldSafe source as a pattern for **unmasked dynamic path proof**, not as a substitute for static retention proof.
3. Determine whether any press-brake OEM ties replacement/service of the secondary/holding/safety valve to rerunning this kind of start-up/stop-distance test.
4. Continue the two-hand total-response chain when hydraulic source gain stalls; preserve logic-state, final-element-state, and physical-stop evidence as separate gates.
5. Do not invent OpenPressBrake hydraulic topology, acceptance distances/times, static drift limits, PL/SIL/category, or production-rearm policy.

## Compute

No simulation/build/test compute was used. Do not use GitHub-hosted runners. If a concrete unresolved question later justifies compute, use `[self-hosted, openpressbrake]` only.
