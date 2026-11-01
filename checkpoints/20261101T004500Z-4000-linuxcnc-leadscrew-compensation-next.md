# 2026-11-01 00:45Z — LinuxCNC COMP_FILE calibration and Tcl reload checkpoint

**Active:** 4000 LinuxCNC-first implementation, NON-GRADUATED; practical 3100 mill/lathe/gantry calibration. Predecessor [HostMot2/MTConnect checkpoint](20261031T234000Z-4000-linuxcnc-hm2-watchdog-recovery-next.md). Mandatory governance, evidence, compute and evaluation state inspected. Graduated 1000/2000/F02/3000 remain CLOSED. Personnel-safety authority and OpenPressBrake physical G0/G1 HOLD unchanged.

Stable v2.9.10 is the annotated tag `4e7abeab3e764a42ef9def932333a1d4004e547b`, peeled to LinuxCNC commit `86cdca76fa2a36274c432caa21952b23c267989a` (tagger 2026-07-02); development is commit `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. Tag signature verification was not established by this audit.

## New verified source paths

1. [COMP-88 loader/compensation](../research/4400_LINUXCNC_COMP_88_LEADSCREW_TABLE_PARSE_FALLBACK_SOURCE_AUDIT_2026-11-01.md): both stable v2.9.10 and pinned development stop reading on first malformed/blank/header line without returning parse failure. Zero accepted entries means runtime falls back to \`BACKLASH\`, contrary to a literal reading of docs' COMP_FILE precedence. Invalid order and >256 rows are logged by Motion but the command status can remain OK. Type 0/1 trims, direction selection, filtered motor command and compensated feedback traced. SOURCE/DOC-CONFIRMED, runtime NOT RUN.
2. [COMP-89 Tcl/Task/reload](../research/4400_LINUXCNC_COMP_89_TCL_RELOAD_JOINT_AND_ACK_SOURCE_AUDIT_2026-11-01.md): both \`sendJointLoadComp\` variants omit the requested joint field; development initializes it to 0, stable does not explicitly initialize it. Tcl ignores sender return and invalid type conversion, and runtime loader appends rather than replaces. **Do not claim stable deterministic target or actual wrong-axis motion.**
3. [14-case disconnected guide](../guides/4000-linuxcnc-leadscrew-compensation-calibration-disconnected-acceptance-2026-11-01.md) C1–C14 all NOT RUN; [strict offline validator with eight unrun tests](../examples/4000_linuxcnc_comp_table_preflight.py). Real upstream \`servo_sim.ini\`/\`screwcompX.dat\` cited but NOT RUN; no physical calibration performed.

## Next precise checkpoint

- If qualified isolated \`[self-hosted, openpressbrake]\` compute is independently established, execute pure-software preflight C1–C6 first, then instrument Task/NML C7–C12. Preserve exact source revision, command bytes, stdout/stderr, per-joint table state, test verdicts and authoritative job times. No GitHub-hosted Actions; no machine connection.
- For possible upstream maintenance, prepare separate narrowly scoped changes only after reproduction: (a) strict parse/error propagation, (b) \`sendJointLoadComp\` joint assignment and Tcl error propagation, (c) explicit replace-vs-append contract. A documentation patch alone must not disguise the behavior.
- If qualified compute remains unavailable, rotate to a distinct unstudied LinuxCNC source path (e.g. realtime motion feed-hold vs compensation ramp, mill tool-change interpolation, or machine-specific kinematics), rather than accumulating duplicate compensation test plans.
- Keep prior HM2/MTConnect/CAM test debt, independent evaluator separation and machine safety gates unchanged.

**Evidence:** SOURCE/DOC-CONFIRMED static; INFERENCE conditional; TEST-CONFIRMED none. No builds, simulations, Python execution, machine operation, independent evaluation or Actions. Hosted/self-hosted Actions 0/0 min; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Existing hourly schedule remains enabled.
