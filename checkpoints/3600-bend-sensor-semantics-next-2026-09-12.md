# 3600 next-work checkpoint — bend-sensor semantics

Date: 2026-09-12

## Critical path first

Re-check the F02 information-separated evaluator result before doing anything else. F02 remains PREPARED / UNSCORED unless a correctly routed evaluator response is durably present. Do not self-score it and do not expose learner-side hidden answers to the evaluator.

## New durable result

`research/3600-bend-sensor-semantic-source-audit-2026-09-12.md` source-traces `aleadvea/press-brake-cnc-upgrade` at `95cf12f639b036f80541b00128e0a31c5dcc9050`.

The project's `bend_sensor` is a binary NC-contact/process-phase witness, not a quantitative angle sensor. Motor firmware can react locally to its edge; the HMI receives the bit and its AUTO state machine uses LOW→HIGH to command retract and later HIGH→LOW to enter the post-bend pause. AUTO explicitly disables the motor-side automatic retract while it owns that response, demonstrating an explicit sensor-observation vs motion-authority boundary.

A motor-side prose comment calls LOW→HIGH "bend finished," but the packet comments and executable HMI state flow support HIGH as the active-bend phase and HIGH→LOW as bend end. Preserve this as a source-comment semantic conflict rather than silently normalizing it.

The status payload has no sample generation/timestamp/edge sequence identity. Nominal 30 ms motor polling/status plus 50 ms HMI evaluation is cadence, not freshness provenance.

## What this does NOT resolve

This source does not provide active measured-angle/springback correction. It has no quantitative angle measurement, phase-qualified angle sample, correction insertion, saturation, Y1/Y2 interaction, or recovery semantics.

Therefore the 3600 active sensor-bending implementation gate remains SOURCE UNAVAILABLE / UNKNOWN.

## Resume rule

If F02 remains blocked, do not run another boolean sensor/retract toy fixture. Reopen 3600 only for genuinely new inspectable evidence that answers one of:

1. active measured-angle acquisition freshness/generation and correction authority;
2. complete tandem Y1/Y2 read -> differential/control -> limit -> write graph;
3. tooling/contact/datum-aware gauge target solver internals;
4. measured-coupon/table-generation fitting source.

When future searches find a term like `bend sensor`, inspect its actual data type, producer, consumers, phase semantics and authority before classifying it as angle-sensing evidence.
