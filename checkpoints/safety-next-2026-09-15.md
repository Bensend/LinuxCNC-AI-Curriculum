# Safety Curriculum Next Work — 2026-09-15

## Current state

Primary curriculum priority is Practical Machine Safety Engineering / 4000 safety-oriented boundaries. The 3000 series remains GRADUATED/CLOSED.

Durable foundation includes `research/linuxcnc-safety-patterns.md`, `research/linuxcnc-iocontrol-estop-callflow-2026-09-15.md`, `research/safety-real-machine-integrations-and-relay-matrix-2026-09-15.md`, and `guides/safety-function-contract-first-pass-2026-09-15.md`.

This pass advanced R-SAFE-01/R-SAFE-02 and the first teaching artifact:
- inspected a real Fenja/Groot LinuxCNC router using Mesa 7i76E + Pilz PNOZ 11; PNOZ Y32 is mapped through Mesa DI07 into LinuxCNC E-stop status while project documentation says the relay independently cuts axis-drive power and is wired to the VFD;
- source-traced a second XYYZ gantry-router config at `zmrdko/mesa_7i95t_config@94af1eb5b86127b314181fc5809d75f2d59526e8`: `iocontrol.0.user-request-enable` drives `estop.reset`, Mesa SSR03, ordinary software E-stop latches and a delayed `halui.estop.reset` path; Mesa input 23 participates in the returned `emc-enable-in` path;
- reconciled that software reset request against exact Pilz PNOZ s4 manual semantics: monitored manual start/restart and external K5/K6 feedback-loop monitoring are device-side capabilities; automatic/bridged start carries an explicit unexpected-restart warning. Public repo evidence still does not prove SSR03->S34 cabinet wiring, selected PNOZ mode, EDM wiring or STO/contactors;
- preserved Maho MH600T public safety-drawing chronology from 2023-08-11 to 2023-08-24, including later `Reset conditions (no stuck contacts)` detail without mislabeling a draft as validation evidence;
- began manufacturer matrix with Omron G9SE, Rockwell Guardmaster examples, PNOZ s4 and PNOZ X3 exact-manual sources;
- built the first generic teaching contract: **hazard -> hazardous event -> safety function -> safe state -> detection/feedback -> reset -> restart authorization -> validation -> residual risk**;
- froze reset as a separate concept from restart and software reset as a request rather than safety authorization.

## Exact next work

1. Finish exact current **PNOZ X3 20547-17** and **PNOZ s4 21396-23** numeric/manual rows: channel/cross-short detection, response/recovery times, output ratings/fusing, PL/SIL restrictions and model-specific wiring. Older manual revisions may establish stable concepts but not revision-sensitive numeric claims.
2. Find a third public LinuxCNC machine integration with **explicit drive STO wiring** and, preferably, commissioning/build chronology. Preserve evidence asymmetry if only a status/config is public.
3. Turn the welded-contactor seed into a scored safety exercise using exact feedback-loop/EDM evidence: failed external device, feedback mismatch, reset inhibition, LinuxCNC diagnostic witness and physical validation method.
4. Expand the teaching contract into machine-family examples: gravity axis, spindle, hydraulic actuator, plasma/laser process source and robot/cell access. Keep safe-state definitions physically distinct.
5. Begin the low-cost reference architecture only after the SRS/failure model is explicit. Never assign Category/PL/SIL to an open reference circuit without the required evidence/calculation/validation chain.

## Lab decision

No lab is justified yet. Current unknowns are source/config/manual questions. Prefer evidence acquisition and standard engineering reasoning over synthetic simulation.

## Human-factors rule

Recovery must be easy but deliberate. Safeguards should be easier to use/reinstall correctly than to bypass. Diagnostics should identify the missing prerequisite without offering a bypass path. A LinuxCNC/HMI reset control is only a **request**; ordinary software must not become the sole safety authorization, and restoring a safeguard must not silently become hazardous restart unless the application-specific risk assessment and safety design explicitly justify that behavior.
