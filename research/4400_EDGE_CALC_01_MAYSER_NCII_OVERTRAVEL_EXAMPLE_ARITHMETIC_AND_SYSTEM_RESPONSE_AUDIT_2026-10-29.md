# 4400-EDGE-CALC-01 — A safety-edge catalogue example is not an independently checked stopping/overtravel calculation

> **2026-10-29 18:40Z source-status upgrade:** [EDGE-CALC-02 original 2025 manufacturer PDF audit](4400_EDGE_CALC_02_MAYSER_2025_ORIGINAL_PAGE_ARITHMETIC_ACTIVE_LENGTH_INSTALLATION_LIMITS_AUDIT_2026-10-29.md) directly opened Mayser **080925 v2.13-RiA**, printed p.17/28 and visually confirmed the same `6.55`/`7.86` mismatch. The *older 050320 v2.11-RiA catalogue* below remains **indexed-only**; its retrieval limits are historical, not the current limit for the 2025 edition. The 2025 source also establishes non-sensitive ends, effective angle, installation exclusions and inspection obligations. No PDF byte hash or manufacturer erratum; no physical machine verdict.

**2026-10-29 | Original arithmetic/provenance audit | NON-GRADUATED | PAPER ONLY | NO MACHINE RELEASE**

## Why this is a distinct follow-on

The existing [4400 tactile-edge source audit](4400_TACTILE_SAFETY_EDGE_SENSOR_PRINCIPLE_AUTORESET_AND_OVERRUN_SOURCE_AUDIT_2026-10-24.md) already establishes sensor-family incompatibility, contact-before-stop, overtravel/force and auto-reset. **Do not repeat or replace it.** This follow-on checks an **exact numerical discrepancy in a manufacturer worked example** and exposes a second, subtler design error: silently substituting a safety-edge monitor's response time for a different sensor/profile's response time. A novelty scan of the full learner index, course research, curriculum and progress found the predecessor but no recorded audit of the particular Mayser arithmetic.

## Frozen question and source provenance

**Question:** Does the printed Mayser SL NC II selection example's arithmetic match its stated equation and inputs, and can a builder treat that worked example as a machine acceptance calculation?

Sources consulted 2026-10-29:

1. **Mayser GmbH & Co. KG**, manufacturer-hosted PDF `Mayser-Gesamtkatalog_EN.pdf`, manufacturer URL https://www.mayser.com/media/687/download/Mayser-Gesamtkatalog_EN.pdf ; **search-indexed text excerpt** of subsection *Normally closed safety edges SL NC II*, printed footer **050320 v2.11-RiA**, **p.18/29** of that subsection. The indexed passage includes the complete relevant example: `v=10 mm/s`, `t1=1300 ms`, `t2=250 ms`, `s1=1/2 × v × (t1+t2)`, printed `s1=6.55 mm`, `C=1.2`, printed `s=7.86 mm`, and cited selected-profile overtravel **12.4 mm**. **Important access limit:** web PDF opening returned content-too-large (11,066,156 bytes); independent container download failed (network unavailable). No full original PDF, byte hash, or page image was inspected. These numbers are **DOC-CONFIRMED as an indexed manufacturer-hosted excerpt only**, not immutable full-manual proof. Do not claim a manufacturer erratum or a verified edition-wide defect.
2. **Mayser manufacturer product-family page** https://www.mayser.us/en-us/safety-technology/sensors-controllers/safety-edges ; indexed OEM text says normally-open profiles may use a monitored resistor or continuous four-wire system. Direct opening failed (503); no substitution/compatibility inference from this indexed family text.
3. **Schmersal**, exact **SE-304 C**, item **101165883**, https://products.schmersal.com/en_US/se-304-c-evaluation-unit-101165883 ; direct original manufacturer product page, generated **2026-10-21**. It publishes **17 ms maximum evaluation-unit reaction time**, one safety contact distinct from a signalling output, optional auto-reset or monitored manual reset, and an *up to* PL d/Cat 3 claim. **This is a different matched sensor/monitor family, not a timing specification for Mayser SL NC II.** The full Schmersal original manual was not inspected here.
4. **ISO**, `ISO 13856-2:2013`, Edition 2 (2013-04; confirmed 2024), https://www.iso.org/standard/57108.html ; **public catalog abstract only**. Scope covers design/testing of pressure-sensitive edges/bars, **not** selecting a suitable profile, application-specific effective sensing geometry or machine target PL. No full normative clauses inspected.
5. **OSHA**, 29 CFR 1910.212(a)(1)–(3), https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212 ; directly inspected general point-of-operation safeguarding requirement. It does not approve a particular edge or give this machine's stopping distance.

