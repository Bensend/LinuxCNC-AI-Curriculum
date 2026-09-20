# External Device Monitoring / Final-Element Feedback Authority Study

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Why this branch

The primary safety lane is currently advancing energized hydraulic diagnostic authority and post-service hydraulic evidence. This study deliberately uses a different evidence family and different files: downstream electrical final-element feedback, especially external device monitoring (EDM) of contactors/relays.

## Evidence labels

- **DOC-CONFIRMED** — stated by manufacturer documentation cited below.
- **SOURCE-CONFIRMED** — directly visible in an authoritative published connection/function description.
- **TEST-CONFIRMED** — requires an actual commissioned-machine test; none is claimed here.
- **COMMUNITY-REPORTED** — none used for the freezes below.
- **INFERENCE** — architecture conclusion derived from the cited evidence, not a claim about OpenPressBrake hardware.
- **UNKNOWN** — machine-specific facts not established by evidence.

## Core architecture lesson

A safety controller or protective device changing its own output state is not the same witness as the downstream power-control element physically reaching the demanded state.

Freeze:

`SAFETY INPUT DEMAND != SAFETY OUTPUT OFF != CONTACTOR COIL DE-ENERGIZED != CONTACTOR MAIN POLES PHYSICALLY OPEN != HAZARDOUS ENERGY REMOVED`.

A feedback/EDM circuit improves the evidence chain, but must not be promoted into proof of facts it does not sense:

`EDM FEEDBACK CORRECT != MAIN POWER PATH PHYSICALLY VERIFIED OPEN != MACHINE HAZARD PHYSICALLY CEASED`.

Likewise:

`RESET REQUEST != EDM HEALTHY != SAFETY REQUALIFIED != FRESH ORDINARY START`.

## Manufacturer evidence

### SICK M4000 external device monitoring

**DOC-CONFIRMED / SOURCE-CONFIRMED:** SICK's M4000 operating instructions describe EDM as checking whether the contactors actually de-energize when the protective device responds. The documented implementation uses positively guided N/C contacts from K1/K2; if the expected feedback is absent after the protective response, EDM prevents machine startup. The same manual separately requires reset/restart handling and places the reset device outside the hazardous area with visibility of that area.

Source: SICK, *M4000 Std., Std. A/P Operating Instructions*, section 6.3 External device monitoring and 6.4 Reset/restart button. Public manufacturer PDF: https://cdn.sick.com/media/content/hf7/hfc/9693002203166.pdf

### SICK UE440/UE470 cyclic EDM

**DOC-CONFIRMED:** SICK documents cyclic checking after each switch-off and before restart. A fused contact is an explicit example of a fault EDM can identify; the assigned safety output remains off. This is useful curriculum evidence because it makes downstream-state feedback part of the restart qualification rather than merely an HMI diagnostic.

Source: SICK, *UE440/UE470 Compact Safety Controller Operating Instructions*, section 4.2.7 External device monitoring. Public manufacturer PDF: https://www.sick.com/media/docs/3/53/153/operating_instructions_ue440_ue470_compact_safety_controller_en_im0014153.pdf

### SICK deTec4 configuration boundary

**DOC-CONFIRMED:** Current deTec4 documentation states that EDM is a configured function, requires correct wiring, and during configuration expects the contactor to be dropped out with the required feedback present. EDM is factory-deactivated in the cited device variant until configured. Therefore, presence of an EDM terminal or feedback wire alone does not establish that EDM is active or correctly commissioned.

Source: SICK, *deTec4 C4P-EAxxx3SC05 Operating Instructions*, 2025-07-07, section 7.5.3. Public manufacturer PDF: https://www.sick.com/media/docs/6/06/106/operating_instructions_detec4_c4p_eaxxx3sc05_en_im0107106.pdf

### Pilz output-contact proof interval example

**DOC-CONFIRMED:** Pilz's P2HZ X1 manual warns that when relay outputs are switched on, mechanical contacts cannot be automatically tested continuously. It requires periodic opening/restarting so internal diagnostics can check that safety contacts open correctly, and states that welded contacts prevent reactivation after the input circuit opens. This demonstrates a separate proof obligation for switching elements even when the safety relay itself is functioning.

Source: Pilz, *P2HZ X1 Operating Manual 20124-EN-10*. Public manufacturer PDF: https://www.pilz.com/download/open/P2HZ_X1_Operating_Manual_20124-EN-10.pdf

## What EDM proves — and what it does not

**DOC-CONFIRMED:** In the cited architectures, EDM compares commanded safety-output state with auxiliary feedback from downstream switching devices and can inhibit restart on disagreement.

**INFERENCE:** The strongest defensible generic claim is therefore that EDM is a *downstream switching-state diagnostic*. It is not automatically a sensor for every hazardous-energy path.

