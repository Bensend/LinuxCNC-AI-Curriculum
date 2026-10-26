# 4400 ROPE-PULL-01 — whole-span emergency-stop cable: practical field module

**Status:** learner-facing engineering module; **NON-GRADUATED**. All public PAPER cases below **UNSCORED**; all documentary gates **NOT RUN**. **No machine operation or energized fault injection authorized.**

**Source prerequisite:** [Rockwell Lifeline 5 / Schneider XY2CE original-source audit](../research/4400_ROPE_PULL_01_ROCKWELL_SCHNEIDER_CABLE_TENSION_RESET_COVERAGE_OEM_AUDIT_2026-10-26.md). Previous 2520/2530 E-stop, 25D0 guarding, 25E0 validation, 25F0 machine transfer, 4400 ESTOP-MECH/PENDANT/RF/OT-SEC lessons remain applicable.

## Objective

A technician or fresh AI must distinguish **reachable cable**, **actual tension/sensor state**, **independent safety command**, **physical machine stop**, and **deliberate safe restart**. A cheap rope pull can be a practical, visible safeguard for a long exposed conveyor, but only if the installed mechanical path is reachable and tested. Neither the rope's red color nor a green HMI status proves those propositions.

## Four independent boundaries

| Boundary | Question | Acceptable type of witness | Invalid shortcut |
|---|---|---|---|
| Mechanical coverage | Can a person at *every intended location* actuate the cable in realistic directions, including corners? | Selected OEM geometry plus qualified installed-span pull/inspection evidence | Tug once beside the switch; assume the far end works |
| Protective-device state | Does pull, cable break/slack and electrical fault reach the required safety input? | Exact product/variant wiring, safety-input state, fault behavior | Treat auxiliary lamp or normal HAL pin as safety-rated |
| Physical safe state | Did conveyor/tool/ram stop and remain safely held? | Independent qualified physical motion/final-element/load witness | OSSD OFF, relay LED OFF, LinuxCNC E-stop bit |
| Restart authorization | Can anyone be trapped/hidden when resetting; is a **new deliberate start** needed? | Zone visibility/inspection, independent restart interlock, physical rearm validation | Reset switch and immediately resume prior queued motion |

**Rule:** if the minimum safe-to-operate threshold cannot be demonstrated, no personnel-exposed hazardous operation. Any experiment must be isolated/remote with people outside the danger zone, and residual risk declared.

## Practical, inexpensive architecture pattern — NOT an as-built schematic

Use a selected and appropriately rated rope-pull device with its exact OEM spring, guides/pulleys, mounting, and wiring; independent safety relay/controller with verified reset/restart interlock; appropriately selected physical stop/final elements; clear local indication; protected yet reachable red cable; easy-to-access tensioner and inspection route. Route away from forklifts/material handling without moving the emergency interface out of reach. Use captive brackets, documented spare parts, readable fault/tension indicators, and maintenance instructions that do not require bypassing the guard to access the adjustment.

**Never** assign the safety decision to ordinary LinuxCNC/HAL, FPGA, a normal PLC bit, web HMI, or remote support session. They may observe/diagnose and inhibit normal commands.

### Manufacturer variant trap

For **Rockwell Lifeline 5** (February 2026 p. 5), a **green status plus amber flashing tension indicator** can mean **low/high tension margin with safety outputs still ON**. A cut/not-tensioned cable and a pulled cable instead switch safety outputs OFF in the specified OSSD table. This is not a universal LED convention. **Schneider XY2CE** (2017 p. 2) requires its particular end spring, cable and guide spacing; do not borrow Rockwell dimensions. The Schneider catalog distinguishes latching NC safety contacts from NO indication contacts and separates local reset from machine start.

## Twelve public PAPER scenarios — all UNSCORED

| ID | Technician observation / challenge | Required reasoning or evidence to request |
|---|---|---|
| RP-P01 | Green Rockwell status and amber tension lamp; operator says “green means certified safe.” | Distinguish still-ON safety output, maintenance warning, full-span coverage and physical stop. |
| RP-P02 | Rope is severed 8 m from sensor; HMI still says “Ready.” | Demand exact model and independent safety-input evidence; HMI freshness/mapping may be wrong. |
| RP-P03 | Rope works at switch but not around a roller/guard corner. | Diagnose friction/routing/pulley/access, require direction-by-direction physical proof. |
| RP-P04 | New spring installed from an unrelated product because it fits. | Reject part equivalence by appearance; require exact OEM assembly and revalidation. |
| RP-P05 | Forklift traffic catches cable; maintenance ties it above reach. | Redesign routing/protection so the reachable, non-defeated safeguard is easiest to maintain. |
| RP-P06 | Machine stops electrically after pull, but conveyor keeps coasting. | Separate device off-response from measured physical stopping/kinetic energy and exposure. |
| RP-P07 | A technician resets at one end while another clears a jam around a blind corner. | Full-span visibility/inspection and separate deliberate start; LOTO for covered servicing. |
| RP-P08 | Temperature changes and the tension warning begins blinking. | OEM thermal/length/variant review, inspect anchors/turnbuckle; don't invent a universal limit. |
| RP-P09 | A replacement switch has same housing but 5-pin vs 8-pin interface. | Verify exact OSSD/GuardLink/wiring and diagnostic semantics; revalidate dependent logic. |
| RP-P10 | A NO auxiliary contact is wired as the sole emergency-stop input. | Identify Schneider's signaling-only NO distinction and require qualified NC/safety path. |
| RP-P11 | Rockwell sensor shows OSSD OFF and LinuxCNC shows E-stop, but hydraulic press ram can descend. | Identify independent gravity restraint/valves/load-hold and physical Y1/Y2 proof, not rope switch alone. |
| RP-P12 | A remote supervisor wants a software reset immediately after an accidental rope pull. | Demand local inspection/zone-clear, fault cause, independent reset, and fresh start; reject remote motion authority. |

