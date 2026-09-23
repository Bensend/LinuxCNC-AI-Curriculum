# 25D0 — Tier A/B/C comparative fault analysis

Session source pass: 2026-09-23 UTC.

## Scope

This is an educational comparison, not a universal machine design and not a PL/SIL claim. The same physical hazard and safe-state proposition must be defined before choosing a tier. Ordinary LinuxCNC/FPGA logic may consume status for diagnostics but does not own personnel-safety authority.

## Architectures compared

- **Tier A:** NC E-stop/contact in one de-energize-to-trip control path driving one final switching element.
- **Tier B:** dual-channel input evaluated by a safety relay/module, intentional monitored/manual reset where the application requires it, one final switching path unless otherwise stated.
- **Tier C:** Tier-B input/evaluation plus two independent final switching elements in the hazardous-energy path and EDM/feedback using appropriate positively driven/mirror contacts.

The tiers deliberately separate input diagnostics from final-element fault tolerance. Adding a safety relay does not automatically make a single downstream contactor tolerant of a welded power contact.

## Manufacturer evidence reopened

**DOC-CONFIRMED — Siemens SIRIUS 3SK2 equipment manual, 05/2025.** A feedback circuit monitors controlled actuators; Siemens requires positively driven NC or mirror contacts to read back coupling/load contactor switch positions, and fail-safe outputs can activate only when the feedback circuit is closed. The manual also distinguishes safety-related enabling circuits from signaling outputs and states signaling outputs must not be used in safety functions.

**DOC-CONFIRMED — Schmersal SRB-E-301ST current product/manual material.** The module documents wire-break detection, cross-circuit detection, start input, feedback circuit, automatic reset and reset-edge detection. The operating instructions show a feedback circuit using downstream KA/KB contacts and warn that inadvertent restart must be prevented by suitable measures. These capabilities are product/application-specific; they are not transferred to every generic safety relay.

## Comparative fault table

| Fault / event | Tier A — single path | Tier B — dual input + safety module | Tier C — redundant final elements + EDM | Physical proposition / residual uncertainty |
|---|---|---|---|---|
| Broken NC input wire | De-energize-to-trip can cause a stop if the break is in the series control path. | A correctly wired supported application can detect channel opening/disagreement; exact diagnostic behavior depends on module configuration. | Same input benefit as B. | An open input path can establish a stop demand. It does **not** prove the final element opened or hazardous motion/energy ended. |
| Input cross-short | A simple series path may be defeated depending on where/how conductors short. | Cross-circuit detection may detect specified faults only when the selected module, sensor wiring and test-source arrangement support it. | Same as B. | Diagnostic detection proves a recognized electrical inconsistency, not absence of every common-cause or mechanical defeat. |
| Stuck/welded input contact | A single stuck input contact can prevent the stop demand. | Two independent channels can reveal disagreement for faults within the monitored model; common mechanical actuation can defeat both channels. | Same as B. | Two input bits do not prove two independent physical channels. |
| One final contactor/power contact welds | Dangerous single point: removing coil power may not interrupt hazardous power. | Still dangerous if B uses only one final switching element; the safety relay does not repair downstream single-point physics. | The second correctly independent series final element can interrupt the path; EDM can inhibit restart when appropriate feedback fails to return. | Redundancy addresses one welded element only if both final elements really interrupt the relevant hazardous-energy path. |
| EDM/feedback contact stuck or miswired | Usually absent. | If feedback is present it can monitor only what the selected auxiliary/mirror contact validly represents. | Can defeat diagnostic/restart inhibition if the feedback path lies; validation must include feedback faults. | EDM proves the state of the **witness contact/path**, not directly the main power pole, motor torque, valve position, standstill or zero stored energy. Mirror/positively driven contact assumptions matter. |
| Reset button stuck/shorted | A simplistic architecture may restart/rearm unintentionally unless restart is separately prevented. | Monitored reset/edge detection can reject some static reset faults when configured accordingly; auto-start deliberately changes this behavior. | Same as B plus EDM must be satisfied before re-enable. | Reset is permission to rearm a safety function, not permission for hazardous motion. Normal cycle start remains separate. |
| Control power lost | De-energize-to-trip usually drops the coil if the architecture is actually de-energize-to-trip. | Safety outputs drop according to documented device behavior. | Both final-element coils should de-energize if designed that way. | Coil de-energization is not proof that contacts opened or that stored/gravity/fluid energy is gone. |
| Control power restored | A poor Tier-A circuit can re-energize immediately if the stop chain is healthy and no deliberate restart inhibit exists. | Manual/monitored restart can require a fresh reset; auto-start applications may re-enable automatically and need separate restart-risk analysis. | Same as B, with EDM preventing re-enable if final-element feedback is not healthy. | **POWER RESTORED != MOTION START AUTHORIZED.** Restoration behavior must be designed, not assumed. |
| Common 24 V/supply/wiring dependency | One common dependency dominates. | Dual channels may still share supply, cable route, terminal block, actuator mechanics or environmental exposure. | Output redundancy can still share control supply, enclosure, wiring route, suppressor mistakes or energy-path common cause. | Channel count does not remove CCF. Separation/diversity/environmental analysis remains required. |
| Both final elements share one unsuitable energy interruption point | N/A / already single path. | N/A / single path if configured that way. | Apparent redundancy can collapse if both devices act on a common component/path whose failure preserves the hazard. | Draw the physical energy path. Schematic symbol count is not independence proof. |

