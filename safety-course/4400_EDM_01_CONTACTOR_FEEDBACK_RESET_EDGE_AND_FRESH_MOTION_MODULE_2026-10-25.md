# 4400-EDM-01 — Contactor feedback is not a safe machine: reset edge, EDM, restart and physical proof
**4000 safety course | 2026-10-25 | NON-GRADUATED | Documentary module; no physical test**

## Prerequisites and learning objective
Prerequisites: 2520 hazard-to-SRS, 2530 E-stop, 2540 relay/contactors, 2580 stored-energy, 4400-REARM/PEDAL, and [selected-machine G0 intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md). Source evidence: [Pilz/OMRON/SICK original OEM audit](../research/4400_PILZ_OMRON_SICK_EDM_RESET_EDGE_DEFAULT_CONFIG_AND_CONTACTOR_PROOF_AUDIT_2026-10-25.md).

A fresh engineer should be able to explain **why** safety relay ready, EDM NC feedback, guard clear, safety reset, ordinary motion start and physical energy containment are distinct propositions; trace a welded contactor or bridged reset through a specific OEM mode; and refuse to infer hydraulic ram safety from electrical status.

## One practical architecture (concept, not wiring instruction)
| Layer | Example input/output | Narrow proposition | Must not infer |
|---|---|---|---|
| Ordinary LinuxCNC/HAL/FPGA | cycle command, motor/valve enable, display | normal control requested motion or stop | personnel safety, contactor opened, hydraulic holding |
| Protective input | E-stop, interlocked guard, ESPE OSSDs | specified safety demand/input state | final elements opened or hazard stopped |
| Independent safety control | appropriate dual-channel monitoring, EDM, restart interlock | safety control logic has received specified evidence | every electrical/hydraulic hazard physically removed |
| Physical final element | contactors, selected safety valves, independent load-holding/restraint | physical switching/containment when verified | zero pressure in all trapped zones or safe access |
| Physical validation | independent displacement/stop/hold, actual guard/access and isolation verification | task/mode-specific safety function acceptance | future safety after a changed valve/guard/firmware |

**Conceptual state contract (INFERENCE, not executable safety code):**
- **STOP/FAULT:** safety output inhibited, old motion command invalidated, rearm unavailable until cause corrected; identify residual gravity/pressure separately.
- **INPUTS RESTORED:** guard/ESPE clear is *not* authorization to resume; EDM must be valid for the selected architecture and faults must be handled.
- **READY FOR REARM:** reset device is outside hazard, operator can assess danger zone; deliberate reset edge is accepted only according to selected safety design.
- **SAFETY REARMED:** no motion merely from reset, power restoration, a bridged input, old held pedal or previously queued cycle.
- **FRESH ORDINARY START:** new intentional action after safety rearm, subject to separate normal process constraints; independent safety still retains veto.
- **MAINTENANCE:** separate lockable isolation, verified residual/reaccumulating energy and positive gravity restraint; none of the above states is a maintenance-entry permit.

## OEM counterexamples that defeat easy assumptions
1. **Pilz PNOZ s4 (21396-EN-14, pp.10,15):** automatic/simple manual/monitored rising/monitored falling modes differ. Manufacturer warns that automatic or bridged manual start can re-enable upon safeguard restoration. Therefore “manual reset” without exact wiring/mode is insufficient.
2. **OMRON G9SE (instruction p.2):** manual reset requires OFF→ON→OFF; the feedback circuit uses forcibly guided NC contacts. G9SE-221-T automatic mode can re-enable after off-delay if the inputs recovered. Therefore a delayed stop is not by itself a manual restart interlock.
3. **SICK C4000 (8012249/YT69, pp.29–30,77–78,88):** internal reset can re-enable OSSDs while a separate machine interlock must still prevent movement; EDM can detect certain welded contactors, but the receiver's documented factory default has EDM deactivated. Replacing the receiver requires configuration review. Therefore green/ready and matched connectors do not prove the same safety coverage.

