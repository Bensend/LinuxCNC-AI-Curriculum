# 4000 safety checkpoint — final-element physical sequence

UTC checkpoint: 2026-09-20T10:44Z

## Durable state

Completed cross-domain comparison in `safety-course/FINAL_ELEMENT_WITNESS_EDM_STO_HYDRAULIC_POSITION_COMPARISON_2026-09-20.md`.

Key freeze:

- `STO REQUESTED != STO ACTIVE != TORQUE DISABLED != AXIS STATIONARY != LOAD RETAINED != ELECTRICAL ENERGY ISOLATED`.
- `VALVE COMMAND OFF != SOLENOID DE-ENERGIZED != SPOOL/POPPET IN EXPECTED POSITION != HYDRAULIC FLOW BLOCKED != PRESSURE REMOVED != RAM PHYSICALLY STOPPED/RETAINED`.
- Do not collapse heterogeneous final-element witnesses into generic `SAFE=true`.

## Exact next work

Trace one complete manufacturer sequence for either:

1. drive STO + safety brake/gravity-axis retention, or
2. hydraulic valve position monitoring + independent pressure/motion witness.

Prefer a sequence that exposes request, independent status/feedback, mismatch timeout/fault, restart inhibition, recovery/requalification, and the physical acceptance test still required beyond feedback.

Do not accumulate generic status-bit tables. No compute is currently justified.
