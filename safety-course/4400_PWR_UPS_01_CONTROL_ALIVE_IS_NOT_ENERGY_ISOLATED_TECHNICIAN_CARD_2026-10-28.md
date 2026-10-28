# 4400 PWR-UPS-01 — Control still on ≠ machine safe
**2026-10-28 | technician/qualified reviewer card | PAPER ONLY / NOT A LIVE TEST**

Read the [original-source audit](../research/4400_PWR_UPS_01_PILZ_PHOENIX_ROCKWELL_SEPARATE_24V_DOMAINS_AND_BUFFERED_POWER_AUDIT_2026-10-28.md) after [RST-01](4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md) and [PANEL-01](4400_PANEL_01_MULTIFEED_SCCR_ARC_FLASH_ISOLATION_AND_RAM_HOLD_MODULE_2026-10-25.md). **Do not energize, jog or remove a fuse to fill this card.**

## Three separate questions
**What remains powered?** Trace the actual AC isolator, 24 V PSU(s), UPS/battery, safety controller A1/A2, safety output feed, sensor/actuator feed, contactor/valve coils and any independent holding energy. An HMI still showing data proves neither main AC availability nor hydraulic ram hold.

**What decides personnel safety?** The qualified independent safety chain and selected physical final elements, not LinuxCNC, normal FPGA, HMI or UPS telemetry. A safety program/LED that is RUN does not prove that every output supply is present; an OFF command does not prove every load has lost energy.

**What permits a new cycle?** After an interruption, establish safeguard/area status, physical stop/hold and independent safety rearm; require a **separate deliberate fresh motion start**. A retained pedal request or automatic PC reboot is not an authorized start.

## Unpowered desk-review checklist
| Reviewer question | Required evidence / status until supplied |
|---|---|
| Is any UPS/battery installed? Which exact loads and DC rails does it feed? | As-built power drawing, battery and UPS label; **UNKNOWN** |
| Does a safety controller have separate logic/output supply terminals? | Exact installed manual and terminal diagram, not generic Pilz example; **UNKNOWN** |
| Is a rail still energized when the main disconnect is open? | Qualified isolation plan for **all** sources, not a live field experiment; **UNKNOWN** |
| Can control and output rails return in different order? | Selected controller fault/rearm documentation and qualified review; **UNKNOWN** |
| Are actuator coil/valve states physically verified, not inferred from a status bit? | Independent final-element and hydraulic/gravity hold witness; **NOT RUN** |
| Does a restart require a new operator action after all safety conditions? | Selected reset and normal-start path, including retained command; **NOT RUN** |
| Can an operator isolate the machine without discovering a hidden battery by surprise? | Clear labels, accessible lockable points and short service card; **UNKNOWN** |

**Avoid the easy-but-unsafe shortcut:** Do not wire a backup supply to every control output simply to prevent nuisance resets, or assume that killing 24 V always holds a gravity-loaded ram. Choose and validate the physical safe state first. Make source labeling, approved isolation and restart simple enough that technicians will use them.

**Evidence classes:** manufacturer supply examples **DOC-CONFIRMED**; the cross-domain scenarios **INFERENCE**; installed OpenPressBrake facts **UNKNOWN**; physical and evaluator results **NOT RUN**. **G0/G1 HOLD; no personnel-exposed hazardous operation.**

**Exact-part compatibility trap (desk calculation, not a machine test):** Pilz B0 nominal 24 V with −20% lower tolerance means **19.2 V minimum**; Phoenix TRIO-UPS 2907160 lists **18 V minimum battery-mode output**. If these *specific* devices were connected directly, the published ranges alone would **not guarantee** operation across the full battery envelope. The Pilz **furnace/EN 298-specific** 20 ms secondary-buffer statement and Phoenix <75 ms switch-over specification are different quantities; neither proves an actual voltage gap or actual compatibility. Check selected SKU, wiring, regulation and qualified manufacturer acceptance instead of probing an energized safety circuit. See [source-depth calculation](../research/4400_PWR_UPS_01_PILZ_PHOENIX_ROCKWELL_SEPARATE_24V_DOMAINS_AND_BUFFERED_POWER_AUDIT_2026-10-28.md).
