# 2550 — Category B through 4 coverage audit and gap fill

## Why this artifact exists

The 2550 source-prep and architecture exercises correctly separated PLr, Category, MTTFd, DCavg, CCF, subsystem decomposition and validation, but the learner route did not yet give Categories B/1/2/3/4 enough explicit treatment. This file fills only that gap.

## Evidence boundary

Current-edition orientation remains ISO 13849-1:2023. Pilz's current overview states that subsystem PL determination requires Category, MTTFd, DC and CCF, and notes that the 2023 revision clarified Category 2, CCF, SRS and validation. IFA/SISTEMA material likewise treats designated architecture, Category, CCF, MTTFd and DCavg as separate model inputs.

Older IFA Report 2/2017e and SISTEMA Cookbook 4 remain useful explanatory evidence for the architecture concepts, but they are not silently treated as the 2023 normative text. Where the 2023 edition changed details, the current edition controls.

## Category is fault-behavior structure, not a PL label

A category answers structural questions such as: how many functional paths exist, what happens when a dangerous fault occurs, whether faults are detected, and whether the safety function can be lost before detection. It does not by itself answer the required PLr, component reliability, complete diagnostic effectiveness, CCF sufficiency, systematic correctness, or machine validation.

### Category B — basic safety-related control principles

Learner mental model: a basic single-channel structure whose safety function can be lost by a dangerous fault. The lesson is not that Category B is 'unsafe'; it is that its architecture does not provide the fault tolerance/diagnostic behavior of the higher categories.

Do not infer a PL from the letter B alone.

### Category 1 — reliability emphasis, still essentially single-channel

Learner mental model: Category 1 strengthens the single-channel approach through well-tried components and well-tried safety principles. The key contrast with Categories 3/4 is that reliability improvement is not the same thing as redundancy or continued safety-function availability after a dangerous single fault.

**Freeze:** HIGHER COMPONENT RELIABILITY != FAULT-TOLERANT ARCHITECTURE.

### Category 2 — tested single-channel architecture

Learner mental model: Category 2 adds checking/diagnostic structure to a primarily single-channel functional path. The safety value depends on meaningful testing, test-channel integrity and the relationship between test opportunity and safety-function demand. IFA's SISTEMA Cookbook specifically warns that infrequent testing can make a Category-2 architecture deceptively weak because a dangerous failure can exist when the next demand arrives.

This is the category most likely to be misunderstood as 'two channels because there is a test channel.' The test path is not automatically a redundant safety-function path.

**Freeze:** TEST CHANNEL != SECOND INDEPENDENT SAFETY-FUNCTION CHANNEL.

### Category 3 — redundant/fault-tolerant intent with diagnostics, but faults may accumulate

Learner mental model: the architecture is arranged so a single fault does not lead to loss of the safety function, with diagnostic coverage appropriate to the design. Not every fault must be detected immediately; undetected faults can accumulate. Therefore Category 3 reasoning must explicitly inspect dependencies, common final elements, CCF, diagnostic blind spots and combinations of faults.

**Freeze:** TWO DRAWN CHANNELS != CATEGORY 3 IF ONE COMMON DANGEROUS FAILURE DEFEATS BOTH.

### Category 4 — high fault tolerance plus strong diagnostic behavior

Learner mental model: retain the single-fault tolerance expectation while also achieving stronger diagnostic behavior so accumulated faults do not silently defeat the safety function under the category's requirements. This is not 'Category 3 with one more relay,' and it still requires reliability, CCF, systematic and application evidence.

**Freeze:** CATEGORY 4 != PL e BY DEFINITION.

## Cross-category comparison questions

For any proposed subsystem, the learner must answer:

1. What dangerous fault can defeat the safety function?
2. Is there one functional path, a tested path, or genuinely redundant paths?
3. What fault is detected, by what diagnostic, and when?
4. Can the safety function be lost between tests or before detection?
5. What happens after the first fault?
6. Can a second/accumulated fault defeat the function?
7. Which dependencies can defeat nominal redundancy together?
8. Are reliability and use-profile assumptions defensible?
9. Does the architecture actually match the designated architecture being claimed?
10. What remains to be validated on the physical machine?

## Coverage audit against the 2550 syllabus

- PLr: covered in source prep; belongs to risk/SRS, not architecture.
- PL a–e: covered as achieved performance/integrity result and comparison to PLr; must not be reduced to a category lookup.
- Categories B/1/2/3/4: **gap found and filled here** with explicit fault-behavior distinctions.
- MTTFd: covered in source prep and architecture exercises; application/use assumptions remain mandatory.
- DC/DCavg: covered; diagnostic evidence is not physical safe-state proof.
- CCF: covered with shared-final-element and shared-dependency traps.
- subsystem decomposition: covered; certified subsystem capability does not become complete-function integrity automatically.
- B10d/cycle reasoning: covered symbolically with nop sensitivity; no invented machine duty.
- systematic correctness: covered as a separate non-numerical obligation; 2023 edition adds/clarifies systematic/software/EMC considerations.
- validation limits: covered repeatedly; SISTEMA/model success is not machine validation.

## Release conclusion

After this gap fill, the 2550 learner-facing coverage is coherent enough for a concise entry map and an information-separated external competency gate. No additional generic ISO 13849 note is justified before that handoff.

## Evidence classification

- Current 2023 revision themes, subsystem PL inputs, SRS/validation/systematic emphasis: `DOC-CONFIRMED` from current Pilz ISO 13849-1 guidance and DGUV/IFA orientation.
- Category-2 test-rate intuition and designated-architecture teaching detail: `DOC-CONFIRMED` from IFA SISTEMA Cookbook/Report explanatory material, with edition boundary explicitly preserved.
- Category learner mental models above: `INFERENCE` constrained by those documented architecture properties; not a substitute for the normative standard text.
- Any machine-specific achieved Category/PL/MTTFd/DCavg/CCF result: `UNKNOWN` until its design and evidence are supplied.
