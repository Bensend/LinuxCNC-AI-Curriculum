# C06-030 — Deterministic Transport Error vs Watchdog Bite

Status: FROZEN EXPERIMENT DESIGN — do not change behavioral gates after observing a run.

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Question
Can a hardware-free HostMot2 fixture demonstrate that low-level communication failure escalation and HostMot2 watchdog-bite state are distinct state machines with distinct HAL-visible evidence and recovery paths?

## Harness
Use pinned `hm2_test` as the low-level board because it is explicitly a hardware-free HostMot2 llio fixture. Apply only an auditable lab instrumentation patch to `hm2_test` so a test controller can deterministically:

1. cause one read transaction to fail without asserting the emulated watchdog status bit;
2. cause repeated read failures and set `llio->io_error` according to a frozen small test threshold implemented in the harness;
3. independently set the emulated watchdog status register bit 0 while transport reads succeed;
4. clear injected transport failure and watchdog status conditions.

Do not modify generic `hostmot2.c`, `tram.c`, or `watchdog.c` behavioral logic. If a usable watchdog-bearing `hm2_test` pattern is not already present at the pinned revision, the harness may add the minimum module-descriptor/register image needed to expose one watchdog, but that patch must be retained in the artifact and treated solely as fixture construction.

## Predeclared prediction
A transient failed read will suppress normal TRAM processing for that observation but will not by itself assert `watchdog.has_bit`. Repeated harness-injected low-level failures can assert `io_error` while `watchdog.has_bit` remains false. Separately, with successful transport and emulated watchdog status bit 0 set, the next valid read will cause `watchdog.has_bit=true` and `needs_reset=1` without requiring transport `io_error`. Clearing the watchdog pin permits the watchdog recovery path; clearing `io_error` alone is not evidence of a watchdog bite or safe physical restart.

This prediction is frozen before implementation and before viewing experiment output.

## Required retained evidence
Retain exact pinned checkout SHA, complete harness patch, build stdout/stderr, HAL configuration, raw same-cycle sampler trace, userspace controller log, final exit code, and artifact provenance. The raw trace must be copied before analysis can terminate.

Sample at least: phase, injected transient-fail command/state, injected repeated-fail command/state, injected watchdog-status command/state, `io_error`, `watchdog.has_bit`, an activity counter or sampled register proving normal TRAM observations resume, and any fixture-exposed reset/recovery state required to distinguish the branches. If internal `needs_reset` cannot be sampled without invasive generic-driver changes, verify it from SOURCE plus its externally observable recovery consequence rather than adding a learner-only production pin.

## Frozen phases

- P0 BASELINE: transport success, watchdog status clear.
- P1 TRANSIENT: inject exactly one failed read, then restore successful reads.
- P2 ESCALATED IO: inject consecutive failed reads until harness low-level `io_error` asserts; watchdog status remains clear.
- P3 IO RECOVERY: remove communication fault and clear `io_error`; demonstrate normal read/write activity resumes without a watchdog `has_bit` event.
- P4 WATCHDOG BITE: transport remains successful; set emulated watchdog status bit 0 and allow a valid HostMot2 read to process it.
- P5 WATCHDOG HOLD: verify `watchdog.has_bit` remains asserted until explicitly cleared and recovery write is withheld while it is asserted.
- P6 WATCHDOG RECOVERY: clear `watchdog.has_bit`, keep transport healthy, and demonstrate recovery/normal service resumes.

## Frozen Gates A–H

### Gate A — provenance/topology
Exact pinned SHA and retained patch are present. Generic `hostmot2.c`, `tram.c`, and `watchdog.c` must match the pinned revision byte-for-byte. One HostMot2 watchdog instance must be proven present in the fixture.

### Gate B — evidence integrity
Raw realtime observation is retained even if analysis fails. Samples are strictly ordered with no hidden deletion/relabeling. Any sampler overrun or missing decisive phase makes the run HARNESS INVALID.

### Gate C — baseline separation
During P0, `io_error=false`, `watchdog.has_bit=false`, and normal HostMot2 read/write activity is observed.

### Gate D — transient is not watchdog
P1 must contain at least one injected failed read followed by recovered successful reads while `watchdog.has_bit` remains false throughout P1. A transient failure must not be labeled an accepted watchdog bite.

### Gate E — escalated communication fault is distinct
P2 must reach `io_error=true` after consecutive injected communication failures while the emulated watchdog status bit remains clear and sampled `watchdog.has_bit=false`. Once `io_error` is true, generic HostMot2 read/write service must stop advancing the normal activity evidence until user/test recovery action.

### Gate F — communication recovery
In P3, after removing the fault and clearing `io_error`, normal activity must resume and `watchdog.has_bit` must remain false. No inference of physical safety is permitted.

### Gate G — watchdog bite with healthy transport
In P4, with communication injection disabled and `io_error=false`, setting the emulated watchdog status bit must be followed by a valid read that asserts `watchdog.has_bit=true`. During P5 the has-bit state must remain asserted until explicitly cleared, and normal watchdog recovery must not be claimed while it remains asserted.

### Gate H — watchdog recovery and boundary
After explicit has-bit clear in P6 with healthy transport, HostMot2 must resume normal service/recovery behavior and the fixture watchdog status must clear or be rewritten consistently with pinned source. The result narrative must explicitly retain: `transport recovery != watchdog recovery != proof of physical safe state`.

## Classification rules
Any failure caused by build, fixture module-descriptor construction, sampling, phase publication, or evidence-retention defects is HARNESS INVALID and cannot falsify the prediction. A valid run that violates a frozen behavioral gate is behavioral evidence and must not be retuned post hoc.
