# Lane B checkpoint — guard-lock escape-release recommissioning

Date: 2026-09-20T11:49Z
Lane: independent safety curriculum Lane B

## Durable work completed

Added `safety-course/GUARD_LOCK_ESCAPE_RELEASE_RECOMMISSIONING_AND_RESTART_AUTHORITY_STUDY_2026-09-20.md`.

Primary lane was re-read before selection. Current main is advancing accessible-cell scanner geometry/reset/restart validation plus hydraulic/gravity-axis physical witness work. Lane B therefore selected guard-lock escape/emergency-release recommissioning as a separate protective-device family and evidence artifact.

## Evidence gained

Manufacturer evidence from Pilz and SICK establishes that accessible guard-lock systems may provide inside escape release; operating release changes the guard/safety state; and restoration after escape/emergency release can require deliberate mechanical restoration plus functional testing/recommissioning rather than simple gate reclosure. Pilz guidance also exposes the power-loss case that motivates a mechanical release when control-powered unlocking may be unavailable.

Freeze:

**GUARD CLOSED != GUARD LOCKED != HAZARD CEASED**

**ESCAPE RELEASE OPERATED != PERSON OUTSIDE HAZARD != AREA CLEAR**

**ESCAPE RELEASE MECHANICALLY RESTORED != SAFETY DEVICE REQUALIFIED**

**GUARD RECLOSED != FUNCTION TEST PASSED != SAFETY REARMED**

**SAFETY REARMED != FRESH ORDINARY START**

No OpenPressBrake guard-lock topology, escape-release hardware, stopping time, reset location, PL/SIL/category, final elements or hydraulic safe state was invented.

## Compute

No executable verification was justified. No GitHub-hosted runner was used and no self-hosted compute was consumed.

## Precise next Lane-B work

Find a manufacturer/OEM commissioning or acceptance procedure exposing the complete guard-lock recovery sequence:

`person inside -> escape release -> guard unlock/open -> safety demand/final elements -> person exits -> release mechanically restored -> retained-person/area-clear decision -> guard reclosed/relocked -> required functional test -> safety reset/requalification -> stale ordinary-command challenge -> separate fresh production start`.

Prefer explicit power-loss behavior and a deliberate retained-person/fault challenge. Do not duplicate the primary lane's scanner-field geometry/stand-behind validation. If the evidence path collapses back into scanner validation, rotate to another guard-lock-specific gap.
