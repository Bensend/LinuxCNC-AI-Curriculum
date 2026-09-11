# Active Curriculum Session State

Session start UTC: `2026-09-11T14:13:50Z`
Session end UTC: `2026-09-11T14:20:17Z`
Actual elapsed: **6.5 minutes**
Status: **CLOSED — 3600 dependency-safe hydraulic-mode architecture research advanced; no new lab job launched.**

Results: bounded source audit confirms the proposed Ursviken/Pullmax `press-state -> motion_type_cmd -> machine-specific decoder` architecture, including a distinct pressure-dump mode, remains a COMMUNITY-REPORTED INTERFACE CONTRACT because the final executable decoder/HAL is still unavailable. Added adjacent `powerchuck` evidence showing a one-servo-period output-age boundary when the interlock component is scheduled after `hm2.write`. Added executable lubrication evidence for `command -> pressure witness -> fault`, plus an adversarial finding that blocking userspace `sleep()` turns machine/spindle authorization into an entry-only check during the wait. Pinned `timedelay.comp` confirms realtime persistence qualification but not fault policy. Consolidated these findings into a hydraulic-mode transition review matrix for halt, fast approach, slow bend, dwell, decompression, return and homing.

Next checkpoint: inspect one executable realtime LinuxCNC state machine with a nontrivial process transition where an active state continuously rechecks an interlock/fault and a physical completion sensor drives transition. Score its evidenced/missing surfaces against `research/press-brake-hydraulic-mode-transition-review-matrix-2026-09-11.md`, including exact function scheduling and hardware-write order. If one bounded search does not find stronger hydraulic source, stop source hunting and formalize the 3600 source-quality/evidence gap plus a generic mode-ownership simulation contract rather than simulating machine-specific valve dynamics. Preserve S02/E20/X01/X02 fresh-AI separation, F02 block and PB-PREP-001 INCONCLUSIVE.

Overlap: **No overlap.** Previous canonical lesson ended `2026-09-11T13:12:28Z`, **61m22s** before this session began.

Timing append requested through the repository's race-safe `TIMING_APPEND_REQUEST.txt` workflow; requested row uses 3600 active numbering.
