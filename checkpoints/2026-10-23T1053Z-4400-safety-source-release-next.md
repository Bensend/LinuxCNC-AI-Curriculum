# 4400 safety curriculum checkpoint — 2026-10-23T10:53Z

**Active:** LinuxCNC/OpenPressBrake SAFETY COURSE, 4400 safety-design and independent physical-witness boundary. **Do not regress** to 3300. 1000/2000 graduated and closed; F02 graduated; completed 3000 evidence preserved. External 2520–25F0 competency evaluations remain OPEN; no blind bank accessed. Continue safety before routine controller-board work.

## This session's durable progress

- Session start UTC recorded before substantive work: 2026-10-23T10:39:52Z (automation invocation UTC). Final end/elapsed recorded separately in canonical `LESSON_LOG.md` immediately before exit.
- Published **13 exact original archive candidates** (all fetched and matched original Git blob): EUCHNER lock-substitution and manufacturer process-lock scope; OSHA lockable isolator exercise; AKAS overrun/workpiece sweep; cross-machine stale proof; LinuxCNC software E-stop three reset timelines; Pilz guard mounting/escape; Schmersal/SICK escape/rearm exercise; HAWE accumulator pressure-zone and monitored-valve coverage; guard access/escape temporal ordering; guard-chain qualification/change control; and series-contact fault-masking field card. See `research/4400_PUBLICATION_RELEASE_LEDGER_2026-10-23.md` for exact paths/blobs.
- Original 85-file consolidated archive **48 candidates still pending** after these 13 releases, based on the previous verified 61/85 state; this is an archive-relative release count, not a fresh exhaustive Git tree audit. Do not count already-published GuardLink architecture/replacement worksheets again.
- Created **five** original non-archive source investigations: OSHA maintenance test/position re-isolation state machine; Rockwell 432ES first-event/uncertain/historical diagnostics; upstream LinuxCNC v2.9.10 estop_latch first-scan/halcompile zero-initialization; Schmersal AZM300Z/B output semantics and Pilz cable routing; HAWE SAKB monitored five positions versus separate NSV; and a sixth original Pilz 1004710-EN-10 mounting FZh/escape-release source trace. Created one new non-archive 432ES technician exercise.
- Updated `PROGRESS.md`, `safety-course/SAFETY_COURSE_INDEX.md`, publication ledger and Safety Design Package §§11E/11F and 432ES supplement. No new physical test, simulation, blind score or verified lab runtime.

## Important new source-confirmed boundaries

1. EUCHNER CTP-I1 order 136595 is process-only locking without safe guard-lock monitoring; CTP-L1 order 123375 documents a different lock-monitoring allocation and connector family. Never treat `OL` diagnostic as equivalent.
2. Rockwell 432ES-UM001E `Ch0.Status` is a manufacturer-described SIL3/PLe channel bit in the 432ES architecture, but `DeviceTripAddress` is first-event, `Uncertain` questions data validity, and library fault rows 2–4 are historical. Distinguish this from **non-safety-rated** 440R-ENETR and from actual physical stopping/occupancy.
3. LinuxCNC v2.9.10 `estop_latch.comp` with `halcompile.g` zero-initialized private state can see a held-high first-scan reset as a software rising edge under permissive inputs. This ordinary software is not a safety reset authority.
4. Schmersal AZM300Z and B have different unlock/open safety-output semantics. Pilz 1004710-EN-10 lists mounting-dependent holding forces (parallel 7,500 N, side-on 5,000 N, bracket with handle 3,000 N) and accessory 80 N release force; none proves jammed-gate escape or selected machine safety.
5. HAWE D 6335 SAKB S lists five monitored manifold positions; separate NSV monitoring and actual load/pressure-zone restraint remain design-specific UNKNOWN. OSHA 1910.147 requires maintenance isolation and fresh verification after temporary energized positioning; an E-stop is not isolation.

## Precise next-work priority

1. **Publish reviewed backlog, avoid duplicates.** Check the publication ledger and `fetch_file` for exact destination before every write. Prioritize `research/4400_GUARDLINK_RESET_FAULT_RECOVERY_AND_SAFETY_AUTHORITY_2026-10-23.md` and `research/4400_HMI_GUARD_DIAGNOSTIC_EVENT_VS_SAFETY_STATE_CONTRACT_2026-10-23.md` if still absent, then remaining manufacturer-source documents and technician exercises. Do not re-publish already-present `4400_GUARDLINK_AUTHORITY_AND_RESET_ARCHITECTURE_CARD`, `4400_GUARDLINK_FAULT_RECOVERY_CHANGE_CONTROL_WORKSHEET`, or `4400_GUARDLINK_RESET_AND_REPLACEMENT_TECHNICIAN_CARD`; they were already in the earlier 61/85 release ledger.
2. **Resolve source/firmware unknowns:** selected 432ES vs 440R ENETR, exact GuardLink reset/diagnostic semantics, firmware-specific behavior, topology changes, physical causality and independent reset/restart authority. Preserve conflicting manual wording and tag uncertainty, never invent firmware behavior.
3. **Maintenance physical evidence:** selected hydraulic schematic, gauge taps and trapped volumes, accumulator isolation/reaccumulation, gravity load restraint, independent stop/hold and access/egress witness. Do not invent a hydraulic truth table, numerical PL/SIL or stop distance.
4. **Practical human factors:** accessible labeled test points, easy guard reinstallation, captive hardware, safe escape, reset location and anti-bypass incentives. Make correct safe procedure simpler than defeating safeguards.
5. External 2520–25F0 competency gates remain open and sealed. A field worksheet is NOT RUN, not an external score, not machine validation.

## Compute and session discipline

- **No GitHub-hosted compute.** Only consider bounded, question-driven workflows on `[self-hosted, openpressbrake]`; if unavailable, continue source/documentary work. The previously queued lesson-log run `39919548510` was rechecked and still QUEUED, with no authoritative runtime; leave `LAB_COMPUTE_LOG.md` unchanged.
- Use repository safe-append mechanism for `LESSON_LOG.md`; never overwrite a partial/truncated fetch. Record actual end UTC, elapsed minutes and overlap. Continue hourly automation unless owner stops or curriculum truly completes.
- All personnel-exposed hazardous operation remains **NOT AUTHORIZED** by documentary work. Isolated/remote experiments still require people outside danger zones and residual-risk controls.
