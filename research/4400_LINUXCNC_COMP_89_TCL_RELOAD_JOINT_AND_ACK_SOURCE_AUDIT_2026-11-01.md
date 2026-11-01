# COMP-89 — Tcl compensation reload loses joint selection and acknowledgment

**Status:** LinuxCNC-first 4000 source audit, NON-GRADUATED. Inspected 2026-11-01 UTC. **SOURCE-CONFIRMED** message construction and return paths; runtime behavior **NOT TESTED**.

## Pinned provenance

- Stable **v2.9.10**: [emcsh.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/emcsh.cc) \`emc_joint_load_comp\` lines 3097–3127 (blob \`672906e222a069b8262d1b2b74121a3e8147e045\`); [shcom.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/shcom.cc) \`sendJointLoadComp\` lines 1192–1206 (blob \`28eb924291788f64effd4fd9376220d23dc3c1c2\`); [emc_nml.hh](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/nml_intf/emc_nml.hh) \`EMC_JOINT_CMD_MSG\` and \`EMC_JOINT_LOAD_COMP\` lines 179–188 and 482–494 (blob \`4e41b6eb61d6cac2f1d7035352fd776d84e5a0e0\`).
- Pinned development \`537cf2d765c96b6e75ae1db44e1dc0b9dba906a1\`: [emcsh.cc](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/usr_intf/emcsh.cc) lines 3237–3267 (blob \`e7e20296f371600ba3b921af1de6ce299e74f295\`); [shcom.cc](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/usr_intf/shcom.cc) lines 940–947 (blob \`0c96ebc5493b8e36d3424beba63007d175edd094\`); [emc_nml.hh](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/nml_intf/emc_nml.hh) \`EMC_JOINT_CMD_MSG\` lines 185–196 and \`EMC_JOINT_LOAD_COMP\` lines 440–454 (blob \`f71030156bbc4ae1c0632008f2722988fb4fed43\`).
- [Task dispatch](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc) \`EMC_JOINT_LOAD_COMP_TYPE\` lines 1783–1788, [taskintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/taskintf.cc) \`emcJointLoadComp\`, [usrmotintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/usrmotintf.cc) \`usrmotLoadComp\`, and [command.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c) \`EMCMOT_SET_JOINT_COMP\`.

## New finding 1 — Tcl joint argument does not reach Task

The Tcl command \`emc_joint_load_comp <joint> <file> <type>\` validates a joint number, but both pinned \`sendJointLoadComp\` implementations **never assign** \`emc_joint_load_comp_msg.joint = joint\`. Development even marks the parameter \`int /*joint*/\`; its \`EMC_JOINT_CMD_MSG\` constructor initializes \`joint(0)\`. Therefore development's Tcl route **sends joint 0 regardless of the requested joint**, while Task faithfully reads the message field and forwards it to \`usrmotLoadComp\`. Stable's base constructor does not explicitly initialize the joint field, so the transmitted value is **not guaranteed** by this source path; do not claim a deterministic stable target joint without runtime evidence. This does **not** implicate startup INI loading, which calls \`emcJointLoadComp(joint,...)\` directly with the intended joint.

## New finding 2 — Tcl result is not a load acknowledgment

Both Tcl implementations invoke \`sendJointLoadComp\` but **discard its return value** and return \`TCL_OK\`. On invalid \`<type>\`, both set a Tcl error message but fail to return \`TCL_ERROR\`, then still call the sender with a potentially indeterminate local \`type\`. This is a source-confirmed validation/acknowledgment gap. An apparently successful Tcl call does not prove a row was installed.

## New finding 3 — loader appends; it does not replace

\`usrmotLoadComp\` issues one \`EMCMOT_SET_JOINT_COMP\` per parsed row. \`command.c\` increments \`joint->comp.entries\` and appends without clearing the prior table. The only inspected zero-entry initialization is in \`motion.c\` joint initialization. A second load with the same nominal range encounters the previous last nominal, so its first row is rejected as non-increasing, but the command can still acknowledge OK (see [COMP-88](4400_LINUXCNC_COMP_88_LEADSCREW_TABLE_PARSE_FALLBACK_SOURCE_AUDIT_2026-11-01.md)). A file containing strictly greater nominals could instead extend the existing table. Thus **runtime replacement is not established**; use a controlled restart/reinitialization and independent verification for a calibration update, not an assumed live hot-swap.

## Practical discriminator

Use an isolated software-only LinuxCNC instance with two joints and a uniquely identifiable type-1 table, and capture Tcl return, serialized NML \`joint\`, Task \`emcJointLoadComp\` target, per-joint compensation entries, and realtime \`joint.N.backlash-corr\` after a direction-qualified move. Repeat on stable/development, then try malformed type, duplicate reload and missing file. A physical machine must not be used as the first oracle. Proposed cases are [C7–C14](../guides/4000-linuxcnc-leadscrew-compensation-calibration-disconnected-acceptance-2026-11-01.md), **all NOT RUN**.

**No claim** of a demonstrated wrong-axis physical movement, real calibration drift, or installed controller failure. Existing independent personnel-safety authority and machine G0/G1 HOLD are unchanged.
