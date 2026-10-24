# 4400 engineering decision card — cable-pull E-stop versus tactile contact edge

**Scope:** generic machine-class safeguard selection and operator/maintenance human factors. This is a **non-graduated, paper-only comparison**, not a machine safety design or certification. Sources: [cable-pull OEM audit](../research/4400_CABLE_PULL_ESTOP_TENSION_MARGIN_GUARDLINK_STANDARD_TAG_SOURCE_AUDIT_2026-10-24.md) and [tactile-edge OEM/ISO public-scope audit](../research/4400_TACTILE_SAFETY_EDGE_SENSOR_PRINCIPLE_AUTORESET_AND_OVERRUN_SOURCE_AUDIT_2026-10-24.md). Do not infer either device is installed on OpenPressBrake.

## Do not substitute one reactive device for the other

| Design question | Cable-pull emergency stop | Tactile safety edge |
|---|---|---|
| Who initiates demand? | Person intentionally pulls accessible cable (or cable breaks, if selected device supports monitoring) | Moving machine part first contacts/deforms sensor against object/person |
| What hazard does it address? | Ability to command emergency stopping from many positions along a machine/line | Contact-triggered protective stop/reversal at a specific closing/shear edge |
| What does it **not** prove? | Person can always reach the rope; final element stops/holds; occupied area clear | Contact force/travel is tolerable; other pinch zones protected; residual travel safe |
| Typical transfer context | Long conveyor, feeder, exposed machine perimeter where risk assessment supports cable | Powered sliding door, guarded transfer/gantry closing edge with adequate overtravel |
| Key installation variable | Full-span reach, pull directions, snagging, cable tension/temperature, reset sightline | Sensing profile physics/coverage, deformation/actuation, machine speed/stopping travel/force |
| Product-specific trap | Lifeline 5 warning-margin tension can leave safety OSSDs **ON**; GuardLink standard tags aren't safety | Schmersal SE40 optical IR ≠ 8k2 resistive/NC chain; SE-304C can be configured auto-reset |
| Reset/restart | Local rope release/fault recovery ≠ independent safety rearm and new start | Edge clearing/monitor auto-reset ≠ independent safety rearm and new start |
| Anti-defeat design | Accessible cable, robust guides/spring, visible warning and easy retension, no awkward hidden reset | Robust washable compatible profile, easy replacement, false-trip diagnosis, adequate sensing zone and residual travel |
| Qualified proof | Demand from all accessible intended points, physical stop/hold and restart prevention | Qualified contact actuation/coverage, physical overtravel/force/stop/reversal and restart prevention |

**Neither device is an energy isolator, a substitute for fixed guarding where required, proof of occupancy, or a gravity-load holding mechanism.** A cable-pull E-stop is not a protective edge, and a tactile edge is not an emergency-stop command device. Do not use an ordinary LinuxCNC HAL input/FPGA output as the sole safety authority for either.

## Five real-world design reviews

1. **Plasma or router gantry:** A perimeter cable may help an operator request emergency stopping, but it does not prove safe contact with a fast moving gantry. A tactile bumper might provide supplemental contact detection only if stopping travel/force and all other approach paths are physically validated. Guarding or presence sensing may be more suitable.
2. **Long feeder/conveyor:** A correctly routed pull wire can provide distributed E-stop access, but stock can snag/hide the rope. Assess trapped-wire probability and all pull directions; don't declare coverage from one successful test near the switch.
3. **Automated machine door:** A contact edge can protect a closing pinch line only where its profile can detect before dangerous force develops. Unprotected corners/hinges and unexpected reclose remain separate hazards; a rope across the door is not an equivalent fix.
4. **Press brake:** Neither device proves the upper ram can stop and remain held against gravity or that the bending point is guarded. An operator's emergency-stop access, rear/backgauge guarding, press-specific point-of-operation safeguards, hydraulic isolation and load restraint require separate evidence.
5. **Robot/transfer cell:** Neither a rope nor contact edge proves the cell is empty after entry. Use risk-assessed guards/occupancy/escape and deliberate restart; ensure one E-stop span does not leave adjacent motion hazardous.

## Make the correct action the easiest action

- **Don't make operators choose between protection and productivity.** Investigate recurring cable tension warnings or edge nuisance trips; adjust architecture, robustness, service access and spare availability rather than accepting a bridge/bypass.
- **Put reset where it is meaningful.** If a rope reset cannot see the span, require an effective full-span inspection/occupancy method. If an edge monitor can auto-reset, the separate machine safety controller must prevent automatic hazardous restart when needed.
- **Make diagnosis visible without giving it authority.** A LinuxCNC screen can show which cable/edge, warning, fault and maintenance status is active, with stale-data indication. It must not replace the qualified safety signal or independent final element.
- **Keep guards simple to reinstall.** Tool-less access where appropriate to non-safety covers, captive hardware for safety-related guards where required, clear alignment features and an obvious restoration test reduce defeat pressure. Do not weaken guard integrity for convenience.
- **Prove what the person experiences.** Device LEDs and PLC bits are intermediate observations. The acceptance claim is about a real person not being exposed to hazardous force/motion, verified by qualified physical methods with people outside the danger zone during experimental commissioning.

## Selection and release gate

| Gate | Required record | Default |
|---|---|---|
| `BND/HAZ` | Who/where/how exposed; normal, fault, setup, maintenance, rescue | UNKNOWN |
| `SF/SRS` | Exact required stop/hold/restart proposition, not a catalog label | UNKNOWN |
| `ARC/DEP` | Selected OEM sensor/switch, safety input/controller/final element, power/diagnostics | UNKNOWN |
| `PHY/VAL/PT` | Independently observed safe motion/force/holding/occupancy with qualified machine-specific criteria | NOT RUN |
| `CHG` | Revalidate after replacement, mode, wiring, cable route, profile or machine speed change | OPEN |
| `G3/G4` | Personnel-exposed operation | **NOT AUTHORIZED while minimum proof absent** |

**Evidence discipline:** OEM statements above are **DOC-CONFIRMED** only for cited products; general failure consequences are **INFERENCE**; selected-machine values, protection and test results remain **UNKNOWN**. No simulation, physical fault injection or human-contact test is authorized by this decision card.
