# Safety Evidence Acceptance / Rejection Gate Matrix

Date: 2026-09-16
Status: durable curriculum artifact
Scope: LinuxCNC / OpenPressBrake safety curriculum; commissioning, maintenance, fault-injection, and validation evidence

## Purpose

This matrix converts the chain-of-custody discipline into a practical review gate. It answers a narrower question than a safety validation report:

> **Is this artifact acceptable evidence for this exact claim, and if so, how narrowly?**

It does not decide that a machine is safe. It does not establish PL, SIL, Category, PFHd, stopping distance, protective distance, hydraulic thresholds, proof-test intervals, or diagnostic coverage.

## Gate outcomes

- **REJECT** — artifact cannot support the proposed claim. It may still be retained as context or evidence of a different, narrower fact.
- **REVIEW** — potentially useful, but one or more material dependencies, integrity questions, or configuration/independence gaps must be resolved before acceptance.
- **ACCEPT-AS-BOUNDED** — artifact supports a specifically written conclusion within its demonstrated boundary. It must not be promoted to a stronger physical or safety claim.

There is deliberately no generic `ACCEPT` outcome. Every evidence item has a boundary.

## Mandatory pre-gate questions

Before grading an artifact, write:

1. exact claim being supported;
2. hazard/safety function to which the claim belongs;
3. provenance class: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, or `UNKNOWN`;
4. observer/source and whether it is independent of the commanded path;
5. tested configuration identity;
6. raw artifact location;
7. transformation history;
8. freshness/session/order evidence;
9. explicit facts that remain `UNKNOWN`.

If the proposed claim itself is vague (`machine safe`, `E-stop works`, `guard good`), return **REVIEW** until it is decomposed into testable physical claims.

## Hard rejection gates

Return **REJECT for the proposed claim** when any of these applies:

| Condition | Why |
|---|---|
| Command bit/command echo is offered as proof of final-element state | It observes the command path, not the physical outcome. |
| HMI `SAFE`, `ESTOP`, `GUARD CLOSED`, or similar status is the sole proof of physical safe state | Displayed state is not an independent physical witness. |
| Cached/stale state after reconnect is offered as present-state evidence | Freshness is absent. |
| Prior PASS is offered after a material unreviewed configuration/wiring/guard/final-element change | Evidence is bound to the prior configuration. |
| Matching controller signature is offered as proof of unchanged field wiring, guard geometry, hydraulics, or final elements | Signature scope does not include those physical facts. |
| A transformed summary is presented as raw data when the raw artifact is known to exist but was discarded or cannot be reconciled | Chain of custody is broken for claims requiring the omitted context. |
| Test stimulus never exercises the claimed final element or physical safety path | The test does not challenge the claimed function. |
| Missing physical fact is replaced with an assumed stopping time, pressure, decay, distance, or threshold | Machine-specific fact was invented. |
| Log entry is offered as proof that a physical bypass/jumper/guard was actually restored | Administrative/log state is not physical restoration evidence. |
| Evidence comes only from the same software state whose correct operation is the claim | No independent witness exists where one is needed. |

`REJECT` is claim-relative. A rejected HMI screenshot may still be **ACCEPT-AS-BOUNDED** for the narrow claim `the HMI displayed ESTOP at this captured instant` if its provenance is adequate.

## Review gates

Return **REVIEW** rather than silently accepting when:

- configuration identity is incomplete but may be recoverable;
- raw data exists but transformation steps are unclear;
- wall-clock ordering is ambiguous and causal order matters;
- device revision or wiring revision is missing;
- independent witness exists but its independence/wiring has not been established;
- a safety signature/configuration signature changed and impact analysis has not bounded what prior evidence remains reusable;
- a replacement safety device was automatically configured but functional testing evidence is incomplete;
- test instrumentation calibration/range/sample behavior matters to the claim and is undocumented;
- a fault injection challenged logic but it is unclear whether the real final element was exercised;
- a maintenance bypass was administratively cleared but restoration/proof-test evidence is incomplete;
- a photo/video appears persuasive but cannot yet be bound to the current machine/configuration/session;
- evidence is `COMMUNITY-REPORTED` and the proposed conclusion requires local physical confirmation.

