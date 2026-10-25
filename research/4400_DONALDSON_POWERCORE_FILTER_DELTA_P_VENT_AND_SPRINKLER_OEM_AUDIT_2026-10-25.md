# 4400-DUST-03 — Collector filter differential pressure, vent discharge and sprinkler structural load
**2026-10-25 | Direct original Donaldson OEM IOM Rev 6 + HSE LEV commissioning | NON-GRADUATED**

## Sources and exact scope
- **Donaldson Torit PowerCore CPC-3 through CPC-48, IOM AD3878001 (ENG), Revision 6, 40-page original manual**, https://www.donaldson.com/content/dam/donaldson/dust-fume-mist/literature/north-america/equipment/dust-collectors/powercore/cp-series/iom-ad3878001/PowerCore-CPC-ENG-IOM.pdf . Inspected original PDF, including printed p.30 and troubleshooting printed pp.31–32, 2026-10-25.
- **Donaldson, What Is Differential Pressure?**, https://www.donaldson.com/en/resources/technical-articles/what-is-differential-pressure/ (manufacturer explanation, accessed 2026-10-25).
- **UK HSE, Commission your LEV system**, https://www.hse.gov.uk/lev/commissioning.htm and **LEV FAQs**, https://www.hse.gov.uk/lev/faqs.htm (official UK guidance, accessed 2026-10-25). UK COSHH examination interval is **not** transplanted into US regulatory obligation.

## Exact OEM findings (DOC-CONFIRMED for stated model/manual)
1. Printed p.30: explosion vent discharge must be directed outdoors away from occupied areas; standard vent is for outdoor installation, and the OEM's vent calculation assumptions exclude duct/obstruction unless specifically addressed. **Venting does not mean safe discharge into a walkway.**
2. Printed p.30: activating a sprinkler can accumulate water inside the collector, and excess water weight can cause **support-leg collapse** unless drainage and structure are addressed. A fire-protection add-on can introduce a new mechanical hazard.
3. Printed pp.31–32: fan can run with insufficient airflow from reverse rotation, unsealed access/hopper, restricted exhaust, dirty filters, pulse-cleaning failure or overfilled storage. `FAN RUNNING` is not `CAPTURE EFFECTIVE`.
4. Printed p.32: before work on pulse valves, OEM calls for electrical lockout and compressed-air bleed. A CNC M9 command does not isolate the collector's electrical/pneumatic energy.
5. OEM article: filter differential pressure is resistance across the filter. Sudden drop may indicate leak/rupture; rise may indicate clogging/cleaning failure. Differential pressure must be interpreted with system design, airflow, fan capacity and filter state; **no single universal Delta-P value establishes capture at a remote hood**.
6. HSE commissioning guidance: document each hood's actual performance, conditions, qualitative/quantitative tests, benchmark flow/pressure, system balancing, and competent examiner. HSE explicitly distinguishes operator indication from an adequate initial commissioning proof.

## Adversarial physical paths (INFERENCE, not selected-machine truth)
- Green filter Delta-P but a local blast gate is shut: collector gauge alone cannot prove the router hood captures dust.
- Low Delta-P after filter rupture: an indicator interpreted as "low restriction = good" could mask emissions.
- High Delta-P with adequate fan capacity: do not assert exposure failure without selected hood proof; OEM notes system behavior is application-dependent.
- Collector explosion vent is outdoors but points toward a service walkway: hazard boundary remains unsafe even with vent installed.
- Sprinkler discharges while hopper/collector drainage is obstructed: water load may threaten structural support, a distinct post-fire hazard.
- Collector pulse-valve maintenance after M9: electrical and compressed-air stored energy remain.

## Source-strength and limitations
**DOC-CONFIRMED** specific Donaldson CPC Rev6 warnings, Donaldson manufacturer Delta-P explanation, HSE UK commissioning/indication guidance. **SOURCE-CONFIRMED** no new LinuxCNC path (DUST-01/02 preserve pinned Task trace). **TEST-CONFIRMED** none; **INFERENCE** transfer scenarios; **UNKNOWN** any installed Donaldson device, collector vent, sprinkler, exact dust, site/AHJ, capture, structural load, actual air pressure and machine stop. Do not extrapolate model-specific vent/structural conditions to every collector or invent vent dimensions, filter alarm thresholds, fire response or proof intervals.

## Practical human factors
Give operators a clear **hood-level adequate/inadequate indication** linked to a qualified commissioning baseline, not a reassuring fan-running light. Put filter/duct maintenance and lockable isolation where technicians can use them; make a blocked duct or fire alarm actionable without reaching into running machinery. A nuisance-prone or inaccessible control will be bypassed; correct the installation.

## Decision
No compute/lab: original OEM and HSE evidence resolves the qualitative false-proxy problem; selected capture/vent/drainage/stop require qualified physical and facility verification. No hosted/local Actions or people-exposed tests.
