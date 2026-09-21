# 25E0 adversarial exercise — valve position, pressure, energy and restart authority

## Scenario

A hydraulic machine has two series shutoff valves. Each valve has monitored spool/position feedback. The safety controller commands both valves to their safe positions and receives the expected position feedback from both. An ordinary LinuxCNC cycle-start input remains physically held throughout the event.

A pressure accumulator exists downstream of the shutoff valves. The design under review has no downstream pressure witness and no motion witness. The HMI displays `HYDRAULIC SAFE` whenever both valve-position inputs indicate the expected safe position.

After maintenance, both valve feedback inputs again agree with their commands. The ordinary cycle-start input is still asserted.

## Questions

1. What has the valve feedback actually established?
2. Is `HYDRAULIC SAFE` justified by the evidence given?
3. Does blocking upstream supply establish that downstream stored energy is harmless?
4. May the safety controller infer zero ram motion from the two valve-position signals?
5. If a valve-position mismatch clears, is a fresh reset necessarily required?
6. If safety permission is later restored, may the already-held LinuxCNC cycle-start be accepted automatically?
7. Which facts belong to independent safety authority and which may remain ordinary-control diagnostics/gating?
8. What additional physical witnesses or validation evidence could be required before making stronger claims?

## Expected reasoning

A strong answer must separate **command**, **final-element position**, **pressure/stored energy**, **motion**, **safety reset/rearm**, and **ordinary demand freshness**.

The two position signals can support only the position/state claim established by their actual sensor arrangement and diagnostic architecture. They do not by themselves prove zero downstream pressure, zero flow, zero ram motion, adequate stopping performance, or harmless stored energy.

The HMI label is therefore over-broad. A better operator presentation names the witnessed fact, for example `SHUTOFF VALVE POSITION CONFIRMED`, while pressure/energy and motion evidence remain separate.

The reset question cannot be answered generically from valve feedback. Siemens 3SK1 and Rockwell SBC already demonstrate materially different professional recovery semantics; the actual safety function must be traced.

Likewise, safety permission restoration does not make an old ordinary cycle-start fresh. The normal controller must deliberately define whether the request is edge-triggered, level-held, latched, queued, cancelled, tracked or regenerated. For a production restart path, retaining a stale demand should be treated as a design issue rather than silently assuming it is safe.

## Failure traps

- Treating a spool switch as a pressure sensor.
- Treating supply isolation as stored-energy dissipation.
- Treating redundant final elements as complete validation.
- Importing Rockwell SBC manual-reset semantics into an unrelated valve system.
- Letting LinuxCNC's `cycle-start` become personnel-safety authority.
- Using one green `SAFE` bit to hide heterogeneous evidence classes.

## Evidence classifications

- SMC main-valve position detection and redundant residual-pressure-release architecture: **DOC-CONFIRMED**.
- Festo distinction among direct valve monitoring, indirect monitoring and process diagnostics: **DOC-CONFIRMED**.
- Rexroth distinction between position-monitored hydraulic supply blocking and safe decompression: **DOC-CONFIRMED**.
- Exact OpenPressBrake hydraulic valve sequence, thresholds, timing and diagnostic coverage: **UNKNOWN until machine-specific engineering/measurement establishes them**.
