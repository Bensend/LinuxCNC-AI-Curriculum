# E20-004 — counterfactual and promotion test

Date: 2026-09-09
Status: completed after authoritative Gates A–J 10/10 and frozen adversarial exam 20/20; fresh-AI handoff remains separate.

## Counterfactual promotion test

Consider the strongest plausible reversals of E20's deferred uncertainties:

1. A particular Mesa board/firmware restores physical output-pin semantics after watchdog recovery differently or more slowly than expected.
2. A future LinuxCNC/hm2_eth version changes packet-error accumulation, saturation, decay, clear, or reset behavior.
3. A specific machine requires additional post-communication-fault revalidation beyond homing/reference/interlock state modeled by the integrator.
4. Real Ethernet failure/recovery timing is substantially different from the deterministic synthetic fixture.

If all four turned out differently, E20's central teaching would remain valid: **transport observation, driver recovery, watchdog/physical-I/O authority, machine-state validity, and motion authorization are separate authority domains unless source/hardware/system evidence explicitly proves a transition between them.**

Those reversals would change machine- or version-specific implementation details and could strengthen the required revalidation/interlock, but they would not justify collapsing the domains or treating clean transport as permission to move. Therefore these items may remain scoped/deferred without invalidating the 2000-level conclusion.

## Higher-level promotion decision

E20 does **not** justify a new 3000-series implementation module by itself.

Reasons:

1. The essential 2000-level mechanism and failure/recovery distinctions were resolved from pinned source plus an independently retained realtime experiment.
2. Exact Mesa physical output timing requires specific hardware/firmware instrumentation; it is valuable physical verification but is not needed to establish the software authority boundary taught here.
3. Designing a custom FPGA transport/recovery protocol would be architecture-specific and should be promoted only when a later real design demonstrates requirements unmet by existing HostMot2/Mesa behavior.
4. Functional-safety claims require a separate hazard/risk architecture, independence analysis, hardware evidence, and applicable validation process; LinuxCNC source/lab work alone cannot manufacture that assurance.
5. Historical/future source differences are best handled by explicit version pinning and source inspection, not by creating a universal recovery abstraction unsupported by evidence.

**Promotion result:** no automatic 3000 promotion. Keep exact physical Mesa watchdog-output restoration timing, hardware-specific Ethernet recovery characterization, and any custom FPGA recovery protocol as conditional advanced candidates only.

## Graduation sufficiency

E20 now has:

- source/version analysis;
- documentation/community pass;
- function/call-flow documentation;
- frozen predeclared experiment;
- valid non-authoritative preflight;
- independent authoritative retained-evidence pass, Gates A–J 10/10;
- frozen adversarial exam 20/20;
- no correction debt from experiment/exam;
- completed counterfactual/promotion review.

The sole remaining graduation requirement is the **fresh-AI handoff test with a novel scenario**. The current learner instance must not self-certify that information-separated requirement.

## Dependency consequence

E20 is **TECHNICALLY ACCEPTED / GRADUATION-PENDING FRESH-AI HANDOFF**. Downstream work must not describe it as fully graduated until that handoff passes. The handoff should specifically test whether a fresh learner resists the unsafe shortcut “communications recovered, therefore motion may automatically resume” while correctly separating current packet state, accumulated driver state, watchdog/physical-I/O authority, machine revalidation, and explicit reauthorization.