## What EDM actually buys

**DOC-CONFIRMED:** Siemens describes feedback as monitoring controlled actuators via positively driven NC or mirror contacts and conditions fail-safe output activation on a closed feedback circuit.

**INFERENCE bounded by that documentation:** In a conventional two-contactor architecture, EDM is valuable because after a stop it can prevent a new enable when the witness contact for a contactor did not return to the expected de-energized state. That closes an important *latent welded/stuck final-element before next demand* path.

It does **not** establish:

- zero voltage at the load;
- zero torque or standstill;
- discharge of a drive DC bus;
- hydraulic/pneumatic decompression;
- mechanical brake effectiveness;
- that a mirror/auxiliary contact is correctly mechanically linked unless the selected component/application evidence establishes that assumption;
- that both contactors do not share a common-cause failure.

Freeze: **EDM HEALTHY != PHYSICAL SAFE STATE PROVED.**

Freeze: **SAFETY RELAY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED.**

Freeze: **DUAL CHANNEL INPUT != REDUNDANT FINAL ELEMENT.**

## Human-factors carry-forward from 25C0

A low-cost architecture must not make correct recovery so irritating that bypass is predictably rewarded.

- Put reset where the operator can verify the protected area as required by the application; a reset hidden inside a cabinet is cheap but can be poor safety engineering.
- Provide diagnostics that distinguish input-channel disagreement, EDM/final-element failure and ordinary process faults. A single generic `SAFETY FAULT` lamp makes bridging and parts-swapping more likely.
- Do not use automatic restart merely to save a reset button or a few seconds of production time where unexpected restart is a hazard.
- Make guard/interlock reconnection and replacement straightforward. A safety device that is routinely left bypassed after maintenance is not a successful low-cost design.
- Keep safety reset/rearm separate from LinuxCNC cycle start and motion commands.

## Cost reasoning without false precision

This pass does **not** freeze dollar values. Manufacturer pages found in this session provide current product capability and manuals but not a sufficiently comparable public transaction-price set across safety relay + contactor + accessory combinations. A fabricated or distributor-mixed BOM would create false precision.

Use cost classes until traceable like-for-like pricing is available:

- **Tier A — lowest parts count:** one input path and one final element. The saved cost leaves welded/stuck input and final-element single faults largely untreated.
- **Tier B — modest safety-control premium:** dual input wiring plus a purpose-built safety module buys specified channel/wire/cross-fault diagnostics and controlled reset behavior *when the chosen product/application supports them*. It does not by itself buy downstream final-element redundancy.
- **Tier C — additional final-element + feedback cost:** the second suitable final element, feedback wiring and panel space buy tolerance/diagnosis for an important single welded/stuck final-element path. They also add contact lifetime, suppression, wiring, CCF and maintenance assumptions that must be engineered.

The cost question is therefore: **which named dangerous failure path does the next dollar close?**

## Machine-specific UNKNOWNs before use

- required safety function and integrity target;
- actual hazardous-energy paths and whether contactors are appropriate final elements;
- contactor switching duty, utilization category, B10d/lifetime data and protective devices;
- required stopping time/distance and guard-release conditions;
- whether gravity/stored/fluid energy remains after electrical interruption;
- reset visibility and pass-through risk;
- environmental/common-cause assumptions;
- exact cross-fault and EDM behavior of the selected safety module/application circuit.

## Next information-gain step

Extend 25D0 from generic A/B/C comparison to two inexpensive, machine-class examples: (1) an ordinary VFD without integrated STO using externally switched energy, and (2) a drive with STO where external isolation still has a separate maintenance purpose. Compare the incremental hardware and the distinct physical propositions; do not turn either into a universal wiring recipe. Then audit whether Tier E fluid-power coverage needs a separate low-cost comparison before the 25D0 learner route/evaluator gate.