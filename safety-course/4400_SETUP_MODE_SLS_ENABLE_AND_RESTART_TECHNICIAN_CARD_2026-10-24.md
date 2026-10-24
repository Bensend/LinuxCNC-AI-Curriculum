# 4400-SET-01 — Technician paper exercise: setup mode, enabling, speed and LOTO
**2026-10-24 | 18 PAPER SCENARIOS ONLY | NOT RUN | NOT MACHINE VALIDATION**

For each case identify (a) hazard and exposed people; (b) ordinary-control versus safety/physical authority; (c) whether the available information proves safe state; (d) minimum decisive OEM/as-built/physical witness; (e) safer easy-to-use redesign. Do not invent PL/SIL, pressure, speed, stopping distance or hydraulic truth tables.

| Case | Adversarial prompt | Minimum competent answer boundary |
|---|---|---|
| SET-01 | Jog speed in LinuxCNC set to 5%; guard open | Low command speed is not independently verified SLS; actual guard/stop/hold architecture required. |
| SET-02 | Three-position grip fully squeezed during panic | In cited Pilz family full squeeze is OFF; require independently verified physical safe response, not just a HAL bit. |
| SET-03 | Grip released; HMI shows "ready" | Enabling permission absent; HMI is not the physical stop witness. |
| SET-04 | Rockwell Kinetix ESM_In reads ON before door opens | Historical OEM says ESM not monitored until DM_In OFF in this mode; do not credit earlier state as proof. |
| SET-05 | Door opens during SLS delay | Exact Kinetix door monitor must be ON during delay or fault; no universal unlock timing. |
| SET-06 | Person inside cell; second operator turns mode selector to AUTO | Prohibit normal mode restoration; independent occupancy and mode authority, not just selector label. |
| SET-07 | Door closes behind an entrant | Door-closed != zone empty; prevent restart and rearm. |
| SET-08 | SLS trips and drive performs STOP A | Coast is not immediate stop or gravity hold; physical motion and access require validation. |
| SET-09 | SLS trips and drive performs STOP B | Controlled braking may fail with supply/drive fault; verify configured response, final elements and residual movement. |
| SET-10 | Siemens encoderless speed estimate after motor switched off | OEM example cannot directly monitor speed after power-off; do not claim stationary shaft or safe load. |
| SET-11 | LinuxCNC 2.7 manual says feed-inhibit includes jogs | Current manual says not jogs; pinned master keyboard JOG_CONT/INCR checks jog_inhibit but **joint wheel jog** still checks net_feed_scale. Exact path and enables mask matter; neither is safety-rated. |
| SET-12 | CNC jog-stop-immediate pin goes TRUE | HAL request is not a proven physical stop distance or safe holding. |
| SET-13 | Kinetix example resumes normal operation after setup exit | Example not permission for retained AUTO command; demand independent fresh start after verified exit/rearm. |
| SET-14 | Maintenance under a suspended hydraulic ram with SLS enabled | SLS cannot replace positive restraint, isolation and verified stored-energy control. |
| SET-15 | Repetitive production adjustment with guard removed | Test all OSHA minor-servicing criteria and effective alternative protection; do not assume exemption. |
| SET-16 | Long repair is relabelled "setup" to avoid LOTO | Label irrelevant; classify task/exposure and use applicable isolation. |
| SET-17 | Two workers perform separate setup tasks | Protect each worker; shared grip/door closed does not establish exclusive control or zone clearance. |
| SET-18 | Grip tether inconvenient, operators tape it down | Predictable bypass is design defect; improve ergonomic location, fixtures and mode-specific access while preserving independent protection. |

**Assessment:** For each case, mark DOC-CONFIRMED product/OSHA text separately from INFERENCE and selected-machine UNKNOWN. Do not score as independent fresh-AI competency; all 18 are learner-readable and answer-cued. Qualified isolated/remote future testing may use inert objects and instrumentation, never a person as a test target. G3/G4 NOT AUTHORIZED.
