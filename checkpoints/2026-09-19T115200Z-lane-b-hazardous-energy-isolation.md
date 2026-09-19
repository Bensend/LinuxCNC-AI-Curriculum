# Safety curriculum Lane-B checkpoint — hazardous-energy isolation / stored energy

Date: 2026-09-19

Substantive commit: `2761bcfc98076736dea2b9369d6ec7984c3527cd`

Completed: `safety-course/HAZARDOUS_ENERGY_ISOLATION_STORED_ENERGY_VERIFICATION_SERVICE_BOUNDARY_STUDY_2026-09-19.md`.

Primary-lane separation: primary durable work at selection time was `PRESS_BRAKE_TWO_HAND_STOPPING_PERFORMANCE_LIFECYCLE_AUTHORITY_TRACE_2026-09-19.md` / checkpoint `3b1bf6d8`, focused on two-hand safeguarding and maintained physical stopping performance. Lane B selected the independent maintenance/service hazardous-energy boundary and did not modify the primary module or evidence package.

Evidence gain: OSHA 29 CFR 1910.147 and related OSHA guidance explicitly separate shutdown/control commands from physical energy isolation, stored/residual-energy control, verification of deenergization, and continued verification where hazardous energy can reaccumulate. Appendix A names hydraulic pressure, elevated machine members, capacitors, springs and other stored-energy forms and gives blocking/bleeding/repositioning/grounding as example controls.

Frozen boundary: `LINUXCNC MACHINE OFF != SAFETY OUTPUT OFF != ENERGY ISOLATED != STORED ENERGY CONTROLLED != ZERO/SAFE ENERGY VERIFIED != REACCUMULATION PREVENTED != SAFE TO SERVICE`; `E-STOP ACTIVE != LOCKOUT`; `STO ACTIVE != ELECTRICAL ISOLATION`; `TAG PRESENT != ENERGY CONTROLLED`.

No OpenPressBrake energy inventory, isolation point, accumulator behavior, blocking method, discharge time, safe voltage/pressure threshold, reaccumulation interval or return-to-service procedure was invented. Those remain UNKNOWN pending machine-specific documentation/measurement.

No executable verification was justified. No GitHub-hosted or self-hosted runner compute was consumed.

Current main was re-read after the substantive commit. `2761bcfc` was HEAD and no overlapping primary-lane change appeared.

Precise next Lane-B target: find a professional hydraulic machine/press/press-brake maintenance implementation exposing `shutdown -> every physical energy isolator -> lockout -> electrical/hydraulic/gravity stored-energy control -> energy-specific verification -> reaccumulation monitoring where applicable -> service -> controlled restoration -> affected safety-function/final-element re-proof -> deliberate production reauthorization`, preferably with explicit accumulator/trapped-volume and ram blocking evidence.