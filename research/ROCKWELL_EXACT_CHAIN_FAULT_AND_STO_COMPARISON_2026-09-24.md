# Exact coherent-chain fault audit and STO comparison — 2026-09-24

Session start: 2026-09-24T12:38:45Z

Status: curriculum evidence artifact. **NOT a machine design, NOT a machine validation, NOT an achieved PL/SIL claim, and NOT permission to operate hazardous machinery.** Generic safety schematics remain NOT FROZEN.

## Question

Deepen the existing Rockwell OSSD -> 440C-CR30 -> 100S-C contactor example far enough to identify what is actually product-family evidence, attack the most misleading failure states, and compare the final-element proposition with a drive Safe Torque Off (STO) architecture.

## Evidence ledger

### DOC-CONFIRMED — coherent Rockwell application

Rockwell application technique SAFETY-AT164A-EN-P identifies the protective device as a **450L light curtain** connected to a **440C-CR30 configurable safety relay**. The CR30 safety outputs control **100S-C safety-contactor coils**. The application states that de-energizing those outputs opens the contactors and interrupts motor power, producing the application's category-0 coast stop. The CR30 monitors the 100S-C devices through mechanically linked N.C. auxiliary contacts and refuses reset unless the expected open condition is reported. Reset in this application is a press-and-release action in the documented 0.25–3.0 s interval after required safety inputs are correct and no faults are detected.

The application therefore supports this exact *family-level* chain:

`450L dual OSSD -> 440C-CR30 configured safety input -> CR30 safety outputs -> two 100S-C coil circuits -> main motor-power contacts -> mechanically linked N.C. auxiliary feedback -> CR30 reset/rearm decision`

It does **not** by itself establish that every 450L variant, every 100S-C catalog number, every suppression accessory, every CR30 firmware/configuration, or every load is interchangeable.

### DOC-CONFIRMED — 100S-C feedback relationship

Rockwell technical data 100-TD013 describes Bulletin 100S-C/104S-C safety contactors as having mechanically linked/positively guided contacts for safety feedback. The permanently fixed front auxiliary contacts carry the mechanically-linked/mirror-contact identification; the N.C. mechanically linked auxiliary does not change state when a power pole welds. Rockwell's SUVA certificate 100S-CT015A-EN-E covers the 100S-C09/C12/C16/C23/C30/C37/C40/C43/C55 family and records mirror-contact/mechanically-linked-contact conformity references.

This evidence justifies a narrow proposition: for a selected covered 100S-C construction used as specified, the designated N.C. feedback contact can witness the manufacturer's mechanical relationship to a welded main power contact. It does not prove machine standstill, absence of voltage everywhere, absence of stored energy, gravity restraint, or absence of a bypass energy path.

### UNKNOWN / schematic-blocking detail

The application-family evidence is still insufficient to freeze a reusable schematic. Before a real implementation is frozen, the exact selected 450L catalog/revision, exact 100S-C catalog number and coil, CR30 hardware/firmware/configuration baseline, safety-output electrical limits, coil inrush/holding current, permitted suppression/accessory network, cable/reference arrangement, and load utilization/sizing must be reconciled against current product documentation. The curriculum must not invent these values.

## Adversarial fault trace

| Fault / misleading state | What the documented chain can establish | What remains unproved / required response |
|---|---|---|
| One main contactor power pole welds | The mechanically linked N.C. feedback relationship is intended to prevent the feedback from returning the expected open state; the CR30 application refuses reset when required feedback is absent. | This does not prove every hazardous energy path is open. Replace/repair the failed final element and revalidate the affected chain before operation. |
| Feedback wire opens | A missing expected feedback state can block reset/rearm in the documented architecture. | An open wire is not proof that the main contacts opened; diagnostic attribution requires the selected circuit. |
| Feedback wire shorts or is forced to a plausible state | Agreement can be false if the feedback path is defeated. | `FEEDBACK PLAUSIBLE != CONTACTOR MECHANISM PROVED`; selected wiring/test strategy and CCF analysis must address whether this fault is detectable. Do not credit a plausible bit as physical proof. |
| Common +24 V is lost | Coils and/or logic may de-energize depending on exact supply allocation. | `CONTROL POWER LOST != HAZARDOUS ENERGY SAFE`; motor inertia, gravity, stored electrical energy, hydraulic/pneumatic energy and alternate feeds remain separate propositions. |
| Common 0 V/reference opens | Multiple channels may become invalid together or produce misleading electrical states depending on topology. | Treat common reference as `DEP-*`; two signal wires do not create independence from a common reference. Exact failure behavior remains selected-circuit evidence. |
| +24 V/0 V returns | The application requires safety-input eligibility and a deliberate reset sequence before CR30 safety outputs return. | `POWER RESTORED != REARM ELIGIBLE`; restoration also does not authorize ordinary hazardous motion. |
| Reset button is held/stuck | The application requires a press-and-release action within its documented timing window. | A maintained level is not credited as a fresh deliberate reset event. Exact selected reset semantics remain product/configuration evidence. |
| Ordinary LinuxCNC cycle-start remains asserted while safety demand clears | The safety chain can restore only its safety permissive after its own reset conditions. | `RESET ACCEPTED != HAZARDOUS MOTION COMMANDED`; ordinary control must be designed so retained cycle-start cannot turn safety reset/power restoration into unexpected restart. |
| HMI says contactors open while physical feedback is wrong | HMI/ordinary-controller state has no personnel-safety authority. | Validate the independent safety chain and machine physical safe-state proposition; do not substitute a software mirror bit. |

