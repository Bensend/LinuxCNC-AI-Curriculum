# 4400 IFA-VALVE-01 — A certified valve is not a certified ram stop
**2026-10-28; non-executable technician card; NON-GRADUATED.** Read [original M12/M13 audit](../research/4400_IFA_VALVE_01_GS_IFA_M12_M13_COMPONENT_TEST_VS_DIAGNOSTICS_AND_MACHINE_HOLD_AUDIT_2026-10-28.md), [Stage A intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md).

**Exact original IFA distinction:** GS-IFA-M13 (edition **10/2024**) is a testing principle for hydraulic/electrohydraulic directional/blocking valve combinations. GS-IFA-M12 (edition **10/2024**) is specifically for electrohydraulic proportional/servo directional valves with **contact-based interruption of transducer power or an equivalent independent device**. A proportional driver's normal `ENABLE=0` does not itself establish the M12 architecture.

**Both original documents explicitly exclude the valve's fault-detection measures from their basic component testing** (printed p.10 footnotes), and both warn that a successfully tested component still needs the selected control-system category/PL and machine Type-C requirements. A component test is not an installed-machine safety certification.

| Appears safe | What the technician must distinguish |
|---|---|
| Valve has safety label/certificate | Exact variant, options, guideline, restrictions, maintenance and current validity |
| Coil power commanded off | Physical contact-based safety interruption, stored driver energy, pilot/backfeed and valve return |
| Spool feedback indicates safe | Fault detection design versus actual leakage, gravity holding and Y1/Y2 motion |
| Spring return claimed | Verified selected operating envelope, mounting, return timing, safe-state retention and drift |
| Manual override used for service | Protected/non-latching approved override, no bypass of independent personnel-safety authority |
| Same-looking replacement fitted | Changed pilot/ports/connectors/SKU/diagnostics triggers CHG and STALE prior validation |

**Human-factor rule:** provide labeled approved spares, keyed connectors and easy guard reinstallation; do not make jumpering a switch the fastest way to recover production. **No live stuck-valve, ram-drop, guard-bypass or personnel-exposed test** is authorized. A qualified remote/isolated physical test plan and actual independent stop/hold witness are still needed.

**OpenPressBrake selected hardware, M12/M13 certification, Pilz/AKAS program, Y1/Y2 physical stop/hold, guard and evaluator UNKNOWN. G0/G1 HOLD.** No PL or hydraulic threshold inferred.
