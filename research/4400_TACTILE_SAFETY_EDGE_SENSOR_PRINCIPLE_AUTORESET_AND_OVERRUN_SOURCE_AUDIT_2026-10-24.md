# 4400 — Tactile safety edges: contact-before-stop, incompatible sensing principles and auto-reset traps

**Status:** OEM/public-standards source investigation; **NOT TEST-CONFIRMED**, no selected-machine implementation or physical validation. Scope: CNC sliding doors, moving gantries, feeders, robot/transfer cells and auxiliary closing edges. **Not** a claim that an edge is installed on OpenPressBrake. Related foundational work: 2590 safeguard selection, 25C0 restart and 4400 independent safety output/physical witness.

## Engineering question

Can a builder put any rubber safety edge on a moving CNC gantry, wire it to a LinuxCNC input, and declare crushing protection because the edge or its relay is advertised as PL d/e? Does automatic reset of an edge monitor mean it is safe to restart movement?

**Answer: no.** An edge detects **contact**, so residual travel/force after first contact is a central physical design constraint. Manufacturer systems use **different sensor physics and monitoring electronics**, and some OEM monitors offer an **automatic reset** mode that cannot itself guarantee a deliberate machine restart. The ISO 13856-2 public abstract expressly excludes judging a particular application’s suitability, target PL selection and effective sensing area geometry.

## Authoritative public sources and provenance limits

1. **ISO 13856-2:2013**, current Edition 2 (confirmed 2024), official ISO public abstract: https://www.iso.org/standard/57108.html . **DOC-CONFIRMED (public abstract only):** specifies design/testing principles for pressure-sensitive edges/bars, not selection/suitability, application-specific effective sensing area, machine-specific PL target, or E-stop. **Full normative text not inspected.**
2. **Schmersal, *Safety edges — SE40/SE70*, official product-family technical page**, accessed 2026-10-24: https://products.schmersal.com/en_US/safety-edges-1000074814 . **DOC-CONFIRMED:** Schmersal SE40/SE70 uses an **infrared transmitter/receiver inside a deformable rubber profile**, with downstream evaluation; manufacturer warns speed must be below the profile's maximum starting speed and profile-specific stopping distance must be coordinated. This is **not** a universal 8.2 kΩ resistive sensor.
3. **Schmersal SE-304 C evaluation unit, exact product 101165883**, official product page: https://products.schmersal.com/en_US/se-304-c-evaluation-unit-101165883 . **DOC-CONFIRMED (OEM catalogue):** monitors 1–4 matching SE40/70 optical edges, 1 safety contact + distinct signalling output, optional manual monitored `0-1-0` reset at X2/X3 (100 ms–2 s) **or** auto-reset via A3/X2, manufacturer max response 17 ms and `up to PL d / Cat 3` for the documented system. **Important provenance:** indexed manufacturer manual `DOC_MAN_MEC_mrl-se304c_SEN_AIN_V2.pdf` appeared in search, but direct retrieval redirected to catalogue home; the full original PDF **was not independently inspected**. Product page is the controlling accessible source; do not invent manual clauses.
4. **Mayser, *Safety edges* (manufacturer product-family page)**: https://www.mayser.com/en/safetytechnology/safety-edges . Manufacturer search-indexed description distinguishes **normally-open** short-on-actuation edges with monitored terminating resistor or four-wire monitoring, from **normally-closed** contact-chain edges. Direct page fetch failed in this session, so these claims are **DOC-CONFIRMED from indexed manufacturer text, limited access**, not a reviewed wiring diagram.
5. **ASO Safety Solutions, *SENTIR edge 8-8* official product page**, accessed 2026-10-24: https://asosafety.com/us/produkt/sentir-edge-8-8-3/ . **DOC-CONFIRMED (manufacturer catalogue):** integrated contact strip and matching evaluation electronics with terminating resistor for monitoring wiring faults; exact implementation must follow matching OEM control/evaluation. The manufacturer's broader CNC gantry marketing examples are not physical performance proof: https://asosafety.com/us/machine-system-automation/ .

No original sensor-profile test report, independent force/travel measurement, stop-time recording, exact PL/SIL calculation or selected application design was available.

## The sensing-physics trap

| Sensor family | OEM-confirmed principle | Incorrect shortcut | Required selected-system evidence |
|---|---|---|---|
| Schmersal SE40/70 | Rubber deformation attenuates **optical IR** transmitter/receiver; SE-304C-type matching evaluation | 'Every edge is an 8k2 switch; wire to an ordinary input' | Exact SE-P40/70, SE-SET revision, matching monitor, all edge segments and fail-detection |
| Mayser normally-open contact edge | Contact **closes/shorts** on actuation; monitor resistor or four-wire scheme may detect wire fault | 'NO means unsafe; put it on a PLC digital input and trust no fault' | Matching end-of-line/4-wire evaluator, contact location and cable-fault discrimination |
| Mayser normally-closed chain | Linked NC contacts **open** on actuation | 'It has the same diagnostic behavior as resistor-monitored NO' | Selected model/series, fault coverage and evaluator |
| ASO SENTIR edge | Integrated contact strip; selected evaluation with terminating resistor to monitor short/wire-break | 'One terminating resistor anywhere proves every segment' | Correct resistor location, series wiring, sensor/monitor combination, cable fault paths |

**DOC-CONFIRMED:** the manufacturer product families are not interchangeable by rubber appearance. **INFERENCE:** a mismatched resistor/optical/NC scheme can mask a fault or cause nuisance trips. **UNKNOWN:** actual fault coverage and detection time for any hypothetical mixed retrofit.