## Independent arithmetic check — a genuine discrepancy in the retrieved excerpt

Recompute the **printed equation using only the printed example inputs**, not invented machine parameters:

| Quantity | Printed/indexed Mayser example | Independently recomputed from its stated equation |
|---|---:|---:|
| Total time `T=t1+t2` | `1300 ms + 250 ms = 1.55 s` | **1.55 s** |
| `s1 = 0.5 × v × T` | **6.55 mm** | `0.5 × 10 mm/s × 1.55 s = 7.75 mm` |
| `s = C × s1`, `C=1.2` | **7.86 mm** | `1.2 × 7.75 mm = 9.30 mm` |
| Selected profile overtravel stated in example | **12.4 mm** | **12.4 mm** (excerpt only) |
| Arithmetic margin `12.4 - s` | **4.54 mm** | **3.10 mm** |

**INDEPENDENT ARITHMETIC-CONFIRMED (not TEST-CONFIRMED physical behavior):** the indexed worked example's `6.55 mm` does **not** follow from its own `0.5 × 10 × 1.55` expression. The following `7.86 mm` is internally consistent with **6.55 × 1.2**, but inherits the earlier mismatch. The corrected arithmetic increases the example's computed minimum by **1.44 mm** and reduces the *arithmetic* margin by the same amount. **Under the excerpt's own simplified method and its 12.4-mm figure, the example's selection conclusion remains unchanged**; this does not validate the actual application.

**UNKNOWN:** whether the immutable source PDF really prints all the excerpted numbers exactly, whether a corrected catalogue revision exists, and whether the OEM intended a different input or rounding convention. Do not silently edit the OEM source, infer a firmware/product change, or label the discrepancy a physical safety failure. Preserve the exact excerpt URL/footer and request a stable original page before treating it as an OEM correction.

## A more important systems-level trap: even a correctly multiplied catalogue formula is not physical proof

A pressure-sensitive edge detects **after contact**. The complete sequence is:

`contact -> deformation to actuation threshold -> sensor electrical/optical transition -> matched evaluator -> independent safety controller -> physical final element -> deceleration/stop -> residual compression and force -> independent reset/fresh start`.

The Mayser example's `t1=1300 ms` is the **profile/example response term**, while Schmersal's `17 ms` is the **different manufacturer's SE-304C monitor reaction time**. Combining them, or substituting a generic LinuxCNC servo tick, produces a calculation that is not supported by either selected system. **DOC-CONFIRMED** each cited number's product context; **INFERENCE** that mixing them can understate total response. A product's rated monitor response is not the complete machine stopping time.

The manufacturer example uses `s1 = 0.5 × v × (t1+t2)`. The `0.5` factor is **not** a universal physical identity for arbitrary delay and braking histories. For example, if velocity remains `v` during a detection delay and only then decelerates uniformly to zero over `t2`, a *different assumed model* would yield `s = v × t1 + 0.5 × v × t2` before any margin. That is a **counterexample about model assumptions, not an alternative acceptance calculation for a machine**. Without the exact OEM definitions, profile force–deformation curves, machine velocity/stop trace and permitted contact force, neither model authorizes use. The actual stop trajectory can be nonuniform, and force/deformation limits matter separately from travel.

