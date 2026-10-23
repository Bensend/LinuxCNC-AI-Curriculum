# 4400 — Temporary re-energization during maintenance testing: the forgotten safety transition
**Learner-facing technician/engineering exercise, 2026-10-23.** Not a machine-specific energization instruction or external blind evaluation key. All examples are hypothetical. **No physical test performed.**

## The failure path
A press brake is locked out for valve replacement. A technician needs to check valve actuation and ram behavior. The team temporarily restores energy, observes a healthy valve-feedback indicator, and resumes maintenance **without restoring personal energy controls**. Another operator sees a green LinuxCNC HMI and presses Cycle Start. An accumulator and elevated ram remain capable of hazardous motion.

The design error is not merely an incorrect valve signal: it is the **transition from maintenance isolation to authorized test and back**, with a missing personnel/exposure and stored-energy gate. A normal LinuxCNC E-stop, fault acknowledgment, or green GuardLink state does not provide maintenance LOTO authority.

## Authoritative source and scope
- **DOC-CONFIRMED:** OSHA 29 CFR 1910.147(f)(1), https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 , explicitly covers temporary removal of lockout/tagout for *testing or positioning* during servicing. It requires clearing tools/materials, removing employees from the area, authorized lock/tag removal, limited energization/testing, and **deenergizing/reapplying energy controls** before servicing continues. OSHA's own [testing tutorial](https://www.osha.gov/etools/lockout-tagout/tutorial/testing-machines) lists the same five phases.
- **DOC-CONFIRMED:** 1910.147(e)(1)–(3) addresses machine/area checks, employee clearance/notification and controlled removal of locks; 1910.147(d)(5)–(6) addresses residual/reaccumulating energy and isolation verification; 1910.147(f)(3) addresses group LOTO and individual protection.
- **DOC-CONFIRMED:** OSHA Appendix A to 1910.147 is an illustrative **nonmandatory** minimum procedure; it specifically includes springs, elevated machine members and hydraulic pressure as stored-energy examples. https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147AppA
- **INFERENCE:** the proposed explicit state/authority records below are an engineering documentation method, not verbatim OSHA-required field names. Applicability to a particular site/task and other jurisdictional requirements must be reviewed.

## Separate state and authority, not just a green light
| Engineering phase | People/exposure proposition | Energy/isolation proposition | Who may authorize transition | What LinuxCNC/HMI may do |
|---|---|---|---|---|
| `M0` Maintenance isolated | Authorized workers protected under machine-specific LOTO | All required energy sources isolated; residual energy controlled and verified | Authorized employees under documented procedure | Display diagnostic state only; ordinary control not safety authority |
| `T0` Pretest clearance | Personnel and tools removed from the machine area; independent exclusion maintained | Plan for test-only restoration and all stored-energy hazards reviewed | Authorized employee(s) and qualified test lead | Log requests, never infer area clear from software |
| `T1` Controlled test window | No person exposed to moving/pressurized hazard | Temporary reenergization limited to the approved purpose; selected safety architecture intact | Qualified authorized test team | May request ordinary motion **only if** independent protective system permits it |
| `M1` Return to maintenance | No reentry until personal protection restored | Deenergize, reapply isolation, control/recheck residual/reaccumulating energy and verify | Authorized employee(s) under LOTO | Show `NOT VERIFIED` until physical maintenance isolation proof |
| `P0` Production return | Machine area cleared, safeguards restored, affected people notified | Formal release from LOTO and separate selected-machine protective-function/restart checks | Authorized employee(s) and designated commissioning authority | Fresh deliberate start only after independent safety authorization |

**Never represent `T1` as a safe attended-production mode.** Its permissibility depends on a machine-specific exclusion, residual-risk and test plan. A retained Cycle Start or foot command must not initiate motion when transitioning through reset or restoration.

## Adversarial technician questions (answer from evidence, not intuition)
1. One authorized worker has removed a lock for the approved test; another crew member's personal lock is still on the group box. Can a generic HMI “Test” button override this? **No.** Establish the applicable group LOTO and personal protection procedure; do not bypass a remaining worker's lock.
2. A manifold pressure gauge is zero but the ram is elevated and an isolated accumulator chamber may remain pressurized. Can servicing resume? **No physical energy/isolation proof yet.** Identify and independently verify the relevant pressure zones and gravity restraint.
3. The test is complete and the safety relay reports Ready. Is it enough to reopen the work area? **No.** `M1` requires restored LOTO, residual-energy controls and verification before service reentry.
4. A technician must repeatedly remove a guard or awkward panel to observe the test, and colleagues routinely defeat it. Is retraining the only fix? **No.** Improve remote sensing, visible safe test points, guard mounting/captive hardware, safe observation and restoration workflow without weakening the independent protective function.
5. After final reassembly, an old foot-pedal command is still true. Can clearing E-stop initiate movement? **No.** Require a fresh intentional ordinary start and independent safety authorization; test the retained-command fault case using an approved remote/isolated plan.

## Evidence form — fill only from selected-machine data
| Stable family | Record before `T0` | Record before `M1` or `P0` |
|---|---|---|
| `BND/HAZ/ENE` | Exact task, personnel count, exclusion zone, pressure/gravity sources | Actual machine/zone configuration after test |
| `SF/SRS/PHY` | Required safe stop/hold/energy control and selected acceptance basis | Independent stop/hold/pressure/escape/maintenance isolation propositions |
| `AUTH/ARC` | Authorized employees, independent safety controller, selected physical final elements | Individual lock ownership and safe rearm authority |
| `DEP/CHG` | Shared pilot/power/feedback and temporary configuration changes | Changes marked STALE until relevant validation repeated |
| `VAL/PT` | Approved test purpose, calibrated independent witness and no-person-exposure method | Test results, LOTO restoration and physical verification; **NOT RUN** here |
| `HF/UNK/RR` | Guard-removal temptation, awkward diagnostic steps, residual risks | Guard correctly restored, maintenance reentry controls, unresolved facts |

**Stop rule:** if a required energy source, load restraint, physical safeguard or worker location is unknown, the transition is **HOLD**. Do not expose people to an unproved hazard. Any necessary machine experiment must be designed for remote/isolated operation with all people outside the danger zone and qualified energy controls. Do not invent hydraulic truth tables, stopping distances, PL/SIL or pressure thresholds.

## Transfer exercise
Apply the same `M0 → T0 → T1 → M1/P0` reasoning to a lathe with stored spindle inertia, a mill with vertical Z gravity load, a plasma table with electrical/thermal/fume hazards, and a robot cell with stored pneumatic energy. **The state reasoning transfers; the selected energy-isolation hardware and physical witness do not.** Every machine requires its own as-built evidence and applicable safety requirements.

Related: [selected-machine physical witness intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md), [accumulator protective-cycle to maintenance transition](4400_ACCUMULATOR_SAFE_CYCLE_TO_MAINTENANCE_TRANSITION_EXERCISE_2026-10-22.md), and cumulative [Safety Design Package](SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md) §11M. Source provenance: `DOC-CONFIRMED` for OSHA requirements; `INFERENCE` for this generic state machine; installed details `UNKNOWN`; physical `TEST-CONFIRMED` **none**.