## Common-cause lesson

Redundant contactors do not imply two independent safety channels if a single upstream supply, reference, protection device, connector, CR30 output dependency, suppression fault, wiring route, bypass, or downstream energy path can defeat both. Each such dependency belongs in `DEP-*` and must be dispositioned before an integrity claim. The right question is not "are there two contactors?" but "what single faults or shared resources can keep hazardous energy available despite the demanded safe state?"

## Comparison: contactor interruption versus drive STO

A contactor-based motor-power interruption and drive STO can both participate in a safety function, but they prove different things and leave different residual-energy questions.

### Contactor architecture

In the worked Rockwell chain, the safety controller removes coil power and expects the selected main power contacts to open. Mechanically linked N.C. auxiliary feedback can support a proposition about the contactor mechanism/main-contact relationship. The machine still needs separate evidence for actual stopping, gravity/external-force behavior, stored energy and maintenance isolation.

### STO architecture

Siemens SIMODRIVE 611 documentation states that Safe Torque Off prevents the motor shaft from generating torque. The same documentation explicitly states that STO **does not electrically isolate the drive from line supply**, and that standstill must be secured separately; additional brakes may be required where external torque creates danger. This is a useful architecture contrast because the final element is no longer a pair of upstream power contactors whose mechanically linked auxiliaries witness contact state. The relevant proposition is inhibition of torque-generating capability inside the drive, under the selected drive's safety architecture.

Therefore:

- `STO ACTIVE != MOTOR STANDSTILL PROVED`;
- `STO ACTIVE != ELECTRICAL ISOLATION`;
- `STO ACTIVE != GRAVITY/EXTERNAL LOAD RESTRAINED`;
- maintenance electrical isolation remains a separate function/procedure;
- if the hazard requires standstill, holding, safe speed or another physical state, the validation witness must match that proposition rather than merely read an STO status bit.

The contrast teaches a general rule: **final-element architecture determines the legitimate witness.** A contactor auxiliary, a drive safety-status channel, a valve-position switch and a pressure transducer are not interchangeable evidence. Each can prove only the physical/electrical relationship established for that selected architecture.

## Validation implications

1. Inject a single-contactor failure only in a bounded, de-energized/safe fixture or manufacturer-approved test context; verify the selected feedback/reset response without exposing personnel to hazardous motion.
2. Test feedback open and plausible-state faults separately. An open-circuit diagnostic success does not establish short/plausible-state diagnostic coverage.
3. Test loss/restoration of each common supply/reference as a dependency case, not merely as two independent channel tests.
4. Verify reset as an event distinct from ordinary cycle start. Retained ordinary commands must not cause unexpected restart when safety permissive returns.
5. For contactor power interruption, separately validate machine stopping and residual energy.
6. For STO, separately validate standstill/holding when required and preserve electrical isolation as a distinct maintenance proposition.
7. Do not derive PL/SIL, stopping distance, diagnostic coverage, proof-test interval or machine-safe timing from these architecture examples.

## Bench-lab decision

No bench lab is justified by this session. The architecture and failure-proposition questions above are resolved far enough by authoritative manufacturer documentation. Remaining uncertainties are selected catalog/configuration and machine-integration questions; a lab becomes justified only after a concrete selected circuit exists and documentation leaves a specific electrical/configuration interaction unresolved. Any such compute/test support remains local-only on `[self-hosted, openpressbrake]`; hazardous-machine validation remains a separate physical commissioning activity.

## New durable freezes

- **FEEDBACK PLAUSIBLE != CONTACTOR MECHANISM PROVED**.
- **REDUNDANT CONTACTORS != INDEPENDENT ENERGY-REMOVAL CHANNELS**.
- **FINAL-ELEMENT ARCHITECTURE DETERMINES THE LEGITIMATE WITNESS**.

These supplement, rather than replace, the existing freezes `MECHANICALLY LINKED CONTACTOR FEEDBACK != MACHINE SAFE STATE PROVED`, `POWER RESTORED != REARM ELIGIBLE`, `RESET ACCEPTED != HAZARDOUS MOTION COMMANDED`, `STO ACTIVE != MOTOR STANDSTILL PROVED`, and `STO ACTIVE != ELECTRICAL ISOLATION`.

## Sources

- Rockwell Automation, *Light Curtain and Configurable Safety Relay Safety Function Application Technique*, SAFETY-AT164A-EN-P — 450L -> 440C-CR30 -> 100S-C chain, feedback and reset behavior.
- Rockwell Automation, *IEC Contactor Specifications*, 100-TD013 — 100S-C/104S-C mechanically linked/mirror-contact construction and selection data.
- Rockwell Automation / SUVA, 100S-CT015A-EN-E — covered 100S-C family and mirror/mechanically-linked contact certification references.
- Siemens, *SIMODRIVE 611 Configuration Manual*, PJU 02/2012 — STO torque-prevention boundary, no line-supply isolation, standstill/external-torque caveats.

Evidence is `DOC-CONFIRMED` unless marked `UNKNOWN` or `INFERENCE`. No runtime/test evidence was generated.