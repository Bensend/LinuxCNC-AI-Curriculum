# S02-006 — counterfactual and promotion test

Date: 2026-09-09
Status: completed after authoritative Gates A–J and frozen adversarial exam; fresh-AI handoff remains separate.

## Counterfactual

Suppose a production architecture actually supplied, for each feedback channel, a trustworthy bounded-age freshness assertion derived from independent acquisition hardware **and** a physically independent geometry reference capable of observing the common-mode fault classes relevant to the machine.

Under that counterfactual, S02's P3/P4 ambiguity would be reduced because the detector input set would no longer be restricted to equal encoder values plus board transport health. The new independent witness could distinguish some states that are observationally identical in the frozen S02 input set.

The important conclusion is not that common-mode faults are therefore solved universally. It is that observability is a property of the available evidence set and failure model. Adding a genuinely independent witness can remove a specific ambiguity; adding a derived software copy, another value from the same acquisition path, or a transport-health bit cannot.

## Promotion test

S02 exposes advanced implementation questions but does **not** currently justify promoting custom FPGA/driver/distributed-realtime work to the 3000 series.

Reasons:

1. The central 2000-level uncertainty—what LinuxCNC/HAL/HostMot2 evidence can and cannot establish about freshness, diversity and physical truth—was resolved using existing LinuxCNC source, documentation and a bounded synthetic realtime fixture.
2. A custom FPGA freshness/validity protocol would be architecture-specific. It should be promoted only if later machine requirements show that existing hardware cannot supply the necessary independent evidence with bounded timing.
3. Common-cause independence is not created merely by moving logic into an FPGA; shared sensor mechanics, power, connectors, acquisition silicon, firmware assumptions and references can remain common causes.
4. Functional-safety or risk-reduction claims would require a separate safety architecture/validation process, not a 3000-series LinuxCNC implementation exercise alone.

**Promotion result:** keep H30/custom FPGA-driver-distributed-realtime work as a **3000 candidate only**. Do not promote it based on S02.

## Dependency consequence

S02 can satisfy its technical evidence/exam/counterfactual requirements without opening a 3000 prerequisite. F02 remains blocked by the other declared 2000-level prerequisites (notably E20 and X02) even after S02 eventually graduates.

## Remaining S02 requirement

Do not mark S02 `GRADUATED` until a genuinely fresh-AI handoff evaluates a novel feedback-integrity scenario without access to a prepared solution and demonstrates the same authority boundaries. The current learner instance must not self-certify as “fresh.”
