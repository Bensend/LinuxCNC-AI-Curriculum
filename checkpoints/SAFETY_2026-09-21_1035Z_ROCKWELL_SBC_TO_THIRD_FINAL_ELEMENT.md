# Safety curriculum checkpoint — 2026-09-21 10:35Z session

Active level: 4000 safety course / professional machine implementation.

Completed this session:
- Cross-vendor 25E0 trace of Rockwell GuardLogix Safe Brake Control.
- Confirmed explicit brake-feedback mismatch timer, fault behavior, correction-plus-reset requirement, Manual restart fresh Reset transition, and conservative cold-start behavior.
- Added adversarial exercise covering recovered feedback, stale ordinary enable demand, vertical/gravity load sequencing and physical witness limits.
- Updated PROGRESS.md.

Durable freezes added:
- BRAKE FEEDBACK RECOVERED != BRAKE SAFETY FUNCTION RESET.
- FAULT CAUSE CORRECTED != OUTPUTS AUTOMATICALLY RE-ENERGIZED (MANUAL RESTART).
- CONTROLLER RUNNING != BRAKE RELEASE AUTHORIZED.
- BRAKE FEEDBACK VALID != BRAKE TORQUE PROVED.
- SBC INTEGRITY TRUE != STOPPING PERFORMANCE VALIDATED.

Important comparison: Siemens 3SK1 and Rockwell SBC demonstrate materially different recovery/restart semantics. Do not universalize either implementation.

Exact next work:
1. Trace a third professional final-element family, preferably a safety hydraulic/pneumatic valve or valve terminal, alternatively drive STO/status monitoring, where feedback disagreement has explicit timeout/fault/reset semantics.
2. Determine whether mere signal recovery restores eligibility, whether fault state latches, and whether a genuinely new reset transition is required.
3. Trace what a held Reset/Start/Jog/Cycle demand does across the mismatch and recovery boundary when the vendor evidence exposes it.
4. Bound the feedback signal to the physical fact actually witnessed; do not promote valve/drive status to proof of pressure, motion, zero torque, stored energy, or stopping performance without evidence.
5. If authoritative public evidence for the third family is source-limited, record the information-gain stop and rotate to another open 25C0/25E0 safety branch rather than manufacturing generic guidance.

Compute: none justified. No GitHub-hosted runner used.