**Do not publish an answer key or self-score these scenarios as blind competence.** An independent evaluator must supply a different unseen problem and withhold its oracle until immutable learner precommitment.

## Ten documentary verification gates — all NOT RUN

| Gate | Required artifact/witness | Release blocker if absent |
|---|---|---|
| RP-G01 | Exact installed machine, lifecycle/exposure and jurisdiction scope | UNKNOWN application; cannot claim requirement or installation |
| RP-G02 | Exact sensor/variant, dated original manual, wiring mode, selected safety controller | UNKNOWN safety-input function |
| RP-G03 | Cable route drawing with every reachable span, turn, support, hazard approach and blind spot | UNKNOWN coverage |
| RP-G04 | OEM spring/cable/pulley/guide/anchor part identity, support strength and adjustment | UNKNOWN mechanical transmission |
| RP-G05 | Tension/temperature/maintenance-margin response with status/OSSD distinction | UNKNOWN degradation response |
| RP-G06 | Qualified no-person-exposed validation plan for pulls in all directions, break/slack and fault paths | NOT RUN; no coverage proof |
| RP-G07 | Independent stop-function chain and physical final-element/stopping/load witness | UNKNOWN safe state |
| RP-G08 | Reset sightline/inspection and independent deliberate restart with held commands cleared | UNKNOWN rearm safety |
| RP-G09 | Service LOTO, change-control/part equivalence, accessible inspection, anti-defeat usability | UNKNOWN maintainability |
| RP-G10 | Independent evaluator precommitment, scoring and transfer retest | NOT RUN; no competency graduation |

These are **documentary readiness gates**, not an instruction to perform hazardous rope pulls or fault injections on an unqualified machine. Only qualified personnel under a machine-specific safe validation plan may later perform physical testing.

## Source-to-claim ledger and cross-machine transfer

- **DOC-CONFIRMED OEM:** Rockwell 440E-IN008H (Feb. 2026) p. 5 tension/safety table, p. 6 thermal example, p. 18 maintenance; Schneider S1A6956103-06 (Dec. 2017) p. 2 mechanical/inspection requirements and XY2C catalog p. 3 reset/NO-NC distinction.
- **DOC-CONFIRMED regulation (narrow scope):** OSHA 1926.555 construction conveyors; OSHA 1910.269(v)(11) specified power-generation conveyors; OSHA 1917.48 marine terminals. **Do not treat these as a press-brake code**.
- **INFERENCE:** proposed user-friendly mechanical routing, diagnosis, zone inspection and restart architecture.
- **UNKNOWN:** any OpenPressBrake rope pull, actual final elements, physical stop/hold, selected PL/SIL, tested geometry, measured stopping time, external evaluator.
- **SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied upon.

**Transfer:** conveyors/material handling and woodworking have long accessible spans; mills/lathes generally need point-of-operation and access guarding rather than assuming one perimeter rope protects inside the machine; automated cells need whole-body access/escape and interlocked rearm; hydraulic press brakes require independent front/rear point-of-operation safeguarding, Y1/Y2 stopping and gravity hold. A rope-pull E-stop is supplementary, never a substitute for prevention of routine exposure.

## Safety design package mapping

Create selected-machine `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/HF/ARC/VAL/PT/CHG/RR/UNK` entries **only when real machine evidence exists**. Before then preserve `UNKNOWN`, `NOT RUN`, `HOLD` and avoid invented PL/SIL, stop distances, pressure limits, cable force, diagnostic coverage, proof-test interval or installation approval. Any cable/anchor/guide/firmware/safety-controller change is a potential `CHG` invalidating affected proof.

**G0/G1 HOLD. G2 NOT RUN. G3/G4 NOT AUTHORIZED. G5 HOLD.** No personnel-exposed hazardous operation.


## Source addendum — series wiring and non-safety controller tags

A second inspection of the **same Rockwell Lifeline 5 original manual** found that its 432ES I/O-tree diagnostic tags are explicitly **standard, non-safety-rated** (printed p. 10), even though they describe safety-device operation. The manual's p. 11 **OSSD-only series** example is described as usable in functions up to **PLe**, while its **mixed voltage-free-contact series** example has a stated **PLd maximum depending on installation**. This is an exact OEM architecture distinction, **not** a selected machine PL assignment. Disabled electronic keying is designated for troubleshooting only. An apparently healthy HMI diagnostic or enumerated module must not substitute for a qualified safety-function path. See the [source audit addendum](../research/4400_ROPE_PULL_01_ROCKWELL_SCHNEIDER_CABLE_TENSION_RESET_COVERAGE_OEM_AUDIT_2026-10-26.md). No new PAPER case or gate has been scored or executed.
