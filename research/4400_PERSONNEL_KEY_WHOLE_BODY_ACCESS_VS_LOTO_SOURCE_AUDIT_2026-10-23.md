# 4400 — Personnel keys, trapped-key access, and the separate maintenance-isolation boundary

**2026-10-23 UTC | Original learner-facing source study | 2590 / 25F0 / 4400.** Not an exact publication of the staged 85-file archive; not a selected-machine design, machine validation, compliance certificate, or blind evaluator key. This study answers a new cross-domain question: **what does an in-hand personnel key actually prevent, and what remains unproven?**

## Sources inspected and limits

| Evidence | Confirmed narrow content | What it does not establish |
|---|---|---|
| **DOC-CONFIRMED** — Fortress Safety, *Understanding Trapped Key Systems*, 2024-03-18, https://fortress-safety.com/news/understanding-trapped-key-systems/ | Distinguishes energy-control key, key-exchange device, guard access lock and personnel key; documents a forced order of key transfers. | A key-operated *control switch* is not automatically a physical energy-isolating device; neither is a key exchange proof of stopped motion. |
| **DOC-CONFIRMED** — Fortress Safety, *Unexpected Start-Up Prevention with Proactive Inhibit Functions*, 2024-08-07, https://fortress-safety.com/news/unexpected-start-up-prevention-with-proactive-inhibit-functions/ | A carried personnel key prevents resetting the described interlock while withheld; multiple keys can serve multiple entrants. | Presence, safe escape, physical stopping, all-energy isolation, and actual absence of people are not measured by the key alone. |
| **DOC-CONFIRMED** — Fortress, *Controlled Access in an Automotive Production Cell with Multiple Entry Points*, https://fortress-safety.com/application/controlled-access-in-an-automotive-production-cell-with-multiple-entry-points/ | Worked application: one energy-control step, key exchange, four guarded access points; personnel key is **optional** in this particular example. | A generic installation cannot copy the sequence without selected energy paths, stopping/holding and whole-body-access review. |
| **DOC-CONFIRMED** — Rockwell, 440T-MDSLE11ABCE configurator cut sheet, https://configurator.rockwellautomation.com/api/Product/440T-MDSLE11ABCE/cutsheet | The single-key Slamlock is described for access without whole-body entry; dual-key variant has a secondary key that can be used as a personnel key. | A secondary key on another model is not automatically interchangeable or an individually assigned maintenance lock. |
| **DOC-CONFIRMED** — EUCHNER CKS key-adapter product page, https://www.euchner-usa.com/en-us/products/transponder-coded-read-heads-with-external-evaluation/cks-key-adapter/ | Coded key + adapter + CES evaluation; removing the key can prevent a restart even if a guard is inadvertently closed, **when integrated as described**. | Product-family Cat.4/PL e capability does not establish the achieved machine safety-function integrity, isolation or occupancy. |
| **DOC-CONFIRMED (public scope only)** — ISO 14119:2024, https://www.iso.org/standard/75942.html and ISO 14118:2017, https://www.iso.org/standard/66460.html | Interlocking/trapped-key selection and unexpected-start prevention are distinct standards topics. ISO 14118 scope includes electrical, fluid, gravity and other stored/external energy. | Full licensed technical clauses were **not inspected**; no specific PL/SIL, timing, key-retention force or architecture is asserted from their abstracts. |
| **DOC-CONFIRMED from OSHA indexed regulation** — 29 CFR 1910.147(b),(d),(e),(f)(3), https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 and OSHA group-LOTO explanation https://www.osha.gov/etools/lockout-tagout/hot-topics/group-lockout-tagout/procedures | Energy-isolating devices physically prevent energy transmission; control-circuit switches do not qualify merely because lockable; stored energy and each authorized group employee's personal control require separate treatment. | OSHA direct open returned 403 in this session; indexed official text was reviewed, not a site-specific legal determination or substitution approval. |

## The four different propositions — do not compress to a single “key safe” bit

1. **Sequencing:** a selected mechanical key exchange can constrain which access lock is operable next. It says nothing about how fast a motor stops unless the preceding energy-control/safe-state condition is correctly implemented.
2. **Inhibit while occupied:** a selected, personally retained key can make rearming impossible **through that designed key path**. It is not a people counter, an emergency escape device, a guarantee against a duplicate/spare/bypass key, or proof that the entire cell is empty.
3. **Physical hazard termination:** an independent safety-related control system and final elements must achieve the required stop/hold/access propositions. Motor coast, robot residual motion, gravity-loaded press-brake ram, hydraulic accumulator and stored electrical energy must be allocated separately.
4. **Maintenance energy control:** when OSHA 1910.147 applies, a safety-interlock key or lockable E-stop does not substitute for the required energy-isolating device, residual-energy control, verification, and each authorized worker's lockout participation. A mechanical trapped-key device **could** form part of an isolation arrangement only if the actual selected device and energy path satisfy that role; do not classify it by the presence of a key.

