# D01-003 — Three-attempt preflight reconciliation and harness redesign

Status: **ESSENTIAL NOW / REDESIGN**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Trigger

The first D01 duplicated-feedback preflight lineage reached three materially similar harness failures. Per `MASTER_MISSION.md`, another incremental retry is prohibited until the experiment is explicitly classified and redesigned.

The third run was workflow `34345951372`, job `102447454146`, artifact `10101854408` (`sha256:10e4d8f005a135fc4bc0894925f086c8404fb448c02627c8ad287838afbeae92`). The GitHub job ran from `2026-09-09T11:30:52Z` to `11:35:50Z`; the inner lab ran `11:30:55Z` to `11:35:43Z` and exited 1.

## What attempt 3 proved

This failure was not a D01 behavioral falsification.

The retained topology reached a valid real LinuxCNC fixture:

- pinned `motmod` and duplicated-coordinate `trivkins` started;
- `joint.1` remained on the stock principal-Y `Ypos` loopback;
- `joint.2` used the independent `sum2` feedback path;
- the duplicated joints had deterministic `0.05` settled following-error limits;
- `motion.motion-enabled` became TRUE;
- realtime order was `motion-command-handler -> motion-controller -> mux2 -> sum2 -> sampler`.

Thus the previous signal-ownership/readiness corrections were effective.

## Exact failure

The command driver emitted a rapid sequence through `linuxcncrsh`. The server returned `SET MDI NAK`; consequently `joint.1.motor-pos-cmd`, `joint.2.motor-pos-cmd`, and both feedback values stayed at zero. The preflight's settled-Y assertion therefore failed before fault injection.

Pinned upstream `tests/linuxcncrsh/test.sh` demonstrates a more defensive protocol: it explicitly checks errors/state around `SET MODE MDI`, prepares the machine, and uses wait behavior around commands. D01 does not test the remote-shell protocol, so continuing to debug that surface inside the D01 plant experiment would add irrelevant failure modes.

## Classification

**ESSENTIAL NOW.** D01's core 2000-level claim requires real-runtime verification because the source-only principal-joint Cartesian feedback rule is central to downstream coupled-control authority reasoning. Promotion would merely defer a core learning objective; DROP would leave the module without independent evidence.

## Material redesign before another run

The failed `012 -> 014` command-driver lineage is retired. The next preflight is a new harness cycle with these changes:

1. Use the built-in Python `linuxcnc.command()` / NML interface for state, homing and MDI motion. This is a normal LinuxCNC userspace command path and removes `linuxcncrsh` protocol timing from the experiment's causal surface.
2. Explicitly home the simulated joints before MDI even though the sample has `NO_FORCE_HOMING=1`; the fixture must prove its coordinate-mode state instead of assuming it.
3. Add an explicit realtime phase channel and require phase-before-offset samples for the low and high mutations.
4. Solve the frozen atomic Cartesian-feedback requirement in the same redesign. Add one minimal **test-only observer HAL pin** to `motmod`: the pin copies `emcmotStatus->carte_pos_fb.tran.y` immediately after `do_forward_kins()` has updated that value. Retain the exact source patch and prove no unrelated production changes.
5. Sample that observer in the same realtime `sampler` stream as both joint commands/feedback, following errors/limits/fault flags, duplicate offset, phase, and `motion.motion-enabled`.
6. Require producer `sampler.0.overruns == 0`, monotonic sample indices and empty collector stderr.
7. This redesigned run remains **non-authoritative**. It validates topology, numeric thresholds, ordering and observer integrity only. Frozen D01-002 Gates A–J remain unscored until a separate independent authoritative run.

## Observer perturbation boundary

The observer is instrumentation, not a control input. It exports a copy of already-computed Cartesian Y after forward kinematics and is never read by the motion controller. Any authoritative run must retain the patch and demonstrate that the added code is only the HAL export plus one copy operation at the publication point. The experiment still cannot claim physical geometry or safety truth from this software value.
