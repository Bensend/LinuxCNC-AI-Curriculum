# 4000 safety checkpoint — press-brake total stop-response authority

Date: 2026-09-20

## Durable advance

Rockford Systems RHPS hydraulic press-brake documentation extends the IRSST two-hand study from general stopping-time dependence into a concrete total-response chain. Preserve separate witnesses for two-hand/interface response, control-system response, final-control-element response, physical ram stopping, stopping-performance-monitor allowance, and station safety distance. Challenge stop time at the documented worst-case downstroke position/condition rather than a convenient point. Increased stopping time requires distance revalidation; repeated reset is not a production workaround for a persistent safety-related fault.

Artifact: `safety-course/PRESS_BRAKE_TWO_HAND_TOTAL_RESPONSE_AND_STOPPING_MONITOR_AUTHORITY_TRACE_2026-09-20.md`.

## Exact next work

1. Return first to the primary hydraulic post-service bridge: named press-brake retaining/safety valve replacement -> unmasked individual retaining-function challenge -> physical ram/load witness -> pass/fail disposition -> stopping/start-up re-proof where applicable -> safety rearm -> fresh production initiation.
2. On the two-hand lane, seek a complete inspectable press-brake implementation showing the actual hydraulic final element controlled by the safety output and the stopping-performance monitor's inhibit/requalification behavior.
3. Seek authoritative evidence for what event forces remeasurement/recalculation after hydraulic valve/control service; do not infer that every valve replacement automatically changes stop time.
4. If source-limited, rotate to reset/restart stale-command commissioning and challenge power restoration/mode transitions against retained LinuxCNC/FPGA/HMI commands.

## Boundaries

Do not transplant Rockford/legacy ANSI numeric formulas or thresholds into OpenPressBrake without current applicable requirements and machine-specific measurement. Do not treat ordinary LinuxCNC, FPGA, or HMI state as personnel-safety authority.

No simulation/build/test compute was used. No GitHub-hosted runner was used.
