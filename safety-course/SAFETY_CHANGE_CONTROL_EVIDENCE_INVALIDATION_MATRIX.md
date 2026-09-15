# Safety Change-Control / Evidence-Invalidation Matrix

Status: curriculum working contract

Purpose: prevent old commissioning or validation evidence from being treated as proof for a machine that has materially changed. This is a machine-agnostic curriculum artifact; it does **not** assign a PL/SIL, stopping distance, hydraulic truth table, proof-test interval, or machine-specific acceptance value.

## Core rule

A previous PASS is evidence for the configuration that was actually tested. It is not a permanent property of the machine.

Before production rearm after a change, identify what changed, determine which safety claims depend on it, invalidate the affected evidence, and re-run the smallest test set that genuinely re-establishes those claims. If the dependency is unknown, classify the affected evidence `UNKNOWN / REVALIDATE`; do not silently preserve PASS.

This rule complements `COMMISSIONING_PERIODIC_VALIDATION_EVIDENCE_WORKSHEET.md`, `SAFETY_FUNCTION_PROOF_OF_RESTORATION_MATRIX.md`, `ENERGY_SOURCE_INVENTORY_WORKSHEET.md`, and `MAINTENANCE_BYPASS_TEMPORARY_OVERRIDE_LIFECYCLE.md`.

## Evidence labels

- `SOURCE-CONFIRMED` — directly supported by an authoritative source.
- `DOC-CONFIRMED` — supported by controlled machine/project documentation.
- `TEST-CONFIRMED` — demonstrated on the identified configuration by a recorded test.
- `COMMUNITY-REPORTED` — useful experience, not validation evidence by itself.
- `INFERENCE` — engineering conclusion whose assumptions remain explicit.
- `UNKNOWN` — unresolved; never promote to PASS by convenience.

## Change record minimum

Every safety-relevant change record should capture:

| Field | Required content |
|---|---|
| Change ID | Unique durable identifier |
| Before identity | Drawing/config/software/hardware revisions actually covered by prior evidence |
| After identity | New revisions/configuration |
| Physical change | What was actually altered, not only ticket wording |
| Hazard boundary affected? | YES / NO / UNKNOWN + reason |
| Safety functions touched | Named functions/claims |
| Energy-control procedure touched | YES / NO / UNKNOWN |
| Evidence invalidated | Exact test records/claims, not a generic `validation` flag |
| Retest scope | Deliberate stimuli and observations required |
| Independent review | Person/method appropriate to the change |
| Production-rearm gate | Evidence required before normal operation |

## Evidence-invalidation matrix

`REOPEN` means prior evidence cannot be used as current proof until the affected claim is re-established. `REVIEW` means dependency analysis is mandatory and may expand to REOPEN. `NO AUTOMATIC REOPEN` means the change does not by itself invalidate that evidence, but contradictions still do.

