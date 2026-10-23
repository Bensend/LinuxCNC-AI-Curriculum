# 4400 safety continuation checkpoint — 2026-10-23T19:36Z

**Authority:** This checkpoint supersedes `checkpoints/2026-10-23T1835Z-4400-stopped-motion-fresh-restart-next.md`. Active work is the 2500 safety course and 4000/4400 independent safety-boundary curriculum. 1000/2000/F02/3000 remain GRADUATED/CLOSED; no return to historical 3300 instructions. **Session start captured in UTC before substantive work: 2026-10-23T19:36:58Z**. End/elapsed/overlap must be appended to canonical LESSON_LOG immediately before session exit.

## New durable original artifacts

1. `research/4400_BRAKE_FAULT_TORQUE_RETENTION_AND_HYDRAULIC_LOAD_CONTROL_SCOPE_2026-10-23.md` — DOC-CONFIRMED manufacturer evidence: Rockwell GuardLogix v38 SBC dual brake outputs, negative vertical-load brake-first sequencing, TOR **retains previous state** on fault; in a specific pre-torque-off brake-feedback fault TOR remains unasserted so motion task may hold a gravity load. This does not guarantee continued torque under simultaneous drive/power failure. Siemens S120 12/2018 FW5.2 SBT intentionally applies test torque and reads encoder motion, and is explicitly unavailable for SINAMICS HLA. Parker HAS HY08-4005-M11 differentiates PO-check holding from controlled load lowering, warns of ratcheting and scopes recommendation to horizontal/non-overrunning HAS use. No universal product-transfer or PL/SIL claims.
2. `safety-course/4400_BRAKE_FAULT_GRAVITY_HOLD_AND_LOAD_LOWERING_TECHNICIAN_CARD_2026-10-23.md` — five open-book adversarial scenarios, including gravity brake feedback fault, press-brake hydraulic lowering, energized SBT, lathe STO/coasting and retained-start after maintenance. Not a sealed blind exam or physical proof.
3. `research/4400_PARKER_HAS_LOAD_HOLD_OVERRIDE_CODE_AND_MANIFOLD_ORIENTATION_2026-10-23.md` — exact Parker HAS manual pp. 35–37 documents **N/no-load-hold** circuit option supplied with **R-coded PO check manually overridden** for free bidirectional flow, optional tamper-resistant cover, and orientation A–D-dependent a/b port-to-push/pull mapping. A visible check-valve cartridge does not prove it is engaged; an assumed port label can invalidate energy-zone witness. Product-specific, not a generic press-brake truth table.
4. Cumulative `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` §§11AI–11AJ; `safety-course/SAFETY_COURSE_INDEX.md`, `PROGRESS.md`, and `research/4400_PUBLICATION_RELEASE_LEDGER_2026-10-23.md` updated. All three newly created files re-fetched from main and Git blob SHAs recorded by connector.

## Evidence boundaries and active gates

- **Historical 85-file archive:** 6 exact original source candidates remain pending; no original ZIP/manifest bytes recovered this session. These three newly authored files do NOT decrement historical backlog.
- **Selected machine:** IN-01..10 UNKNOWN; PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART UNKNOWN; VAL/PT NOT RUN; G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed operation authorized. Experimental physical operation, if ever justified, requires remote/isolation with approved exclusion and residual-risk assessment.
- **External:** 2520–25F0 information-separated/fresh evaluations OPEN. No learner inspection of hidden answers; FEEDBACK_SCORE_LOG unchanged.
- **Compute:** zero GitHub-hosted minutes, zero self-hosted lab minutes, zero simulation/bench/physical tests in this session. Existing self-hosted-only append workflow run 39919548510/job 120301190483 freshly checked QUEUED, no authoritative job runtime; LAB_COMPUTE_LOG unchanged.
- **Provenance:** DOC-CONFIRMED manufacturer docs, INFERENCE separated, selected physical facts UNKNOWN, no TEST-CONFIRMED.

## Precise next work

1. Briefly check current main and external gate without polling indefinitely. Recover exact historical ZIP only if bytes become available; compare original manifest/sha and Git blobs before calling any exact release.
2. Highest-value selected-machine intake: exact cylinder/brake/valve part and order code, override state, orientation and port-to-chamber map, gravity and pilot paths, independent final holding mechanism, brake feedback, drive power-loss behavior, guard release/inside escape, worker energy isolation and fresh rearm. Record actual IN-01..10 and independently qualified PHY witnesses. Do **not** invent numbers or run fault injection with people exposed.
3. If no machine intake exists, rotate to another unblocked 4400 source topic: manufacturer-documented brake feedback failure + independent secondary holding, or hydraulics pilot-loss/hose rupture/accumulator reaccumulation, with exact selected product/manual scope and a cross-machine press brake/lathe distinction. Avoid repeating these three papers.
4. Human factors: make guard/override recovery easy without bypass; mark bypass and return-to-service state physically, not only on HMI. Keep ordinary LinuxCNC/FPGA outside personnel-safety release authority.
5. No hosted compute. Local [self-hosted, openpressbrake] only if a specific unresolved question justifies a bounded test and runner access is confirmed; no fallback.

**Close:** Immediately before exit, append UTC end time, elapsed minutes and known-overlap status to LESSON_LOG using complete-file SHA-guarded update (or safe immutable append mechanism), verify commit, preserve recurring automation.

## Same-session follow-on after initial checkpoint

Manufacturer/official regulatory cross-check added to the first research document and technician card: Siemens S120 SBT intentionally energizes motor/brake with a defined selection/exit sequence; official OSHA 29 CFR 1910.147(f)(1) governs temporary test energization in covered maintenance circumstances. Cumulative design package §11AK and PROGRESS updated. This is a paper-only distinction between routine production testing and authorized maintenance reenergization, **not** an energized test authorization. No new compute or physical evidence. Preserve all next-work and historical archive gates above.
