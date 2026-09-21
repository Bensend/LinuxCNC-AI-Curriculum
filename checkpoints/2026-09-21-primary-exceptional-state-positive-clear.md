# Primary checkpoint — exceptional commissioning-state positive clear

Date: 2026-09-21

## Reconciliation

Read current governance and the newest Lane-B checkpoint `d9b7fbbd`, which is working the ESPE post-maintenance physical-detection chain. This primary run stayed on the distinct temporary force/simulation/override persistence branch to avoid duplicating Lane B.

## Durable work

- `safety-course/SIEMENS_FORCE_PERSISTENCE_RESTART_AND_EXPLICIT_CLEARING_AUTHORITY_STUDY_2026-09-21.md`
- `safety-course/ROCKWELL_FORCE_STATUS_NONVOLATILE_RELOAD_AND_PRODUCTION_CLEARANCE_BOUNDARY_2026-09-21.md`
- `safety-course/25C0_EXCEPTIONAL_COMMISSIONING_STATE_POSITIVE_CLEAR_HANDOFF_EXERCISE_2026-09-21.md`

## New freezes

- **ENGINEERING TOOL CLOSED != FORCE REMOVED**
- **FORCES DISABLED != FORCE VALUES REMOVED**
- **POWER CYCLE != KNOWN PRODUCTION CONFIGURATION RESTORED**
- **PROJECT DOWNLOAD/RELOAD != FORCE DISPOSITION PROVED**
- **SAFETY LOCK/SIGNATURE VALID != ORDINARY I/O FORCE STATE CLEARED**
- **FORCE STATE CLEARED != FIELD I/O FUNCTION PHYSICALLY PROVED** when forcing could have masked a defect
- **PRODUCTION HANDOFF REQUIRES POSITIVE DISPOSITION OF EXCEPTIONAL COMMISSIONING STATE**

## Evidence discipline

Siemens force persistence after STEP 7 closure and CPU-resident force-job clearing are `DOC-CONFIRMED` for the cited platforms. Rockwell distinct installed/enabled force states and nonvolatile on-power-up project load are `DOC-CONFIRMED`. Cross-platform return-to-service rules are `INFERENCE`. Exact OpenPressBrake/LinuxCNC persistence semantics remain `UNKNOWN` until implementation-specific evidence exists.

Do not teach reboot as a universal force/simulation sanitization mechanism.

## Compute

No executable compute was justified. No GitHub-hosted runner was used.

## Precise next work

Primary: seek authoritative evidence for a machine/controller that exposes a machine-readable exceptional commissioning-state summary or production interlock spanning multiple mechanisms (forces, simulations, overrides/test modes), preferably with explicit clearing/acknowledgement and restart/handoff behavior. Avoid generic forcing tutorials. If this branch becomes source-limited, rotate to another open 25C0/25E0 safety-human-factors branch.

Lane B remains independently open on the ESPE chain: physical field challenge -> protective-device output -> safety logic -> actual final-element stop -> failed-test production lockout -> correction/retest -> reset/rearm -> fresh ordinary start.
