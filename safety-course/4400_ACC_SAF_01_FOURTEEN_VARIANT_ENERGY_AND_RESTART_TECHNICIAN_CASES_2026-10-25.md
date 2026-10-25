# 4400-ACC-SAF-01 — 14 public, unscored accumulator safety transfer cases

**Status:** PAPER ONLY / UNSCORED. Read [module](4400_ACC_SAF_01_EXACT_BLEED_POLARITY_FLUID_GAS_AND_RAM_HOLD_MODULE_2026-10-25.md) and [original source audit](../research/4400_HYDAC_SAF_2021_VARIANT_DEENERGIZED_BLEED_AND_PARKER_DUAL_ENERGY_AUDIT_2026-10-25.md). These are not hidden/blind evaluation, machine-specific commissioning instructions, or permission to operate.

For each case record: **(a)** actual known evidence, **(b)** which proposition fails, **(c)** affected BND/ENE/SRS/ARC/DEP/PHY/VAL/CHG/RR identifiers, **(d)** simplest practical safer redesign, **(e)** what selected-machine proof remains UNKNOWN. No invented pressures, flow rates, stopping distances, PL/SIL or hydraulic truth table.

1. **M substituted for E:** Service installs a HYDAC SAF...M in place of SAF...E. Ordinary HMI still says AUTO BLEED. What component is missing, and what claim must be invalidated?
2. **Y substituted for Z:** A replacement SAF...E...Y differs from documented E...Z. Which deenergized bleed behavior changes? Why does neither variant establish a universal press-brake safe state?
3. **Z substituted for Y:** The original design assumes loss of 24 V opens a discharge path. The replacement order code ends in Z. What breaks before any physical test?
4. **Generic catalog “Solenoid” field:** A catalog page says “Valve Type: Solenoid” for exact SAF20M16. Does this override the M model code? Identify the source hierarchy and how to verify installed equipment.
5. **Optional gauge absent:** A compact block has no gauge fitted. A PLC status register displays zero pressure. What independent observation is missing?
6. **Gauge on pump side:** A gauge at a supply manifold falls to zero while an isolated accumulator-side volume remains pressurized. Which zones and ports must be mapped before declaring service-safe?
7. **Tank return obstructed:** An E/Y coil is deenergized, but a blocked return prevents normal discharge. Why does a coil LED or safety-relay state not close the physical-energy proposition?
8. **Hydraulic fluid zero, nitrogen present:** A qualified technician is preparing to remove an accumulator after draining the hydraulic side. Which *different* pressure domain remains and which manufacturer's exact service procedure governs?
9. **Elevated gravity load:** Accumulator pressure falls during a stop while Y1/Y2 remain raised. Does a zero gauge prove holding? What independent restraint and witness are required?
10. **Protective-cycle accumulator:** The accumulator may be needed to finish a controlled stop or emergency rescue. A proposed E/Y “dump on E-stop” circuit is offered. What must be established before accepting or rejecting the architecture?
11. **Relief valve confused with bleed:** A maintenance card points to the overpressure relief setting as evidence of automatic shutdown exhaust. Explain the different component functions.
12. **Locked main shutoff, bleed closed:** A worker padlocks the main isolator but forgets the manual bleed and assumes all cavities are empty. What verification sequence and human-factor changes should the design support?
13. **Power returns with stale cycle request:** After electrical restoration, independent safety logic reports READY and LinuxCNC retains an ordinary run request. What separate rearm and *fresh command* conditions must be reviewed?
14. **Change of accumulator/port location:** A retrofit moves a gauge, adds a check valve, and changes the bleed block. Which previous evidence is STALE, and what must be revalidated before exposed operation?

## Blank technician evidence record

| Case | Source/variant checked | Failed physical proposition | Dependencies / CCF | Safer practical change | UNKNOWN / restriction |
|---|---|---|---|---|---|
| 01–14 | NOT RUN | NOT RUN | NOT RUN | NOT RUN | NOT RUN |

**Adversarial stop rule:** A convincing-looking component datasheet, a nominally fail-open valve, or a zero pressure indication must never substitute for independent physical proof of *every* hazard-relevant zone and gravity holding. The real selected machine remains **G0/G1 HOLD**, all 14 scenarios unscored, no tests executed.
