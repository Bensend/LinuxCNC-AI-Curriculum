# 4400-TK-01 — Trapped-key exchange, personal occupancy keys and hazardous-energy isolation
**Original manufacturer-document inspection | 2026-10-25 | DOC-CONFIRMED within edition; no machine test**

## Engineering question
Does the physical return of an isolation key prove that a multi-door hazardous zone is unoccupied, de-energized and safe to restart? **No**: a correct key exchange can constrain a *specified* sequence, but only the complete selected topology, actual isolation, all-person accountability and final-element/energy proof can support those separate claims.

## Original sources inspected
1. **Castell X Key Exchange Box**, Sentric Safety Group, *U-X-01-E Issue 7 (05-25)*, five-page original manual, pp. 1–3: https://www.sentricsafetygroup.com/us/wp-content/uploads/sites/2/2025/08/castell-x-sentricmay-25.pdf . Direct PDF inspection. p.1: one free isolation key inserted/trapped to release three access keys; isolation key cannot be removed until all three are returned. p.3: illustrative KS key switch → X box → AIE access interlocks, explicitly an integrated safety system. p.2: competent installation, anti-tamper mounting, six-month inspection and verify key removal only in intended conditions. The manufacturer's **component** PLd/B10d values on p.3 are not an achieved machine PL.
2. **DOLD SAFEMASTER STS Design Guide**, original 20-page manufacturer guide hosted by AutomationDirect, pp. 2–3, 6, 10–11: https://cdn.automationdirect.com/static/manuals/trappedkey/designguide.pdf . Direct PDF inspection. p.2: STS mechanical/electromechanical fault detection can block access/restart at the next demand; manufacturer discusses architecture-specific diagnostic coverage and CCF, not automatic proof for a new installation. p.3: STS personal keys are mechanically monitored and distinguished from ordinary unmonitored blocking keys; workers can carry personal keys during whole-body entry. pp. 10–11: examples combine multiple gates, escape routes, keys and safety modules; example risk ratings are *not transferable* to OpenPressBrake.
3. **OSHA 29 CFR 1910.147**, official current online regulation, paragraphs (d)(3)–(6), (e), (f)(1), (f)(3)–(4): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 . Direct official text. For covered servicing, each energy-isolating device, stored energy, verification, individual/group employee control and shift handover matter. A trapped-key operating interlock is **not automatically** the worker's personal LOTO lock, nor does return of an access key satisfy all isolation verification.
4. **ISO 14119:2024**, official publisher scope (not full normative text): https://www.iso.org/es/contents/data/standard/07/59/75942.html . Publisher confirms the edition covers trapped-key interlocking devices/systems and reasonably foreseeable defeat. Do not attribute specific normative clauses without the standard.

## Exact sequence and its limits
The original X-box example defines:
- **K0**: isolation key at the isolator, exchange keys trapped, access locks closed.
- **K1**: isolation key released from the *correctly operated* isolator, exchange keys still trapped.
- **K2**: isolation key inserted/trapped at X, access keys released.
- **K3**: one or more access keys in door locks, hazardous-area entry possible.
- **K4**: all access keys returned to X; isolation key may be withdrawn and returned to the isolator.

**DOC-CONFIRMED**: this sequence is an example of a correctly configured X-box. **INFERENCE**: it constrains key possession and normal operator order. **NOT ESTABLISHED**: which energy sources actually opened; whether contactors/valves physically changed state; whether the zone contains people; whether every person retains an independent personal key; whether a duplicate key or defeated actuator exists; whether a stored hydraulic accumulator, elevated ram, spindle coast or adjacent machine remains hazardous.

## Failure-path adversarial audit
| Fault or shortcut | False claim to reject | Needed independent discriminator |
|---|---|---|
| One isolator key covers only main motor; hydraulic pressure remains | "The X-box has all keys, so all energy is off" | Complete energy-source map, qualified isolation/bleed/hold verification |
| Two workers enter on one access key, one exits and returns it | "All keys returned proves zero occupancy" | One-person-one-personal-key architecture or equivalent qualified occupancy/accountability method |
| Duplicate/borrowed/uncoded key or spare kept at panel | "Mechanical sequence cannot be bypassed" | Key-code register, controlled spares, audit of actual locks and physical noninterchangeability |
| Gate actuator removed or mechanically defeated | "Locked key means the guard physically encloses the area" | Qualified as-built guard/actuator/defeat inspection |
| Ram gravity load or pneumatic/vacuum payload after isolator OFF | "Deenergized means safely supported" | Independent load-restraint and stored-energy proof |
| Technician requires short powered positioning during maintenance | "Key can be reinserted with colleagues inside" | OSHA covered-work temporary test/re-isolation transaction, every person accounted for |
| Power returns while all keys have been returned | "Permission equals a new start" | Independent safety reset/EDM/occupancy and **new** normal start, no retained motion |
| Door key cannot be returned because guard is awkward to align | "Just leave a spare in the lock" | Rework hinge/handle/guard alignment, maintenance access and visible fault diagnosis |

## Practical human-factors architecture
Prefer a clearly labeled, captive, easy-to-operate isolator and X-box physically adjacent to the access path, with a documented key map; hinged aligned guards and inside escape; individual personal keys/locks where the task demands them; conspicuous key accounting; no undocumented spares; and diagnostics that tell the technician **which** gate/energy boundary is blocking restart. Avoid a process so slow or fragile that users routinely defeat it. A key interlock cannot replace a physically adequate guard or an energy-removal mechanism.

## Cross-machine transfer, not installation claims
Press brake: multiple rear/side access doors and backgauge energy may be exchange-controlled, but Y1/Y2 independent hydraulic stop, gravity hold and residual pressure still require distinct proof. Mill/lathe: spindle run-down and tool/chuck retention remain distinct. Robot cell: every worker must have a reliable personal exclusion mechanism and a way out; upstream E-stop reset must not trigger downstream restart. Conveyor/woodworking: multiple isolated drives and pneumatic devices may need more than one upstream key.

## Evidence ledger / stop
- **DOC-CONFIRMED**: Castell Issue 7 physical key-exchange sequence, DOLD personal-key design concept, OSHA energy-control requirements.
- **SOURCE-CONFIRMED**: no LinuxCNC source trace needed for this mechanical topic.
- **TEST-CONFIRMED**: none; no selected-machine test.
- **COMMUNITY-REPORTED**: none relied upon.
- **INFERENCE**: proposed failure paths, ergonomic improvements and independent architecture.
- **UNKNOWN**: exact selected locks/keys/isolators, duplicate policy, employee count, guard/energy map, stop/hold, PL/SIL, restart and measured performance.
- **No physical release**: G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 independent evaluation OPEN. No personnel-exposed operation.
