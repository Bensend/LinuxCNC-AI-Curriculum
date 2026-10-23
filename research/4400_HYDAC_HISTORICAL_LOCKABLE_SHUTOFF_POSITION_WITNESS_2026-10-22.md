# 4400 — HYDAC historical SAF lockable-shutoff and position-witness source trace

**Status:** source-edition comparison and human-factors safety lesson. Manufacturer historical document `E 3.551.17/08.03` (August 2003), publicly hosted by HYDAC Australia, https://www.hydac.com.au/pub/media/Ourcompanies/s/a/safetyvalveblocks.pdf. The PDF model-code and accessory pages were visually inspected 2026-10-22. **Historical design evidence only; not a current catalog guarantee.**

## Why the suffix matters

The HYDAC SAF/DSV brochure's printed p.5 model-code key identifies:

- `M`: manual discharge; `E`: solenoid plus manual discharge.
- `Y`: historical 2SV5E2Y solenoid valve **open when de-energized**; `Z`: historical 2SV5E2Z **closed when de-energized**.
- `L`: lockable main shut-off valve.
- `LPI`: lockable main shut-off with inductive position monitoring.
- `LPM`: lockable main shut-off with mechanical limit-switch position monitoring.

The printed p.20 accessory drawing states the lockable main shut-off can be padlocked in **either the open or the closed position**. Thus **LOCK FITTED != SAFE ISOLATION POSITION SELECTED**. A position switch can report a shut-off handle/mechanism position without proving accumulator pressure absence or mechanical load restraint. A lock that can hold an *open* path is useful for process/administrative purposes but cannot be credited as closed isolation merely because a padlock is present.

The brochure is explicitly **August 2003**, and the model key names older 2SV5E2Y/Z parts. Modern HYDAC catalog part 2120394 identifies WSM06020Y as normally open and separately warns that 2SV5 and WSM coil families are not interchangeable without corresponding parts. Preserve this revision boundary: the historical drawing establishes design distinctions and suffix semantics in that edition; it does **not** authorize direct interchange or assert identical modern internal construction, fault response, switching time, or pressure decay.

## Safety-package fault cases

| Case | Wrong inference | Required witness/disposition |
|---|---|---|
| Padlock present on `L` accessory | Lock means energy isolated | Verify the **selected locked position** and correct hydraulic path; physical isolation and residual pressure still require independent proof. |
| `LPI` or `LPM` indicates expected shut-off position | All hazardous energy removed | Narrow claim: position-monitor target only. Accumulator fluid/gas, pilot and actuator zones remain separate `PHY/VAL` questions. |
| `Y` substituted by `Z`, or `M` substituted for `E` | Same catalog family means same power-loss behavior | Treat as `CHG`; revalidate SRS, default state, authority, rearm and physical safe-state witnesses. |
| Lockable valve intentionally left open for production | Padlock always improves personnel protection | Mark maintenance-isolation proposition NOT ESTABLISHED; require correctly selected isolation configuration and personal energy control. |
| Gauge on wrong side of closed shut-off | Zero gauge means safe accumulator | Map exact gauge tap and connected pressure zone, and verify all relevant trapped volumes and load restraint. |

## Human-factors requirement

Provide a conspicuous **position-specific** lockout label, clear handle orientation, a way to confirm closed isolation without reaching into the hazard, and approved accessible pressure test points. A lockable handle that looks equally legitimate in open and closed positions is a foreseeable misuse path. Avoid creating an override workflow where the easiest way to service the machine is to lock the wrong position or bypass a guard.

## Authority and release

The padlock, optional position sensor, pressure relief, discharge and physical machine safe state remain different propositions. Ordinary LinuxCNC/FPGA/HMI may display or request, but cannot acquire independent personnel-safety authority from these indicators. Actual achieved safety integrity, mechanical restraint, pressure topology, pressure thresholds, stopping distances and permitted maintenance procedure are UNKNOWN until selected-machine evidence.

**Evidence:** DOC-CONFIRMED for historical HYDAC brochure printed pp.3–5,20 and modern HYDAC catalog part 2120394 as specifically named; INFERENCE for fault and human-factors analysis; UNKNOWN for installed machine; no TEST-CONFIRMED results. No lab required.
