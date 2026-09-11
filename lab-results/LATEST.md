# Latest LinuxCNC Lab Result

- Job: `079-pb-prep-002-abstract-process-state`
- Job file: `lab-jobs/079-pb-prep-002-abstract-process-state.sh`
- Workflow run ID: `34626267634`
- Attempt: `1`
- Source commit: `214e0b7218b5848d19027aa935f8b2bdf6340331`
- Exit code: `0`
- Finished UTC: `2026-09-11T17:11:28Z`

## Metadata
```text
LinuxCNC AI Curriculum Lab
UTC start: 2026-09-11T17:11:28Z
Repository commit: 214e0b7218b5848d19027aa935f8b2bdf6340331
Workflow run: 34626267634 attempt 1
Job file: lab-jobs/079-pb-prep-002-abstract-process-state.sh
Runner: Linux runnervmlun5p 6.17.0-1022-azure #22-Ubuntu SMP Mon Jul 27 17:24:03 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
Inner lab timeout: 70 minutes (job ceiling: 75 minutes)

UTC finish: 2026-09-11T17:11:28Z
```

## Standard output
```text
{
  "contract": "PB-PREP-002",
  "dt_seconds": 0.01,
  "timeout_seconds": 0.05,
  "rows": 38,
  "faults": {
    "P1": [
      "AUTHORIZATION_LOST",
      "PROCESS_C"
    ],
    "P2": [
      "PROCESS_TIMEOUT",
      "PROCESS_A"
    ],
    "P3": [
      "INTERMEDIATE_NOT_FOLLOWING",
      "PROCESS_A"
    ],
    "P4": [
      "COORDINATION_INVALID",
      "PROCESS_B"
    ],
    "P5": [
      "IO_INVALID",
      "RETURN"
    ]
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
  "boundary": "simulation-only ordinary-control semantics; NOT functional safety or machine commissioning evidence"
}
PB-PREP-002 PASS: frozen abstract ownership/state contract only; no physical hydraulic behavior modeled.
```

## Standard error
```text
```
