# 4400 — General hydraulic operating manual versus installed-machine safety evidence

**Status:** source-adjudication addendum, 2026-10-22. **New primary source recovered:** HAWE B 5488, *Assembly, commissioning and maintenance*, **10-2024 rev 3.1**, https://productfinder.hawe.com/downloads/B5488-en.pdf . This manual is referenced by HAWE NSV D 6368 p. 24. The prior separate B 6335 operating instructions remain unverified; do not conflate B 5488 with B 6335.

## Source hierarchy and edition gate

**DOC-CONFIRMED, B 5488 p. 4:** this is a *general* manual, applicable only alongside product-specific operating/assembly instructions; it does not replace the complete machine's operating instructions. Therefore even correct general HAWE instructions cannot establish selected SAKB/NSV installation, pressure topology, safety-function performance or machine release.

**DOC-CONFIRMED, B 5488 pp. 7–8:** the manufacturer warns about hydraulic injection from pressurized systems, requires control of accumulator/pressure hazards and separately recognizes crushing/falling loads. This reinforces that electrical stop, valve position, pressure relief and gravity restraint are different physical propositions. The generic warning does not supply a cylinder-specific restraint design.

**DOC-CONFIRMED, B 5488 p. 17:** for complex systems, the manufacturer says simultaneous observation of multiple pressures, electrical signals, routes, speeds and flow rates may be necessary, beyond ordinary single conventional instruments. This is direct manufacturer support for a *multi-witness* commissioning evidence plan. It does not establish which instruments, timebase or acceptance thresholds the selected machine needs.

**DOC-CONFIRMED, B 5488 p. 22:** HAWE says pressure valve/pilot settings should be checked and corrections recorded, and gauges/switches should be checked for operation. The instrument is itself an evidence dependency. A pressure trace without gauge identity, connection topology, calibration/function status and relevant operating state is not independent physical proof.

**DOC-CONFIRMED, B 5488 pp. 12, 15, 20:** this generic manual includes example maintenance/testing intervals and an electrical capacitor waiting instruction. These are **not universal press-brake safety proof-test intervals, machine isolation verification or safe-discharge times**. The selected product/manual edition, actual electrical topology, applicable standards, risk assessment and physical verification determine the machine's procedures and acceptance criteria.

## Practical machine witness map

| Claimed state | Needed evidence | What the general manual does NOT establish |
|---|---|---|
| `hydraulics stopped` | exact stop/control function, independent final element and physical response | zero pressure, zero motion, beam held |
| `all valves monitored` | installed part codes, each sensor target, configuration and coverage | that separate NSV or optional tool-clamp/crowning paths are monitored |
| `pressure low` | verified sensor, tap-to-volume topology, sample freshness, required pressure zone | that every trapped chamber/accumulator is depressurized |
| `safe for cylinder service` | lockable isolation, residual-energy control, physical restraint, personal protection, continued verification if required | that normal production E-stop or valve feedback is sufficient |
| `validated stop` | accepted SRS criterion, selected instrumentation and synchronized physical observations | any stopping time, distance, PL/SIL or safe-state limit for this machine |

## Adversarial review

A learner claims: “B 5488 recommends an inspection interval, so that is our machine's proof-test interval.” **Reject**. The general manual has a product/lifecycle scope; the installed safety function's diagnostic proof-test interval is an SRS/integrity/validation question with exact component and architecture dependencies. Preserve the manual's interval as a *documented manufacturer instruction where applicable*, but do not substitute it for a machine-level safety validation plan.

Another learner claims: “The gauge is calibrated, so its zero proves all pressure is gone.” **Reject**. Calibration improves instrument accuracy at the measured point, not hydraulic connectivity to all trapped volumes or independent evidence of gravity restraint. The physical-port topology remains a separate `DEP/PHY/VAL` obligation.

## Traceability additions

- `BND/UNK`: exact general and product-specific manual editions, selected-machine applicability.
- `DEP`: pressure-port topology, instrument supply/reference, calibration/health, pressure zone connectivity.
- `VAL/PT`: multi-witness synchronized commissioning plan with selected acceptance criteria; independent motion/restraint observation.
- `CHG`: sensor relocation, pressure-gauge replacement, changed valve suffix, hydraulic service alterations invalidate dependent evidence.
- `HF`: accessible, protected test points and readable pressure-zone labels, so proper verification is easier than bypassing guards.

**No physical test, no selected machine facts, no numerical safety limits.** The information-gain stop is installed-machine schematic, selected manual and instrument/physical witness evidence. Continue other safety modules until those are available.

**Explicit UNKNOWN ledger:** selected hydraulic diagram, installed sensor and gauge locations, electrical capacitor discharge path, actual pressure-zone reaccumulation, machine-specific maintenance interval and achieved safety-function integrity remain UNKNOWN. None is TEST-CONFIRMED by this source review.
