# 4400 technician card — pneumatic safe exhaust, trapped air, fault memory and fresh restart
Date: 2026-10-24 UTC. **PAPER EXERCISE ONLY; no energized testing authorized.**
Prerequisite: [source audit](../research/4400_PNEUMATIC_SAFE_EXHAUST_VARIANT_RESET_TRAPPED_VOLUME_SCOPE_AUDIT_2026-10-24.md). Apply to generic automated cells, feeders, clamps and auxiliary press equipment, **not** as an assumed OpenPressBrake installation.

## Learner objective and safe decision rule

For every case, name (1) the hazardous **physical** proposition, (2) what the component indication actually proves, (3) the missing as-built/independent evidence, (4) the least inconvenient safer architecture, and (5) the release status. Default: **no personnel exposure** where a basic safe-to-operate threshold is unproven. Experimental operation, if later approved, must be isolated/remote with all people outside danger zones and residual risk documented.

| Case | Paper scenario | Required reasoning / stop decision |
|---|---|---|
| PA-01 | Festo MS6-SV-E says exhausted; clamp remains loaded behind a check valve. | Trace both chamber paths; valve status is not trapped-volume pressure proof. Require zone-specific isolation/measurement and load restraint; hold entry. |
| PA-02 | A gravity-loaded slide drops when the safety dump exhausts. | Distinguish air removal from load holding; add independently justified mechanical holding and physical witness; reject 'air off = safe'. |
| PA-03 | A maintenance worker replaces an exhaust silencer with a smaller quiet unit. | Treat exhaust restriction/backpressure as a change to the safety function. Restore an approved exhaust path and revalidate; no informal equivalence. |
| PA-04 | Festo NECA-MP5 is installed but the safety design credits the MP3's internal cross-circuit detection. | Inspect actual connector code and external safety-controller fault coverage. Mark dependency stale; do not claim inherited diagnostic coverage. |
| PA-05 | Festo high-PL exhaust valve is proposed as a press clutch/brake final element. | Locate explicit manufacturer's press safety valve restriction. Do not select from PL label alone; establish exact application and approved product. |
| PA-06 | ROSS DM1 C is substituted for DM2 C; fault clears when supply cycles. | Distinguish automatic from latched fault reset. Record CHG and invalidate prior restart validation. |
| PA-07 | ROSS DM2 C has reset, and an old LinuxCNC cycle-start remains asserted. | Valve reset/anti-tie-down is not whole-machine fresh start. Independent safety reset then deliberate local new production START, with stale requests discarded. |
| PA-08 | Main compressor and safety valve are off, but one gauge is zero and a remote air accumulator remains. | OSHA isolation/stored-energy logic and as-built zone map; no fitting loosening or hand leak search; hold service. |
| PA-09 | Valve READY switch is wired to HMI green 'SAFE TO ENTER'. | Show feedback target versus load/pressure/occupancy; relabel as diagnostic, require independent safety and physical witness. |
| PA-10 | Technician must remove a guard to reach an unlabelled air bleed screw. | Redesign service access with protected labelled lockable isolation/test points, not a procedural workaround that invites defeat. |

## Qualification worksheet — copy per actual pneumatic zone

`BND/ENE/HAZ:` machine class, task, personnel exposure, pressure/vacuum, gravity/spring/part load.

`SF/SRS:` required protective stop, safe vent/hold and prevention of unexpected re-pressurisation, including when power/normal control fails.

`AUTH/ARC/DEP:` independent safety logic and final element; exact Festo E/D + NECA MP1/MP3/MP5 or ROSS DM1/DM2 variant if actually installed; upstream/downstream valves, exhaust/silencer, common supplies, software boundary.

`PHY:` independent pressure witness in **each** potentially trapped volume, load support/part retention, protected access and escape.

`VAL/PT:` paper predictions OPEN; qualified as-built validation plan NOT WRITTEN; all physical tests NOT RUN.

`CHG/HF:` silencer/connector/valve swap, bypass/branch, poor access, nuisance trips and restart incentive.

`G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.`

## Reviewer challenge

A vendor brochure states 'PL e'. The engineer proposes one safe exhaust valve upstream of a directional control manifold and claims every clamp and robot tool is safe once the valve status reads exhausted. **Reject the premise**: list every chamber/retained-energy path, mechanical consequence, diagnostic limitation, reset/restart dependency and manufacturer application restriction requiring inspection. Mark all unmeasured claims `UNKNOWN`. This card is not a blind external evaluation and has no hidden answer or score.

**Next:** actual machine-specific drawings and selected-device instructions, then an independently reviewed, isolated physical validation design if justified. Do not invent pressure/time thresholds or expose personnel.