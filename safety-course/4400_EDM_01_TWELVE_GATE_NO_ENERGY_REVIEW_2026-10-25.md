# 4400-EDM-01 — 12-gate no-energy documentary review
**2026-10-25 | ALL GATES NOT RUN | Qualified review required | No energized test recipe**

This is a document/review checklist for a **specific future selected machine**, not proof that any OpenPressBrake safety function exists. Use [G0 intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) and keep proprietary diagrams in the restricted project.

| Gate | Qualified documentary evidence to inspect | Current disposition |
|---|---|---|
| 01 | Selected machine revision, mode/access map, exact installed safety device model/firmware/manual edition | NOT RUN / UNKNOWN |
| 02 | Hazard-specific SRS for stop, guard access, hold, reset, restart and maintenance | NOT RUN / UNKNOWN |
| 03 | Dual-channel protective inputs, short/cross fault detection and actual safety logic owner | NOT RUN / UNKNOWN |
| 04 | Exact reset mode (auto/simple manual/monitored rising/falling), wiring and stuck-button response | NOT RUN / UNKNOWN |
| 05 | Reset station location, visibility, whole-body access and inside escape requirements | NOT RUN / UNKNOWN |
| 06 | Actual EDM circuit, mechanically linked NC contacts, bypass/jumper history and diagnostic response | NOT RUN / UNKNOWN |
| 07 | Safety output contact versus auxiliary/HMI output allocation and separate normal LinuxCNC/FPGA commands | NOT RUN / UNKNOWN |
| 08 | Final contactor/drive/valve part identities, safety outputs and residual/common-cause paths | NOT RUN / UNKNOWN |
| 09 | Power loss/return, E-stop release, guard restore, off-delay and retained pedal/cycle requests | NOT RUN / UNKNOWN |
| 10 | Replacement/configuration management: exact defaults, configuration readback and stale evidence invalidation | NOT RUN / UNKNOWN |
| 11 | Independent Y1/Y2 physical stop/hold and pressure-zone/accumulator/isolation verification plan from outside danger zone | NOT RUN / UNKNOWN |
| 12 | Qualified independent reviewer disposition, non-bypass usability, external evaluation and next restricted witness links | NOT RUN / UNKNOWN |

**G0 documentary readiness** is possible only after coherent signed evidence; it is not G1 isolated-test permission, G2 physical proof, G3 personnel-exposed operating release or G4 maintenance entry. A generic example diagram, a matching connector, a software simulation, an HMI READY bit or an EDM loop alone is insufficient. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.**

**Failure-path minimum:** identify what happens for a bridged reset, welded contactor, shorted EDM, light-curtain receiver replacement, recovered field during off-delay, stale foot command and loss of hydraulic holding. No forced faults on a live machine are authorized here. No PL/SIL, stop time, distance, pressure or diagnostic coverage numbers have been calculated.
