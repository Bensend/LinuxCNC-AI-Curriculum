# Rockwell PlantPAx bypass aggregation and production-gate boundary

Session start: 2026-09-21T06:33:07Z

## Question
Can a running industrial controller expose more than one exceptional-state class strongly enough to support a production-handoff gate, without confusing that ordinary-control gate with personnel-safety authority?

## Evidence

### DOC-CONFIRMED — PlantPAx exposes live bypass state
Rockwell Studio 5000 PlantPAx `PINTLK` documentation states that process interlocks can be configured bypassable, that Maintenance selects bypasses from those Engineering permits, and that bypassed inputs do not raise the normal interlock condition when the connected device has bypass enabled. The online properties expose overall `Bypassed` / `Not bypassed` state and per-interlock state.

Source: Rockwell Automation, Studio 5000 Logix Designer v38, **Process Interlocks (PINTLK)** and **Monitor PINTLK parameter values** (retrieved 2026-09-21).

### DOC-CONFIRMED — Equipment Phase aggregates bypass state
Rockwell PlantPAx Equipment Manager / Equipment Phase User Guide, PROCES-UM110C-EN-P (Nov. 2025), documents `Sts_BypActive` on an Equipment Phase. The guide shows `Sts_BypActive` wired to `Inp_BypActive` on PINTLK/PPERM instances and states that bypass can be enabled from the HMI. This is stronger than a workstation-only indication: the equipment object carries a runtime bypass summary.

### DOC-CONFIRMED — interlocks can prevent energization/start
Rockwell documents PINTLK as collecting interlock conditions that stop/de-energize running equipment and can prevent equipment from starting or energizing. Therefore a production-permission layer can consume a bypass-clean condition in ordinary control logic rather than relying on operator memory.

### Existing course evidence retained
Prior course work established that Logix running logic can read `MODULE.ForceStatus` with GSV (installed and enabled are distinct) and can read a controller Audit Value whose configured change set can include online edits and force operations. These are separate evidence classes from PlantPAx equipment bypass state.

## What the sources do NOT prove

No public Rockwell source found in this pass shows a single vendor-supplied universal `production_clean` API that automatically combines controller force state, audit/baseline state, PlantPAx maintenance bypass state, physical temporary jumpers, and personnel-presence state.

The defensible architecture is therefore a curriculum **INFERENCE**, not a claimed Rockwell product guarantee:

`ordinary_production_release = no_forces_installed AND no_equipment_bypass_active AND accepted_baseline_disposition AND service/test_mode_clear AND physical_handoff_complete`

The exact inputs are machine/project specific. A LinuxCNC/PLC/FPGA implementation may use such an ordinary-control release to make accidental production with commissioning exceptions harder, but it must not be represented as the personnel-safety function.

## Boundary with independent safety

PlantPAx process interlocks, controller force status, audit values, LinuxCNC HAL state, and a normal FPGA controller can provide diagnostics and ordinary production inhibition. They are not thereby safety-rated protective functions. Personnel clear, guard/ESPE status, safety reset/rearm, safety-rated final-element action, and required physical validation remain under the independently engineered safety architecture.

Freeze:

- **EQUIPMENT BYPASS SUMMARY AVAILABLE != ALL EXCEPTIONAL STATE CLEAR.**
- **NO FORCES INSTALLED + NO PLANTPAX BYPASS != ACCEPTED PRODUCTION BASELINE PROVED.**
- **ORDINARY PRODUCTION GATE TRUE != PERSONNEL-SAFETY RELEASE.**
- **PERSONNEL-SAFETY RELEASE TRUE != ORDINARY PRODUCTION CONFIGURATION CLEAN.**
- **HMI SHOWS NO BYPASS != PHYSICAL TEMPORARY JUMPERS / TEST AIDS ABSENT.**

## Human-factors design consequence

A production handoff should fail visibly when a machine-readable exceptional state remains. Where a state cannot be observed programmatically (temporary jumper, blocking fixture, disconnected mechanical guard part, hydraulic test aid), the handoff needs a positive inspection/disposition step. Do not make the operator infer cleanliness from RUN mode or a green safety indicator.

This keeps the safer path easier: the machine itself can reject known software exceptions, while the handoff checklist is reserved for facts software cannot witness.

## Source-availability decision

The narrow search for a public OEM/vendor implementation of one universal aggregate gate is now at an information-gain stop. Rockwell exposes multiple useful component states, but the public evidence found does not justify claiming a universal cross-class production-clean primitive. Do not keep searching generic force/bypass tutorials to manufacture one.

## Next curriculum move
Rotate to an open 25C0/25E0 branch with higher information gain. A high-value target is the boundary between maintenance/service-mode authorization and *fresh* production start after the exceptional state clears: determine from authoritative implementations whether clearing a bypass/test mode can directly resume motion or whether a separate reset/rearm/new-start action is required. Preserve the distinction between ordinary-control restart discipline and independent safety restart authority.
