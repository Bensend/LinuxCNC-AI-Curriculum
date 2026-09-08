# Latest LinuxCNC Lab Result

- Job: `033-c05-scale-jump-concurrent-samplers`
- Job file: `lab-jobs/033-c05-scale-jump-concurrent-samplers.sh`
- Workflow run ID: `34252503889`
- Attempt: `1`
- Source commit: `5df6891c4c1b836d9813d58b6fb507ea6b8abaee`
- Exit code: `90`
- Finished UTC: `2026-09-08T16:40:39Z`

## Metadata
```text
LinuxCNC AI Curriculum Lab
UTC start: 2026-09-08T16:40:39Z
Repository commit: 5df6891c4c1b836d9813d58b6fb507ea6b8abaee
Workflow run: 34252503889 attempt 1
Job file: lab-jobs/033-c05-scale-jump-concurrent-samplers.sh
Runner: Linux runnervmejwal 6.17.0-1022-azure #22-Ubuntu SMP Mon Jul 27 17:24:03 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
Inner lab timeout: 70 minutes (job ceiling: 75 minutes)

UTC finish: 2026-09-08T16:40:39Z
```

## Standard output
```text
C05-029 redesigned attempt: two concurrent halsampler readers; frozen Gates A-H and behavioral values unchanged.
C05-029 attempt-3 correction=Python generator quoting only; split-sampler transport and frozen Gates A-H unchanged.
C05-029 attempt-2 correction=split sampler transport only; frozen Gates A-H unchanged.
base-harness-sha256=95f0c5bd344fa7552845dbf5a7de7a3207fed6eec0b754874251c05585cdd9e4
patched-generator-sha256=51f3ba20a0ddf200474c63a9e5351c05c85bb79f29585bfd7640d9354707dcf1
```

## Standard error
```text
HARNESS_INVALID: missing source harness /home/runner/work/_temp/c05-033/root/lab-jobs/028-c05-feedback-freeze.sh
```