## The physical overtravel trap — tactile means first contact has already occurred

`person/object first touches edge -> edge deformation to switching threshold -> sensor/evaluator detects -> independent safety logic responds -> final element removes hazardous motion -> mechanism physically stops or reverses -> residual compression/force/reach must remain tolerable`.

The Schmersal OEM explicitly requires **profile-specific maximum starting speed** and **stopping distance** to be harmonized; ASO's CNC gantry example also discusses **overtravel and permissible forces**. These are **DOC-CONFIRMED qualitative design dependencies**, not a universal numeric threshold.

**INFERENCE:** a safety edge with too little available deformation/travel for the actual mechanism may allow crushing even if the sensor, monitor and controller all work exactly as specified. A contact edge cannot retroactively prevent the initial contact. It may be a suitable supplemental safeguard in a qualified application, but is not automatically suitable for a fast press-brake closing gap, exposed robot sweep or heavy gantry.

Do **not** calculate a safe force, compression distance, maximum speed, PL, stop time or stopping distance without selected geometry, mass, speed, stopping behavior, profile data, human-contact exposure and applicable standards. No hand/arm/person contact test is authorized.

## Reset and normal-control authority trap

Schmersal SE-304 C catalogue documents **two different** reset arrangements:

- Monitored manual reset: `X2/X3` `0-1-0` transition in a **100 ms–2 s product-specific window**.
- Auto-reset: `A3/X2` connection, with return of edge to normal potentially restoring the monitor's safety contact without a deliberate local operator action.

**DOC-CONFIRMED** these are device/controller interface modes, not machine-level safe-start policy. **INFERENCE:** if the normal LinuxCNC controller retains a prior move/start request, using monitor auto-reset without independent restart interlock can allow hazardous movement when the obstruction clears. Treat this as a hazard to analyze, **not** a claim that a specific product or selected machine actually auto-restarts.

A qualified safety system must independently own reset/rearm and stop. The LinuxCNC HMI may show **read-only** diagnostics and ordinary start commands but must not become the sole safety owner. A Schmersal SE-304 C *signalling* output is not its *safety contact*. The manufacturer's **17 ms monitor response** is not physical machine stopping time, and the catalogue `up to PL d` is not an achieved whole-machine rating.

## Adversarial failure-path review

| Failure / shortcut | What could go wrong | Classification and needed discriminator |
|---|---|---|
| Wrong rubber profile/evaluator pairing | No reliable actuation or fault detection | **INFERENCE**; verify exact OEM parts and compatibility |
| Edge protects only the center of a sliding door, leaving pinch corners exposed | Person can be trapped outside sensing area | **INFERENCE**; physical geometry/coverage `PHY-ACCESS` |
| Heavy gantry travels after edge compresses | Residual travel/force causes injury | **INFERENCE** from OEM travel requirement; physical `PHY-STOP/FORCE` UNKNOWN |
| Normal LinuxCNC motion command persists through edge release | Re-energization may resume motion without new intent | **INFERENCE**; qualified rearm/fresh-start test required |
| Technician bridges a failed edge because it nuisance trips in chips/oil | Personnel protection defeated | **INFERENCE** human factors; redesign maintenance/robust profile rather than bypass |
| Safety monitor fault LED clears | False confidence that a person is no longer exposed | **INFERENCE**; device state ≠ occupancy, final-element state or physical safe state |
| Replacing optical profile with 8k2 resistive sensor | Mismatched signal/evaluator | **DOC-CONFIRMED** different OEM physics; actual selected behavior **UNKNOWN** |

## Evidence status / no release

- **DOC-CONFIRMED:** ISO public scope; Schmersal optical sensing and SE-304C reset modes; Mayser indexed NO/NC distinction; ASO terminating-resistor scheme.
- **SOURCE-CONFIRMED:** none (not a LinuxCNC code trace).
- **TEST-CONFIRMED:** none.
- **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** incompatibility and unsafe machine restart/crushing scenarios.
- **UNKNOWN:** exact installed parts, mechanical contact geometry, response chain, stopping distance, residual force, safety PL/SIL, pressure/load holding, reset/restart behavior.

**Next:** for any selected safety edge collect exact profile/sensor/evaluator, sensing coverage, edge travel, full machine stop response and independent rearm/physical witness; store private as-built data outside this public repository. Until basic safe-to-operate protection is demonstrated, **no personnel-exposed hazardous operation**; any experimental operation must be isolated/remote with people outside the danger zone and residual risk documented. Do not use people as force/overtravel test objects.


## 2026-10-29 original Mayser worked-example arithmetic follow-up

The distinct [EDGE-CALC-01 manufacturer-indexed example audit](4400_EDGE_CALC_01_MAYSER_NCII_OVERTRAVEL_EXAMPLE_ARITHMETIC_AND_SYSTEM_RESPONSE_AUDIT_2026-10-29.md) found that the indexed Mayser SL NC II p.18/29 example prints `0.5 × 10 mm/s × 1.55 s = 6.55 mm`, whereas that expression equals **7.75 mm**; after its `C=1.2` factor, **9.30 mm**, not **7.86 mm**. The profile's stated 12.4-mm example travel still exceeds 9.30 mm, but the arithmetic margin shrinks. The complete 11-MB manufacturer PDF was not retrievable, so the mismatch is **arithmetic-confirmed for the indexed excerpt, immutable-page UNKNOWN**; not a manufacturer erratum or physical machine failure. Never mix Mayser sensor timing with Schmersal's 17-ms SE-304C evaluation-unit timing. The original qualitative contact/overtravel/independent-safety conclusions stand. No machine test or new scored competency.
