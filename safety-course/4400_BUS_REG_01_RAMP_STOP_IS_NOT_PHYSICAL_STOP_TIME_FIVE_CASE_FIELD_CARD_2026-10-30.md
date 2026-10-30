# 4400-BUS-REG-01 — A commanded ramp is not a physical stopping-time witness
**2026-10-30 | public unscored technician/reviewer exercise | not a machine procedure or external blind evaluation**

**Primary source:** [exact September 2024 Rockwell PowerFlex 40P A117/A121 original-manual audit](../research/4400_BUS_REG_01_ROCKWELL_40P_2024_UNCOMMANDED_SPEED_DELAYED_DECEL_AND_STALL_TIMER_OEM_AUDIT_2026-10-30.md). Predecessors: VFD-EXIT-01 ordinary stop, BR-01 dynamic resistor fire, DCB-01 bus backfeed, RST-01 deliberate restart. The **new** lesson is that a VFD bus regulator may alter deceleration and even cause uncommanded positive speed; this is not the same as process exit, resistor overheating or shared-bus electrical isolation.

## Five paper-only transfer cases (no numerical machine assumptions)
1. **Door release after programmed ramp:** A mill spindle is commanded to stop with a 2-second ramp and a guard unlock timer is set to 2 seconds. PowerFlex 40P A117 is enabled. Which missing physical witnesses block release? Explain why the timer is not a safety stop-time calculation.
2. **Voltage disturbance:** The same drive has a supply imbalance and its ordinary frequency output briefly rises despite a lower LinuxCNC speed command. Distinguish OEM-documented possibility, source observation and installed-machine proof. Which independent protective action remains required?
3. **Fault timer trap:** A technician points to the manual's “one minute” stall fault and assumes it limits guard access. Find A121's documented default and alternatives; explain why *even a correct timer value* does not establish physical standstill.
4. **Quick parameter change:** A mechanic proposes disabling A117 to make a press-brake accessory drive stop faster. What new fault/energy questions does the OEM positioning note raise? Why is changing the drive parameter not a safety release?
5. **Shared STOP button:** A conveyor with a gravity-overhauling load uses the normal drive ramp and a safety-off option. Explain which functions belong to normal command, independent protective stop, physical braking/holding, and maintenance isolation; identify where real stop-time evidence must come from.

## Reviewer contract
For each case, require: **hazard / physical proposition / ordinary command / independent safety authority / final element / real witness / UNKNOWN / bypass incentive / rearm rule**. Reject any answer that substitutes a programmed ramp, drive fault flag, software watchdog, dark LED or manufacturer's component rating for measured and validated machine behavior. No made-up stop distance, torque, A117 setting, PL/SIL, guard timing or installed hydraulic/drive facts.

**Evidence:** DOC-CONFIRMED Rockwell 22D-UM001F-EN-E pp.9, 56–57, 83–84, 172; INFERENCE transfer to generic machines; TEST-CONFIRMED none. Public unscored exercises do not contaminate sealed 2520–25F0 evaluations. No hardware operation or compute. **G0/G1 HOLD; no personnel-exposed hazardous operation.**
