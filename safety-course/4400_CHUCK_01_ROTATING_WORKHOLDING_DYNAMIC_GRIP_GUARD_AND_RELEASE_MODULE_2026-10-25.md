# 4400-CHUCK-01 — Rotating workholding: dynamic grip, ejection and independent safety
**2026-10-25 | 4000 safety | NON-GRADUATED | no physical tests**

## Prerequisites and learning outcome
2520 hazard-to-function, 2540 final elements, 2570 stopping, 2580 isolation, 2590 guarding, 4400-ATC-01 mechanical retention and 4400-MON-01 speed monitoring. Learner must distinguish **hydraulic pressure**, **actuator travel**, **static force**, **dynamic force at RPM**, **jaw fastening**, **spindle stop**, **guard containment**, **human access**, **service isolation**, and **fresh restart**. Read [original RÖHM/Haas/HSE/OSHA + pinned LinuxCNC audit](../research/4400_ROEHM_HAAS_CHUCK_CENTRIFUGAL_GRIP_PRESSURE_AND_LINUXCNC_DIO_SOURCE_AUDIT_2026-10-25.md), [paper scenarios and blank witness](4400_CHUCK_01_TECHNICIAN_SCENARIOS_AND_BLANK_WITNESS_2026-10-25.md), and [no-energy design review](4400_CHUCK_01_NO_ENERGY_RETENTION_GUARD_AND_CHANGE_REVIEW_2026-10-25.md).

## Physical mechanism and failure
**DOC-CONFIRMED RÖHM KFD 12/03:** outside-in jaw force falls with centrifugal effects dependent on jaw mass, centroid radius and speed; special jaws require renewed engineering. Stationary grip and a chuck nameplate maximum RPM do not establish a particular workpiece's permissible speed. Jaw lubrication, bolts, workpiece contact and material, collision damage and enclosure containment are independent hazards. **DOC-CONFIRMED Haas:** a pressure reading/command is not a universal force witness; the named programmable option exhibits history-dependent grip after a pressure decrease. **INFERENCE:** pressure OK plus commanded RPM is not proof against ejection.

## Four authority layers
1. **Ordinary CNC:** LinuxCNC interpreter M62/M63/M64/M65, HAL output, spindle M3/M5 and HMI request motion or I/O. Not a safety-rated clamp/stop authority.
2. **Monitoring and diagnostics:** pressure switch, drawtube stroke, spindle speed, service grip-force test and alarms. Each measures a narrow proposition; shared power, wrong mapping or stale data can defeat several at once.
3. **Safety-related control:** selected and independently engineered protective stop, access interlock/guard lock, overspeed and restart inhibition as justified by machine risk assessment. No generic PL/SIL assigned to any example.
4. **Physical energy and containment:** chuck/jaw/bolt/workpiece contact, actual drive stop/brake, qualified guard resistance, hydraulic isolation and stored-energy control. These must physically prevent or contain the hazard.

## Candidate functions (not approved designs)
- **SF-CH-RET:** selected workpiece/jaws retained over qualified cutting load, jaw geometry, wear and speed envelope.
- **SF-CH-ACCESS:** protect personnel from rotating/entanglement/ejection hazards until safe access is physically established.
- **SF-CH-CHANGE:** changes to jaws, workpiece, pressure program, RPM, bolts or guard invalidate affected acceptance evidence until independently reviewed.
- **SF-CH-SERVICE:** isolate rotation and hydraulic/pneumatic/spring energy before jaw change, maintenance or jam recovery.
- **SF-CH-RESTART:** reset/guard closure/power return must not trigger retained spindle or clamp commands; new deliberate start required.

## Fault/contradiction table
| Apparently good | Contradiction | Required disposition |
|---|---|---|
| pressure OK | static force low from lubrication/wear | HOLD; force not proven |
| stroke OK | jaw does not contact the selected part | HOLD; retention not proven |
| static grip OK | longer/heavier jaw installed | previous speed/grip evidence STALE |
| spindle command OFF | spindle still coasts | access not yet proven |
| M64 output true | actuator stuck / pressure isolated | ordinary command only |
| door closed | guard not qualified for ejected jaw mass | containment UNKNOWN |
| safety reset accepted | previous M3 or clamp request persists | independent fresh-start inhibit needed |

## Human factors
Use visible jaw IDs and short change cards, convenient lubrication/force checks, safe loading aids, guards that hinge and reinstall without fiddly alignment, and a clear message naming the missing physical proposition. Ask operators which guard they bypass and why; a safeguard that predictably invites defeat needs redesign, not a software override. Do not allow hand-held emery cloth on rotating work.

## Cross-machine transfer
Lathe power chucks/collets and long bars are the direct example. Mills and ATCs have different retention mechanics; robots have gripper drop risks; press brakes have die-clamp/gravity-hold risks, not centrifugal jaws. Transfer the principle **feedback is not physical retention**, not RÖHM numbers or hydraulic truth tables. No RÖHM/Haas installation on OpenPressBrake is claimed.

## Evidence and graduation
SOURCE-CONFIRMED pinned normal LinuxCNC command dispatch; DOC-CONFIRMED OEM/agency exact editions; INFERENCE candidate safety architecture; TEST-CONFIRMED none; COMMUNITY-REPORTED none relied on; UNKNOWN selected hardware, machine-level safe stopping/holding/guarding, external score and PL/SIL. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 OPEN. Counterfactual unknown physical force/containment could overturn safety, so **NOT GRADUATED**. No machine exposed-person operation without minimum independent proof; experimental operation must be isolated/remote and independently approved.
