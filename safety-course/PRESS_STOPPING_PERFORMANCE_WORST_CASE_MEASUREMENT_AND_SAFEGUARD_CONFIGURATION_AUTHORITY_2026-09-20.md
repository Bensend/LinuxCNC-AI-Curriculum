# Press stopping-performance worst-case measurement and safeguard-configuration authority

## Purpose

Extend the return-to-service curriculum beyond a single stop-time number. This study traces authoritative U.S. press-safety evidence showing that quantitative stopping-performance acceptance is coupled to the machine configuration under which the measurement is taken and to the installed safeguard geometry.

## Evidence labels

- **SOURCE-CONFIRMED** — regulatory text or authoritative OSHA guidance directly states the requirement.
- **INFERENCE** — engineering consequence derived from multiple confirmed requirements.
- **UNKNOWN** — OpenPressBrake-specific value or behavior not established by this evidence.

## Source trace

### 1. Safety distance depends on measured stopping time

**SOURCE-CONFIRMED.** OSHA's machine-guarding guidance for presses states that safety distance is based on machine stopping time and that a portable or built-in stop-time measurement unit is used to determine stopping time. OSHA further explains that such measurement is applicable to reciprocating machines including mechanical and hydraulic presses and press brakes, and can be repeated periodically to confirm that the installed safety distance remains appropriate for the machine's current stopping ability.

Source: OSHA Machine Guarding eTool, `Presses — Safety Distance`, accessed 2026-09-20.
https://www.osha.gov/etools/machine-guarding/presses/safety-distance

### 2. The measurement configuration matters

**SOURCE-CONFIRMED.** OSHA's 29 CFR 1910.217 supplementary material states that stopping-time measurements used for PSDI safety-distance derivation are made with clutch/brake air pressure at the manufacturer's recommended value for full clutch torque capability, with the heaviest upper die planned for use, and with slide counterbalance correctly adjusted for upper-die weight where applicable. It also requires safety distance to be based on the longest relevant measured downstroke stopping time rather than substituting a more favorable top-of-stroke value.

Source: OSHA / 29 CFR 1910.217 supplementary information, accessed 2026-09-20.
https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217AppD

This evidence is for mechanical-power-press/PSDI requirements; it must not be copied numerically into a hydraulic OpenPressBrake design. Its curriculum value is the physical principle: a stopping-time result is evidence for the tested machine state, not an abstract property of the controller.

### 3. Safeguard geometry remains coupled to stopping performance

**SOURCE-CONFIRMED.** OSHA's press guidance defines minimum safety distance from the sensing field to the hazard from measured stopping performance and notes that total system response includes machine, control, protective-device and interface response. OSHA also states that periodically rechecking stopping time is used to ensure the current safety distance still corresponds to the machine's current stopping ability.

**SOURCE-CONFIRMED.** In the mechanical-power-press PSDI requirements, where a presence-sensing-device location is adjustable, its location is set at each tool change/setup to provide the required minimum safety distance, or fixed far enough away to satisfy all tooling setups intended for that press. Adjustable location requires controlled adjustment.

Source: 29 CFR 1910.217 and OSHA Machine Guarding eTool, accessed 2026-09-20.
https://www.law.cornell.edu/cfr/text/29/1910.217
https://www.osha.gov/etools/machine-guarding/presses/safety-distance

## Curriculum freezes

**STOP-TIME NUMBER RECORDED != STOPPING PERFORMANCE VALID FOR EVERY MACHINE CONFIGURATION.**

**CONTROLLER RESPONSE VERIFIED != PHYSICAL MACHINE STOPPING PERFORMANCE VERIFIED.**

**ONE FAVORABLE STOP TEST != WORST-CASE RELEVANT STOPPING PERFORMANCE ESTABLISHED.**

**STOPPING PERFORMANCE ACCEPTED != INSTALLED SAFEGUARD GEOMETRY VERIFIED.**

**SAFEGUARD DISTANCE ON PAPER != PHYSICAL SAFEGUARD LOCATION VERIFIED.**

**PREVIOUSLY VALID SAFEGUARD LOCATION != CURRENTLY VALID LOCATION AFTER STOPPING-PERFORMANCE DETERIORATION OR RELEVANT CONFIGURATION CHANGE.**

## Change-impact interpretation

The evidence supports a dependency-oriented return-to-service model:

1. identify whether maintenance or configuration change can affect physical stopping performance;
2. if it can, invalidate the affected quantitative stopping-performance evidence;
3. repeat the applicable physical measurement under a justified machine condition rather than a convenient condition;
4. recompute/recheck the safeguarding requirement using the governing machine/safeguard standard and actual system response inputs;
5. physically verify the installed safeguard geometry;
6. only then continue through the machine's required functional checks and production-release process.

Steps 1–6 as a universal cross-machine sequence are **INFERENCE** assembled from the cited evidence and prior manufacturer traces; they are not claimed as a verbatim OSHA checklist.

## OpenPressBrake boundary

The following remain **UNKNOWN** and must not be imported from the mechanical-press examples:

- OpenPressBrake stopping-time or stopping-distance limit;
- the governing safety-distance equation for its eventual safeguarding architecture;
- worst-case hydraulic load, tooling, pressure, ram position, speed, temperature or other test conditions;
- required number and locations of measurements;
- protective-device response time and penetration/additional-distance terms;
- PL/SIL/Category targets;
- brake-monitor tolerances;
- proof-test interval.

Those require the actual machine risk assessment, safeguard selection, hydraulic architecture, component documentation and physical validation.

## Human-factors implication

A safeguarding installation should make correct physical location easy to preserve and hard to casually defeat. Where adjustment is legitimately needed, provide an obvious reference, controlled adjustment, durable labels/records and a straightforward requalification method. A safeguard that routinely must be moved out of the way to perform normal work creates predictable defeat pressure and should be treated as an engineering defect in the machine/safeguard integration.

## LinuxCNC / FPGA boundary

LinuxCNC or the ordinary FPGA may record stop-test results, machine state, tooling/configuration identity and maintenance history. They may assist the commissioning workflow. They do not become the personnel-safety authority merely by computing a distance or displaying PASS. The independent safety architecture and physical safeguard/final elements remain authoritative, and the physical machine response must be measured where the safety function depends on it.

## Information-gain result

This closes a curriculum gap between `quantitative stop test` and `which physical machine state did that result actually validate?` It also strengthens the maintenance change-impact matrix: changes to tooling/load/counterbalance/stopping mechanism or other parameters that can materially alter stopping performance can invalidate a previously accepted physical-performance witness even when safety logic and configuration checksums are unchanged.

Next high-value evidence should be a modern machine/OEM partial-acceptance or maintenance matrix that explicitly identifies affected safety functions and then maps them to physical final-element/performance revalidation. Prefer hydraulic/mechanical machinery over more generic drive acceptance documentation.
