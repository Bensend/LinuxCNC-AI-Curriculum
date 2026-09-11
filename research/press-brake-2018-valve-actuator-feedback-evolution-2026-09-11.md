# 2018 press-brake valve-actuator feedback evolution

Date: 2026-09-11
Course context: dependency-safe 4600 research
Evidence class: COMMUNITY-REPORTED DEVELOPMENT / FIELD TEST; not source-confirmed LinuxCNC behavior unless explicitly stated

## Why this thread matters

The later pages of the 2018 `Hydraulic press brake control` diary contain a useful failure-driven architecture change that is easy to miss if only the initial component skeleton is read.

The machine has two cylinder glass scales and two stepper-driven hydraulic spool valves. The stepper position is therefore not merely a generic motion axis: it is an intermediate actuator state that determines hydraulic flow to each side.

## Chronology

### September 29: separate the inner valve-position loop

The builder proposed putting closed-loop stepper control outside the press component. Grotius agreed. This separates two responsibilities:

- inner valve-actuator position control: make each physical stepper/spool reach its requested position;
- outer ram synchronization: compare left/right cylinder glass-scale feedback and bias the respective valve request when one side lags.

Later discussion explicitly describes synchronization during full speed, lower speed and press hold by reading both glass scales and changing the lagging side's valve-stepper angle.

This is COMMUNITY-REPORTED architecture intent. It does not establish the final equations, limits, thread order or stability.

### November 27: machine movement achieved, but incomplete

The builder reported that a custom component could move the machine, but movement was jumpy, homing was absent and the valve steppers were still position-commanded without closed-loop encoder correction.

This is useful because it prevents retrospective treatment of the early configuration as a mature controller.

### November 28: hydraulic disturbance invalidates open-loop valve-position assumption

The builder then reported two related findings:

1. the synchronization compensation was not linear; changing it made motion smoother;
2. when the hydraulic pressure relief operated, the resulting pressure spike could mechanically kick the valve and cause the stepper-driven valve to lose position.

The builder concluded that the valve steppers needed to become closed-loop.

This is the strongest finding in this pass. It is a real development report in which a **hydraulic disturbance changed the state of an intermediate actuator**, so commanding a step count was not sufficient evidence of actual valve position.

## Derived layered-control lesson

The public evidence supports the following bounded architecture inference:

`ram target/common motion -> Y1/Y2 synchronization correction -> requested valve position -> valve actuator position loop -> hydraulic plant -> physical ram scale feedback`

The important point is not that every press brake needs a stepper valve. Most do not. The reusable lesson is that **every stateful intermediate actuator whose actual state can diverge from command needs an observability/feedback decision appropriate to its failure modes.**

For a proportional electrical valve this might instead be current feedback, amplifier diagnostics, spool feedback, or no direct valve-state feedback depending on the hardware. The curriculum must not invent a required sensor. It must ask whether command is a trustworthy proxy for actuator state and document the consequence if it is not.

## Failure-ownership implications

| Failure | Earliest credible witness in this machine | Owner that can detect it | Why ram synchronization alone is insufficient |
|---|---|---|---|
| valve stepper/spool displaced by pressure event | valve-stepper encoder disagreement with requested position | inner valve-actuator loop / actuator diagnostic | ram scales see only the later plant consequence; they cannot identify the valve-state cause |
| one ram side lags | left-right glass-scale differential | Y1/Y2 synchronization/fault layer | inner valve loop can be healthy while hydraulic/cylinder response differs |
| nonlinear side compensation | motion response versus applied correction | outer synchronization tuning/verification | perfect valve position does not make the hydraulic plant linear |
| pressure relief event | pressure/relief witness if instrumented; otherwise indirect plant/actuator response | hydraulic/process layer | neither a step command nor a ram error uniquely proves relief operation |

## Adversarial checks

**Premise: "The step generator is closed loop because LinuxCNC knows how many steps it emitted."** Rejected for this machine. The reported pressure event physically displaced the valve mechanism and caused lost position. Emitted steps were not physical valve truth.

**Premise: "Two ram scales make valve feedback unnecessary."** Rejected as a general inference. Ram scales can close the outer plant loop but do not necessarily identify or bound an intermediate actuator-state error before it propagates.

**Premise: "The pressure-spike report proves all proportional valves need spool feedback."** Rejected. The report concerns this mechanical stepper-driven spool arrangement. It establishes an observability question, not a universal sensor requirement.

## Consequence for the 4600 playbook

For each hydraulic command path, inventory all stateful stages between LinuxCNC's final numeric/boolean command and cylinder force/velocity. For each stage record:

- commanded quantity;
- physical quantity actually controlled;
- whether direct feedback exists;
- plausible ways actual state can diverge from command;
- earliest diagnostic witness;
- which loop/state machine owns detection and response;
- what remains unknown without physical instrumentation.

This should be part of the state -> hydraulic-mode -> decoder -> final-authorization trace, not an afterthought during tuning.

## Source

LinuxCNC Forum, `Hydraulic press brake control`, especially posts of 29 Sep 2018 and 27–28 Nov 2018:
https://forum.linuxcnc.org/30-cnc-machines/35266-hydraulic-press-brake-control?start=10
https://forum.linuxcnc.org/30-cnc-machines/35266-hydraulic-press-brake-control?start=20

## Next checkpoint

Find executable public state-to-hydraulic-decoder evidence with a nontrivial mode such as decompression and explicit mid-state disable/fault handling. Keep the 2018 project as failure-driven actuator-observability evidence, not as a mature reference architecture.
