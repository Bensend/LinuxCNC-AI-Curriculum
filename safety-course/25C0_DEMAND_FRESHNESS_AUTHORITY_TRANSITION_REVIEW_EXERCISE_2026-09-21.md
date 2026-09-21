# 25C0 exercise — demand freshness across authority transitions

## Scenario
A machine has Program, Operator, Maintenance and Hand command sources. During automatic production, Program demand is ON. A technician switches the machine to Hand for an adjustment. The field device is manually driven to a running/energized state. The controller object tracks actual device state to support bumpless transfer. The technician then clears the work area and releases Hand back to Program.

The independent safety system is healthy and its restart conditions have been satisfied.

The integrator argues: "Hand was a different command source, so returning to Program is effectively a fresh command. We do not need another Cycle Start."

## Tasks

1. Decide whether the argument is source-supported.
2. Separate command-source authority, retained/tracked demand, safety readiness, and fresh production start.
3. Identify the questions that must be answered in the machine state-machine contract before release-to-Program can be considered safe from unexpected ordinary-control restart.
4. Explain when bumpless transfer is desirable and why it still does not prove demand freshness.
5. Propose an operator-facing implementation that makes the safer path easier than relying on remembered mode history.

## Required reasoning

A correct answer must reject the inference that source transfer itself creates a fresh demand. Rockwell documents Hand-mode state tracking for bumpless transfer and documents retained/tracked settings across command-source changes. Higher-priority source selection can suppress another source without proving that source's latent settings/demand have been erased.

The design review must explicitly classify each production request as appropriate: edge, level, latched, queued, cancelled, tracked, or regenerated. It must state what service/maintenance/hand/override entry does to the request and what exit does.

For hazardous machinery, a strong ordinary-control pattern is to set `fresh_start_required` when entering exceptional authority and require a deliberate new production request after cleanup. Safety reset/rearm can make motion eligible but must not manufacture that new production request.

## Adversarial variants

### Variant A — device stopped in Hand
The technician leaves the field device stopped before releasing Hand. Do not infer that this proves Program demand was cleared. The state may have been tracked for bumpless transfer or Program demand may remain latent depending on the object/configuration.

### Variant B — controller object was disabled, not merely put in Hand
The instruction was actually disabled/scanned false during service. Some PlantPAx objects document Program/Operator commands being ignored and cleared in this condition. The learner must recognize that this is different evidence from a command-source transition and must not generalize it to all mode changes.

### Variant C — safety reset occurs last
After ordinary cleanup, the safety reset is the final action. The machine immediately starts because Program demand remained high. Even if the safety function behaved exactly as designed, the overall human-factors design is defective if reset was reasonably understood as restoring readiness rather than commanding production. Fix ordinary demand freshness; do not move production-start semantics into the safety controller.

## Review checklist extracted from the exercise

For every authority/mode transition that can occur around maintenance, setup or recovery, document:

- outgoing authority;
- incoming authority;
- physical output behavior during transition;
- whether commands/settings are retained or tracked;
- whether queued/latched requests survive;
- whether automatic demand is invalidated;
- what event establishes fresh demand;
- whether reset/rearm is separate from start;
- HMI indication of `fresh_start_required`;
- behavior after power cycle/reboot;
- behavior after fault clear;
- test evidence for the actual machine implementation.

Unknown semantics block claims of automatic safe restart. They do not justify guessing.
