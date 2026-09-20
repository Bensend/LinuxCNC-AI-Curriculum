# CIP Safety I/O Replacement — Identity, Ownership, Configuration and Functional Revalidation

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Why this branch

The primary safety lane is currently advancing integrated setup/service-mode enabling-device authority and physical held-jog behavior. This study intentionally uses a different evidence family and different files: replacement of networked safety I/O and the commissioning authority needed before return to service.

## Evidence provenance

### SOURCE-CONFIRMED / DOC-CONFIRMED — Rockwell GuardLogix / CIP Safety

Rockwell's current GuardLogix documentation states that replacing a safety I/O device requires the replacement device to be configured correctly **and its operation user-verified**. During replacement or functional testing, system safety must not rely on the affected device. The controller exposes two replacement policies: automatic configuration only under restricted safety-signature conditions, or always allowing automatic configuration when the application-specific safety strategy permits it.

Rockwell documents that a CIP Safety device identity/connection depends on more than ordinary Ethernet reachability. The replacement workflow can involve the Safety Network Number (SNN), node/IP address, electronic keying, configuration ownership and configuration signature. A safety-device configuration signature uniquely identifies configuration and is only considered verified after user testing.

For the case where a replacement device has a different SNN while a safety signature exists, Rockwell requires resetting ownership, setting the correct SNN, verifying the Network Status indication on the **correct physical device** before accepting the SNN write, and then following the prescribed functional test and authorization procedure.

Rockwell further warns that `Always Allow Automatic Configuration` is appropriate only when the routable safety system is not being relied on to maintain the claimed safety behavior during replacement/testing; otherwise the more restrictive replacement policy is required. This is an important maintenance-boundary lesson: convenience of automatic replacement is not itself evidence that the remaining machine safety architecture is valid during the work.

Sources:
- Rockwell Automation, GuardLogix 5580 / Compact GuardLogix 5380 Safety Reference Manual, Safety I/O Device Replacement.
- Rockwell Automation online documentation, Safety I/O Replacement Options and replacement scenarios.
- Rockwell Automation online documentation, Safety I/O Device Signature / Configuration Signature and Ownership.

### DOC-CONFIRMED — Siemens PROFIsafe independent corroboration

Siemens' 2025 guidance on software assignment of PROFIsafe addresses requires functional testing after F-address assignment and explicitly calls for test cases capable of discovering station mix-ups. Its multi-axis example says each axis should be moved and direction verified. This independently supports the principle that correct logical addressing is not sufficient: commissioning must prove that the intended physical function is actually connected to the intended safety identity.

Source: Siemens, `Assignment of PROFIsafe addresses via software`, Entry ID 109748466, V2.3, 04/2025.

## Durable architecture freezes

- **IP/NODE ADDRESS CORRECT != SAFETY DEVICE IDENTITY CORRECT.**
- **SAFETY DEVICE IDENTITY CORRECT != CONFIGURATION OWNERSHIP CORRECT.**
- **OWNERSHIP CORRECT != CONFIGURATION SIGNATURE VERIFIED.**
- **SAFETY CONNECTION ESTABLISHED != SAFETY FUNCTION FUNCTIONALLY REVALIDATED.**
- **REPLACEMENT DEVICE COMMUNICATING != PHYSICAL FIELD DEVICE / CHANNEL / FINAL ELEMENT MAPPING PROVED.**
- **AUTOMATIC CONFIGURATION SUCCEEDED != RETURN TO PRODUCTION AUTHORIZED.**
- **LINUXCNC/HAL SEES EXPECTED BITS != CIP/PROFIsafe SAFETY IDENTITY OR FUNCTIONAL VALIDATION PROVED.**

The safety controller/network owns the safety identity and validated configuration relationship. LinuxCNC or an OpenPressBrake FPGA may display diagnostics or consume ordinary status, but neither becomes personnel-safety authority merely because its observed bits match expected values.

## Replacement acceptance worksheet

For a future machine-specific implementation, require evidence for each applicable step rather than collapsing replacement into `device online`:

1. Put the affected safety function/machine in a condition where safety does not depend on the device being replaced.
2. Record the intended device, physical location, catalog/revision/keying requirements, safety network identity and configuration owner from controlled documentation.
3. Replace the device without assuming that matching IP/node address establishes safety identity.
4. Resolve/reset prior ownership only under the manufacturer's documented procedure.
5. Assign/verify the required safety network identity on the intended **physical** device.
6. Verify expected configuration/signature state and that the correct controller owns the safety configuration.
7. Re-establish the safety connection without treating connection state as acceptance.
8. Deliberately challenge every affected safety input/output/function needed by the machine validation plan. Verify the physical device/channel identity, not only a software bit.
9. For outputs/final elements, verify the actual downstream physical response and relevant feedback/witness path.
10. Challenge plausible mix-up cases: swapped identical modules, wrong node/IP, wrong SNN/F-address, wrong physical channel, wrong owner/configuration, stale configuration, and a device that communicates but is wired to the wrong machine function.
11. Verify reset/restart/rearm behavior and reject stale ordinary LinuxCNC START/CYCLE/JOG authority across the maintenance event.
12. Record functional-test evidence and explicit authorization before production return.

## Failure-path table

| Challenge | What a weak check might say | Required disposition |
|---|---|---|
| Correct IP, wrong safety identity | `ping/connection OK` | Not accepted; resolve safety identity |
| Correct safety identity, wrong owner/config | `device online` | Not accepted; verify ownership/configuration/signature |
| Correct network config, swapped physical station | `all nodes healthy` | Not accepted; physical function test must expose mapping error |
| Input changes in software but wrong field device actuated | `bit toggles` | Not accepted; prove intended physical channel/function |
| Safety output connection restored but final element does not respond | `safety network healthy` | Not accepted; physical final-element witness required |
| Automatic configuration succeeds | `replacement complete` | Not accepted until functional revalidation and authorization |
| LinuxCNC status looks normal | `machine ready` | Ordinary control status is not safety requalification |

## OpenPressBrake applicability

**INFERENCE:** if OpenPressBrake later uses networked safety I/O, a replacement workflow should preserve the same authority ladder: physical device identity -> safety-network identity -> ownership/configuration -> safety connection -> affected-function physical challenge -> final-element witness -> reset/rearm -> fresh ordinary start.

**UNKNOWN:** OpenPressBrake's eventual safety-network technology, device count, addresses, safety signatures, replacement policy, PL/SIL/category, exact proof-test scope and machine-specific acceptance thresholds. Do not invent them.

## Compute disposition

No simulation, synthesis, benchmark or executable verification is justified for this documentation/architecture question. No GitHub-hosted runner was used. A future executable lab is justified only if it answers a concrete implementation question that documents cannot resolve; it must then use `[self-hosted, openpressbrake]`.

## Precise next-work checkpoint

Seek an authoritative OEM/manufacturer replacement acceptance example that goes beyond `functionally test per company procedure` and explicitly demonstrates **replacement identity/configuration -> deliberate physical input/output challenge -> wrong-station or wrong-channel detection -> actual final-element response -> reset/rearm -> fresh production start**. Prefer a complete machine or cell commissioning checklist. If that evidence is unavailable after a bounded search, mark this branch source-limited and rotate rather than repeating generic CIP Safety/PROFIsafe catalog research.
