# 4400-DSEDM-01 — Oil-dielectric EDM fire, discharge power and power-on motion
**2026-10-25 | 4400 safety follow-on | NON-GRADUATED | no physical test**

## Learning objective and prerequisites
A fresh engineer must distinguish die-sinking EDM's electrical discharge, combustible dielectric, fire-suppression, axis/tank motion, maintenance and rearm hazards; identify which exact manufacturer instructions apply to which model; and construct a defensible safety-function/witness request without pretending that a LinuxCNC coolant command, alarm or E-stop alone proves physical safety. Prerequisites: 2520 hazard/SRS, 2530 E-stop, 2580 fluid-energy safety, 2590 guards, 25F0 transfer, 4400 output/witness methods. Source reading: [original Makino EDGE3/3i audit](../research/4400_MAKINO_EDGE3I_SINKER_EDM_DIELECTRIC_FIRE_Z_STARTUP_AND_VARIANT_OEM_AUDIT_2026-10-25.md). This is **not** a reopening of graduated 3700 Grinding/EDM specialization.

## Model-specific facts, not universal EDM settings
The manufacturer-authored **EDGE3/3i Safety and Installation manual 24ED1MX02-1804E** specifies dielectric flashpoint above 70°C, fluid at least 50 mm above the workpiece, a temperature stop at 45±3°C, a fluid-level stop, an abnormal-machining stop, and automatic extinguisher. It prohibits blow machining and expects fire supervision even with safeguards active. These numbers are **OEM edition-specific**, not engineering values to copy to another EDM. Official Makino UPV-3 product literature describes **oil-based wire EDM**; never assume all wire EDM is water-based. Official Makino EDAF2 product literature describes a flame sensor and built-in suppression, not a transferable circuit or performance guarantee.

### Five independent propositions
| Layer | What ordinary controls can show | What must instead be established |
|---|---|---|
| Process | M7/M8/M9 or pump command, flushing request, gap current, spark-on command | Actual selected fluid level *at discharge location*, correct dielectric/SDS and geometry; selected OEM-required process constraints |
| Protective control | Temperature/level/arc alarm, software output low, CNC E-stop | Verified safety-related response to faults and protective demands; selected final removal/inhibition of hazardous discharge energy and hazardous movement |
| Fire mitigation | Flame-sensor status, extinguisher installed | Actual suppression suitability/coverage, charge, nozzle location, inspection, detection and evacuation; no inference from green HMI |
| Mechanical | Z command zero, tank axis idle, power-on UI | Actual head/tank support and guarding during power transitions, setup and maintenance; independent selected physical witnesses |
| Service | Main panel OFF, pulse-generator OFF, reset cleared | Lockable isolation of all applicable electrical, motion, fluid and stored energy; tested absence before service and deliberate post-service rearm |

**Important OEM detail:** EDGE3/3i installation §2.3.2 says POWER ON starts fluid-related equipment and the “Z axis break is released.” This is an **exact literal wording**, not proof of the construction or safety performance of a Z holding brake. It is a reason to demand the selected electrical/mechanical drawings and observe safe power-return behavior with qualified personnel and no exposure—not a reason to infer a universal Z-brake circuit.

## Three distinct stop/recovery pathways
**Ordinary cycle stop:** removes or pauses normal machining requests; may leave dielectric hot, stored electrical energy present, a vertical axis unrestrained, or a fire developing. Normal LinuxCNC/FPGA/HMI owns only process coordination and diagnostics.

**Protective demand / fire:** the selected safety architecture must stop hazardous discharge and motion, maintain containment/egress, and operate independently justified detection/mitigation. E-stop can stop machining and pumps in the OEM-described product; that does not extinguish a fire, prove cooling, isolate mains, or justify entry.

**Maintenance and fresh start:** determine exact hazardous-energy sources; isolate, lock, verify, restore guard/nozzle/sensor position, verify correct fluid and fault-free protective devices, inspect occupancy, and require deliberate fresh cycle start. A reset or restored supply cannot be the cycle-start authority. Do not place the portable panel on a surface where an elbow can accidentally actuate axes—the OEM explicitly warns of this.

