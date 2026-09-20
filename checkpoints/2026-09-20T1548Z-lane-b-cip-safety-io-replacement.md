# Checkpoint — Lane B CIP Safety I/O replacement revalidation

Date: 2026-09-20

## Durable work

- `safety-course/CIP_SAFETY_IO_REPLACEMENT_IDENTITY_OWNERSHIP_AND_FUNCTIONAL_REVALIDATION_STUDY_2026-09-20.md`
- Primary lane was re-read before selection and again before checkpointing. It is advancing integrated setup/enabling-device authority; this Lane-B work uses a separate networked-safety-I/O replacement evidence family and separate files.

## Result

Rockwell GuardLogix evidence establishes that a replacement safety I/O device is not accepted merely because ordinary network addressing or the safety connection works. Replacement can require correct SNN, electronic keying, node/IP, configuration ownership and configuration signature, followed by user functional verification. Rockwell explicitly requires functional testing/authorization after replacement and warns that system safety must not rely on the affected device during replacement/testing.

Siemens PROFIsafe guidance independently strengthens the physical mapping boundary: after F-address assignment, commissioning function tests must be capable of discovering station mix-ups; its multi-axis example calls for moving each axis and verifying direction.

Freeze: **IP/NODE ADDRESS CORRECT != SAFETY DEVICE IDENTITY CORRECT != CONFIGURATION OWNERSHIP CORRECT != CONFIGURATION/SIGNATURE VERIFIED != SAFETY CONNECTION RESTORED != PHYSICAL FUNCTION MAPPING PROVED != FUNCTIONAL SAFETY REVALIDATED != PRODUCTION AUTHORITY**.

LinuxCNC/HAL/FPGA may expose status, but expected bits do not prove safety-network identity, ownership, configuration or physical functional revalidation.

## Precise next work

Seek an authoritative OEM/manufacturer replacement acceptance example that explicitly demonstrates **replacement identity/configuration -> deliberate physical input/output challenge -> wrong-station or wrong-channel detection -> actual final-element response -> reset/rearm -> fresh production start**. Prefer a complete machine/cell commissioning checklist. If a bounded search finds only generic `functionally test per company procedure` language, mark this branch source-limited and rotate to another independent safety branch.

## Compute

No simulation/build/test compute was justified. No GitHub-hosted runner was used.
