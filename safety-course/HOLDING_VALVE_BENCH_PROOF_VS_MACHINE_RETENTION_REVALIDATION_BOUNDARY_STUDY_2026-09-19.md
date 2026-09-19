# Holding-valve bench proof vs machine retention/revalidation boundary study

Date: 2026-09-19

## Question

Can authoritative professional hydraulic service evidence close any part of the current press-brake post-service chain without inventing an OpenPressBrake hydraulic truth table or machine-specific acceptance threshold?

## Source trace

Primary source: Terex Utilities Tech Tip 38, *Adjustable Hydraulic Valves*, released 2022-03-22, v1.0. This is not a press-brake source and must not be projected onto a press brake as a machine-specific procedure. It is useful as professional component-level hydraulic service evidence.

Source URL: https://www.terex.com/docs/librariesprovider7/tech-tips/techtip_38.pdf

The source states that before a holding valve is removed, trapped cylinder pressure must be relieved as much as possible and the supported component/assembly must be properly supported; removal of the holding valve can otherwise allow the cylinder load to free-fall.

For the holding-valve test itself, Terex directs the technician to remove the valve and install it in an appropriate holding-valve test block, tee a pressure gauge into the load-holding side with a hydraulic pressure source, increase pressure on the load-supporting port, observe opening behavior, adjust to the specified value, verify that the valve resets and maintains the manufacturer-specified value, lock the adjustment, and repeat the test.

Terex separately warns that the Tech Tip supplements rather than replaces the machine Service Manual.

## Evidence classification

### DOC-CONFIRMED

- A professional hydraulic OEM/service source treats safe support of the load before removal as a separate requirement from proof of the removed holding valve.
- A holding valve can be challenged individually outside the machine in a dedicated test block, eliminating a companion machine retaining path from the component test.
- The component test uses a physical pressure witness at the valve's load-holding side and verifies both opening behavior and reset/maintenance of the specified manufacturer value.
- The adjustment is locked and the test repeated, so `ADJUSTED ONCE` is not treated as final proof.
- The component-level procedure remains subordinate to the machine-specific Service Manual.

### INFERENCE

- An off-machine test block is one legitimate engineering pattern for defeating companion-path masking when the question is the individual valve's own pressure-holding/setting behavior.
- This is stronger evidence for the individual component than command/monitor-contact agreement, because the hydraulic element itself is challenged by pressure.
- Passing the bench test still cannot prove correct installation, plumbing, pilot behavior, machine load retention, machine stopping performance, or machine-level safety function after reinstallation.

### TEST-CONFIRMED

None for OpenPressBrake. No lab was run.

### COMMUNITY-REPORTED

None relied upon.

### UNKNOWN

- Whether the eventual OpenPressBrake retaining/safety valve is adjustable or is appropriately tested by this pattern.
- Its manufacturer/model, required setting, allowable leakage, test fluid/temperature, proof pressure, duration, reset characteristic, contamination requirement, or service limits.
- Whether its OEM permits off-machine test-block proof after service/replacement.
- The actual OpenPressBrake hydraulic topology and whether there are two independent retaining elements whose individual machine-level proof requires isolation or another OEM-defined method.
- The required machine-level static ram/load retention test after valve reinstallation.
- Whether valve replacement invokes stopping/start-up tests on the eventual press-brake architecture.
- Production release, safety reset/rearm, and fresh-start requirements for the actual machine.

## Durable proof boundary

Freeze:

`LOAD PHYSICALLY SUPPORTED FOR VALVE REMOVAL != TRAPPED PRESSURE CONTROLLED != INDIVIDUAL VALVE BENCH-CHALLENGED != VALVE SETTING/RESET PROVED != VALVE CORRECTLY REINSTALLED != MACHINE STATIC RETENTION PROVED != DYNAMIC STOPPING PERFORMANCE PROVED != SAFETY REARM != FRESH PRODUCTION START`

Also freeze:

`COMPANION PATH REMOVED FROM COMPONENT BENCH TEST != COMPANION PATH PROVED IN THE MACHINE`

and

`INDIVIDUAL VALVE BENCH PASS != MACHINE RETAINING SAFETY FUNCTION PASS`.

## Curriculum consequence

Teach three distinct witnesses instead of one generic "hydraulics OK" result:

1. **Service restraint witness** — the hazardous load is independently supported and stored pressure is controlled before opening the circuit.
2. **Individual component witness** — where the component manufacturer/OEM permits it, the holding element itself is challenged without another retaining path masking its behavior.
3. **Machine-level witness after reassembly** — correct installation and the complete retaining/stopping safety functions still require the machine-specific OEM validation procedure and physical machine response.

This source supplies a concrete professional example of stage 2 but does not supply the press-brake-specific stage 3.

## Human-factors consequence

A design that makes individual retaining-element proof practical reduces pressure to accept ambiguous aggregate evidence. If an eventual OpenPressBrake hydraulic architecture uses multiple retaining elements, service access and test provisions should be designed so the OEM-defined individual proof can be performed without improvised bypasses. This is a design objective, not authority to invent a test circuit or defeat a safety path.

## Compute decision

No simulation/build/test was justified. The unresolved questions are machine/component documentation and physical architecture questions, not questions a generic simulation can answer. No GitHub-hosted compute and no self-hosted compute were used.

## Next primary-lane work

Return to press-brake/manifold-specific evidence. Seek a named holding/safety valve and an OEM post-service procedure that connects component service to machine-level static retention, failed-test disposition, stopping-performance re-proof where applicable, safety rearm, and fresh production initiation. Use the Terex pattern only as a comparison model for individual unmasked component proof; do not transplant its values or procedure into OpenPressBrake.
