# 4400-BAR-01 — Bar whip, liner versus grip and mode-dependent feeder-door authority
**4000 safety | 2026-10-25 | NON-GRADUATED / documentary only**

## Prerequisites
2520 hazard map, 2530 E-stop span, 2570 motion stopping, 2590 guards, 4400-CELL-01 cross-machine reset and 4400-CHUCK-01 workholding. Read [original Haas OEM edition/version audit](../research/4400_HAAS_BAR_FEEDER_LINER_WHIP_DOOR_MODE_VERSION_OEM_AUDIT_2026-10-25.md) and [12 PAPER scenarios](4400_BAR_01_DOOR_LINER_WHIP_TECHNICIAN_CARD_2026-10-25.md).

## Mechanism
**DOC-CONFIRMED:** a spindle liner guides bar stock and reduces whip but does not grip it; a collet/drawtube provides retention. Unsupported rotating bar can whip; liner geometry, material straightness, rear enclosure and selected RPM all matter. **DOC-CONFIRMED OEM version-specific:** Haas software 100.23.000.1200+ permits some feeder arms/loader movement to finish a step with feeder door open, and may leave the lathe cycle running absent a bar-feeder motion command. A 'door open => entire cell stopped' assumption is false for this documented configuration.

## Authority map
| Layer | Scope |
|---|---|
| Ordinary lathe/feeder controller | part program, bar feed command, trolley and loader requests; not personnel-safety authority |
| Monitoring/diagnostics | door position, feeder state, collet/clamp sensor, spindle command, bar-presence/liner configuration; not a physical safe-state proof |
| Independent safety-related control | selected hazard-zone stop, access/guarding and fresh-start functions with exact firmware and mode truth table |
| Physical mechanisms | actual spindle stop, collet retention, bar liner/support, rear containment, physical guarding and electrical/pneumatic isolation |

## Safety functions to design, NOT an installed solution
SF-BAR-WHIP: prevent hazardous bar motion/whip under selected speed, length, material and support. SF-BAR-ACCESS: prevent access to every moving trolley/lifter/loader/spindle hazard, not only the axis stopped by a lid switch. SF-BAR-HOLD: actual collet grip verified independently of liner presence. SF-BAR-RESTART: closing a lid and resetting safety must not independently restart hazardous motion; require deliberate new start and no stale command. SF-BAR-SERVICE: maintenance access requires task-specific isolation, stored-energy and pinch-zone control.

## Human factors and failure review
Provide accessible correctly sized liner storage and simple change confirmation; a robust guard that opens/reinstalls easily; a clear indication of which axes may still move; an unambiguous safe bar-remnant and jam recovery workflow; rear bar containment that does not obstruct routine loading. A routinely bypassed feeder lid is a design usability defect. Do not substitute an HMI 'feeder stopped' icon for independent physical motion/occupancy proof.

## Qualification
Original OEM claims DOC-CONFIRMED for exact manual/software; cross-machine safety architecture INFERENCE; selected installation, PL/SIL, stop/whip criteria and physical witnesses UNKNOWN. No SOURCE-CONFIRMED LinuxCNC feeder implementation, no TEST-CONFIRMED, no external score. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. If minimum independent protection is absent, do not operate with personnel exposed; isolated/remote only with people outside danger zone and qualified residual-risk plan. This is a new 4400 safety branch, not reopening graduated 3200.