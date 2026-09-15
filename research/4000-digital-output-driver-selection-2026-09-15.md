# 4000 protected digital-output driver selection — 2026-09-15

Status: WORKING SELECTION — high-side/sourcing base outputs preferred; isolation implementation still open.

## Why sourcing/high-side wins the base design

Mesa's 7I77 documentation states the practical fault-containment advantage directly: sourcing field wiring is less likely to cause unintended actuation from a short-to-ground, the common field-wiring fault. Sinking outputs remain useful for retrofit compatibility, but that does not outweigh making the new generic board's normal output architecture predictable.

Therefore the base 16-output bank should be **24-V sourcing/high-side**. Legacy sinking loads can use an external relay/interface or a later dedicated retrofit variant rather than making every output topology ambiguous.

## Working smart-switch family

**TI TPS4H160-Q1 A-version** is the preferred first schematic candidate for the ordinary output bank.

Manufacturer-supported characteristics:
- active/current product;
- four high-side channels/package;
- 3.4-40 V operating range;
- 160 mOhm typical integrated switches;
- adjustable current limit, with published 0.25-A lower current-limit class;
- short-to-ground/overcurrent protection;
- thermal shutdown/latch-off options;
- inductive-load negative-voltage clamp;
- loss-of-ground/loss-of-battery protection;
- open-load/short-to-battery diagnostics;
- global fault indication;
- A-version provides digital diagnostic output.

Reference: https://www.ti.com/product/TPS4H160-Q1

Four devices provide 16 outputs. This is not yet a final procurement freeze; exact suffix/package and thermal/current-limit design need the schematic/BOM calculation pass.

## Why not simply choose the highest-current industrial switch

ST IPS2050H is an excellent industrial/numerical-control high-side reference with 8-60 V supply, strong IEC transient design intent, per-channel overload/thermal diagnostics and 2.4-A/channel capability. That current class is useful for larger solenoids but excessive for every general I/O point and increases fault energy. It remains a strong candidate for a separate **high-current auxiliary output block**, not the ordinary 16-output bank.

Reference: https://www.st.com/en/power-management/ips2050h.html

## Output contract implications

The smart switch's internal protection is not enough by itself. Normal output authority must be:

`LinuxCNC command -> FPGA output bit -> FPGA-local watchdog/enable gate -> isolation boundary -> smart-switch IN -> field output`

Watchdog/reset gating must remove the smart-switch input command even if the host-side command register still contains ON.

Diagnostic return is separate:

`smart-switch diagnostic -> isolation boundary -> FPGA diagnostic -> host VALID/FRESH`

A driver diagnostic can prove electrical fault classes but still cannot prove a relay moved, valve shifted, contactor closed, clamp engaged, etc. Those require independent field inputs.

## Isolation architecture still open

The base field I/O requirement remains galvanic isolation, but this pass does **not** freeze whether isolation is per-channel optocoupling or a grouped isolated field-side logic domain. Forty direct isolation channels (24 inputs + 16 output commands, plus diagnostics) may be unnecessarily expensive and pin-heavy. A grouped field-side I/O architecture could be cleaner, but only if its local communications watchdog and stale-command behavior are explicit and deterministic.

This is now the main DIO architecture question. Do not draw the final DIO schematic until it is resolved.

## Current limit / load classes

Do not claim every ordinary output can directly drive every machine solenoid. Working general-purpose target remains roughly Mesa-class sub-amp loads. The exact current limit should be selected after inventorying common relay coils, contactor coils, small pneumatic/hydraulic solenoids and indicator loads. Larger loads should use interposing relays or the later high-current output variant.

## Verification

- REFERENCE-PROVEN: sourcing industrial CNC output architecture and protected-output behavior from Mesa production interfaces.
- DATASHEET: TPS4H160-Q1 protections/diagnostics/electrical envelope.
- CALCULATION: per-channel current limit, Rds(on) dissipation, simultaneous-load thermal envelope, clamp energy.
- FAULT/INTEGRATION: short-to-ground, open load, overtemperature simulation/bench where practical; FPGA watchdog must force OFF and require rearm.

## Next

Resolve grouped-isolation versus per-channel-isolation architecture and select the 24-V input receiver. Then freeze the complete 4300-DIO block.
