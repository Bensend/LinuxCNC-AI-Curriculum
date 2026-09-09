# C06-041 Fixture/Sampler Interaction Diagnostic Reconciliation

## Classification

**PARTIALLY VALID NON-AUTHORITATIVE DIAGNOSTIC; WRAPPER EXIT INVALID AFTER DECISIVE STAGE OUTPUT.** This run does not score frozen C06-030 Gates A–H.

- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Curriculum source commit: `9bfd5ae283328853f911324bde1c5aa5af053e92`
- Workflow: `34310509116`
- Job: `102336017000`
- Job start/end: `2026-09-09T04:19:19Z` / `2026-09-09T04:22:18Z`
- Exact job compute: 3.0 min
- Inner exit: 1

## Predeclared stages

C06-039 had already proven that exact `depth=30000 cfg=uubbbuuuub` attaches without HostMot2. C06-041 then added the accepted C06-036 pattern-15 fixture in stages:

- **Stage A:** `hostmot2` + pattern-15 `hm2_test` + exact sampler, no C06 signal topology.
- **Stage B:** complete static P0 C06 signals/nets/sampler links plus watchdog timeout, still with no P1–P6 fault phases.

Prediction A was that a Stage-A failure would implicate the fixture/HAL interaction itself. Prediction B was that Stage-A pass plus Stage-B failure would narrow the trigger to static P0 topology/startup state, subject to eliminating cross-halrun residue.

## Retained measured output

`lab-results/run-34310509116-1/summary.txt` records:

```text
CASE fixture wiring=fixture: halsampler_rc=0 parseable_rows=10
CASE full-p0 wiring=full: halsampler_rc=1 parseable_rows=0
  stderr: hal_stream_attach: Invalid argument
```

These two stage measurements completed and their cleanup paths ran before the shell terminated.

## Wrapper defect

The script intentionally called Stage B under `set +e`, but `run_case()` internally restored `set -e` before returning a false final `[[ ... ]]`. Because shell option state is process-global rather than function-local, that false return terminated the script before it printed its final verdict/UTC-finish line. This explains workflow exit 1 and is a diagnostic-wrapper defect, not a LinuxCNC behavioral failure.

The retained Stage-A and Stage-B observations remain useful as diagnostic evidence because both probes themselves completed and saved their stdout/stderr before the wrapper exit. However, Stage B ran in a second `halrun` after Stage A, so cross-halrun/shared-memory cleanup remains a plausible confound and must be removed before assigning causality to a particular net/pin mutation.

## Additional source check

The pattern-15 fake watchdog status address `0x2004` is within pinned `hm2_test` backing storage: `hm2_test.h` allocates a 64 KiB byte array / 16 Ki-dword alias. Therefore the earlier hypothesis that `0x2004` was automatically an out-of-bounds fake-register write is falsified.

## Next discriminator

`lab-jobs/042-c06-persistent-stream-topology-localizer.sh` keeps one fixture and one sampler stream alive, obtains a baseline successful userspace attach, then probes the same stream after:

1. signal creation only;
2. linking fixture/HostMot2 endpoints while leaving sampler pins untouched;
3. linking sampler pins 0–9 one at a time;
4. applying the P0 watchdog timeout and non-faulting P0 values.

An attach transition from pass to fail on the same still-live stream would identify the first causally sufficient topology mutation and eliminate the C06-041 cross-halrun confound. Frozen C06-030 gates/thresholds/phases remain unchanged and unscored.
