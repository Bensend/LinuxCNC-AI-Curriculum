# Real LinuxCNC Safety Integrations + Safety-Relay Evidence — 2026-09-15

Session start: **2026-09-15T14:34:09Z**.

Purpose: advance R-SAFE-01/R-SAFE-02 from the active safety checkpoint. This pass deliberately separates what the LinuxCNC configuration can prove from what only machine wiring/manual evidence can prove.

## Evidence labels

- `SOURCE-CONFIRMED`: inspectable configuration/source directly shows the behavior.
- `DOC-CONFIRMED`: manufacturer or project documentation explicitly states the behavior.
- `COMMUNITY-REPORTED`: public build/forum evidence; useful but not a certification basis.
- `INFERENCE`: engineering conclusion from cited evidence; must not be promoted into a product claim without validation.
- `UNKNOWN`: not established by the inspected evidence.

## Integration A — Fenja/Groot router, Mesa 7i76E + Pilz PNOZ 11

Public repo: `GuiHue/myfenjalinuxcnc`, inspected at commit surfaced by GitHub code search `16af9ade9484e9f6897b19bd6453ab4bbe79c0ac` and current README.

The README identifies a real router using Mesa 7i76E, JMC axis drives, a Hitachi WJ-200 VFD and **Pilz PNOZ 11**. It explicitly says the PNOZ semiconductor output Y32 reports safety-relay state to LinuxCNC, while the relay also cuts power to the axis drives and is wired to the VFD. `hallib/io.hal` maps Y32 to Mesa DI07 as `estop-ext`; `hallib/estop.hal` ultimately feeds the composed E-stop signal to `iocontrol.0.emc-enable-in`.

Evidence classification:
- PNOZ 11 exists in this machine and Y32 -> Mesa DI07 -> LinuxCNC E-stop path: **SOURCE-CONFIRMED / project-DOC-CONFIRMED**.
- PNOZ independently affects axis-drive/VFD power: **project-DOC-CONFIRMED**, but the public HAL cannot prove the cabinet wiring.
- Exact PNOZ channel topology, reset mode, EDM wiring, contactor arrangement and achieved PL/SIL: **UNKNOWN** from the inspected repo.

Teaching consequence: the status signal into LinuxCNC is a **permission/status witness**, not the safety actuation path. A learner must not reconstruct the cabinet safety function from `emc-enable-in` alone.

## Integration B — XYYZ gantry router, Mesa 7i95T + Pilz PNOZ s4

Public repo: `zmrdko/mesa_7i95t_config`, current README plus indexed configuration at `94af1eb5b86127b314181fc5809d75f2d59526e8`.

The README identifies four Delta ASD-B2 servos, a Mesa 7i95T, a **Pilz PNOZ s4**, dual-Y gantry and an **on-screen safety-relay reset**.

Evidence classification:
- Hardware presence and software-exposed reset feature: **project-DOC-CONFIRMED**.
- Exact electrical reset circuit, whether the GUI command is a monitored reset request rather than safety authorization, STO/contactors controlled by PNOZ, EDM, and restart behavior after a fault: **UNKNOWN** until the specific HAL/wiring path and PNOZ s4 manual are reconciled.

Human-factors lesson: a convenient GUI reset can be acceptable only as a **reset request** where the safety device itself enforces the required reset semantics. A normal PC/HAL bit must not become the sole proof that the danger zone is clear or the sole safety authorization.

## Integration C — Maho MH600T retrofit drawing chronology

Public LinuxCNC forum attachments from Finngineering expose actual safety-circuit draft drawings dated **2023-08-11** and **2023-08-24**. The earlier drawing shows a CM22D0A safety relay with emergency stop, LinuxCNC E-stop, X/Y/Z overtravel inputs, a reset-safety-relay button and relay/contact outputs. The later drawing materially changes the architecture: it shows emergency stop, LinuxCNC E-stop, remote E-stop, X/Y/Z overtravel, explicit `Reset conditions (no stuck contacts)`, a reset-safety-relay button, relay chain K1–K6 and a `Safety relay tripped` status.

Evidence classification:
- Those signals and chronology are **DOC-CONFIRMED** by the public machine drawings.
- The change between August 11 and August 24 is evidence that commissioning/design review evolved the safety circuit; it is **not** proof that the later draft was the final commissioned circuit.
- Final machine validation, achieved PL/SIL/category, actual stopping time and contactor weld-detection coverage remain **UNKNOWN**.

Teaching consequence: preserve chronology. A later drawing with explicit stuck-contact reset conditions is stronger evidence of intended feedback monitoring than an earlier schematic, but neither should be called validated merely because it is detailed.

## Cross-machine pattern now supported

Across the Fenja router and Maho drawing, LinuxCNC receives/report states while external safety hardware owns at least part of hazardous-energy interruption. The second router independently demonstrates the same design family (external PNOZ safety relay with a software-facing reset request), although its exact wiring still needs tracing.

