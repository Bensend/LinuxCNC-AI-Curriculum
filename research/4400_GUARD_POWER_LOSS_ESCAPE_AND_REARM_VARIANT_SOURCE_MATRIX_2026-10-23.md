# 4400 — Guard power loss, escape, and rearm: selected-variant source matrix

**2026-10-23 | Original source research | 4000 safety branch / 2590 guard/access prerequisite.** Evidence is documentary only; no selected machine, physical test, achieved PL/SIL, stopping time, or permission for personnel-exposed operation. This document is **not** an exact release from the earlier 85-document publication archive.

## Decision to be made

When a guarded machine loses 24 V power, should its door remain locked, become unlocked, or be mechanically releasable? These are not interchangeable fail-safe defaults. The answer depends on at least **two different hazardous events**: (A) a person gaining access while motion or stored energy remains hazardous and (B) a person trapped inside after loss of power. A third event is **unexpected restart** after power, release mechanism, or safety logic is restored. Choosing one electrical polarity without considering all three creates a foreseeable single-event trap.

## Original manufacturer sources, exact scope

1. **SICK TR110 Lock**, Operating Instructions **8023119/1K8B/2023-09-15**, sections 3.3.3, 4.4.1, 8.2–8.3 and ordering table 24, https://www.sick.com/media/docs/2/82/682/operating_instructions_tr110_lock_en_im0082682.pdf. **DOC-CONFIRMED**: power-to-release variants remain mechanically locked when the solenoid loses voltage, with an explicit entrapment warning; power-to-lock variants release when voltage is disconnected, with an explicit warning that unlocking may precede the end of hazardous motion. An inside escape release is an *option*, not present on every part number. SICK requires separate starting after guard closure and overall control-system validation.
2. **EUCHNER CTP-AP**, Operating Instructions **2124217-08-06/21**, §§3, 6.6–6.8, 7, https://assets2.euchner.de/Downloads/Betriebsanleitung/en/MAN_Transponder-Coded-Safety-Switch-With-Guard%E2%80%A6_EN_08_06-21_2124217.pdf. **DOC-CONFIRMED**: CTP-L1 spring locks without solenoid voltage and warns about unintended trapping if an open door closes during a supply interruption; CTP-L2 releases without voltage, with a product-specific warning about personnel-protection suitability. The guard-lock **control** safety characteristic belongs to external control, not the solenoid-monitoring device. Auxiliary release withdraws safety outputs to request a stop; that is not a physical stop witness.
3. **Pilz PSEN ml b 1.1/2.1/2.2**, Operating Manual **1003884-EN-17**, §§4.6–4.8, https://www.pilz.com/download/open/PSEN_ml_b_1_12_12_2_Op_Man_1003884-EN-17.pdf. **DOC-CONFIRMED**: its documented escape release acts mechanically on the auxiliary release, drives safety outputs low, and requires handle reset, power cycling and qualified functional checking before recommissioning. Section 4.7 describes an actuator padlock hole to prevent engagement while someone is inside. The padlock is a *restart/access supplement*, not proof that electrical/hydraulic/pneumatic/gravity energy is isolated.
4. **Pilz PSENmlock product-family page**, https://www.pilz.com/en-AU/products/sensor-technology/safety-switches-with-guard-locking/psenmlock-safety-locking-devices. **DOC-CONFIRMED**: Pilz also markets distinct **power-reset** and **automatic-reset** variants following escape release; its public description says the automatic-reset type can recover after restoring the release and closing the guard. **Do not transplant this family-level statement into the EN-17 manual's exact model or treat automatic device recovery as permission for machine restart.**

Manufacturer source pages and original manuals were checked 2026-10-23 UTC. Public standards abstracts do not establish the selected design's integrity or acceptable distance.

## Causal event matrix — three separate propositions

| Event / variant | Manufacturer-grounded local device behavior | Machine proposition still UNKNOWN | Safe design obligation (INFERENCE) |
|---|---|---|---|
| Solenoid supply disappears on SICK TR110 power-to-release or EUCHNER CTP-L1 | Mechanical guard locking remains active; a door closed with no voltage can trap a person | Whether anyone is inside, whether release can be reached, whether the machine stopped or is held | Provide physically accessible inside escape where required, occupancy/restart protection, and a no-exposure validation method |
| Solenoid supply disappears on SICK TR110 power-to-lock or EUCHNER CTP-L2 | Lock releases regardless of whether motion has stopped | Whether a spinning spindle, robot, descending ram or stored pressure can still harm an entrant | Independent protective stop/hold or other barrier must prevent access to the hazard until the dangerous state has ended; do not rely on the solenoid's loss-of-power state |
| Inside escape release is actuated | Local mechanical release permits opening; applicable safety outputs request stop | Whether final element has removed force, whether beam/spindle stopped, whether person can physically pass through | Independent stop/hold and actual egress geometry are separate witnesses; the emergency escape path cannot depend on LinuxCNC/HMI being powered |
| Auxiliary or emergency release is restored | Some products require tool/physical restoration, seal, power cycle and function check; some other variants automatically restore device status | Whether safety controller has fresh reset, whether an operator is still inside, whether an old start command remains asserted | Fresh deliberate safety rearm **and** separate ordinary new start, no retained request, visible personnel-clearance method |
| Device replaced with a similar-looking alternate variant | Wiring, lock polarity, output proposition and reset behavior can change | Whether old validation and stop/escape witnesses still apply | Treat affected SRS, wiring, mode, human factors, physical VAL/PT and restart evidence as STALE pending requalification |

