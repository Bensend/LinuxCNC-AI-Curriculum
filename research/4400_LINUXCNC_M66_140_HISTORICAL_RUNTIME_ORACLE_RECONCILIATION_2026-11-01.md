# 4000-LC-M66-140 — Recovering an existing executable oracle for the M66 → G4 stale-wait defect

**2026-11-01 evidence correction.** Scope: LinuxCNC Task/interpreter timing, 3300 plasma integration and 4000 verification practice. **TEST-CONFIRMED on historical LinuxCNC commit `8bf4605ae81042248add031e94c77300406e0413`**, not on stable v2.9.10 or inspected development `06864e23559e70463fc7112d5ce77138bcbc288c`. This is a **read-only audit of a September 11, 2026 execution**, not a new test or an authorization to use hosted runners.

## Why this correction matters

The November 1 [M66-138 audit](4400_LINUXCNC_M66_138_TIMEOUT_STALE_WAIT_TRUNCATES_G4_DWELL_SOURCE_AUDIT_2026-11-01.md) described the stale input index as a new source-only finding and said `TEST-CONFIRMED none`. That was **wrong for the mechanism across the repository**. The historical [laboratory ledger](../LAB_COMPUTE_LOG.md) already records `M66-TIMEOUT-001` / lab 079 as a successful **stale-wait interaction reproduction**. The newer A–E matrix itself is still **NOT RUN**, but an earlier, closely matched L1 case *was* run. The 2026-10-27 M66-01 audit covered timeout semantics, not this test; checking only PROGRESS/LESSON_LOG and M66-01 missed the older lab. Do not erase the November 1 source-version trace; reclassify its novelty as **cross-version source corroboration + plasma transfer + extended controls**, not first discovery.

## Immutable execution and provenance witnesses

