# 4400 — Sheet whip-up, powered follower and independent stop coverage: technician card

**Status:** learner-facing paper exercise; **NOT RUN** on a machine; not a safety approval, numerical design or external blind score. Prerequisites: [original source audit](../research/4400_PRESS_BRAKE_SHEET_WHIP_UP_AND_INDEPENDENT_FOLLOWER_SAFETY_BOUNDARY_2026-10-24.md), 2520/2590 safety methodology, selected-machine intake and 4400 authority/physical-witness gates.

## One-minute hazard recognition

The punch/die gap is **not the only danger zone**. A long workpiece may whip upward and trap a hand against the slide face or strike a person; a powered sheet follower may add a separate moving support, pinch zone and stored-energy path. **A stopped ram is not proof of a stopped follower or restrained workpiece.** Conversely, a sheet follower can reduce handling strain and whip-up exposure if properly selected and integrated.

Sources: [Oregon OSHA p.33](https://osha.oregon.gov/OSHAPubs/2980.pdf); [AMADA 2016 p.7](https://www.amada.co.jp/english/products/pdf/saftyguide_bend_e.pdf); [Fab Supply original product description](https://press-brake-products.fabsupplyinc.com/item/all-categories/sheet-follower/sheet-follower); [ENUTRON stand-alone follower](https://enutron.com/press-brake-sheet-followers-enulift-enua1/).

## Paper cases — do not energize a machine

For each case fill: `BND/HAZ`, `SF/PHY`, `AUTH/ARC`, `DEP/HF`, `UNK`, required independent physical witness and `VAL/PT` status. Correct default for missing evidence: **UNKNOWN / HOLD / NOT RUN**.

| ID | Situation | Question the learner must answer |
|---|---|---|
| WF-01 | Ram-mounted laser stops the punch when a finger approaches the die. Long sheet still swings up. | Which hazard geometry is **not** proved covered by the laser? |
| WF-02 | A large panel rises and can pinch against the front of the slide. | How would you identify the complete material path and operator/helper exposure, not only die clearance? |
| WF-03 | A vendor says its servo sheet follower works independently of press controls. | Which **safety integration** questions remain UNKNOWN? Why is 'independent' not proof of absent safety wiring? |
| WF-04 | Ram stop demand is received; follower drive is still in its normal commanded state. | Which separate final-element and physical-motion witnesses are required before claiming a protective stop? |
| WF-05 | Follower torque is removed while holding a large sheet. | Can 'motor off' be a safe-state claim without proving sheet support and gravity/elastic energy behavior? |
| WF-06 | Portable follower is unplugged, moved, then connected to a different press. | Which geometry, guarding, safety-demand, configuration and restart records become STALE? |
| WF-07 | Follower remote troubleshooting reports READY and all servo positions nominal. | Why does this not authorize entry, local reset or hazardous motion? |
| WF-08 | A worker removes the support because it obstructs normal small-part bending. | What human-factors redesign would make safe support/guard restoration easier than defeating it? |
| WF-09 | One support is working, the other is disconnected; sheet center of gravity is off-center. | What load/geometry assumptions and independent witnesses must be obtained rather than guessing lift capacity? |
| WF-10 | A long part bends successfully, but the next part has a different flange and tool arrangement. | Which previously validated safe-trajectory/guard assumptions must be reviewed under CHG? |
| WF-11 | A follower safety stop is requested and its output indicator turns off. | What physical evidence would disprove 'indicator OFF = no dangerous force or motion'? |
| WF-12 | A machine has **no** powered follower and a worker manually supports a large part. | Which whip-up/handling hazard remains, and why must the optional follower intake be recorded N/A rather than fabricated? |

## Independent authority sketch (fill with selected-machine evidence)

```text
NORMAL COMMANDS:  CNC bend sequence ------> press Y1/Y2 normal motion
                  optional follower CNC --> follower normal motion
SAFETY INPUTS:    guards/laser/E-stop ---> [qualified independent safety logic]
                                         |--> [actual press final elements]
                                         '--> [actual follower final elements, if present]
PHYSICAL:         ram stopped? | follower stopped/held? | sheet restrained?
                  pinch/strike path inaccessible? | energy isolated for service?
```

The drawing is an **allocation question**, not a proposed wiring diagram. No safety claim is assigned to LinuxCNC, a general FPGA, remote diagnostics or an unverified shared enable line.

## Reviewer rubric (not hidden answers)

- **Hazard completeness:** recognizes sheet strike, slide-front pinch, added follower actuator and service/reconnection exposure.
- **Evidence precision:** distinguishes OEM-described capability from selected-machine as-built fact and `DOC-CONFIRMED` from `INFERENCE`/`UNKNOWN`.
- **Authority separation:** identifies independent safety demand/final elements for both press and follower when required.
- **Physical witness:** refuses to equate stop command, servo position, light curtain clear or output OFF with physical stop, hold, no pinch, no stored energy.
- **Human factors:** offers an ergonomic, easy-to-restore support/guard arrangement rather than a bypass procedure.
- **Release:** correctly keeps `VAL/PT NOT RUN`, G3/G4 NOT AUTHORIZED and no personnel-exposed operation pending selected-machine proof.

## Empty evidence handoff

| Case | Hazard / exposure | Required safety function | Physical safe-state proposition | Owner / final element | Missing selected evidence | Disposition |
|---|---|---|---|---|---|---|
| WF-__ | | | | | | UNKNOWN / HOLD |

**Practical floor:** if the actual part/ram/follower hazard boundary is not safeguarded, do **not** operate with people exposed. Experimental investigation requires a separately qualified isolated/remote plan with personnel outside the danger zone, physical support and residual risk explicitly reviewed. No hazardous tests are prescribed here.

**External competency:** this is open learner-facing practice, not a sealed benchmark or a scored fresh-AI evaluation. Existing 2520–25F0 and 4400-HY-01 external gates remain open.
