# 4400 — SICK Safe Stationary Machine: dual encoder mechanical independence and stop-ramp authority
**2026-10-25 | Original OEM example application, edition 8020304/2017-07-26 | DOC-CONFIRMED exact example only | No lab/physical witness**

## Engineering question
When a safety controller receives two speed values, what must remain independent to detect loss of hazardous motion feedback, and why does an electronically monitored deceleration ramp not prove a gravity-held press ram?

## Original source
SICK AG, *Safe Stationary Machine — Example application*, **8020304/2017-07-26**, original 60-page PDF:
https://www.sick.com/media/docs/9/59/059/operating_instructions_safe_stationary_machine_en_im0075059.pdf
Directly inspected printed pp.19–22 (§4.2.2), pp.24–26 (§5.2–5.3), pp.29–35 (§5.4), pp.37–39 (§5.5). **2017 example**; not current universal approval or selected hardware proof.

## Direct OEM findings
1. **DOC-CONFIRMED (p.20–21):** Example offers **two non-safety encoders** or **one appropriately implemented safety encoder**. Two non-safety encoders require a structure meeting the stated category; **one mechanical failure must not impair both measurement paths**. SICK explicitly calls for separate mechanical breakage paths, suitable independent wiring, diverse measurement technologies, power-fault detection, and analysis of EMC/vibration/CCF. Two encoder readouts from one fragile coupling do not meet that independence proposition.
2. **DOC-CONFIRMED (pp.19–21):** The selected components and final elements, including STO wiring, must meet the application requirements. The OEM says the integrator is responsible for validating the complete implementation and must not implement the example if operating limits cannot be assessed. Its suggested PL d is conditional, not a whole-machine certificate.
3. **DOC-CONFIRMED (pp.24–26):** FX3-MOC0 example hardware and logic differ between dual ordinary encoders and one safety encoder; when using one safety encoder, the example changes both hardware configuration and motion input mapping. An auxiliary Speed comparison function block must mirror appropriate parameters. A copy of a diagram without the matching variant configuration is not a validated safety function.
4. **DOC-CONFIRMED (pp.29–30):** The example's **Automatic error reset** assistant is restricted to the documented settings, including existence of other primary protective devices that prevent access and **no suppression of error response/self-repair**. It warns against selecting other options. This is not permission for automatic hazardous machine restart.
5. **DOC-CONFIRMED (pp.31–34):** The assistant configures a standstill **speed and position window**, separate service versus automatic limits, a **response time for stop request**, speed-transition ramp and stop ramp. The OEM explicitly says an ordinary drive stop ramp is usually **not safe**; the safety monitor checks actual speed reduction. The example does not itself demonstrate selected physical load holding.
6. **DOC-CONFIRMED (pp.37–39):** Speed comparison block checks both encoders, uses manual reset and no automatic reset in this example; signed speed comparison affects downstream speed and safe-stop blocks. Product-specific SSI parameters in the manual are not general requirements for all encoders.

## Adversarial failure table (INFERENCE, to be qualified)
| Single fault / human shortcut | False reassurance | Needed discriminator |
|---|---|---|
| Both sensors share a coupling that shears | Two agreeing speed readings prove ram stationary | Trace sensor-to-load mechanical paths independently |
| One encoder shares supply/cable with other | Two channels are independent | Common 24 V/0 V, shielding, connectors, EMI, diagnostics |
| Service speed selected but hydraulic load falls | SLS = safe holding | Separate independent hydraulic/gravity physical restraint |
| Ordinary drive ramp commanded | Safe stop complete | Independent monitored deceleration **and** final physical stop/hold |
| Standstill within speed/position window | Exact zero displacement forever | Configured tolerances, sampling, residual motion and load drift |
| Protective device clears after reset | Area unoccupied and fresh start authorized | Guard/occupancy, independent reset and new deliberate start |
| Controller outputs safe-state bit | Valves/brakes physically safe | Final-element feedback, leakage, gravity proof and qualified witness |

## Architecture separation
Normal LinuxCNC/HostMot2/FPGA may command speed, mode and deceleration and log diagnostics. A validated independent safety controller with suitable sensors can monitor a selected SLS/stop function; a physically qualified actuator/brake/valve/restraint must establish the **actual safe state**. No source above makes an ordinary LinuxCNC HAL signal a safety-certified channel.

## Evidence status
SOURCE-CONFIRMED: none in this document. DOC-CONFIRMED: exact 2017 OEM example. TEST-CONFIRMED: none. COMMUNITY-REPORTED: none. INFERENCE: transfer to press brakes/mills/lathes/cells. UNKNOWN: actual installed hardware, category/PL/SIL, encoder independence, selected reaction and ramp, gravity holding, hydraulic pressure/isolation, Y1/Y2 physical proof, restart. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; no personnel-exposed hazardous operation.
