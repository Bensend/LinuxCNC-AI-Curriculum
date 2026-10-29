# 4400-BRAKE-WEAR-01 — “Brake released” is not “load held”
**2026-10-29 | short technician review card | NOT A TEST INSTRUCTION / NOT SCORED**

**Do not assume a spring-applied brake is installed on OpenPressBrake.** First identify the actual final element from the restricted Stage A [A–G](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md). If no exact spring-applied brake is present, this is cross-machine transfer only. No hazardous operation with people exposed while stop/hold evidence is absent.

| The claim on the screen or service note | What it might establish | What it does **not** establish |
|---|---|---|
| BRAKE OUTPUT OFF | Ordinary controller requested a coil state | Coil de-energized, brake physically engaged, adequate torque |
| RELEASE SWITCH CHANGED | Selected microswitch observed an armature-related condition | Rotor wear within limits or gravity-load holding |
| WEAR SWITCH NORMAL | Selected contact state in its intended *de-energized* evaluation window | Holding torque, healthy friction pair, no mechanical damage |
| BRAKE-CHECKER OK | Selected product's inferred electrical/armature condition | Independently validated load restraint on the selected machine |
| AXIS STOPPED | Position did not visibly change in that observation | It will remain stopped after pressure loss, power loss or disturbance |

**Exact OEM discriminator:** Kendrion BFK468 instructions §5.2.1 warn that its *wear-check* microswitch may momentarily appear at maximum air gap during uneven armature attraction; the manufacturer says to evaluate that signal when the brake is not energized. The same manual calls for air-gap/rotor checks and load separation for inspection. Mayr ROBA-stop-M Type 891.06_.1 instructions require wear/friction/torque maintenance matched to duty; holding-brake conditioning is a **qualified OEM procedure**, not something to improvise on a loaded axis. Read the [original-source audit](../research/4400_BRAKE_WEAR_01_KENDRION_BFK468_MAYR_ROBA_STOP_M_AIR_GAP_SWITCH_AND_HOLD_TORQUE_SOURCE_AUDIT_2026-10-29.md) before acting.

**Low-friction design:** give the maintainer a load-secured inspection position, legible exact brake/rectifier/switch IDs, clear wear-versus-release signal names, accessible OEM service points and a dated inspection record. A nuisance-trip bypass is a design/maintenance defect, not a solution.

**Release gate:** qualified model/variant and safety allocation → independent mechanical/energy isolation → OEM-specified inspection and validated load holding → independent fresh restart. Do not credit LinuxCNC/HAL/FPGA status, a single microswitch, a contactor auxiliary, or a brake's marketing name as physical proof. **All selected OpenPressBrake evidence remains UNKNOWN; G0/G1 HOLD; no personnel-exposed operation.**


**Additional exact-model service trap:** BFK468 §2.1 warns oil/grease on friction surfaces can reduce torque even when an electrical switch appears healthy. Its adjustable **E** version can have spring force/torque reduced; the **N** version differs. A recent lubrication, washdown, brake replacement or adjustment is a **revalidation trigger**, not evidence that holding improved. Keep the machine load supported and use the exact OEM qualified service process; do not “prove” holding by removing the support.


**Maintenance clocks are different:** contactor/relay electrical cycles, brake friction work/rotor wear, and elapsed time since the last qualified load-hold proof must not be collapsed into one “service due” lamp. The exact OEM/SRS determines each inspection/acceptance rule. Record actual service and load evidence in a form the maintainer can use without bypassing the switch.


**Do not swap product-family labels:** Mayr's **ROBA brake-checker** describes sensorless brake condition monitoring (with a variant-specific validation aid), whereas **ROBA SBCplus** is a separate safety-related brake-control product advertised for use up to PL e/SIL CL3 under its conditions. Neither label, nor a copied PL number, establishes actual mechanical holding torque or the complete machine safety function. Confirm the exact article number and applicable validation documents.
