# 4400 — Brake fault, torque retention and hydraulic load-control source audit
Date: 2026-10-23 UTC | Status: original documentary research, NOT an archived-source release or machine qualification
Course: 2500 safety / 4400 safety-oriented hardware boundaries

## Engineering question and pre-source prediction

**Question:** On a gravity-loaded axis, must every detected brake fault immediately remove drive torque, and can an inexpensive pilot-operated check valve be substituted for a controlled load-lowering device?

**Pre-source engineering prediction (INFERENCE, not a test):** A blanket “fault -> STO” rule is not defensible for a suspended load; safe response depends on whether torque is temporarily needed to prevent falling and on the independently proven final holding mechanism. A pilot-operated check that locks an actuator may not regulate an overrunning load during descent. The manufacturer evidence below supports both concerns, with important product and configuration limits.

## Manufacturer evidence ledger

| ID | Finding | Evidence class | Product / edition and source | Scope limit |
| --- | --- | --- | --- | --- |
| BR-01 | Rockwell SBC safety instruction commands two active-low brake outputs, coordinates Torque Off Request (TOR), monitors two brake-feedback inputs and I/O status. | DOC-CONFIRMED | Rockwell Studio 5000 Logix Designer v38 online help, Safe Brake Control (SBC), operands and instruction description: https://www.rockwellautomation.com/en-pr/docs/studio-5000-logix-designer/38-00/contents-ditamap/instruction-set/drive-safety-instructions/sbc.html | Applies to listed GuardLogix 5380/5580 and ControlLogix 5590 families, not LinuxCNC HAL or generic drives. |
| BR-02 | Rockwell requires a *negative* STO-to-SBC delay for vertical loads and a magnitude longer than mechanical brake engagement time; it separately requires the feedback-check delay to fit the sequencing constraint. | DOC-CONFIRMED | Same Rockwell help, operand table, STO to SBC Delay. | No universal milliseconds; mechanical engagement time must come from selected device/installation evidence. |
| BR-03 | On SBC fault, brake outputs go OFF, while TOR retains its immediately previous state. In the illustrated feedback-fault path TOR is **not asserted** so the motion task can continue holding a gravity load. | DOC-CONFIRMED | Same Rockwell help, Faults and Corrective Actions / brake-feedback fault example. | **Do not generalize to “TOR always remains OFF on fault.”** Its retained state depends on fault timing; independent failure and power-loss responses must be designed. |
| BR-04 | Rockwell's separate SBC application technique warns that motor holding brakes may not be designed for dynamic stopping, and that unexpected drive Disable & Coast may expose a falling-load risk. | DOC-CONFIRMED | Rockwell publication SAFETY-AT178-EN-P, Safe Brake Control (SBC) Safety Function Application Technique: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at178_-en-p.pdf | An application example is not a blanket certification of a machine or an independent secondary brake. |
| BR-05 | Siemens S120 Safe Brake Test (SBT) deliberately applies torque against a closed brake and observes encoder movement against configured tolerance; it requires enabled drive pulses and has explicit selection/exit sequencing. | DOC-CONFIRMED | Siemens SINAMICS S120 Safety Integrated Function Manual 12/2018, 6SL3097-5AR00-0BP1, FW 5.2, §§4.2.12 pp. 138–147: https://cache.industry.siemens.com/dl/files/292/109763292/att_971633/v1/S120_safety_fct_man_1218_en-US.pdf | Not a passive indicator or no-motion test. Selected axis/test setup, torque, motion allowance and personnel exclusion must be qualified. |
| BR-06 | Siemens explicitly states SBT is **not available for SINAMICS HLA** in this 2018 edition. | DOC-CONFIRMED | Same Siemens manual, §4.2.12, p. 143, note “SBT and HLA”. | No transfer of S120 electrical brake-test feature to hydraulic press-brake HLA or LinuxCNC valve outputs. |
| BR-07 | Parker's Hybrid Actuation System (HAS) installation manual describes its pilot-to-open check as a **load-holding**, not a load-lowering valve, warns of ratcheting when lowering, and limits the described PO-check application to horizontal axes without overrunning-load implications. | DOC-CONFIRMED | Parker HY08-4005-M11, HAS Cylinders Installation Manual, pp. 35–36, “Load Holding Valves – PO Check Valves”: https://www.parker.com/content/dam/Parker-com/Literature/Industrial-Cylinder/cylinder/Serv/HY08-4005-M11_HAS_Installation_Manual.pdf | **HAS-specific recommendation**, not a prohibition on all pilot checks in all hydraulic circuits. Do not substitute for selected-machine hydraulic analysis. |
| BR-08 | Parker's E2 counterbalance family describes load control during overrunning descent through pilot-assisted metering and load holding when pilot pressure is absent. | DOC-CONFIRMED | Parker E2 Series Counterbalance Valve manufacturer description: https://discover.parker.com/e2-series-counterbalance-valve | Product-family description, not evidence of a safety-rated press-brake stop, actual leakage, fault response, or suitability for a specific cylinder. |
| BR-09 | An SBC instruction or hydraulic-valve status does not prove that the hazardous ram, spindle or workpiece is restrained. | INFERENCE | BR-01 through BR-08 plus physical energy-path reasoning | Requires actual machine witness and hazard analysis; never label TEST-CONFIRMED. |