| Change class | Hazard / risk assessment | Safety-function logic | Input/device response | Final-element response/feedback | Reset/restart/rearm | Energy-isolation procedure | Guarding / access validation | Stopping/performance evidence | Training / procedure | Minimum disposition |
|---|---|---|---|---|---|---|---|---|---|---|
| Safety relay/PLC/controller replacement, firmware, safety configuration | REVIEW | REOPEN | REVIEW | REVIEW | REOPEN | REVIEW | REVIEW | REVIEW | REVIEW | Revalidate every function whose logic, timing, diagnostics or reset path depends on the changed item |
| Safety input device, wiring, channel mapping, polarity, test-pulse configuration | REVIEW | REVIEW | REOPEN | REVIEW | REVIEW | NO AUTOMATIC REOPEN | REOPEN where access protection depends on it | REVIEW | REVIEW | Fault-test changed channel plus dependent safety function end-to-end |
| Contactor, valve-enable final element, EDM/feedback wiring | REVIEW | REVIEW | REVIEW | REOPEN | REOPEN | REVIEW | REVIEW | REVIEW | REVIEW | Prove de-energized response, feedback plausibility, persistent-fault behavior and no automatic restart |
| Ordinary LinuxCNC HAL/config/UI change | REVIEW | REVIEW only where safety interface is affected | REVIEW | REVIEW | REOPEN if restart/rearm behavior changed | NO AUTOMATIC REOPEN | NO AUTOMATIC REOPEN | REVIEW if motion behavior can change | REVIEW | Never allow LinuxCNC to become independent safety authority merely because a config changed |
| Normal FPGA gateware, watchdog, I/O mapping, transport protocol | REVIEW | REVIEW at safety boundary; ordinary FPGA remains non-safety authority | REVIEW | REVIEW | REOPEN for watchdog/rearm/stale-command claims | NO AUTOMATIC REOPEN | NO AUTOMATIC REOPEN | REVIEW if motion/output timing changes | REVIEW | Re-test containment, stale-command prevention and safety-interface independence |
| Hydraulic valve, manifold, hose routing, accumulator, pressure-control architecture | REOPEN | REVIEW | REVIEW | REOPEN | REVIEW | REOPEN | REVIEW | REOPEN where stop/hold behavior depends on hydraulics | REOPEN | Do not infer new hydraulic behavior; require machine-specific engineering/measurement |
| Drive, motor, brake, gearbox, axis mechanics | REOPEN | REVIEW | REVIEW | REOPEN | REVIEW | REVIEW | REVIEW | REOPEN | REVIEW | Re-establish motion/stop/holding assumptions affected by the hardware |
| Guard, door, light curtain, scanner, access geometry, mounting | REOPEN | REVIEW | REOPEN | REVIEW | REVIEW | NO AUTOMATIC REOPEN | REOPEN | REOPEN where distance/timing matters | REVIEW | Reassess access/hazard geometry; do not carry forward old placement evidence |
| Tooling, die, fixture, workholding or process change that alters access/hazard | REOPEN | REVIEW | REVIEW | REVIEW | REVIEW | REVIEW | REOPEN | REVIEW | REVIEW | Treat changed hazard geometry/energy as a new dependency question |
| Main disconnect, lockout point, blocking device, bleed/restraint method, stored-energy path | REOPEN | NO AUTOMATIC REOPEN | NO AUTOMATIC REOPEN | REVIEW | REVIEW | REOPEN | REVIEW | NO AUTOMATIC REOPEN | REOPEN | Re-perform energy-source inventory and isolation verification; update training/procedure as needed |
| Safety reset/start control relocation or HMI workflow change | REVIEW | REVIEW | REVIEW | REVIEW | REOPEN | NO AUTOMATIC REOPEN | REVIEW | NO AUTOMATIC REOPEN | REVIEW | Re-test deliberate reset, separate start, held-control behavior and visibility of hazard zone |
| Diagnostic-only display/logging change with proven no control authority | NO AUTOMATIC REOPEN | NO AUTOMATIC REOPEN | NO AUTOMATIC REOPEN | NO AUTOMATIC REOPEN | REVIEW if operator decisions depend on it | NO AUTOMATIC REOPEN | NO AUTOMATIC REOPEN | NO AUTOMATIC REOPEN | REVIEW | Prove it remains diagnostic-only and does not forge permission/feedback |
| Like-for-like component replacement | REVIEW | REVIEW | REVIEW | REVIEW | REVIEW | REVIEW | REVIEW | REVIEW | REVIEW | `Like-for-like` is a hypothesis, not an exemption: compare safety-relevant characteristics and reopen affected claims |
| Documentation-only correction with no physical/configuration change | REVIEW | NO AUTOMATIC REOPEN | NO AUTOMATIC REOPEN | NO AUTOMATIC REOPEN | NO AUTOMATIC REOPEN | REOPEN if the correction reveals the energy procedure was wrong | REVIEW | REVIEW | REVIEW | Determine whether the old test was executed against an incorrect assumption; if yes, reopen it |

## Dependency rule

Do not choose retests from the component name alone. Trace:

`changed item -> affected assumption -> safety claim -> prior evidence -> required new observation`

Example: changing an ordinary FPGA build does not automatically require claiming that the safety relay was redesigned. It **does** reopen evidence for watchdog inhibition, output rearm, stale-command suppression, or safety-interface independence if those behaviors traverse the FPGA.

Likewise, changing a guard location can reopen access-distance or stopping-performance evidence even if no electrical wire changed.

## Production-rearm gate

Production rearm is prohibited while any safety-relevant changed dependency is:

