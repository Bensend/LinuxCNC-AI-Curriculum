# 4400 adversarial design review — Automatic accumulator bleed versus protective-cycle energy

**Status:** architecture reasoning using manufacturer product documentation. No selected hydraulic circuit, personnel-safety rating, machine test or accepted stop/hold behavior. The table below is **conditional reasoning, not a hydraulic truth table**.

## The conflict a safety block cannot solve by its name

HYDAC SAF `E` catalog variants may contain a solenoid-operated accumulator bleed; a documented historical `Y` configuration opens the bleed valve when de-energized, while `Z` closes it. HAWE D 7571 rev 1.1 p.18 identifies emergency actuation after pump-side pressure loss as a possible accumulator application. These are independent manufacturer statements about **possible components and applications**. A designer must resolve whether a particular machine's safest response to loss of electrical/pump power is immediate pressure release, a controlled accumulator-powered protective action, mechanical holding, or a verified combination. It is unsafe to presume that every de-energize-to-dump arrangement prevents hazardous motion.

## Conditional safety requirements, not assumed machine behavior

| Hypothetical demand / fault | Design conflict to resolve | Required `SRS/PHY/AUTH/DEP/VAL` evidence |
|---|---|---|
| Loss of electrical power while a gravity-loaded ram is raised | If pressure is removed, the load might move unless a suitable independent load-holding path exists. Conversely, trapped pressure can itself be hazardous. | Selected mechanical/hydraulic holding function, energy-path schematic, fail positions and independent load witness. **Do not assert descent or restraint without actual circuit.** |
| Loss of pump pressure during a machine-required protective cycle | Accumulator energy might be intentionally reserved to finish a protective action; automatic bleed might remove that energy prematurely. | SRS specifies protective cycle, sequencing authority independent of ordinary LinuxCNC, energy budget and physical completion witness; all UNKNOWN here. |
| Bleed commanded, return path blocked or valve stuck | Command/coil and valve-status light can look correct while pressure persists. | Physical gauge/test point on correct zone, independent witness, selected fault detection and a blocked-release disposition. |
| Valve/coil changed from historical `Y` to `Z` or `E` to `M` | De-energized discharge behavior may invert or disappear; ordinary control might not detect hardware substitution. | Exact part/revision, installed wiring/port map, `CHG` requalification, safety demand, power-loss/restart behavior and physical validation. |
| Lockable main shut-off padlocked **open** | Lock may prevent accidental handle motion but does not isolate energy. | Position-specific lockout procedure, clear labeling and verification of actual closed isolating path; handle-position sensor is not pressure witness. |
| Gauge installed only at pump port | A low reading may coexist with trapped accumulator/cylinder pressure behind closed valves. | Zone-to-port connectivity map, calibrated appropriate pressure witnesses, reaccumulation analysis and service isolation. |
| After temporary powered test, a worker resumes service | Previously verified isolation is stale after energization. | Reapply energy control and verify isolation before exposure, per OSHA 1910.147(f)(1); do not let an HMI reset substitute. |

## Minimal fault-tree structure for an engineering review

**Top event:** person exposed while a machine's required physical safe-state proposition is false.

Potential contributing branches (OR; not a quantified probability tree):

1. **Wrong safety function selected:** an assumed universal `pressure = 0` target conflicts with gravity holding or a needed protective cycle.
2. **Output-to-physics failure:** bleed command sent but final element sticks, return is blocked, pilot dependency fails or a trapped chamber remains isolated.
3. **Plausible but incomplete witness:** gauge at wrong tap, blocked gauge connection, uncalibrated sensor, or handle-position indication substituted for pressure/load evidence.
4. **Configuration drift:** `M/E`, `Y/Z`, coil/valve revision or gauge/port location changed without revalidation.
5. **Maintenance exposure:** lock applied in wrong valve position, temporary powered test not followed by renewed isolation, suspended load not independently restrained, or inaccessible gauge encourages guard defeat.

These are **INFERENCE / candidate failure paths**. Without a selected circuit, they are not claims that a particular fault is physically possible or a particular PL/diagnostic coverage is achieved.

## Practical decision sequence

1. Write the **physical hazardous event** and desired protective/maintenance states separately. If gravity or external force exists, do not define "safe" solely as pump power removed.
2. Establish whether any accumulator energy is intentionally part of a protective sequence, and which independent authority is allowed to initiate/complete it.
3. Identify exact block/bleed/relief/shut-off variants and de-energized states from **current selected** product documentation. Historical model-code examples are research only.
4. Trace all accumulator, pilot, actuator and mechanical energy paths, including check valves and isolated chambers.
5. Require separate feedback propositions: electrical demand, actual valve position, zone-specific pressure, physical load/motion/restraint and maintenance lockout.
6. Make the safest routine easy: labeled lock positions, visible test ports, accessible service guards, unambiguous reset/rearm and independent restart inhibition.
7. Reject personnel-exposed operation if the minimum safe-to-operate proposition remains unproved; use isolated/remote experimental diagnosis with personnel outside the danger zone and residual risk documented.

## What would justify a lab?

Only after the selected SRS, exact installed circuit and manufacturer documents identify a specific unresolved physical response that cannot be settled by source/engineering analysis. Then create a **bounded, separately authorized** validation plan with safe instrumentation, approved remote/isolated controls and explicit acceptance criteria. No lab is frozen here. No simulation or test would turn an invented hydraulic truth table into evidence.

**Sources:** HYDAC SAF/DSV `E 3.551.17/08.03` printed pp.3–5,20; HYDAC part 2120394 official catalog; HAWE D 7571 rev 1.1 printed pp.11,18; OSHA 1910.147(d)(5)–(6),(f)(1). Product/OSHA statements DOC-CONFIRMED; abstract fault tree INFERENCE; selected machine UNKNOWN; no TEST-CONFIRMED claims.

## Direct source navigation (publication-review addition)

- [HAWE miniature accumulator D 7571, 03-2024 rev 1.1](https://productfinder.hawe.com/downloads/D7571-en.pdf)
- [HYDAC SAF exact manual discharge example 2076241](https://catalog.hydac.com/en-us/item/safety-and-shut-off-blocks/type-saf-safety---shut-off-blocks/2076241)
- [HYDAC SAF solenoid/manual discharge example 2120394](https://catalog.hydac.com/en-us/item/safety-and-shut-off-blocks/type-saf-safety---shut-off-blocks/2120394)

These links identify source families/editions used by the companion investigation; they do **not** make this qualitative note an as-built machine design or a physical validation result. Verify exact selected product/manual and the proposition each source supports before publication.