| Witness | Exact value / location | Classification |
|---|---|---|
| Source experiment | [`lab-jobs/079-pb-m66-timeout-stale-dwell.sh`](../lab-jobs/079-pb-m66-timeout-stale-dwell.sh), current Git blob `867535d86c647dd6bd1c467d7041e4dd0b858771` | SOURCE-CONFIRMED harness |
| LinuxCNC checkout | `8bf4605ae81042248add031e94c77300406e0413`, detached checkout in the script; `HEAD is now at 8bf4605ae` in retained stderr | Execution provenance |
| Curriculum checkout | `cd46cacf7696a714472fa72a1549e6e577365df1` in [metadata](../lab-results/run-34593401753-1/metadata.txt) | Execution provenance |
| Job / run | [GitHub Actions run 34593401753](https://github.com/Bensend/LinuxCNC-AI-Curriculum/actions/runs/34593401753), job `103243588697`, **2026-09-11 11:18:50–11:21:57 UTC** | Historical authoritative job timing |
| Program outputs | [stdout](../lab-results/run-34593401753-1/stdout.log), [stderr](../lab-results/run-34593401753-1/stderr.log), [exit code](../lab-results/run-34593401753-1/exit_code.txt) = `0` | TEST-CONFIRMED for that run |
| Fixture digests from stdout | control SHA-256 `84009e4f2c637370aef9457ea1fd09fbc1dafda593d57fc99e7b96148981e777`; experiment `ab6047e8fb842868a971be70eec6218834c13e6bb110fdff05d5992b5be6d4e6` | Reproduction identifiers |
| Runner | Workflow log identifies **GitHub-hosted Ubuntu 24.04** (historical, 2026-09-11) | **Forbidden for any new compute under current owner policy** |

The retained workflow log independently confirms job success, the frozen oracle printed before execution, a completed program and publication to the repository. The script builds LinuxCNC in a userspace loopback configuration and runs `tests/linuxcncrsh/linuxcncrsh-test.ini`; it controls `motion.digital-in-00` using `halcmd setp` and reads the pin back. No physical Mesa, torch, ram or spindle was exercised. **No new compute was dispatched in this reconciliation.**

## Frozen inputs and observed result

The script freezes its prediction and threshold *before* executing:

- Control: `G21 G90; G4 P0.50; M2`, input LOW. Measured AUTO_RUN-to-DONE = **0.505165 s**.
- Experiment: `G21 G90; M66 P0 L1 Q0.20; O100 if [#5399 NE -1] (abort,...) O100 endif; G4 P0.50; M2`. Input initially LOW; `halcmd` sets it HIGH at **0.301064 s** after AUTO_RUN. Measured AUTO_RUN-to-DONE = **0.311439 s**.
- Experimental minus control = **−0.193726 s**, passing the frozen `<= -0.10 s` discriminator. Stdout says `VERDICT=STALE-WAIT INTERACTION CONFIRMED` and all A–E harness gates PASS. Here “A–E” are the **historical script's gates**, *not* the November 1 five-scenario matrix.
- The program's `#5399 NE -1` abort guard did not fire; completion is consistent with **M66 timeout yielding −1**. The harness did not print the numeric parameter directly.
- The entire experimental program finished in **0.311439 s**, which is less than the programmed **0.50 s G4 alone**. Therefore the full G4 dwell was not honored in that execution. The exact start/end of G4 was **not instrumented separately**, so do not report a precise 0.11 s measured dwell.
- The experiment's input transition is timed relative to AUTO_RUN, not a separately timestamped Task command transition; the underlying causal explanation is independently supported by the Task static-index source trace, but exact polling latency and whether any individual Task pass caused the completion are **not directly recorded**.

**Conclusion:** This is stronger than merely SOURCE-CONFIRMED: the specified stale-wait → early-program-completion behavior was **TEST-CONFIRMED in a stock, disconnected LinuxCNC userspace execution on 2026-09-11**. It does **not** establish a physical plasma event, a v2.9.10 or `06864e` runtime result, a Task-state timestamp, or cross-program abort persistence.

## Version and fixture differences that still matter

The historical reproduction uses **M66 L1 RISE, Q0.20 and G4 P0.50**; November 1 [A–E fixture](../guides/3300-4000-linuxcnc-m66-timeout-g4-pierce-dwell-preflight-2026-11-01.md) uses **M66 L3 HIGH, Q0.5 and G4 P4**, plus explicit success, no-edge, L0-disarm and no-prior-M66 controls. They test the same Task state ownership but are not interchangeable records. The source audit covers stable v2.9.10 and `06864e`; historical execution is on `8bf4605`. **Neither of the newer versions has been executed in this record.**

The earlier runner was hosted, as its logs attest. Historical evidence remains valid as evidence of what ran; **the current compute restriction is prospective and absolute**: any new executable work must use a positively isolated `[self-hosted, openpressbrake]` runner. A label by itself does not prove physical disconnection.

## Practical implementation and corrective review

For LinuxCNC source review, the key invariant is: **the completion of an M66 wait (success, timeout, abort) must relinquish its Task input-watcher ownership before a later unrelated G4 or wait command starts, while preserving `input_timeout=1` long enough for the interpreter to read `#5399=-1`.** The existing Task source shows a file-static `emcAuxInputWaitIndex`, timeout branch that leaves it armed, and G4 issue path that replaces only the deadline; see [M66-138](4400_LINUXCNC_M66_138_TIMEOUT_STALE_WAIT_TRUNCATES_G4_DWELL_SOURCE_AUDIT_2026-11-01.md). An unconditional clear of `input_timeout` at timeout is **not** a valid fix.

A useful minimal upstream regression would assert *separate G4 issue/completion timestamps* and a saved `#5399=-1` in the same Task process. Use the existing lab 079 harness as the executable starting point; add a post-timeout LOW→HIGH input change, a no-transition control, an L0-disarm control, a success control, and a G4-only control. Record per-command Task state and make the oracle robust to AUTO_RUN overhead. A subsequent abort/reopen test is distinct and remains unverified. Avoid repeating the already-confirmed historical L1 result as if it were a first experiment.

## Study-method correction

A source-only novelty check that searches only `PROGRESS.md`, `LESSON_LOG.md`, recent research and GitHub code search is insufficient: **the authoritative `LAB_COMPUTE_LOG.md` and old `lab-jobs/` may contain earlier execution results absent from current summaries**. For every proposed LinuxCNC defect/reproduction, scan the lab ledger and source job scripts by mechanism and synonyms *before* claiming no tests or novelty. The failure here inflated verification debt and would have spent scarce runner time rerunning an already-confirmed case. Preserve both original historical claims and this explicit superseding correction.

## Evidence limits and next checkpoint

**TEST-CONFIRMED:** 2026-09-11 historical LinuxCNC `8bf4605` control/experiment timing and program completion. **SOURCE-CONFIRMED:** source state-lifetime mechanism at v2.9.10 and `06864e`. **INFERENCE:** precise Task pass and G4 dwell duration in historical run. **NOT RUN:** newer A–E matrix, stable/development execution, cross-program abort, any proposed patch. **UNKNOWN:** field configurations and physical behavior. Graduated levels and independent personnel-safety G0/G1 HOLD unchanged. [Next checkpoint](../checkpoints/20261101T234000Z-4000-linuxcnc-m66-evidence-reconciliation-next.md).
