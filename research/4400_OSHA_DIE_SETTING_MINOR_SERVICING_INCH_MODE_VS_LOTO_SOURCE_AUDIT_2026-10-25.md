# 4400-SETUP-01 — Die setting, inch mode and the minor-servicing exception

**Status:** non-graduated, 2026-10-25. This is a **distinct source question** from group LOTO/shift handoff. Directly relevant to the temptation to leave a hydraulic press in inch/setup mode during tool change. **US OSHA hydraulic power press scenario**, not a press-brake-specific Type-C standard or selected OpenPressBrake safety approval.

## Original authority and source-access qualification
1. OSHA **April 22, 2005** letter, corrected February 20, 2008, *LOTO requirements for die-setting operations in hydraulic power presses*: https://www.osha.gov/laws-regs/standardinterpretations/2005-04-22
2. OSHA **December 28, 2006** letter, *Application of LOTO to die-setting and other machine setup*: https://www.osha.gov/laws-regs/standardinterpretations/2006-12-28
3. OSHA **January 25, 2008** letter, *PLC alternative protection for minor servicing*: https://www.osha.gov/laws-regs/standardinterpretations/2008-01-25
4. 29 CFR 1910.147(a)(2)(ii), (b), (f)(1): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147
5. OSHA minor-servicing eTool: https://www.osha.gov/etools/lockout-tagout/hot-topics/relationship-subpart-o/minor-servicing-exception

**Access:** official OSHA search-indexed source passages retrieved 2026-10-25; direct open of OSHA pages in this environment returned 403. Therefore **DOC-CONFIRMED from indexed original-authority text**, not a claim of full direct PDF/page inspection. The 2005 letter is interpretation of the specified hydraulic power press scenario, not a new regulation.

## Central discriminator
The 2005 original OSHA interpretation rejects the proposed shortcut: 'keep press in key-selected inch mode with two-hand controls during unbolting/removing/replacing dies, instead of LOTO.' The letter states a properly applied inch mechanism may be protective **during the necessary energized testing/positioning step**, but does not by itself protect workers performing other hands-in-die-space servicing. It specifically identifies gravity, hydraulic leakage/component failure, dropped upper die, unintended activation and a foot-control treadle hazard. **Slow motion and two-hand activation do not remove these stored-energy mechanisms.**

The 2006 interpretation confirms that die setting is *setup/servicing*, not automatically normal production, and that the minor-servicing exception generally does not apply to hydraulic/mechanical power-press die setting because the activity is not during normal production operations. The 2008 interpretation says a PLC is not an energy-isolating device and its use as an alternative protective measure is only potentially defensible for a genuinely qualifying **minor, routine, repetitive, integral activity during normal production**, with case-specific effective-protection hazard analysis. **Do not invert this narrow exception into general permission to use LinuxCNC/FPGA jog as maintenance isolation.**

## Decision table
| Activity | Source-grounded analysis | Required next step |
|---|---|---|
| Hands-on removal/refastening of a die, press stopped | Servicing, not inherently minor servicing during production; inch switch is control circuit, not isolation | Apply appropriate energy control and independent load restraint; verify actual machine-specific sources and isolation. |
| Brief positioning movement needed for alignment | 1910.147(f)(1) allows *limited* temporary energization with people/tools clear and reapplication of isolation afterwards | Qualified risk/guard plan; no exposed-person trial; return to verified LOTO before hands-on work. |
| Routine production adjustment with effective safeguarding and no hazardous exposure | Potential minor-servicing exception **only** if every condition is met | Document exact task, alternative protective function, hazard analysis and independent evidence; not automatic. |
| Machine with upper die hanging from slide | Gravity/drop hazard may persist despite electrical deenergization | Verify positive mechanical retention/support and all energy zones; no invented support capacity. |
| Control mode changes to 'slow jog' | Does not inherently inhibit drift, mechanical failure or third-party actuation | Do not accept as a maintenance isolator or proof of physical holding. |

## Press brake transfer caution
OSHA's hydraulic **power press** die-setting examples illustrate general failure mechanisms. A **press brake** has different construction, point-of-operation geometry, safeguarding and Type-C requirements; 29 CFR 1910.217 specifically does not automatically govern press brakes (see existing BLOCK-01 research). The 1910.147 energy-control analysis and general principle of physical hazard isolation remain important, but **do not transfer the 2005 letter's press-specific safety-block wording or other regulatory scope as universal press-brake requirements**. Evaluate exact task, jurisdiction and machine design.

## Failure-path and human factors
**Common shortcut:** operator repeatedly unlocks LOTO for a 2-second alignment, finds the procedure inconvenient, and leaves the machine in inch mode for subsequent hands-on tooling work. **INFERENCE design response:** provide an ergonomic tool-handling fixture, clearly staged ALIGN versus HANDS-ON states, safe remote observation, quick individual-lock access, positive physical ram/tool restraint, and explicit return-to-isolation verification. The design should reduce the temptation to defeat the safeguard, not merely add warning stickers.

## Evidence classification and stop
**DOC-CONFIRMED (official indexed):** exact OSHA 2005/2006/2008 distinctions. **SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **INFERENCE:** staged workflow and safeguard usability. **UNKNOWN:** OpenPressBrake die mass/retention, Y1/Y2 ram holding, hydraulic circuit, selected safety function, stop time, PL/SIL, exception applicability and actual validation. No machine operation, compute or simulation. **G0/G1 HOLD**, no people-exposed operation.
