# 4400-ROBOT-PLANE-01 — Safety plane on screen versus physical swept volume
**2026-10-29 | six UNSCORED paper technician scenarios | no machine test**

Use [the original UR SW10_15 source audit](../research/4400_ROBOT_PLANE_01_UR_SW10_15_DYNAMIC_SAFETY_PLANE_LATE_TRIGGER_AND_UNMONITORED_GEOMETRY_OEM_AUDIT_2026-10-29.md) and existing [25F0 machine safety capstone](SAFETY_COURSE_INDEX.md). Do not treat these visible exercises as a blind independent score.

1. A gate opens and a safety input activates a restrictive robot plane after the arm is already approaching it. The operator claims the plane can never be crossed. Which exact SF23 OEM exception invalidates that unconditional claim, and what physical evidence would be required before access?
2. A robot's TCP stays outside a forbidden zone, but its elbow or wrist passes near a person. What selected monitoring options and full-arm geometry must the reviewer inspect?
3. A gripper carries a long sheet; the safety configuration includes a small sphere at the tool flange. Which actual swept volumes are absent from that approximation? How could an independent guard make the safe architecture simpler than relying on a visual sphere?
4. A frame copied from a fixture has its normal reversed. The GUI draws a neat plane, but the permitted side is opposite the engineer's intention. What unpowered review can identify the direction/transform discrepancy before a qualified isolated physical validation?
5. The safety plane is configured only for Reduced mode; an HMI switches to Normal and another robot enters the same work cell. What separate mode and machine-scope protections must be demonstrated?
6. A technician reduces a tool-sphere radius because it blocks convenient teaching near a fence. Identify the human-factors defect and propose a fixture/guard/interface redesign that removes the incentive without weakening the actual protected envelope.

## No-energy selected-machine intake
| Required evidence | Status |
|---|---|
| Exact robot/firmware/manual and selected safety plane/config revision | UNKNOWN |
| Input activation latency, mode/plane direction and selected stop limits | UNKNOWN |
| Configured monitored elbow/wrist/flange and custom tool spheres | UNKNOWN |
| Actual tool, payload and all moving components' swept volumes | UNKNOWN |
| Physical guards, other machines and independent safety final elements | UNKNOWN |
| Qualified isolated witness, stop distance, validation and release | NOT RUN |

**Boundary:** No personnel-exposed operation if the physical protected zone and safe stop/hold are unproven. Ordinary LinuxCNC/HAL/FPGA geometry displays are diagnostic, not personnel-safety authority. Experimental motion requires qualified isolated/remote operation with people outside the danger zone and residual risk recorded. **DOC-CONFIRMED** OEM source scope; **INFERENCE** application hazards; **UNKNOWN** machine; **TEST-CONFIRMED none**. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.
