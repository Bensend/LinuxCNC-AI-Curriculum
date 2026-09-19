# Safety Configuration Signature, Change, and Revalidation Authority Study — 2026-09-19

## Why this independent Lane-B branch exists
The newest durable primary/Lane work is access-stop plus inside-area restart prevention. This study deliberately does not modify those modules or evidence artifacts. It addresses a different lifecycle hazard: whether a safety-controller program/configuration is still the validated configuration after an edit, download, restore, module replacement, or maintenance intervention.

## Architecture freeze

**PROJECT OPENS != CORRECT SAFETY PROJECT.**

**DOWNLOAD SUCCEEDED != VALIDATED SAFETY APPLICATION.**

**CONTROLLER RUNNING != SAFETY CONFIGURATION VERIFIED.**

**SAFETY SIGNATURE PRESENT != EVERY EXTERNAL DEVICE CONFIGURATION VERIFIED.**

**SIGNATURE MATCH != PHYSICAL SAFETY FUNCTION PROVED AFTER A RELEVANT CHANGE.**

**FAULT ACKNOWLEDGED != CHANGE VALIDATED != PRODUCTION AUTHORITY.**

A safety signature/checksum is an integrity/configuration witness. It is not a physical-hazard witness and does not replace functional validation.

## Source-confirmed implementation evidence

### Rockwell GuardLogix safety signatures
Rockwell's current GuardLogix 5580 safety documentation states that a safety signature verifies integrity of the safety application and covers the safety portion of the controller project, not the standard application. Safety-signature elements include the safety application, controller attributes, safety tags, tag mapping, safety task/programs/routines/AOIs, and safety-I/O device configuration. Modification of an associated element changes its signature and requires revalidation.

Rockwell also documents the download/restore boundary: application testing is required after download unless a safety signature exists; to verify the correct safety application was downloaded/restored, the safety signature must be manually checked against the original safety documentation. If a safety-locked controller does not match the project signature, it must be unlocked to download; that download deletes the signature and the application must be revalidated.

Safety-I/O configuration has its own signature. Rockwell states that unexpected safety-I/O signature change can prevent the safety connection and drive the module to its safe state. Importantly, Rockwell also states that a signature can only be considered verified/configuration locked after user testing.

Evidence classification: **SOURCE-CONFIRMED**.

Sources:
- https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-programming-considerations/safety-signature-elements.html
- https://www.rockwellautomation.com/en-no/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-applications/download-upload-a-safety-application-program.html
- https://www.rockwellautomation.com/en-be/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-i-o/safety-i-o-configuration-signature.html
- https://www.rockwellautomation.com/en-tr/docs/technical/i-o/current/5034-pointmax/_online/5034-um002-ditamap/pointmax-safety-applications/use-safety-controllers/configuration-signature-ownership.html

### SICK Flexi configuration verification
SICK Flexi documentation provides an independent implementation. After transfer, configuration data are read back from the safety controller and compared with project data; a matching report must be reviewed and confirmed before the configuration is considered verified. Current Flexi Compact documentation warns not to operate the safety controller as a protective device unless configuration is verified and says a safety-related parameter change resets status to `Not verified`.

SICK also makes a boundary explicit that is valuable for this curriculum: verification of the safety controller does not necessarily verify connected configurable devices; those devices must be verified separately where applicable.

Evidence classification: **SOURCE-CONFIRMED**.

Sources:
- https://www.sick.com/media/docs/0/20/120/online_help_software_flexi_soft_designer_en_im0040120.pdf
- https://www.sick.com/media/docs/9/79/279/operating_instructions_8026634_en_im0096279.pdf

## LinuxCNC/OpenPressBrake boundary
LinuxCNC, HAL, a normal FPGA, an HMI, or repository revision may record/display safety-controller version, checksum, signature, verification status, maintenance state, or a safety permissive. They must not become the sole authority that declares an independently safety-rated application validated.

A useful ordinary-control diagnostic interface keeps these propositions separate:
- expected safety project/version;
- safety application signature/checksum identity;
- safety configuration verified/not verified;
- safety-I/O/device configuration identity where exposed;
- safety connection health;
- safety fault/revalidation required;
- independent safety permission to ordinary control;
- ordinary START/JOG/CYCLE intent.

