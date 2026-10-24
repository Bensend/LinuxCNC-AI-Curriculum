# 4400 rear-access / scanner-to-safety-controller interface review worksheet

**Documentary design review, 2026-10-24. NOT an as-built wiring diagram, commissioning checklist or certification.** Primary source: SICK S300 8010948/ZD76/2025-08-19 printed pp. 23–25, 31–32, 88–90 and 97–98, https://www.sick.com/media/docs/3/13/613/operating_instructions_s300_safety_laser_scanner_en_im0017613.pdf . See [source audit](../research/4400_SICK_S300_EFI_RESTART_INTERLOCK_SIGNAL_SELECTION_AND_REAR_ZONE_SOURCE_AUDIT_2026-10-24.md).

## The specific integration mistake to prevent

A technician may enable **restart interlock in the scanner**, observe an OSSD that stays OFF after the field clears, and conclude the whole machine cannot restart. The S300 manufacturer says this inference is wrong **if** Flexi Soft consumes the **protective-field status** over EFI rather than the **OSSD status**: scanner internal interlock does not govern that controller input; controller-side interlock must be implemented. A machine can also require a separate start even after the safety reset. The review must identify the exact safety variable and its authority, not only a device feature checkbox.

## Architecture worksheet (do not populate from guesses)

| Trace item | Evidence required | Current selected OpenPressBrake |
|---|---|---|
| Hazard zone | rear helper, sheet, X/R/Z backgauge, ram, optional follower and service entry boundaries | UNKNOWN |
| Access protection | fixed fence/monitored gate or exact scanner model, mounting and blind-zone drawing | UNKNOWN |
| Scanner configuration if present | model, edition, field-set list, case-switching logic, OSSD/interlock setting, checksum | UNKNOWN |
| EFI integration if present | safety PLC family/version and **actual consumed signal**: OSSD status or raw field status | UNKNOWN |
| Interlock authority | scanner-side and/or PLC-side restart interlock, documented reset edge and power recovery | UNKNOWN |
| Human reset | local control position, line of sight, hidden-area detection, separate fresh start | UNKNOWN |
| Final elements | backgauge drives/STO/physical brake, hydraulic ram final elements, other hazardous actuators | UNKNOWN |
| Witness | independently checked stop, hold, occupancy prevention, energy isolation and fresh-start result | NOT RUN |
| Change control | who can edit field selection, reset logic, machine modes, wiring and diagnostics | UNKNOWN |

## Safety-function decomposition

**Rear entry:** `access demand → independent safety-related control → qualified backgauge/ram/auxiliary final elements as required → actual hazardous-motion stop and maintained prevention → protected occupancy/escape → local reset → separate deliberate start`.

**Maintenance:** `personal lockable isolation → stored-energy assessment → gravity restraint and zone-specific pressure/electrical verification → safe service access`. Rear scanner/guard E-stop and STO alone do **not** replace this chain.

**Normal control:** `LinuxCNC/FPGA → production X/R/Z/Y trajectories, status and logs`; it may request a stop but is not a personnel-safety controller. Network loss or stale HMI cannot rearm the independent chain.

## Design review rejection tests (paper)

- Reject a claim supported only by a green scanner LED, a screenshot of an internal restart setting, an ordinary PLC/HAL boolean or a non-safe universal I/O pin.
- Reject automatic field-clear rearm where a person can pass behind the detection plane; distinguish passage from occupancy.
- Reject any single front-beam laser as proof that backgauge, sheet whip-up, rear helper or sheet follower hazards are covered.
- Reject copying a TRUMPF backgauge STO statement or SICK scanner feature rating into a different installed machine.
- Reject a reset button that cannot see the entire zone unless another independently validated trapped-person prevention method closes that gap.
- Reject service access where isolators, supports or guards are so awkward that removal/bypass is the predictable behavior.

## Change and verification trigger

Any change to scanner model, mounting, field-set shape, case switching, safety PLC signal selection, restart logic, final-element wiring, guard placement, machine mode or auxiliary motion creates an affected `CHG → SRS → ARC → DEP → PHY → VAL/PT` re-review. Obtain machine-specific design limits from its risk assessment and applicable standards; do not invent separation distances, performance levels, stopping times or safe speeds. No physical tests planned until as-built evidence exists. `G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD`.
