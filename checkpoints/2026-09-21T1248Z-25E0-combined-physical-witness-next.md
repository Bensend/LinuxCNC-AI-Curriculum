# 25E0 continuation checkpoint — combined physical witnesses

Date: 2026-09-21

## Durable state

The Siemens S120 process-witness pass is complete. SBR/SAM supplies authoritative evidence that a professional safety function can monitor the motor-speed trajectory rather than only final-element command/status, while SSM commissioning evidence shows restart/re-entry behavior remains separately defined and configuration-specific.

Freeze the distinction:

`command/final-element status -> process response -> energy state -> safety rearm -> fresh ordinary demand`

Do not collapse those authorities.

## Exact next work

Trace one professional implementation that combines **two different physical witness classes** in one documented safety or return-to-service decision. Preferred targets:

1. brake state/feedback + safe motion/standstill;
2. valve position + pressure/motion evidence;
3. drive final-element status + independent motion evidence.

Require authoritative manufacturer evidence for the combination and explicit fault/restart behavior. Bound exactly what each witness proves.

If no public source exposes the combined state machine, record that source limit and rotate to another open 25E0/25C0 branch. Do not synthesize a universal algorithm from separate products.

Continue to test held reset/start/jog/cycle inputs across evidence recovery. Demand freshness remains independent of safety permission.

No lab is currently justified. If compute later becomes necessary, use only `[self-hosted, openpressbrake]`; never GitHub-hosted runners.
