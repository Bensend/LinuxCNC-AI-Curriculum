# HYD-DRAIN-01 — No new CNC command does not guarantee a stationary hydraulic spool
**4400 technician review | 2026-10-28 | documentary, NOT RUN.**

**Unexpected path:** Parker's D111VW installation page A257 warns that surges in a **shared tank/pilot-drain line** can shift a directional spool. Its detented-style example retains the last spool position after power or pilot pressure is lost; spring-centered and spring-offset examples behave differently. Main hydraulic flow may continue even after the electrical command disappears. This is a catalog warning, **not** a claim that OpenPressBrake has that valve or fault.

**Keep three questions separate:** (1) What did LinuxCNC/FPGA request? (2) What are the actual pilot X/Y, return and spool states? (3) What independent safety-related hydraulic final element physically prevents hazardous ram motion and holds the load? A valve LED, pump OFF status or safety reset bit cannot answer all three.

**Make the safe option easy:** retain exact valve order code, internal/external drain selection, marked X/Y/return line, approved replacement, and a short maintenance change-impact card. If a shared return is surge-prone, follow the selected OEM's engineering guidance; **do not** improvise drain rerouting or energize a press to see what happens.

**Reviewer challenge:** If a second actuator dumps oil into the common return while a detented spool retains its last position, which independent physical stop/hold witness remains valid? If the circuit, fault coverage and proof are unknown, the correct disposition is **HOLD**, not a test with someone near the ram.

Sources: [Parker original MSG14-2500/US A257](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Valve-Division/hydraulicvalve/Catalog-sections-for-websphere/Industrial-Directional-Control/Catalog---Static-Files/D111VW.pdf), [original audit](../research/4400_HYD_DRAIN_01_PARKER_D111VW_SHARED_DRAIN_SURGE_DETENT_POWER_LOSS_SOURCE_AUDIT_2026-10-28.md). **DOC-CONFIRMED OEM only; selected machine UNKNOWN; G0/G1 HOLD.**
