# Accessible Cell Power-Loss, Escape-Release, and Restart-Authority Trace

Date: 2026-09-18
Status: SOURCE/DOC study; no machine-specific PL/SIL/timing values inferred

## Question

For a bodily-enterable safeguarded cell, what can authoritative manufacturer evidence establish about guard locking during power loss, inside escape, restoration of the locking device, personnel-clear/restart prevention, and the requirement for a separate production start?

## Evidence

### EUCHNER CTP BiState guard locking

**DOC-CONFIRMED:** EUCHNER's CTP-LBI-AP BiState device states that its bistable guard locking is intended to prevent people from accidentally becoming trapped when power fails or the machine is switched off while the safety door is open, while also preventing activated guard locking from being deactivated by a power failure. It separately exposes door-position monitoring (`OD`) and guard-lock monitoring (`OL`) and provides an escape release usable from the danger zone without tools.

Source: EUCHNER CTP-LBI-AP-U-HA-AE-SA-170618 product documentation, accessed 2026-09-18.
https://www.euchner.com/en-us/a/170618/

**INFERENCE, bounded:** loss of electrical power cannot be treated as one universal guard state. A bistable device may intentionally preserve its previous lock state; therefore commissioning must challenge power loss from both an already-locked and an already-unlocked/open state. The machine-level safe reaction still depends on the complete safety architecture.

### EUCHNER TZ operating instructions

**DOC-CONFIRMED:** EUCHNER's TZ instructions require starting commands for dangerous machine functions to become active only when the guard is closed and locked; guard locking must not be released until the dangerous machine function has ended; for personnel protection the guard-lock position must be monitored in the safety circuit; and closing/locking the guard must not automatically start a dangerous function—a separate start command is required.

Source: EUCHNER, Operating Instructions Safety Switch TZ, current public manual accessed 2026-09-18.
https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Operating-Instructions-Safety-Switch-TZ_EN_3633049_2088062.pdf

### Escape release and return to readiness

**DOC-CONFIRMED:** EUCHNER TZ variants with key-button escape release describe the escape release as manual release from inside the danger zone without tools and state that the disable can be removed and the switch returned to readiness only with the included key. Auxiliary release is separately intended for access after a malfunction such as power failure and must be protected against misuse.

Source: EUCHNER TZ1RE024MVAB-C1828 product documentation, accessed 2026-09-18.
https://www.euchner.com/en-us/a/089469/

**DOC-CONFIRMED:** Pilz PSENmlock documentation distinguishes escape-release reset behavior by product version. Power-reset versions require cycling supply after escape release; automatic-reset versions restore the device by restoring the escape release and closing the safeguard. Pilz separately notes that its handle module can accept up to five personal locks to prevent restart.

Source: Pilz PSENmlock product documentation, accessed 2026-09-18.
https://www.pilz.com/en-US/products/sensor-technology/safety-switches-with-guard-locking/psenmlock-safety-locking-devices

**BOUNDARY:** device readiness/reset after an escape release is not evidence that the cell is personnel-clear and is not production START authority.

### Personnel-retention restart prevention

**DOC-CONFIRMED:** Pilz's PSS 4000 Key-in-pocket function is explicitly intended to prevent unplanned restart while people remain in the danger zone; Pilz states the plant cannot restart until the last person has left.

Source: Pilz, System release PSS 4000 1.25 — Key-in-pocket solution, 2023-08-28.
https://www.pilz.com/en-US/company/news/articles/238605

This is independent supporting architecture evidence, not a claim that the EUCHNER device and Pilz Key-in-pocket form one certified system.

## Authority chain frozen for the curriculum

