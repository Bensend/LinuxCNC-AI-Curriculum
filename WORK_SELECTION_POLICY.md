# Curriculum Work-Selection Policy

This file is authoritative for choosing the next autonomous curriculum task when multiple course branches, evaluations, or specialization tracks are open.

## Core rule

A block, external dependency, source-availability limit, or information-gain stop in one module or specialization is **branch-local**. It must not stop the overall curriculum while useful work remains elsewhere.

The recurring curriculum automation is the heartbeat. Do not disable it merely because the currently active branch is blocked, awaiting an independent evaluator, waiting for public source, or has reached an information-gain stop. Disable it only if the owner explicitly requests a pause/stop or the active curriculum has genuinely completed with no justified next work.

## Session work selection

At the start of every session:

1. Re-check any critical external graduation gate briefly and preserve a new result if one exists. Do not spend the whole lesson repeatedly polling an unchanged external gate.
2. Resume an unfinished task when it still has a concrete evidence-gain path.
3. If that branch is blocked or at an information-gain stop, immediately select another useful unblocked branch rather than ending the session.
4. Prefer work that advances the active course level, closes a real evidence gap, or creates reusable cross-machine understanding.
5. When the 2000 series is technically complete but formal closure is waiting only on an information-separated external evaluation, dependency-safe 3000-series research/source/playbook preparation may continue. Do not claim formal graduation of a downstream module if an actually required prerequisite is unresolved.
6. Within the 3000 series, treat tracks 3100 through 3900 as parallel specialization branches. A stop in 3600 Press Brakes does not block 3100 Mills/VMCs, 3200 Lathes/Turning Centers, 3300 Plasma/Laser/Waterjet, 3400 Routers/Woodworking, 3500 Robots/Custom Kinematics, 3700 Grinding/EDM, 3800 Saws/Feeders/Automation Cells, or 3900 Emerging/Unusual Machines.
7. Choose among open 3000 tracks by expected information gain, breadth of LinuxCNC community use, prerequisite value for other tracks, current coverage gap, availability of inspectable configs/source/build diaries, and transfer value to OpenPressBrake or future controller work. Prefer an underdeveloped track over repeatedly searching a source-exhausted branch.
8. When a track reaches a genuine source-availability or information-gain stop, record exactly what evidence would reopen it, checkpoint it, and rotate to another track.
9. Do not manufacture synthetic experiments, redundant searches, or documentation solely to keep a session busy. Switching branches is preferred to low-value repetition.
10. Continue the normal 15–20 minute useful-work pacing when coherent work exists, while respecting the laboratory compute budget and avoiding duplicate labs.

## 3000-series breadth objective

The 3000 series is intended to develop broad machine-class competence, not to finish one specialization before looking at another. Over time, every justified track should receive real source/community/config research, an architecture/playbook foundation, important failure/recovery knowledge, and evidence appropriate to its maturity.

Early passes may proceed in parallel and need not be equally deep. Press Brakes may remain a priority specialization, but they are not allowed to monopolize all 3000-series study when another track has higher available information gain.

## External-gate handling

An information-separated handoff, delayed retention check, sealed benchmark, owner action, physical measurement, or unavailable third-party source may block a specific graduation or experiment. Such a gate does not justify idling the curriculum if independent work exists elsewhere.

Check external gates at sensible session boundaries, then work another branch. Never self-score or contaminate a blind/fresh-AI evaluation merely to unblock the dependency graph.

## Completion / stopping condition

The autonomous curriculum may stop only when one of these is true:

- the owner explicitly pauses or stops it;
- human/safety/account intervention is required and no other useful unblocked curriculum work exists; or
- all justified active levels and tracks have genuinely graduated or reached documented terminal states with no justified next level or branch.

A single module stop, a single specialization stop, or a waiting evaluator is not a curriculum completion condition.

## Canonical-index novelty check (2026-10-26 study-method correction)
Before calling a proposed safety module or 4000 branch **unworked**, inspect the current canonical learner index and relevant `PROGRESS.md` section **directly**, not only GitHub code-search results. Search within fetched index text for synonymous mechanisms, hazard propositions, source manufacturers and prior module IDs; compare the candidate to existing source audits and exercises. Classify proposed work as **new causal mechanism**, **new exact manufacturer/edition evidence**, **transfer/integration**, or **duplicate/no information gain**. A code-search zero result is not evidence of novelty: [2026-10-26 safety overlap audit](research/4400_SAFETY_SOURCE_OVERLAP_RECONCILIATION_AND_NOVELTY_CHECK_METHOD_2026-10-26.md) found existing suppressor, leakage and pneumatic exhaust modules that keyword code search missed. Preserve valuable exact-OEM additions and unscored transfer practice, but do not claim new competencies or re-teach the same mechanism as a first discovery. When no meaningful new evidence remains, rotate to another genuinely distinct safety branch or qualified external evidence gate. This check improves selection quality; it does not reopen graduated levels or relax any physical/evaluator HOLD.


