# Lane B checkpoint — safety fieldbus black-channel authority

Date: 2026-09-18T14:49Z

## Durable work

Created `safety-course/SAFETY_FIELDBUS_BLACK_CHANNEL_IDENTITY_FRESHNESS_AUTHORITY_STUDY_2026-09-18.md` in commit `dc1c71c88560fe63548d80151bde6d170e1b89d8`.

This branch is independent of the primary lane's newest accessible-cell power-loss / escape / restart work.

## Freeze

`ETHERNET LINK UP != SAFETY CONNECTION VALID != SAFETY PEER IDENTITY VALID != SAFETY TELEGRAM FRESH != SAFETY DATA VALID != SAFETY APPLICATION PERMISSIVE != FINAL ELEMENT PROVEN IN SAFE/EXPECTED STATE.`

`ORDINARY NETWORK TRANSPORT HEALTH != PERSONNEL-SAFETY AUTHORITY.`

Manufacturer/protocol evidence from PI PROFIsafe, Rockwell CIP Safety, and Beckhoff FSoE shows the reusable architecture: standard network infrastructure may be treated as a black channel because safety endpoints/protocol add identity, freshness/timing, sequence/connection state, and integrity defenses. An ordinary Ethernet/fieldbus exchange is not an equivalent safety channel.

## Provenance state

SOURCE-CONFIRMED: PROFIsafe black-channel architecture and F-message sequence/watchdog/address/CRC measures; CIP Safety end-node-to-end-node black-channel architecture and unique node/SNN identity; FSoE black-channel architecture and exposed safety address/connection/watchdog/unique-device parameters.

INFERENCE: ordinary LinuxCNC/HAL/FPGA networking can coexist with a safety channel but must not become personnel-safety authority merely by transporting or observing the same semantic data.

UNKNOWN: all OpenPressBrake-specific safety-protocol selection, endpoints, identities, watchdog timing, safe substitute values, recommissioning procedure, PL/SIL/category/DC/CCF, and network/topology acceptability.

No TEST-CONFIRMED or COMMUNITY-REPORTED claims were promoted in this pass.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.

## Parallel-work check

Immediately before the substantive write, `main` still ended at primary checkpoint `d85b9ef6bea034e69974be4585a56242b722b3c9`. After the substantive write, `dc1c71c88560fe63548d80151bde6d170e1b89d8` was directly above it; no intervening overlapping write appeared. Lane B did not modify the primary lane's accessible-cell files or `PROGRESS.md`.

## Exact next work

Find one authoritative complete implementation where standard and safety traffic share physical infrastructure and trace:

`safety sensor -> safety endpoint -> safety protocol identity/freshness/integrity -> black-channel infrastructure -> receiving safety endpoint -> safety output/final element -> communication fault -> safe reaction -> recovery/rearm -> separate ordinary motion/start authority`.

Prefer evidence that also exposes wrong-device identity, replacement/recommissioning, copied-project/network-number hazards, or recovery after safety communication loss. Preserve OpenPressBrake-specific physical/performance facts as UNKNOWN until measured or documented.