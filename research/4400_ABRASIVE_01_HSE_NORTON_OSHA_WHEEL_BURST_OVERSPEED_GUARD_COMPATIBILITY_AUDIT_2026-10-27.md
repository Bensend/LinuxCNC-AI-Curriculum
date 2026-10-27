# 4400-ABRASIVE-01 — Grinding-wheel burst, rated speed, mounting and fragment containment

**Date:** 2026-10-27 UTC. **Status:** NON-GRADUATED original documentary audit. **Applicability:** conditional to actual bonded abrasive wheel grinding/cutoff machinery; not a universal rule for milling cutters, saw blades, coated abrasives or press brakes. OpenPressBrake abrasive-wheel installation UNKNOWN.

## Novelty and prior-lesson comparison

Directly examined the canonical 978-line safety index before research: no `grinding wheel`, `wheel burst`, `abrasive wheel`, `wheel guard` or `spindle overspeed` module. Existing `TOOL` retention, `PANEL` energy, `DUST` explosion, `GUARD` access and 3700 specialized evidence remain distinct. This is a **new physical failure mechanism** in 4400 safety, not reopening the graduated 3700 machine specialization.

## Original sources and evidence

| Source | Directness / dated scope | Supported fact | Limitation |
|---|---|---|---|
| UK HSE HSG17 *Safety in the use of abrasive wheels*, third edition **2000**, 53-page original PDF **directly read** (printed pp. 9, 14, 29–31): https://www.hse.gov.uk/pubns/priced/hsg17.pdf | **DOC-CONFIRMED direct** | Wheel burst remains a hazard despite manufacturer precautions; storage, mounting, balance, speed, machine defects and improper use contribute. Guards serve **fragment containment** and **contact protection**, and inadequate fasteners can allow a guard to detach during a burst. A splash screen is not automatically a burst guard. | UK guidance, not US legal text; historic examples/dimensions must not be transferred to an arbitrary machine or wheel. |
| Norton Abrasives *Proper Mounting of a Grinding Wheel*, **2023-01-31**, original OEM **directly read**: https://www.nortonabrasives.com/en-us/resources/expertise/proper-mounting-grinding-wheel | **DOC-CONFIRMED direct** | Check wheel marking vs machine speed, condition, arbor/flanges/blotters/guards, prevent overtightening; manufacturer describes protected one-minute startup after mounting and keeping people out of wheel plane. | Exact procedure depends on selected wheel/machine; not permission for unguarded startup. |
| Norton *Grinding Machine Maintenance*, **2023-06-21**, **directly read**: https://www.nortonabrasives.com/en-us/resources/expertise/grinding-machine-maintenance | **DOC-CONFIRMED direct** | Wheel speed and machine free-running speed need competent checks; a speed command or motor nameplate alone does not establish actual spindle speed. Norton references ANSI B7.1-2017 speed-check provisions. | ANSI normative clauses are cited by manufacturer; full licensed standard NOT inspected here. |
| Norton *What You Should Know About Grinding Wheel Guards*, **2023-03-16**, **directly read**: https://www.nortonabrasives.com/en-us/resources/expertise/what-you-should-know-about-grinding-wheel-guards | **DOC-CONFIRMED direct** | Type 27/28 guards are not interchangeable with cup-wheel or cutoff-wheel guards; wrong geometry, damaged guard, missing fasteners and guard removal defeat fragment protection. | Exact model and guard compatibility require selected product instructions. |
| US 29 CFR **1910.215** *Abrasive wheel machinery*, **directly read eCFR** current through **2026-10-23** (title 29 last amended 2026-10-14): https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XVII/part-1910/subpart-O/section-1910.215 . The OSHA-hosted page separately returned 403. | **DOC-CONFIRMED direct eCFR** | Different machine/wheel types have different guard exposure, flange and mounting provisions; §1910.215(d)(1) describes pre-mount inspection/ring testing and spindle speed vs wheel maximum. Offhand work-rest 1/8-inch and certain tongue-guard 1/4-inch rules have **specific scope**, not universal CNC wheel clearance. | Direct §1910.215(a)(4) limits the 1/8-inch rest to **offhand** grinding; §(b)(9) limits the 1/4-inch tongue to specified guard types. §(d)(1)(i) expressly warns organic-bond wheels do not ring like vitrified/silicate wheels. §(b)(12) references ANSI B7.1-1970 by incorporation; the later Norton-cited ANSI B7.1-2017 is a different edition. Do not apply one guard angle, rest gap or flange fraction to every wheel type. Applicability depends on machine and operation. |
| Norton *Cut-Off Wheels and Die Grinders — A Dangerous Combination*, **2023-02-08**, OEM indexed/direct available: https://www.nortonabrasives.com/en-us/resources/expertise/cut-wheels-and-die-grinders-dangerous-combination | **DOC-CONFIRMED OEM** | A die grinder lacking proper guard/flanges is not a cut-off tool merely because a disc can be mechanically attached. | Not a general approval of any alternative machine or adapter. |

