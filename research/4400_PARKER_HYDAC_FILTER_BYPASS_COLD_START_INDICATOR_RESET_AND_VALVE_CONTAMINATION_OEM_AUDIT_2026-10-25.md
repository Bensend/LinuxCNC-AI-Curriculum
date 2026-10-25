# 4400-FILT-01 — Original Parker/HYDAC filter bypass, cold-start indicator and safety-valve contamination audit
**2026-10-25 | ORIGINAL OEM RESEARCH | NON-GRADUATED | NO SELECTED-MACHINE TEST**

## New safety question
Does a green filter-condition switch or a filter installed upstream of hydraulic safety-related valves prove that those valves receive clean oil and remain capable of the required physical stop/hold? **No.** The inspected original manufacturers distinguish actual filter-element flow, bypass-to-downstream or bypass-to-tank routing, independent differential-pressure indicators, viscosity-dependent cold-start response, automatic reset and retained manual indications. This is a **new filtration/diagnostic common-cause** branch, not the earlier hose-fuse flow-window lesson.

## Original documents inspected
- **Parker Hannifin Hydraulic Filter Division Europe**, [*Handbook of Hydraulic Filtration*, FDHB289UK](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Filter-Division-Europe/fdhb289uk.pdf), PDF pp. 26–29, especially printed pp. 25–28: bypass valve, filter condition indicator, filter sizing and bypass contamination. Direct original 40-page PDF text inspected.
- **HYDAC Technology Corporation**, [*Filters: Hydraulic & Lube Oil, Overview of Products*, PN#2211480 / 04.22](https://betterfit-us.hydac.com/wp-content/uploads/Filters-Overview.pdf), PDF pp. 30–31, printed section C3: auto/manual reset, cold-start thermal lockout, contact wiring and manufacturer-specific interchangeability. Direct original 60-page PDF text inspected.
- **HYDAC** [VD high-pressure BM manual-reset part 303165](https://catalog.hydac.com/item/clogging-indicators-differential/vd--high-pressure-type-bm--visual-manual-reset/303165), original manufacturer catalog, *Clogging Indicator Settings* and *Additional Information*. Exact product-specific settings, not transferable thresholds.
- **Parker**, [CF/RF filter service instructions](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Filter/Hydraulic-Filter---PDF-files/CF-RF_Filter_ser-main-instr.pdf), original 12-page PDF, indexed *Table 2 Troubleshooting Chart* reports cold oil/dirty element as separate causes of bypass indication and contamination/backpressure as causes of a jammed directional valve. PDF text extraction returned zero lines; claim is **indexed-only DOC-CONFIRMED**, not directly page-verified.

## Manufacturer-confirmed distinctions
| Proposition | Original OEM evidence | Evidence status and limit |
|---|---|---|
| A bypass valve may open before a heavily contaminated filter element collapses, allowing flow around it | Parker FDHB289UK PDF p. 27 | DOC-CONFIRMED; not a selected filter state |
| A bypass-to-tank arrangement differs from bypassing unfiltered oil downstream; a no-bypass design needs a suitable high-collapse element and engineering sizing | Parker PDF p. 27 | DOC-CONFIRMED; not a recommendation to plug/remove bypass |
| A filter indicator may be mechanically linked to the bypass valve **or** be an independent differential-pressure sensor | Parker PDF p. 28 | DOC-CONFIRMED; indicator state is not a direct universal witness of bypass position |
| Peak flow, cylinder return-flow multiplication, oil viscosity and cold temperature can change differential pressure and bypass exposure | Parker PDF pp. 28–29 | DOC-CONFIRMED; no selected flow, viscosity or threshold measured |
| HYDAC electric switches automatically return when ΔP falls below trip, while visual BM manual-reset retains a history indication | HYDAC PDF p. 31 | DOC-CONFIRMED exact indicator family; a cleared alarm is not proof element replacement |
| Optional thermal lockout suppresses cold viscous-oil false-clog indication by a series temperature switch | HYDAC PDF p. 31 | DOC-CONFIRMED; while lockout is active, absent alarm does not establish a clean filter |
| HYDAC indicator contact NO/NC behavior depends on site wiring; OEM warns against mixing indicator and filter makes | HYDAC PDF p. 31 | DOC-CONFIRMED; exact installed suffix/wiring required |
| HYDAC catalog typically positions warning before bypass cracking and advises timely element change | HYDAC part 303165 original product page | DOC-CONFIRMED for that family; not an installed-machine setting or guaranteed remaining time |
| Contamination may jam a directional valve | Parker CF/RF service chart, indexed text | DOC-CONFIRMED indexed-only; precise valve, probability and physical failure direction UNKNOWN |

## Causal safety boundary
**INFERENCE:** filter bypass or service neglect may be a common-cause contributor to multiple downstream hydraulic valve faults. This is **not** proof that a particular press-brake holding valve will stick open, nor a calculated diagnostic coverage or failure probability. Ordinary LinuxCNC oil-temperature/filter HMI alarms are maintenance diagnostics unless a separately qualified safety function, sensor path, diagnostic coverage and physical final element are established.

**Adversarial examples:** (1) auto-reset switch returns green after the pump stops; dirty element may remain. (2) cold-start thermal lockout suppresses a nuisance alarm but also prevents the switch from indicating clogging during that temperature interval. (3) normal high-flow return transient briefly bypasses the element; a low average pump flow does not rule this out. (4) a filter indicator is independent of the bypass valve; it does not prove bypass closure. (5) a no-bypass modification without verified element collapse rating can introduce a different hazard.

## Scope and unresolved evidence
**DOC-CONFIRMED** original Parker/HYDAC product-specific statements above; **SOURCE-CONFIRMED** no new LinuxCNC source; **TEST-CONFIRMED** none; **COMMUNITY-REPORTED** none; **INFERENCE** downstream common-cause and maintenance design; **UNKNOWN** actual OpenPressBrake filtration, bypass routing, cold-start lockout, indicator wiring, fluid cleanliness, valve reliability, independent Y1/Y2 stop/hold, PL/SIL and external score. Do not copy OEM example pressure values or service intervals into selected-machine acceptance.

**Information-gain stop:** obtain restricted as-built filter housing/element/bypass part/suffix, indicator type and wiring, flow/temperature envelope, OEM maintenance criteria, fluid cleanliness samples, physical safety-valve design and qualified evidence. No energized filter bypass, deliberate contamination, forced pressure/temperature fault or personnel exposure as curriculum exercise.
