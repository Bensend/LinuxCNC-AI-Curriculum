# Professional machine safety wiring reference study 02

Status: RESEARCH / hydraulic-energy boundary deepening  
Date: 2026-09-16

## Objective

Deepen the first professional-wiring study by separating four states that are often incorrectly collapsed into the word `off`:

1. normal command inhibited;
2. torque/actuation safety function active;
3. hazardous fluid/motion path brought to a validated safe state;
4. energy physically isolated for maintenance.

This pass does **not** invent an OEM press-brake valve truth table. It records only manufacturer-supported architectural lessons and leaves machine-specific final states UNKNOWN until complete machine drawings establish them.

## Pilz fluid-power safety architecture lesson

Authoritative source: Pilz, *Safety Compendium*, Chapter 8 Mechanical, pneumatic and hydraulic design, including stopping/braking examples.

Source URL: https://www.pilz.com/download/open/TechBo_Pilz_safety_compendium_1004669-EN-02.pdf

**DOC-CONFIRMED** — Pilz treats fluid-power safety as a physical actuator/valve problem, not merely a PLC-output problem. Its examples distinguish valves that vent/isolate fluid energy from mechanical holding devices and service brakes.

**DOC-CONFIRMED** — For vertical loads, Pilz explicitly warns that de-pressurisation alone can permit gravity-driven movement. A clamping cartridge/holding device has a different function from a service brake, and opening a holding device with an inadequately controlled cylinder can itself create hazardous movement.

### Press-brake transfer lesson

**INFERENCE, bounded by the manufacturer evidence above** — `pump off`, `proportional command = 0`, `valve coil off`, `pressure dumped`, and `ram mechanically/hydraulically prevented from descending` must remain separate states in the press-brake curriculum. None may be substituted for another without the actual hydraulic circuit and validated component behavior.

This reinforces the HAWE SAKB finding from Study 01: the Y1/Y2 hazardous-motion boundary must be traced through cylinder-side holding/anti-cavitation and directional elements, not stopped at the pump motor or normal proportional command.

## Energy-state worksheet for OEM drawings

Every complete OEM machine trace should now fill this table rather than merely identify a safety relay:

| Layer | Normal run | Protective stop / E-stop | Maintenance isolation | Proof/feedback |
|---|---|---|---|---|
| Main incoming electrical | machine-specific | UNKNOWN until drawing traced | disconnect/isolation arrangement | visual/measurement/aux contacts as applicable |
| Control 24 V | machine-specific | often may remain for diagnostics; verify | task-specific | supply/status |
| Servo/spindle torque | enabled | STO/contactors/safe-motion as documented | electrical isolation if servicing requires it | STO diagnostics / contactor EDM |
| Hydraulic pump | running as required | OEM-specific: may run or stop | electrically isolated for relevant service | contactor/drive feedback as provided |
| Proportional command | active | inhibited/zeroed as documented | not sufficient alone | command/current diagnostics only |
| Hydraulic safety/holding valves | operational state | validated safe state required | pressure controlled + mechanical blocking where task requires | valve position monitoring where provided |
| Cylinder/ram | commanded motion | hazardous motion prevented/stopped per validated architecture | stored/gravity energy controlled | position + physical verification appropriate to task |

The `Protective stop / E-stop` column must never be populated by assumption from the component name.

## Human-factors design consequence

For home-shop teaching, a maintenance procedure should identify the **hazard to be entered** and then select the physical controls needed for that hazard. A universal instruction to `hit E-stop` is inadequate because E-stop may intentionally leave control power, drive DC bus, hydraulic pressure, or other energy present.

Likewise, a universal instruction to `turn the pump off` is inadequate for a gravity-loaded hydraulic axis because trapped pressure and gravity remain relevant. If hands/body will enter a crushing zone, the course must teach positive control of the load appropriate to the machine design rather than trusting software state.

If that minimum state cannot be established, the machine should not be operated with people exposed to the hazard; experimental operation belongs isolated/remote with people outside the danger zone.

## Professional architecture checklist added by this pass

For each E-stop/interlock circuit, trace **two parallel maps**:

### Map A — safety command and diagnostics
`protective device -> safety relay/PLC -> safety outputs -> final elements -> EDM/position feedback -> reset/rearm`

### Map B — physical energy
`source of electrical/fluid/gravity energy -> switching/valving/holding elements -> actuator -> hazardous motion`

Then overlay the maps and answer:

- Which Map-B elements does each Map-A safety output actually change?
- Which energy sources remain present?
- Can stored or gravity energy still create motion?
- Is the final state monitored, or merely commanded?
- Does reset only re-arm safety authority, or can it initiate motion?
- What additional isolation/blocking is required before maintenance access?

## Adversarial review

- `The safety PLC output went false, so the ram is safe.` **UNSUPPORTED.** Trace the final hydraulic elements and their feedback.
- `The pump contactor opened, so hydraulic energy is gone.` **FALSE as a generic claim.** Stored pressure/gravity can remain.
- `Dumping pressure always makes a vertical cylinder safer.` **FALSE as a generic claim.** Manufacturer fluid-power guidance explicitly identifies gravity movement after depressurisation as a hazard requiring appropriate holding/braking architecture.
- `STO means electrical isolation.` **FALSE**, retained from Study 01.
- `E-stop is the maintenance isolation.` **FALSE as a generic design rule.** Operational emergency stopping and task-specific hazardous-energy isolation are distinct functions.

## Evidence gap / next work

The highest-value unresolved item remains a publicly inspectable OEM press-brake electrical + hydraulic drawing pair that identifies what the safety controller's monitored contactor actually disconnects and maps safety outputs to named hydraulic valves. Until that is obtained, preserve the exact OEM E-stop hydraulic truth table as **UNKNOWN**.

If that source remains unavailable, rotate within safety research to a complete servo-machine or robotic-cell OEM architecture and use it to mature the two-map method rather than fabricating press-brake detail.

## Compute decision

No compute is justified by this evidence gap. It is a documentary/machine-architecture question; simulation cannot establish an unknown OEM wiring or valve truth table. No GitHub-hosted or self-hosted runner was used.
