# 4400 — Reset, power return, EDM and welded final-element contacts: original OEM source audit
**2026-10-24 | SOURCE-READING | NOT SELECTED-MACHINE VALIDATION**

## Concrete engineering question
Can a restored 24 V supply, a held reset button, or a healthy-looking safety relay automatically restore hazardous motion permission? Does feedback from a contactor prove that the physical hazard has stopped? What distinguishes reset eligibility, safety-output rearming, and a separate machine-cycle start?

## Original manufacturer sources actually inspected
1. **Pilz**, *PNOZ X3P Operating Manual*, 20899-EN-13, 30-page original PDF, https://www.pilz.com/download/open/PNOZ_X3P_Operating_Manual_20899-EN-13.pdf — PDF pp. 6, 8, 10, 12–16 (printed pp. 6, 8, 10, 12–16). Exact model: **PNOZ X3P**, not every PNOZ X3 or other relay.
2. **Rockwell Automation**, *Guardmaster Safety Relay CI Installation Instructions*, 440R-IN046, issue 2 **June 2012**, original four-page manufacturer PDF, https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440r-in046_-mu-p.pdf — PDF p. 2 (zero-based P1), English reset and feedback text.
3. **Rockwell Automation**, *Guardmaster Safety Relay DI Installation Instructions*, 440R-IN037, issue 1 **April 2011**, original four-page manufacturer PDF, https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440r-in037_-mu-p.pdf — PDF p. 2, English reset/feedback and input-wiring variant text.
4. **OSHA**, 29 CFR 1910.212(a), https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212 — official guarding text; this regulation is **not** an electrical relay application diagram. OSHA 1910.217(b)(8)(iii) explicitly addresses power-return motor restart for *mechanical power presses*, but 1910.217(a)(5) excludes press brakes. Do **not** transplant the mechanical-press-specific clause to a press brake as if it were its direct standard.

## Findings with exact scope

### Pilz: automatic start is not monitored start
**DOC-CONFIRMED — PNOZ X3P, printed p. 10:** automatic-start mode activates after its input circuit closes. Monitored-start mode requires the input circuit closed and a start-circuit closure after its waiting period. The manufacturer timing diagram distinguishes the two. **Printed p. 14** warns that automatic start can energize when the safeguard is reset (including E-stop release), and calls for external measures to prevent unexpected restart. Thus a selected machine must establish whether the relay mode is automatic or monitored and whether an **independent new cycle-start demand** is required. This is not a claim that every automatically reset safety relay necessarily moves a machine: the downstream machine control and final elements matter.

**DOC-CONFIRMED — PNOZ X3P, printed pp. 8, 12:** three N/O safety contacts 13–14, 23–24, 33–34 are distinct from auxiliary N/C 41–42 and semiconductor status Y32. Pilz explicitly prohibits use of 41–42 as a safety circuit. A PLC/HMI lamp wired to Y32 cannot substitute for actual contactor/valve/ram proof.

**DOC-CONFIRMED — PNOZ X3P, printed p. 15:** manufacturer says relay mechanical contacts cannot be automatically checked while switched ON; it specifies periodic off/on cycling to permit diagnostic checking, with different model/application inspection frequencies, and qualified testing after commissioning or machine change. Those particular frequencies are **not** universal inspection intervals for OpenPressBrake. Printed p. 16 says welded contacts prevent reactivation after the input circuit opens. This is a fault-response statement for the documented relay, not a promise that a downstream welded contactor cannot remain energized.

### Rockwell: a reset configuration can create power-up rearm
**DOC-CONFIRMED — Guardmaster CI 440R-IN046 p. 2:** reset configuration AM (automatic/manual start) has **no reset edge detection**. When safety inputs and reset circuit are closed at power-up, the unit can function after startup delay. In MM (manual monitored reset), the circuit must close and reopen within the manufacturer's **250 ms to 3 s** window; these values belong to this exact product. A valid reset also requires the feedback circuit closed; external actuator feedback contacts are placed in series with A1–S34. This demonstrates why a **stuck reset** or wire link is materially different under AM and MM. It does **not** show that the downstream machine moves: separate normal start must be inspected.

**DOC-CONFIRMED — Guardmaster DI 440R-IN037 p. 2:** the same AM/MM distinction exists (named T/R in its text), and the product's input cross-fault monitoring depends on wiring. Dual-channel four-wire arrangements can provide detection, whereas the manufacturer says it is disabled for single-channel, dual-channel three-wire and external 24 V signal variants. A 'dual-channel' label alone is therefore insufficient to infer diagnostic coverage. The DI manual also distinguishes auxiliary PNP Y32 from safety outputs.

