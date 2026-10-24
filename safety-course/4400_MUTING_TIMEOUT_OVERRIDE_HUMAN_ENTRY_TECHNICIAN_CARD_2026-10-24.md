# 4400-MUT-01 — 18 technician adversarial paper cases
**2026-10-24 | PAPER ONLY / NOT BLIND / NOT SCORED / NO PHYSICAL TEST.** For each case, state the hazard, the source-supported discriminator, the required as-built/physical evidence, and whether personnel-exposed operation is allowed. Do not invent timing, PL/SIL or hydraulic truth tables.

1. A SICK SP2 muting design claims its total timer always ends after 30 seconds; the config has not been read.
2. A SICK conveyor belt stops mid-load with muting active; technician expects a 4-second hold timer to continue counting.
3. Same stopped conveyor: a muting sensor changes state; technician asserts belt-stop means all state changes are ignored.
4. Two SICK sensors on receiver extension connection switch simultaneously; electrician treats the 50 ms stagger as universal to all connection variants.
5. SICK override button is accessible from inside the guarded cell and is held with tape to clear recurring jams.
6. The SICK override counter is set to five; operator power-cycles to retry after reaching the limit.
7. SICK auto protective-field-width measurement starts with a load obstructing the field; operator assumes 'end by ESPE' is effective immediately.
8. A Rockwell FSBM Maximum Mute Time is set to 0; programmer calls it 'zero seconds allowed.'
9. Rockwell FSBM Maximum Override Time is 0; integrator claims it cannot energize O1.
10. FSBM Input Status is false and faults are active, yet Override rises and O1 energizes; observer claims software impossibility.
11. A safety HMI shows a newly edited FSBM timer, but the safety controller has not been cycled through the required mode transition.
12. An FSBM automatic restart setting is enabled while someone may be hidden behind the light curtain.
13. Muting lamp is broken; integrator forces the FSBM lamp-status input true without an application review.
14. Four sensors are wired correctly, but a person can walk directly behind a pallet through the unguarded side gap.
15. An operator's recovery keyswitch is out of sight of the hazard; camera display is proposed as a substitute for actual qualified sightline and occupancy review.
16. A robot cell muting gate is copied to a press-brake front point of operation; Y1/Y2 gravity holding is unproven.
17. A safety designer cites IEC 62046:2018 as the 'current edition' in October 2026; the licensed 2026 normative text is unavailable.
18. After the pallet clears and the ESPE is restored, a retained LinuxCNC command requests immediate movement without a fresh operator start.

**No answer key here.** These cases are learner-readable and must not be used as a blind evaluator's hidden oracle. Reference the [SICK](../research/4400_SICK_DETEC4_HG_MUTING_BELT_STOP_OVERRIDE_TIMER_SOURCE_AUDIT_2026-10-24.md), [Rockwell](../research/4400_ROCKWELL_FSBM_ZERO_TIMER_OVERRIDE_AND_RESTART_SOURCE_AUDIT_2026-10-24.md) and [IEC edition](../research/4400_IEC_62046_2026_MUTING_WHOLE_BODY_STANDARD_EDITION_SCOPE_AUDIT_2026-10-24.md) audits. Physical stop/hold, access and restart are unverified; no personnel-exposed hazardous operation authorized.
