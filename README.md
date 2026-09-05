# LinuxCNC AI Curriculum

A source-level LinuxCNC curriculum and developer guide designed for another AI engineer.

The goal is not merely to explain how to configure LinuxCNC, but to build implementation-level understanding sufficient to architect, modify, debug, test, and extend LinuxCNC-based machine controls.

## Mission

Build and execute a comprehensive LinuxCNC developer curriculum. For each subsystem:

1. Study current official LinuxCNC documentation.
2. Identify useful expert knowledge from LinuxCNC forums, mailing lists, examples, and community discussions.
3. Inspect the actual LinuxCNC source implementation.
4. Trace important functions, structures, call chains, and execution paths.
5. Produce an AI-oriented developer guide.
6. Design reproducible experiments that verify the documented behavior.
7. Record conflicting claims, uncertainties, version differences, and open questions.
8. Test understanding before marking the subsystem complete.

A module is not complete merely because a convincing summary was written.

**Documentation -> community knowledge -> source code -> function guide -> call-flow guide -> experiment -> verification -> adversarial exam -> corrections -> complete**

## Intended Audience

The primary audience is an AI engineering agent that needs enough context to work directly with LinuxCNC source code and machine-control configurations. Human engineers should also be able to use the material as an architecture and development reference.

Guides should emphasize source paths, symbols, callers/callees, data structures, realtime versus userspace execution, HAL-visible behavior, configuration dependencies, failure behavior, timing assumptions, watchdog behavior, hardware interaction, debugging methods, evidence, uncertainties, and useful symbols for further source exploration.

## Evidence and Source Hierarchy

Information should normally be weighted in this order:

1. LinuxCNC source code for implementation behavior.
2. Current official LinuxCNC documentation and design notes.
3. Official examples, tests, and reference implementations.
4. Statements from LinuxCNC developers and experienced integrators.
5. LinuxCNC forum discussions and field reports.
6. Third-party tutorials, videos, blogs, and other community material.

Forum and secondary-source claims are leads, not automatic facts. Important claims should be reconciled with source and/or reproducible experiments whenever practical. Every significant claim should retain enough provenance for another agent to verify it.

## Versioning

Every source-level guide and experiment must record the exact LinuxCNC tag, branch, and/or commit SHA studied. Development-branch behavior must not silently be presented as stable-release behavior. Where useful, document differences between the development branch and current stable release.

## Curriculum Areas

The curriculum will grow as a dependency graph and includes LinuxCNC architecture, realtime execution, HAL, INI configuration, task and motion, joints and axes, servo/PID control, following error, homing and limits, trajectory planning, custom components, NML, HostMot2, hm2_eth, FPGA-facing interfaces, encoders, PWM/PDM, step generation, GPIO, watchdogs, machine I/O, GUIs, diagnostics, simulation, automated testing, and fault injection.

## Developer Guide Standard

For behaviorally significant functions, document: source file; purpose; called by; calls; inputs; outputs; state modified; execution context; invocation frequency; control flow; failure behavior; assumptions; related structures; HAL pins/parameters; configuration; tests; relevant community findings; unresolved questions; and symbols another AI should inspect next.

Inventory the complete subsystem, but do not give trivial getters and boilerplate the same depth as control-flow-critical code.

## Call-Flow Guides

End-to-end execution paths are first-class artifacts. Examples include:

- What happens during one LinuxCNC servo-thread period?
- How does a HAL signal propagate through a realtime component?
- How does feedback move from hardware into LinuxCNC motion control?
- How does an output command travel from LinuxCNC through HostMot2 to hardware?
- What happens when an Ethernet cycle is late or lost?
- What happens when a HostMot2 watchdog expires?
- What happens when encoder feedback freezes or becomes invalid?

## Experiments

Wherever practical, claims should be backed by reproducible LinuxCNC simulations, HAL test networks, custom components, synthetic feedback, servo simulations, fault injection, communication-delay tests, invalid-configuration tests, and regression tests.

Each experiment records its objective, exact LinuxCNC revision, setup, commands, expected behavior, observed behavior, logs/artifacts, conclusions, and discrepancies.

## Codespaces Laboratory

This repository is intended to provide a reproducible LinuxCNC software laboratory using GitHub Codespaces. The lab will support obtaining a selected LinuxCNC revision, building LinuxCNC, running userspace/simulation configurations, compiling custom components, running tests and curriculum experiments, and preserving results.

The Codespaces lab is a software research environment. It is not a substitute for a realtime physical-machine test environment.

## Safety Boundary

LinuxCNC can control powerful machinery. This curriculum must distinguish ordinary machine-control software, realtime control, diagnostics/fault handling, and safety-rated functions. Software behavior is not assumed safety-rated merely because it executes in LinuxCNC or in a realtime thread. Physical-machine experiments require separate hardware safety analysis and controlled commissioning.

## Planned Repository Structure

```text
00-Architecture/
01-Realtime/
02-HAL/
03-Motion/
04-Servo-PID/
05-HostMot2/
06-hm2-eth/
07-Encoders/
08-IO/
09-Safety-Watchdogs/
10-GCode-Interpreter/
11-NML/
12-GUI/
13-Testing/
14-Machine-Control/
developer-guides/
call-flows/
experiments/
forum-findings/
claims/
unknowns/
exams/
.devcontainer/
scripts/
```

## Completion Standard

A module graduates only when a fresh AI engineer, using the resulting repository artifacts, can explain the subsystem, locate its implementation, trace important execution paths, identify configuration interfaces, understand common failure modes, reproduce experiments, recognize uncertainty rather than invent behavior, and make an appropriate small code/configuration change.

The final test is successful technical handoff, not document length.

## Project Status

Initial repository and LinuxCNC Codespaces laboratory setup in progress.