## Concrete safety-function derivation exercise
For a selected machine, generate distinct IDs in the cumulative Safety Design Package:
- `BND`: exact model, serial, manuals, fluid type, production/setup/service/abnormal-fire states, unattended policy.
- `ENE`: pulse generator, mains/DC bus, Z/tank/ATC motion, hot combustible dielectric, possible fire/extinguisher agent, filter-pump pressure.
- `HAZ`: exposed discharge/ignition, lost immersion, moving tank pinch, power-on release, hot fluid/fire, false suppression-ready, service bypass.
- `SF/SRS`: loss-of-level, excessive-temperature, abnormal gap, fire, guard access, E-stop, isolation, and fresh restart *each as distinct demands*.
- `AUTH/ARC`: which selected protective devices and final elements act without ordinary LinuxCNC/FPGA success.
- `PHY/VAL/PT`: actual level at relevant geometry, actual power inhibition, independently verified axis hold/stop, suppression coverage/inspection and maintenance isolation; all **UNKNOWN/NOT RUN** until qualified evidence.
- `HF/CHG`: inconvenient guard, difficult refill/cleanout, obstructed flame sensor/nozzle, borrowed setpoint, sensor temporarily unplugged, stale HMI, poor portable pendant stowage; design away defeat incentives without weakening protection.

## Failure-path decision model
If a fault occurs, answer in order: **What physical hazardous event? → What is the exact sensor/protective demand? → What independent authority reacts? → Which final element changes physical energy? → Which independent witness can verify? → What residual hazard remains? → What deliberate rearm and occupancy check are needed?** Do not stop at “alarm present” or “command off.”

A plausible tank-level float does not prove a deeply recessed workpiece is immersed. An extinguisher bottle installed does not prove it can reach the flame after a nozzle is moved. A temperature value in range does not prove the sensor is correctly placed or diagnostics work. An E-stop that stops pumps can leave a fire and hot oil. A “ready” screen after POWER ON is not evidence of a mechanically held Z axis.

## Human-factors design priorities
Make fluid filling, chip/debris cleanup and electrode setup possible **with guarding restored and without defeating sensors**. Give clear fill marks tied to fixture geometry, easy visual inspection of nozzles, accessible documented inspection dates, a safe pendant dock away from moving surfaces, guarded service isolation and an obvious separate reset/start sequence. Avoid a design that forces operators to defeat a low-level sensor to machine awkward parts; redesign fixture/tank/process or prohibit the job.

## Learning/evidence gate
Complete [16 unscored technician cases and blank witness](4400_DSEDM_01_TECHNICIAN_CARD_AND_BLANK_WITNESS_2026-10-25.md) and [12-gate no-energy design review](4400_DSEDM_01_12_GATE_NO_ENERGY_REVIEW_2026-10-25.md). An [independent evaluator handoff](../evaluation/4400_DSEDM_01_FRESH_FIRE_AND_POWER_RETURN_TRANSFER_HANDOFF_2026-10-25.md) is **PREPARED/NOT RUN**; do not self-score as blind. The OEM operation manual/schematic and selected hardware are not available.

**DOC-CONFIRMED:** exact Makino documents only. **SOURCE-CONFIRMED:** no new LinuxCNC trace; prior M8/M9 and M62–M65 source audits support only ordinary output semantics. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **INFERENCE:** safe authority allocation and failure model. **UNKNOWN:** machine-specific threshold, fire detection/mitigation performance, exact brake meaning, selected controller program, physical stop/hold, PL/SIL, test outcome.

**Graduation:** not achieved. If all selected hardware assumptions differ, the core teaching “normal request/indicator != physical safe state” remains true; no physical acceptance claim is made. Do not operate an unverified machine with people exposed. Any necessary engineering experiment requires qualified isolation/remote operation, people outside hazard zones and explicit residual-risk assessment.

## OEM marketing/edition conflict to resolve before any unattended policy
The inspected 2018-era EDGE3/3i **safety manual** §1.4.3 requires a capable fire supervisor even with safeguards active. A **manufacturer-hosted Chinese-market EDGE3i product page** promotes unattended operation and flame-sensor/suppression features. Both statements are documentary facts; they are **not** interchangeable operational permission. The correct policy depends on the selected serial/market/firmware, current OEM operation manual, installed fire system, local site risk assessment and authority. Treat this as **UNKNOWN / HOLD**, not as an excuse to bypass supervision or a reason to claim all EDM must always be attended. See the source audit's conflict ledger.
