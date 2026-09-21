# 25C0 Exercise — Runtime Manifest vs Baseline Integrity

Date: 2026-09-21

## Scenario

A machine using an ordinary Logix controller plus an independent safety system has completed commissioning work. The HMI's proposed `PRODUCTION CONFIG CLEAN` page shows:

- controller in RUN;
- I/O `ForceStatus`: installed=0, enabled=0;
- safety controller reports safety-locked and no safety fault;
- engineering workstation currently shows `No Edits`;
- controller audit value differs from the value recorded at the last approved production release;
- maintenance says an online standard-logic edit was assembled earlier to diagnose a permissive and then the laptop was disconnected;
- the temporary cabinet jumper used during the same job is *believed* removed, but nobody has signed the physical-clearance item.

The independent safety circuit has not been intentionally modified.

## Learner task

Decide whether automatic production may be released. For every datum, classify it as one of:

1. live machine-readable exceptional-state evidence;
2. baseline/change-accounting evidence;
3. independent safety diagnostic/readiness evidence;
4. engineering-tool-only evidence;
5. physical-inspection evidence.

Then state the minimum additional dispositions required before ordinary production handoff. Do not demand unrelated full-machine revalidation unless the change-impact analysis requires it, and do not promote the ordinary production-clean gate into personnel-safety authority.

## Expected reasoning boundary

A strong answer must reject production release even though RUN, `ForceStatus=0`, safety lock, and `No Edits` all look favorable.

The changed audit value means the accepted production baseline has changed or at least that a monitored change occurred and requires disposition. `No Edits` does not prove that an already assembled edit disappeared; it can mean there is no *pending/test edit state* while changed logic remains. The unverified physical jumper is outside controller telemetry entirely.

Minimum disposition should include:

- identify/reconcile the audit-changing event(s) against the approved production baseline;
- review the accepted standard-logic change for its effect on ordinary control and on safety timing/tag mapping where applicable;
- restore or formally accept the intended production logic/configuration under the site's change process;
- positively inspect/remove the temporary jumper/test aid and record that clearance;
- functionally check any real field input/output path that the temporary force/jumper/edit could have masked;
- retain independent safety readiness/validation requirements as a separate gate.

## Misleading answers to reject

- "Safety is locked, therefore production is safe." Safety lock is not production-configuration proof or physical validation.
- "No forces and no edits means the original program is back." Current exceptional-state absence is not baseline identity.
- "The audit value changed, therefore a force is still active." Audit change is historical/invalidation evidence, not current force-state evidence.
- "The PLC says clean, so the jumper must be gone." Controller telemetry cannot prove an uninstrumented physical aid is removed.
- "Rerun every validation test." Change-impact analysis should determine affected evidence; ritual full retest is not the lesson.

## Transfer variant

Replace the Logix force with a LinuxCNC HAL test override and replace the controller audit value with a signed/versioned production configuration baseline. Ask the same question. The correct transfer is the *evidence architecture*, not Rockwell-specific APIs: live exceptional-state observability where available + baseline identity/change disposition + physical clearance + independent safety authority.

## Evidence labels

The Rockwell-specific force/audit mechanisms are **DOC-CONFIRMED**. Applying the evidence architecture to a generic machine or LinuxCNC integration is an **INFERENCE/design pattern** until that implementation is actually built and validated.
