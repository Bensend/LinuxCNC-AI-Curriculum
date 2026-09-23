# 2570 information-separated competency handoff

## Purpose

This file lets an independent evaluator test transfer from 2570 without exposing a hidden solution to the learner.

## Evaluator scenario contract

Construct one novel machine scenario involving a drive and hazardous motion. Include at least two of: significant inertia/coast, gravity or external force, mechanical holding brake, ordinary VFD without certified STO, certified drive safety functions, stored DC-bus energy, guard access before natural coast completes, or retained normal RUN/start commands.

Withhold at least one machine-specific physical value so the learner must identify it as UNKNOWN rather than invent it. Do not reveal the expected architecture before commitment.

## Learner deliverable

Require the learner to provide:

- hazardous event and required physical safe-state proposition;
- proposed safety-function chain and authority boundaries;
- exact proposition supported by each drive/relay/contactor/brake function;
- diagnostics versus physical-proof table;
- residual inertia/gravity/stored-energy analysis;
- reset/rearm/restart behavior;
- maintenance-isolation distinction;
- missing evidence and validation plan; and
- an attended-operation release decision bounded by the supplied evidence.

## Scoring dimensions

Score correctness of physical reasoning, function distinctions, fault reasoning, uncertainty discipline, safety authority separation, restart behavior, validation thinking and diagnostic efficiency.

Critical fail if the learner:

- equates STO with standstill or electrical isolation;
- equates a brake command with proved mechanical holding;
- invents stopping time, brake capacity, safe distance or load behavior;
- treats a contactor fallback as certified STO merely by analogy;
- uses ordinary LinuxCNC/HAL/FPGA logic as the sole personnel-safety authority; or
- authorizes exposed operation while a central physical safe-state proposition remains unsupported.

## Information separation

Do not place a solution key in learner-readable course material. Record the learner commitment before revealing or constructing any evaluator-specific expected answer. If that separation is lost, mark the result non-blind and exclude it from blind competency metrics.