## Fault-path comparison: three very different architectures

### A. Gravity-loaded electric servo axis with mechanical safety brake

**Normal control:** LinuxCNC/FPGA requests position/torque; drive closes servo loop. Neither is the personnel-safety authority.

**Independent safety control:** A selected, qualified safety controller/drive safety function requests a stop, coordinates brake application and torque removal, monitors the selected brake circuit, and inhibits unauthorized rearm.

**Physical final elements:** Drive torque, mechanical brake, transmission/coupling, gravity-loaded axis, any independent support/restraint. Each element has different failure modes.

**Adversarial fault:** Brake feedback does not confirm engagement before torque withdrawal. Rockwell's illustrated SBC implementation retains the ability for motor torque to hold the axis rather than automatically asserting TOR. This is an engineered *conditional fault response*, not permission to keep a hazardous axis accessible, nor proof the drive can hold it through mains loss, drive fault, encoder loss or motor coupling failure.

**Further fault:** If the drive itself faults or power fails while the brake is not confirmed, motor holding torque may disappear. Independent load arrest/support and protected exclusion become essential. A “green brake engaged” HMI bit is insufficient.

### B. Gravity-loaded hydraulic press-brake ram

A press-brake proportional valve, pump command, encoder, pressure gauge and LinuxCNC position-hold loop are ordinary control/diagnostic surfaces. Whether a selected monitored valve, counterbalance arrangement, mechanical support, hydraulic lock or another final element safely holds the beam depends on the *actual* cylinder chambers, pilot connections, hose-break paths, leakage, trapped pressure, gravity force and valve default states.

**Do not transplant** Rockwell's motor-brake TOR sequence to a hydraulic manifold. Likewise do not infer a safe lowering function from a PO check marketed for holding: Parker's HAS manual warns that its PO-check implementation can ratchet when lowering. An alternative counterbalance product description is not an as-built press-brake safety circuit or a PL/SIL claim.

**Crucial conflict to resolve in design:** Some energy may be required for a controlled protective stop; different isolation is required for maintenance. Neither “always dump all pressure instantly” nor “always retain pressure” is universal. Selected circuit and physical witness determine both.

### C. Lathe spindle/chuck

The motor may be at zero command or STO while spindle/chuck inertia still produces hazardous motion. A motor brake or shaft sensor may not observe a disconnected spindle, belt, chuck or workpiece. Unlike a suspended vertical load, retained torque is not necessarily the safe fallback: unexpected spindle energization can itself create the hazard. Require selected spindle/brake topology, independently observed hazardous-element stop, guard-release delay/monitoring, and fresh cycle start. Do not transfer a press-brake hydraulic holding rule to a lathe.

