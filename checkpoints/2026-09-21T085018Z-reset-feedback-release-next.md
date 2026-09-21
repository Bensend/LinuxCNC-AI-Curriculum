# Safety course checkpoint — reset, feedback and release separation

Session start recorded: 2026-09-21T08:34:18Z.

## Durable result

The setup/manual -> safeguarded automatic trace reached its useful evidence boundary. Siemens SIRIUS and ABB robot documentation establish that operating-mode/safety-permission restoration is separate from a later Start action, but do not define a universal held-input algorithm. That limitation is now explicit rather than invented.

The session rotated into 25E0. Schmersal PROTECT SELECT documentation exposes protective inputs, reset/restart condition, external actuator feedback circuit and ordinary controller release as distinct functions. New durable study: `safety-course/SCHMERSAL_RESET_RESTART_FEEDBACK_AND_CONTROLLER_RELEASE_SEPARATION_2026-09-21.md`.

## Exact next work

Trace a professional implementation in which restart inhibit/reset semantics are coupled to monitored external final elements, preferably with explicit fault behavior when feedback fails to return or disagrees. Determine exactly what the feedback witness proves and what remains physical/machine-specific. Prefer manufacturer schematics/manuals over generic safety-relay tutorials.

Carry forward the demand-freshness rule: even a valid safety release does not regenerate a stale ordinary start request.

If the reset/feedback source path becomes repetitive, rotate to another open 25E0 professional implementation rather than inventing diagnostic coverage or physical safe-state claims.

No compute was justified; no GitHub-hosted runner was used.
