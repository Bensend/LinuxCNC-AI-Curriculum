# Reset, restart, cold-start, and stale-command authority study

Date: 2026-09-19

## Why this branch

The primary press-brake hydraulic post-service trace remains open, but another search did not produce an authoritative press-brake OEM procedure that closes the missing bridge from a named serviced retaining valve through an unmasked individual retaining challenge, installed ram/load witness, stopping-performance re-proof, and production release. Per WORK_SELECTION_POLICY, that source limit is branch-local, so this session rotated to a high-value safety-course branch rather than manufacturing a test.

## Evidence

### SICK — reset is a safety-function input, not a start command

**DOC-CONFIRMED.** SICK's *Safety Guide for the Americas* states that after a protective device has issued a stop command, the stopped state is maintained until manual reset and subsequent restart. The reset signal is part of the safety function and must be wired discretely to safety logic or transmitted over a safety-related bus. Reset must not initiate movement or a hazardous situation; a separate start command is required after reset. SICK also requires intentional reset actuation, permits reset only when safety functions/protective devices are functional, and places the reset device outside the hazard zone where the hazard zone can be overseen.

Source: https://www.sick.com/media/docs/6/06/606/Special_information_Safety_Guide_For_The_Americas_en_IM0032606.PDF (search result inspected 2026-09-19).

### Pilz — emergency-stop release/reset prepares restart; it does not restart

**DOC-CONFIRMED.** Pilz's current FAQ on emergency stop in a machine line states that the initiating emergency-stop device is reset intentionally at that device, and that resetting it must not automatically restart the machine; it only prepares the machine for restart. Starting must require voluntary actuation of a control device intended for that purpose. Pilz also notes that if the relevant operating range cannot be fully checked from the E-stop position, additional reset/start provisions may be required by risk assessment.

Source: https://www.pilz.com/en-US/support/faq/standards/articles/180045 (inspected 2026-09-19).

### Rockwell — reset and start can be physically distinct stages

**DOC-CONFIRMED.** Rockwell Automation Safety Function application technique SAFETY-AT122A-EN-P describes a safety-mat/E-stop system in which clearing the demand is insufficient: the safety relay is reset by pressing/releasing Reset, and hazardous motion begins only after the separate Start button is pressed. The document explicitly says hazardous motion does not resume on E-stop release and that safety reset does not resume motion until a secondary Start action occurs.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at122_-en-p.pdf (inspected 2026-09-19).

### Rockwell — cold start is itself a restart-policy decision

**DOC-CONFIRMED.** Rockwell's current Safe Stop 1/2 safety-instruction documentation exposes both `Restart Type` and `Cold Start Type`. With manual cold start, applying controller power or changing to Run requires a new Reset transition before the safety instruction can operate. Automatic cold start is a separately configurable behavior. Automatic restart is cautioned for use only where its use cannot create an unsafe condition.

Sources:
- https://www.rockwellautomation.com/en-pl/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/drive-safety-instructions/ss1.html
- https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-00/contents-ditamap/instruction-set/drive-safety-instructions/ss2.html

## Curriculum conclusions

Freeze the following authority chain:

**HAZARD DEMAND CLEARED != SAFETY RESET PERMITTED != SAFETY RESET COMPLETED != SAFETY FUNCTION READY != ORDINARY START REQUEST FRESH != HAZARDOUS MOTION AUTHORIZED.**

Also freeze:

**POWER RESTORED != COLD-START SAFETY RESET SATISFIED != ORDINARY CONTROL STATE TRUSTWORTHY != STALE START ABSENT != PRODUCTION AUTHORITY.**

A reset device is not merely a convenience button. In architectures requiring manual reset, its location and intentional edge/action are part of the safety-function design. Conversely, the ordinary START control is not a substitute for safety reset unless a validated architecture explicitly combines functions without creating unexpected restart risk.

## LinuxCNC / ordinary-controller boundary

**INFERENCE, bounded by the manufacturer evidence above and the repository safety contract.** LinuxCNC, a normal FPGA, PLC-style HAL logic, or an HMI may request ordinary machine motion after safety permission is available, but retained ordinary-control state must not silently become a fresh production command when a safety demand clears, safety power returns, or a safety reset occurs. The independent safety architecture must not rely on ordinary LinuxCNC software to make a personnel-safety reset valid.

A practical commissioning challenge should therefore include stale-command conditions: hold or latch an ordinary START request, demand the safeguard/E-stop, clear the initiating device, perform the required safety reset, and prove hazardous motion does not resume until the architecture's required fresh intentional production initiation occurs. Exact implementation and whether an edge, release/repress, state transition, or other command qualification is required are machine/design specific and must not be invented.

## Human-factors consequence

Reset and restart controls should make the correct sequence easier than bypassing it. A reset location that cannot see the protected area, a confusing combined reset/start behavior, or a workflow that repeatedly forces operators to defeat safeguards is a design defect to correct, not merely an operator-training problem.

## UNKNOWN / machine-specific

Do not infer for OpenPressBrake or another machine without design evidence:

- exact reset locations;
- whether each safety function uses manual or automatic reset;
- cold-start policy;
- exact stale-command rejection implementation;
- whether a given safe-motion function permits automatic restart;
- required reset timing/edge semantics;
- machine-specific production-start sequence;
- safety performance level/category from these examples.

## Next work

Return first to the primary hydraulic source trace. Seek an authoritative press-brake OEM/manifold procedure naming the serviced retaining/safety valve and its post-reassembly functional test. If that remains source-limited, continue safety-course work on commissioning tests for stale command, power restoration, safety-controller restart, and mode transition while keeping ordinary LinuxCNC command authority separate from personnel-safety authority.
