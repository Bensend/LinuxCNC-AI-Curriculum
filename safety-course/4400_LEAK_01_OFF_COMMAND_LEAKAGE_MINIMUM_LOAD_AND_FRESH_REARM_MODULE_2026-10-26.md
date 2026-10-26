# 4400-LEAK-01 — An OFF bit is not an open energy path
**2026-10-26 | 4000 safety course | NON-GRADUATED**

## Objective
Given a controller output, interposing contact, contactor interface and suppression circuit, identify (1) where OFF-state current can flow, (2) whether the load/input thresholds are compatible, (3) how the **physical** final element is made safe, and (4) why reset/power return cannot authorize new hazardous motion.

## Read original sources first
- [Rockwell IntelliVAC leakage, two-wire power-up and delayed opening audit](../research/4400_ROCKWELL_INTELLIVAC_OFF_STATE_LEAKAGE_SNUBBER_POWER_UP_AND_DELAY_OEM_AUDIT_2026-10-26.md).
- [Schmersal AES 2335 UE minimum-contact-load audit](../research/4400_SCHMERSAL_MINIMUM_RELAY_LOAD_AND_CONTACT_SUPPRESSION_SCOPE_AUDIT_2026-10-26.md).

## Five claims a technician must not merge
| Layer | Observable | Does **not** prove |
|---|---|---|
| Normal LinuxCNC / FPGA | commanded OFF / HAL pin FALSE | output transistor nonconductive, safety output deenergized |
| Electrical interface | relay contact open or semiconductor OFF | no leakage via snubber/semiconductor, receiver below its OFF threshold |
| Final switching | contactor feedback changed | all poles open, hydraulic pressure removed, Y1/Y2 restrained |
| Independent safety control | safety demand/diagnostic and monitored final elements | gravity-load support, personnel absence, maintenance LOTO |
| Physical machine | independently verified stopped/held/isolated | permission for automatic restart without deliberate command |

**DOC-CONFIRMED:** Rockwell's 2013 IntelliVAC manual explicitly describes residual voltage/off leakage causing unwanted contactor retention; its two-wire power-up option can disable a power-up safeguard. **DOC-CONFIRMED:** a specific Schmersal safety relay has a **minimum** switching rating; Rockwell PointMax ordinary I/O documents suppression near inductive coils and product-specific exceptions. **INFERENCE:** these interface constraints belong in change control and safety function verification. No claim about OpenPressBrake hardware.

## Safe workflow (paper first; no energized machine test)
1. **Identify** exact output, relay/contact, suppressor, downstream input, final element and physical energy source from restricted as-built records. A generic '24 V' label is insufficient.
2. **Draw both paths** on a documentary circuit sketch: commanded current path and any OFF-state parallel/suppression/leakage path. Mark known OEM threshold/current and **UNKNOWN** where absent.
3. **Compare exact device specifications**, including minimum relay switching load, off-state leakage, receiving-input OFF threshold, coil/suppression topology and dropout behavior. Do not invent a generic resistor, capacitor, filter or threshold.
4. **Trace independent safety authority** to its monitored final element(s), physical load restraint and energy isolation. A proposed interposing relay is not automatically a safety-rated solution.
5. **Review recovery**: brownout, retained two-wire CLOSE, output replacement, snubber failure and manual reset. Require a fresh, deliberate motion authorization separate from diagnostic acknowledgment.
6. **Qualified validation** only after G0/G1 documentary gates: isolated/remote no-exposure verification of electrical state and physical stop/hold under a controlled, approved plan; personal LOTO for maintenance. No personnel-exposed operation when basic safe-to-operate conditions are unproven.

## Human factors
Do not 'fix' a nuisance trip by bridging contacts, removing coil suppression at random, or masking input status in HAL. Use a documented, keyed/labelled compatible replacement kit, a clear fault indication, and an easy-to-restore independent guard. A difficult safety service path is an engineering defect, not a technician training problem.

## Cross-machine transfer
A press brake requires independent ram hold and hydraulic energy boundaries; a mill needs spindle/coastdown and door access; a lathe has rotating-workholding inertia; a plasma table adds arc/high-voltage hazards; an automated cell adds occupancy/restart and multiple energy sources. None inherits IntelliVAC electrical specifications merely because it has a contactor.

**Adversarial check (PUBLIC / UNSCORED):** 'The PLC output LED is OFF, the relay contact is open, and the HMI says stopped; therefore the ram cannot move.' Identify at least three unproven propositions, two exact OEM data sheets required, and the G0 hold. Never answer with a live bypass experiment.

**Status:** SOURCE-CONFIRMED new LinuxCNC none; DOC-CONFIRMED exact OEM only; INFERENCE architecture; TEST-CONFIRMED none; UNKNOWN selected machine. External evaluator NOT RUN, G0/G1 HOLD.


## Source-level twist: command-acknowledgment is not a final-element witness
The same IntelliVAC June 2013 manual's printed **p. 5-2** says its *Contactor Status* output relay can close during a **200 ms CLOSE-command interval**, or when the contactor is closed. A naive controller/HMI could treat a contactor-status assertion as physical proof before a final-element state has been independently established. This is **DOC-CONFIRMED for that interface**; do not infer that all contactor auxiliary contacts behave this way. Table 1.A also specifies **maximum OFF-state command-input current at stated test conditions** (900 µA at 30 V DC; 700 µA at 20 V AC), not a generic allowable leakage for all hardware. A qualified reviewer must compare exact variant/test conditions rather than borrow either number for OpenPressBrake.