A reviewer must record exactly what would move the artifact from `REVIEW` to `ACCEPT-AS-BOUNDED` or `REJECT`.

## Accept-as-bounded gates

An artifact may be **ACCEPT-AS-BOUNDED** when all dependencies necessary for the written conclusion are present and the conclusion does not outrun the observer.

Typical examples:

| Artifact | Acceptable bounded conclusion | Still not established |
|---|---|---|
| Raw safety-controller trace bound to configuration and session | controller input/output logic followed the recorded sequence | external contactor/valve/hazard state unless independently witnessed |
| Independently wired mirror/feedback contact observed during a defined test | feedback path represented the final-element feedback state under the tested conditions | every downstream hazardous energy source harmless |
| Instrumented ram-position trace with known configuration and test conditions | measured position behaved as recorded during that test | required stopping performance unless requirement/measurement method is separately established |
| Original photo showing restored guard, bound to machine/work order | guard was visibly present in the recorded configuration | interlock function, defeat resistance, or safe distance |
| Functional interlock test that exercises input, safety logic, final element, independent feedback, and restart behavior | tested path behaved as documented under those conditions | untested faults, other guards, other energy sources, PL/SIL |
| Matching archived safety signature after download | safety application identity matches the archived signature within that mechanism's scope | unchanged field installation or complete machine validation |
| Manufacturer manual section | documented device behavior/requirement for the identified model/revision | actual installation compliance or physical performance |
| LinuxCNC/FPGA watchdog test | ordinary-control containment behaved as observed | personnel-safety authority or safety-rated performance |

## Evidence-quality dimensions

Grade each dimension `GOOD`, `LIMITED`, `MISSING`, or `NOT-NEEDED`, with a sentence explaining why.

| Dimension | Review question |
|---|---|
| Claim specificity | Is the physical claim narrow and testable? |
| Source authority | Does the source/observer actually observe the claimed fact? |
| Independence | Is the witness independent enough from the path whose success is claimed? |
| Raw retention | Is the earliest practical artifact retained? |
| Configuration binding | Can the artifact be tied to the relevant machine, logic, wiring, device, guard, and parameter revisions? |
| Transformation trace | Can exports, filtering, cropping, calculations, and summaries be reconstructed? |
| Freshness/session identity | Is current versus cached/historical state distinguishable? |
| Causal ordering | Is event order established sufficiently for the claim? |
| Test challenge | Did the test actually exercise the claimed path/fault? |
| Physical witness | Where needed, was the final element/hazard physically observed? |
| Recovery coverage | Were reset/restart/rearm consequences checked when relevant? |
| Bypass/restoration state | Were temporary overrides/jumpers/guards/test forces accounted for? |
| Unknown discipline | Are unmeasured facts explicitly left `UNKNOWN`? |

A numerical score is intentionally forbidden. Missing one critical dimension can invalidate a claim even if every other dimension is excellent.

## Configuration-change rule

**DOC-CONFIRMED:** Rockwell GuardLogix documentation states that safety-signature elements change when their associated safety-application elements are modified and require revalidation. It also states that safety-I/O configuration signatures identify device configuration and are considered verified only after user testing.

Therefore:

- signature match is useful configuration-identity evidence within its scope;
- signature mismatch/change is an impact-analysis/revalidation trigger;
- neither result substitutes for inspection/test of physical installation facts outside the signature scope;
- unchanged elements may be reusable only when the validation plan and dependency analysis justify that reuse.

Do not use `everything changed, retest everything` as a substitute for dependency analysis. Do not use `only software changed` as a reason to skip physical-path testing when the software change can affect that path.

## Maintenance and return-to-service rule

**DOC-CONFIRMED:** OSHA machine-guarding guidance describes return-to-service steps after servicing that include checking guards and safety devices are in place and functional and checking the area before reenergization/startup.

Accordingly, an administrative `bypass=false`, closed work order, cleared fault, or restored configuration is not enough by itself. Evidence acceptance must separately consider physical restoration and functional behavior of affected safeguards.