**Source conflict / version boundary:** SICK, EUCHNER and Pilz documents describe different products, dates and recovery behaviors. A source-confirmed recovery sequence for one selected device does not establish another's behavior. Exact installed model, actuator, release accessory, connector, firmware, safety-controller program and supply wiring are **UNKNOWN**.

## Four distinct authorities

- **Ordinary LinuxCNC/FPGA:** requests motion, mode and HMI indications. It may consume safety status but does not authorize personnel-protective unlocking or certify zero motion.
- **Diagnostics:** report guard-open, locked, release-used, fault, data age and exact device identity. A healthy status or restored OSSD is not a proof of personnel clearance.
- **Independent safety-related control:** owns validated unlock conditions, fault handling, safety outputs, rearm and prevention of unexpected hazardous restart. Its selected performance/integrity target requires separate design calculation and validation.
- **Physical mechanisms:** actual latch/escape hardware, guard geometry, drive/valve/contactor final elements, load restraint, stored-energy discharge and maintenance isolators. No one electrical bit proves these all worked.

## Minimum selected-machine qualification packet (not an energization procedure)

For each access point, identify **(1)** exact switch/actuator/accessory part and manual revision; **(2)** power-to-lock/release behavior; **(3)** inside/outside release locations and reachable mechanical path without tools where required; **(4)** who can be inside when the door closes; **(5)** all hazardous energy sources and independent stop/hold witnesses; **(6)** selected safety-controller input/output wiring and power-loss behavior; **(7)** reset/rearm and retained ordinary start policy; **(8)** safe remote/isolated validation fixture and witness method; **(9)** human-factors friction and foreseeable defeat; **(10)** change-control signatures and stale-proof list.

Use existing `safety-course/4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md` IDs `IN-01..10` and `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART`. Before any energized test, obtain qualified design review, no-person-exposure test envelope and residual-risk approval. Do **not** ask a person to be trapped to demonstrate escape. Inspect mechanical release and opening in a safely isolated, unoccupied setup.

## Adversarial review / falsifiers

1. **Counterexample to “power-to-release is always safest”:** a door closes behind a maintainer during a blackout; mechanical lock holds; no inside escape accessory is installed. Local locked status may be correct while the overall machine is unsafe for that task.
2. **Counterexample to “power-to-lock is always safest”:** power disappears while a hazardous spindle coasts; the guard becomes openable before the stopping interval is proven. A software E-stop lamp does not establish the end of hazard.
3. **Counterexample to “release equals stop”:** escape release withdraws OSSD, but a welded final element or hydraulic gravity load still moves. Stop demand is not physical stop/hold.
4. **Counterexample to “power reset equals machine reset”:** device status returns after restoration while LinuxCNC has a retained motion request. Independent safety logic must require a deliberate restart path and fresh ordinary start.
5. **Counterexample to “padlock equals LOTO”:** a lock on the actuator blocks gate closure, yet an accumulator and elevated ram remain energized. Personal lockout and zone-specific stored-energy verification remain separate.

## Human-factors acceptance

Inspect routine access, jam clearing, setup, washdown, power outage and multi-person work. A release hidden behind a guard bracket, a cable prone to damage, an actuator lock hole inaccessible with gloves, or a reset requiring a long detour is a design defect likely to induce defeat. Favor accessible approved inside release, simple captive/clearly labeled controls, independent per-guard diagnostics, easy guard reinstallation and practical lockout/test points. Improvements must not silently relax stop/hold/escape or restart requirements.

## Disposition

**DOC-CONFIRMED:** specific product principles, optional escape accessories and variant-dependent recovery. **INFERENCE:** the machine-level event decomposition and evidence-intake architecture. **UNKNOWN:** all selected hardware, stopping/holding, pressure, escape geometry, power-loss sequence, PL/SIL, diagnostic coverage and field performance. **TEST-CONFIRMED:** none. No numerical safety parameter is transferred. Until independent selected-machine proof exists, personnel-exposed hazardous operation is **NOT AUTHORIZED**; any experimental operation must be isolated/remote with people outside the danger zone and residual risk explicitly reviewed.

**Next:** complete the selected-machine intake and examine the six original-archive pending research candidates without treating their historical claims as current repository truth.