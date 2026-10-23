# 4400 technician card — LinuxCNC network commands are not safety authorization

**Open-book field exercise | 2026-10-23 | no live commands or hazardous machine tests.** Use the [pinned v2.9.10 source trace](../research/4400_LINUXCNCRSH_2910_REMOTE_COMMAND_AUTHORITY_AND_STALE_STATUS_SOURCE_TRACE_2026-10-23.md) and the [remote-support authority contract](4400_REMOTE_SUPPORT_WEB_UI_AUTHORITY_AND_INDEPENDENT_SAFETY_CONTRACT_2026-10-23.md).

## Exercise objective
A technician can distinguish **network access**, **normal command authority**, **software status**, **independent safety function**, and **physical safe-state evidence**. The goal is a useful, simple diagnostic interface that cannot silently acquire hazardous-motion or personnel-safety authority.

## Source reading (do not execute on a machine)
Pinned `LinuxCNC/linuxcnc` tag `v2.9.10`, `src/emc/usr_intf/emcrsh.cc` Git blob `81b387c20f297d43b7fb63ad26fcf4d25ec0aa62`. Inspect lines 542–563, 603–621, 764–779, 839–856, 1307–1410, 1518–1525, 1592–1599, 2388–2405 and 2777–2835. Compare official [LinuxCNC 2.9 manual](https://linuxcnc.org/docs/2.9/html/man/man1/linuxcncrsh.1.html).

## Eight adversarial cases — paper only, all NOT RUN

| Case | Claim to evaluate | Required answer/evidence |
|---|---|---|
| NET-01 | “The service requires a password, so it is safe to expose it.” | Reject: default passwords and cleartext transport are documented; ordinary authentication cannot replace physical safety. Check network boundary, not just UI login. |
| NET-02 | “We removed the Jog button from the web page, so this is read-only.” | Reject unless the backend **does not forward arbitrary command SET**. Source dispatch supports ESTOP reset, machine ON, MDI, RUN, jog, limit override. |
| NET-03 | “SET ESTOP OFF is our safety reset.” | Reject: pinned source calls `sendEstopReset()`, a LinuxCNC software command. Require independent physical safety-reset authority and a separate local motion start. |
| NET-04 | “GET ESTOP OFF proves the beam is held.” | Reject: task state is not ram restraint, valve condition, mechanical brake or pressure-zone proof; check actual independent physical witnesses. |
| NET-05 | “The machine is safe because the last GET returned normal status.” | Ask when `updateStatus()` last ran, whether UPDATE NONE was selected, the age of every signal, and what physical condition it actually measures. |
| NET-06 | “When remote support disconnects, LinuxCNC necessarily stops.” | Reject: socket disconnect path closes/frees context; no protective-stop proof in that path. Require independent protection on network loss and define ordinary-control behavior separately. |
| NET-07 | “An ACK means the drive contactor opened and motion stopped.” | Reject: command-handler acknowledgment does not witness final-element state or load stopping. Separate request, Task acknowledgment, hardware feedback and physical motion. |
| NET-08 | “We can use the same LinuxCNC endpoint for diagnostics and safety reset because it has SET ENABLE.” | Reject: enabled socket is an ordinary software gate; the actual safety system must not depend on remote socket lifetime, LinuxCNC process, FPGA normal logic or the browser. |

## Small implementation exercise (design only)
Draw four boxes: **remote read-only diagnostics**, **local LinuxCNC normal control**, **independent safety-related controller/relay and final elements**, **physical isolators/load restraint**. Draw arrows only for legitimate authority:
- Remote diagnostics **reads** an explicitly filtered snapshot with timestamps/quality and cannot send arbitrary LinuxCNC commands.
- Local normal control may request motion only under its own local deliberate operator action; independent safety may inhibit hazardous energy regardless of LinuxCNC state.
- Safety-related controller monitors qualified protective devices and actuates selected independent final elements; it does not infer safety from network ACKs.
- Physical isolation, stored-energy release and load support remain service/maintenance measures; their physical verification is distinct from functional stopping.

**Usability criterion:** a local “diagnostics enabled” action and visible session indicator should be easier than sharing a machine-control password or leaving a general command socket open. If remote troubleshooting requires bypassing a guard or safety circuit, redesign the troubleshooting workflow.

## Technician response template
For each case, record: (a) proposition asserted; (b) exact source/manual evidence and version; (c) SOURCE-CONFIRMED / DOC-CONFIRMED / INFERENCE / UNKNOWN; (d) what remains physically unproved; (e) simplest non-bypass corrective design; (f) what selected-machine evidence is still needed. Do not invent physical stop time, hydraulic valve state, performance level or remote-access configuration.

## Adversarial pass criterion
A learner **fails** if it treats `SET ENABLE`, `GET ESTOP OFF`, TCP disconnect, a command ACK, VPN/MFA, or an HMI color as sufficient proof of personnel safety; or proposes remote E-stop reset/guard bypass as a convenience feature. A defensible answer uses source line references, rejects unsupported physical claims, and offers a practical read-only diagnostic alternative.

**Status:** NET-01..08 **PAPER EXERCISES NOT RUN**; no blind evaluation, no lab simulation, no physical validation. OpenPressBrake selected `IN/OPT/PHY/VAL/PT` UNKNOWN/NOT RUN. Minimum safety threshold for personnel-exposed hazardous operation not demonstrated; do not operate with people exposed. Isolated/remote experiments require exclusion and residual-risk assessment.
