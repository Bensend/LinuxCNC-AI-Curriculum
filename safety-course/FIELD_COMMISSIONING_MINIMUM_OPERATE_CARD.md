# Field commissioning / minimum-operate card

Use this as a compact field gate after the full machine risk assessment, safety requirements and detailed validation package have defined what the machine must do. It is not a substitute for those documents and does not assign PL/SIL, stopping distance, safe speed, pressure or response-time values.

**Rule:** if a safety-critical item below is `UNKNOWN`, the affected exposed operating state is **NOT CLEARED**. If an engineering test still has legitimate information value, isolate/remote the test, keep people outside the danger zone, minimize energy/duration, provide an independent energy-removal means, and return the machine to unmistakable OUT OF SERVICE status afterward.

## A. Before hazardous energy

- [ ] **HAZARD BOUNDARY** — electrical, hydraulic, pneumatic, gravity, stored electrical/mechanical/thermal and tooling hazards relevant to this machine/task are identified.
- [ ] **DRAWING MATCH** — released electrical/hydraulic/pneumatic drawings and safety configuration match the machine as built; undocumented jumpers/forces/bypasses are absent or explicitly controlled by the current test.
- [ ] **INDEPENDENT SAFETY AUTHORITY** — ordinary LinuxCNC/HAL/FPGA/network logic is not the sole personnel-safety authority.
- [ ] **FINAL ELEMENTS IDENTIFIED** — contactors, STO channels, safety/holding valves, brakes/restraints and other final elements are named and their actual physical energy paths are traced.
- [ ] **GRAVITY/STORED ENERGY** — blocking, restraint, discharge or holding strategy is established before exposure.

## B. Integrity gates

- [ ] **MODE INTEGRITY** — one ordinary-control, selector-wiring, permission or configuration fault cannot silently create a less-protective operating mode. Mode selection does not itself start hazardous motion.
- [ ] **FEEDBACK INTEGRITY** — final-element feedback/EDM cannot share an obvious single wiring/configuration failure that falsely proves multiple final elements safe. Feedback proves element state, not absence of every hazardous energy source.
- [ ] **COMMON CAUSE** — redundant channels are reviewed for shared supply/return, connector/harness, environmental, transient, contamination, software/configuration and mechanical/hydraulic common causes.
- [ ] **LATENT FAILURE** — faults that can remain hidden until the next safety demand have a detection/test path and defined response.
- [ ] **RESTART INTEGRITY** — demand clearing, reset, fault acknowledgment, LinuxCNC/FPGA reboot, network recovery and power restoration cannot silently create hazardous motion; separate deliberate START is proved where required.
- [ ] **RESET/START SEPARATION** — safety reset restores readiness only; it does not execute a queued CNC command, restore actuator authority by itself, or turn a held foot/jog/cycle-start command into motion.

## C. Functional proof

- [ ] **PROTECTIVE DEVICES** — E-stops, guards/interlocks, light curtains/laser protection, enabling devices and other claimed protective devices are exercised in every applicable operating mode.
- [ ] **PHYSICAL FINAL-ELEMENT PROOF** — tests observe actual contactor/valve/brake/restraint response and required feedback, not only controller LEDs or software bits.
- [ ] **SINGLE-FAULT / DISCREPANCY TESTS** — bounded tests cover representative channel disagreement, missing/stuck feedback and other faults required by the safety architecture.
- [ ] **STOPPING / LIMIT REQUIREMENTS** — every machine-specific stopping, speed, position, pressure or timing acceptance criterion required by the safety concept comes from an established requirement and has valid evidence. No invented numbers.
- [ ] **SPECIAL / SETUP MODES** — any mode that weakens normal guarding is deliberate, conspicuous and bounded; compensating protection is established. A convenient guard bypass is not accepted as a setup mode.
- [ ] **ACCESS / UNLOCK AUTHORITY** — where guard locking protects personnel, ordinary CNC/HMI may request access but does not alone decide that the physical hazard is absent; actual lock state is observed where required.
- [ ] **ESCAPE / OCCUPANCY** — an entered person cannot be trapped by loss of LinuxCNC/HMI/network/normal-controller power, and the architecture prevents restart while a person may remain inside a blind or accessible guarded space.
- [ ] **DEFEAT RESISTANCE** — normal production/setup does not impose avoidable friction that predictably encourages taped/wedged/spoofed/removed safeguards; foreseeable manipulation has appropriate design countermeasures.

## D. Return to service

- [ ] **RESTORATION SWEEP** — jumpers, lifted wires, test plugs, external supplies, forced I/O/HAL/PLC states, diagnostic firmware/software, temporary parameters, bypasses, temporary hydraulic/pneumatic connections, service tooling and removed guards are reconciled.
- [ ] **BLOCK/RESTRAINT TRANSITION** — before removing a mechanical restraint, the function taking over its protective role is already proved available.
- [ ] **RESET LOCATION / PERSONNEL CLEAR** — reset is outside the hazard zone, cannot be casually operated from inside it, and the resetter has the required view/zone-clear evidence; blind spaces have an engineered occupancy/restart-inhibition strategy rather than a warning-only workaround.
- [ ] **OUT-OF-SERVICE FALLBACK** — if any required item remains unresolved, the machine is left unmistakably OUT OF SERVICE / DO NOT OPERATE. Tag-out communicates state; it does not replace physical hazard control.

## Release statement

`CLEARED FOR THE DEFINED OPERATING STATE` only when every applicable safety-critical item above is closed from design evidence and validation. Otherwise record the exact unresolved item and keep the affected operating state `NOT CLEARED`.

For detailed test design, use `COMMISSIONING_VALIDATION_FAULT_INJECTION_PACKAGE_2026-09-17.md`, `COMMON_CAUSE_LATENT_FAILURE_AND_MINIMUM_OPERATE_GATE_2026-09-17.md`, `HUMAN_FACTORS_RESTART_ACCESS_AND_GUARDING_REVIEW_2026-09-17.md`, and the applicable complete-machine trace.