## Fault-injection evidence gate

For every injected fault, separate at least five claims:

1. fault was actually introduced at the intended point;
2. safety/normal-control logic detected or reacted to it;
3. final element reached the observed state;
4. hazardous physical condition behaved as observed;
5. recovery/reset/restart behavior behaved as observed.

One artifact rarely proves all five. Assign an outcome to each claim rather than giving the whole experiment a single PASS.

Test count must never be converted into diagnostic coverage, PL, SIL, Category, PFHd, or machine suitability.

## Practical adjudication examples

### 1. LinuxCNC says E-stop active; no contactor feedback

- HMI-display claim: **ACCEPT-AS-BOUNDED** if capture provenance is adequate.
- `contactor opened`: **REJECT**.
- `hazard removed`: **REJECT**.
- Required next evidence: independent final-element/hazard witness appropriate to the actual architecture.

### 2. Safety signature matches, but field wiring was modified

- `controller safety application matches archived identity`: **ACCEPT-AS-BOUNDED**.
- `field installation unchanged/validated`: **REJECT** until wiring change is inspected/tested.

### 3. CSV shows stop sequence but original trace is missing

- If causal timing/detail matters: **REVIEW** or **REJECT**, depending on whether provenance can be reconstructed.
- Do not infer omitted channels/sample behavior.

### 4. Interlock test opens gate and independently observes final-element feedback, but restart is untested

- stop-path behavior: potentially **ACCEPT-AS-BOUNDED** for the tested path.
- restart/rearm claim: **REVIEW** or `UNKNOWN` until challenged.

### 5. Maintenance log says temporary jumper removed; photo shows wiring but no functional test

- administrative removal record: **ACCEPT-AS-BOUNDED**.
- physical configuration may be **REVIEW** if photo/revision binding is adequate.
- restored safety function: **REVIEW** until required functional challenge is completed.

### 6. Watchdog test on ordinary FPGA removes proportional-valve command

- FPGA command-containment claim: **ACCEPT-AS-BOUNDED** if raw trace/configuration are sound.
- valve current/spool/hydraulic response/ram stop: separate claims requiring their own evidence.
- personnel-safety authority: **REJECT**; ordinary FPGA watchdog containment is not thereby safety-rated authority.

## Reviewer record template

| Field | Entry |
|---|---|
| Evidence ID | |
| Proposed claim | |
| Provenance class | |
| Gate outcome | `REJECT` / `REVIEW` / `ACCEPT-AS-BOUNDED` |
| Critical dimension(s) | |
| Bounded accepted conclusion | |
| Explicit rejected promotion | |
| Remaining UNKNOWNs | |
| Required next evidence | |
| Configuration/revision | |
| Reviewer/date | |

## Source notes

- **DOC-CONFIRMED — Rockwell Automation, GuardLogix Safety Signature Elements / Safety Signature:** changed safety-signature elements require revalidation; element-level impact analysis can distinguish changed from unchanged portions.
- **DOC-CONFIRMED — Rockwell Automation, Safety I/O Device Signature / Connect to Safety I/O:** safety-I/O configuration signatures identify configuration and are only considered verified after user testing.
- **DOC-CONFIRMED — Rockwell Automation, Download/Upload a Safety Application Program:** mismatching a safety signature during download/restore removes the prior signature and requires revalidation.
- **DOC-CONFIRMED — OSHA Machine Guarding eTool, Additional Safety Considerations:** return to service after servicing includes inspection that guards/safety devices are in place and functional and checking the area before startup.

## Open machine-specific facts

For an actual OpenPressBrake installation, keep `UNKNOWN` until measured/designed/documented:

- stopping time and protective distance;
- hydraulic pressure/decay and trapped-energy behavior;
- gravity/load-retention behavior;
- required PL/SIL/Category and quantitative reliability values;
- exact safety-controller/final-element architecture;
- proof-test intervals;
- required calibrated instrumentation and acceptance tolerances;
- machine-specific reset/restart/rearm requirements derived from the final risk assessment.

The evidence gate controls the quality of claims. It does not manufacture the missing physical facts.