# Source and Evidence Policy

## Purpose

This project is intended to create source-level knowledge that another AI engineer can trust and independently verify. Fluent prose is not evidence.

## Authority Model

For implementation behavior, prefer the actual LinuxCNC source at the revision being studied. Use official documentation to establish intended/public behavior and terminology. Use official examples/tests as executable evidence. Use developer/integrator discussions and forum posts to discover edge cases, historical context, debugging techniques, and questions that should be verified.

## Claim Classes

Every nontrivial technical conclusion should be distinguishable as one of:

- **SOURCE-CONFIRMED** — directly supported by inspected source at a recorded revision.
- **DOC-CONFIRMED** — explicitly supported by current official documentation.
- **TEST-CONFIRMED** — reproduced in a recorded experiment.
- **COMMUNITY-REPORTED** — reported by a credible community source but not yet independently verified here.
- **INFERENCE** — reasoned from evidence but not directly established.
- **UNKNOWN** — unresolved or conflicting evidence.

Multiple labels may apply.

## Required Provenance

Source findings record repository path, symbol/function, LinuxCNC commit SHA, and useful line/range or nearby symbol. Documentation findings retain page/title and URL. Community findings retain thread/post URL, author when useful, date, and the precise claim being investigated. Experiments retain commands/configuration and resulting artifacts.

## Conflict Rule

Do not silently reconcile conflicts. Record the conflicting evidence, version context, likely explanation if one exists, and an experiment or source-reading task that could resolve it.

## Version Rule

Never generalize behavior found on one revision to all LinuxCNC versions without evidence. Stable and development branches may differ.

## Research Workflow

For each subsystem:

1. Establish vocabulary and intended behavior from official material.
2. Search community material for real failure modes and implementation clues.
3. Inventory relevant source directories/files/symbols.
4. Trace behaviorally significant call chains.
5. Produce the developer guide.
6. Convert important claims into experiments where practical.
7. Run experiments and reconcile results.
8. Create an adversarial comprehension test.
9. Correct the guide from failures before graduation.

## Public Repository Boundary

This repository contains generic/public LinuxCNC research. Do not copy proprietary machine drawings, private OpenPressBrake design material, credentials, private infrastructure details, or other confidential material into this public repository.
