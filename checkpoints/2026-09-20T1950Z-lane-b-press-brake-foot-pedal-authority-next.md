# 4000 Safety Lane-B checkpoint — press-brake three-position foot-pedal authority

## Completed
- Added `safety-course/PRESS_BRAKE_THREE_POSITION_FOOT_PEDAL_OVERTRAVEL_RELEASE_AND_RESTART_AUTHORITY_STUDY_2026-09-20.md`.
- Fiessler FE-FS evidence establishes a press-oriented three-position pressure-point pedal where overtravel returns working contacts to idle, operates positive-opening safety contact(s), initiates stop, and requires complete pedal release before restart is possible.
- Lazer Safe Defender independently demonstrates a press-brake release-and-repress requirement after a forced Stop-at-Mute boundary; a continuously held foot request is not automatically sufficient to continue the stroke.
- Kept this branch separate from the primary lane's post-maintenance return-to-production/change-impact files.

## Freeze
- PEDAL WORKING POSITION != PERSONNEL-SAFETY AUTHORITY.
- OVERTRAVEL/PANIC DEMAND != ORDINARY SOFTWARE STOP REQUEST.
- RETURN THROUGH WORKING POSITION AFTER OVERTRAVEL != FRESH START.
- COMPLETE PEDAL RELEASE != SAFETY READY/PRODUCTION AUTHORITY.
- FRESH PEDAL ACTUATION remains subordinate to independent safeguards and safety final elements.

## Next work
Seek an authoritative manufacturer/OEM commissioning test that physically exercises working-position motion -> release stop -> working-position motion -> panic overtravel stop -> slow return through working position with no restart -> complete release -> fresh re-actuation, preferably including redundant-contact fault insertion and actual final-element/machine response. If only component switching diagrams are available, mark this branch source-limited and rotate.

OpenPressBrake pedal topology, stopping performance, hydraulic response, PL/SIL/category/DC/CCF and acceptance thresholds remain UNKNOWN. No simulation/build/test compute was justified; no GitHub-hosted runner was used.