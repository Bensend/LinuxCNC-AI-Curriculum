# C05-029 attempt 10 reconciliation — HARNESS INVALID

Date: 2026-09-08
Workflow: `34263179781`
Job: `102185951531`
Artifact: `10070739669`
Source commit: `9771834ec8b293bf72705fa0683f2479d6268bc3`
Inner exit: `2`
Classification: **HARNESS INVALID — no C05 behavioral verdict**

Attempt 10 again checked out the exact pinned LinuxCNC revision but failed in the generated shell before configure/build with `syntax error near unexpected token '('`.

The defect is now reproduced independently from the generator source: the outer generator emitted the observer shell via `obs_shell = r<repr-string>`. Because that is a Python **raw** string, the `\n` escape sequences produced by `repr()` remained literal backslash-n characters instead of becoming shell line breaks. The generated observer patch therefore became one malformed shell line.

Correction is limited to the generator representation: emit `obs_shell = <repr-string>` as a normal Python string so the escaped newlines become actual shell line boundaries. The exact-match/verified `%f` -> `%.17g` userspace observer edit, single 20-field realtime FIFO, analyzer delimiter fix, frozen Gates A-H, thresholds, transforms, gains and phase timing are otherwise unchanged.