## Failure tree for a fresh engineer
| Event | First plausible unsafe shortcut | Independent engineering response |
|---|---|---|
| Guard clears, held cycle request | “Ready means run” | Reject stale command; fresh deliberate start, safety rearm separate |
| Reset contact stuck high | “It's a manual button” | Check selected monitored-edge mode and documented fault response |
| Contactor power pole welded | “Relay says off” | Proper mechanically linked NC EDM plus qualified final-element and physical witness |
| Feedback shorted/bypassed | “EDM green” | Qualified circuit audit, anti-bypass routing and change verification; do not accept an unexplained bridge |
| Safety receiver replaced | “Same plug, same safety” | Reconcile firmware/configuration defaults, wiring and functional validation |
| Off-delay expires after field clears | “Delay prevents auto restart” | Selected reset mode and downstream start authority, qualified stop/approach analysis |
| E-stop released | “Reset means restart” | E-stop release must only prepare, not cause motion; separate deliberate command |
| Hydraulic valve sticks open | “Contactor NC feedback proves stop” | Independent hydraulic stop/hold, stored-energy/accumulator and gravity analysis |
| Tool-change with HMI green | “Maintenance safe” | Lockout, residual-energy verification, independent physical ram support |

## Human factors: make correct protection the easiest
Provide clear **why-not-ready** indications (e.g. guard open / EDM disagreement / reset required / stale start / mechanical restraint required), without presenting ordinary diagnostics as a certified safety decision. Keep the reset reachable *outside* the danger zone with real visibility; prevent remote reset from hiding a person behind the ram. A reset workflow that requires repeated obscure operations encourages unsafe jumpers—fix the design and fault messaging, never defeat EDM. For maintenance, put durable, legible isolation and restraint information at the machine; preserve evidence of temporary service overrides and require a visible restoration check.

## Study exercise / adversarial prompt
A replacement light curtain has a green output, a LinuxCNC UI shows “Cycle Ready,” and the hydraulic pump contactor's NC auxiliary feedback appears healthy. An operator's foot remains on the pedal. Explain exactly which propositions are DOC-CONFIRMED from the installed device manual, which are merely INFERENCE and which remain UNKNOWN. Draft a safe *paper-only* release disposition and the minimum as-built evidence needed to decide whether a fresh deliberate start and independent physical stop/hold exist. **Do not** propose a live experiment with a person at the dies.

## Evidence floor and graduation gate
- **DOC-CONFIRMED:** exact manufacturer statements in the linked source audit, scoped to those product revisions.
- **SOURCE-CONFIRMED:** no new LinuxCNC source trace; earlier ordinary motion/HAL evidence does not establish safety authority.
- **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **INFERENCE:** proposed separation and human-factors improvements.
- **UNKNOWN:** actual installed safety configuration, physical final elements, Y1/Y2 stop/hold/isolation and blind external competency.
- **Not graduated:** qualified selected-machine G0/physical validation and independent unseen evaluation remain open; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. No machine-specific timing, hydraulic truth table, PL/SIL or stop distance inferred.

## Promotion / unresolved queue
| Item | Evidence needed | Consequence | Priority | Blocks selected-machine release? |
|---|---|---|---|---|
| Actual reset circuit/mode and EDM wiring | Restricted as-built drawings + exact OEM edition/config | unexpected restart/weld fault coverage | CRITICAL | YES |
| Actual hydraulic stop/hold vs electrical isolation | Qualified pressure-zone and physical witness | ram may move with relay off | CRITICAL | YES |
| External fresh-AI transfer | Sealed new scenario and independent score | teaching efficacy unknown | HIGH | YES for course competency, not proof of machine |
| Device replacement behavior | exact installed variant and validated config diff | loss of diagnostic/rearm coverage | HIGH | YES if changed |

**Counterfactual test:** if actual machine uses different safety components, the generic *separation of authorities* remains valid, but any claimed selected-machine protection would fail. Therefore no machine release is asserted or promotable without physical evidence.


## MIRROR-01 correction to the phrase “forcibly guided feedback”
A **power contactor's IEC 60947-4-1 mirror NC** and a **relay's IEC 60947-5-1 mechanically linked auxiliary NO/NC** are not interchangeable claims. The exact contactor/auxiliary combination matters: Schneider documents TeSys K 0601 versus 0610 mirror differences and recommends an integral base NC over removable front auxiliaries where suitable. Do not substitute a generic NC for the required main-pole mirror witness. See [exact-part original manufacturer audit](../research/4400_SCHNEIDER_SIEMENS_MIRROR_NC_VS_GUIDED_AUX_EDM_VARIANT_SOURCE_AUDIT_2026-10-25.md) and [12 replacement cases](4400_MIRROR_01_TWELVE_REPLACEMENT_AND_EDM_FAULT_CASES_2026-10-25.md). **DOC-CONFIRMED** Schneider; exact selected machine and physical stop/hold **UNKNOWN**. This correction sharpens, rather than certifies, the earlier generic EDM teaching.
