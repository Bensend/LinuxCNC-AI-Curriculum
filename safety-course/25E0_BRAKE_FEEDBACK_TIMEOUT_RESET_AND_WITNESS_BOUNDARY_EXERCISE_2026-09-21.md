# 25E0 Adversarial Exercise — Brake feedback timeout, reset, and witness boundary

Date: 2026-09-21

## Scenario

A vertical servo axis uses a safety controller's Safe Brake Control function. The function commands two brake-control outputs and receives two brake-feedback signals. Manual restart is configured. The configured feedback-check delay is 250 ms.

At t=0 the function commands the brake to engage. One feedback channel reaches its expected state in 90 ms; the other remains in the old state. At t=250 ms the safety function declares a brake-feedback fault and drives its brake outputs to the documented fault state.

A technician finds a loose feedback connector. At t=8 s the connector is reseated and both feedback inputs now indicate the expected state. The ordinary CNC application has had an `axis_enable_request` continuously true since before the fault. No new operator action has occurred.

The HMI now shows both feedback bits in the expected state. A maintenance note says: `Brake feedback good again — OK to run.`

## Questions

1. Is the safety brake function automatically reset merely because both feedback inputs have recovered?
2. In manual-restart operation, what additional transition is required before the documented SBC function may resume normal operation?
3. May the ordinary `axis_enable_request`, which remained true throughout the fault, be treated as a fresh production demand after safety permission returns? Explain the authority boundary.
4. What did the 250 ms timeout establish, and what did it not establish?
5. Does `both brake feedback bits valid` prove that the vertical load cannot fall? Name at least four physical claims that remain outside the feedback witness unless separately established by the actual design/validation.
6. A programmer proposes changing the safety function to automatic restart because this avoids the operator reset step after connector repair. What evidence is required before that change is acceptable?
7. Why would `drop STO immediately for every brake-feedback fault` also be an unsafe universal rule for vertical/gravity-loaded systems?
8. Write a safe return-to-operation sequence that keeps ordinary CNC/LinuxCNC demand freshness separate from independent safety reset/rearm.

## Expected reasoning / review key

1. **No.** In the documented Rockwell SBC behavior, a fault keeps brake outputs in the fault state until the fault condition is corrected **and SBC is reset**. Signal recovery is not equivalent to reset.
2. Manual restart requires the documented fresh Reset transition under valid reset conditions. A reset attempt while the fault condition remains is not equivalent to a successful reset after correction.
3. **No automatic inference.** The safety subsystem may restore permission after its valid reset, but ordinary LinuxCNC/CNC control must separately decide whether a demand held through the authority loss is stale. The safer reusable production-control pattern is to invalidate/consume pre-fault motion authority and require a deliberate fresh demand where the machine's validated state machine requires it. Ordinary LinuxCNC logic must not become the personnel-safety authority.
4. The timeout establishes that the configured feedback failed to reach the expected relationship to the brake command within the allowed diagnostic interval. It does not measure actual brake torque, stopping distance, stopping time, load support, or all mechanical failure modes.
5. No. Examples outside the generic bit witness include actual holding torque/force, friction/wear margin, stopping performance, mechanical attachment integrity, stored energy, gravity-driven movement, sensor/contact truthfulness, and whether the brake physically engaged despite a misleading feedback mechanism.
6. A machine-specific risk/safety analysis and validated architecture must establish that automatic restart cannot create an unsafe condition. The convenience of avoiding reset is not evidence. Vendor permission for an option is not machine validation.
7. Rockwell explicitly discusses gravity-load applications where maintaining motor control during some brake-feedback faults can be necessary. Removing torque before a brake is physically capable of holding the load can itself create hazardous motion. Required sequencing is design-specific and must be validated.
8. One defensible sequence is: maintain the independent safety fault response; diagnose and correct the feedback fault; verify the physical final element to the degree required by the maintenance/change; perform the safety function's required fresh reset/rearm; positively clear stale ordinary motion/start requests; restore ordinary controller eligibility; require the validated fresh operator/automatic production demand; then observe/validate machine response as required. Safety permission and ordinary start remain separate transitions.

## Failure traps

- Treating a recovered input level as fault reset.
- Treating safety reset as production Start.
- Letting a held ordinary demand silently become fresh when safety permission returns.
- Treating an auxiliary switch/contact as proof of brake torque or stopping performance.
- Assuming automatic restart is safer because the vendor offers it.
- Assuming immediate STO is universally safe for gravity-loaded axes.
- Copying the 250 ms example value into another machine. It is an exercise value, not an OpenPressBrake requirement.

## Evidence classification

The Rockwell SBC timeout/reset semantics used here are DOC-CONFIRMED. The generic demand-freshness production pattern is an engineering INFERENCE carried by the curriculum and must be implemented/validated per machine. Physical brake capability and stopping performance are UNKNOWN until established by design-specific evidence.