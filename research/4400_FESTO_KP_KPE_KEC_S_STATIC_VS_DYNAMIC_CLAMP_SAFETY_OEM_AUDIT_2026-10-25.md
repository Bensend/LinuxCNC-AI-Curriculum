# 4400-CLAMP-01 — Festo clamping cartridge versus certified braking clamp, release lurch and overtravel
**2026-10-25 | Original OEM documents directly inspected | exact model/edition only**

## Safety question
Can a spring-applied, air-released rod clamp that holds a static load automatically be used as an emergency dynamic brake or as proof that a vertical load will remain supported after loss of air? **No general equivalence.** Manufacturer distinguishes *non-certified static-only families* from an *-S safety-related braking family*, and requires force balance, qualified sizing and measured overtravel for the latter.

## Original manufacturer sources
1. **Festo "Clamping cartridges/units" catalog**, manufacturer-hosted 14-page PDF at `https://ftp.festo.com/Public/PNEUMATIC/SOFTWARE_SERVICE/Documentation/2024/EN/KP_KPE_KEC_EN.PDF`, internally marked **2020/09** despite 2024 hosting directory. Direct PDF read pp. 2–4, 10, 12–13.
2. **Festo "Clamping-unit cylinders, standard port pattern"**, original manufacturer 20-page PDF at `https://ftp.festo.com/Public/PNEUMATIC/SOFTWARE_SERVICE/Documentation/2018/EN/DNCKE_EN.PDF`, internally marked **2017/10**, pp. 2, 6–7. Direct PDF read.
3. **SMC Corporation of America, "Enhance Machine Safety with Locking Cylinders"**, original manufacturer article `https://www.smcusa.com/help-and-support/best-practices/enhance-machine-safety-with-locking-cylinders`, original page inspected 2026-10-25. Explains that a center-closed pneumatic valve trapping air alone is not recommended for maintaining a heavy vertical load. Article is product/application guidance, not selected safety validation.

## Model and function comparison — DOC-CONFIRMED, not interchangeable
| Product family | Original OEM scope | Safety-relevant implication |
|---|---|---|
| **KP cartridge / KPE unit** | Spring clamp, air releases; **not certified for use in safety-related control systems**; static holding, **not suitable for dynamic operation** (catalog pp. 2–4) | Do not replace a dynamic personnel-safety brake with KP/KPE because its static holding number looks sufficient |
| **KEC** | Spring clamp, air releases, static holding; **not certified for safety-related control systems** and **not suitable for dynamic operation** (pp. 2–4) | A similar housing/rod diameter does not establish safety brake performance |
| **KEC-...-S** | Distinct IFA/DGUV safety-related braking/holding variant; catalog describes single-channel Cat. 1 function and specific use conditions, not a complete safety solution (pp. 2, 12–13) | Dynamic use requires exact certified variant, selected system validation, overtravel and wear checks; not automatic PLe or two-channel redundancy |
| **DNCKE vs DNCKE-S** | 2017/10 OEM catalog likewise distinguishes standard static-only clamp from -S safety-related brake/holding option (p. 2) | S suffix and exact documentation are consequential; no substitute by visual resemblance |

## Three direct warnings that change engineering design
**1. Pressure trapped in both cylinder chambers is not a safety guarantee.** The Festo KEC/KEC-S catalog p.10/12 explicitly rejects treating closure of both cylinder supplies with a 5/3-way valve as adequate safety. SMC separately says trapped air alone is not recommended for holding a heavy vertical load. This does not mean every 5/3 valve is defective; it means it cannot independently prove safe sustained holding for the cited hazard.

**2. Releasing a clamp under unbalanced force can cause sudden motion.** Festo p.10/12 says forces on the rod must be balanced before clamp release. This is a *different* hazard from failure to engage the clamp. A pneumatic cylinder or gravity load can lurch at rearm even after the previous stop was successful.

**3. A braking clamp's overtravel is not its static holding rating.** Festo p.13 defines overtravel as travel after exhausting the clamping unit until stop, and says the integrator must determine it on the machine. It varies with load, speed, valve size, air line length/diameter, pressure, wear and environment. The manual warns it can increase with braking frequency. The published example/component category cannot substitute for the selected risk assessment, protected measurements and proof-test schedule.

## Failure paths to discriminate without invented numbers
- Static KP/KPE installed for dynamic emergency braking; wear/slip changes stopping distance. **DOC-CONFIRMED family restriction; selected consequence INFERENCE**.
- KEC-S replaced with visually similar KEC; machine status still reports "clamped." **DOC-CONFIRMED distinct product scopes; actual behavior UNKNOWN**.
- Air valve centers, both chambers trap pressure, but seals/tubing leak or a vertical payload shifts. **DOC-CONFIRMED manufacturer limitation; selected physical outcome UNKNOWN**.
- Clamp is released before force balance: rod jumps under gravity or differential pressure. **DOC-CONFIRMED hazard, not an asserted machine incident**.
- A speed/overtravel value is copied from a catalog rather than measured on the machine. **INVALID** for commissioning.
- Clamp engages but a disconnected rod/coupling allows the load to fall. **INFERENCE**: verify mechanical load path.
- Clamp is repeatedly used as a dynamic brake with no post-demand wear/overtravel verification. **DOC-CONFIRMED** maintenance requirement is application dependent; actual schedule must be selected.
- One Cat.1 clamp is treated as an achieved system PLd/PLe. **INVALID**: performance of whole safety-related control function remains to be demonstrated.

## Cross-machine relevance
Pneumatic press fixtures, pick-and-place cells, conveyors, router gantries and vertical handling axes may have spring-applied rod locks. **Press brake transfer is conceptual only:** OpenPressBrake Y1/Y2 is an unverified hydraulic/gravity system; no pneumatic Festo clamp is asserted installed or suitable. Hydraulic valves, cylinder mechanics and load-bearing restraints require their own selected design.

## Evidence ledger
- **DOC-CONFIRMED:** exact Festo catalogs and SMC OEM article within cited editions.
- **SOURCE-CONFIRMED:** no LinuxCNC source path; LinuxCNC/FPGA cannot own personnel-safety final holding.
- **TEST-CONFIRMED:** none; no selected physical stop/hold/overtravel.
- **COMMUNITY-REPORTED:** none relied on.
- **INFERENCE:** hypothetical coupling/slip/failure-path transfer.
- **UNKNOWN:** selected clamp/air circuit, pressure, load, PL/SIL, dynamic force, stop time/distance, maintenance history, mechanical attachment, qualified witness.
- **Safety:** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 external evaluation OPEN. No exposed-person hazardous operation or energization permitted by this audit.