**Do not** derive a universal safe speed, pressure, compression, PL, stopping distance, force limit or acceptance verdict from this paper example. Do not use a human hand/body as a contact test object. The selected-machine SRS and independent qualified witness must establish actual geometry, full response, final elements, stopping/holding and residual force.

## Failure-path / adversarial review

| Shortcut or fault | Consequence | Evidence and discriminator |
|---|---|---|
| Copy printed `7.86 mm` into a retrofit worksheet | Margin overstated relative to stated equation | **Arithmetic-confirmed** discrepancy in **indexed excerpt**; recheck immutable OEM page and recalculate |
| Replace Mayser's `1300 ms` with Schmersal's `17 ms` | Understates delay by mixing unmatched products | **DOC-CONFIRMED** distinct component contexts; actual matched system **UNKNOWN** |
| Treat `12.4 > 9.3` as a safe-machine verdict | Ignores effective contact coverage, force, actual stopping, faults and restart | **INFERENCE** from ISO scope/OEM architecture; qualified physical evidence required |
| Edge deforms but hazardous axis coasts | Personnel injury despite healthy monitor | **INFERENCE**; stop/force measured under qualified isolated protocol, not with a person |
| Edge clears and monitor auto-resets while old CNC command persists | Unexpected restart possible | **INFERENCE**; independent reset/command-clear/fresh-start validation required |
| Use edge monitor signalling output as final safety output | Incorrect safety-channel allocation | **DOC-CONFIRMED** Schmersal outputs differ; actual wiring **UNKNOWN** |
| OEM catalogue changes or web excerpt is inaccurate | Arithmetic criticism may not apply to actual edition | **UNKNOWN**; stable PDF/page/hash or OEM clarification needed |

## Practical minimum design/validation gate

1. **Paper first:** exact machine hazard, movement direction and crush points, selected profile/part suffix, matching sensor monitor, controller/final-element chain, OEM edition and maintenance conditions.
2. **Separate the numbers:** sensing deformation/response, evaluator response, safety-logic reaction, physical stopping/holding and allowed compression/force. Recompute every arithmetic step with units and independently review the assumed deceleration model.
3. **No false PL transfer:** product `up to PL d` and ISO scope do not establish whole-machine PL, safe stop or occupancy clearance.
4. **Human factors:** mount the edge where it can be inspected and cleaned, keep its mounting/cabling robust, make replacement simple, show distinct *sensor fault / safety demand / physical-stop not proven* states; nuisance trips call for redesign, never bypass.
5. **Release hold:** absent selected machine and qualified physical proof, no personnel-exposed hazardous operation. Any justified experiment must be separately approved, isolated/remote, with people outside the danger zone and residual risk stated.

## Evidence ledger / handoff

- **SOURCE-CONFIRMED:** none from LinuxCNC; this is OEM/standards engineering and independent arithmetic.
- **DOC-CONFIRMED:** narrow Mayser **indexed** excerpt only; direct Schmersal product page; ISO **abstract** only; OSHA regulation. Provenance restrictions above are mandatory.
- **TEST-CONFIRMED:** **none** (no runtime, force or machine test).
- **COMMUNITY-REPORTED:** none used.
- **INFERENCE:** model-mixing and bypass/crush/restart failure scenarios.
- **UNKNOWN:** original Mayser PDF byte-verified numbers, OEM clarification, actual machine parameters, installed edge/monitor, physical stop/hold, target PL, qualified acceptance.
- **Evaluation:** independent 2520–25F0 remains OPEN; this is an unscored source-and-arithmetic correction, not new competency graduation.
- **Compute:** no GitHub-hosted or self-hosted workflows or lab minutes. This was document/source inspection and hand arithmetic only.
- **OpenPressBrake:** **no assertion that an edge is installed**; Stage A A–G absent, **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD**.

**Next exact evidence discriminator:** obtain the complete immutable Mayser SL NC II section p.18/29 and verify `1.55`, `6.55`, `7.86` and the edition footer; if mismatch persists, seek OEM clarification. Independently qualified machine-specific physical proof and external evaluator remain separate prerequisites.