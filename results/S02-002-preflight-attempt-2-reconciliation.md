# S02-002 — frozen observability preflight attempt 2 reconciliation

Date: 2026-09-09
Workflow: `34394421086`
Job: `102610462761`
Job runtime: 2026-09-09T19:20:04Z–2026-09-09T19:25:08Z = 5.1 min
Source commit: `c29f95aac6603fcc798de45de9b8e22a77f70d0b`

## Classification

**HARNESS INVALID — pre-behavior HAL lifecycle mismatch.** Frozen S02 P0–P5 and Gates A–J remain **UNSCORED**.

Attempt 2 correctly fixed the exported HAL object name (`s02-model.0`) and progressed beyond the attempt-1 `addf` error. It still did not produce P0–P5 evidence.

## Failure and source check

The outer shell later failed on:

```text
<commandline>:0: parameter or pin 'sampler.0.enable': not found
```

This is not evidence that the pinned sampler lacks an enable pin. At LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`, `src/hal/components/sampler.c:init_sampler()` explicitly exports `sampler.%d.enable` as a `HAL_IN` bit, initialized true, and `sample()` tests it before capture.

The harness problem is lifecycle: it started `halrun -f /tmp/s02.hal` in the background and assumed that process would remain as the owner of the HAL configuration. Once the file was executed, that standalone `halrun` invocation did not provide the persistent HAL lifetime expected by the later external `halcmd` calls. The resulting missing pin is therefore a harness-lifetime symptom, not a sampler interface contradiction.

Repository precedent (`lab-jobs/007-h04-execution-ordering.sh`) uses the correct standalone pattern: `realtime start`, persistent `halcmd loadrt/...`, `halcmd start`, then external observation, with explicit stop/unload/realtime cleanup.

## Allowed attempt-3 correction

Attempt 3 may change only the standalone HAL lifetime mechanism:

1. retain attempt-1 exported-name correction `s02_model.0` -> `s02-model.0`;
2. replace background `halrun -f` ownership with `realtime start` plus `halcmd -f /tmp/s02.hal` (or equivalent persistent `halcmd` setup);
3. replace process-kill cleanup with `halcmd stop`, `halcmd unload all`, `realtime stop`;
4. leave frozen P0–P5, Gates A–J and every numeric threshold/latency unchanged.

This is the second materially similar preflight attempt. Attempt 3 is the final allowed incremental correction in this lineage before mandatory ESSENTIAL NOW / PROMOTE / DROP classification.
