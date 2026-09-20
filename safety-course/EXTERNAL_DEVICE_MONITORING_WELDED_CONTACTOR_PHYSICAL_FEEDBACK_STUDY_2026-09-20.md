# External-device monitoring, welded-contactor and physical-feedback study

Date: 2026-09-20

## Why this branch

After closing the generic safety-input fault-table branch, the next higher-value question is whether a safety output command alone proves that the downstream energy-switching device actually reached its de-energized state.

## Manufacturer evidence

### Rockwell SafeZone EDM — DOC-CONFIRMED

Rockwell's SafeZone scanner documentation describes External Device Monitoring (EDM) for the contactors driven by its two OSSDs. The machine is allowed to start only if both monitored contactors are in their de-energized state at reset. The scanner checks the contactors after each protective-field interruption and before machine restart so a welded contactor can be detected.

The implementation uses positively driven/positively guided N/C feedback contacts from the external contactors. If the expected de-energized feedback state is not present, restart is prevented; depending on restart configuration the system either locks out or keeps its OSSDs deactivated and reports the fault/reset requirement.

Rockwell's SC300 documentation similarly states that EDM checks whether external contactors actually de-energize when the protective device triggers. If the expected response is not detected within the documented interval, the OSSDs are deactivated again; inability to reach a safe operational state can produce lock-out.

Evidence class: DOC-CONFIRMED.

### Pilz myPNOZ feedback loop — DOC-CONFIRMED

Pilz's current myPNOZ application documentation connects N/C feedback-loop contacts from external contactors to the relevant output module. Those feedback contacts must be closed before starting; if a feedback contact remains open, myPNOZ and therefore the connected plant/machine cannot restart.

Pilz PNOZ X9P documentation adds an important lifecycle point: relay-output mechanical contact opening cannot always be tested automatically while outputs remain switched on. It requires periodic switching/test behavior so internal diagnostics can verify correct opening, and states that safety functions should be checked after initial commissioning and whenever the plant/machine is changed.

## Durable conclusions

`SAFETY OUTPUT COMMANDED OFF != EXTERNAL CONTACTOR DE-ENERGIZED`.

`CONTACTOR COIL DE-ENERGIZED != POWER CONTACTS PHYSICALLY OPEN`.

`EDM FEEDBACK CLOSED != ALL HAZARDOUS ENERGY REMOVED`; EDM is evidence about the monitored switching element, not universal proof of hydraulic, pneumatic, gravity, stored electrical or mechanical energy state.

`RESET REQUESTED != EDM HEALTHY != RESTART AUTHORIZED`.

`CONTACTOR WORKED DURING PRODUCTION != CONTACTOR OPENING DIAGNOSTIC PROVED`; periodic or demand-driven exercise may be required to expose latent non-opening faults.

`DIAGNOSTIC AUXILIARY CONTACT STATE != PHYSICAL LOAD POWER ABSENT` unless the safety architecture and validation establish the relationship and required fault assumptions.

## Architecture implication

The reusable safety architecture needs explicit final-element feedback where required rather than assuming that an output bit, OSSD state, FPGA pin, relay-coil command or LinuxCNC HAL value proves physical energy interruption. Ordinary LinuxCNC/FPGA may display and record EDM state, but should not replace the independent safety evaluation that owns the monitored contactors.

For hydraulic machines, this same reasoning pattern is transferable but not automatically equivalent: spool-position feedback, pressure witness, ram motion witness and electrical contactor EDM prove different physical facts. Do not substitute one for another.

## Human-factors implication

A failed EDM loop should produce an obvious non-start/lockout condition and actionable diagnostic rather than inviting an operator to repeatedly press Reset. Maintenance instructions should make restoration of the real feedback path easier than bypassing it.

## Next evidence question

Study final-element proof beyond contactors: compare electrical EDM with drive STO feedback/status and hydraulic valve/spool monitoring, explicitly identifying what each witness proves and what it cannot prove. Prefer manufacturer architectures with physical feedback and restart inhibition. Do not infer safety rating from ordinary status bits.

## Sources

- Rockwell Automation, SafeZone Singlezone and Multizone Safety Laser Scanner User Manual, Publication 442L-UM003C-EN-P, February 2025.
- Rockwell Automation, SC300 Safety Sensor User Manual, Publication 442L-UM004C-EN-P, July 2020.
- Pilz, myPNOZ Signal forwarding application description, 1005677-EN-02, 2026.
- Pilz, PNOZ X9P Operating Manual, 1003362-EN-15, 2025.

## Compute

No executable lab justified; no GitHub-hosted or self-hosted compute used.
