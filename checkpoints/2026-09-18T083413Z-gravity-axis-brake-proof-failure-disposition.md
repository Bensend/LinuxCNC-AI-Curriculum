# Safety-course checkpoint — gravity-axis brake-proof failure disposition

Session start UTC: 2026-09-18T08:34:13Z
Session end UTC: 2026-09-18T08:39:00Z
Elapsed: 4.8 min
Overlap status: no overlap known from this invocation; LESSON_LOG full tail was not safely available through the connector, so exact previous-session end comparison remains UNKNOWN.

## Durable work

- Added `safety-course/GRAVITY_AXIS_BRAKE_PROOF_FAILURE_DISPOSITION_TRACE_2026-09-18.md`.
- Updated `PROGRESS.md` with gravity-axis proof/recovery freeze and exact next work.
- Source evidence: SEW-EURODRIVE SBT failure places inverter in STO and requires SBT control deactivation before safety-option acknowledgement; SEW explicitly warns STO alone can allow a gravity-loaded axis to fall; Pilz SBT failure prevents further operation; SEW diagnostic-chain and load-torque constraints bound what SBT PASS actually proves.
- No lab, simulation, build, synthesis, benchmark, test-suite or GitHub-hosted Actions compute used.

## Frozen lesson

`SBT FAIL -> SAFETY FAULT/INHIBIT -> PHYSICAL LOAD-SAFE DISPOSITION REQUIRED -> FAULT CAUSE CORRECTED -> ACKNOWLEDGEMENT -> REQUIRED RE-PROOF -> SAFETY AUTHORITY -> FRESH ORDINARY START.`

STO is not gravity-load retention. Acknowledgement is not repair. One passing retaining element does not automatically license degraded production when another required retaining element fails/has unknown proof.

## Next work

Find a same-machine professional implementation exposing failed mechanical/hydraulic retaining proof through safety latch/inhibit, physical load-safe disposition, repair/reset prerequisites, required re-proof, final-element re-enable and separate ordinary START. Prefer a dual-retaining-element system with documented disagreement/common-cause behavior. Preserve OpenPressBrake-specific topology/performance as UNKNOWN.

## LESSON_LOG safe-append payload

The connector returned only a truncated prefix of the large shared `LESSON_LOG.md`; replacing it would risk destroying unseen rows. Append this row using the repository's safe append mechanism when available:

`| 2026-09-18 | 4000 safety — gravity-axis brake-proof failure disposition | 2026-09-18T08:34:13Z | 2026-09-18T08:39:00Z | 4.8 | PROFESSIONAL SBT FAILURE/RECOVERY TRACE INTEGRATED | Find same-machine failed retaining proof -> physical load-safe disposition -> repair/re-proof -> final-element re-enable -> separate ordinary START, preferably dual-retaining. | Overlap UNKNOWN because safe tail read/append was unavailable. SEW/Pilz evidence integrated; STO explicitly not gravity-load retention; no lab/Actions compute consumed. |`
