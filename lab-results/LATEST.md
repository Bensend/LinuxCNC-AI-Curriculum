# Latest LinuxCNC Lab Result

- Job: `031-c05-scale-jump-corrected`
- Job file: `lab-jobs/031-c05-scale-jump-corrected.sh`
- Workflow run ID: `34251568612`
- Attempt: `1`
- Source commit: `6a151ae686c034de7bb64b276c0d2fde452dec46`
- Exit code: `1`
- Finished UTC: `2026-09-08T16:31:47Z`

## Metadata
```text
LinuxCNC AI Curriculum Lab
UTC start: 2026-09-08T16:31:47Z
Repository commit: 6a151ae686c034de7bb64b276c0d2fde452dec46
Workflow run: 34251568612 attempt 1
Job file: lab-jobs/031-c05-scale-jump-corrected.sh
Runner: Linux runnervmejwal 6.17.0-1022-azure #22-Ubuntu SMP Mon Jul 27 17:24:03 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
Inner lab timeout: 70 minutes (job ceiling: 75 minutes)

UTC finish: 2026-09-08T16:31:47Z
```

## Standard output
```text
```

## Standard error
```text
  File "<stdin>", line 61
    halsampler -c 1 -n "$SECONDARY_COUNT" -t >c05-029-realtime-b.txt 2>c05-029-halsampler-b.stderr
                                                  ^
SyntaxError: leading zeros in decimal integer literals are not permitted; use an 0o prefix for octal integers
```
