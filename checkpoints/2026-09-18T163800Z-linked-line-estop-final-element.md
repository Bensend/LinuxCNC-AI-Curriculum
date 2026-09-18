# Checkpoint — linked-line E-stop span, propagation, and final-element witness

Date: 2026-09-18
UTC session start: 2026-09-18T16:35:10Z
UTC checkpoint time: 2026-09-18T16:38:00Z

## Durable work

Created and deepened `safety-course/LINKED_MACHINE_ESTOP_SPAN_SIGNAL_FORWARDING_RESET_AUTHORITY_TRACE_2026-09-18.md` in commits `516bfb3383db3300b0794782f5fb82fac9914a7c`, `0ad9ef60e06317ada28e89f84ccdf5019effbf55`, and `8737836b7e60d46b6c17228f2d05277e7c70194a`.

## Evidence gain

Pilz application note 1005677-EN-02 provides a concrete FU1/FU2/FU3 linked-line topology. FU2 E-stop ES2 propagates into FU1 to stop the assembly line feeding FU2; FU3 E-stop ES3 propagates into FU2 to stop its assembly line. The same application explicitly conditions continued upstream/downstream operation on absence of hazard.

The same implementation also exposes external-contactor feedback: KM21-KM24 N/C feedback contacts are monitored and required closed before restart; a failed required feedback state prevents machine/plant restart. This advances the prior Lane-B span study from abstract span authority into a professional cross-unit propagation + final-element feedback example.

Siemens Automation Framework and LSafe documentation independently preserve zone actuator networks and separation of acknowledgement, E-stop release, drive enable and start authority.

## Freeze

`LOCAL E-STOP ACTUATED != ONLY LOCAL HAZARD EXISTS != ADJACENT EQUIPMENT MAY CONTINUE SAFELY != ALL RELEVANT FINAL ELEMENTS REACTED != PHYSICAL HAZARD ABSENT != RESET PERMITTED != PRODUCTION START AUTHORIZED.`

`SAFETY OUTPUT OFF != EXTERNAL CONTACTOR OPEN != ALL HAZARDOUS ENERGY ABSENT.`

`SAFETY ZONE BOUNDARY != CONTROLLER/ENCLOSURE BOUNDARY != MATERIAL-TRANSFER HAZARD BOUNDARY.`

## Parallel/overlap status

Newest pre-session durable checkpoint was `59e56278e09b11fa63f23bee1106ee1d20a7a4db` (Lane B E-stop span). No intervening external commits appeared during this session; the new work deliberately extends that lane using a new artifact and does not rewrite shared `PROGRESS.md`. Overlap status: NONE OBSERVED.

## Compute

No executable verification was justified. No GitHub-hosted runner and no self-hosted compute were consumed.

## Exact next work

Continue from the Pilz FU1/FU2/FU3 baseline into detailed circuit/commissioning evidence exposing:

`device/location -> span matrix -> cross-unit safety forwarding -> receiving evaluator -> safety output -> contactor/final element -> feedback witness -> physical hazard witness -> adjacent-zone behavior -> forwarding/final-element fault -> latched state -> reset/rearm -> separate production START`.

Highest-value remaining gap is physical hazard witness beyond contactor EDM, plus an injected forwarding/wrong-span failure. Preserve UNKNOWN where public evidence ends.
