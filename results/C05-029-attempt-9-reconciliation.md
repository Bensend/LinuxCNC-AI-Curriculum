# C05-029 attempt 9 reconciliation — HARNESS INVALID

Date: 2026-09-08
Workflow: `34262965164`
Job: `102185236542`
Artifact: `10070659035`
Source commit: `7c3108c63e7ad67f8c4cfc93b4aaf7b2040a6bfc`
Inner exit: `2`
Classification: **HARNESS INVALID — no C05 behavioral verdict**

Attempt 9 was intended to preserve the single 20-field realtime FIFO, retain the analyzer here-document terminator, and change only pinned userspace `halsampler` float serialization from `%f` to `%.17g` before build.

The run checked out the exact pinned LinuxCNC commit, then the generated shell failed at line 27 with `syntax error near unexpected token '('`. No LinuxCNC configure/build, fixture startup, sampling, or frozen behavioral phase occurred. The nested Python-here-document construction used to inject the observer patch was itself malformed when emitted into the generated shell.

This is a staging/generator defect only. Frozen C05-029 Gates A-H, `Kc`, plant/PID gains, scale factor, jump offset, phase durations, sampler field map, and the one-FIFO architecture remain unchanged.

Next correction: remove the nested Python observer-edit block entirely. Use a simple exact-match/verified userspace source edit before build, prove exactly one `%f` HAL_REAL print site was changed to `%.17g`, emit the resulting source diff/hash, retain the analyzer closing delimiter, and run the same one-FIFO experiment. No behavioral retuning is permitted.
