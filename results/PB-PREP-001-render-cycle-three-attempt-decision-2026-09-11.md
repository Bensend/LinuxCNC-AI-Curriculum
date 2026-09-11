# PB-PREP-001 render-cycle three-attempt decision

Date: 2026-09-11

Decision: **ESSENTIAL NOW — stop blind execution and scope the next transformation to the generated `newnets` block only**

This is the second explicit three-attempt decision for PB-PREP-001 harness construction. No 070–072 result contains A/B/C behavioral evidence.

## Redesigned-cycle attempts

1. **070 — render-validated construction:** failed in 9 seconds before generated validation/LinuxCNC because the temp generator was invoked as an executable without execute permission. This validated the cheap-fail principle but not the behavioral fixture.
2. **071 — execution-mode correction:** reached pinned LinuxCNC build and retained the generated HAL, then failed at HAL load. Independent inspection of `arch-A/fixture.hal` showed the primary signals were already created correctly, but packed sampler taps used constructs such as `net sr1 y1cmd => sampler.0.pin.2`. In HAL syntax `y1cmd` is an existing signal, not a pin; a sampler must join that signal with `net y1cmd => sampler.0.pin.2`.
3. **072 — attempted sampler-tap correction:** failed in 9 seconds in its preflight because the target text occurs twice in the 068 generator source: once in `oldnets` and once in `newnets`. The preflight correctly refused an ambiguous global replacement rather than modifying both blocks.

## Why ESSENTIAL NOW remains correct

The frozen comparison still requires one coherent, independently auditable atomic recorder. The newly exposed defects are instrumentation construction, not evidence against any A/B/C controller architecture. Promoting or dropping the harness while retaining a claimed comparison would invalidate the evidence chain.

## Required next construction boundary

The next attempt must **not** search/replace the whole generator source. It must locate the `newnets='''...'''` raw-string block structurally, transform only that block, then assert:

- `oldnets` remains byte-for-byte unchanged;
- packed `newnets` contains direct joins to existing `y1cmd`, `y2cmd`, `y1fb`, `y2fb`, `ref1`, `ref2`, `pid1out`, and `pid2out` signals;
- no `net sr1 y1cmd`, `net sr2 y2cmd`, `net sy1 y1fb`, `net sy2 y2fb`, `net sref1 ref1`, `net sref2 ref2`, `net spid1 pid1out`, or `net spid2 pid2out` remains in `newnets`;
- the fully rendered final behavioral script passes the existing 070 `bash -n`, 21-element sampler, pin-index, frozen-constant, disturbance, and B/P6-INCONCLUSIVE static checks before LinuxCNC setup;
- no behavioral constants, timing, Gates A–J, or outcome rules change.

This structural scoping is the material correction required before another execution. A new run should be considered a new construction cycle only after that scoped transformation is retained and statically audited.

## Evidence classification

067–072 remain **HARNESS INVALID / compute only**. They must not be pooled into architecture metrics, used to rank A/B/C, or used to infer hydraulic or safety suitability.
