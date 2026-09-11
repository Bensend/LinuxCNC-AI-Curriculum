# Latest LinuxCNC Lab Result

- Job: `082-f02-compound-fault-arbitration`
- Job file: `lab-jobs/082-f02-compound-fault-arbitration.sh`
- Workflow run ID: `34657204415`
- Attempt: `1`
- Source commit: `4d3277d1d11b60cf68126c65190d7ee42886f8e8`
- Exit code: `0`
- Finished UTC: `2026-09-11T23:13:13Z`

## Metadata
```text
LinuxCNC AI Curriculum Lab
UTC start: 2026-09-11T23:13:13Z
Repository commit: 4d3277d1d11b60cf68126c65190d7ee42886f8e8
Workflow run: 34657204415 attempt 1
Job file: lab-jobs/082-f02-compound-fault-arbitration.sh
Runner: Linux runnervmlun5p 6.17.0-1022-azure #22-Ubuntu SMP Mon Jul 27 17:24:03 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
Inner lab timeout: 70 minutes (job ceiling: 75 minutes)

UTC finish: 2026-09-11T23:13:13Z
```

## Standard output
```text
{
  "contract": "F02-001",
  "course_level": 2000,
  "pinned_linuxcnc": "8bf4605ae81042248add031e94c77300406e0413",
  "rows": 19,
  "retention": {
    "strict_monotonic_complete_seq": true,
    "rows": 19,
    "required_columns_present": true
  },
  "gates": {
    "A": true,
    "B": true,
    "C": true,
    "D": true,
    "E": true,
    "F": true,
    "G": true,
    "H": true,
    "I": true,
    "J": true
  },
  "prediction_match": true,
  "boundary": "deterministic ordinary-control policy only; not physical, network, machine-commissioning, or functional-safety evidence"
}
F02-001 PASS: compound-fault policy contract only; no physical-machine or functional-safety claim.
```

## Standard error
```text
```
