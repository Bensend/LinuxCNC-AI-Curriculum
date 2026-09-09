# E20 — adversarial exam (frozen before authoritative-result review)

Status: **FROZEN / UNGRADED**
Course level: 2000
Module: E20 — hm2_eth / HostMot2 watchdog recovery across versions
Points: 20 total, 2 points each

This exam is frozen before the independent authoritative E20-001 result is reviewed. Do not alter questions or scoring traps to fit that result.

## Q1 — Green transport is not machine authority (2)

A trace shows the current hm2_eth transaction is clean, `io_error` is clear, and the HostMot2 watchdog is no longer bitten. An integrator concludes that motion may therefore be re-enabled automatically. State whether the conclusion follows, identify the missing authority boundary, and name the additional evidence/state that must be considered before motion reauthorization.

## Q2 — Saturating history versus current error (2)

For a version using packet-error limit 10, increment 2, decrement 1, begin at level 0. Observe one failed transaction, then one clean transaction. Give the expected current-error state and level after each observation and explain why cumulative/history state and current transport state must not be conflated.

## Q3 — Threshold edge (2)

Starting from level 0 under consecutive transport failures with increment 2 and limit 10, on which failure does the modeled threshold become exceeded and `io_error` assert? Explain the exact edge and identify what evidence would distinguish `>= limit` from `> limit` behavior.

## Q4 — Misleading premise: watchdog reset proves output continuity (2)

Premise: “Once the HostMot2 watchdog is reset, all physical outputs necessarily resume the pre-fault commanded values in the same servo period, so a separate machine-state check is redundant.” Identify every unsupported part of this claim and distinguish source-confirmed watchdog behavior from hardware/timing claims that E20 does not establish.

## Q5 — Version-sensitive recovery (2)

You are handed an old deployment and a current v2.9.x deployment. Explain why you must not apply one generic hm2_eth recovery description to both. Identify the historical/current recovery distinction documented by E20 and give the source-inspection strategy you would use before modifying either system.

## Q6 — Failure-path call flow (2)

Trace the conceptual path from a bad Ethernet transaction through driver error accounting/escalation to machine motion remaining unauthorized. Separate: (a) transaction observation, (b) driver-level error/recovery, (c) watchdog/physical-I/O authority, and (d) machine-state revalidation. Explicitly state which transitions are not proven to be automatic consequences of the others.

## Q7 — Atomic evidence attack (2)

An experiment records packet-error level with one userspace command, watchdog state with another, and motion authorization with a third. All three values individually look plausible. Explain why this is insufficient for a same-cycle recovery claim and specify the minimum evidence arrangement needed to make the claim defensible.

## Q8 — Recorder-health trap (2)

A sampled trace has contiguous-looking retained rows but the producer reports overruns. May the trace be used to prove absence of a brief authorization pulse during recovery? Explain the evidence rule and what correction is required before making that negative claim.

## Q9 — Small design/configuration task (2)

Design a bounded recovery interlock for an integrator that must not reauthorize motion merely because transport becomes clean. Give the minimum state variables and transition conditions you would expose/use in HAL or a custom realtime component. The design must keep driver/board recovery distinct from independent machine revalidation and must fail closed on a new communication fault.

## Q10 — Scope and safety boundary (2)

List four claims that an authoritative pass of E20-001 may support and four stronger claims it must **not** be used to support. At least one excluded claim must concern functional safety, one exact physical Mesa-output timing, and one universal cross-version behavior.

## Scoring traps

A response cannot earn full credit if it:

- treats current clean transport as proof of machine-state validity;
- treats watchdog reset as proof of restored physical output semantics;
- generalizes v2.9.10 behavior to all LinuxCNC versions;
- uses workflow success instead of retained underlying evidence;
- accepts torn userspace observations for a same-cycle claim;
- ignores recorder overruns for an absence-of-event claim;
- claims E20 establishes functional safety;
- collapses driver/board reset and independent machine revalidation into one state.
