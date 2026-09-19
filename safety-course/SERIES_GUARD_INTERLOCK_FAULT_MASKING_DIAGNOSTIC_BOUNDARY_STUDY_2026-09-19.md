# Series Guard Interlock Fault Masking and Diagnostic Boundary Study

Date: 2026-09-19
Lane: independent safety curriculum lane B

## Why this lane

The primary safety lane's newest durable work is press-brake valve monitoring versus physical hydraulic/motion witnesses. This study deliberately stays outside that module, evidence package, and files. It addresses a different recurring architecture risk: several movable guards sharing one safety evaluation path can look healthy at the aggregate level while a device/wiring fault is masked by foreseeable operation of another guard.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly supported by a primary manufacturer/standards-oriented source.
- **DOC-CONFIRMED** — supported by repository or product documentation, but not a machine-specific physical test.
- **TEST-CONFIRMED** — demonstrated by an actual relevant test. None claimed here.
- **COMMUNITY-REPORTED** — community evidence only. None relied on here.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence and identified as such.
- **UNKNOWN** — requires machine-specific design evidence, calculation, inspection, or test.

## Durable architecture freeze

**ALL GUARDS CLOSED != EACH GUARD CHANNEL HEALTHY != INDIVIDUAL FAULT DETECTABLE != AGGREGATE SAFETY INPUT HEALTHY != HAZARD STOPPED != PERSONNEL CLEAR != RESTART AUTHORITY.**

And:

**A SAFETY RELAY THAT SEES A NORMAL SERIES STATE DOES NOT, BY ITSELF, PROVE THAT EVERY SERIES-CONNECTED INTERLOCK REMAINS CAPABLE OF DEMANDING A STOP.**

## Source trace

### SICK — fault masking in conventional series connections

SOURCE-CONFIRMED from SICK, *Safe series connection* (8018284): conventional logical series connection of interlocking devices with volt-free contacts can mask faults because the evaluator sees only the complete series. SICK gives a concrete sequence: an initial short/cross-circuit is exposed as a discrepancy, operation of another guard can make the aggregate input requirements look valid again, reset can then mask the original fault, and an additional fault can cause loss of the safety function.

This is valuable because it is not merely a generic warning. It supplies a failure path that can be used directly as a commissioning/validation challenge.

Source: https://www.sick.com/media/docs/8/68/468/Special_information_Safe_series_connection_en_IM0059468.PDF

### SICK STR1 — safe series options and diagnostic visibility

SOURCE-CONFIRMED from SICK STR1 operating instructions: STR1 supports several series architectures. Flexi Loop evaluates individual switches and carries information to the evaluator; T-connector series wiring without diagnostics makes the connected devices act like one device; cabinet series connection can retain individual auxiliary diagnostic outputs while OSSDs form the safety path. The device also performs internal fault detection and OSSD short/cross-circuit monitoring.

Source: https://www.sick.com/media/docs/5/45/245/Operating_instructions_STR1_en_IM0068245.PDF

### Pilz — fault masking is a diagnostic-coverage problem

SOURCE-CONFIRMED from the Pilz Safety Compendium: fault masking must be considered for mechanical and magnetic guard switches in series. Pilz notes that switches with internal diagnostics and OSSD outputs avoid this particular conventional-contact masking mechanism, while series groups of conventional switches can have their achievable diagnostic coverage restricted by masking probability.

Source: https://www.pilz.com/download/open/TechBo_Pilz_safety_compendium_1004669-EN-02.pdf

SOURCE-CONFIRMED from Pilz movable-guard guidance: opening an interlocked guard is expected to stop the hazardous function and prevent unexpected restart; restart after safeguarding has been triggered is a separate deliberate action rather than an automatic consequence of field restoration.

Source: https://www.pilz.com/en-GB/support/law-standards-norms/iso-standards/choosing-guards/movable

## Architecture consequences for LinuxCNC/OpenPressBrake

