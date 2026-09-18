# Press-brake dynamic muting state/authority trace

Date: 2026-09-18
Session start UTC: 2026-09-18T10:35:38Z

## Scope

This study advances the 4000 safety course from generic ESPE muting/blanking into a press-brake-specific professional implementation. It does **not** define an OpenPressBrake safety design and does not transfer example stopping distances, speeds, PL/SIL/category/DC values, hydraulic behavior, or timing values to any physical machine.

## Professional implementation evidence

### Pilz PSENvip 2 + PSS 4000 / Fast Analysis Unit

**DOC-CONFIRMED.** Pilz describes PSENvip 2 as a camera-based protection system specifically for press brakes and describes a certified PSS 4000 function block for dynamic muting. In the documented complete solution, configuration includes tool class, muting end point and protected-field mode. Safety-related monitoring includes position, speed, braking ramp, overrun distance and protected field. Pilz states that dynamic muting is initiated only after the required check has completed. A foreign object in the optical protected field causes the press operation to be stopped safely. The protected field is dynamically adapted with upper-tool movement/speed rather than being treated as a permanently bypassed curtain.

Source: Pilz, “Camera-based protection system PSENvip 2: New Pilz function block for dynamic muting on press brakes,” 2023-07-04, https://www.pilz.com/en-US/company/press/messages/articles/236263

This is materially stronger evidence than a generic statement that “muting temporarily disables a light curtain.” For this professional press-brake architecture, muting permission is coupled to checked press state and tool/protected-field configuration.

### SICK restart-interlock boundary

**DOC-CONFIRMED.** SICK's current miniTwin4 operating instructions state that restart interlock prevents automatic machine starting after protective-device response or operating-mode change. The machine must not restart merely because the OSSD returns ON after reset; the machine control must require the machine START button after reset, in the specified order.

Source: SICK miniTwin4 operating instructions, 2024-05-07, section 4.4.2 Restart interlock, https://www.sick.com/media/docs/5/75/375/Operating_instructions_miniTwin4_Safety_light_curtain_en_IM0033375.PDF

This is not evidence that PSENvip 2 uses miniTwin4's exact reset circuit. It is independent professional evidence for the general authority boundary between protective-device reset and ordinary machine start.

## Frozen state/authority model

For a press-brake safeguarding implementation, do not collapse these states:

`TOOL/PROTECTED-FIELD CONFIG VALID`

`!= POSITION/SPEED/BRAKING/OVERRUN CONDITIONS VALID`

`!= DYNAMIC MUTING PERMITTED`

`!= DYNAMIC MUTING ACTIVE`

`!= PROTECTIVE FIELD EFFECTIVELY RESTORED`

`!= RESTART INTERLOCK SATISFIED`

`!= SAFETY MOTION AUTHORITY AVAILABLE`

`!= FRESH ORDINARY PRESS START COMMAND`.

A “muting active” lamp or HMI bit is therefore diagnostic evidence only. It is not proof that the correct tool class is loaded, the muting endpoint is physically correct, the monitored speed/position state is valid, the protected field is geometrically effective, or no person/body part is exposed.

## Failure-path analysis

### Wrong or stale tool/protected-field configuration

If a muting endpoint or protected-field mode is selected for a different tool/setup, the intended protected geometry may not match the actual hazard. The Pilz source confirms these are configurable inputs to the dynamic-mut­ing solution; it does **not** provide enough public evidence here to claim the exact fault reaction for every mismatch. Classification: configuration role **DOC-CONFIRMED**; exact mismatch reaction **UNKNOWN**.

Commissioning must therefore challenge configuration identity rather than merely observing that muting occurs.

### Position/speed evidence disagrees with muting request

Pilz explicitly identifies position, speed, braking ramp, overrun distance and protected field as monitored safety functions and states muting begins after the check. Therefore a commissioning test should challenge each relied-upon input/feedback path and demonstrate that dynamic muting cannot be granted from an ordinary-control request alone. Exact internal voting/timing remains **UNKNOWN**.

### Foreign object during protected phase

Pilz states that foreign bodies in the optical protected field are detected and press operation is safely stopped. This supports a physical intrusion challenge at representative allowed locations/configurations. It does not establish OpenPressBrake stopping distance or hydraulic stop performance.

### Stale ordinary START through safety recovery

SICK's restart-interlock documentation independently demonstrates the required conceptual separation: reset/OSSD restoration is not machine START. For LinuxCNC integration, a START/JOG/DOWN/ENABLE request that remained TRUE while safety authority was absent must not silently become fresh intent when authority returns. LinuxCNC/HAL may consume safety permissives and diagnostics, but ordinary software must not own the personnel-safety restart decision.

## Commissioning card

For each installed tool/protected-field configuration, record actual machine evidence for:

1. configuration identity and physical tool/setup correspondence;
2. protected-field geometry before muting;
3. position and speed feedback used by the safety implementation;
4. muting-endpoint behavior and transition into the reduced/protected bending region;
5. intrusion response before, during and after the permitted dynamic-mut­ing interval;
6. invalid/stale/disconnected feedback behavior;
7. power-cycle and mode-change behavior;
8. reset/restart-interlock behavior;
9. proof that ordinary START must be newly asserted after safety recovery;
10. final-element response and actual hazardous-motion cessation, measured on the installed machine when commissioning reaches that stage.

Do not accept a successful production bend as validation of the safety function. The test must deliberately exercise the safety boundary and representative faults.

## Human-factors/adversarial review

Dynamic muting exists partly to preserve productivity. That is valuable because a safeguard that constantly obstructs legitimate bending work creates pressure to bypass it. The engineering objective is therefore not “make muting hard to use”; it is “make the **correct bounded muting path** easier than bypassing the safeguard.” Tool/setup selection, diagnostics and recovery should make wrong-state operation conspicuous and normal recovery straightforward without turning override/bypass into routine production practice.

If the installed machine cannot demonstrate a valid protective field, valid safety-state inputs, required stopping behavior and controlled restart for the intended mode, it should not be operated with people exposed to the bending hazard. Experimental motion must be isolated/remote with people outside the danger zone and residual risk stated plainly.

## Evidence ledger

- PSENvip 2 is a press-brake-specific camera protection solution: **DOC-CONFIRMED**.
- Its dynamic-mut­ing function block uses/configures tool class, muting endpoint and protected-field modes: **DOC-CONFIRMED**.
- Position, speed, braking ramp, overrun distance and protected field are monitored in the described solution: **DOC-CONFIRMED**.
- Dynamic muting begins after the described check: **DOC-CONFIRMED**.
- Foreign-body detection in the protected field stops the press operation: **DOC-CONFIRMED**.
- Reset/OSSD restoration must be separated from machine START in SICK's restart-interlock implementation: **DOC-CONFIRMED**.
- Exact PSENvip/PSS 4000 internal state machine, voting, discrepancy timing and fault codes: **UNKNOWN** from the public evidence inspected here.
- OpenPressBrake tool geometry, PSENvip applicability, protective-field geometry, stopping distance/time, safe speed, muting endpoint, hydraulic stop behavior and achieved PL/SIL/category/DC: **UNKNOWN**.

## Next evidence target

Obtain a Pilz PSENvip 2 / PSS 4000 application or commissioning manual exposing the dynamic-mut­ing block's actual input/output state machine and fault/restart behavior, especially invalid tool class/protected-field mode, invalid position/speed state, failed muting transition, reset prerequisites and post-reset ordinary start. If that public evidence is unavailable, rotate to another open safety branch rather than inventing the missing implementation.

No simulation, build, synthesis, benchmark, test suite or GitHub-hosted Actions compute was used for this study.