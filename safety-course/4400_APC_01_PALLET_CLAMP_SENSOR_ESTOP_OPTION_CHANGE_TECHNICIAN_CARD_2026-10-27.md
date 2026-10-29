# 4400-APC-01 — Automatic pallet changer: is the pallet *really* seated?
**2026-10-27 | OEM documentary field card | NOT a live troubleshooting procedure**

**A “clamped” light is not a physical pallet-retention certificate.** Haas TG0108 documents a pallet lowering too early because a switch was triggered before the pallet reached its intended position; Haas changed the EC-400 rack notch and switch mount geometry. The same guide describes reversed hydraulic clamp/unclamp lines, reversed sensor connections, and a damaged seal leaking hydraulic oil into the air blast. These are different physical failures even when the CNC displays similar alarms.

## Three different facts, three different witnesses
| Question | Ordinary signal | Independent fact needed |
|---|---|---|
| Where is the pallet/H-frame? | Full CW/CCW, up/down switch and I/O status | Actual mechanical position, load support and receiver/locator geometry |
| Is the pallet retained? | Clamp/unclamp input or HPU pressure | Real clamp/locator engagement, correct hydraulic routing and load restraint |
| May a person enter the load station? | Door closed, E-stop alarm clear, “Part Ready” | Installed and validated guard/E-stop protective path, safe machine state and deliberate rearm |

**Context matters:** TG0108's OEM table permits both clamp/unclamp inputs inactive when **no pallet is present**. An input pair cannot be interpreted without the selected machine and phase. Conversely, a switch transitioning is not proof of the mechanical location that actuated it.

## Retrofit/commissioning change trap
Haas's **October 2026 Revision E** UMC pallet-pool installation documents a service shorting block for a deliberately **absent-pool** machine configuration and requires integration of the station interface when the option is installed. This is **not** a general bypass permission. The approved absence/installation state, actual station E-stop/door circuit and all temporary service hardware must be checked during handback. OEM keyed hydraulic couplings are also a practical anti-misconnection measure; do not defeat the keying to “make it fit.”

## Practical minimum
Give maintainers an accessible physical clamp/locator inspection path, mechanically restrained loads, labeled/locked hydraulic and electrical energy isolation, clear pressure-relief verification, correctly keyed connections and an easy-to-reinstall station guard. Make recovery display **POSITION/CLAMP UNKNOWN — NOT READY** until independent verification, rather than automatically clearing to “ready” after power restoration. An operator should never have to defeat a guard to see whether a pallet is seated.

**STOP / no personnel exposure:** Do not run with a person in the pallet transfer zone or under a partially clamped/unsupported pallet. Do not attempt energized sensor adjustment, hose reversal, E-stop jumper changes or recovery motion from this card. A qualified, separately validated physical plan is required.

**Conditional evidence (selected machines only):** APC-1 identity; APC-2 clamp/locator witness; APC-3 hydraulic direction and support; APC-4 rack/switch variant; APC-5 guard/E-stop and option-state signoff; APC-6 power-loss recovery/rearm; APC-7 accessible maintenance. All UNKNOWN/NOT RUN; no OpenPressBrake pallet changer asserted.

**Provenance:** [full engineering audit](../research/4400_APC_01_HAAS_PALLET_CHANGER_EARLY_CLAMP_SENSOR_HYDRAULIC_REVERSE_AND_SERVICE_JUMPER_OEM_AUDIT_2026-10-27.md); [Haas TG0108, updated 2025-10-14](https://haascnc.com/service/troubleshooting-and-how-to/troubleshooting/pallet-changer---ngc---troubleshooting-guide.html); [Haas UMC pallet-pool installation Rev E, 2026-10-02](https://haascnc.com/service/troubleshooting-and-how-to/how-to/umc-pallet-pool---10-station---version-2---installation.html); [OSHA 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147). **DOC-CONFIRMED** OEM symptoms; **INFERENCE** possible failure consequences; **UNKNOWN** actual selected-machine safety performance. No compute/evaluator; G0/G1 HOLD.


## LinuxCNC stock M60/M30 implementation caveat — 2026-10-29
Before transferring these Haas-specific mechanical/sensor lessons to a LinuxCNC retrofit, read the [pinned LinuxCNC M60/M30 canonical stub audit](../research/4400_M60_M30_01_LINUXCNC_2910_PALLET_SHUTTLE_STUB_VS_DOCUMENTED_EXCHANGE_AND_PAUSE_SOURCE_AUDIT_2026-10-29.md). The default LinuxCNC pallet-shuttle canonical function is unimplemented even though the M-code manual says M60/M30 exchange pallets; a selected machine may instead use a custom M60 remap or external sequence. The presence of M60, an ordinary PAUSED/ENDED indication or an OEM sensor name is not a pallet movement/retention/guarding witness. No additional APC cases or graduation claim are created by this addendum.
