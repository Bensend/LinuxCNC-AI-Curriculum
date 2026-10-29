# 4400-ROBOT-PLANE-01 — A safety plane may be crossed after a late activation; not every arm part is covered
**2026-10-29 | original Universal Robots g-Series PolyScope X SW10_15 online manufacturer manual | NON-GRADUATED**

## Unresolved engineering question
Can a dynamically enabled safety plane guarantee that no part of a robot, long gripper, carried sheet or attached tool crosses a person's boundary? What happens when the safety-plane input activates too late to stop before the plane? This is distinct from the [3PE mode/Freedrive](4400_ENABLE_02_UR_SW10_15_THREE_POSITION_MODE_FREEDRIVE_SF19_SF20_OUTPUT_CONTRACT_OEM_AUDIT_2026-10-29.md) and [status-output](4400_ROBOT_STATUS_01_UR_SW10_15_MOVING_NOT_STOPPING_TOOL_IO_AND_SAFEGUARD_STOP_SEMANTICS_AUDIT_2026-10-29.md) questions.

## Direct original OEM documents read on 2026-10-29
- Universal Robots, *g-Series / PolyScope X SW10_15 Safety Functions Table*, **SF23**, rows 159–170: https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/complianceG7/safetyFunctionsAndinterfaces/safety_functions_table1.htm
- Universal Robots, *Safety Planes*, lines 92–113 and 130–142: https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/complianceG7/PolyX_SW/safety_planes.htm
- Universal Robots, *Tool Position Restriction*, lines 92–103 and 111–122: https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/complianceG7/PolyX_SW/polyx_toolposition.htm

**Provenance:** manufacturer-hosted HTML with exact SW10_15 URL path and inspected passages. No immutable PDF hash, selected robot installation, active plane configuration or firmware execution captured. These are **DOC-CONFIRMED** version/product-specific descriptions, not TEST-CONFIRMED physical results or general guarantees for other robots.

## Four source-grounded findings
1. **Late SF23 activation can violate the plane.** The OEM SF23 row explicitly says that if the monitored TCP pose is already beyond a newly imposed plane or there is insufficient time/distance to stop, a stop is initiated but the monitored TCP pose **may pass the plane** while complying with configured stopping-time/distance limits. Therefore an input that switches from free movement to restricted movement is **not** an instantaneous physical barrier. No machine-specific threshold or distance can be inferred without the actual state/limits and qualified measurement.
2. **Plane geometry is not whole-robot coverage.** The OEM Safety Planes page warns that only configured tool spheres and selected monitored arm parts (e.g. elbow) are constrained; it does **not guarantee every arm part** stays on the permitted side. The operator can configure elbow and flange/wrist restriction options; their selected state matters.
3. **Tool shapes require selected approximation.** The OEM Tool Position page allows up to **two custom tool-position spheres**, with configured radii and offsets relative to flange. A long bar, gripper, vacuum sheet, sharp tool or payload may not be bounded by an incorrectly sized or positioned sphere. This is an **INFERENCE about geometry** grounded in the OEM's explicitly limited modeled points; it is not evidence of a specific UR model defect.
4. **Frames, direction and mode matter.** OEM Safety Planes instructions warn that copied frames can invert the intended plane and suggest 180-degree tilt correction when the robot is on the violating side. Planes may be Normal, Reduced, Both or Trigger Reduced Mode; a reduced-mode trigger is not equivalent to an unconditional exclusion barrier.

## Hazard-path counterexamples (engineering inference, not measured failures)
| Intended safety claim | Counterexample that must be resolved | Required selected evidence |
|---|---|---|
| "When the input changes, the robot cannot cross this plane." | Input changes too late; SF23 initiates a stop but crossing is possible | Timing, distance, selected safety limits, independent physical verification and approach control. |
| "Everything attached to the arm is behind the plane." | Long gripper/sheet extends beyond configured spheres | Actual end-effector/payload swept volume and validated geometry/guarding. |
| "The whole arm is fenced by the plane." | Wrist/elbow/flange restrictions disabled or other arm segments unmodeled | Selected monitored elements, full swept-volume analysis and physical barrier as required. |
| "The green plane graphic means correct orientation." | Copied frame reversed; Normal/Reduced scope differs | Qualified frame/plane direction and mode review; source-version record. |
| "The robot safety plane makes the shared cell safe." | Other robots, backgauges, hydraulic rams, tools or loads move independently | Separate safety functions/final elements for every hazardous energy source and entrant. |

## Practical design/verification contract
**NORMAL:** LinuxCNC/FPGA/HMI may display robot/tool position, request normal motion and log a plane input. These do not grant personnel-safety authority.

**SAFETY:** selected independent safety architecture must define which physical volumes are protected, how mode/input changes are evaluated, actual monitored points/spheres, safety-rated speed/stopping limits, access and guard status, and failure response. A safety plane can contribute to risk reduction only within its proven configuration and physical envelope.

**PHYSICAL:** guard geometry, actual stopping behavior, tool/payload extent, falling-load restraint, and interaction with neighboring machines require independent evidence. No generic stopping distance, PL/SIL, payload size or safe speed is invented.

**HUMAN FACTORS:** clear protected/uncertain zone indications, easy-to-reinstall physical barriers, no operator incentive to shrink tool spheres to make teaching easier, and mode changes that do not silently disable a needed boundary.

## Evidence disposition
- **DOC-CONFIRMED:** three UR SW10_15 original online manual sections above.
- **SOURCE-CONFIRMED (repository):** prior ENABLE-01/02, ROBOT-STATUS-01 and 25F0 robot/cell safety prerequisites exist.
- **INFERENCE:** geometric/human-factor failure-path transfer to actual tooling, robots and press-brake-adjacent cells.
- **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none used.
- **UNKNOWN:** selected machine and exact tool spheres/plane direction, actual robot speed/stop distance, adjacent axes, people exposure, integrated safety performance and independent witness.
- **Lab decision:** source resolves whether crossing is *possible* in the documented design; a synthetic simulation cannot establish a selected machine's geometry or safety distance. Do not dispatch compute merely to demonstrate the obvious.

**Release:** without validated actual hazard boundary and independent physical proof, no personnel-exposed hazardous operation. OpenPressBrake Stage A A–G public status unverified (restricted receipt UNKNOWN), G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.
