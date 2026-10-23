# 4400 technician card — Guard locking, escape and rearm (public-source exercise)

**Objective:** diagnose five common guard-locking misconceptions without using machine-specific guesses. This is an evidence-reasoning exercise, not a procedure to energize a machine. Read `research/4400_GUARD_LOCKING_POWER_LOSS_ESCAPE_RELEASE_AUTHORITY_2026-10-22.md` and the cited exact manufacturer manuals.

## Scenario

A cell can admit an entire person. It has a locked access door, a moving load that may continue after the drive is disabled, and an ordinary LinuxCNC controller. The operator says: 'The guard lock light is green; if power goes away, the door is safe. We also have a red release lever outside, and when the door closes again LinuxCNC will resume.' The actual interlock suffix, downstream safety controller, motion stopping time and escape geometry are not yet known.

## Candidate's required response (no assumed machine numbers)

1. Compare **power-to-lock** and **power-to-release** failure paths under supply loss. Identify the hazard each can introduce and what physical evidence is needed before selecting either.
2. Distinguish inside **escape**, outside **emergency**, and tool-required **auxiliary** release. Explain why the red outside lever does not prove a trapped worker can escape.
3. A maintenance replacement changes Schmersal **AZM300Z** to **AZM300B** while retaining the same visible guard and electrical connector. Identify the manufacturer-documented change in safety-output meaning and all affected package IDs. Do not infer interchangeability.
4. A SICK TR110 guard was manually released, then closed and re-locked. The HMI shows 'lock healthy' and an old start signal is still asserted. Explain the minimum rearm/start and functional-check conditions; identify who has personnel-safety authority.
5. The guard is closed, power is lost and a worker remains inside. The escape button is physically obstructed by a stored workpiece. Classify the status of the physical proposition, operational restriction and human-factors redesign.
6. A diagnostic PLC output says 'locked' while a separate physical witness shows the guard open. State what each witness can prove, what remains contradicted and whether rearm is allowed.

## Assessor evidence expectations (not a sealed key)

A competent answer keeps separate the guard locking principle, the safety output/diagnostic output, safe stop/holding, escape/rescue, occupancy, reset and ordinary start. It must preserve UNKNOWN physical quantities and prohibit personnel-exposed operation where basic safety cannot be established. It should cite the exact SICK manual edition and Schmersal ordering-code variant and carry contradictions through `PHY/VAL/DEP/CHG/UNK` rather than claiming a green light proves the machine safe.

**No physical exercise:** Do not actuate or defeat installed guards to complete this card. A later controlled validation must use qualified personnel, manufacturer instructions, isolated hazards and approved machine-specific test plans.