## Failure mechanism and safety-authority boundaries

**Physical chain (INFERENCE transfer from direct OEM/HSE facts):**
`wheel type/condition + actual rotational speed + mounting/flange load + dynamic imbalance/contact load` → possible fracture → fragments at high energy → containment by **correct, intact, properly fastened guard** and protected operator zone. An HMI speed setpoint, spindle encoder, drive ready bit, software E-stop or CNC stop command cannot retrospectively contain a burst. An operator may be injured **before** any controller detects a fault.

- **Normal control:** LinuxCNC/FPGA/drive can command spindle speed, report feedback and stop a cycle. This is not automatically a safety-rated speed limitation or a physical fragment barrier.
- **Independent safety-related functions:** if risk assessment requires them, actual overspeed prevention/detection, guarded access, standstill/restart and safe isolation must be allocated to qualified equipment and validated as a complete function. No PL/SIL is assigned here.
- **Physical protection:** exact wheel type/marking, manufacturer-compatible spindle, flange, blotter, guard shape/strength/fasteners and operator position are indispensable.
- **Maintenance:** isolation before wheel change, competent speed verification, inspection, correct mounting and guard restoration; do not defeat guards because they interfere with access. A wheel that cannot be used with the correct guard needs a different machine/tool/process.
- **Separate residual hazards:** sparks, grinding dust (including combustible metals), noise, coolant and ejected workpieces require their own controls; `DUST-01` addresses dust explosion but cannot substitute for wheel burst containment.

## False-equivalence adversarial matrix

| Misleading evidence | What it really proves | Missing physical proof |
|---|---|---|
| `S1000` command and VFD frequency correct | Normal software/drive command path only | Actual free-running spindle speed and exact wheel speed rating; qualified speed control |
| Wheel fits arbor with a washer | Mechanical assembly occurred | Wheel type/size, correct flanges, fit, blotters, guard compatibility |
| Enclosure catches coolant splash | Splash containment | Fragment-impact containment strength and fastener retention |
| Guard closed switch green | Guard-position signal | Correct guard type, strength, attachment and fragment trajectory |
| E-stop stops spindle after 2 s | A stop behavior, if actually measured | Prevention of initial burst; safe standstill/access and no exposed fragment path |
| Wheel ring test sounds normal | A limited inspection observation | Other damage, correct bond/type, speed, mounting and guard; ring behavior differs by wheel type |
| Wheel has worn to smaller diameter | Geometry changed | Correct rated speed/operating limits and controlled adjustment, not arbitrary speed increase |
| Old guard removed for new tool | Tool change is easier | Actual containment; change requires safe redesign, not bypass |

## Qualified selected-machine evidence needed

1. Exact machine/spindle/wheel manufacturer, type, bond, dimensions, marked maximum speed, storage and service history.
2. Actual free-running spindle speed range and independently justified verification method **with hazardous wheel removed** where OEM directs; no arbitrary test run.
3. Correct guard type, geometry, material, attachment/fasteners, wear/condition and accessible correct installation.
4. Exact wheel mounting/flange/blotter/arbor procedure, compatible parts and inspection method by wheel type.
5. Hazard-zone occupancy, fragment trajectories, enclosure/door integrity, protective access and standstill/restart allocation.
6. Competent maintenance, guard-reinstallation usability, incident response, change-control and independent physical validation.

**No-lab decision:** The general wheel-burst and guard principles are settled by direct HSE/OEM documents. Any unresolved spindle speed/guard strength/fragment risk is **machine-specific**; neither simulation on a panel PC nor unguarded test runs can prove safe operation. No wheel-spin, overspeed, burst or deliberate guard-defeat experiment is authorized. If a basic fragment-containment/speed-compatibility threshold is unmet, **do not operate with people exposed**; remote experimental operation still requires a qualified isolated zone and residual fragment/fire risk controls.

**Evidence:** direct DOC-CONFIRMED as above; regulatory directly read eCFR; cross-machine INFERENCE; selected machine UNKNOWN; TEST-CONFIRMED none; COMMUNITY-REPORTED none; independent evaluator NOT RUN. **G0/G1 remains HOLD for OpenPressBrake.**
