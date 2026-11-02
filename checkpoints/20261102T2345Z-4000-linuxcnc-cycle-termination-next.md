# 2026-11-02 ~23:45Z — CYCLE-174 next checkpoint

**Priority:** LinuxCNC implementation first; active 4000 NON-GRADUATED, 3100/3400 transfer. 1000/2000/F02/3000 remain GRADUATED/CLOSED. Preserve independent personnel-safety authority and OpenPressBrake G0/G1 HOLD. Recurring hourly curriculum stays enabled.

**Source result:** [CYCLE-174](../research/4400_LINUXCNC_CYCLE_TERM_174_G611_G81_G82_CANONICAL_MODE_RESTORE_ERROR_SOURCE_AUDIT_2026-11-02.md) finds stable v2.9.10 and pinned dev 67437d8 six-plane canned-cycle `CANON_EXACT_PATH` override. Successful G61.1/G64 cycles restore prior mode; G82 missing P and G83 missing Q can return from `CHKS/ERS` after override without restoration. If initial Z<R, a preliminary canonical R traverse is emitted even before missing-P validation. **Important limitation:** Task AUTO/MDI clears `interp_list` on interpreter error; neither a canonical traverse nor a changed canonical mode proves Task motion acceptance or post-abort persistence. Existing upstream g6164/G81 fixtures do not cover this combined branch.

**Executable priority:** MOTION-144 only after independent physically disconnected isolation of allowlisted `[self-hosted, openpressbrake]` runner; no GitHub-hosted fallback. Then [A–F CYCLE-174 fixtures](../examples/4000_cycle_term_174/README.md) against both pinned `rs274 -g` interpreters, capture output/error/exit, and *separately* Task error/queue/TP behavior if runner permits. Do not apply a speculative fix; compare validation-before-side-effects and cleanup guard across six planes.

**If runner remains unqualified:** rotate to a distinct, nonduplicative LinuxCNC core source question (prefer HAL realtime / real Mesa configs or interpreter Task consistency after checking prior research and historical lab ledger). Do not manufacture safety-course work or reopen graduated levels.

**Evidence:** SOURCE/DOC-CONFIRMED, standalone mode/velocity INFERENCE, TEST-CONFIRMED none; no LinuxCNC build, simulation, machine, evaluator or Actions. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged; hosted/self-hosted 0/0 min this session.
