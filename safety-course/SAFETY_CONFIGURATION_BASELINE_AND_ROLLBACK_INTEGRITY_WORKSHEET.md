# Safety Configuration Baseline and Rollback Integrity Worksheet

Date: 2026-09-17

## Purpose

Prevent a maintenance, recovery, controller replacement, backup restore, firmware change, or rollback from restoring a configuration that is internally valid but no longer matches the installed machine.

Core rule:

> **A backup is evidence of what was saved, not proof that it is safe for the hardware that exists now.**

Restoring ordinary LinuxCNC/HAL/FPGA software is not the same event as restoring independent safety authority. A checksum/signature can establish configuration identity/integrity within its defined scope; it does not prove that field wiring, valves, contactors, guards, sensors, drive parameters, mechanical restraint, or hydraulic topology still match the validated machine.

## Evidence basis

### SOURCE-CONFIRMED / manufacturer documentation

- Rockwell GuardLogix documentation states that after downloading a safety application, application testing is required unless a safety signature exists; to verify a restored/downloaded application, the safety signature must be manually checked against the original safety documentation. If a mismatch requires unlocking/deleting the signature, the application requires revalidation.
- Rockwell states that its safety signature uniquely identifies the safety portion of a project, including logic, constant data, and configuration, and recommends recording/checking it after downloads. Firmware compatibility and controller state are also checked during safety-project download.
- Rockwell safety I/O uses device configuration signatures; connection identity/ownership also depends on node/slot, Safety Network Number, path and configuration signature. Device replacement behavior is therefore a controlled safety-lifecycle issue, not simply a generic backup restore.
- SICK Flexi Soft verification reads downloaded configuration back from the safety controller, compares it with project data, presents a report for confirmation, and only then treats the station as verified. Newer Flexi Soft gateway documentation exposes current and most-recently-verified checksums and describes verification as comparing the Safety Designer configuration checksum to the configuration stored in the device.
- Pilz PNOZ s30 documentation instructs the user to verify that the Configuration CRC in the physical PNOZ s30 matches the CRC displayed by the configurator after download.

### INFERENCE / curriculum engineering structure

The baseline manifest, rollback gates, compatibility matrix, and `IDENTICAL / COMPATIBLE-REVALIDATE / INCOMPATIBLE / UNKNOWN` classifications below are engineering controls synthesized from those lifecycle principles. They are not claimed as verbatim requirements of any one manufacturer or standard.

## 1. Freeze the validated baseline

For every commissioned machine, record the identity that actually participated in validation.

| Baseline item | Recorded identity / value | Evidence location | Safety relevance | Owner |
|---|---|---|---|---|
| Machine identity / serial | | | | |
| Electrical drawing revision | | | | |
| Hydraulic/pneumatic drawing revision | | | | |
| Guard/access drawing revision | | | | |
| Safety controller model / firmware | | | | |
| Safety project name / version | | | | |
| Safety signature / CRC / checksum | | | | |
| Safety I/O identities / signatures | | | | |
| Safety network/device identity | | | | |
| Drive model / safety firmware / safety parameters | | | | |
| Final contactor / STO / valve / brake identities | | | | |
| EDM / final-element feedback wiring revision | | | | |
| Protective-device models/configuration | | | | |
| Operating-mode selector/configuration | | | | |
| LinuxCNC version / commit or package identity | | | | |
| INI / HAL / userspace PLC/config revision | | | | |
| FPGA bitstream / firmware identity | | | | |
| Transport/protocol configuration | | | | |
| Ordinary drive/current/valve parameters | | | | |
| Mechanical blocking/restraint configuration | | | | |
| Validation report / commissioning record | | | | |

A baseline is incomplete if the restored file can be identified but the physical configuration against which it was validated cannot.

## 2. Separate configuration authorities

Keep these as separate records even when one engineering workstation stores all of them:

1. **Ordinary control** — LinuxCNC, HAL, GUI, PLC/userspace logic, recipes and machine parameters.
2. **Normal hardware/FPGA control** — bitstream, I/O mapping, watchdog/freshness behavior, proportional/servo parameters and communications.
3. **Safety-related configuration** — safety controller logic, safety I/O, safe drive functions, safety mode selection, reset/restart logic, EDM/final-element monitoring.
4. **Physical energy-control implementation** — contactors, STO wiring, hydraulic/pneumatic valves, brakes, blocks/restraints and the energy paths they actually interrupt/control.

Do not let restoring (1) or (2) silently assert that (3) or (4) is valid.

## 3. Backup record

For each controlled backup capture:

- machine identity;
- capture UTC date/time;
- source device/project;
- software/tool and version used to capture it;
- firmware/hardware compatibility range if documented;
- safety signature/CRC/checksum and its defined scope;
- ordinary-control revision and FPGA/firmware identity separately;
- drawing revisions current at capture;
- validation report associated with that exact baseline;
- known temporary edits, forces, bypasses, diagnostic firmware, overrides or service state;
- whether the backup is **VALIDATED BASELINE**, **DEVELOPMENT**, **SERVICE SNAPSHOT**, or **UNKNOWN**.

A service snapshot must never be promoted to validated baseline merely because it is newest.

## 4. Pre-rollback compatibility gate

Before any restore, compare backup identity to installed machine.

For every row classify:

- `IDENTICAL` — same validated item/identity;
- `COMPATIBLE-REVALIDATE` — change may be acceptable but affected claims require revalidation;
- `INCOMPATIBLE` — do not restore/operate in the affected state;
- `UNKNOWN` — do not claim the affected safety function is validated.