Freeze the conceptual boundary:

`operator/protective device -> safety logic -> safety outputs/energy-control hardware`

in parallel with

`safety status -> ordinary I/O -> LinuxCNC coordination/diagnostics`

and, where reset is software-originated:

`LinuxCNC/HMI reset request -> safety device reset input -> safety device decides whether reset/rearm conditions are valid`.

The arrows do **not** imply that LinuxCNC grants personnel-safety authorization.

## R-SAFE-02 relay comparison — first exact-manufacturer pass

### Omron G9SE

Current Omron specifications state a minimum reset-input time of **250 ms**. They define response time as the interval from safety input OFF until the safety main contact opens, including bounce. Omron also specifies an **8 A IEC 60127 fuse per contact output** for short-circuit protection. The product family is positioned as a compact safety relay with diagnostic indication.

Omron's safety-relay reset FAQ makes a critical semantic distinction: automatic reset can restart when the input becomes ON; manual reset requires a reset switch in the feedback circuit. Omron explicitly directs manual reset for emergency-stop circuits and guards through which people can enter, with product-specific exceptions that must be respected.

Evidence: **DOC-CONFIRMED** from Omron product/specification/FAQ pages. Exact G9SE model response-time and PL/SIL values still need model-specific manual extraction before freezing a complete row.

### Rockwell Guardmaster examples

Rockwell's current MSR127R product data identifies **Manual Monitored Reset**. The MSR117T identifies **Automatic/Manual Monitored** reset. A current Guardmaster relay product page (440R-M23143) exposes a **15 ms response time**, **100 ms recovery time**, Category 4 instantaneous architecture data, DC 90%, PFHd and MTTFd values for that exact product record.

Evidence: **DOC-CONFIRMED** for those exact product records. Do not transpose the 15 ms or Category/PL-related data to another Guardmaster model.

### Pilz PNOZ X3

Pilz's current product/document page exposes the PNOZ X3 operating manual revisions, including 2025/2026 manuals. This pass confirms the exact-manual source exists but does not yet freeze response time, EDM/channel diagnostics or PL/SIL values because those values must be extracted from the actual selected revision rather than a secondary summary.

Evidence: manual availability **DOC-CONFIRMED**; detailed row **OPEN**.

## Failure exercise seed — welded contact / failed external device

Scenario: a safety relay removes its safety outputs, but one downstream contactor remains mechanically welded closed.

The learner must answer in this order:
1. What hazardous energy can the welded contactor still pass?
2. Is there a second independent output element or drive STO channel that actually reaches the required safe state?
3. What feedback path proves the external device changed state before reset/restart?
4. Does the safety relay's reset/EDM circuit refuse rearm when feedback is inconsistent?
5. What does LinuxCNC see, and why is that diagnostic visibility not a substitute for the external feedback function?
6. What physical test demonstrates the fault is detected before hazardous restart?

Do not award a PL/category/SIL answer from topology alone. The exercise is about authority, feedback and restart inhibition first; quantitative safety claims require the actual device architecture, failure data, application assumptions and validation.

## Human-factors findings

- Reset should be easy to understand and deliberate, but it should not silently become restart.
- Diagnostics should say *which prerequisite is missing* (E-stop channel open, guard open, EDM mismatch, drive not safe, etc.) without exposing a bypass control.
- If an HMI reset request is used, loss/reboot/stuck-state of the ordinary controller must not create safety authorization.
- Safeguard wiring and connectors should make correct restoration easier than bypassing or leaving a channel defeated.

## Remaining high-information work

1. Fetch the exact current PNOZ X3 and PNOZ s4 manuals and extract channel/cross-short behavior, reset modes, EDM, response/recovery times, output ratings/fusing, PL/SIL restrictions and wiring examples.
2. Trace the `zmrdko` on-screen PNOZ reset path through HAL and identify whether the safety relay itself performs monitored reset semantics.
3. Find a third public LinuxCNC integration with **explicit STO wiring** (not merely an E-stop input) and preserve commissioning chronology.
4. Turn the welded-contactor seed above into the first scored safety exercise after exact EDM manual evidence is captured.
5. Build the first generic hazard -> hazardous event -> safety function -> safe state -> reset/restart -> validation teaching artifact. Do not assign performance level from a generic drawing.

## Sources

- GuiHue/myfenjalinuxcnc README and HAL, GitHub.
- zmrdko/mesa_7i95t_config README/configuration, GitHub.
- Finngineering Maho MH600T CNC safety-circuit drafts, LinuxCNC forum attachments dated 2023-08-11 and 2023-08-24.
- Omron G9SE specifications and Omron safety-relay reset FAQ.
- Rockwell Automation Guardmaster/MSR product records.
- Pilz PNOZ X3 product/document page and operating-manual index.