1. **INFERENCE:** LinuxCNC/HAL may display aggregate guard state and diagnostics, but ordinary LinuxCNC/FPGA logic must not become the personnel-safety authority merely because it can identify which door changed.
2. **INFERENCE:** A single aggregate `guards_ok` bit is insufficient commissioning evidence for a multi-guard safety function. Validation should challenge each guard and each relevant channel/fault path in the actual architecture.
3. **INFERENCE:** Individual diagnostic visibility is useful for maintenance, but a nonsafety diagnostic bit does not substitute for the safety function's required fault response.
4. **INFERENCE:** When conventional contacts are series-connected, foreseeable operation of another guard during troubleshooting or normal use must be considered because it can alter whether a latent fault remains visible.
5. **INFERENCE:** Replacing conventional series wiring with OSSD devices or a diagnostic safety network may improve fault visibility, but the actual achieved safety performance remains design-specific and must not be inferred from product family claims alone.

## Failure-path worksheet

For each real multi-guard implementation, answer and physically validate where appropriate:

| Challenge | Required evidence |
|---|---|
| Open guard A from normal operation | Safety demand reaches the intended final elements; hazardous function responds as designed |
| Open guard B independently | Same, without relying on guard A |
| Create/represent one channel discrepancy at guard A | Evaluator detects/inhibits according to the documented architecture |
| While A has the discrepancy, operate guard B | Original fault must not become silently acceptable merely because aggregate inputs now resemble a valid sequence |
| Close all guards with a latent fault remaining | Safety rearm/restart must remain inhibited when the architecture requires fault retention |
| Power cycle with the fault present | Power restoration must not convert unresolved guard fault into production authority |
| Hold stale LinuxCNC START/CYCLE/JOG while restoring guards | Safety-side restoration must not make stale ordinary motion intent sufficient for hazardous restart |
| Replace one guard switch or actuator | Identity/coding/alignment/wiring and affected safety function are re-proved before production |
| Defeat/misalign one actuator | Actual defeat resistance and diagnostic response are checked; do not assume coding alone proves installation resistance |

## Commissioning acceptance boundary

A defensible commissioning record should identify:

- every guard and the hazard(s) within its span of control;
- switch technology and coding type;
- whether safety channels are individual, conventional series, OSSD series, or safety-networked;
- what the safety evaluator can and cannot distinguish;
- diagnostic paths that are safety-rated versus maintenance-only;
- the deliberate fault challenges actually performed;
- reset/restart behavior after each fault;
- actual final-element response and any separate physical stop/safe-state witness required by the machine;
- configuration/version/change-control evidence after replacement.

## Explicit UNKNOWNs for OpenPressBrake

The following are not established by this study and must not be invented:

- number or type of OpenPressBrake guards/interlocks;
- whether any guard contacts are series-connected;
- required PL/SIL/category/DC/CCF;
- switch coding or defeat-resistance measures;
- stop category, hydraulic response, stopping distance/time, or safe pressure;
- whether guard opening removes electrical, hydraulic, mechanical, or only motion authority;
- exact reset location and personnel-clear method;
- whether guard locking is required for overrun;
- final-element topology.

## No compute justification

No simulation, synthesis, benchmarking, or executable verification is needed to establish this source/documentation boundary. No GitHub-hosted runner is justified. A future executable lab should be launched only for a concrete question that cannot be answered by documentation and must target `[self-hosted, openpressbrake]`.

## Exact next-work checkpoint

Find a complete professional multi-guard implementation that exposes:

`guard A/B/C -> individual or series safety channels -> evaluator diagnostic behavior -> deliberately introduced single fault -> operation of a second guard while fault exists -> fault retained or masked -> reset/restart disposition -> actual final element -> physical hazardous-state witness -> correction -> re-proof -> fresh ordinary production start`.

Prefer a manufacturer commissioning example that contrasts conventional volt-free-contact series wiring with an individually diagnosable OSSD/safety-network architecture. Preserve the distinction between safety-path fault detection and ordinary PLC/HMI diagnostics.