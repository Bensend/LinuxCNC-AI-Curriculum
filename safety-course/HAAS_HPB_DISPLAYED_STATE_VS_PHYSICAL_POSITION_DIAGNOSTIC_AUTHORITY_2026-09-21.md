# Haas HPB displayed state versus physical position: diagnostic authority

Date: 2026-09-21

## Source

Haas Automation, Haas Press Brake Operator's/Service Manual, Chapter 7 Troubleshooting, Revision A 08/2026.

URL: https://www.haascnc.com/service/online-manuals/haas-press-brake---operator-s--service-manual/7---hpb---troubleshooting.html

Evidence class: DOC-CONFIRMED.

## Durable lesson

The current Haas HPB troubleshooting procedure contains a particularly clean physical-witness rule for the crowning mechanism. During service it requires the technician to record the displayed deflection position, inspect the physical position of the position sensor, and compare the two. If the motor physically moves but displayed feedback does not change, changes in the wrong direction, or does not correspond to physical sensor position, the procedure says to inspect the feedback system before continuing and warns against repeatedly commanding toward end of travel.

The same procedure separately identifies normal end-of-travel switches and additional hard-stop travel safety switches, and instructs the technician to verify actual direction after phasing changes rather than trusting the command alone.

Freeze:

- **COMMAND DIRECTION != PHYSICAL DIRECTION.**
- **DISPLAYED POSITION != PHYSICAL POSITION.**
- **PHYSICAL MOTION OBSERVED != POSITION FEEDBACK VALID.**
- **FEEDBACK CHANGES != FEEDBACK DIRECTION/CORRESPONDENCE CORRECT.**
- **FAULT CLEARED FROM HARD STOP != NORMAL OPERATING GEOMETRY RESTORED.**

This is a machine-OEM example of the curriculum's witness ladder: command, physical response, sensor response, correspondence check, and only then continued authority.

## Hydraulic relevance without overclaim

The same troubleshooting chapter identifies a pressure-transducer failure on the synchronization valve and hydraulic symptoms including pressure loss, leakage, jammed relief-valve spool, slider creep, and slider drop associated with a stuck valve core, leaking safety valve or cylinder seal. This demonstrates why a controller state or valve command cannot stand in for physical hydraulic condition.

However, the public troubleshooting table is diagnostic guidance, not a safety acceptance truth table. It does not establish which hydraulic faults are safety-related, what quantitative thresholds apply, or what exact post-repair validation is required before production. Those remain design/OEM-specific.

## Curriculum application

For OpenPressBrake, ordinary LinuxCNC/HAL/FPGA diagnostics should expose disagreement rather than normalize it away. A displayed state derived from the same command that caused motion is weak evidence of physical state. Where the safety architecture requires a physical witness, use an appropriately independent physical feedback path and validate its mapping/direction/correspondence under the actual machine design.

Do not infer a particular sensor, redundancy, PL/SIL, threshold, travel limit or hydraulic truth table from the Haas example.

## Compute

No executable compute was justified. No GitHub-hosted runner was used.
