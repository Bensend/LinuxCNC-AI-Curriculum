# Safety Curriculum Next Work — 2026-09-15

## Current state

Primary curriculum priority is Practical Machine Safety Engineering / 4000 safety-oriented boundaries. The 3000 series remains GRADUATED/CLOSED.

Durable foundation already includes `research/linuxcnc-safety-patterns.md` and `research/linuxcnc-iocontrol-estop-callflow-2026-09-15.md`, with LinuxCNC master pinned at `d1a9d7d04cc274bfb5082caee6accc2489607418` for the source conclusions recorded there.

This pass added `research/safety-real-machine-integrations-and-relay-matrix-2026-09-15.md` and advanced R-SAFE-01/R-SAFE-02:
- inspected a real Fenja/Groot LinuxCNC router using Mesa 7i76E + Pilz PNOZ 11; PNOZ Y32 is mapped through Mesa DI07 into LinuxCNC E-stop status while project documentation says the relay independently cuts axis-drive power and is wired to the VFD;
- inspected a second XYYZ gantry-router config using Mesa 7i95T + Pilz PNOZ s4 with an on-screen safety-relay reset; exact reset wiring/semantics remain open and must not be inferred from the GUI feature;
- preserved chronology from public Maho MH600T LinuxCNC safety-circuit drafts dated 2023-08-11 and 2023-08-24; the later drawing adds remote E-stop and explicit `Reset conditions (no stuck contacts)`/relay-chain detail, but remains a draft rather than validation evidence;
- froze the practical external-safety pattern: **protective device -> independent safety logic -> safety outputs/energy-control hardware**, with safety status separately returned to ordinary LinuxCNC I/O for coordination/diagnostics;
- began the exact-manufacturer relay matrix: Omron G9SE reset-input timing/fusing/reset semantics, Rockwell monitored-reset/product timing examples, and exact Pilz PNOZ X3 manual availability;
- created a welded-contactor/EDM failure exercise seed without assigning unsupported Category/PL/SIL claims.

## Exact next work

1. Fetch exact current Pilz **PNOZ X3** and **PNOZ s4** operating manuals and extract reset modes, channel/cross-short detection, EDM/feedback-loop behavior, output structure, response/recovery times, fuse/load assumptions, PL/SIL claims and restrictions. Do not transpose values between models.
2. Trace the `zmrdko/mesa_7i95t_config` on-screen PNOZ reset path through HAL/config and determine exactly what LinuxCNC requests versus what the safety relay independently validates.
3. Find a third public LinuxCNC machine integration with **explicit drive STO wiring** and, preferably, commissioning/build chronology. Preserve evidence asymmetry if only a status/config is public.
4. Build the first teaching artifact from accumulated evidence: **hazard -> hazardous event -> safety function -> safe state -> reset/restart -> validation -> residual risk**. Keep it generic and force the learner to identify which claims require machine-specific measurement.
5. After exact EDM evidence is captured, turn the welded-contactor seed into a scored exercise: failed external device, feedback mismatch, reset inhibition, LinuxCNC diagnostic witness, and physical validation method.
6. Only after the SRS/failure model exists, begin low-cost reference architecture drawings. Never assign Category/PL/SIL to an open reference circuit without the evidence and calculations required for that claim.

## Lab decision

No lab is justified yet. The remaining uncertainties are source/config/manual questions. Prefer evidence acquisition and standard engineering reasoning over synthetic simulation.

## Human-factors rule

Recovery must be easy but deliberate. Safeguards should be easier to use/reinstall correctly than to bypass. Diagnostics should identify the missing prerequisite without offering a bypass path. A LinuxCNC/HMI reset control is only a **request**; ordinary software must not become the sole safety authorization.
