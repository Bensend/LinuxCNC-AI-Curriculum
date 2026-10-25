# 4400-COMM-01 — Ten open technician cases: disabled safety mode and commissioning return
**2026-10-25 | PAPER ONLY | 10 public cases UNSCORED, not blind or physical tests**

Read [direct Rockwell Kinetix original-OEM audit](../research/4400_ROCKWELL_KINETIX_DISABLED_MODE_SAFE_OUTPUTS_MOTION_POWER_ENABLED_SOURCE_AUDIT_2026-10-25.md). For each: state exact OEM evidence, missing as-built fact, potential hazard, independent protective mechanism and low-friction safe restoration. Never claim the OEM mode exists on OpenPressBrake without selected-machine proof.

1. An HMI reads “safety outputs OFF.” The exact drive is in 2013 Kinetix **Disabled** mode. What does the manual say about commissioning motion power?
2. A technician assumes speed-monitor diagnostics still detect overspeed in Disabled mode. What is documented?
3. A safety relay output is deenergized, but a separate ordinary enable permits motor torque during a commissioning task. What must the full final-element path demonstrate?
4. The machine returns to production after safety configuration work; the ordinary HMI reports READY. Which safety mode/configuration and physical proof must be independently restored?
5. A shop proposes to disable the safety monitor permanently because nuisance trips delay tool changes. Suggest an engineering fix that makes correct guard use easier.
6. An isolated commissioning plan has remote controls but an assistant stands in the ram hazard zone to watch the work. What minimum safety boundary fails?
7. A machine uses ordinary LinuxCNC E-stop and an FPGA watchdog; a safety option is disabled. What independent personnel-safety authority is missing?
8. A fault-free safety output is interpreted as evidence that a spindle cannot coast. Distinguish output state from physical standstill.
9. The selected machine has a gravity-loaded hydraulic beam; drive motion power is available in a service mode. What additional energy/holding/restraint and escape evidence is needed?
10. A technician documents “safety mode restored” but has not checked guard interlock wiring or fresh restart after a drive replacement. Which G0 release gates remain open?

**Status:** all ten PAPER cases UNSCORED; independent evaluator NOT RUN; selected OpenPressBrake physical G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. This card does not authorize any hazardous energized demonstration.