| Comparison | Classification | Evidence | Required action before exposed operation |
|---|---|---|---|
| Machine identity matches backup | | | |
| Safety controller hardware/firmware compatible | | | |
| Safety project signature/CRC/checksum matches intended validated baseline | | | |
| Safety I/O identity/configuration matches | | | |
| Drive/STO/safe-motion hardware and parameters match | | | |
| Protective devices and configuration match | | | |
| Mode selector / enabling devices match | | | |
| Contactors/valves/brakes and feedback contacts match | | | |
| Electrical/hydraulic drawings match installed hardware | | | |
| Guard/access arrangement matches | | | |
| LinuxCNC/HAL interfaces presented to safety system match | | | |
| FPGA I/O mapping/watchdog behavior matches | | | |
| Ordinary actuator parameters match physical hardware | | | |
| Known modifications since backup reconciled | | | |

**Stop condition:** a safety-critical `INCOMPATIBLE` or unresolved `UNKNOWN` keeps the affected exposed operating state **NOT CLEARED**.

## 5. Restore authorization boundary

The person/process permitted to restore ordinary LinuxCNC files does not automatically have authority to alter or restore safety configuration.

Record separately:

- who may restore ordinary controller software;
- who may alter/download safety configuration;
- credentials/keys/tools required;
- whether safety locking/signature protection is active;
- what action invalidates a signature/verified state;
- what validation is mandatory after that action;
- how uncontrolled copies are prevented from being mistaken for the validated baseline.

Never create a maintenance shortcut where a LinuxCNC startup script, generic image restore, FPGA updater, or network provisioning operation automatically overwrites safety-controller configuration.

## 6. Post-restore proof

A successful file transfer is only the first proof layer.

Require, as applicable:

1. **Transfer integrity** — manufacturer-supported CRC/signature/checksum/readback agrees with the intended baseline.
2. **Hardware identity** — target controller/I/O/device identity and firmware are the intended compatible hardware.
3. **Physical correspondence** — drawings, field wiring, protective devices, final elements and feedback paths correspond to the validated baseline or have entered controlled change revalidation.
4. **Safety-function validation** — affected protective-device, stop, reset/restart, mode, EDM/final-element and power-restoration behavior is physically rechecked to the required scope.
5. **Normal-control freshness** — LinuxCNC/FPGA restart or reconnection cannot release a stale command when safety readiness returns.
6. **Return-to-service reconciliation** — forces, bypasses, jumpers, diagnostic firmware, temporary supplies, mechanical blocks and service tooling are reconciled before release.

## 7. Rollback adversarial tests

At minimum challenge these scenarios in the validation plan:

- old safety backup + newer field wiring;
- correct safety project + wrong replacement I/O identity/configuration;
- correct LinuxCNC backup + old FPGA I/O map;
- correct FPGA image + changed HAL pin mapping;
- safety signature matches but a final contactor/valve was replaced with a different feedback arrangement;
- controller replacement restores configuration but safety network/device identity differs;
- firmware upgrade/downgrade invalidates or deletes the validated signature/state;
- newest backup contains a maintenance force, bypass or diagnostic configuration;
- restore reinitializes safety/ordinary data to saved values that can affect restart behavior;
- rollback removes a later fix for a previously discovered hazardous failure path;
- backup server/file name is correct but machine identity is wrong;
- safety configuration is correct but hydraulic/mechanical machine changes make the old validation evidence obsolete.

For each test record **prediction -> observed evidence -> affected safety claim -> pass/fail -> required revalidation**.

## 8. Human-factors rule

Make the validated baseline easier to identify and restore correctly than an arbitrary old copy:

- one clearly designated validated release;
- machine identity visible in the backup and on the machine;
- safety signature/CRC/checksum visible in the commissioning record;
- development/service snapshots visually and procedurally distinct;
- no ambiguous filenames such as `final2`, `old-good`, or `backup-new` as authority;
- restoration checklist points directly to the correct physical drawings and validation record;
- a mismatch produces an obvious **NOT CLEARED** state rather than a warning that can be clicked through and forgotten.

## 9. What a matching checksum does *not* prove

Even a correct manufacturer safety signature/CRC/checksum does **not by itself prove**:

- field wiring is unchanged;
- the correct valve/contactor/brake is installed;
- hydraulic plumbing is unchanged;
- a guard cannot be defeated;
- mechanical restraint is adequate;
- stopping distance/time is acceptable;
- EDM contacts truthfully represent the final element;
- the machine has no stored-energy hazard;
- LinuxCNC/FPGA ordinary control cannot present a stale command;
- machine-specific PL/SIL/DC requirements are achieved.

Those remain separate evidence obligations.

## 10. Minimum release statement

A restored machine may return to exposed operation only when the configuration identity is established, hardware/physical correspondence is established, all affected safety claims have valid evidence, required physical validation has passed, and the return-to-service reconciliation is complete.

If that cannot yet be shown, the machine remains **OUT OF SERVICE / NOT CLEARED**. If a bounded engineering test is necessary, use the curriculum's isolated/remote-test rules with people outside the danger zone and minimize energy/duration.

## Open machine-specific unknowns

Do not invent values for:

- required PL/SIL/DC;
- proof-test interval;
- stopping time/distance;
- safe speed/pressure/force;
- hydraulic valve truth table;
- acceptable firmware compatibility;
- device replacement policy;
- exact scope of revalidation after a change.

Resolve them from the actual machine risk assessment, manufacturer documentation, safety design and jurisdiction before claiming the affected function is validated.
