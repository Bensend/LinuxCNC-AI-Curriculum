# 25B0 — Quantitative boundaries, latent faults, and proof-test reasoning

## Purpose

Failure analysis becomes misleading when a precise-looking number is calculated from guessed inputs. This note defines when FMEDA/DC/PFH-style arithmetic is evidence-bearing and when the correct engineering result is qualitative fault analysis plus an explicit UNKNOWN.

## Evidence boundary

### Quantitative arithmetic is justified only when its inputs are defensible

For a subsystem calculation, identify the architecture and the failure model before calculating. Inputs may include manufacturer/sourced dangerous-failure or B10d data, realistic operating cycles, diagnostic test interval, proof-test interval/service life, diagnostic effectiveness for the particular failure modes, and common-cause assumptions appropriate to the architecture.

Siemens' 2023 contactor safety application guide is a useful concrete example: it derives dangerous failure rate from B10d and actual operations per hour, uses T2 as diagnostic test interval, uses T1 as the minimum of proof-test interval and service life, and carries a beta/common-cause term in redundant architecture calculations. It also warns that architectural constraints still apply; a probability number alone does not establish the achieved SIL.

Evidence class: **DOC-CONFIRMED** for the documented calculation relationships; application values remain **UNKNOWN** until sourced for the actual design.

### Diagnostic coverage is not a count of tests

ISO 13849 guidance defines DC as effectiveness of diagnostics in terms of the rate of detected dangerous failures relative to the total dangerous-failure rate. Therefore `7 of 10 injected faults detected = 70% DC` is invalid unless those ten injections validly represent and weight the dangerous failure population. A fault-injection campaign can demonstrate particular diagnostic mechanisms; it does not automatically estimate DCavg.

Evidence class: **DOC-CONFIRMED** for the definition; **INFERENCE** for the consequence that an unweighted hand-selected campaign cannot establish DCavg.

Freeze: **PERCENT OF TEST CASES DETECTED != DIAGNOSTIC COVERAGE.**

### Missing quantitative inputs is a stopping condition, not permission to guess

If a homebuilt interface has no defensible failure-rate distribution, no diagnostic-effectiveness basis, or no justified common-cause model, preserve the qualitative findings: single-point dangerous failures, latent failures, diagnostic paths, dependencies, safe-state consequences, and validation tests. Mark the unavailable quantitative claim UNKNOWN. The qualitative result can still justify obvious architectural improvements without manufacturing a PL/SIL number.

Freeze: **QUALITATIVE FAULT ANALYSIS CAN JUSTIFY REDESIGN WITHOUT JUSTIFYING A PL/SIL CLAIM.**

## Proof tests and latent faults

A proof test exists to reveal dangerous faults or degradation not found by automatic diagnostics. Siemens' IEC 62061 training material describes the proof-test interval as the interval between manual tests intended to detect dangerous faults not detected automatically, after which the safety system/subsystem is tested and restored to an as-new condition. Its example also shows T1 entering PFHd reasoning as the minimum of service life and proof-test interval for relevant architectures.

This creates an important distinction:

- **diagnostic test interval T2** — how frequently the automatic/online diagnostic mechanism challenges or observes a fault;
- **proof-test interval T1-related assumption** — how long an otherwise latent dangerous condition may remain before a manual test/restoration opportunity, subject to the method and component assumptions;
- **maintenance/inspection interval** — an application schedule that may include activities not equivalent to the assumed proof test.

Freeze: **ROUTINE MAINTENANCE != PROOF TEST UNLESS IT ACTUALLY DETECTS THE ASSUMED LATENT FAILURES.**

Freeze: **PROOF TEST PERFORMED != ALL DANGEROUS FAILURES DETECTED.** Proof-test effectiveness is bounded by the actual test procedure and failure modes it can reveal.

Freeze: **LONGER PROOF-TEST INTERVAL != FREE OPERATING-LIFE EXTENSION.** Where the reliability method depends on the interval, changing it changes the quantitative evidence and may require recalculation/revalidation.

## Latent-fault reasoning without invented rates

Even when rates are unavailable, interval reasoning remains useful qualitatively. Suppose channel A can fail dangerously without automatic detection while channel B still stops the machine. The first fault is latent. Until a test capable of exposing A is performed, the architecture operates with reduced redundancy. A later independent B failure or a common-cause event may then defeat the safety function.

Without sourced rates, do **not** calculate the probability of that sequence. Instead document:

1. which first fault can remain latent;
2. what automatic diagnostic, if any, detects it;
3. which manual proof test can reveal it;
4. what evidence defines the allowed test interval;
5. what operation is permitted after a detected fault;
6. which second fault or CCF becomes hazardous while the first remains present.

If item 4 lacks authoritative design/manufacturer/risk evidence, the interval is **UNKNOWN**. Do not invent one.

## Worked qualitative example — redundant contactors

K1 and K2 are series final elements. K1's main contacts weld. If correctly designed EDM detects K1's failure to return and prevents reset/restart, the first fault is diagnosed before another demand. If the auxiliary feedback does not truthfully represent the relevant mechanical state, K1 can remain latent while K2 alone carries the stop function.

The engineering question is not merely `did the motor stop?`; it is `did the first dangerous failure become known soon enough, and did the architecture prevent operation in the degraded state as required?`

A numeric PFHd/PL/SIL claim additionally needs the reliability, diagnostic and CCF inputs required by the selected method. This example deliberately supplies none.

## Compute decision

No executable compute is justified by these questions. The unresolved quantities are evidence inputs, not arithmetic difficulty. Simulation cannot manufacture missing B10d/failure-rate, diagnostic-effectiveness, proof-test-effectiveness, CCF, or application interval evidence.

## Sources

- Siemens, *Contactors in safety applications*, Entry-ID 109807687, V1.1, 07/2023 — B10d/operation-rate relationship, T1/T2 and beta/CCF treatment, architectural constraints.
- Siemens, *SIMATIC Safety Integrated / IEC 62061 Basics*, AS-FE-013 — proof-test purpose and interval concept.
- Pilz, EN ISO 13849 guidance (current web guidance) — Category, MTTFd, DC and CCF as distinct inputs; DC defined through detected versus total dangerous failure rate.

## Provenance

Claims above are DOC-CONFIRMED where explicitly attributed to manufacturer/standards guidance, INFERENCE where an engineering consequence is derived from those definitions, and UNKNOWN for application-specific numerical inputs not supplied by evidence.
