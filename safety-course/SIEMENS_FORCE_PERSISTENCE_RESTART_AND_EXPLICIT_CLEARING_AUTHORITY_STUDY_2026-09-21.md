# Siemens force persistence, restart, and explicit-clearing authority study

Date: 2026-09-21
Course: 4000 safety / 25C0 human factors and return-to-service

## Question

Can restart, engineering-tool closure, or return to an ordinary operating mode be treated as evidence that a temporary commissioning force has disappeared?

## Authoritative evidence

### Siemens S7-1200 force state is not scoped to the engineering UI session

**DOC-CONFIRMED.** Siemens S7-1200 System Manual V4.3 states that when an input or output is forced in a force table, the force actions become part of the project configuration. Closing STEP 7 does not clear them: the forced elements remain active in the CPU program until explicitly cleared. The documented clearing action is to reconnect online and stop/turn off the force function in the force table.

Source: Siemens, *S7-1200 Programmable Controller System Manual*, V4.3.0, 02/2019, A5E02486680-AM, force-table section.
https://cache.industry.siemens.com/dl/files/129/109764129/att_974298/v1/s71200_system_manual_en-US_en-US.pdf

### Older STEP 7 likewise treats the force job as CPU-resident state

**DOC-CONFIRMED.** Siemens *Programming with STEP 7*, 04/2017, describes a force job existing on the CPU, provides an operation to read it from the CPU, and requires an explicit `Delete Force` operation to delete force values from the selected CPU. This independently supports the distinction between closing/changing the engineering view and actually removing the exceptional state from the controller.

Source: Siemens, *Programming with STEP 7*, 04/2017, A5E41552389-AA, section 20.8.
https://cache.industry.siemens.com/dl/files/825/109751825/att_933142/v1/STEP_7_-_Programming_with_STEP_7.pdf

## Engineering interpretation

The useful safety lesson is not that every controller retains every force across every reboot. That would be an unsupported generalization. The durable lesson is that **temporary commissioning state may be controller-resident and may outlive the engineering UI/session that created it**. Therefore a production handoff cannot infer absence of forces merely because the programming software was closed, the technician disconnected, the controller changed mode, or a new operator arrived.

A return-to-service procedure needs positive evidence appropriate to the actual platform that exceptional state has been removed. Where a platform exposes a force table/status, use it. Where a controller documents an explicit clear/delete operation, perform and verify that operation rather than relying on an unrelated transition.

## Human-factors consequence

Forcing is especially defeat-prone because the physical machine may look normal while the controller is intentionally substituting a value for physical I/O. A safer architecture makes the exceptional state conspicuous and production-incompatible where practical:

1. temporary force/simulation/override state is explicitly inventoried;
2. production release requires an explicit clearing/removal step;
3. the cleared state is positively verified from the controller/platform, not inferred from closing a laptop or changing personnel;
4. ordinary physical I/O behavior is functionally rechecked where the force could have masked it;
5. reset/rearm remains distinct from a fresh ordinary START.

## Frozen distinctions

- **ENGINEERING TOOL CLOSED != FORCE REMOVED**
- **TECHNICIAN DISCONNECTED != CONTROLLER-RESIDENT EXCEPTIONAL STATE CLEARED**
- **ORDINARY MODE SELECTED != FORCE ABSENT** unless the platform specifically documents that transition as a clearing mechanism
- **RESTART/REBOOT != FORCE CLEARED** unless the exact controller/version documents that behavior and it is verified
- **FORCE COMMAND CLEARED != PHYSICAL I/O PATH FUNCTIONALLY REVALIDATED** when the force could have masked a field fault
- **PRODUCTION HANDOFF != PRODUCTION CONFIGURATION RESTORED** without positive exceptional-state disposition

## Provenance and transfer boundary

The Siemens behavior above is `DOC-CONFIRMED` for the cited Siemens platforms/manuals. The generic return-to-service rule is `INFERENCE` supported by that evidence and the existing FANUC/Rockwell studies. It is not evidence that LinuxCNC, an OpenPressBrake FPGA, or any other PLC has identical persistence semantics.

OpenPressBrake-specific temporary-state persistence, clearing on cold start, UI indicators, authorization model, production interlocks, and required functional retests remain `UNKNOWN` until its actual implementation is defined and verified.

## Curriculum consequence

25C0 should teach a **positive-clear rule**: every exceptional commissioning authority needs an explicit owner, visible state, removal action, and production-release witness. Do not teach reboot as a universal sanitization mechanism. Reboot may itself load retained/nonvolatile state, and platform semantics must be established rather than assumed.

## Compute

No executable compute was justified. No GitHub-hosted runner was used.
