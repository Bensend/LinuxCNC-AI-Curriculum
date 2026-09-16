# 4000 Safety Lane B Checkpoint — 2026-09-16

Status: ACTIVE

## Durable state

Independent lane added `safety-course/SENSOR_FEEDBACK_INDEPENDENCE_COMMON_CAUSE_WORKSHEET.md` at commit `eb3b3a5a7148af663c10bc768f4f27c64ed7b7f9`.

The worksheet prevents channel-count inflation: multiple screens, tags, sensors, or feedback values count as independent evidence only to the extent that their sensing, power, reference, wiring, controller, transport, software derivation, freshness, configuration, mechanical target, environment, calibration, and maintenance dependencies support that conclusion.

Frozen rule: **three displays derived from one stale bit are one witness, not three independent witnesses.**

## Parallel-work reconciliation

Before selecting work, current `main` showed the primary safety lane at `f3ad56a620d333d648b3c56b616c8ed382c42db6`. The primary lane completed `safety-course/STORED_ENERGY_ZERO_VS_CONTROLLED_SAFE_STATE.md` and is now explicitly advancing an energy-isolation verification/witness-design lesson covering multiple feeds, trapped hydraulic/pneumatic energy, gravity/springs/flywheels, blocking/standstill, reaccumulation, and maintainable isolation/test points.

Lane B therefore did not create or modify energy-isolation, stored-energy, bleed/test-point, blocking, zero-energy, or primary-checkpoint artifacts. It followed its previous checkpoint and advanced sensor/feedback independence and common-cause analysis in a new file.

After the Lane-B artifact commit, `main` was re-read. The new Lane-B commit was head and the preceding primary commit remained `f3ad56a`; no overlapping file changed during this run. The Lane-B checkpoint itself was then re-fetched before this update.

## Evidence frozen

- Agreement is not independence.
- Separate UI presentations are not separate witnesses when they derive from one source.
- Separate electrical channels may still share power, cable, connector, mechanical target, environment, configuration, calibration, or maintenance common causes.
- Separate software tags are not separate sensors when derived from one ADC/register/value.
- Freshness/session identity is part of evidence validity; common stale state can produce false agreement.
- Disagreement is diagnostically valuable and must not be suppressed merely to preserve availability.
- Rockwell GuardLogix documentation distinguishes module-level dual-channel discrepancy checking from controller-instruction discrepancy diagnostics; the comparison/diagnostic layer must be traced rather than inferred from channel count.
- OSHA hazardous-energy guidance keeps control circuitry distinct from physical energy isolation and requires verification of isolation/deenergization, potentially using multiple methods.
- LinuxCNC/HAL and the ordinary FPGA remain useful diagnostic/normal-control participants, not personnel-safety authority merely because they supervise or disagree with another channel.

Evidence classes remain `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`.

No executable verification was justified, so no compute was consumed.

## Precise next independent work

If still independent of the primary lane, build a **diagnostic blind-spot / latent-fault accumulation worksheet**.

It should force identification of:
1. faults detected immediately versus only on demand/change of state;
2. faults that can remain latent during normal operation;
3. which second fault could combine with a latent first fault to defeat the intended safety function;
4. whether diagnostics observe the physical channel or merely a command/software representation;
5. startup/restart tests that expose otherwise latent faults;
6. proof-test stimuli and observability needed to challenge the actual final-element/sensor path;
7. common-cause cases where both channels pass the same inadequate diagnostic;
8. what evidence invalidates a prior `healthy` state after reboot, maintenance, wiring change, device replacement, or stale communication;
9. machine-specific facts that must remain `UNKNOWN` rather than inventing diagnostic-coverage percentages or proof-test intervals.

Keep the lesson architecture-focused and cross-machine. Do not duplicate the primary lane's energy-isolation verification/witness-design artifact. If the primary lane occupies latent-fault diagnostics before the next run, switch to an independent proof-test stimulus/observability study or safety-diagnostic startup/restart challenge matrix using different files and evidence artifacts.
