# 25E0 adversarial exercise — active brake proof with two witness classes

## Scenario

A vertical machine axis has a spring-applied holding brake. The drive reports the brake command as applied and the brake-control circuit reports no electrical fault. During commissioning, a Safe Brake Test-style diagnostic deliberately applies a configured motor torque against the brake while monitoring axis position.

Test A: brake command is applied; axis motion remains inside the configured position tolerance.

Test B after maintenance: brake command is applied, but axis motion exceeds the configured tolerance while the same test challenge is applied.

Separately, the ordinary controller's Cycle Start input is held continuously true throughout Test B and remains true after the technician repairs the brake mechanism.

## Required reasoning

1. What does the brake command prove by itself?
2. What additional physical claim can Test A support that the brake-command/status signal cannot?
3. Why is Test A still not proof that every hazardous energy path is safe?
4. What should Test B mean for return to production?
5. Does repair of the brake mechanism, by itself, prove the safety function is revalidated?
6. May the continuously held Cycle Start become the production start merely because the safety proof later succeeds?
7. Which facts require design-specific validation rather than copying an OEM example?

## Expected reasoning boundaries

- The command/status establishes control-state evidence, not holding capability.
- A defined challenge plus measured axis response within a defined tolerance can support a bounded claim that the brake resisted that challenge under those test conditions.
- The test does not automatically prove other brakes, hydraulic/pneumatic stored energy, mechanical transmission integrity outside the tested chain, safeguard state, personnel clearance, or future performance.
- Excess motion is a failed physical proof and must block normal return to production until the defined corrective action and validation are complete.
- Repair is not validation. The required retest/reset/rearm sequence comes from the actual safety implementation and validation plan.
- Ordinary demand freshness remains independent. A held Cycle Start must not be treated as a newly issued demand merely because safety eligibility returns; the ordinary-control design should require the intended fresh-start semantics.
- Test torque, allowable displacement, test interval, stopping/holding requirements, diagnostic coverage, PL/SIL claims, and reset behavior are design-specific.

## Misleading premise to reject

> "The brake output is safe-rated and its status says applied, so the brake is proven safe."

Reject it. Safe command integrity and mechanical holding capability are different evidence classes.

## OpenPressBrake transfer question

For a press brake or other gravity-loaded hydraulic axis, identify separately which evidence would be needed to support each claim: valve commanded safe, valve physically in expected position, downstream pressure reduced, ram not moving, retaining/brake mechanism capable of holding load, safety function rearmed, and ordinary production demand fresh. Do not merge these into one `SAFE=true` variable.
