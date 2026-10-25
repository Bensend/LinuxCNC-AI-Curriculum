# 4400-GRIND-01 — abrasive-wheel speed/guard and variable-speed CNC authority
**2026-10-25 | independent second safety branch | documentary, no lab**

## Frozen question
Can a LinuxCNC spindle speed request, a VFD command, a wheel manufacturer's marked maximum speed, or a successful machine stop establish that an abrasive wheel is safe from overspeed/burst, including after wheel wear, replacement or setup change?

## Authoritative sources directly inspected
1. **OSHA 29 CFR 1910.215**, official regulation https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.215 : §(a)(1) guarding and limited exceptions; §(a)(4) work-rest geometry for offhand grinders; §(b) wheel/guard type and exposure-specific requirements; §(d)(1) wheel inspection, ring-test qualification and **machine spindle speed check before mounting**. The regulation's applicability depends on the actual wheel and machine type; do not copy bench-grinder work-rest requirements to every CNC grinder.
2. **Norton Abrasives / Saint-Gobain, Grinding Machine Maintenance**, original manufacturer guidance https://www.nortonabrasives.com/en-us/resources/expertise/grinding-machine-maintenance : wheel's marked RPM/SFPM must not be exceeded; speed check every mount/remount; variable-speed machine may raise RPM as wheel diameter wears **only while the original permitted surface speed is not exceeded**, per its cited ANSI B7.1-2017 discussion. This is manufacturer guidance referencing a standard, **not** an inspection of the licensed standard itself.
3. **OSHA Abrasive Wheel Equipment Grinder Checklist**, https://www.osha.gov/machine-guarding/new-grinder-checklist : accessible summary of guarding, work-rest, tongue, wheel RPM and ring-test checks. Use §1910.215 itself for scope/requirements, not checklist as blanket CNC acceptance.
4. **Norton Abrasives, When Purchasing Grinding Wheels… Check for the Seal** (2023-03-21), https://www.nortonabrasives.com/en-us/resources/expertise/when-purchasing-grinding-wheels-check-seal : original manufacturer describes wheel speed testing and certification seal limitations; an intact seal is not evidence of correct mounting or selected-machine overspeed protection.

## Findings and failure distinctions
| Claim | Evidence | Label | Boundary |
|---|---|---|---|
| Wheel marking and machine spindle speed must be checked at mounting | OSHA §1910.215(d)(1); Norton maintenance | DOC-CONFIRMED | No assumption that `S` command equals actual shaft RPM or wheel max RPM. |
| Guard design depends on machine/wheel type, and guard geometry can become wrong as wheel wears | OSHA §1910.215(a)/(b), specific illustrations | DOC-CONFIRMED | Do not apply bench-grinder tongue/work-rest numbers to unrelated CNC surface grinders without type determination. |
| RPM can increase as wheel diameter decreases under a *specific* surface-speed condition | Norton original citing ANSI B7.1-2017 | DOC-CONFIRMED manufacturer interpretation | Not permission to exceed wheel's marked RPM; verify both markings and selected OEM/wheel instructions. |
| Wheel may be damaged despite looking acceptable | OSHA §1910.215(d)(1) ring/inspection and exceptions for different bond types | DOC-CONFIRMED | Ring test is not universal for all bonded products and does not replace wheel-specific inspection. |
| A CNC/HAL/VFD output is a normal command, not an independent overspeed/guard proof | Architecture inference from ordinary-control boundary; prior LinuxCNC spindle source audit | INFERENCE for selected machine | Requires actual measured shaft speed and independent selected safety architecture, guard/burst containment evidence. |

**Physics discriminator (not a safety rating):** surface speed `v = π D n / 60` (D in metres, n in revolutions/minute, v in m/s). At fixed RPM, decreasing D decreases v. Maintaining a target surface speed as D decreases requires increasing RPM; that can violate a separate wheel's marked maximum RPM or machine capability. A software conversion can calculate a *command*, not prove actual shaft speed or physical wheel integrity.

## Adversarial failure paths
- Replacement wheel has a lower marked max RPM than prior wheel; retained CNC spindle override/recipe commands the old speed -> physical overspeed/burst hazard; program label/green HMI insufficient.
- Wheel wear reduces diameter; an automatic surface-speed compensation raises commanded RPM; missing wheel-specific maximum clamp or incorrect diameter may cause overspeed. Need selected hardware speed witness and independent fault response if risk assessment requires it.
- Encoder reports expected speed but is on wrong shaft, coupled through a failed gear or stale tag -> measured value not independent physical wheel speed.
- Guard adjusted for original wheel diameter is left with inappropriate exposure as wheel wears; guard replacement for setup creates bypass incentive. Mechanical containment is a separate protective layer.
- E-stop stops spindle drive but wheel coasts; “motor off” != physical standstill. Guard access/release must use actual selected safe-state evidence.

## Practical design and verification
Favor wheel-ID/marked-rating capture at changeover, physical guard designs that fit the task and are easy to reinstall, mechanical speed limits or independently justified monitored-speed protection where required, documented inspection and correct mounting tools, and safe standstill/access conditions. **No single normal LinuxCNC spindle `S`, `spindle.N.at-speed`, VFD display or command can be used as a personnel-safety witness.** Prior pinned LinuxCNC `spindle.N.at-speed` source audit establishes ordinary default/readiness semantics only, not selected grinder behavior: `research/4400_LINUXCNC_PINNED_SPINDLE_AT_SPEED_DEFAULT_TRUE_RAMPED_COMMAND_VS_SAFETY_MONITOR_SOURCE_TRACE_2026-10-25.md`.

## Limits
No actual grinding machine, wheel, guard, drive, feedback location or safety circuit selected; **wheel burst speed, max RPM, stopping distance, guard design, PL/SIL and diagnostic coverage UNKNOWN**. **SOURCE-CONFIRMED** no new LinuxCNC source; prior pinned source only. **DOC-CONFIRMED** OSHA and Norton exact sources. **TEST-CONFIRMED none**; **COMMUNITY-REPORTED none**. **INFERENCE** independent overspeed/standstill safety allocation. No experiment frozen: generic simulation cannot prove wheel strength, actual speed feedback, guard containment or safe access. No Actions or physical operation.