## Counterexample/fault table — no numerical claims

| Fault or demand | Unsafe shortcut | Required engineering evidence |
| --- | --- | --- |
| Brake feedback stuck “engaged” | Trust bit and withdraw torque | Mechanically credible feedback, diagnostic coverage, load restraint, independent witness |
| Feedback missing before TOR | Always assert STO on every fault | Selected safety function's documented conditional response; independent falling-load protection; what happens on simultaneous drive loss |
| Power lost while brake unconfirmed | Assume motor continues to hold | Independent passive/physical hold, gravity exclusion, power-restoration behavior |
| SBT commanded during production access | Call it a harmless software test | Test torque and motion allowance, isolation/exclusion, approved test procedure, post-test status and restart |
| HAS PO check used for gravity descent | Treat check valve as proportional load-lowering control | Actual hydraulic topology and appropriate metering/load-control element; manufacturer applicability |
| Lathe guard release on drive STO | Assume zero motor torque means spindle stopped | Actual spindle/chuck coast and downstream coupling witness, selected safe access strategy |
| Guard/maintenance reset after fault | Reuse a retained LinuxCNC run bit | Fresh independent safety rearm plus distinct fresh ordinary cycle-start episode |

## Practical human factors and lowest-friction safe design

A practical design should expose **why** release is delayed (brake not proved, shaft not stopped, hydraulic zone unknown), offer a documented non-bypass recovery path, make guard closure/inside escape easy, and avoid unnecessary nuisance trips that encourage defeat. If the load cannot be physically restrained and independently verified, personnel-exposed operation must not occur. Isolated/remote experimental testing still requires an approved exclusion zone and residual-risk assessment.

For commissioning, create an *as-built* worksheet with actual brake/valve model and manual revision, source and return of holding energy, feedback target, single/common failure dependencies, drive fault behavior, supply-loss state, accessible escape, maintenance isolation points, and independent PHY-STOP/HOLD/ACCESS/ENERGY/RESTART witnesses. Freeze test conditions only after machine review. Never assign guessed PL/SIL, stopping distances, hydraulic pressure thresholds or brake-test torque.

## Adversarial review / falsification

1. **False claim:** “Rockwell SBC never removes torque when a brake fault occurs.” **Correction:** TOR retains its previous state; the example is one timing/fault path (BR-03).
2. **False claim:** “A safe brake test can be run while a technician stands under the load because it is safety-rated.” **Correction:** Siemens explicitly applies test torque; test exposure and protection need independent approval (BR-05).
3. **False claim:** “A PO check is always unsafe on vertical cylinders.” **Correction:** Parker's statement is scoped to the documented HAS arrangement; another selected circuit may differ (BR-07).
4. **False claim:** “Two independently wired brake feedback channels prove physical holding.” **Correction:** Common mechanical failure or downstream coupling can invalidate that inference (BR-09).

## Evidence not acquired / next-work gate

- **UNKNOWN:** Selected OpenPressBrake/lathe as-built brake and hydraulic schematics, real shaft/cylinder coupling, final elements, power-loss behavior, exact product safety ratings, stopping/holding acceptance, physical witness.
- **NOT RUN:** No simulation, bench or machine fault insertion; no TEST-CONFIRMED claims.
- **External:** 2520–25F0 information-separated competency evaluations remain OPEN.
- **Archive:** Original 85-document consolidated release remains 6 pending; this is new original work, not one of the six historical files.
- **Next:** Complete selected-machine IN-01..10 and physical PHY-STOP/HOLD/ENERGY/RESTART, then derive product-specific validation; alternatively source-trace a different unblocked 4400 physical safety question without manufacturing numerical acceptance criteria.
