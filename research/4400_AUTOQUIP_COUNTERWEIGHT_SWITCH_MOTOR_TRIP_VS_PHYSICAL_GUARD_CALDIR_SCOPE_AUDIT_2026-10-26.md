# 4400-CW-01 — A counterweight travel switch does not catch a falling counterweight

**2026-10-26 | Original OEM + official regulatory source audit | NON-GRADUATED.** Cross-machine 4000 safety deepening; **not** evidence that OpenPressBrake has a counterweight, lift or Autoquip hardware.

## Question
If a limit/sensing switch detects a counterweight rising out of its guide and removes motor power, does that establish physical containment of the counterweight during a rope/chain failure, access to its travel path, or maintenance isolation?

## Direct original sources
- [Autoquip, Counterweight Sensing Switch Installation Instructions, six-page OEM PDF](https://autoquip.com/wp-content/uploads/2018/03/counterweight_sensing_switch_install_instructions.pdf), pp.1–2, plus installation figures pp.3–6. [Autoquip support index](https://autoquip.com/troubleshooting/) links this manual. The PDF filename path contains 2018/03; **the issue/revision date is not established by that URL**.
- [California DIR Title 8 §3318, Counterweights — General Industry Safety Orders](https://www.dir.ca.gov/title8/3318.html), official public text, accessed 2026-10-26.
- [California DIR Title 8 §1604.12, Location and Guarding of Counterweights — Construction Hoists](https://www.dir.ca.gov/title8/1604_12.html), official public text, accessed 2026-10-26. **Different regulatory scope**, not a universal machine requirement.
- [OSHA 1910.147(d)(5)–(6)](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147), stored energy and isolation verification for covered maintenance.

## DOC-CONFIRMED mechanism and limits
| Source | Direct claim | Narrow consequence | Not established |
|---|---|---|---|
| Autoquip p.1 | Counterweight switch intended to **turn off motor** if weight attempts to exit guide tube at top; NC contact opens when tripped | A particular **overtravel / motor control** demand path exists in this lift kit | Counterweight cable integrity, load-side restraint, personnel protection after cable break |
| Autoquip pp.1–2 | Position/arm adjusted for physical contact; qualified electrician uses order-specific schematic, especially post-11/2006; continuity closed at rest, open when actuated | Device installation and wiring **depend on actual lift revision and schematic** | Installed safety PL/SIL, redundant final elements, actual stop time |
| CA DIR §3318 | General-industry counterweights must be guarded against falling hazards, with stated alternatives/exceptions; note mentions chains/cables | **Physical containment/exclusion** is a separate safety topic | Automatic application to every jurisdiction or a particular LinuxCNC machine |
| CA DIR §1604.12 | Construction-hoist counterweight pit guarding, enclosure and locked access rules | A **construction-hoist-specific** access and guarding scope exists | Universal 6–8 ft guard requirement for press brakes or mills |

**Important engineering separation:** the Autoquip sensing switch responds to a **specific counterweight overtravel scenario**, not necessarily a broken support cable. The switch's motor-power reaction does not mechanically catch a weight that is already free to fall. This is an **INFERENCE** from the described load path, not a performed break test. Likewise a guard can exclude personnel without stopping a moving counterweight; both physical propositions must be evaluated for the selected machine.

## Adversarial fault paths (conditional)
1. **Motor continues pulling after jam:** Autoquip's intended switch can demand motor stop if physically contacted and correctly wired; downstream power removal and actual motion still require verification.
2. **Counterweight support cable fails below switch:** weight can fall without ever lifting the top switch arm. **Do not infer** the switch detects this fault.
3. **Switch arm misaligned or installation revised:** counterweight may not contact arm; OEM specifically requires mechanical position and order-specific electrical schematic. A green HMI bit is not proof.
4. **Person enters counterweight travel zone:** a functioning motor trip is not an enclosure, barrier, lockout or independently restrained mass.
5. **Reset after a jam:** restoring motor authorization without resolving jam and counterweight condition can reintroduce motion; require qualified fault resolution, occupancy clearance and fresh start.

## Practical builder design pattern
Treat **(a) overtravel motor inhibit, (b) fall restraint/containment, (c) access guarding, (d) service isolation and (e) deliberate restart** as five different requirements. The simplest robust approach is a physically enclosed counterweight path or independently engineered restraint where warranted, with easy inspection access and an independent qualified motor-stop function where the hazard analysis requires it. Keep LinuxCNC/FPGA normal control and HMI diagnostics separate from safety-related final elements. A service gate must be easy to close correctly; a hard-to-reinstall guard is a predictable bypass hazard.

Do **not** copy California construction-hoist guard dimensions to a press brake, assign a safety performance level to an ordinary limit switch, or invent a counterweight mass/stopping distance. Verify actual jurisdiction, applicable machine standard and as-built design with qualified personnel.

## Evidence ledger / continuation
**DOC-CONFIRMED:** exact Autoquip OEM and California DIR text; OSHA stored-energy text. **SOURCE-CONFIRMED LinuxCNC:** none. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **INFERENCE:** distinct overtravel/retention/guarding failure paths and architecture. **UNKNOWN:** whether any counterweight exists on OpenPressBrake, exact switch and motor path, restraint/guard/access, selected PL/SIL, physical Y1/Y2 hold, evaluator. If selected machine has no counterweight, mark this conditional branch N/A with qualified evidence; essential ram/hydraulic gates remain HOLD. No fault injection or personnel-exposed test authorized. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.
