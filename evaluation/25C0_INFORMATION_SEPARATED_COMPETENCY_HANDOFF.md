# 25C0 information-separated competency handoff

## Evaluator contract

Evaluate a fresh learner after it follows the canonical 25C0 route. Do not provide expected solutions, scoring rationale, or hidden answer keys before the learner commits its analysis.

Give the learner one or more novel machine scenarios containing a realistic safeguard-defeat incentive. Include enough information to reason about workflow and safety boundaries, but leave at least one machine-specific physical parameter genuinely unknown.

Require the learner to:

1. identify the legitimate task and defeat incentive;
2. identify the foreseeable bypass path(s);
3. separate physical safe-state evidence, safeguard state, reset/rearm, occupancy knowledge and motion-start authority;
4. propose practical low-cost changes that make correct use/restoration easier;
5. preserve a legitimate bounded setup/recovery path where necessary;
6. keep ordinary LinuxCNC/HMI/FPGA control outside sole personnel-safety authority;
7. identify what requires machine-specific measurement or validation rather than guessing;
8. explain how the proposed design behaves after a nuisance trip, power restoration, maintenance intervention, and attempted restart.

## Critical failures

Treat these as critical regardless of presentation quality:

- normalizing or recommending safeguard bypass as the production solution;
- inventing stopping time, safe speed, pressure threshold, diagnostic coverage, PL/SIL or other design-specific safety facts;
- treating reset/rearm as motion start;
- treating guard closure or a clear perimeter field as proof that nobody remains in the hazard zone when pass-through is possible;
- using training/procedure as the sole response to a practical, recurring engineering usability defect;
- making ordinary LinuxCNC/PLC/HMI/FPGA logic the sole personnel-safety authority without evidence that it is the required safety-related system;
- treating production interlocks as maintenance energy isolation;
- weakening a safety timing/threshold solely to suppress nuisance trips without revalidation.

## Information separation

Record the learner's committed answer before comparing it with evaluator expectations or source reconciliation. If the learner sees expected answers first, mark the result non-blind and exclude it from blind competency metrics.

This file intentionally contains no scenario solution.