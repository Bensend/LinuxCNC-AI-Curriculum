# M66-TIMEOUT-001 — authoritative frozen behavioral contract

Frozen: 2026-09-11, before inspection of any run-079 result.
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Pre-result consistency correction

The call-flow note `call-flows/press-brake-M66-Q-supervisory-wait-timeout.md` contains one experiment-summary bullet that says `M66 P0 L3 Q0.20`. That is a transcription error and is **not** the authoritative experiment mode.

The source-grounded hypothesis developed in that same note is specifically about a timed-out `RISE` wait: with the input initially LOW, Task transforms `WAIT_MODE_RISE` to `WAIT_MODE_HIGH`; if timeout occurs without clearing the auxiliary wait bookkeeping, the following `G4` may share `WAITING_FOR_DELAY` with a stale HIGH wait. Therefore the authoritative frozen M66 instruction is:

`M66 P0 L1 Q0.20`

This correction is committed before inspecting any run-079 behavioral result. It changes no runtime script, threshold, timing, or result interpretation; it only makes the written contract consistent with the already-stated source hypothesis and the committed lab script.

## Frozen sequence

Control, in a fresh LinuxCNC process state before any M66 wait:

1. force `motion.digital-in-00` LOW;
2. execute `G4 P0.50`;
3. measure program completion interval.

Experimental case:

1. force `motion.digital-in-00` LOW;
2. execute `M66 P0 L1 Q0.20`;
3. require `#5399 == -1`; otherwise abort and classify the harness invalid for this contract;
4. immediately execute `G4 P0.50`;
5. at 0.30 s after AUTO_RUN begins, force the same digital input HIGH;
6. measure program completion interval.

## Frozen discriminator

Let `delta = experimental_duration - control_duration`.

- `delta <= -0.10 s` -> `STALE-WAIT INTERACTION CONFIRMED`.
- `delta >= +0.10 s` -> `HYPOTHESIS FALSIFIED`.
- otherwise -> `NONDISCRIMINATING / HARNESS INVALID`.

The control G4 must lie inside a broad 0.35–1.20 s plausibility band. The frozen input transition must actually execute. LinuxCNC error-channel output invalidates the run unless it is explicitly part of the contract.

## Interpretation boundary

A positive result would confirm a stock Task/interpreter bookkeeping interaction at the pinned revision. It would **not** by itself establish physical press-brake behavior, field-I/O timing, realtime synchronization behavior, or functional-safety implications.

A negative result would falsify this specific stale-wait/G4 consequence, but would not change the already source-confirmed architectural conclusion that M66 is a non-realtime supervisory wait whose timeout becomes `#5399=-1` and must be explicitly handled by the operation owner.
