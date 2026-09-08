# Latest LinuxCNC Lab Result

- Job: `026-c04-asymmetric-authority-attempt2`
- Job file: `lab-jobs/026-c04-asymmetric-authority-attempt2.sh`
- Workflow run ID: `34243595136`
- Attempt: `1`
- Source commit: `553cb3aa9def030d9b7b115493909ba76df7e892`
- Exit code: `1`
- Finished UTC: `2026-09-08T15:15:43Z`

## Metadata
```text
LinuxCNC AI Curriculum Lab
UTC start: 2026-09-08T15:15:43Z
Repository commit: 553cb3aa9def030d9b7b115493909ba76df7e892
Workflow run: 34243595136 attempt 1
Job file: lab-jobs/026-c04-asymmetric-authority-attempt2.sh
Runner: Linux runnervmejwal 6.17.0-1022-azure #22-Ubuntu SMP Mon Jul 27 17:24:03 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
Inner lab timeout: 70 minutes (job ceiling: 75 minutes)

UTC finish: 2026-09-08T15:15:43Z
```

## Standard output
```text
== C04-026 corrected observation preflight ==
frozen-gates=A-H unchanged
control-values=unchanged
corrections=Gate-F outB tuple index 9; raw/internal logs retained before analyzer
99:# Corrected evidence retention inserted before the generated analyzer.
108:    printf 'pre-analyzer-retained-evidence=%s sha256=%s bytes=%s\\n' "$f" "$(sha256sum "$f" | awk '{print $1}')" "$(wc -c < "$f")"
114:printf 'pre-analyzer-retained-realtime-lines=%s\\n' "$(wc -l < c04-026-realtime.txt)"
156:    ok=(r[18]==1 and abs(r[9]-1.0)<=1e-9) # outB index 9; positive move
corrected-outer-sha256=b3eb3ca00aa9ed9da23bbdded24061cc713d7bf4d5f3a0f751bb62b73bef4e3a
```

## Standard error
```text
Traceback (most recent call last):
  File "<stdin>", line 105, in <module>
AssertionError: 0
```