### Distinct propositions required for machine safety
| Proposition | Example evidence | What it does **not** prove |
|---|---|---|
| Protective device has been restored | Independent input contact / ESPE OSSD states | No person inside, or actual stop/hold |
| Safety relay has reset/rearmed | Exact model, wiring, mode, event sequence, safe output terminal | Separate new motion start, or physically deenergized load |
| EDM feedback is eligible | Properly selected positively guided/mirror auxiliary contact and validated wiring/feedback transition | The entire hydraulic/mechanical load path safe; all welded failure modes detected |
| Final element actually interrupted | Qualified electrical/hydraulic inspection, appropriate independent witness | Gravity load supported, stored pressure discharged, or whole-body area clear |
| New machine cycle deliberately requested | Fresh operator command after reset and verified safe conditions | A safety PLC alone grants safe-to-operate status |
| Physical hazard controlled | Machine-specific independent stop, hold, guard, energy-isolation and validation evidence | Can be inferred from a green HMI status bit |

**INFERENCE:** For a press brake, power return while LinuxCNC retains a commanded axis state, stale normal-control outputs, or a held pedal is a foreseeable adversarial commissioning scenario. The specific outcome depends on as-built wiring, controller initialization, valve deenergized positions, independent safety logic and final-element mechanics; no outcome or hydraulic truth table is asserted here.

## Failure-path review (reasoning, not physical test)
1. **Power dips with guard/E-stop inputs closed:** in documented Rockwell AM mode, reset may become eligible without a new edge. The selected design must require a deliberate new cycle command independent of rearming, and must establish physical hold during outage and restoration.
2. **Reset button welded or deliberately tied high:** Rockwell MM's edge/timing requirement can reject the static state; AM lacks that detection. Never assume a particular configuration or pin map without exact readback.
3. **External contactor welded:** a properly designed EDM feedback path can prevent a subsequent rearm, but only after the applicable transition/diagnostic opportunity. A contactor still closed at the moment of a stop may be hazardous despite a relay fault or later lockout.
4. **Auxiliary feedback shorted/bypassed:** a green EDM indication is not independent proof of actual final-element state. Inspect the circuit topology, contact type, common-cause routing and safe test evidence.
5. **Normal LinuxCNC/UI resets itself:** its startup/servo-enable state may be useful diagnostics but must not provide independent personnel-safety authority. A successful GUI startup is not a safe restart witness.
6. **People inside a guarded area:** reset/rearm must not be mistaken for area-clearance or automatic cycle-start authorization. Provide reset location/visibility, trapped-person escape and occupancy review appropriate to the machine.

## Transfer to other machines
- **Press brake:** distinguish hydraulic stop/hold, ram gravity, dual Y1/Y2 and fresh pedal/cycle start; a generic relay wiring diagram is insufficient.
- **Mill/lathe:** spindle coastdown, chuck/workholding and toolchanger energy remain after a safety output drops.
- **Robot/cell:** guard restoration may occur with a person inside; deliberate separate reset and start plus whole-body entry controls matter.
- **Plasma:** torch HV and gas/air isolation are separate from axis motion.

## Provenance ledger
| Claim | Class | Boundary / next proof |
|---|---|---|
| PNOZ X3P automatic and monitored start differ; automatic can rearm on safeguard reset | DOC-CONFIRMED | Original 20899-EN-13 pp. 10, 14; selected mode UNKNOWN |
| PNOZ X3P 41–42 auxiliary not safety-rated; Y32 is status | DOC-CONFIRMED | Original pp. 8, 12; physical outputs UNKNOWN |
| PNOZ X3P periodic off/on diagnosis and welded relay reactivation inhibition | DOC-CONFIRMED | Original pp. 15–16; external contactor behavior UNKNOWN |
| Rockwell CI AM has no edge and can rearm on power-up; MM has timed reset sequence | DOC-CONFIRMED | Original 440R-IN046 p. 2; selected wiring UNKNOWN |
| Rockwell DI cross-fault coverage varies with connection | DOC-CONFIRMED | Original 440R-IN037 p. 2; achieved PL/diagnostic coverage UNKNOWN |
| OpenPressBrake uses these devices or modes | UNKNOWN | No as-built selected evidence; do not assert |
| Reset/rearm physically stops/holds OpenPressBrake Y1/Y2 | UNKNOWN / NOT TEST-CONFIRMED | Qualified physical VAL/PT required |
| Separate start and safety reset reduce unexpected motion risk | INFERENCE supported by OEM warnings | Verify selected wiring and actual power-return behavior |

## Information-gain and lab decision
These original manuals answer the generic mode/EDM questions without simulation. **No test dispatched.** Only freeze a bounded software test if an unresolved, version-specific normal-control startup question affects a later safety interface specification; such a test would **not** prove personnel safety. Selected machine physical evidence and external fresh evaluation remain open. No personnel-exposed operation authorized.
