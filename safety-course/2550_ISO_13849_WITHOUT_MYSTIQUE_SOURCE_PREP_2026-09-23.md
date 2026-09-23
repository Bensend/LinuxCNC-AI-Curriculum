# 2550 — ISO 13849 without the mystique — source preparation

## Purpose

Teach ISO 13849 as a disciplined method for evaluating a defined safety function, not as a ritual for obtaining a PL letter from a diagram or software tool.

This module inherits the 2520 rule:

`hazard -> safety function/SRS -> required target -> subsystem architecture/reliability/diagnostics/CCF/systematic controls -> achieved integrity evidence -> validation`

2540 contributes the physical reminder that component data and diagnostic witnesses remain bounded to the propositions they actually support.

## Current-edition orientation

**DOC-CONFIRMED:** DGUV/IFA reports that the fourth edition of ISO 13849-1 appeared after extensive revision at the end of 2023 and that SISTEMA is being updated for EN ISO 13849-1:2023. IFA identifies Category, CCF, MTTFd and DCavg among the inputs used to evaluate safety-related controls and calculate achieved PL.

Sources:
- https://www.dguv.de/ifa/forschung/projektverzeichnis/ifa5176.jsp
- https://www.dguv.de/ifa/praxishilfen/practical-solutions-machine-safety/software-sistema/index.jsp

**DOC-CONFIRMED:** Pilz's current ISO 13849-1 overview describes PLr as a risk-assessment-derived requirement for a safety function and identifies, for self-designed subsystems, Category, MTTFd, DC and CCF as aspects used in determining subsystem PL. Its 2023-edition summary also notes stronger SRS guidance, subsystem-oriented structure, clarification of Category 2 and CCF, integration/revision of validation requirements, and changes to PLr guidance.

Source: https://www.pilz.com/pl-PL/support/law-standards-norms/functional-safety/en-iso-13849-1

## The six concepts must not collapse into one

### 1. PLr — required performance

PLr belongs to the safety function's risk/SRS context. It is not inferred from how many relays, channels, safety devices, or certified components are present.

**Freeze:** ARCHITECTURE DOES NOT CREATE PLr.

### 2. Category — structural/fault-behavior constraint

Category describes architectural/fault-response properties. It is one input to achieved PL, not a synonym for PL.

**Freeze:** CATEGORY 4 != PL e BY DEFINITION.

### 3. MTTFd — dangerous-failure reliability input

MTTFd addresses dangerous random hardware failure reliability under the applicable assumptions. For electromechanical components, use profile and switching cycles can matter through B10d-derived reasoning. A catalog number detached from application duty is not sufficient evidence.

### 4. DC / DCavg — diagnostic effectiveness

Diagnostic coverage concerns the effectiveness of diagnostics for dangerous failures. It is not proof that the machine has reached the physical safe state. EDM may contribute to a diagnostic claim while still not proving shaft standstill, pressure exhaustion, or personnel clearance.

**Freeze:** DC CLAIM != PHYSICAL SAFE-STATE PROOF.

### 5. CCF — common-cause vulnerability

Redundant channels can fail together through shared dependencies, environment, power, routing, contamination, design errors, maintenance, or other common causes. Counting channels is not a CCF analysis.

### 6. Validation/systematic correctness

A numerical PL result does not prove that the safety function was specified correctly, implemented correctly, configured correctly, integrated with the real machine correctly, or physically validated. The current 2023 method explicitly strengthens SRS/validation treatment.

**Freeze:** SISTEMA PASS != MACHINE VALIDATION PASS.

## SISTEMA: calculator, not oracle

**DOC-CONFIRMED:** IFA describes SISTEMA as a tool that models safety-related control structure using designated architectures and calculates reliability values including achieved PL. Inputs include PLr risk parameters, Category, CCF measures, MTTFd and DCavg.

Therefore a plausible-looking green/result screen cannot repair false assumptions supplied to the model. The engineering work occurs both before and after the calculation:

1. define the right safety function and PLr;
2. decompose the real implementation correctly;
3. enter defensible component/use/diagnostic/CCF assumptions;
4. interpret the result within the method's scope;
5. validate the actual safety function and machine behavior.

## First learner exercise — same topology, different evidence

Give two nominally identical dual-channel contactor schematics.

Architecture A has:
- documented safety-component reliability data;
- documented mirror contacts and monitored feedback;
- justified switching/use profile;
- analyzed channel independence/CCF measures;
- controlled replacement configuration;
- machine-level validation.

Architecture B has:
- lookalike ordinary relays;
- unknown dangerous-failure data;
- ordinary auxiliary contacts assumed to be mirror contacts;
- unknown switching frequency and utilization duty;
- shared unexamined dependencies;
- no physical validation.

Ask: why can the drawing topology look similar while the defensible achieved-integrity evidence differs radically?

The answer must not assign a PL to either architecture unless all method inputs needed for that claim are actually supplied.

## Cheapest-change reasoning

The course lab asks for the cheapest change producing the largest increase in fault tolerance. Do not answer this generically. The best change depends on the current weak link. Examples to investigate in later exercises:

- replacing a single unmonitored final element with an architecture that detects/withstands the relevant dangerous fault;
- adding a diagnostic only when it observes a meaningful dangerous failure;
- removing a common-cause dependency rather than adding another nominal channel;
- selecting components with defensible reliability/application data;
- improving maintainability so replacement does not silently invalidate the architecture.

The learner must first identify the limiting proposition/failure path, then propose the cheapest effective correction.

## Evidence classifications

- ISO 13849-1:2023 current-edition orientation and revision themes: `DOC-CONFIRMED` through DGUV/IFA and manufacturer standards guidance.
- SISTEMA input/evaluation role: `DOC-CONFIRMED` through DGUV/IFA.
- Category/MTTFd/DC/CCF as distinct contributors to achieved PL: `DOC-CONFIRMED`.
- PLr as safety-function risk requirement: `DOC-CONFIRMED`.
- Any named machine's PLr, achieved PL, MTTFd, DCavg, CCF sufficiency, B10d applicability, mission/use profile or PFHd: `UNKNOWN` until its evidence is supplied.
- Cross-layer proposition discipline inherited from 2520/2540: `INFERENCE` supported by the documented method boundaries and prior curriculum evidence.

## Next evidence-gain task

Build 2550 example architectures using symbolic or explicitly sourced data rather than invented machine values. The exercises must make Category, MTTFd, DCavg and CCF vary independently enough to demonstrate why no single one determines PL. Include at least one case where adding nominal redundancy fails to improve the defensible result because a common final element or CCF dominates, and one case where a numerical tool result is invalidated by a bad application assumption.

No compute is justified yet: these are method/source questions. If a later bounded SISTEMA-compatible calculation answers a concrete unresolved question, run it only on `[self-hosted, openpressbrake]`.
