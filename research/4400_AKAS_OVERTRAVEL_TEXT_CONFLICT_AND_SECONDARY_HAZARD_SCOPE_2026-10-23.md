# 4400 — AKAS-5M overrun text discrepancy and hazards outside the laser field

**Date:** 2026-10-23 UTC. **Status:** DOC-CONFIRMED TEXT DISCREPANCY + DOC-CONFIRMED hazard-scope limitations; no selected-machine TEST-CONFIRMED evidence. **Not a parameter recommendation.**

## Two different numbers in the *same* manufacturer manual

Source: Fiessler, *AKAS-5M Operating Instructions*, document 1581, revision 15 February 2024, https://www.fiessler.de/default-wAssets/docs/download/AKAS/bdh-akas-5-original-engl-doc1581-v1.0.pdf . Both passages were checked against rendered PDF pages, not merely OCR:

- Printed **p.5** (PDF index 4), Safety Instructions §2.1 item 4, describes a **13 mm** maximum allowable overrun and says fast speed must be reduced if a result among ten consecutive measurements exceeds **13 mm**.
- Printed **p.14** (PDF index 13), Mounting §5.2 step 1a, says fast speed must be reduced if the **results of ten consecutive measurements** exceed **11 mm**. Unlike p.5, this wording does not clearly say whether one or all of the ten results triggers the instruction. The adjacent Table 14/1 maps multiple dip-switch adjustment positions to different allowable overrun-related distances; the table's first two rows include 13 mm and 11 mm.

**DOC-CONFIRMED:** the text presents two different fast-speed-reduction numbers, 13 mm and 11 mm, for the named AKAS-5 family, and different/ambiguous wording about the ten measurements. **UNKNOWN:** whether this is a typo, a conservative setup margin, an unstated product/setting distinction, or a different acceptance context. The discrepancy is not resolved by taking the larger number, averaging them, assuming the stricter value is universally applicable, or copying a number into a different product. Exact selected catalog/revision, adjustment position, actual machine stop/overrun, tool geometry, manufacturer clarification and applicable machine standard must be reconciled before engineering acceptance.

**Practical consequence:** add a `BND/UNK` entry citing both pages, flag any proposed numeric stop/overrun criterion as **NOT FROZEN**, and block a machine release that relies on the unverified number. The appropriate independent machine-level witness and justified acceptance criterion remain required. This is a documentary source conflict, not a measured failed stop.

## Laser coverage is not a complete hazard boundary

The same manual, printed **p.4** (PDF index 3), explicitly states that light barriers do not protect against machine-caused flying objects. It also warns about a fast-engagement interval before punch/matrix closure and loss of front-beam protection during box bending. Printed **p.5** includes illustrations and warnings that AKAS does not protect against certain squeeze/workpiece-motion scenarios.

OSHA, *Machine Guarding eTool — Powered Press Brakes*, https://www.osha.gov/etools/machine-guarding/presses/powered-press-brakes , separately identifies moving workpieces, part-to-slide pinch points and accidental foot-pedal actuation as hazards. **DOC-CONFIRMED:** a laser protective field for the bending line is not evidence that these other hazard paths are controlled.

### Hazard partition for the cumulative package

| Hazard / exposure | Laser evidence relevant? | Separate `HAZ/PHY/SRS/VAL` proposition required |
|---|---|---|
| Finger reaches active bending line | Potentially, only within selected active field, geometry and mode | Actual reach, active beam/blanking state, stop/overrun and safety output/final element |
| Box side flange enters deliberately muted field | No protective credit for the suppressed elements | Operator hand position, side/tool geometry, alternate safety-related protection and actual motion |
| Large sheet rotates/lifts and sweeps operator/helper | Laser interruption alone does not establish protection | Workpiece trajectory/clearance, helper position, handling/support measures and task controls |
| Sheet/part pinches against slide or frame | Not automatically covered by die-front field | Part/tool/ram clearance and separately justified guarding or exclusion |
| Part or tool fragment is ejected | Manufacturer explicitly disclaims flying-object protection | Containment/physical guard, tooling integrity and exclusion as justified |
| Foot control is accidentally actuated | Laser alone cannot establish start-prevention design | Guarded control, safety/start logic and independent reset/restart proposition |
| Maintenance with stored pressure/gravity | No; production optical safeguard is not energy isolation | Lockable isolation, depressurization/reaccumulation verification and load restraint |

**INFERENCE:** an HMI label `laser healthy` encourages unsafe scope creep if the hazard register does not explicitly list these non-laser hazards. Design the interface to show the limited function and keep diagnostics separate from personnel-safety authority.

## Adversarial field-review prompts (NOT RUN)

1. A test rod demonstrates laser interruption at the tool, but a large workpiece rotates upward toward the operator. Which safety proposition remains untested?
2. The operator moves a helper into the sweep area during a box bend. Why is the OSSD state not an occupancy or workpiece-motion witness?
3. A technician uses 13 mm from printed p.5 while a second technician uses 11 mm from p.14. What records and source clarification are required before accepting a stopping-distance/blanking design? Do not select a number here.
4. The muting lamp is on and a finger is near the die. Which protection has deliberately been removed, and what independently engineered protection is required for the actual mode?
5. A controller reports correct valve feedback while ram motion or stored pressure contradicts the expected safe state. Which physical proposition wins, and why must release be blocked?

## Evidence classification and next source gate

- `DOC-CONFIRMED`: exact 13/11 text discrepancy in one Fiessler manual; separate manufacturer flying-object/box-mode limitation; OSHA workpiece and foot-control hazards.
- `INFERENCE`: discrepancy can lead to a false parameter freeze; one green laser status may conceal other hazards.
- `UNKNOWN`: intended distinction between the two overrun statements; actual installed variant/dip setting; measured machine overrun; workpiece/guard geometry; physical hydraulic holding; safety integrity/acceptance.
- `TEST-CONFIRMED`: **none**. No hardware, simulation, or proof test was run.

The open source question is suitable for manufacturer clarification or an exact selected-machine documentation package, **not** for generic simulation. No hazardous operation with people exposed until the machine-specific minimum safe-to-operate propositions are independently established. An isolated remote experiment still requires a separate residual-risk assessment.
