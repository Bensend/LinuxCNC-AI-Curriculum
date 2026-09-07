# Curriculum checkpoint — S05 graduated / S06 source active

- Checkpoint UTC: `2026-09-07T16:16:07Z`
- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Durable state

S05 is GRADUATED at 1000 level. Authoritative workflow `34137614386` exited 0 and all frozen Gates A–J passed. Accepted result, adversarial exam/answer key, fresh-AI handoff, promotion audit, and updated `PROGRESS.md` are committed.

S06 — fault injection framework is active in RESEARCH / SOURCE. `guides/S06-fault-injection-framework-research.md` defines the initial layer taxonomy and experiment contract and inventories accepted S03–S05 injection patterns.

## Exact next work

1. Inspect pinned `streamer` / `sampler` implementation and repository `.github/workflows/lab-runner.yml` plus any helper scripts that preserve artifacts.
2. Define a machine-readable result schema that separates: injection evidence, subsystem-response oracle, healthy/adversarial controls, realtime ordering, recovery, harness-invalid criteria, raw trace, exit code, metadata, and explicit non-claims.
3. Decide stock-only versus tiny test-only realtime sequence+counter source. Reject any design where userspace scheduler timing becomes the hidden oracle for a freshness claim.
4. Freeze `experiments/S06-016-...-plan.md` before implementation with healthy baseline, stuck/frozen value, single-cycle jump, deterministic age/skew, recovery, and an explicit circular-oracle rejection case.
5. Implement/run only after the plan is frozen; apply the three-attempt safeguard and keep injection-layer claims bounded.

## Important boundary

Do not claim that a HAL-level injected freeze/jump demonstrates a physical sensor, network, FPGA, drive, or safety-rated fault. The framework must keep injected layer and evidenced layer explicit.