**INFERENCE design freeze:** `PERSONNEL KEY RETAINED != ALL HAZARDOUS ENERGY ISOLATED`; `ALL ACCESS KEYS RETURNED != GUARDED SPACE VERIFIED EMPTY`; `GUARD CLOSED != DELIBERATE RESTART`; `KEY SWITCH OFF != PHYSICAL ENERGY-ISOLATING DEVICE PROVED`.

## Example architecture with separate authorities (not a wiring prescription)

`guard access demand -> independent safety controller -> qualified stopping/holding final elements -> independent physical safe-state witness -> key-release permission -> access lock -> personal retained key -> exit and key accounting -> deliberate reset -> fresh ordinary cycle-start`.

The ordinary LinuxCNC/FPGA may request stop, report key/door status, or display diagnostics. It must not itself decide personnel-safe key release or override the independent safety inhibit. A local key switch on an HMI is ordinary access control unless a selected safety architecture and actual final-element path prove otherwise. **No generic key-release-on-timer or key-release-on-command** is accepted for a hazard with unknown coast/hold behavior.

## Adversarial failure paths and field design

| Scenario | Plausible wrong shortcut | Required design/evidence response |
|---|---|---|
| Two workers enter, but only one removes a personnel key | One worker leaves and returns it while the other is hidden behind tooling | Per-person key/individual control strategy appropriate to the task; independent exit/accountability and restart procedure; whole-body entry review. Do not claim keys alone count people. |
| Guard is shut from outside while worker remains inside | “Closed” indicator is mistaken for empty zone | Retained key inhibits rearm on selected path; separately review escape, blind spots and alternative entrances. |
| A duplicate/spare key exists or key is lost | Maintenance uses an unofficial replacement, or bypasses an awkward sequence | Key coding/issuance inventory, change-control, keyed captive parts, simple replacement process, controlled recovery that does not permit a hazardous restart. |
| Power fails with guard locked | Operator cannot escape, or lock opens before machine stops | Selected locking polarity, mechanical inside escape and independent stop/hold evidence; no live trapped-person demonstration. |
| Interlock key turns off a PLC output but pump/accumulator remains energized | “Key removed = isolated” | Map all electrical, hydraulic, pneumatic, gravity and residual zones; separate lockable isolators, pressure verification and load restraint for maintenance. |
| Robot cell has multiple gates, a press brake has rear access, a lathe has a coasting spindle | One generic access rule copied between machines | Distinct `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART` propositions and machine-specific witnesses. |
| A safety reset restores power and a held foot pedal/old LinuxCNC start command persists | Reset causes motion | Independent restart interlock plus fresh deliberate ordinary start; prove no retained command can move the machine on rearm. |

**Human-factors requirement:** a safe key sequence should be easier to execute than to defeat. Use clearly labelled per-person keys, easy-to-reach but controlled exchange points, durable captive hardware, unambiguous status, accessible inside release, non-ambiguous spare-key management and straightforward recovery from jam/misalignment. Observe actual tasks and record inconvenience before redesign; no observed operator timing or benefit is claimed here.

## Selected-machine evidence intake and release

Create `BND/HAZ` for every entrance and maintenance task; `SRS` for stop, release, occupied inhibit, escape, isolation and restart; `AUTH` separating ordinary control, diagnostic readout, independent safety controller and physical energy path; `DEP` for keys, common power, mechanical lock, access bypass, firmware and duplicate key; `ARC` with exact catalog variants; `HF` for task usability; `VAL/PT` for the independent physical witness and adverse transitions; `CHG` for every replacement/changed key set. Use `IN-01..10` from the selected-machine intake before any physical trial.

**Current state: UNKNOWN / NOT RUN.** No selected guard, key count, whole-body geometry, hydraulic diagram, stopping/holding measurement, LOTO program, individual-key ownership, or fresh-start validation is available. `G0/G1 HOLD`, `G2 NOT RUN`, `G3/G4 NOT AUTHORIZED`, `G5 HOLD`. If minimum protection is not established, do not operate with people exposed. Any experimental operation requires approved isolated/remote exclusion and explicit residual-risk review.

**No lab justified:** manufacturer and regulatory documentation resolve the role distinction. Only an exact selected device's unresolved release/diagnostic behavior after full manual review could justify a bounded, isolated bench test on `[self-hosted, openpressbrake]`; no GitHub-hosted compute.
