# 4400 technician exercise — sensor target is not the hazard (AKFR transfer)

**Learner-facing / not a physical test procedure.** Use after 2580 fluid-power safety and the cumulative Safety Design Package. Preserve blind evaluator separation. This exercise is not a hidden answer key.

## Case

A generic press-brake retrofit uses ordinary LinuxCNC motion commands and a separately selected AKAS-F/AKFR safety arrangement. The operator sees a normal-looking guard indicator, five AKFR release contacts and a green valve-status bit. A maintenance gauge near the pump reads low. The beam has not been independently shown to be restrained. The owner asks whether the die area can be entered for service.

Fiessler AKFR document 1257 (2010-04-01, p. 2) and English document 1264 (2010-07-16, p. 2) mention valve-position **and pressure-sensor** inputs and five release contacts. The documents concern AKAS-F + AKFR, **not an interchangeable AKAS-5M M-variant wiring contract**. Neither document supplies this hypothetical machine's complete pressure-tap map, valve fail states, load path or service isolation procedure.

## Exercise 1 — identify every witness

Complete **one row per physical proposition**, not one row per HMI LED.

| Signal / observation | Exact sensor target and location | Strongest proposition it could prove | What it cannot prove | Common dependency | Linked `PHY/DEP/VAL` IDs | Evidence status |
|---|---|---|---|---|---|---|
| AKFR output contact | | | | | | |
| Valve-position indicator | | | | | | |
| Pressure sensor at selected port | | | | | | |
| Gauge near pump | | | | | | |
| Independent ram position / velocity | | | | | | |
| Load-support/restraint witness | | | | | | |
| Isolating device and stored-energy check | | | | | | |

**Required distinction:** one pressure tap cannot prove the state of every cylinder chamber, accumulator or isolated volume; five electrical contacts cannot be assumed to represent five independent final energy paths. A production safety permissive does not prove maintenance isolation.

## Exercise 2 — deliberate contradiction

Assume a qualified independent measurement establishes continuing beam motion after the protective demand, while the valve-position indicator and pump-side pressure sensor remain plausible. Fill in:

- `SRS-*` protective response required (state the actual selected-machine criterion as UNKNOWN if unavailable):
- `PHY-*` required physical proposition and present status:
- `AUTH-*` ordinary LinuxCNC, independent safety controller, and physical element roles:
- `DEP-*` three distinct credible common-cause or feedback-masking paths:
- `VAL-*` accepted, failed, blocked, or not run — and why:
- `UNK-*` exact facts required before a root cause can be assigned:
- `CHG-*` what changes would invalidate old evidence:
- `HF-*` how to make safe diagnosis/guard restoration easier than bypass:
- Restriction while unresolved:

Do **not** declare the actual cause from these symptoms. If the independent motion measurement is itself unqualified, the broader physical claim is still not established; record that witness uncertainty rather than asserting a pass.

## Exercise 3 — transfer to another machine

Select one: (A) vertical servo axis with STO and holding brake; (B) pneumatic clamp with monitored exhaust valve and downstream trapped air; (C) guarded robot cell with a field-clear indication but a person remaining inside. For the selected machine, reconstruct the same eight-field witness record and identify the separate maintenance-isolation boundary. Preserve the independent safety owner; LinuxCNC/FPGA state alone is insufficient.

## Adversarial review questions

1. Does a pressure sensor inside the safety-controller chain automatically become an independent machine-level pressure witness? What exactly would need to be demonstrated?
2. What would a pressure sensor upstream of a closed valve fail to see?
3. How could a correct valve-position indication coexist with hazardous gravity motion?
4. How would a wrong contact-to-load map survive a superficial electrical lamp test?
5. If fault troubleshooting requires repeatedly defeating a guard, what engineering changes make the safer route the easier route?
6. What can be established from the 2010 AKFR manufacturer sheet, and what requires selected machine documentation and measurement?

## Completion and safety gate

The learner must distinguish `DOC-CONFIRMED`, `INFERENCE`, `UNKNOWN` and any later genuinely `TEST-CONFIRMED` evidence, avoid inventing thresholds, and refuse to convert a controller-status pass into machine-safe-state or maintenance-entry authorization. Do not perform energized fault injection with people exposed. With minimum safe-to-operate evidence missing, no exposed-person operation; remote/isolated experiments require independent residual-risk controls.

Source: https://www.fiessler.de/default-wAssets/docs/download/AKFH-R/bdh-akas-akfr-si-interface-dt-doc1257-v1.0.pdf and https://www.fiessler.de/default-wAssets/docs/download/AKFH-R/bdh-akas-akfr-si-interface-engl-doc1268-v1.0.pdf.