- `UNKNOWN`;
- backed only by a command echo or software status where independent observation is required;
- covered only by evidence from a superseded configuration;
- awaiting a machine-specific measurement that materially determines the claim; or
- contradicted by current physical inspection, feedback, fault response, or energy-isolation evidence.

Safety reset, normal cycle start, LinuxCNC machine-on, and FPGA/output rearm remain distinct events. Revalidation must not turn restoration into automatic restart.

## Safety Sandbox adversarial cases

1. **FPGA pin remap with unchanged safety PLC** — learner must reopen watchdog/rearm/interface evidence, but must not claim the ordinary FPGA became the safety authority.
2. **Safety relay firmware/configuration change with same wiring** — old logic/reset/diagnostic validation is not automatically current.
3. **Guard moved 150 mm with identical switch** — electrical continuity PASS does not preserve access/placement or stopping-distance evidence.
4. **Hydraulic valve replaced with a nominal equivalent** — old measured stopping/holding behavior is not portable without justified equivalence or retest.
5. **HMI color/text change only** — should not trigger wholesale hardware revalidation, but misleading status or changed reset/start workflow must reopen human-interface claims.
6. **EDM contact rewired to a spare auxiliary contact** — command state is not accepted as proof; feedback plausibility and persistent welded/stuck final-element cases are re-tested.
7. **LinuxCNC update restores stale output command after reconnect** — independent safety may remain healthy, but normal-output rearm evidence fails and production rearm remains blocked.
8. **New die creates a reach-around path** — prior guard geometry PASS is invalid even though the guard and safety circuit were untouched.
9. **LOTO procedure changes because an accumulator is discovered** — energy-isolation evidence and affected training/procedure are reopened; an old electrical-only verification cannot remain PASS.
10. **`Like-for-like` contactor has different auxiliary-contact behavior** — comparison must include the feedback/EDM characteristic, not just coil voltage and contact current.
11. **Documentation typo reveals test used wrong channel identity** — evidence for that test is reopened even though the machine was not changed.
12. **Power cycle after maintenance change** — no stale command, held reset, or remembered bypass may manufacture production permission; restoration evidence must be configuration-current.

## Source-backed anchors

### OSHA hazardous-energy change triggers — SOURCE-CONFIRMED
29 CFR 1910.147(c)(7)(iii) requires retraining when job assignments change, when machines/equipment/processes present a new hazard, when energy-control procedures change, or when inspection/reason indicates deviations or inadequacies. This is a strong curriculum anchor for treating change as an evidence/procedure trigger rather than assuming an old procedure remains adequate.

29 CFR 1910.147(c)(6) also requires periodic inspection of each energy-control procedure and correction of identified deviations or inadequacies. This is an energy-control requirement; it must not be misrepresented as a universal annual proof-test interval for every safety component.

### Machinery-safety validation — SOURCE-CONFIRMED / scope caution
Pilz's machinery-safety validation guidance, summarizing ISO 13849 / IEC 62061 / IEC 61508 practice, explicitly treats validation depth as dependent on whether machinery is unchanged, subject to minor changes, or subject to complex/significant changes. It also describes validation as checking that protective measures and safety functions are correctly implemented. Use this as a practical lifecycle/change-control source, not as a substitute for the actual standards or a machine-specific conformity determination.

## Curriculum acceptance criteria

A learner passes this topic only if they can:

1. reject the statement `it passed once, therefore it is still safe`;
2. identify the configuration identity attached to evidence;
3. trace changes through assumptions to claims rather than retesting everything blindly;
4. distinguish safety-function validation from hazardous-energy/LOTO procedure inspection;
5. preserve the independent safety boundary when ordinary LinuxCNC/FPGA software changes;
6. fail closed on unknown dependencies;
7. demand machine-specific measurement when a changed hydraulic/mechanical fact cannot be inferred; and
8. keep reset, restart, rearm, restoration and production permission distinct.

## Next independent branch

Build a **safety fault-injection / diagnostic-coverage test catalog** that maps realistic single faults (shorts, opens, welded contacts, stuck valves/feedback, channel discrepancy, lost communications, stale command, sensor disagreement) to observable response and evidence class, without assigning invented diagnostic-coverage percentages or PL/SIL claims.