### 2026-10-27 refinement — exact-keyword false negative (DUST-05)
A direct full-index **literal phrase scan** is also insufficient if existing headings use different words. In this session, searching `dust explosion`/`dust collector` missed 2026-10-25 `4400-DUST-01..04` modules titled *wood-router LEV*, *collector fire/deflagration* and *filter Delta-P*. The error was caught by checking the **complete** `SAFETY_COURSE_RESEARCH.md` plan and following the earlier linked modules/14-gate review. Before asserting a new safety mechanism: (1) inspect both the canonical index **and** `SAFETY_COURSE_RESEARCH.md`; (2) search mechanism synonyms, adjacent equipment, and **existing module IDs**, not only literal candidate title; (3) follow relevant links and compare **hazard, physical final element, control authority and required witness**; (4) record exact incremental OEM/incident evidence separately from new causal mechanisms; (5) correct and rename any duplicate identifier before final checkpoint. [Concrete reconciliation](research/4400_DUST_05_PREDECESSOR_OVERLAP_RECONCILIATION_AND_SOURCE_DELTA_2026-10-27.md). This extends, rather than replaces, the 2026-10-26 rule. Do not erase valid predecessor evidence or claim unscored transfer exercises are a new competence.


## 2026-10-27 validation-debt and information-gain refinement (4400 safety)
[Evidence-debt/selection audit](research/4400_SAFETY_EVIDENCE_DEBT_AND_INFORMATION_GAIN_TRIAGE_AUDIT_2026-10-27.md) found that new public safety paper scenarios and desk gates can accumulate while all remain **UNSCORED/NOT RUN**, independent 2520–25F0 evaluation remains OPEN, and selected OpenPressBrake G0/G1 remains HOLD. At each 4400 session boundary, **first check for genuinely new qualified selected-machine evidence or information-separated evaluator results**; process those before adding another documentary module. If absent, choose source/documentary work only when it changes a concrete safety architecture, physical witness, diagnostic discriminator, high-consequence uncertainty or novel transfer capability, with direct canonical-index/research-plan predecessor comparison. State the incremental physical witness and why predecessors do not already teach it. Prefer source-depth and failure-path reconciliation over multiplying unscored case banks. A physical/evaluator block remains branch-local: continue other useful safety work and keep the recurring curriculum enabled. Do not treat artifact count as validation, self-score public scenarios or invent physical proof.


## 2026-10-27 — source-path predecessor check after FEED-JOG overlap correction

The [FEED-JOG-01 reconciliation](research/4400_FEED_JOG_01_PREDECESSOR_AND_WHEEL_JOG_SOURCE_CORRECTION_2026-10-27.md) found a false novelty claim even after reading the **full** canonical learner index and research plan: a 2026-10-24 SET-01 source-depth addendum in historical `PROGRESS.md`, cumulative design §11CC and `research/4400_LINUXCNC_FEED_INHIBIT_JOG_DOCUMENTATION_VERSION_DRIFT_2026-10-24.md` already established the keyboard-versus-wheel-jog path divergence. The candidate index heading did not use the proposed exact title. **Before asserting an unworked source mechanism**, additionally (1) inspect research filenames for synonymous symbols and mechanism names, (2) search full historical PROGRESS and cumulative design package for source symbols and relevant revisions, (3) read the closest predecessor's *addenda*, not just its title, and (4) classify the result as new mechanism / exact version delta / source reinspection / integration / duplicate. If a predecessor is discovered after publication, correct the claim in place, link and preserve the prior evidence, and update every canonical summary. Do not multiply public unscored exercises to disguise overlap. This does not weaken the independent safety or physical release gates.


## 2026-10-27 — cross-repository source-freshness trap (OPB-INTERFACE-04)

When a source audit consults another repository, **“latest in the returned commit list” does not mean “published today.”** Before describing a contract, file or architecture as *newly published* or a current design change, retrieve the actual source commit metadata (`created_at`/commit timestamp), record the immutable commit and blob, and distinguish **source publication date** from **date first audited by this curriculum**. Compare against relevant predecessor sources and current branch state. This session initially described OpenPressBrake `relay_contactor_driver/REV1_RESOURCE_CONTRACT.yaml` as newly published on 2026-10-27 because it was the newest returned commit; direct commit inspection established publication **2026-09-24T13:23:20Z**. The error was corrected across the original audit, field card and canonical integrations before checkpoint. [Exact correction and source context](research/4400_OPB_RELAY_COIL_VS_DRY_CONTACT_VS_PILZ_FINAL_ELEMENT_CROSS_REPO_AUTHORITY_AUDIT_2026-10-27.md). A current **audit** can still have new information gain from an older, previously unstudied source, but must not invent a recent hardware revision or physical machine change. This extends the source-path novelty rule without reopening graduated levels or relaxing G0/G1/evaluator holds.


