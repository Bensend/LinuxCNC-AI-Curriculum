# 4400-M60-M30-01 — Pallet-change text is not a pallet-change witness
**Open-book technician review | 2026-10-29 | NON-GRADUATED | paper-only; no live machine commands**

Read the [pinned-source investigation](../research/4400_M60_M30_01_LINUXCNC_2910_PALLET_SHUTTLE_STUB_VS_DOCUMENTED_EXCHANGE_AND_PAUSE_SOURCE_AUDIT_2026-10-29.md), [APC-01 original-OEM pallet-change audit](../research/4400_APC_01_HAAS_PALLET_CHANGER_EARLY_CLAMP_SENSOR_HYDRAULIC_REVERSE_AND_SERVICE_JUMPER_OEM_AUDIT_2026-10-27.md), and [normal pause/access composition](4400_NORMAL_SEQUENCE_WAIT_PAUSE_JOG_FALSE_SAFE_ACCESS_COMPOSITION_REVIEW_2026-10-27.md). These are unscored transfer prompts, **not** a blind external evaluation or a machine commissioning procedure.

## The first question
A retrofit programmer sees `M60` described in the manual as "exchange pallets and pause." The HMI shows **PAUSED**. What can be concluded?

**Answer:** The inspected stock LinuxCNC v2.9.10 canonical `PALLET_SHUTTLE()` is an unimplemented no-op; stock `M60` then issues an ordinary pause. It does **not** establish that any pallet moved or clamped. If a machine has a custom remap/external controller, its actual behavior is **UNKNOWN** until inspected. PAUSED is not an independent protective stop or permission to enter the cell.

## Four quick desk checks (no energized access)
1. **Default M60:** Locate `convert_stop`, `PALLET_SHUTTLE`, `PROGRAM_STOP` and Task's `EMC_TASK_PLAN_PAUSE`. Identify exactly which one would need to move the pallet and why it does not in stock source. Explain why spindle/coolant state is not automatically changed by M60.
2. **M30 versus M60:** Explain why M30 ends and resets normal program/spindle/coolant state but stock M30's pallet function is the same no-op. A program-end status does not witness a pallet exchange.
3. **Configured M60 remap:** Find the selected INI `REMAP=M60` entry (if any), actual NGC/Python handler, PLC/HAL outputs, completion conditions and abort behavior. A remap **replaces** the stock stop branch; do not assume it preserves a pause or guards people.
4. **Stale "pallet changed":** A sensor remains HIGH after power cycling. Describe how an ordinary sequence might falsely advance, then identify distinct independent safety access/guarding and physical clamp/retention evidence. Do not invent a sensor truth table or assign a PL/SIL.

## Minimal safe integration checklist
| Boundary | Must establish | Not sufficient |
|---|---|---|
| Ordinary LinuxCNC | exact code/remap version, requested action, timeouts, phase and abort handling | `M60` or `M30` text; Task PAUSED/ENDED |
| Physical equipment | pallet identity, position, clamp/retention, and load-station geometry | generic "done" bit or single ambiguous proximity input |
| Independent personnel protection | selected guard/interlock, hazardous-motion stop/hold, stored-energy control, restart/rearm | normal HAL, FPGA, G-code or HMI "safe" indicator |
| Maintenance/commissioning | qualified isolation and separately authorized physical verification | opening the cell after a normal pause |

**Safer default:** where the machine has no implemented exchange, expose `EXCHANGE NOT IMPLEMENTED` instead of a green "Pallet Changed." Where it has a real changer, present **REQUESTED / MOVING / POSITION UNKNOWN / CLAMP VERIFIED / SAFETY ACCESS PERMITTED** as separate, provenance-tagged states. Never use an ordinary state as the sole authority for personnel entry.

**Status:** SOURCE-CONFIRMED pinned stock implementation; DOC-CONFIRMED official manual/remap documentation; TEST-CONFIRMED none; INFERENCE failure paths; selected machine and physical safety UNKNOWN. Existing OpenPressBrake G0/G1 HOLD remains unchanged. No personnel-exposed hazardous operation is authorized by this lesson.
