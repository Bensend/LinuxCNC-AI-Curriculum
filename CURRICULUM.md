# LinuxCNC Developer Curriculum

This curriculum is dependency-driven rather than a fixed reading list. Modules may spawn prerequisites when source reading exposes missing knowledge.

## Critical Path

The first branch is deliberately chosen to support future Ethernet FPGA machine-control development while still establishing LinuxCNC fundamentals:

`Architecture -> Realtime Model -> HAL Execution Model -> Motion/Servo Cycle -> HostMot2 Core -> hm2_eth -> HostMot2 Watchdog -> Encoder Path -> Output/PWM Path`

No later module may paper over an ungraduated prerequisite.

## Laboratory Compute Budget

The autonomous curriculum may continue hourly, but paid/limited laboratory compute must be treated as a separate resource budget.

- Target laboratory compute budget: **maximum 4 hours per calendar day**, sized to remain near a **120-hour/month** allowance over a 30-day month.
- Research, source reading, documentation, reasoning, exams, corrections, and handoff work should continue outside the lab budget whenever they do not require the laboratory environment.
- A laboratory experiment may span multiple hourly curriculum lessons. Launch it once, record its run/job identifier and checkpoint, and let later lessons inspect and continue the same experiment rather than starting duplicates.
- An hourly lesson arriving while a lab is still running must not by itself trigger another copy of that lab.
- Individual workflow/job execution limits are independent of the daily compute budget. If the execution platform terminates an individual job at approximately 60 minutes, checkpoint or split the experiment into bounded stages and continue it in a later lesson/run.
- Once approximately 4 hours of laboratory compute have been consumed for the day, subsequent lessons should preferentially perform non-lab work and queue additional experiments for the next available daily budget.
- Lab time and lesson-agent wall-clock time are distinct. A background lab may legitimately overlap later lessons; duplicate lab execution should be avoided.
- Where practical, record laboratory start/end/runtime data so daily and monthly usage can be audited and the budget adjusted if actual platform accounting differs from wall-clock estimates.

## Phase 0 — Laboratory and Research Method

- L00 — Codespaces LinuxCNC laboratory
- L01 — source/version pinning and reproducibility
- L02 — LinuxCNC repository map and build/test system
- L03 — evidence/claims workflow

## Phase 1 — Architecture

- A01 — process/component architecture
- A02 — startup and configuration lifecycle
- A03 — task, motion, interpreter, GUI, HAL and NML boundaries
- A04 — machine state and enable/disable lifecycle
- A05 — one complete command-to-feedback conceptual trace

## Phase 2 — Realtime

- R01 — LinuxCNC realtime model and supported realtime environments
- R02 — realtime threads, functions, scheduling and periods
- R03 — servo thread versus other thread roles
- R04 — latency, deadline behavior and what LinuxCNC does/does not guarantee
- R05 — realtime/userspace communication boundaries

## Phase 3 — HAL

- H01 — HAL architecture and object model
- H02 — pins, signals, parameters and types
- H03 — components and exported functions
- H04 — thread/function execution ordering
- H05 — halcmd, halshow, halmeter and halscope internals/usage
- H06 — custom components and halcompile
- H07 — HAL failure/debugging patterns

## Phase 4 — Motion and Servo Control

- M01 — joints versus axes
- M02 — motion command/feedback data path
- M03 — one servo-period source-level trace
- M04 — PID component and closed-loop topology
- M05 — following error
- M06 — limits and homing
- M07 — enable, fault and recovery paths
- M08 — coordinated motion/trajectory boundary

## Phase 5 — HostMot2

- HM01 — HostMot2 architecture and registration lifecycle
- HM02 — module descriptor/IDROM model
- HM03 — register access model
- HM04 — GPIO
- HM05 — encoder module
- HM06 — PWM/PDM generators
- HM07 — stepgen
- HM08 — watchdog
- HM09 — read/write cycle ordering
- HM10 — error propagation into HAL/LinuxCNC

## Phase 6 — hm2_eth

- E01 — driver architecture and board discovery
- E02 — socket/network initialization
- E03 — read request/response path
- E04 — write path
- E05 — servo-period interaction and timing
- E06 — packet loss, timeout and error behavior
- E07 — recovery behavior
- E08 — interaction with HostMot2 watchdog
- E09 — complete LinuxCNC-to-Ethernet-register call flow

## Phase 7 — Feedback and Output Hardware Paths

- IO01 — quadrature encoder register-to-HAL path
- IO02 — encoder scaling/index/latch behavior
- IO03 — synthetic/faulted encoder experiments
- IO04 — PWM/PDM command path
- IO05 — analog-servo interface patterns
- IO06 — GPIO input/output path
- IO07 — hardware enable and fault patterns

## Phase 8 — Safety Boundary and Failure Engineering

- S01 — LinuxCNC machine control versus functional safety
- S02 — watchdog design patterns
- S03 — communication-loss behavior
- S04 — stale/frozen feedback
- S05 — disagreement/redundancy monitoring patterns
- S06 — fault injection framework
- S07 — restart/recovery/state integrity

## Phase 9 — Interpreter, Task, NML and UI

- T01 — G-code interpreter architecture
- T02 — task layer
- T03 — NML architecture and messages
- T04 — GUI integration boundaries
- T05 — custom operator interface patterns

## Phase 10 — Machine-Control Capstone

- C01 — simulated dual-actuator machine
- C02 — independent feedback loops
- C03 — synchronization/cross-coupling experiment
- C04 — asymmetric actuator response
- C05 — frozen/jumping feedback
- C06 — communication/watchdog faults
- C07 — state-machine sequencing
- C08 — diagnostics and trace capture
- C09 — fresh-AI architecture handoff

## Graduation Rule

Every module uses `MODULE_TEMPLATE.md`. A module does not graduate from prose alone. It requires source evidence, reproducible experiments where practical, an adversarial exam, corrections, and a fresh-AI handoff test.

## Public/Private Boundary

Machine-specific proprietary design information belongs outside this public curriculum. Capstone simulations should remain generic enough to teach LinuxCNC behavior without publishing private machine drawings or private hardware design details.
