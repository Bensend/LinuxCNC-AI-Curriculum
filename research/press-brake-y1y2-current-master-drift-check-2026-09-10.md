# Y1/Y2 source drift check against current LinuxCNC master — 2026-09-10

Purpose: determine whether the specific source assumptions used by the dependency-safe Y1/Y2 specialization preparation have already drifted since the pinned experimental revision.

Pinned curriculum comparison revision: `8bf4605ae81042248add031e94c77300406e0413`.

Current LinuxCNC `master` observed during this session: `e646ce0ad8b5f0c7024b25cad63537a0609a2787`, dated 2026-09-09T22:24:57Z.

## Exact blob comparison

The critical files checked below have **identical Git blob SHAs** at the pinned curriculum revision and current master:

| File | pinned blob SHA | current-master blob SHA | Result |
|---|---|---|---|
| `src/emc/kinematics/kins_util.c` | `c82a4a2fc9561be46ea91a5ebd2a05b72a59fb7f` | `c82a4a2fc9561be46ea91a5ebd2a05b72a59fb7f` | IDENTICAL |
| `src/emc/motion/control.c` | `2ddf587b484919057821c65f1d4a9392a6d69f06` | `2ddf587b484919057821c65f1d4a9392a6d69f06` | IDENTICAL |
| `src/emc/motion/motion.c` | `d2cb761595898d7d1e5e21fd87d3058f273c1084` | `d2cb761595898d7d1e5e21fd87d3058f273c1084` | IDENTICAL |
| `src/hal/components/pid.c` | `b35b11a81733d5d5852134b1c3e35cded7295134` | `b35b11a81733d5d5852134b1c3e35cded7295134` | IDENTICAL |

## Consequence

For these exact files, the source-level conclusions used by the current preparation have not drifted between `8bf4605...` and master `e646ce0...`:

- identity duplicate-coordinate mapping still fans one coordinate value to every mapped duplicate joint;
- forward identity mapping still derives Cartesian coordinate representation from the principal/first mapped joint rather than averaging duplicates;
- motion still owns independent per-joint feedback/following-error state and the same servo-controller ordering in the checked file;
- per-joint HAL command/feedback/enable pins remain exported by the same `motion.c` blob;
- stock PID per-instance state, output limiting and saturation ownership are unchanged in the checked `pid.c` blob.

Classification: **SOURCE-CONFIRMED / CURRENT-MASTER CROSS-CHECK** for exact code identity of these four files.

## Important limit

This is not permission to abandon pinned-version experiments. The surrounding build, other components, HAL examples, runtime environment, or future commits can differ even when these four blobs match. Any authoritative lab remains pinned to its declared source revision, and later current-version generalization still requires a fresh provenance check.

## Additional saturation observation

The unchanged `pid.c` source makes the post-PID insertion concern concrete: PID anti-windup uses its internal `limit_state`, which is set when **that PID's own computed output** reaches `maxoutput`; the exported `saturated` state comes from the same internal limit state. Therefore an external effort added after `pid.N.output`, followed by a different final actuator limiter, is outside the stock PID's saturation/anti-windup knowledge unless explicitly fed back through a custom design.

This strengthens Gate F/H of `experiments/PB-PREP-001-y1y2-insertion-comparison-plan.md`: both stock-PID saturation and final-command saturation must be retained separately in the post-PID architecture.
