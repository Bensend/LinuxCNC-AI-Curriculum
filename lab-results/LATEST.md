# Latest LinuxCNC Lab Result

- Job: `072-pb-prep-001-p2-p7-render-validated-nettap-fix`
- Job file: `lab-jobs/072-pb-prep-001-p2-p7-render-validated-nettap-fix.sh`
- Workflow run ID: `34554444939`
- Attempt: `1`
- Source commit: `d7f937183bc03b668751e2dbd455e25a4829aba8`
- Exit code: `1`
- Finished UTC: `2026-09-11T02:23:46Z`

## Metadata
```text
LinuxCNC AI Curriculum Lab
UTC start: 2026-09-11T02:23:46Z
Repository commit: d7f937183bc03b668751e2dbd455e25a4829aba8
Workflow run: 34554444939 attempt 1
Job file: lab-jobs/072-pb-prep-001-p2-p7-render-validated-nettap-fix.sh
Runner: Linux runnervmlun5p 6.17.0-1022-azure #22-Ubuntu SMP Mon Jul 27 17:24:03 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
Inner lab timeout: 70 minutes (job ceiling: 75 minutes)

UTC finish: 2026-09-11T02:23:46Z
```

## Standard output
```text
PB-PREP-001 072: sampler taps now reuse existing HAL signals; frozen behavioral contract unchanged.
```

## Standard error
```text
HARNESS_INVALID: expected one packed sampler tap 'net sr1 y1cmd => sampler.0.pin.2', found 2
```
