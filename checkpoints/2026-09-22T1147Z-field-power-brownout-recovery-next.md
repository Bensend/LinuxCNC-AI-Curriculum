# 4000 Safety checkpoint — field-power / brownout recovery

UTC: 2026-09-22T11:47Z

Completed this branch:
- reusable `safety-course/POWER_RECOVERY_TRANSITION_WORKSHEET.md`;
- `safety-course/25E0_FIELD_POWER_RECOVERY_BROWNOUT_AND_MACHINE_TRANSFER_2026-09-22.md`;
- professional Rockwell field-power-loss and safety-input recovery trace;
- asynchronous multi-domain brownout adversarial case;
- press-brake/gravity-axis, spindle-machine, and plasma/router transfer comparison;
- no executable compute justified; no GitHub-hosted runner used.

Next work, in order:
1. Deepen monotonic recovery with authoritative safety-network/I/O connection-loss/restoration behavior and reset/ack semantics.
2. Exercise a shared field-power supply as a common-cause dependency feeding multiple nominally separate safety inputs; reverse-trace into affected propositions.
3. Connect field-power restoration to a mechanically displaced/misaligned guard/actuator case where post-outage physical state differs.
4. Extend transfer to robot/automated-cell access and personnel-clear propositions.

Hard boundaries:
- communication restored is not physical witness reacquired;
- field power restored is not machine-level proposition freshness;
- retained/held ordinary demand is not fresh production demand;
- preserve UNKNOWN for machine-specific physics and criteria;
- do not reopen closed 3000 work merely because historical checkpoints exist.
