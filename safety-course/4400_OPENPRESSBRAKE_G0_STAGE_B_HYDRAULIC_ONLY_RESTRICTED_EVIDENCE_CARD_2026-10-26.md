# OpenPressBrake G0 Stage B — hydraulic-only evidence card
**2026-10-26 | CONDITIONAL DOCUMENTARY HANDOFF / NOT A TEST OR RELEASE.**

**When to use:** Only after qualified Stage A [one-page A–G request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) confirms that the selected machine has hydraulic Y1/Y2 or another applicable hydraulic hazard. If absent, mark N/A with dated as-built proof. Do not ask operators to fill the 99k-character technical intake as first contact.

## Restricted existing evidence to collect (no energized work)
| Item | Existing drawing/record to provide privately | State |
|---|---|---|
| H1 | Machine/retrofit revision and current as-built Y1/Y2 hydraulic schematic | UNKNOWN |
| H2 | Each cylinder/load direction, mounting and independent mechanical support path | UNKNOWN |
| H3 | Exact directional, holding, counterbalance, check and safety-valve part numbers/suffixes | UNKNOWN |
| H4 | Valve-to-cylinder hose geometry, pilot/drain/return/relief connections, shared zones | UNKNOWN |
| H5 | Accumulators and pressure zones, pressure indication locations and limitations | UNKNOWN |
| H6 | Documented protective-stop vs power-loss vs hose-fault load-retention safety requirements | UNKNOWN |
| H7 | Safety controller/final-element monitoring independent of LinuxCNC/FPGA commands | UNKNOWN |
| H8 | Maintenance personal LOTO, support, pressure-zone verification and rescue concept | UNKNOWN |
| H9 | Any manual release/override, exact restored state, tamper/change records | UNKNOWN |
| H10 | Qualified validation plan with remote/isolation, people excluded, residual risks and separate deliberate restart | UNKNOWN |

## Qualified reviewer decision
Map every claimed STOP, HOLD, BLEED, ACCESS and RESTART function to its **specific** physical element and witness. Reject: “E-stop = hydraulic zero,” “one zero gauge = all zones zero,” “same cartridge cavity = same safety behavior,” “safety valve rated = machine rated,” and “pressure restored = start.” If a holding valve blocks depressurization, **do not remove it** as a shortcut; require an engineered load-support and isolation plan. If bleed would release gravity support, **do not bleed** until independent restraint is established under qualified procedure. No pressures, valve truth tables, PL/SIL or test steps are supplied.

Return to public curriculum only **redacted status IDs** (not drawings, machine secrets, precise terminals, or hazardous service steps). Essential G0/G1 remains HOLD pending coherent qualified evidence; G2 physical validation NOT RUN; G3/G4 NOT AUTHORIZED.

## Evidence basis
[Parker HAS](../research/4400_PARKER_HAS_LOAD_HOLD_CODE_N_MANUAL_RELEASE_PO_CHECK_AND_TRAPPED_PRESSURE_OEM_AUDIT_2026-10-26.md), [Bosch STOM](../research/4400_BOSCH_REXROTH_STOM_HYDRAULIC_STO_SDE_SLS_VS_RAM_HOLD_OEM_SCOPE_AUDIT_2026-10-26.md), [ROSS manual L-O-X](../research/4400_ROSS_HYDRAULIC_LOX_T1_T2_BLEED_VS_CYLINDER_HOLD_ISOLATION_SOURCE_AUDIT_2026-10-26.md), [ROSS HBB/HBH](../research/4400_ROSS_HBB_BLOCK_BLEED_VS_HBH_BLOCK_STOP_MONITORING_AND_LOTO_SCOPE_AUDIT_2026-10-26.md). **DOC-CONFIRMED** exact manufacturer scope, **INFERENCE** conditional intake design, selected-machine evidence UNKNOWN. No tests/compute.