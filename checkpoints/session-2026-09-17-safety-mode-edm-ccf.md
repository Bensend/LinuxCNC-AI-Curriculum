# Safety mode-selection / EDM common-cause session — 2026-09-17

- Session start UTC: `2026-09-17T03:39:00Z`
- Session end UTC: `2026-09-17T03:47:00Z`
- Actual elapsed: `8.0 min`
- Overlap status: `NO EVIDENCE OF OVERLAP` — prior durable checkpoint ended 2026-09-17T02:42:26Z.
- Compute: `NONE`; manufacturer documentation and engineering synthesis only. No GitHub-hosted Actions minutes consumed; self-hosted compute was not justified.
- Status: CHECKPOINTED — safety course remains active.

## Durable work completed

- Added `safety-course/MODE_SELECTION_EDM_COMMON_CAUSE_APPLICATION_2026-09-17.md`.
- Applied the common-cause method to safely evaluated operating-mode selection and downstream contactor EDM.
- Added explicit MODE INTEGRITY and FEEDBACK INTEGRITY gates for eventual compact commissioning card.
- Recorded that mode selection must not itself start motion, invalid selector combinations should fail safe where the architecture relies on safe mode evaluation, and ordinary LinuxCNC/HAL/FPGA must not be sole safety-mode authority.
- Recorded that EDM proves monitored final-element state relationships, not absence of all hazardous energy; physical energy tracing remains mandatory.
- Updated `PROGRESS.md`.

## Evidence gained

1. Pilz documents mutually exclusive operating-mode selection, separation of mode selection from machine start, and safe evaluation when modes alter safety functions.
2. Pilz PNOZ s30 documents a one-hot selector pattern in which shorts, cross-shorts, opens or drift producing invalid patterns cause an error and outputs OFF.
3. SICK UE440/UE470 and M4000 documentation traces EDM to downstream contactor feedback and restart prevention on failed contactor response.
4. Current SICK Flexi Soft documentation explicitly warns that misuse of EDM Error reset can cause undesired switch-on with a defective contactor, making reset-path validation part of the safety case.

## Exact next work

1. Find/apply the full package to a complete modern machine drawing set exposing safeguarding, safety logic, final elements and physical energy paths together.
2. After that second complete-machine application, compress the minimum-operate gate into a field commissioning card with MODE INTEGRITY and FEEDBACK INTEGRITY.
3. Preserve all machine-specific PL/SIL, stopping, pressure, timing and hydraulic truth-table values as UNKNOWN until established by the actual design/evidence.

## LESSON_LOG safe-append status

`LESSON_LOG.md` remains large and normal fetch is truncated. Required timing is preserved here rather than overwriting an incomplete fetch. Append this row only through a verified safe append path:

`| 2026-09-17 | Safety course — mode-selection + EDM common-cause application | 2026-09-17T03:39:00Z | 2026-09-17T03:47:00Z | 8.0 | MODE / FEEDBACK INTEGRITY GATES INTEGRATED | Complete modern-machine application, then commissioning card | No overlap; no compute. |`