Repository commit identity is valuable provenance but is not itself proof that the physical controller contains the validated safety configuration.

## Change-impact / recommissioning rule
A configuration change should trigger an explicit impact analysis rather than either extreme of `retest nothing` or blindly assuming every historical test remains valid. Rockwell's element signatures are specifically useful for identifying what changed, but unchanged signatures do not establish that altered wiring, replaced field devices, mechanical changes, hydraulic service, or other physical work is safe.

Classification: the requirement to use actual manufacturer change/signature behavior is **SOURCE-CONFIRMED**; the curriculum's generalized impact-analysis workflow across vendor platforms is **INFERENCE** and must be adapted to the real safety system.

## Commissioning and adversarial validation worksheet
For a real implementation, challenge at least these cases where applicable:

1. Edit one safety-related parameter -> verify validated/signature state changes as documented and production authority is withheld until the required validation path is complete.
2. Download an unsigned/changed safety project -> verify a successful download is not treated as automatic production approval.
3. Restore from memory/media -> independently compare the loaded safety signature/checksum with the approved record.
4. Attempt download to a safety-locked controller with a mismatched signature -> record actual refusal/unlock/revalidation behavior.
5. Replace a safety-I/O module -> verify device identity/configuration ownership/signature and perform the required functional test; do not accept network reachability as proof.
6. Change only ordinary LinuxCNC/HMI logic -> verify this cannot forge `safety configuration verified` or bypass the independent safety evaluator.
7. Modify a connected configurable protective device while the safety-controller project remains unchanged -> verify the device's own verification path; controller signature alone is insufficient where the manufacturer separates these mechanisms.
8. Power-cycle after an unverified change -> verify restart does not silently transform `not verified` into production authority.
9. Retain START/JOG/CYCLE while safety validation/rearm is incomplete -> verify stale ordinary intent cannot become fresh motion when safety permission later returns.
10. After relevant safety software/configuration change, functionally challenge the affected protective device -> evaluator -> final element -> physical hazard response chain, not just the checksum.
11. After a change affecting stop-performance assumptions, perform the applicable physical stop-performance revalidation rather than inferring it from program identity.
12. Archive the approved signature/checksum/report with enough provenance to distinguish approved configuration from later edits.

## Evidence vocabulary
- GuardLogix signature scope/change behavior: **SOURCE-CONFIRMED**.
- GuardLogix download/restore signature comparison and revalidation behavior: **SOURCE-CONFIRMED**.
- GuardLogix safety-I/O configuration-signature connection behavior: **SOURCE-CONFIRMED**.
- SICK readback/report verification and `Not verified` after safety-related change: **SOURCE-CONFIRMED**.
- SICK connected-device verification can remain separate: **SOURCE-CONFIRMED**.
- Any claim that an OpenPressBrake safety controller will use GuardLogix/Flexi or these exact workflows: **UNKNOWN**.
- Exact OpenPressBrake safety program, signature/checksum, field-device set, test scope, PL/SIL/category/DC, stop time/distance, hydraulic truth table, pressure threshold, or validation interval: **UNKNOWN**.
- Generalizing these examples into a vendor-neutral change-impact workflow: **INFERENCE** until applied to a selected safety platform.
- No **DOC-CONFIRMED**, **TEST-CONFIRMED**, or **COMMUNITY-REPORTED** claim is added by this study.

## Minimum-operate consequence
If a safety-related configuration has changed and the manufacturer's required verification/validation state has not been restored, treat the affected safety function as not proven for personnel exposure. Do not use an HMI green state, ordinary controller readiness, network connectivity, or a successful download as a substitute.

## Next independent evidence target
Find one professional implementation exposing the joined lifecycle chain:

`approved safety configuration/signature -> intentional safety edit or device change -> signature/checksum/verified state changes -> production safety authority withheld -> change impact identified -> affected safety function functionally tested through final element and physical hazard -> new approved signature/checksum/report archived -> deliberate safety reset/rearm -> separate fresh ordinary START`

Prefer an example that includes a configurable scanner/drive/STO/safety-I/O device whose own configuration must also be verified, because that demonstrates why controller-project integrity and field-device configuration integrity are related but distinct propositions.

## Compute
No simulation, synthesis, benchmark, test-suite execution, or other executable verification was needed. No GitHub-hosted runner was used; no self-hosted compute was consumed.