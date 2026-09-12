# Press-brake backgauge — atomic `at position` witness source trace

Date: 2026-09-12
Course context: dependency-safe 3600 preparation while the F02 fresh-AI transfer remains externally information-separated
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Question

After PB-BG-002 and the homing/reference trace, determine which LinuxCNC realtime witnesses are actually available to construct a production extra-joint backgauge `at position` indication, and identify what LinuxCNC does *not* provide for the application.

## Pinned-source findings

`src/emc/motion/motion.c::export_joint()` exports, for each joint, `joint.N.pos-cmd`, `joint.N.pos-fb`, `joint.N.motor-pos-cmd`, `joint.N.motor-pos-fb`, `joint.N.vel-cmd`, `joint.N.f-error`, `joint.N.f-error-lim`, `joint.N.free-pos-cmd`, `joint.N.free-vel-lim`, `joint.N.free-tp-enable`, `joint.N.in-position`, hard-limit states, `joint.N.error`, `joint.N.f-errored`, and `joint.N.faulted`. `export_extrajoint()` separately exports the application-owned `joint.N.posthome-cmd` input.

`src/emc/motion/homing.c::base_make_joint_home_pins()` exports `joint.N.homing`, `joint.N.homed`, `joint.N.home-state`, the home switch input and index-enable. Therefore reference validity is directly observable at realtime/HAL level rather than needing a GUI-derived approximation.

The free planner's `in-position` state is useful but narrower than the production semantic needed here. `control.c` explicitly clears the joint in-position flag while the free trajectory planner is active. It therefore witnesses planner activity/completion, not by itself target provenance, feedback truth, drive health, or command-episode identity.

For an extra joint, the post-home application target enters motion through `joint.N.posthome-cmd`; the prior source trace established that `control.c` uses it as `motor-pos-cmd` only when the extra joint is homed. LinuxCNC exposes the numeric target and resulting command/feedback states, but there is no native generation/episode ID attached to `posthome-cmd`.

## Call-flow / ownership consequence

A production HMI can observe this realtime chain:

`application target -> joint.N.posthome-cmd -> [homed gate in motion] -> motor-pos-cmd -> drive/plant -> motor-pos-fb -> joint.N.pos-fb / f-error / fault flags`

with planner/reference witnesses alongside it:

`joint.N.homed + joint.N.free-tp-enable + joint.N.in-position + joint.N.vel-cmd`

These are sufficient to build a bounded *state* completion predicate, but not sufficient to prove that a numerically matching completion belongs to the newest application request. Numeric equality is ambiguous when two episodes command the same position or when a stale target survives a fault/reference cycle.

## Required application-owned episode witness

The backgauge application should own a monotonically advancing command episode/generation value. Increment it when a typed/program target is newly authorized. On any event that invalidates authority or reference (for example homed loss, drive/feedback/stall fault, authorization loss, reconciliation-required transition), invalidate the active episode rather than allowing a retained numeric target to regain completion status automatically.

`at_position` may then be asserted only for the currently authorized episode when all of these are true in one coherent observation:

1. `joint.N.homed` is true and application reference validity has not been invalidated;
2. active episode is valid and still owns the current target;
3. planner is no longer active (`free-tp-enable` false / appropriate planner-completion witness) and commanded velocity is settled according to commissioned policy;
4. commanded/feedback position agrees with the active episode target within commissioned tolerance;
5. `joint.N.error`, `joint.N.f-errored`, `joint.N.faulted`, applicable hard/soft limits, and application drive/feedback/stall faults are clear;
6. the sampled episode ID equals the episode ID whose target is being compared.

The episode ID is deliberately application-owned because pinned LinuxCNC provides no posthome-command generation token.

## Adversarial analysis

- **Same numeric target twice:** position equality cannot distinguish old completion from the new request. Episode identity can.
- **Reference lost then regained while target remains unchanged:** `homed` can become true again, but the pre-loss episode remains invalid; explicit reconciliation/new authorization is required.
- **Planner idle at the wrong position:** `in-position`/idle alone is insufficient; compare current feedback and command to the active episode target.
- **Feedback frozen at the requested number:** numeric agreement plus planner idle is still insufficient when independent feedback-validity/stall supervision reports a fault.
- **Drive fault after apparent completion:** completion must revoke with fault/authorization state; it is not a sticky success latch.
- **GUI polling misses a transient invalidation:** derive/latch episode invalidation on the control/HAL side or preserve diagnostic history; a slower GUI must not recreate authority from the latest visually healthy snapshot.

## Experiment decision

No motor/plant simulation is justified. Pinned source resolves the available LinuxCNC witness inventory and exposes the one real integration gap: command-episode identity is not native to `posthome-cmd`.

A small deterministic integration experiment is justified later only to test the application-owned episode latch and coherent `at_position` predicate across stale-target replay, same-target reissue, reference loss/regain, and feedback/drive fault revocation. Such a lab should test state/ownership logic, not motor physics.

## Claims boundary

This establishes a software/HAL integration contract. It does not establish encoder physical truth, commissioned tolerance/settle values, switch repeatability, drive diagnostic coverage, stopping distance, or functional-safety performance.

## Precise next checkpoint

Critical path remains the genuinely information-separated F02 transfer. While waiting, the next dependency-safe 3600 step is to freeze the smallest PB-BG-003 state/ownership experiment around an application-owned episode ID and atomic completion predicate, using the source-confirmed HAL witnesses above. Do not add motor physics or machine-specific numeric tolerances.
