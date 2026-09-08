# C05-029 attempt 7 reconciliation — concurrent sampler transport remains invalid

## Classification

**HARNESS INVALID / observation transport.** Do not score frozen C05-029 Gates A–H from this run and do not treat it as evidence for or against the wrong-scale/jump behavioral prediction.

## Authoritative run

- workflow: `34256658628`
- job: `102164080412`
- source commit: `5fba233b8dee0dca10df8ef224e75af565f16e1a`
- lab job: `036-c05-scale-jump-concurrent-samplers-quiescent-drain`
- artifact: `10068261174`
- workflow/inner result: failure / exit 1

The run reached the intended LinuxCNC fixture, passed provenance/topology, homed, entered MDI, published phase 1, and reported `sampler-overruns=0`. The failure occurred in the split observation transport after acquisition, before any C05-029 behavioral gate could be validly scored.

## What attempt 7 changed

Attempt 7 retained two concurrent `halsampler` readers and the exact sample-number join. Relative to attempt 6 it stopped realtime production once and inserted a 250 ms quiescent drain interval before either reader was terminated. No frozen behavioral gate, threshold, PID gain, plant gain, phase duration, `Kc`, wrong-scale value, or jump offset was changed.

## Why the result is invalid

The transport has now consumed multiple closely related termination/drain patches without producing an auditable exact two-FIFO observation set. The latest result still exits 1 immediately after the phase-1 acquisition summary rather than reaching the frozen behavioral analysis. A zero sampler-overrun count does not prove that two independent userspace FIFO readers retained identical terminal sample-number sets.

The curriculum's three-similar-attempt rule therefore applies to this transport family. Another `sleep`, reader-kill ordering change, or FIFO-drain timing tweak would be iterative harness tuning, not new LinuxCNC behavioral evidence.

## Correction decision

**Retire the split-FIFO exact-join transport for C05-029.** The experiment remains ESSENTIAL NOW, so it is not promoted away. The next implementation must return to a single realtime sampler FIFO containing the complete decisive row, or otherwise use one atomic realtime observation record. This removes cross-FIFO terminal alignment as an evidence dependency instead of trying to tune it.

The redesign must preserve:

1. frozen C05-029 Gates A–H and all behavioral values unchanged;
2. same-servo-cycle capture of every quantity required to score the gates;
3. raw trace preservation before analyzer exit;
4. no interpolation, nearest-neighbor matching, post-hoc row deletion, or phase relabeling;
5. explicit sampler overrun evidence;
6. the existing safety boundary: fixture true state is simulation truth only, and ordinary HAL/PID arithmetic is not safety-rated sensor-fault detection.

## Next-work checkpoint

Inventory the fields actually required by frozen Gates A–H, verify they fit one `sampler` channel under the pinned component's supported pin-count/type constraints, document the one-row field map, and only then implement one single-FIFO C05-029 transport. If they cannot fit, design a realtime packing/reduction method whose outputs are themselves sampled atomically; do not resume split-FIFO timing patches.
