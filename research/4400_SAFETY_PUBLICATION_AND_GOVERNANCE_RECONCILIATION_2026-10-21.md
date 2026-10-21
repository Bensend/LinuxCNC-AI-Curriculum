# 4400 safety publication and governance reconciliation — 2026-10-21

Session start: 2026-10-21T18:38:04Z UTC. Documentation-only audit. No machine test, simulation, GitHub Actions compute, or safety validation.

## Source-confirmed current state

At the session read, `PROGRESS.md` (blob `5c08859ec743cf16b586153cab201f3fa46cd721`) declares 1000/2000/3000 GRADUATED/CLOSED and 4000 safety implementation primary. The 2520–25F0 information-separated competency gates remain open; internally prepared lessons are **not** externally graduated. The canonical safety index (blob `8ebcf769875591bc2e058eaf18cf5181298b8ea3`) still calls 2550 active. This is stale learner navigation, not authority to regress. The latest main commit checked was `214ee77c1033423e12dde25c5fad56f882528ced`.

The existing `hardware/SO_FINAL_ELEMENT_IMPLEMENTATION_SPEC_TEMPLATE.md` (blob `4baa80486fa42667d5da7e97f9e754aef0ec1964`) already implements all eight final-element witness fields and a healthy-feedback/contradictory-physical-witness case. The old September 24 PROGRESS task to add them is satisfied; do not create a duplicate.

## Offline unpublished-package audit

Read three prior review ZIPs: the 2026-10-21 15:38 cumulative package (353 candidate research/safety-course/checkpoint Markdown paths), 16:40 delta (3), and 17:39 delta (5). All ZIP integrity checks passed. Their **361 unique candidate paths** comprise 119 research, 189 safety-course, 53 checkpoints, with zero duplicate normalized paths or conflicting same-path SHA-256. This is an archive inventory, **not** proof of 361 currently unpublished paths or correctness. The two previously published standalone October 21 safety notes are absent from the candidate set. Older bundled integration scripts can have lower frozen file counts than this cumulative set; running one script does not publish the whole backlog.

Six existing-file update baselines read: selected-block worksheet `855a94f6998bd21ef8a710a0d5c58b3664466021`, SO template `4baa80486fa42667d5da7e97f9e754aef0ec1964`, SC-CORE template `38f11250489ef1b63449c489945fcfa8411ecd26`, safety traceability template `69e53569e950b34dee9bb9ed3fa1bb4e5f7388d2`, PROGRESS `5c08859ec743cf16b586153cab201f3fa46cd721`, and safety index `8ebcf769875591bc2e058eaf18cf5181298b8ea3`. Re-read immediately before an authorized change; never overwrite on SHA drift or collision.

## Safe publication and log constraints

Use a clean authorized checkout, explicit path/hash manifest, collision checks, full diff review, and separate guarded updates. Do not circumvent any platform write rejection. Keep `LESSON_LOG.md`, `TIMING_APPEND_REQUEST.txt`, `LAB_COMPUTE_LOG.md`, and workflows outside bulk import.

`TIMING_APPEND_REQUEST.txt` (blob `f8656622948d121ef40eb61a47a13b95568d1b7e`) still holds the October 12 request. The existing `.github/workflows/append-lesson-log.yml` (blob `4291be271f9a3e37dc195a06d0f11d1be0e10733`) runs only on `[self-hosted, openpressbrake]`, appends the requested row on a request-file push, and **does not clear the request**. Never replace the occupied request or rewrite a large/truncated canonical log. No new authoritative lab runtime was found; no compute-ledger update is warranted.

## Safety and next checkpoint

Publication status, controller feedback, and physical safety evidence are different propositions. Valve-position feedback cannot prove ram standstill, residual-pressure absence, or maintenance isolation. Keep selected Pilz program identity, AKAS/pedal wiring, hydraulic stop/hold architecture, mechanical ram-support load path, PL/SIL, stopping distance, pressure and thresholds **UNKNOWN** pending exact installed evidence. All conceptual adversarial cases remain **NOT RUN**. No personnel-exposed hazardous operation is authorized.

Next: reconcile the backlog in an authorized checkout; correct stale safety index/PROGRESS without promoting external gates; recover the installed safety program and independent hydraulic/mechanical physical witness by non-modifying evidence collection; rotate to another open 4000 safety module when the selected-machine branch is evidence-blocked.
