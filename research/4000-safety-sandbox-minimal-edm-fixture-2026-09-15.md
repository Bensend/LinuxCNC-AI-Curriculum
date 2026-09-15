# Safety Sandbox minimal EDM fixture — 2026-09-15

Session start: 2026-09-15T22:37:58Z

Status: SOURCE/DOC-CONFIRMED MODEL CONTRACT; NOT A MACHINE SAFETY VALIDATION

## Question
What is the smallest deterministic relay/contactor exercise that teaches the difference between physical hazard removal and diagnostic knowledge under welded-contact and feedback faults?

## Component contract
Each interruption device K1/K2 exposes independent state: `coil_cmd`, `mechanical_state`, `main_poles[]`, `feedback_contacts[]`, and `faults[]`. The circuit separately computes `hazard_path_energized`, `edm_observation`, and `rearm_permitted`. A coil command is never accepted as proof of a contact state.

Feedback contact relationship is typed, not implied:
- `ordinary_aux`: no modeled proof relationship to a welded main pole.
- `mirror_contact`: may witness main-pole state only to the relationship explicitly documented for the selected contactor/device.
- `forcibly_guided`: NO/NC relationships follow the selected relay's documented forced-guidance behavior.

## Manufacturer evidence
DOC-CONFIRMED — Omron G7SA is documented as a relay with forcibly guided contacts certified to EN 61810-3. Omron states that if an NO contact welds, all NC contacts maintain at least 0.5 mm gap with the coil deenergized; conversely, if an NC contact welds, all NO contacts maintain at least 0.5 mm gap with the coil energized. Omron's safety-components technical explanation also states that welding cannot be pulled apart and that the forced-guided relationship enables a control circuit to determine welding state.

DOC-CONFIRMED — Omron explicitly warns that the maximum applicable safety category belongs to the safety system/control-system construction and does not apply to an individual component. Therefore this fixture assigns no PL/SIL/category to a relay or to the resulting exercise.

DOC-CONFIRMED — Omron distinguishes automatic reset from manual reset: manual reset requires a reset action in the feedback circuit rather than starting solely when the input returns. This supports modeling `rearm_permitted` separately from `hazard_path_energized`; exact reset requirements remain device/application specific.

Sources:
- https://www.ia.omron.com/support/faq/answer/16/faq02481/
- https://www.ia.omron.com/data_pdf/guide/4/safetycompo_tg_e_2_1.pdf
- https://www.ia.omron.com/products/family/386/
- https://www.ia.omron.com/support/models/models/en/safety.html
- https://www.ia.omron.com/support/faq/answer/16/faq02358/

## Deterministic fixture
Two independent interruption devices K1 and K2 are series elements in a generic hazardous-energy command path. This is an abstract teaching path, not a claim that two contactors constitute a sufficient safe state for any particular machine.

Normal RUN:
- K1/K2 coils commanded on.
- Required main paths close.
- Hazard path may be energized.
- Rearm is irrelevant while running.

STOP request:
- K1/K2 coil commands off.
- Physical contact model resolves each main pole independently.
- Hazard outcome is derived only from the resulting energy path.
- EDM derives only from configured feedback witnesses.

### Required adversarial cases
1. **No fault:** both devices release; hazard path removed; valid feedback permits later rearm subject to reset policy.
2. **K1 main pole welded, K2 healthy:** K1 welded pole remains conducting after coil release; K2 opens the series path, so physical hazard path is removed in this abstract fixture. The K1 fault remains latent unless the configured witness can legitimately reveal it. Rearm must be inhibited when valid EDM reveals the failed release.
3. **K1 welded + ordinary auxiliary appears released:** physical path can still be removed by K2, but ordinary auxiliary state must not be promoted to proof that K1 main pole opened. Report diagnostic uncertainty/false-inference risk.
4. **K1 welded + documented mirror/forced-guided witness:** where the selected device documentation establishes the relationship, feedback remains inconsistent with a successful release; EDM blocks rearm.
5. **Feedback contact stuck in permissive state:** physical hazard result is unchanged; diagnostic channel can falsely indicate release unless another independent diagnostic catches it. Report hazard state and diagnostic state separately.
6. **Feedback wire open:** model the electrical observation actually produced by the chosen EDM topology. Do not universally call open-wire safe or unsafe without the circuit topology; the exercise must make the wiring consequence explicit.
7. **Control power loss:** deenergize coils, then resolve mechanical/main-contact faults. Power loss is not itself proof of hazardous-energy removal because welded contacts and independent stored/physical energy may remain.
8. **Power restoration:** restoration must not imply RUN or rearm. `rearm_permitted` remains a separate state and requires the modeled reset/restart conditions.

## Required outputs per step
- commanded state
- physical K1/K2 mechanical/contact state
- actual abstract hazard-path state
- EDM/diagnostic observation
- rearm permission
- active injected faults
- evidence class behind any claimed contact relationship

Never collapse these to one `safe=true` bit.

## Machine-family mapping boundary
The same educational logic can illustrate an electrical interruption/feedback concept on mills, lathes, plasma tables, press brakes, robots, and automated cells, but the actual hazardous energy and safe-state mechanisms differ. The fixture therefore does not invent spindle stopping time, plasma energy-removal behavior, hydraulic pressure/valve truth tables, press-brake stopping distance, robot safe-motion functions, or required performance levels. Those remain machine/design-specific validation work.

## Prototype gate
No compute is justified yet. The next source question is to freeze one actual power-contactor mirror-contact family and its exact documented main-pole/feedback relationship, then express this fixture as a small truth table suitable for a DigitalJS synchronous custom-cell prototype. Only run a prototype if it answers a remaining engine/serialization/reevaluation question rather than merely demonstrating the already-resolved logic.
