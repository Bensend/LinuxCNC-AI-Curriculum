# E20-002 — authoritative retained-evidence reconciliation

Date: 2026-09-09
Module: E20 — hm2_eth / HostMot2 watchdog recovery across versions
Experiment: `experiments/E20-001-transport-watchdog-recovery-boundaries.md`
Classification: **AUTHORITATIVE PASS — FROZEN GATES A–J 10/10**

## Authoritative execution identity

- GitHub Actions workflow: `34399792261`
- Job: `102628547104`
- Artifact: `10123146331`
- Authoritative wrapper: `lab-jobs/026-e20-authoritative-transport-watchdog.sh`
- Numeric/model contract remained frozen at packet-error limit `10`, increment `2`, decrement `1`, 1 ms realtime sampling, P0–P8, and unchanged Gates A–J.

Workflow success was **not** accepted as experiment evidence. The retained artifact was downloaded and its actual files were independently inspected.

## Retained evidence inspected

The artifact contains the authoritative fixture source and publication package, including:

- `e20_model.comp`
- `e20.hal`
- `atomic.samples`
- `analysis.txt`
- `recorder-health.txt`
- `predeclared-model.txt`
- `thread.txt`
- `topology.txt`
- `linuxcnc-commit.txt`
- HAL/realtime/sampler stdout+stderr and wrapper lineage/source material.

The atomic stream contains **1,100 rows** with monotonically contiguous retained tags `0..1099`. Producer health reports `sampler-overruns=0`.

The retained component source confirms phase is assigned before the phase-specific stimulus/state logic and that all observed discriminator signals are produced in the same realtime function before the sampler runs downstream in the retained HAL ordering.

## Independent runtime checks

### P0 — clean baseline

Retained P0 samples are internally clean: packet-error level 0, current packet error false, `io_error` false, watchdog clear, physical I/O authority true. Initial motion authorization is true.

### P1 — isolated soft packet error

The first retained P1 sample (tag 281) contains one transaction error and shows:

- total errors = 1;
- packet-error level = **2**;
- current packet error = true;
- `needs_soft_reset` = true;
- `io_error` = false;
- machine authorization = false.

This preserves the distinction between a soft packet error and saturated `io_error`.

### P2 — clean current transaction with retained history

The first P2 sample (tag 282) is a clean transaction with:

- current packet error = false;
- level = **1**;
- `io_error` = false;
- motion still unauthorized.

The following clean cycle decays the level to 0 while authorization remains false. A clean current packet therefore does not erase prior fault history or reauthorize motion.

### P3 — exact threshold edge

Starting from level 0, the five consecutive P3 errors produce levels:

`2, 4, 6, 8, 10`

The fifth error (tag 386) is the first to show level 10 with both `packet_error_exceeded = true` and `io_error = true`. No threshold was retuned after execution.

### P4 — driver recovery is not machine recovery

At tag 387 the retained explicit clear request resets the saturated communication-error state before the clean receive-cycle update. Retained state shows:

- level = 0;
- current packet error = false;
- `io_error` = false;
- exceeded = false;
- motion authorization remains false.

Thus `io_error == FALSE` is not used as an automatic-restart condition.

### P5 — watchdog/physical-I/O authority is independent

Across retained P5:

- current transport remains clean;
- watchdog is bitten;
- physical I/O authority is false;
- motion is unauthorized;
- internal generator counter continues advancing every sampled cycle.

This directly demonstrates the frozen laboratory discriminator: internal FPGA/module activity and a clean host transaction do not prove physical output-pin authority.

### P6 — board/driver recovery without machine-state revalidation

At the first P6 sample the watchdog is clear, physical I/O authority is true, transport is clean, `io_error` is false, and the modeled `needs_soft_reset` latch has been explicitly cleared. `state_revalidated` remains false and machine authorization remains false throughout P6.

This preserves the boundary between transport/driver/board recovery and independent machine-state authority.

### P7 — explicit revalidation + explicit reauthorization

The first P7 sample (tag 687) contains both explicit `state_revalidated = true` and explicit `reauthorize_request = true`, with clean transport, no `io_error`, no soft-reset requirement, and physical I/O authority present. Only then does machine authorization become true.

### P8 — fail-closed relapse

The first P8 sample (tag 787) injects a fresh transaction fault. In that **same retained realtime sample**, current packet error becomes true, level becomes 2, `needs_soft_reset` relatches, and machine authorization becomes false. Prior P7 validation does not survive the new fault.

## Frozen Gates A–J

| Gate | Result | Retained-evidence basis |
|---|---|---|
| A | **PASS** | One retained atomic realtime stream, 1,100 contiguous tags, full declared signal set, producer `sampler-overruns=0`. |
| B | **PASS** | P0 clean baseline has level 0, no packet/io/watchdog fault, physical authority true. |
| C | **PASS** | P1 single error gives level exactly 2, current packet error + soft-reset latch, no saturated `io_error`, authorization revoked. |
| D | **PASS** | First P2 clean sample clears current packet error while level remains exactly 1 and authorization stays false. |
| E | **PASS** | Exactly five P3 errors produce 2/4/6/8/10 and assert exceeded/`io_error` on the fifth. |
| F | **PASS** | P4 clears saturated driver error state while machine authorization stays false. |
| G | **PASS** | P5 clean current transport + advancing internal counter coexist with watchdog bite and physical authority false. |
| H | **PASS** | P6 restores transport/driver/watchdog/physical-I/O conditions while revalidation is false and authorization remains false. |
| I | **PASS** | P7 explicitly revalidates/reauthorizes; first P8 fresh fault revokes authorization in the same modeled cycle. |
| J | **PASS** | Interpretation remains explicitly synthetic/version-pinned and makes no physical stopping, diagnostic-coverage, functional-safety, or universal-version claim. |

**Score: 10/10 — AUTHORITATIVE PASS.**

## Scope boundary retained after pass

E20-001 supports a source-informed state-separation model for current-lineage hm2_eth soft-error accounting and a deliberately synthetic watchdog/physical-authority/machine-revalidation discriminator. It does **not** prove Ethernet physics, Mesa firmware timing, exact physical output behavior, stopping performance, functional-safety integrity, diagnostic coverage, or identical behavior across LinuxCNC versions.

The historical source comparison remains material: old hm2_eth implementations must be inspected on their own source/release lineage rather than being assigned v2.9.x recovery semantics by analogy.

## Next acceptance step

Execute and grade the already-frozen `evaluation/E20-adversarial-exam-draft.md` without altering its questions or traps. If it passes, perform the counterfactual/promotion review and prepare the required information-separated fresh-AI handoff. The current learner instance must not self-certify that handoff as fresh.
