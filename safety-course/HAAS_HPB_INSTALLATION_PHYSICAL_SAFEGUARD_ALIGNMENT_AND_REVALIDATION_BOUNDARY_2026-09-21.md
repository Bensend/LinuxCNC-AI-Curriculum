# Haas HPB installation: physical safeguard alignment and revalidation boundary

Date: 2026-09-21

## Question

What does a current press-brake OEM installation procedure prove after installation of hydraulic final elements and physical safeguard geometry, and what safety evidence remains unproven?

## Authoritative source

Haas Automation, Haas Press Brake Operator's/Service Manual, Chapter 4 Installation, Revision A 08/2026; Chapter 6 Maintenance, Revision A 07/2026.

Source URL: https://www.haascnc.com/service/online-manuals/haas-press-brake---operator-s--service-manual/4---hpb---installation.html

Maintenance URL: https://www.haascnc.com/service/online-manuals/haas-press-brake---operator-s--service-manual/6---hpb---maintenance-.html

Evidence class: DOC-CONFIRMED.

## What the OEM procedure actually establishes

The HPB installation procedure is unusually useful because it puts hydraulic and safeguarding work in the same machine-level commissioning document.

For the HPB-170-10, the installation procedure identifies Y1/Y2 proportional valves, requires seal rings to be present, installs the hydraulic lines and control connectors, and repeats the installation on both machine sides. It later requires control/hydraulic initialization before operation.

The same procedure then installs the light curtain and gives a physical alignment procedure. The punch is lowered to an approximate setup height, the pump is turned off and E-stop pressed before placing auxiliary tooling between punch and die, the emitter and receiver are physically aligned, mounting hardware is tightened, the auxiliary tooling is removed, and receiver indication is used to determine whether alignment is complete. The manual states that after adjustment the punch can move at high speed.

The current maintenance parts list independently shows that this machine architecture includes servo/solenoid valves, valve/manifold blocks, pressure sensor, safety relay, safety switches, contactors and light-curtain-related hardware. This is machine-specific evidence that hydraulic actuation, electrical safety components and physical safeguarding coexist as separate implementation layers.

## Critical evidence boundary

The public installation procedure proves a physical installation/alignment process. It does **not**, in the cited sequence, expose a complete post-installation safety acceptance matrix demonstrating all of the following as one chain:

`protective demand -> safety logic/output response -> hydraulic final-element safe response -> measured ram response/stopping performance -> quantitative acceptance -> safeguard geometry qualification -> production release`.

In particular, receiver indication that the light curtain is aligned/receiving is not itself evidence that interruption of the protective field produces the required hazardous-motion response at the machine. Likewise, successful control/hydraulic initialization is not quantitative proof of stopping performance or hydraulic safe-state behavior.

Freeze these distinctions:

- **LIGHT CURTAIN PHYSICALLY ALIGNED != PROTECTIVE FUNCTION MACHINE-RESPONSE VALIDATED.**
- **RECEIVER/STATUS INDICATION HEALTHY != RAM STOPPING RESPONSE PHYSICALLY PROVED.**
- **PROPORTIONAL VALVE INSTALLED/CONNECTED != SAFETY-RELATED HYDRAULIC FINAL-ELEMENT RESPONSE VALIDATED.**
- **CONTROL + HYDRAULIC INITIALIZATION COMPLETE != SAFETY ACCEPTANCE COMPLETE.**
- **FACTORY CONFIGURATION BACKUP CREATED != PHYSICAL SAFETY FUNCTION VALIDATED.**
- **SAFEGUARD GEOMETRY CHANGED != PREVIOUS GEOMETRY-DEPENDENT VALIDATION EVIDENCE STILL VALID.**

These are evidence-scope statements, not a claim that the Haas machine lacks other factory, service, certification or non-public validation procedures.

## Change-impact lesson

This OEM example gives a concrete physical-change case for the curriculum's partial-revalidation model.

A change to a light-curtain mount, emitter/receiver position, machine anchoring/level, tooling geometry or other physical arrangement can invalidate geometry-dependent evidence without changing the safety program or its checksum. A change to a proportional/servo valve, hydraulic connection, pressure-sensing path or manifold can invalidate hydraulic-response evidence without changing ordinary CNC logic.

Therefore change-impact analysis must trace dependencies into physical machine geometry and hydraulic final elements. Software identity is useful provenance, but it is not the outer boundary of safety validation.

## Practical commissioning scaffold derived without inventing OEM criteria

For a retrofit curriculum, do not copy an unknown Haas factory acceptance procedure. Instead preserve the evidence categories that a machine-specific validation plan must eventually fill:

1. installation/identity evidence for the changed component;
2. physical alignment/geometry evidence where the safeguard depends on geometry;
3. normal-demand functional challenge of the protective device;
4. physical final-element/machine-response witness;
5. quantitative performance evidence where safety distance or safe motion depends on stopping/response performance;
6. fault/mismatch tests required by the selected safety architecture;
7. repair/retest disposition after any failure;
8. separate production-release authorization and fresh ordinary START.

The actual OpenPressBrake test points, hydraulic truth table, stopping conditions, limits, distances, PL/SIL/category/DC/CCF, and release authority remain UNKNOWN until its design/risk assessment/validation establishes them.

## Human-factors implication

A safeguard that is easy to knock out of alignment, hard to restore, or gives ambiguous alignment feedback invites defeat. Mounting, alignment indication and the test procedure should make correct restoration easier than bypass. But an easy alignment indication must not be presented as a substitute for a functional machine-response test.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC, HAL, an HMI or the normal FPGA may record component identity, maintenance state, configuration hashes, alignment-test records and machine diagnostics. This does not make ordinary control software the personnel-safety authority and does not turn a software/status bit into physical proof of protective-field geometry, hydraulic final-element state or ram stopping performance.

## Information-gain result

This source advances the course because it is a current OEM press-brake installation sequence that physically touches both Y1/Y2 hydraulic proportional valves and light-curtain geometry. It does **not** provide the sought complete post-maintenance partial-acceptance matrix. The generic public press-brake-OEM search for that single all-in-one matrix is therefore approaching a source-availability stop.

A branch-reopening source would need to add genuinely new evidence: affected-function scoping after a change plus physical hydraulic/mechanical or safeguard response, quantitative criterion, failure disposition/retest, and explicit production release.

## Compute

No executable compute was justified. No GitHub-hosted runner was used.
