# Rockwell force-removal, safety-signature, and standard-control boundary study

Date: 2026-09-21

## Sources

Rockwell Automation current GuardLogix / Logix SIS safety documentation:

- Safety Applications: https://www.rockwellautomation.com/en-mde/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-applications.html
- Force Data: https://www.rockwellautomation.com/en-be/docs/technical/logix5000/_online/1756-rm015/logix-sis-safety-reference-manual-ditamap/safety-applications/force-data.html
- GuardLogix Safety Reference Manual publication 1756-RM012: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/1756-rm012_-en-p.pdf

Evidence label for manufacturer behavior below: **DOC-CONFIRMED/SOURCE-CONFIRMED**. OpenPressBrake transfer is **INFERENCE**.

## Findings

Rockwell makes a useful distinction between development state and validated/protected safety application state. An unlocked application without a safety signature is development-only and can have safety I/O forces. Safety I/O forces must be **removed, not merely disabled**, before the safety project can be locked or a safety signature generated. Once the safety application is signed/locked, safety forces are not permitted.

However, Rockwell separately states that forces can still be installed/removed on **standard tags** regardless of safety-lock state. Therefore a valid/protected safety application does not by itself prove that ordinary-control commissioning forces are absent.

Rockwell's digital safety-I/O manual also warns that forcing can cause unexpected machine motion and requires determining the effect of a force and keeping personnel away from the machine area before using it. It notes a subtle restoration hazard: removing forces can still leave forces globally enabled, so later installation of a new force can take effect immediately.

## Curriculum freezes

**SAFETY APPLICATION LOCKED/SIGNED != STANDARD-CONTROL FORCES ABSENT.**

**FORCE DISABLED != FORCE REMOVED.**

**FORCE REMOVED != GLOBAL FORCE FACILITY NECESSARILY DISABLED.**

**VALID SAFETY SIGNATURE != ORDINARY PRODUCTION CONFIGURATION RESTORED.**

**TEMPORARY FORCE REQUIRED FOR DEBUG != PERSONNEL EXPOSURE JUSTIFIED.**

These distinctions close a loophole in return-to-service reasoning: safety-application integrity and ordinary-control commissioning state are different evidence layers.

## Human-factors implication

A good production-release design should make exceptional standard-control state hard to overlook. Where the platform permits standard forces/simulations while the independent safety application remains valid, the HMI/release process should expose that fact and block ordinary production authority where practical until production-incompatible temporary state is cleared.

The FANUC study in this course provides one concrete implementation pattern: automatic production blocking while simulation remains active plus conspicuous indication. Rockwell provides a complementary architectural warning: a protected safety application does not automatically clear every standard-control force.

## LinuxCNC / FPGA transfer

LinuxCNC and an ordinary FPGA may provide commissioning overrides, simulated inputs, HAL substitutions, debug modes, or forced ordinary outputs. If such facilities are provided, they should be:

- explicit rather than hidden;
- enumerable where practical;
- conspicuous during use;
- scoped and access-controlled appropriately;
- designed so production-incompatible states inhibit ordinary production-cycle authority;
- positively cleared/restored before production handoff.

This ordinary-control mechanism is not a substitute for independent personnel-safety authority. The exact OpenPressBrake debug/override facilities remain **UNKNOWN** until defined.

## Compute

No executable compute is justified; this is manufacturer-source architecture evidence. No GitHub-hosted runner was used.
