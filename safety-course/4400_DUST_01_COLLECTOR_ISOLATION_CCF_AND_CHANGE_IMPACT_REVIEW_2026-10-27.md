# 4400-DUST-01 — Collector protection composition, common-cause failures and change-impact review

**Status:** documentary/adversarial engineering review, NON-GRADUATED. Use with [DUST-01 source audit](../research/4400_DUST_01_OSHA_CSB_FIKE_NFPA660_COMBUSTIBLE_PARTICULATE_AND_COLLECTOR_PROPAGATION_AUDIT_2026-10-27.md) and [public field module](4400_DUST_01_COLLECTOR_PRIMARY_SECONDARY_EXPLOSION_AND_MAINTENANCE_FIELD_MODULE_2026-10-27.md). **No machine selected; no test performed.**

## Why this composition matters

An ordinary extraction system moves particulate out of the breathing zone, but it may **concentrate** the particulate in a collector, ducts or hopper. HSE directly identifies extraction-system fires. Fike directly distinguishes protecting the **collector vessel** from protecting connected inlet/outlet equipment. The CSB Imperial Sugar case directly documents a primary event propagating into secondary events. These are source-backed mechanisms; the following abstract design decomposition is **INFERENCE** until applied to a qualified machine.

### Separate safety propositions (do not merge)

| ID | Physical proposition | Example independent evidence required | What cannot substitute |
|---|---|---|---|
| DUST-PHY-01 | Material/process hazard is characterized for actual dust and operating modes. | Representative competent material/process assessment. | Material name alone, no prior fires, coarse stock behavior. |
| DUST-PHY-02 | Collector enclosure is protected against credible internal deflagration consequences. | Selected collector/protection design, installation, inspection, qualified acceptance. | Airflow green, filter efficiency, fan motor OFF. |
| DUST-PHY-03 | Inlet/outlet/hopper connections cannot propagate unacceptable flame/pressure into occupied zones under the defined design basis. | Selected isolation devices, layout and installation limits, separate physical validation. | Vessel vent alone, ordinary PLC interlock, normal duct damper. |
| DUST-PHY-04 | Vent/relief discharge does not expose personnel or damage other critical equipment. | Site-specific discharge geometry and exclusion/structural review. | 'Vented outdoors' checkbox. |
| DUST-PHY-05 | Deposited/hidden dust is controlled over normal operation and maintenance. | Accessible inspection, cleaning records, real observations, foreseeable-defeat review. | Good breathing-zone measurement, HMI dust sensor. |
| DUST-PHY-06 | Maintenance opening/restart does not expose workers to retained heat, smoldering, material or energy. | Isolation and fire-condition assessment, physical access proof, deliberate restart. | CNC E-stop, fan stopped, alarm acknowledged. |

### Four layers of control and authority

1. **Normal LinuxCNC/FPGA**: run/stop process and fan, log differential pressure, warn of airflow loss. This may reduce routine process exposure but cannot be designated as independent explosion containment/isolation without a separately justified safety architecture.
2. **Diagnostics**: record timestamp, quality, configuration identity, device state, stale/invalid sensor, bypass state and service history. These are useful maintenance evidence; a fresh green bit does not prove `DUST-PHY-02/03`.
3. **Qualified protection system**: product- and installation-specific passive or active explosion protection and isolation. **Fike OEM confirms architecture families**, not installed-device performance. Any active detector/controller/final element requires its own independence, common-cause, power-failure, maintenance and validation analysis.
4. **Physical layout/energy**: actual collector strength, vent path, duct isolation, deposits, fire, service access and occupancy. The hazard can persist after all electrical commands are OFF.

### Adversarial minimal cut-set prompts (qualitative, NOT probability calculations)

- **A:** ignition + suspended combustible dust + confinement + inadequate collector protection -> potential vessel event. Every premise must be checked; do not infer frequency or severity numerically.
- **B:** collector event + unqualified open duct path + occupied downstream zone -> potential secondary exposure even if collector itself vents.
- **C:** smoldering product + normal fan restart + unreviewed oxygen/transport/duct conditions -> potential renewed fire/propagation. Exact outcome UNKNOWN; do not test by energizing.
- **D:** normal airflow fault + operator defeats alarm + hidden dust accumulation -> increased unrecognized hazard; fix nuisance cause and access rather than making bypass the normal workflow.
- **E:** shared power/ground/configuration service path disables active detection and final protection simultaneously -> potential common-cause defeat. Passive protection may have different failure modes; do not assume either architecture is universally better.
- **F:** new fine-powder process + unchanged collector approval/maintenance plan -> stale hazard characterization and `VAL/PT` even when HMI and wiring are unchanged.

### Change-control matrix

| Change | Reopen at minimum | Avoid this shortcut |
|---|---|---|
| Wood species or sanding/routing tool changes fines | DUST-PHY-01, -05, collector design basis | 'Same machine, so same dust.' |
| Material changes to metal/plastic or mixtures | DUST-PHY-01–06 and compatible collection/suppression | 'Existing vacuum is adequate.' |
| Collector moved indoors, vent reoriented or duct shortened | DUST-PHY-02–04; building/fire-code/occupancy | 'Fan still pulls air.' |
| Duct tee, hopper/rotary valve or return-air route changed | DUST-PHY-03–05; isolation/propagation | 'Only airflow balancing changed.' |
| Filter/collector service access or cleaning method changed | DUST-PHY-05/06; HF/CHG/PT | 'Maintenance-only, not safety-related.' |
| Sensor/PLC/FPGA firmware or reset wiring changed | DUST-PHY-02/03 if used by protective system; AUTH/DEP/VAL | 'Software passes, so protection passes.' |
| Shared 24 V/0 V, power supply, protection, cabling changed | Active protection dependency/CCF, physical validation | 'Both channels report healthy.' |

### Commissioning / maintenance witness discipline

A qualified release package should include a material inventory and characterization, exact selected equipment and installed layout, protection system documents and change-controlled configuration, independent inspection of ducts and physical vent/isolation paths, maintenance and cleaning instructions that workers can actually follow, and a deliberate reset/restart protocol. **Do not** use live dust ignition, explosion, intentional defeat of protection or exposure of people as an ad hoc validation method. Physical proof must be designed by qualified specialists and may involve documentary certification, safe inspection and approved nonhazardous functional tests; it is not created by the curriculum.

**Status:** DUST-PHY-01–06 **UNKNOWN**, documentary gates **NOT RUN**, independent evaluator **NOT RUN**, no LinuxCNC new SOURCE-CONFIRMED, no TEST-CONFIRMED, no machine safety performance level or physical operating authorization. Existing OpenPressBrake G0/G1 remains HOLD. No hosted or local compute.
