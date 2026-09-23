# 2550 — Example architectures and assumption traps

## Purpose

Make ISO 13849 reasoning concrete without inventing a machine PL, PLr, stopping time, diagnostic coverage, or component lifetime. These are teaching cases, not certification calculations.

Evidence labels used below: `DOC-CONFIRMED`, `INFERENCE`, `ILLUSTRATIVE`, `UNKNOWN`.

## Authoritative anchors

`DOC-CONFIRMED`: DGUV/IFA describes SISTEMA as modelling SRP/CS using designated architectures and evaluating reliability including achieved PL. Its entered factors include PLr risk parameters, Category, CCF measures, MTTFd and DCavg.

- https://www.dguv.de/ifa/praxishilfen/praxishilfen-maschinenschutz/software-sistema/index.jsp

`DOC-CONFIRMED`: current manufacturer standards guidance identifies Category, MTTFd, DC and CCF as separate inputs for a self-designed subsystem rather than interchangeable names for one quantity.

- https://www.pilz.com/ko-KR/support/law-standards-norms/functional-safety/en-iso-13849-1

`DOC-CONFIRMED`: Pilz gives the electromechanical relationship `MTTFd = B10d / (0.1 * nop)` and `nop = (dop * hop * 3600) / tcycle`, with operating days, operating hours and mean cycle interval as application assumptions.

- https://www.pilz.com/download/open/TechBo_Pilz_safety_compendium_1004669-EN-02.pdf

`DOC-CONFIRMED`: a Schmersal worked machine-safety example applies the same B10d/nop relationship and shows that a channel can contain components with very different reliability and diagnostic data. It combines component contributions rather than assigning a channel result from topology alone.

- https://products.schmersal.com/upload/orig/10/00/20/06/DOC_MAN_INS_installationshandbuch-psc1-c-10_SEN_AIN_V5.pdf

## Case A — same architecture, reliability changes

Two implementations have the same functional block structure:

`guard sensor -> safety logic -> final element`

Hold Category, diagnostic concept and CCF measures fixed. Change only the defensible dangerous-failure reliability of one channel component from `R_good` to `R_poor`, where both symbols stand for properly sourced values applicable to the real duty.

Expected learner conclusion:

- the drawing can remain identical while MTTFd evidence changes;
- Category therefore cannot by itself determine achieved PL;
- a certified-looking topology cannot repair missing or inapplicable reliability data.

No PL letter is assigned because the numerical method inputs are intentionally absent.

## Case B — same reliability, diagnostic effectiveness changes

Use the same two-channel structure and the same component reliability evidence twice.

- B1: diagnostics are documented to detect the relevant dangerous failure modes with defensible coverage evidence.
- B2: an ordinary auxiliary/status signal is merely *assumed* to detect those faults.

Hold the nominal architecture and reliability evidence fixed.

Expected learner conclusion:

- DC/DCavg is a distinct evidence dimension;
- a status bit is not diagnostic coverage merely because software can read it;
- even legitimate diagnostic coverage does not prove the physical safe state after a demand.

**Freeze:** DIAGNOSTIC OBSERVABILITY != PHYSICAL SAFE-STATE PROOF.

## Case C — nominal redundancy defeated by a common final element

Architecture shown to the learner:

`Sensor channel A -> Logic channel A --+`

`                                  +--> one ordinary final element -> hazard`

`Sensor channel B -> Logic channel B --+`

The sensor and logic paths are nominally redundant. Both ultimately depend on one final element whose dangerous failure can defeat the demanded safety action. No independent second final element or other justified means of tolerating/detecting that dangerous final-element failure is supplied.

`INFERENCE`: adding upstream channels cannot make the downstream single point disappear. The learner must model the *real safety function*, not count parallel lines on the left side of a schematic.

Expected learner response:

1. identify the common final element as a dominating dependency;
2. refuse to claim that upstream two-channel appearance proves a high Category/PL;
3. state what evidence or architectural change would be needed before a stronger claim could be evaluated.

## Case D — two channels, one common-cause mechanism

Architecture:

- two input channels;
- two logic paths;
- two nominal output channels;
- both channels share an unanalyzed environmental/power/routing dependency capable of defeating both together.

Examples of dependency classes to investigate rather than automatically assume: shared power fault, common connector damage, common routing exposure, contamination/environment, common design error, or maintenance practice that defeats both channels.

Expected learner conclusion:

**CHANNEL COUNT != CCF CONTROL.**

The exercise deliberately provides no CCF score. The learner must identify and justify actual measures rather than invent points.

## Case E — plausible tool result, invalid use-profile assumption

A project file contains an apparently satisfactory numerical result. The electromechanical final element was entered using a manufacturer B10d value, but `nop` was calculated from an obsolete commissioning estimate of 20 demands/day. Production changes later cause 200 demands/day. Nobody updates the model.

