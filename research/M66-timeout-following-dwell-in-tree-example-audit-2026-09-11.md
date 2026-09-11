# M66 timeout -> following dwell: in-tree example audit

Date: 2026-09-11
Context: 4600 press-cycle timeout ownership research
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Related lab: M66-TIMEOUT-001 / run 079

## Finding

After run 079 independently confirmed that a timed-out event-mode M66 can leave stale auxiliary-wait state that prematurely terminates a subsequent G4, a bounded source search found an existing LinuxCNC example with the same command shape:

`nc_files/touchoff.ngc`

Relevant sequence at the pinned revision:

```text
M3 S1
M66 P0 L1 Q5 (Wait for Arc OK from Torch)
G4 P#2 (Pause for pierce delay)
F25
Z#3 (goto cut height)
```

The file does not test `#5399` between M66 and G4.

Git history metadata exposed by GitHub dates this example to 2011-04-17 at the inspected pinned file, making it a longstanding example rather than a new press-brake-specific construction.

## Why it matters

The exact run-079 failure mechanism requires the event wait to **time out** and the previously selected input later to satisfy the stale internal wait condition during the following dwell.

For this example's `L1` RISE wait:

1. if Arc OK rises normally before Q5, the ordinary successful-wait branch clears the auxiliary wait index and the confirmed stale-timeout mechanism does not apply;
2. if Arc OK never arrives, M66 reaches timeout and `#5399` becomes `-1`;
3. because this example does not inspect `#5399`, execution proceeds directly to its pierce-delay G4;
4. on the tested LinuxCNC revision, if Arc OK then arrives late during that G4, the stale M66 HIGH state can terminate the G4 early instead of allowing the programmed pierce delay to finish.

This is a **source-supported applicability analysis** combined with a **lab-confirmed generic mechanism**. It is not evidence that a specific plasma machine suffered an incident or that the example necessarily uses a nonzero `#2` in every invocation.

## Current-master relevance

A source search on 2026-09-11 found the same `M66 P0 L1 Q5` followed by `G4 P#2` sequence still present in current LinuxCNC master, and separate inspection of current `emctaskmain.cc` found the same stale auxiliary-wait bookkeeping structure.

Behavioral execution of current master was not performed in this curriculum session, so the current-master statement is source-level only.

## Curriculum consequence

This turns the stale-wait result from a purely synthetic corner case into a lesson with a real in-tree sequencing example:

- after any timed M66, consume `#5399` explicitly before continuing process sequencing;
- do not assume a following G4 is independent after an M66 timeout on affected code;
- process-state ownership should make timeout a named transition rather than silently falling through into the next timed phase;
- preserve the existing distinction between supervisory process timing and realtime/safety fault detection.

For press-brake design, this specifically supports making **pressure/position/authorization wait expiration an explicit cycle-state failure**, rather than writing `M66 ... Q...` followed by the next dwell/motion without an explicit timeout branch.

## Scope boundary

This artifact is not a functional-safety claim, hydraulic validation, realtime synchronization result, or evidence about Arc OK hardware behavior. It is a LinuxCNC Task/interpreter sequencing result and source-example audit.
