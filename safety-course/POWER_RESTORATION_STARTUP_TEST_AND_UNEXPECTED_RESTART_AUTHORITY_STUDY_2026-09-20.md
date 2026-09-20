# Power Restoration, Startup Test, and Unexpected-Restart Authority Study

Date: 2026-09-20
Course: 4000 safety / professional machine implementation
Lane: independent safety Lane B

## Question

What must be proved after loss and restoration of control power so that restoration of safety inputs or safety-controller readiness cannot silently become hazardous-motion authority?

## Evidence

### Pilz PNOZ e4.1p startup-test behavior

**DOC-CONFIRMED.** Pilz documents a start-up test that prevents automatic restart after a power failure and return of voltage. After supply voltage is applied, the unit requires the safety mat to be activated and then cleared. In manual-restart mode the unit additionally does not become active until the start button has been operated and released while the mat is clear.

Source: Pilz, PNOZ e4.1p Operating Manual 21362-EN-09, operating modes/start-up test.
Public source: https://www.pilz.com/download/open/PNOZ_e4_1p_Operat_Man_21362-EN-09.pdf

This is useful because power restoration is treated as a distinct commissioning/runtime transition, not merely another scan with all inputs currently healthy.

### Pilz PNOZ s5 warning on automatic/manual-start wiring

**DOC-CONFIRMED.** Pilz warns that automatic start, or a manual-start circuit defeated by a bridged start contact, can cause the unit to start automatically when the safeguard is reset (for example when an E-stop is released). The manual directs the machine designer to use external circuit measures to prevent unexpected restart.

Source: Pilz, PNOZ s5 Operating Manual 21397-EN-11, start circuit/feedback loop.
Public source: https://www.pilz.com/download/open/PNOZ_s5_Operat_Man_21397-EN-11.pdf

This establishes that a safety relay's reset/start mode cannot by itself be interpreted as complete machine restart policy.

### Pilz safeguard/reset guidance

**SOURCE-CONFIRMED.** Pilz's movable-guard guidance states that after a safeguard has triggered, clearing the protected field must not automatically restart the machine; restart is via a reset control outside the danger zone with visual contact. Its E-stop guidance separately states that resetting the operated E-stop prepares the machine to restart but must not itself restart it; starting machinery requires voluntary actuation of a control device provided for that purpose.

Sources:
- https://www.pilz.com/en-IE/support/law-standards-norms/iso-standards/choosing-guards/movable
- https://www.pilz.com/en-CA/support/faq/standards/articles/180045

### Rockwell monitored-manual reset semantics

**DOC-CONFIRMED.** Rockwell's Guardmaster safety-relay manual distinguishes monitored manual reset from automatic/manual reset. Monitored manual reset requires an off-on-off reset pulse in a prescribed period and executes reset on the trailing edge. Automatic/manual reset can execute immediately when the reset input is continuously on and safety inputs become active. This provides a concrete implementation reason to test reset-edge freshness rather than treating a high reset signal as proof of deliberate post-fault action.

Source: Rockwell Automation, Guardmaster Safety Relays User Manual 440R-UM013, reset definitions.
Public source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um013_-en-p.pdf

## Architecture conclusions

Freeze these distinctions:

**CONTROL POWER RESTORED != SAFETY INPUTS REQUALIFIED.**

**SAFETY INPUTS HEALTHY != STARTUP TEST COMPLETE.**

**STARTUP TEST COMPLETE != SAFETY RESET/REARM ACCEPTED.**

**SAFETY RESET/REARM ACCEPTED != ORDINARY MACHINE START.**

**RESET INPUT HIGH ACROSS POWER RESTORATION != FRESH DELIBERATE RESET ACTION.**

**ORDINARY START COMMAND HELD ACROSS POWER LOSS/RESTORATION != FRESH POST-RESTORATION START AUTHORITY.**

A safety component may support automatic reset without that making automatic machine restart acceptable. Conversely, a monitored reset edge proves only the reset transaction that component is designed to supervise; it does not prove personnel clear, hydraulic/mechanical safe state, safeguard geometry, final-element response, or production authority.

## Commissioning / validation worksheet

For an eventual OpenPressBrake safety architecture, the acceptance plan should deliberately challenge these transitions where applicable:

1. Establish ordinary ready state with no hazardous motion.
2. Hold an ordinary START/CYCLE/JOG request active, remove control power, then restore power. Verify that restoration alone does not produce hazardous motion.
3. Restore power with a safety input already in its nominal healthy state. Verify any architecture-required startup test/requalification rather than assuming a static healthy level proves the input path.
4. Hold RESET continuously active across power restoration. Where monitored/fresh reset is required, verify that the stale level is rejected.
5. Perform the deliberate safety-input test/cycle required by the selected safety device, then perform the required reset/rearm action. Verify that this establishes safety readiness only.
6. Keep the preexisting ordinary motion command stale through requalification/reset and prove it cannot become post-reset motion authority.
7. Release the stale ordinary command and issue a separate fresh ordinary START/JOG/CYCLE action; only then may normal control request motion, subject to every other safety prerequisite.
8. Repeat relevant cases after E-stop reset and guard/protective-device restoration so power-up behavior cannot bypass the normal reset/restart boundary.
9. Where the final architecture claims external-device monitoring or hydraulic/mechanical safe-state feedback, witness the actual downstream final elements rather than only LinuxCNC/HAL/FPGA or safety-controller status bits.

## LinuxCNC / FPGA boundary

LinuxCNC, HAL, HostMot2/FPGA and an ordinary machine-control MCU may observe power-good, safety-ready, reset-request and start-command states for sequencing and diagnostics. They must not be treated as the personnel-safety authority merely because their state machine rejects stale commands correctly. The independent safety architecture must establish its own required power-up/requalification behavior and final-element authority.

A useful normal-control design rule is still to edge-qualify or otherwise freshness-qualify ordinary motion commands across safety loss and power restoration. That is defense in depth and production-state hygiene, not a replacement for the independent safety function.

## OpenPressBrake boundary

**UNKNOWN:** exact power domains, safety-controller architecture, safety-relay/controller reset mode, startup-test requirement, retained-state behavior, E-stop topology, guard/protective-device topology, hydraulic safe state, final elements, reset station location, PL/SIL/category/DC/CCF, timing, and production-release procedure.

Do not copy the PNOZ mat startup sequence, Rockwell reset timing, or any manufacturer-specific wiring directly into OpenPressBrake without selecting and validating the actual safety architecture.

## Evidence status / next work

This closes the generic power-restoration/restart semantic gap well enough for curriculum architecture. Further cataloging of reset modes is low value.

Next high-value evidence is a complete machine/OEM commissioning procedure that deliberately performs **power loss/restoration with START/JOG held -> startup requalification -> deliberate reset/rearm -> stale command remains ineffective -> fresh ordinary start -> physical final-element/machine response**, preferably with a deliberate reset-contact or safety-input fault. If the primary lane enters this exact evidence package first, Lane B should rotate to another independent 4000 safety branch.

No executable verification was justified. No GitHub-hosted runner was used.