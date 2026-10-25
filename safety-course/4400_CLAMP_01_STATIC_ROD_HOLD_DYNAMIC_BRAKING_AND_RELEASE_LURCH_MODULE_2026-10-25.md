# 4400-CLAMP-01 — Rod holding is not dynamic braking, and releasing a clamp can create motion
**2026-10-25 | 4000 safety course | NON-GRADUATED | OEM documentary only**

## Prerequisites and objective
Prerequisites 2520 risk/SRS, 2570 drive stop, 2580 energy isolation, 4400-BLK-01 mechanical gravity restraint, 4400-HYD-01 physical holding/valve feedback, 4400-RST-01 deliberate restart. A fresh AI engineer should be able to reject three common but dangerous shortcuts: static-only rod clamp used as emergency brake, trapped cylinder air treated as guaranteed gravity holding, and spring-clamp release treated as motionless reset.

Read [original Festo/SMC source audit](../research/4400_FESTO_KP_KPE_KEC_S_STATIC_VS_DYNAMIC_CLAMP_SAFETY_OEM_AUDIT_2026-10-25.md) and [16 paper cases / blank selected witness](4400_CLAMP_STATIC_DYNAMIC_RELEASE_TECHNICIAN_AND_WITNESS_2026-10-25.md).

## Four physical propositions
1. **Normal command:** LinuxCNC/FPGA asks an actuator to stop, and normal pneumatics may center a valve. This is not the personnel-safety final authority.
2. **Dynamic arrest:** actual hazardous load is decelerated by a suitable, independently validated brake/valve/structure. The safety function includes stopping travel and wear response, not just "clamp on."
3. **Sustained hold:** actual load remains restrained under gravity and residual energy after stopping, including leakage, loss of pressure and component faults. A static rating is only one input to an engineering calculation.
4. **Controlled release/restart:** forces are balanced or otherwise safely controlled before releasing the brake; no retained CNC command moves the load when independent safety rearm becomes eligible.

## Exact manufacturer differentiation
**Festo KP/KPE/KEC** are not certified for safety-related control systems in the cited catalog and are not suitable for dynamic braking. **KEC-S** is a separately identified IFA/DGUV safety-related braking/holding component, with manufacturer scope at single-channel Cat.1 and additional measures for higher categories. Festo's 2017/10 DNCKE vs DNCKE-S catalog makes the same family distinction. No family name, "spring applied" description or advertised static holding force by itself proves achieved PL/SIL.

The original Festo KEC-S material identifies **machine-specific overtravel**, wear and selected valve/line/load effects. It also warns of sudden rod motion if released without balancing forces. SMC manufacturer guidance independently rejects relying on a center-closed pneumatic valve alone to hold heavy vertical loads. Do not invent a safe stopping distance, maximum mass, pressure threshold or inspection interval for an unknown machine.

## Proposed engineering sequence (INFERENCE, not PLC code)
**C0 Unknown**: no proof of load, brake variant, valve/air path, holding or personnel clearance => no hazardous operation.
**C1 Requested stop**: normal command may initiate deceleration; independent safety monitors/final elements own risk reduction.
**C2 Braking**: actual load is stopping; qualified system must account for selected overtravel and demand wear.
**C3 Held**: actual load and residual pressure are restrained, not inferred from a coil or PLC output.
**C4 Service**: use qualified LOTO and mechanical support where required; a spring clamp is not a universal substitute for isolation.
**C5 Release preparation**: independently ensure forces and loads are controlled before releasing clamp.
**C6 Deliberate restart**: independently reset safety after area clearance, then require new ordinary LinuxCNC start, with no queued motion.

## Human-factors design
Choose a brake/holding device with a clearly differentiated safety-rated part number where justified, simple access for inspection and adjustment, visible status that distinguishes "commanded" from "mechanically held," robust line routing, a protected service support, and a recovery procedure that does not tempt maintainers to defeat the clamp. If every nuisance stop damages or wears the clamp, redesign deceleration/maintenance rather than hiding fault alarms.

## Cross-machine transfer
A vertical pneumatic gantry and robotic fixture can need a spring-applied safety-related brake plus mechanical load path and independent isolation. A press brake's hydraulic Y1/Y2 requires separately selected hydraulic/gravity holding; a Festo pneumatic clamp example does not establish OpenPressBrake hardware or PL. Mills/lathes may have different spindle and tool retention loads. Robot payloads and vacuum grippers need their own holding functions.

## Evidence, evaluation and gate
DOC-CONFIRMED exact Festo/SMC; INFERENCE design state model; TEST-CONFIRMED none; SOURCE-CONFIRMED no new LinuxCNC path; COMMUNITY-REPORTED none; UNKNOWN selected machine components, dynamic force, overtravel, load, stop/hold and independent score. [16 learner PAPER cases](4400_CLAMP_STATIC_DYNAMIC_RELEASE_TECHNICIAN_AND_WITNESS_2026-10-25.md) are not blind competency. A fresh evaluator should create a novel case and withhold the oracle until precommitment. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 OPEN; no people-exposed operation.
