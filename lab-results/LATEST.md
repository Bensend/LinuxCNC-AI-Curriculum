# Latest LinuxCNC Lab Result

- Job: `026-c04-asymmetric-authority-attempt2`
- Job file: `lab-jobs/026-c04-asymmetric-authority-attempt2.sh`
- Workflow run ID: `34243479618`
- Attempt: `1`
- Source commit: `0fbcb00849f17b7e468f9bd860b4bdd3ff7f30bd`
- Exit code: `1`
- Finished UTC: `2026-09-08T15:14:40Z`

## Metadata
```text
LinuxCNC AI Curriculum Lab
UTC start: 2026-09-08T15:14:40Z
Repository commit: 0fbcb00849f17b7e468f9bd860b4bdd3ff7f30bd
Workflow run: 34243479618 attempt 1
Job file: lab-jobs/026-c04-asymmetric-authority-attempt2.sh
Runner: Linux runnervmejwal 6.17.0-1022-azure #22-Ubuntu SMP Mon Jul 27 17:24:03 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
Inner lab timeout: 70 minutes (job ceiling: 75 minutes)

UTC finish: 2026-09-08T15:14:40Z
```

## Standard output
```text
```

## Standard error
```text
  File "<stdin>", line 18
    retain = r'''\nmkdir -p "$EVID"\nRUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"\nmkdir -p "$RUN_EVID"\nfor f in c04-026-realtime.txt c04-linuxcnc.stdout c04-linuxcnc.stderr c04-026-halsampler.stderr; do\n  if [[ -f "$f" ]]; then\n    cp "$f" "$EVID/$f"\n    cp "$f" "$RUN_EVID/$f"\n    printf 'pre-analyzer-retained-evidence=%s sha256=%s bytes=%s\\n' "$f" "$(sha256sum "$f" | awk '{print $1}')" "$(wc -c < "$f")"\n  else\n    printf 'HARNESS_INVALID: required pre-analyzer evidence missing: %s\\n' "$f" >&2\n    exit 32\n  fi\ndone\nprintf 'pre-analyzer-retained-realtime-lines=%s\\n' "$(wc -l < c04-026-realtime.txt)"\n'''\ntrace_marker="TRACE=c04-026-realtime.txt python3 - <<'PY'\\n"\nassert s.count(trace_marker)==1, s.count(trace_marker)\ns=s.replace(trace_marker, retain+trace_marker, 1)\n'''
                                                                                                                                                               ^
SyntaxError: unexpected character after line continuation character
```
