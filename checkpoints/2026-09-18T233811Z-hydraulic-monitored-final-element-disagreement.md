# Checkpoint — Hydraulic Monitored Final-Element Disagreement

UTC start: 2026-09-18T23:36:42Z
UTC checkpoint: 2026-09-18T23:38:11Z

## Durable result

Created and deepened `safety-course/HYDRAULIC_FINAL_ELEMENT_DISAGREEMENT_FAIL_SAFE_TRACE_2026-09-18.md`.

New same-machine evidence: HAWE D 6335 current SAKB documentation exposes a valve-monitoring press-brake variant in which two proportional directional valves, two holding valves and the 4/2-way directional valve have position monitoring. This closes the earlier gap between generic valve-position monitoring and identification of multiple monitored final elements in an actual press-brake hydraulic system.

HYDAC PSV 10/16 provides separate professional evidence that a monitored-valve failure can demand safe shutdown, but it is a mechanical/servo-press clutch/brake product and is deliberately not treated as a hydraulic press-brake truth table.

## Freeze

`SAFE COMMAND != COIL OFF != SWITCHING ELEMENT SAFE != ALL REQUIRED MONITORED HYDRAULIC ELEMENTS PROVED != RAM/LOAD RETAINED != STORED ENERGY SAFE != STOP PERFORMANCE VALID != ACCESS SAFE`.

Do not infer degraded production from a healthy companion valve. Do not let LinuxCNC/HAL/ordinary FPGA become the sole safety authority.

## Exact next work

Seek authoritative same-machine evidence for `single monitored SAKB/press-brake element disagreement -> machine-level safe reaction/load disposition -> fault retention -> repair -> required re-proof/stop validation -> safety rearm -> separate fresh production initiation`, including whether companion holding elements can mask a failed element during proof.

No compute was justified or used. No GitHub-hosted Actions minutes were consumed.