Examples that remain separate unless the actual machine design and validation prove otherwise:

- a welded/bypassed main contact not faithfully represented by the monitored auxiliary path;
- a second unmonitored contactor or alternate feed;
- stored DC-bus/capacitor energy after the contactor opens;
- gravity, hydraulic, pneumatic, spring or mechanical stored energy;
- drive behavior downstream of an opened upstream contactor;
- a contactor mechanically open but an independently powered hazardous subsystem still active.

These are architecture questions, not claims that any one failure exists on OpenPressBrake.

## LinuxCNC / FPGA authority boundary

Ordinary LinuxCNC, HAL, FPGA, HMI, and diagnostic software may display or record safety-system state, but they must not silently become the personnel-safety authority merely because they can see an EDM signal.

Freeze:

`HAL EDM_STATUS = TRUE != PERSONNEL-SAFETY AUTHORITY`.

`FPGA CONTACTOR_FEEDBACK = OFF != MACHINE ENERGY-ISOLATION PROOF`.

`SAFETY SYSTEM READY != LINUXCNC START COMMAND FRESH`.

A useful architecture exposes safety status read-only to ordinary control where desired while the independent safety function retains authority over the safety outputs, feedback qualification, fault latch/reset, and safe restart prerequisites.

## Commissioning / validation worksheet

For a real machine, record each item as **TEST-CONFIRMED** only after physical validation:

1. Identify every safety-controlled final switching element and the hazardous energy/path it actually controls.
2. Trace the safety demand from protective device/evaluator output to each final element.
3. Identify the exact feedback contact/sensor used for EDM and whether it is positively guided / mechanically linked as required by the chosen architecture.
4. Demand a stop and verify the safety output state.
5. Verify each monitored final element changes state and EDM observes the expected transition.
6. Verify the physical hazardous function reaches the required safe state; do not stop at the auxiliary-contact witness.
7. Introduce an approved commissioning fault or simulation that holds one feedback channel in the wrong state without creating uncontrolled hazardous motion; verify restart is inhibited and a diagnostic is produced.
8. Challenge a feedback wiring fault/cross-connection where the manufacturer's commissioning procedure permits it.
9. Verify reset cannot conceal an unresolved EDM fault.
10. Verify correcting the EDM fault does not itself restart hazardous motion.
11. Verify safety requalification remains separate from a fresh LinuxCNC/HMI/ordinary START/CYCLE command.
12. After contactor/relay, safety-controller, wiring, or configuration replacement, repeat the affected validation rather than accepting normal communications or an HMI-ready indication as proof.

## Failure-path table

| Challenge | Required architectural question |
|---|---|
| One contactor welds/sticks | Does feedback disagree and inhibit restart? |
| Feedback contact/wire sticks in healthy state | Is this fault detectable by the actual architecture/test regime? |
| Safety output turns off but final element does not | Is disagreement detected before restart? |
| Final element opens but hazardous energy persists | What separate physical witness proves the hazard ceased? |
| EDM configuration is disabled/lost | How is commissioning/configuration identity verified? |
| Power cycle with prior EDM fault | Does the fault remain safely dispositioned rather than auto-authorizing motion? |
| Stale LinuxCNC START/CYCLE remains asserted | Can safety recovery accidentally convert it into motion authority? |

## OpenPressBrake status

**UNKNOWN:** Whether the final OpenPressBrake safety architecture uses external contactors, force-guided relays, drive STO feedback, hydraulic valve-position feedback, EDM in a safety relay/PLC, or another final-element diagnostic pattern.

**UNKNOWN:** Required PL/SIL/category/DC/CCF, contactor count, feedback topology, diagnostic timing, proof-test interval, stop category, or acceptance timing.

No machine-specific timing, stopping distance, hydraulic truth table, pressure threshold, or safety performance is assigned by this study.

## Durable next-work checkpoint

Highest-value continuation for this branch: find a complete professional machine or safety-controller implementation that exposes the entire chain

`PROTECTIVE DEMAND -> SAFETY EVALUATOR -> TWO/REDUNDANT FINAL SWITCHING ELEMENTS -> INDIVIDUAL FEEDBACK/EDM -> DELIBERATE ONE-ELEMENT STUCK/WELDED CHALLENGE -> RESTART INHIBIT -> PHYSICAL HAZARD/ENERGY WITNESS -> CORRECTION -> REVALIDATION -> SAFETY RESET/REARM -> FRESH ORDINARY START`.

Prefer an OEM machine schematic or manufacturer application example that shows both the main power contacts and their feedback contacts, rather than another isolated definition of EDM.

## Compute

No simulation, synthesis, benchmark, or executable verification is justified by this evidence question. No GitHub-hosted runner is required. If a later concrete runtime test is warranted, use only the self-hosted runner labelled `[self-hosted, openpressbrake]`.