# 4400-PEDAL-01 — Technician decision card and selected-machine blank witness
**2026-10-25 | 18 PAPER cases | UNEXECUTED / UNSCORED | no hazardous machine operation authorized**

Use with [module](4400_PEDAL_01_THREE_POSITION_OVERTRAVEL_UNLOCK_AND_FRESH_START_MODULE_2026-10-25.md) and [original OEM source audit](../research/4400_FOOT_PEDAL_LATCH_UNLOCK_PULSE_IK_RELEASE_VARIANT_OEM_AUDIT_2026-10-25.md). No hidden answer key is included. For every case record: (a) hazard/exposed person, (b) ordinary versus independent safety authority, (c) STOP/HOLD/RESTART/ENERGY proposition, (d) precise DOC/SOURCE/TEST/INFERENCE/UNKNOWN class, (e) minimum no-energy evidence and next qualified witness, (f) PASS/HOLD/UNKNOWN. A plausible story is not physical proof.

## 18 novel PAPER scenarios
1. A Schmersal UEDR pedal has been pressed through and mechanically latched. An operator presses its blue unlock while the ordinary LinuxCNC cycle-start bit remains true. What new electrical event does the OEM warn about, and what must *not* follow from it?
2. A technician says a 50 ms debounce will remove the unlock hazard. What evidence would be needed to justify any timing value? Does debounce alone solve retained-command restart?
3. A replacement footswitch has 1 NO and 1 NC, exactly like the old one, but its part suffix is different. What four differences must be reconciled before accepting it?
4. A steute IK article 1441615 product sheet says no release impulse. Does this prove the safety relay cannot automatically re-enable on release or that a ram cannot drift?
5. A Fiessler right pedal working contact returns to rest after overtravel. A maintainer connects only that working contact to the ordinary controller and ignores the separate safety contact. What physical and functional evidence is now missing?
6. A two-pedal enclosure has one non-safety left pedal for UP/mode and a safety right pedal for DOWN. Why is the enclosure not evidence of two-hand safeguarding?
7. The machine shows "E-stop released" while the three-position pedal remains latched. Which reset/authorization propositions remain unresolved?
8. A pedal is clean and electrically healthy, but its shield is too awkward to reach while supporting a large sheet. Operators begin wedging the cover open. Propose a task-level redesign without weakening protection.
9. The normal LinuxCNC motion enable falls to zero during overtravel. The hydraulic ram nevertheless creeps downward. What is the proper release decision and what separate witnesses are needed?
10. The safety relay has an automatic-start option, and its contacts appear healthy on a bench. The installed machine retains a previous DOWN command. Explain why relay health does not prove fresh-start prevention.
11. A replacement changes from a mechanically latched overtravel stop to a release-resetting variant. The wiring diagram seems similar. What change-control evidence is now stale?
12. A stuck footswitch remains in its working range when power returns. A green HMI lamp appears. What must prevent movement independently of the HMI?
13. An operator lifts a foot from a pressed-through pedal and the contact appears to pulse briefly during return. Is this evidence of an OEM defect, a normal variant behavior or a safety failure? What additional source/part evidence is needed?
14. A machine has a rear helper who cannot see the front foot pedal. Does an independent pedal overtravel function by itself protect the rear backgauge/sheet-sweep hazard?
15. The right pedal commands DOWN, the left pedal commands UP. An emergency-rescue instruction refers to UP while E-stop is active. Why must the selected mode/state/rescue authority be proven rather than assumed?
16. A machine is locked out electrically but an accumulator and gravity-loaded beam remain. Can footswitch maintenance begin solely because pedal contacts read open?
17. An operator reports that dust/debris prevents full pedal return once per shift. What inspection/cleaning design and change-management actions reduce predictable bypass incentives?
18. An independent evaluator supplies a novel contact-state diagram with no part number. Can the learner conclude whether unlock produces a start pulse, which contacts are safety-rated, or whether personnel-exposed operation is acceptable?

## Blank no-energy selected-device transition evidence
**Do not fill from catalog assumptions.** Qualified owner records exact installed variant and signs off before any later physical test plan.

| Field | Selected-machine entry |
|---|---|
| Machine identity / revision / permitted mode | **UNKNOWN** |
| Pedal maker, full part suffix, drawing revision, photo | **UNKNOWN** |
| Normal-command contact(s) and wiring revision | **UNKNOWN** |
| Safety-contact(s), input channels, monitoring configuration | **UNKNOWN** |
| Mechanical overtravel/latch/unlock behavior | **UNKNOWN** |
| OEM explicit release/unlock impulse statement and applicability | **UNKNOWN** |
| Selected safety controller, reset/rearm config and signature | **UNKNOWN** |
| Retained LinuxCNC/FPGA commands and reset arbitration | **UNKNOWN** |
| Independent stop final elements and feedback targets | **UNKNOWN** |
| Independent Y1/Y2 stop and gravity HOLD witnesses | **UNKNOWN** |
| Front/rear/backgauge/sheet-sweep protection | **UNKNOWN** |
| Hydraulic/gas/gravity maintenance isolation and restraint | **UNKNOWN** |
| Operator/maintainer usability and bypass incentives | **UNKNOWN** |
| Qualified reviewer and G0 packet IDs/revisions | **UNKNOWN** |
| No-energy review decision and residual unknowns | **HOLD** |
| Isolated physical VAL/PT plan approved? | **NO / NOT RUN** |
| People-exposed release authorized? | **NO** |

### Adversarial no-energy decision gates
| Gate | Evidence question | Current status |
|---|---|---|
| D1 | Is exact pedal part/suffix and its OEM contact-state document known? | UNKNOWN |
| D2 | Are normal versus safety contacts independently mapped? | UNKNOWN |
| D3 | Is overtravel, release, mechanical unlock and fault behavior explicitly specified? | UNKNOWN |
| D4 | Does the receiving safety logic reject unlock impulse, held reset and stale normal demand? | UNKNOWN |
| D5 | Is reset distinct from new deliberate cycle start? | UNKNOWN |
| D6 | Is mode-dependent UP/DOWN/RESET authority unambiguous? | UNKNOWN |
| D7 | Are input faults, common cable and stuck contacts handled by selected architecture? | UNKNOWN |
| D8 | Are final stop/hold elements and independent physical witnesses identified? | UNKNOWN |
| D9 | Are front/rear/side helper and sheet-sweep hazards separately protected? | UNKNOWN |
| D10 | Are guarding, ergonomics, debris cleaning and repair workable without defeat? | UNKNOWN |
| D11 | Is energy isolation/rescue separate from footswitch/E-stop state? | UNKNOWN |
| D12 | Have exact selected change/revision, qualified reviewer and physical plan been approved? | UNKNOWN |

**Release:** Any missing essential D1–D12 keeps G0 documentary readiness **HOLD**. G1 isolated-test permission is distinct, G2 physical proof NOT RUN, G3 people-exposed operation NOT AUTHORIZED, G4 maintenance-entry authority NOT AUTHORIZED. No live human entrapment, unguarded movement or intentional shorting of safety contacts. Experimental operation only under separately approved remote/isolated controls with everyone outside danger zones and documented residual risk.

## Evidence integrity
All scenarios are hypothetical **INFERENCE** exercises. OEM contact statements are **DOC-CONFIRMED** only for cited exact variants; no **TEST-CONFIRMED** selected machine, no independent learner score, no source-specific LinuxCNC code trace in this module. The blind external evaluator must hold out answers before learner commitment; this worksheet is not a scored test result.