## 2026-10-28 — first-contact evidence packet anti-creep safeguard (G0-HF-02)
The [G0 Stage A appendix-creep audit](research/4400_G0_STAGE_A_FIRST_CONTACT_APPENDIX_CREEP_AND_PROVENANCE_REFACTOR_AUDIT_2026-10-28.md) found that a nominal one-page A–G owner request had grown to 14,994 characters after dated source findings were appended. It has been restored to 5,306 characters with all seven A–G packets retained; the nine moved conditional headings remain in a dated reviewer archive. **Future 4400 safety sessions must not append extended OEM/standards research to the owner-facing first-contact packet.** Preserve source-depth in linked reviewer/research files, use Stage B only for qualified installed-component matches, and keep the redacted one-screen board as the owner/status surface. This is a measured repository information-architecture correction, **not** measured operator adoption or physical safety validation. Essential G0/G1 and independent evaluator holds remain unchanged.



## 2026-10-28 — legacy hosted-workflow trigger guard (local-compute rule)
[Direct workflow inventory and trigger audit](research/4400_LOCAL_COMPUTE_RUNNER_TRIGGER_GUARD_AUDIT_2026-10-28.md) confirms that the historical `.github/workflows/lab-runner.yml` still has `runs-on: ubuntu-latest` and can run on manual dispatch **or push to `lab-jobs/**` / its own YAML**; `append-lab-compute.yml` still has `runs-on: ubuntu-latest` and triggers on `LAB_COMPUTE_APPEND_REQUEST.md`. **Do not dispatch or touch those trigger paths for compute/append under the current local-compute rule.** The existing `append-lesson-log.yml` and `pb-dxf-001.yml` target `[self-hosted, openpressbrake]`; self-hosted dispatch availability is not proven merely by YAML. Only after a frozen, justified question, use/convert a bounded manual workflow to the local runner and verify access; otherwise continue source work and record the blocker. No hosted fallback, speculative runtime or routine test. This is a source-confirmed repository workflow trap, not a machine-safety test.


## 2026-10-28 — local runner isolation is a separate safety boundary (RUNNER-BOUNDARY-01)
The earlier [legacy hosted-workflow trigger inventory](research/4400_LOCAL_COMPUTE_RUNNER_TRIGGER_GUARD_AUDIT_2026-10-28.md) is **historical as of 19:32Z**: [new source audit](research/4400_RUNNER_BOUNDARY_01_LOCAL_PANEL_PC_WORKFLOW_ISOLATION_AND_HOSTED_COMPUTE_ELIMINATION_AUDIT_2026-10-28.md) records that `lab-runner.yml` was changed to **manual-only** `[self-hosted, openpressbrake]` with explicit reviewed script SHA-256 and disconnected-simulation attestation, and `append-lab-compute.yml` was changed to the same local runner. **No workflows were dispatched or tested.** An attestation, SHA, label or job exit code is **not proof** that a physical panel PC cannot reach HAL/FPGA/hydraulic outputs. Before any future justified local lab, require independently established physical isolation from machine actuation and a frozen question; if isolation/runner access is unknown, **do not dispatch** and continue documentary/source work. Do not add hosted fallback or automatic lab push triggers. Existing G0/G1 physical and independent evaluator holds are unchanged.

**Same-session follow-through:** the manual lab workflow additionally uses `contents: read`, removes its automatic results-to-main push, and serializes its own jobs; accepted raw artifacts must be reviewed and committed separately before retention expiry. This reduces write-token exposure but does **not** isolate a panel PC from machine I/O or serialize other workflows. Do not dispatch until qualified isolation and runner access are established.

**Fail-closed job selection:** source review found historical 056/079 jobs with `sudo` and LinuxCNC build/control paths. The local lab is now allowlisted to exact pure-software fixtures 086–089; other jobs, including the pending G43.2 simulator, require a separately reviewed workflow change and qualified machine-isolation evidence. GitHub code-search negatives did not detect some directly inspected script commands; use direct file inspection before making isolation claims. No lab was run.

**Reviewed-content guard:** the four local job allowlist entries are now pinned to their inspected Git blob SHAs, in addition to operator-supplied SHA-256; changing an allowed script requires a reviewed workflow revision. A source hash cannot prove a physical machine is isolated.

**Action supply-chain follow-through:** all four curriculum workflows now pin original GitHub `actions/checkout` v4 and `actions/upload-artifact` v4 to exact reviewed upstream commits (2026-10-28 ref inspection). This removes floating tag drift but does not make a public-repo self-hosted runner physically isolated or safe for arbitrary code. No workflow executed.

**All-branch hosted-minute trap closure (2026-10-28):** direct branch inventory found four historical A01 refs still carrying `ubuntu-latest` lab-runner workflows. All four were replaced by inert manual-only `if: false` self-hosted stubs; original workflow blobs remain in Git history. Current main bounded local lab remains manual-only. Post-write direct reads verified no hosted lab runner or push trigger on any of the five enumerated branches. This is not a guarantee about future branches or other repositories, nor physical runner isolation. No workflow executed.
