# C01-023 accepted result — realtime same-cycle duplicated-joint observation

## Disposition

**PASS / TEST-CONFIRMED for the frozen C01-023 Gates A-H.**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Authoritative behavioral evidence is the workflow artifact, not the workflow envelope conclusion:

- workflow run: `34209185893`
- job: `102005842122`
- artifact: `10049218375`
- source curriculum commit: `5b2309fb33e0a39b56f1cb7ea61b113cfacd95ae`
- inner lab exit code: `0`
- inner lab UTC: `2026-09-08T09:17:39Z`–`2026-09-08T09:22:15Z`

The GitHub workflow envelope is red because the later "Commit readable results back to repository" step raced with concurrent curriculum documentation commits. The published artifact independently preserves `LATEST.exit_code.txt = 0`, metadata, stdout/stderr, and the complete realtime trace. Therefore the workflow envelope is not used as the behavioral oracle.

## Frozen-gate reconciliation

### Gate A — pinned provenance: PASS

The lab reported:

```text
checked-out-commit=8bf4605ae81042248add031e94c77300406e0413
gate-A=PASS
```

The LinuxCNC executable, Python `linuxcnc` module, Python `hal` module, and `halsampler` executable were all verified as coming from the pinned Run-In-Place build tree.

### Gate B — four-joint homed fixture: PASS

```text
runtime-joint-count=4
homed-vector=1,1,1,1
gate-B=PASS
```

### Gate C — separate joint interfaces and sampler endpoints: PASS

The runtime independently exposed joint 1 and joint 3 command/feedback HAL endpoints and the configured sampler endpoints. The endpoint-existence check is intentionally separate from the simultaneous equality oracle.

### Gate D — meaningful coordinated motion: PASS

A 5-inch world-Y move at F60 was observed. The status trace entered not-in-position and later completed at the target. Realtime capture showed:

```text
realtime-j1-command-span=5
realtime-j3-command-span=5
gate-D=PASS
```

Thus a static zero-equals-zero result cannot satisfy the comparison.

### Gate E — duplicated commands match in the same realtime observation: PASS

`sampler.0` ran after `motion-controller` in the same servo thread and captured joint 1 and joint 3 command signals in each single FIFO row.

```text
realtime-samples=5798
realtime-sample-first=0 last=5797
sampler-overruns=0
max-abs-j1-j3-command-diff=0
gate-E=PASS
```

The frozen threshold remained `1e-9`; it was not weakened after attempt 1. Same-cycle maximum difference was exactly zero.

### Gate F — declared ideal loopback behaves as wired: PASS

```text
max-abs-j1-command-feedback-loopback-diff=0
max-abs-j3-command-feedback-loopback-diff=0
gate-F=PASS
```

This is evidence for the declared simulation topology only. Each command/feedback pair shares a HAL signal; this is not independent plant feedback.

### Gate G — direct joint-3 evidence, no world-coordinate substitution: PASS

```text
joint3-proof-source=direct realtime sampler capture of joint.3 HAL signal
world-y-alone-used-as-joint3-proof=NO
gate-G=PASS
```

### Gate H — cleanup: PASS

The runtime was shut down and the lab verified that the TCP endpoint and joint HAL namespace did not remain. `gate-H=PASS` was emitted before the overall PASS.

## Attempt-1 correction validated

Attempt 1's apparent 0.001-inch divergence was a torn sequential-userspace observation. At 1 in/s with a 1 ms servo period, that difference is exactly one servo tick. The corrected same-cycle realtime capture measured zero duplicated-command divergence for 5,798 consecutive samples with zero FIFO overruns. This validates the correction without moving the behavioral goalposts.

## What C01-023 establishes

At the pinned revision and tested fixture:

1. `trivkins coordinates=XYZY kinstype=BOTH` supports four joints with duplicated world Y.
2. A coordinated world-Y command fans out to distinct joint 1 and joint 3 command interfaces.
3. In same-servo-cycle realtime samples during a nontrivial move, those duplicated software commands were identical.
4. Distinct joint HAL interfaces remain observable even though the coordinated command is shared.

## What it does not establish

This experiment does **not** prove:

- two physical actuators remain aligned;
- two independent encoders agree or are fresh;
- a hydraulic pair shares load/pressure correctly;
- following-error or anti-racking logic is sufficient;
- duplicated-coordinate kinematics is a functional-safety mechanism.

Those are explicitly downstream C02/C03 and hardware-level concerns.
