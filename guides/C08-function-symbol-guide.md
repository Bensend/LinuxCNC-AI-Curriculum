# C08 — Diagnostic Function / Symbol Guide

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

| Symbol | Source | Context | Purpose / state | Failure behavior | Diagnostic consequence |
|---|---|---|---|---|---|
| `sample()` | `src/hal/components/sampler.c` | realtime HAL function | reads configured HAL pins and enqueues one record | full FIFO records sampler overrun/full evidence | sample meaning depends on HAL thread placement |
| `hal_stream_create()` | `src/hal/hal_lib.c` | creator, RT-capable HAL library | allocates/initializes typed shared-memory FIFO | invalid type/config/shmem errors | creator readiness must precede attach |
| `hal_stream_attach()` | `src/hal/hal_lib.c` | userspace consumer path | validates magic/types then maps full FIFO | bad magic/type/shmem -> negative return | HAL pin existence alone does not prove attachability |
| `hal_stream_write()` | `src/hal/hal_lib.c` | producer | copies complete record, assigns successful-enqueue sample number, publishes `in` | full -> increments `num_overruns`, `-ENOSPC`, no successful sample-number increment | producer overrun evidence cannot be replaced by consumer tag continuity |
| `hal_stream_read()` | `src/hal/hal_lib.c` | consumer | copies one queued record and its stored sample number, advances `out` | empty -> `num_underruns`, `-ENOSPC` | returned tag identifies queued record sequence, not attempted sample count |
| `hal_stream_writable()` | `src/hal/hal_lib.c` | producer | checks `advance(in) != out` | false when reserved-slot ring is full | usable capacity is depth-1 |
| `halsampler` consumer loop | `src/hal/components/sampler_usr.c` | userspace | attaches, waits, reads, checks expected sample number, prints typed trace | attach/read/process lifecycle failures | retain stderr/exit/completion plus producer validity state |
| `emcOperatorError()` | `src/emc/task/emctaskmain.cc` | Task userspace process | formats error, `rcs_print`s it, writes `EMC_OPERATOR_ERROR` to error NML | channel-space/format preconditions can fail | process log and NML message are two descendants, not an atomic pair |
| `updateError()` | `src/emc/usr_intf/shcom.cc` | UI/userspace client | reads `emcErrorBuffer`, copies typed operator/NML errors to local strings | invalid/read error -> -1 | GUI/script error text is a consumed copy of channel state |
| `updateStatus()` | `src/emc/usr_intf/shcom.cc` | UI/userspace client | peeks status NML buffer | invalid/CMS error -> -1 | point status is controller-reported state, not plant truth |
| `emcCommandWaitDone()` | `src/emc/usr_intf/shcom.cc` | UI/userspace client | polls status, correlates command serial, distinguishes EXEC/DONE/ERROR | timeout/ERROR/unknown status -> -1 | command completion evidence is separate from error text and physical achievement |

## Retrieval rules

```text
HAL object exists != stream attach succeeds
realtime sample != automatically after every relevant producer
successful sample tags contiguous != no producer-side rejected writes
NML operator error present != exact servo-cycle timestamp known
command DONE/ERROR != physical plant truth
process log line and NML error message != atomic cross-surface observation
trace visibility != safety function
```
