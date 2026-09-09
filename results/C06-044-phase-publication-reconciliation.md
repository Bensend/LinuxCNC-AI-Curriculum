# C06-044 — authoritative real-readiness run reconciliation

Status: **HARNESS INVALID — PHASE PUBLICATION DEFECT**

Workflow `34311582310`, job `102339170004`, artifact `10088629138`, pinned LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`.

C06-044 fixed the earlier sampler-readiness defect and produced 2,967 strictly ordered single-stream realtime rows. The retained analyzer printed Gates A–C and E–H PASS and Gate D FAIL. That printed `BEHAVIORAL VERDICT: FAIL` is **not accepted** after raw-trace reconciliation because the frozen experiment plan explicitly classifies a phase-publication defect as HARNESS INVALID.

## Raw-trace finding

P0 ends with `read_fail=0`. The **first** sample labeled P1 already has `read_fail=1`, `fail_reads_remaining=0`, `io_error=0`, and `watchdog.has_bit=0`. All later P1 rows retain `read_fail=1` while successful-read and successful-write counters continue advancing. Thus the intended single transient failed read occurred, watchdog state stayed clear, and transport recovered — but the fault event happened before the P1 label became visible to the realtime sampler.

The cause is deterministic in the executed controller ordering:

```text
sets c06-fail-remaining 1
sets c06-phase 1
```

Those are asynchronous HAL commands. The realtime thread can consume the first mutation before it observes the second. Gate D was frozen to require the failed-read event **inside P1**, so the trace cannot legitimately satisfy it even though the surrounding behavior matches the prediction.

The same publication ordering is visible at other transitions and strengthens the diagnosis rather than rescuing Gate D post hoc:

- first P2 row already has two additional failed reads (`read_fail=3`, `consecutive_failures=2`);
- first P4 row already has watchdog command/status/`has_bit` asserted;
- first P6 row already has watchdog command/status/`has_bit` cleared.

## Classification

The frozen plan says: “Any failure caused by ... phase publication ... defects is HARNESS INVALID and cannot falsify the prediction.” Therefore:

- C06-044 is **HARNESS INVALID**, not an accepted LinuxCNC behavioral failure;
- Gates A–H remain unaccepted as a complete authoritative set;
- the raw trace is still useful diagnostic evidence and strongly supports the intended state separation, but cannot be promoted to the accepted experiment because one decisive transition was outside its declared phase.

## Three-attempt decision

The redesigned behavioral lineage has now produced C06-037, C06-038, and C06-044 without an accepted run. Per the module-template three-similar-attempt rule the decision remains **ESSENTIAL NOW / REDESIGN**, not blind retry. The next harness must change the publication protocol, not the frozen behavior:

1. publish the new phase label first;
2. retain several realtime rows proving that phase is observable;
3. only then mutate the fault/recovery control inside that phase;
4. leave threshold `3`, watchdog status `0x2004:0`, P0–P6 meanings, production HostMot2 code, and Gates A–H unchanged.

A non-authoritative transition-publication preflight should first prove that each commanded state mutation appears strictly after at least one sample carrying its intended phase label. Only then is one redesigned authoritative C06-030 attempt justified.