`HAZARD STOPPED / SAFE-ENTRY EVIDENCE`
→ `UNLOCK AUTHORIZED`
→ `GUARD UNLOCKED`
→ `BODILY ENTRY / PERSONNEL RETENTION ACTIVE`
→ `ESCAPE RELEASE IF NEEDED`
→ `PERSONNEL-CLEAR EVIDENCE`
→ `ESCAPE DEVICE RESTORED / DEVICE READY`
→ `GUARD CLOSED`
→ `GUARD LOCKED AND LOCK STATE MONITORED`
→ `SAFETY RESET / REARM`
→ `FINAL-ELEMENT SAFETY AUTHORITY RESTORED`
→ `SEPARATE FRESH ORDINARY START`

Freeze:

**POWER RESTORED != GUARD READY != GUARD CLOSED != GUARD LOCKED != PERSONNEL CLEAR != SAFETY RESET != PRODUCTION START.**

Freeze:

**ESCAPE RELEASE RESTORED != PERSONNEL-CLEAR PROOF.**

Freeze:

**CLOSE + LOCK MUST NOT AUTOMATICALLY RESTART HAZARDOUS MOTION.**

## LinuxCNC / ordinary FPGA boundary

LinuxCNC/HAL and the ordinary FPGA may request stop/unlock, display door/lock/personnel-retention diagnostics, and receive a safety permissive. They must not be the sole authority that decides personnel are clear, bypasses an active restart-prevention state, or converts a stale pre-entry `START`, `JOG`, `DOWN`, or `ENABLE` into fresh intent when the safety system rearms.

A practical implementation should clear or edge-qualify ordinary hazardous-motion requests across an access cycle. That is ordinary-control hygiene layered beneath—not a replacement for—the independent safety restart interlock.

## Commissioning / adversarial checks

1. Lose power with the guard locked. Verify the actual device/system behavior against its specified locking principle and verify hazardous energy disposition independently.
2. Lose power with the guard open/unlocked. Verify restoration cannot unexpectedly lock a person inside or grant motion authority.
3. Operate escape release from inside. Verify hazardous-motion authority remains removed and the escape path is usable without tools.
4. Restore the escape release but deliberately keep personnel-retention evidence active. Restart must remain inhibited.
5. Clear personnel-retention evidence while guard is open. Motion authority must remain inhibited.
6. Close but do not establish monitored lock. Motion authority must remain inhibited where locking is required for the hazard.
7. Restore lock and perform safety reset while an ordinary LinuxCNC motion/start command is stale TRUE. Hazardous motion must not start from that stale request.
8. Require a distinct fresh ordinary START after safety authority has returned.
9. Challenge failed/stuck door-position and lock-monitoring feedback separately; do not collapse `door closed` and `lock engaged` into one diagnostic.
10. Challenge auxiliary/emergency release misuse and verify its required restoration/reset behavior from the exact device manual.

## Human-factors rule

The inside escape control must be obvious and reachable from the danger zone. Personnel restart-prevention must be easier to use correctly than to bypass. A workflow that routinely forces workers to defeat the guard or borrow/defeat retention credentials is an engineering defect, not merely a training problem.

## Minimum-operate gate

For a bodily-enterable zone, if the architecture cannot establish the required safe-entry state, prevent restart while personnel may remain inside, provide the required escape path, monitor the guard/lock state relied upon for protection, and require controlled rearm plus separate start, do not operate with people exposed to the hazard. Experimental operation must keep people outside the danger zone and state residual risk explicitly.

## UNKNOWN / not inferred

- Exact OpenPressBrake guard-locking device or locking principle.
- Machine-specific safe standstill/energy-discharge evidence needed before unlock.
- Required PL/SIL/category/DC.
- Required stopping time/distance or hydraulic pressure thresholds.
- Whether electronic Key-in-pocket is appropriate for any specific OpenPressBrake maintenance task versus physical LOTO/blocking.
- Exact complete same-machine state machine joining all cited products; sources are deliberately not represented as one certified system.

## Next evidence target

Find a complete professional accessible-cell application exposing the same chain in one machine/system, preferably including power-cycle recovery, escape-release diagnostics, personnel-clear/restart prevention, monitored relock, safety reset, and separate production START. If public evidence stops, rotate to the open two-retaining-element failure-disposition branch rather than inventing the missing state machine.