Using the sourced relationship:

`MTTFd = B10d / (0.1 * nop)`

and holding B10d constant, a tenfold increase in valid `nop` produces a tenfold decrease in the B10d-derived MTTFd input.

This ratio requires no machine-specific invented value and no calculator.

Expected learner conclusion:

- the old calculation can be internally correct and still no longer describe the application;
- stale use-profile evidence invalidates the claimed input;
- a green SISTEMA result cannot override incorrect input evidence;
- change control must include safety-model assumptions, not only drawings and part numbers.

**Freeze:** NUMERICALLY CORRECT MODEL + FALSE APPLICATION ASSUMPTION = UNDEFENSIBLE SAFETY CLAIM.

## Case F — correct part number, wrong switching application

A replacement relay/contactor has a documented B10d figure, but the engineer has not established that the value applies to the actual load/use conditions or switching duty in the machine.

Expected learner conclusion:

- `B10d exists` is not equivalent to `this B10d is applicable`;
- component identity, duty/use profile and manufacturer conditions are part of evidence provenance;
- do not calculate a formal result from an inapplicable catalog value.

This carries forward the 2540 freeze `CONTACT CARRY CURRENT != SWITCHING SUITABILITY`.

## Case G — subsystem decomposition trap

A complete safety function is:

`interlocked guard -> safety logic -> STO-capable drive -> motor/hazard`

The drive supplier supplies certified subsystem data for STO. The learner is asked whether the drive's PL/PFH capability is the achieved PL of the complete guard safety function.

Correct reasoning requirement:

- supplier subsystem evidence may support the drive/STO subsystem within its documented assumptions;
- it does not erase input, logic, integration, CCF/systematic, SRS or validation obligations elsewhere in the function;
- it does not prove actual standstill, guard-distance adequacy or absence of externally driven motion unless those propositions are separately established.

**Freeze:** CERTIFIED SUBSYSTEM CAPABILITY != COMPLETE SAFETY-FUNCTION ACHIEVED INTEGRITY.

## B10d and cycle reasoning — what the learner may calculate

For an electromechanical component where the source and method legitimately apply:

`nop = (dop * hop * 3600) / tcycle`

`MTTFd = B10d / (0.1 * nop)`

The important lesson is not arithmetic. Every term has provenance:

- `B10d`: applicable manufacturer/standard evidence;
- `dop`: actual or defensibly specified operating days/year;
- `hop`: actual or defensibly specified operating hours/day;
- `tcycle`: actual or defensibly specified mean cycle interval.

If one of these is `UNKNOWN`, a formal application result must not be invented. Symbolic sensitivity reasoning is still allowed.

## Independent-variation matrix

| Case | Category/topology | MTTFd evidence | DC evidence | CCF evidence | Main lesson |
|---|---|---|---|---|---|
| A | held | varied | held | held | topology does not determine reliability |
| B | held | held | varied | held | diagnostics are independent evidence |
| C | apparently redundant upstream | not enough | not enough | downstream dependency dominates | redundancy must extend through the real function |
| D | two-channel | held | held | deliberately deficient/unknown | channel count is not CCF control |
| E | held | stale because duty changed | held | held | valid arithmetic cannot rescue stale assumptions |
| F | held | applicability unknown | held | held | catalog data requires application provenance |
| G | mixed certified/custom subsystems | subsystem-specific | subsystem-specific | integration still required | subsystem capability does not become whole-function capability |

## Adversarial questions

1. A SISTEMA project says PL e. Which repository/source evidence must you inspect before accepting that statement?
2. A designer doubles the number of input channels but retains one unmonitored final contactor. What dangerous path remains?
3. A diagnostic detects a welded contactor via a documented mirror contact. What physical propositions are still not proved?
4. Production rate increases by 10x. Which B10d-derived input is immediately suspect and why?
5. Two channels use identical routing, connectors, power and maintenance procedure. Why is `two channels` not the end of the analysis?
6. A drive's STO subsystem is certified. Why can the complete guard function still fail its required integrity or physical validation?

## Compute decision

No executable compute is justified for these cases. The unresolved questions are evidence/provenance and architecture questions. Running a calculation would add false precision rather than information. If a later exercise requires an actual SISTEMA-compatible numerical comparison with complete authoritative inputs, it must be bounded and run only on `[self-hosted, openpressbrake]`.

## Next work

Build a 2550 fault-driven assessment around a realistic mixed technology safety function (electromechanical input, safety logic, drive STO plus contactor or fluid-power final element). Require the learner to decompose subsystems, identify data provenance, expose CCF/dependency traps, separate numerical PL evidence from physical validation, and reject at least one attractive but invalid calculation. Then audit whether 2550 has enough coverage for a concise learner route and information-separated evaluation handoff.