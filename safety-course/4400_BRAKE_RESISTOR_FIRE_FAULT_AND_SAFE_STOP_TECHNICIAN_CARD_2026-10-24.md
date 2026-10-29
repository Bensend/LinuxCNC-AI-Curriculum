# 4400 — Brake resistor heat, chopper failure and safe-stop boundary
**2026-10-24 | 12 PAPER SCENARIOS | NO LIVE FAULT INJECTION**

Read [original OEM audit](../research/4400_DYNAMIC_BRAKE_RESISTOR_STUCK_CHOPPER_FIRE_AND_STOP_BOUNDARY_OEM_AUDIT_2026-10-24.md) and [common-bus audit](../research/4400_COMMON_DC_BUS_REGENERATION_REENERGIZATION_AND_ISOLATION_OEM_AUDIT_2026-10-24.md). For each scenario separate thermal/fire protection, normal braking, personnel safety stop, gravity hold, service isolation, reset and human factors.

| ID | Paper-only scenario | Required discrimination |
|---|---|---|
| BR-T01 | External resistor becomes hot while drive HMI displays normal. | Thermal hazard exists independently of CNC alarm; verify OEM protection. |
| BR-T02 | Brake IGBT fails conductive and resistor temperature rises. | Rockwell OEM identifies fire risk; independent thermal interruption path required where applicable. |
| BR-T03 | Technician adds an external resistor but assumes the drive protects it. | Exact drive/resistor combination and instructions required; not universal. |
| BR-T04 | Specific Armor PowerFlex 350 kit reports thermal event. | OEM's internal Electronic Motor Disconnect claim is product-specific; do not generalize. |
| BR-T05 | Rockwell 35R kit proposed for Armor PowerFlex 330. | January 2026 original installation instruction explicitly excludes this substitution. |
| BR-T06 | Operator touches resistor after motor stops. | Burn risk remains; thermal cooldown and guarding are independent of zero speed. |
| BR-T07 | Resistor circuit opens during controlled deceleration. | Normal brake energy dissipation unavailable; actual stop response UNKNOWN until engineered/validated. |
| BR-T08 | Thermal model trips drive software, but chopper semiconductor remains conductive. | A drive fault is not proof that resistor power physically stopped; trace actual final element. |
| BR-T09 | Upstream contactor opens while a second inverter powers common DC bus. | Contact interruption of one AC feed may not isolate chopper/resistor from shared bus. |
| BR-T10 | Servo motor loses torque with suspended press beam. | STO/dynamic brake do not establish gravity holding. |
| BR-T11 | Thermal fault clears on cooldown while old CNC run command persists. | Separate fault reset, safety rearm and fresh deliberate start. |
| BR-T12 | Resistor moved behind a removable guard for easier service. | Address heat, combustibles, cooling, access and predictable bypass; validate change. |

**Evidence classes:** OEM statements `DOC-CONFIRMED` for specified products; cross-machine transfers `INFERENCE`; selected machine wiring, temperatures, stopping, safety function and installed device `UNKNOWN`. These prompts include open instructor cues and are **not** blind external competency evidence.

**Practical response:** For any unresolved fire/stop/hold protection, no personnel-exposed operation. Use manufacturer-supported thermal protection, qualified isolation and independent physical validation; never deliberately short a chopper, overload a resistor or test fire behavior on an occupied machine. `VAL/PT NOT RUN`, `G3/G4 NOT AUTHORIZED`.


**2026-10-29 exact-source addendum:** [ABB 2011 circuit / ACS800 frame exception / Schneider accessory suffix audit](../research/4400_BRAKE_RESISTOR_2026_10_29_ABB_2011_ACS800_FRAME_EXCEPTION_AND_SCHNEIDER_SUFFIX_SOURCE_DELTA.md). The existing BR-T02/BR-T03/BR-T08 scenarios already cover chopper short and thermal interruption. New discriminator: ABB ACS800 R7/R8 with internal chopper and correctly selected resistor has an OEM-specific input-bridge interruption exception; external chopper needs a contactor in that manual. Schneider ATV312 resistor suffixes may **lack** thermal contacts. Always inspect exact model/frame/suffix; do not prescribe or omit a contactor universally. No physical test or new scenarios.
