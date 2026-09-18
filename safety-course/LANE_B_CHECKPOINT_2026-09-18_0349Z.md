# Lane B Safety Checkpoint — 2026-09-18 03:49Z

## Completed

- Added `COMMON_DC_BUS_BACKFEED_SERVICE_ISOLATION_BOUNDARY_STUDY_2026-09-18.md` at commit `86a313377116739f10c0c23d5d0edec9c74ff075`.
- Primary-lane newest durable checkpoint inspected before selection: `6828b49a598dd8bb604fbaea6a19e857e2ec6d2d`, HAWE ePRAX valve-path + Y1/Y2 hydraulic disagreement work.
- Lane B intentionally selected a different evidence package and different file.
- Re-read current `main` immediately after the substantive commit: Lane-B commit was directly above `6828b49a`; no intervening overlapping write existed.
- No executable verification was justified; no GitHub-hosted or self-hosted compute was consumed.

## Frozen result

`STO ACTIVE != MAINS DISCONNECTED != COMMON DC BUS ISOLATED != DC BUS DISCHARGED != ABSENCE OF VOLTAGE VERIFIED != MECHANICAL/GRAVITY ENERGY CONTROLLED`.

A locally disabled/disconnected drive cannot be assumed electrically dead when a documented shared-DC-bus, regenerative, externally driven motor, auxiliary-supply, or other energy path exists. HMI/LED state is not physical absence-of-voltage proof.

## Evidence status

- SOURCE-CONFIRMED: STO can leave DC-bus/mains voltage present; external motor forces can regenerate to a drive; common DC buses exchange braking energy; manufacturer service procedure requires physical DC-bus voltage verification rather than relying on an LED.
- DOC-CONFIRMED: repository Lane-B stored-energy boundary is now extended into multi-drive/common-bus service isolation.
- TEST-CONFIRMED: none.
- COMMUNITY-REPORTED: none relied upon.
- INFERENCE: OpenPressBrake should keep motion-safety authority, operational power state, and maintenance/service isolation proof as separate concepts.
- UNKNOWN: actual OpenPressBrake drive/common-bus topology, discharge behavior, measurement points, auxiliary supplies, regeneration capability, thresholds/times and hydraulic/gravity state.

## Precise next independent work

Trace an authoritative professional multi-drive/common-DC-bus chain exposing **mains disconnect(s) -> line/regenerative supply -> precharge -> shared DC link -> individual inverter(s) -> STO -> braking/regeneration path -> discharge/voltage-measurement points -> maintenance isolation -> return to service**.

If primary safety work reaches that evidence package first, rotate Lane B to **separate 24-V/control-supply backfeed across an open isolation boundary** or **gravity-axis brake/load-retention sequencing**. Do not duplicate the primary lane's hydraulic Y1/Y2 discrepancy files.
