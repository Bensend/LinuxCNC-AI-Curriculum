# 4400-REPLACE-01 — Safety I/O automatic replacement can reconnect without proving a machine safe
**2026-10-25 | Original Rockwell documentation | NON-GRADUATED / paper-only**

## Concrete question
Does an automatic safety I/O configuration transfer after replacement establish the replacement's physical protective function? **Pre-evidence prediction:** no; configuration transfer, network identity and actual protected machine response are different evidence layers.

## Manufacturer sources directly opened
1. Rockwell, *ControlLogix 5580 and GuardLogix 5580 — Safety I/O Replacement Options*: https://www.rockwellautomation.com/en-mde/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-replacement-options.html . **DOC-CONFIRMED** two selectable policies: `Only Allow Automatic Configuration When No Safety Signature Exists` and `Always Allow Automatic Configuration`. DeviceID combines node/IP and **Safety Network Number (SNN)**; matching DeviceID permits controller configuration transfer in the described case.
2. Rockwell, *Always Allow Automatic Configuration*: https://www.rockwellautomation.com/en-mde/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-replacement-options/always-allow-automatic-configuration.html . **DOC-CONFIRMED:** manufacturer limits this permissive option to circumstances where the **entire CIP Safety control system is not relied upon to maintain SIL 2/3 behavior during device replacement and functional testing**. Compatible device at network address with out-of-box state or matching SNN can be auto-connected. The OEM still requires prescribed **functional testing and authorization** after replacement.
3. Rockwell, *Scenario 1 — Replacement Device is Out-of-box and Safety Signature Exists*: https://www.rockwellautomation.com/en-mde/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-replacement-options/scenario-1---replacement-device-is-out-of-box-and-.html . **DOC-CONFIRMED:** the exact replacement procedure calls for verifying the alternating red/green network status on the **correct device** before confirming SNN, followed by company-prescribed functional testing. This is not a generic recipe for other controllers.
4. Rockwell, *GuardLogix 5580 Safety Signature* (separate scope): https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/guardlogix-functional-safety/safety-signature.html . The safety signature excludes the standard application and cannot alone prove physical installation.

## Fault-path analysis and boundaries
| Event | What can be DOC-CONFIRMED for this family | What remains UNKNOWN without physical proof |
|---|---|---|
| Replacement device has correct SNN and address | Controller may identify/connect/configure under selected option | Correct device *at the actual hazard*, optical alignment, contacts, wiring, output load, guarding, stop/hold |
| Permissive automatic replacement selected | OEM expressly constrains circumstances during replacement/testing | Whether alternate protections actually isolate the hazard; cannot assume full SIL 2/3 during this period |
| Device LEDs indicate network status | Correct module can be identified by OEM procedure | Hazardous motion stopped, gravity load held, pressure isolated |
| New module configured | Data transfer/re-established connection is possible | Independent function test and authorization are still required |
| Standard motion program updated separately | Safety signature may remain unchanged | Fresh-start semantics, changed approach timing, reset/occupancy and LinuxCNC-to-safety interface |

**Common-cause hazards:** swapped modules or addresses, default replacement policy left permissive, shared SNN confusion, wrong firmware/terminal mode, incorrect input pulse/OSSD filtering, field wiring backfeed, stale accepted configuration, unvalidated normal-control restart. Neither signature nor network LED supplies a physical safety witness.

## Practical design
- Inventory exact OEM controller/module suffix, firmware, device ID/SNN, replacement option, approved spare and accepted project baseline **in restricted machine documentation**.
- Require independent proof of correct device identity and controlled physical hazard before returning to service. Use a clearly labeled module/port map and preapproved replacement parts to make correct service easy.
- Separate four states: **network connected**, **safety logic healthy**, **physical hazard safely controlled**, **authorized new motion**. Never collapse them into a single READY bit.
- Treat an unexpected auto-reconnect as a hold point pending qualified review, not as an invitation to reset and run.
- No energized testing, resetting safety ownership or hardware substitution is authorized by this educational audit.

## Evidence and next work
**DOC-CONFIRMED:** exact Rockwell 5580 family replacement options and OEM retest requirement. **INFERENCE:** four-state human-factor/architecture contract. **UNKNOWN:** OpenPressBrake uses this equipment at all; selected module, safe-state physics, function test, evaluator, PL/SIL. **TEST-CONFIRMED:** none; **SOURCE-CONFIRMED LinuxCNC:** none; **COMMUNITY-REPORTED:** none. No simulation/build/Actions justified. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED.
