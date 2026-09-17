# Safety Safeguard-Defeat Key / Override Access Register

Date: 2026-09-17
Purpose: make temporary safeguard defeat, service overrides, keys, tools, passwords, and service credentials visible, bounded, recoverable, and auditable without pretending access control is itself a safety function.

## Frozen boundary

`possession of key/credential != task authorization != competence != isolation authority != permission for exposed hazardous operation != safety reset authority != ordinary-control rearm authority != START authority`

A key, password, jumper, service dongle, configuration privilege, bypass tool, or hidden HMI page is an **access-control mechanism**. It does not make an unsafe machine state safe and cannot substitute for an independent safety function, physical hazardous-energy control, or a machine-specific safe setup/service mode.

## Register

| ID | Key / tool / credential | Safeguard or function affected | Named holder | Authorized task | Issue UTC | Expiry / return trigger | Alternate protective measures required | Machine status during use | Restoration witness | Returned/revoked | Notes/evidence |
|---|---|---|---|---|---|---|---|---|---|---|---|
| OVR-001 |  |  |  |  |  |  |  |  |  |  |  |

Do not use shared identities such as `maintenance`, `operator`, or `admin` as the only holder record when an individual can be identified. If a credential must be shared because of legacy equipment, record that weakness explicitly and compensate with a controlled issue/recovery process.

## Issue gate

Before issuing or enabling an override:

1. Identify the exact task that cannot reasonably be completed with the safeguard in normal operation.
2. Identify the hazardous energy and exposure created by the override.
3. Prefer isolation/blocking/restraint where the task does not genuinely require energization.
4. If temporary energized testing/positioning is necessary, define the machine-specific alternate protective measures and who is allowed inside the affected boundary.
5. Define an expiry/return trigger before use begins: task completion, shift end, named time, configuration restore, guard reinstallation, or another objective event.
6. Record who can reset safety, who can rearm ordinary control, and who can authorize START. Do not collapse those authorities merely because one person holds a service key.
7. Mark the machine state so another person cannot mistake an intentionally degraded safeguard state for normal production readiness.

## Failure paths that must be reviewed

- lost or duplicated physical key;
- key intentionally left in a selector or bypass position;
- jumper/bypass plug left installed after service;
- password shared broadly or written on the machine;
- default/vendor service credential never changed where change is supported and appropriate;
- service laptop remains logged in with elevated privilege;
- temporary configuration survives reboot or power restoration;
- override survives shift change or contractor departure;
- one credential can both defeat a safeguard and issue/reset/rearm/start hazardous motion;
- override masks EDM, discrepancy, guard, protective-field, speed, position, or mode faults rather than creating a bounded service state;
- production pressure converts a temporary exception into the normal workflow;
- bypass makes the machine easier/faster to use than the protected production mode.

Repeated use of the same override is an engineering signal. Investigate guard access, visibility, material handling, setup workflow, diagnostics, service access, ergonomics, and nuisance-trip root cause rather than normalizing the bypass.

## Restoration gate

The override is not closed merely because the key was returned or the password session ended. Before return to service:

- remove temporary jumpers/tools and restore the documented hardware state;
- restore the validated safety configuration and verify applicable CRC/signature/configuration identity where available;
- inspect/reconcile guard, protective-device, wiring, connector, final-element and feedback state affected by the work;
- clear temporary ordinary-control forcing, HAL/PLC overrides, FPGA debug modes, retained commands and service parameters;
- perform the scoped functional revalidation required by the change-impact worksheet;
- prove safety reset does not itself create ordinary-control rearm or START;
- obtain an independent restoration witness when the override affected a personnel-safety function;
- update the validated baseline if the final installed state legitimately changed.

Any unresolved safety-critical difference is `UNKNOWN — NOT CLEARED` for exposed operation.

## Human-factors rule

The long-term fix should make correct safeguard use easier than defeat. If a guard must routinely be removed for lubrication, adjustment, chip clearing, loading, diagnostics, or normal setup, treat that inconvenience as a design/workflow defect to investigate. Access control may reduce casual misuse, but it does not repair a protection concept that predictably motivates bypassing.

## LinuxCNC / FPGA boundary

LinuxCNC, HAL, a normal PLC, FPGA registers, service GUIs, or watchdog state may log and diagnose an override, but they are not promoted to independent personnel-safety authority by this register. A software flag saying `guard_bypass_authorized=1` is not physical evidence that the resulting exposed machine state is safe.
