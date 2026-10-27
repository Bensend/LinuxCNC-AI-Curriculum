# 4400-AKAS-M-01 — restricted existing-records review delta (LC-II M / Pilz)

**2026-10-27 | NOT a test instruction, commissioning permit or new evaluator challenge.** Applies only if [Stage A](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) establishes the actual LC-II M / retained-Pilz architecture. Source: [manufacturer-variant audit](../research/4400_AKAS_LCII_M_PILZ_MUTING_SLOW_SPEED_OVERTRAVEL_AUTHORITY_AUDIT_2026-10-27.md). Do not upload proprietary program, wiring, serials or sensitive photos to this public repository.

## One-pass reviewer packet — add to existing OPB-D02, not another questionnaire

| Existing Stage A / D02 dependency | Restricted record to identify | Evidence status |
|---|---|---|
| A/C/E, OPB-D02 | Installed AKAS M/F exact model, document number/edition, safety PLC model and signed active program/export revision; reconcile drawing 16 to physical installation. | **UNKNOWN** |
| C/E, OPB-D01/D02 | Qualified *source-to-sink* trace: normal CNC wire 44, separate AKAS wire 402, actual PLC logic, any LC-II M FUS/FUO, SGS/SGO/SP, OSSD1/2. Mark each signal **request, independently checked condition, safety output or ordinary diagnostic**. | **UNKNOWN** |
| C/F, OPB-D02 | What independent speed/position and contactor/valve transition evidence prevents a stuck or replayed normal mute request from suppressing protection? Document mode, fault, stale-input, setup-exit and reset behavior from the actual safety application. | **UNKNOWN** |
| F/G, OPB-D08 | Exact selected manufacturer overrun-test requirement, implementation owner, machine-specific acceptance basis, reset/interval handling and historical test witness. A PLC timer or HMI green lamp alone is not a physical stopping-distance witness. | **UNKNOWN** |
| B/D/E/F/G, OPB-D05/D08 | Actual OSSD-to-Pilz-to-physical-final-element path, independent Y1/Y2 stop/hold, hydraulic isolation, guard coverage, tool-change usability and deliberate fresh start. | **UNKNOWN** |

**Reject three shortcuts:** (1) a wire labeled MUTE is not a qualified safety function; (2) the generic Pilz conveyor-muting function block is not proof of the installed press-brake program; (3) a manufacturer LC-II M **2011** example's 10 mm / <10 mm/s / 30 h values, or an F-family 24 h example, are not as-built acceptance measurements or universal standards.

**Progress semantics:** RECEIVED means only that an artifact exists. A qualified reviewer may mark REVIEWED/CONTRADICTORY/STALE with revision, reviewer role and linked restricted evidence; only independently reviewed consistent selected-machine records may inform G0. G0 itself is documentary readiness, not G1 test permission or G2 physical validation. Missing critical proof is **HOLD**, not N/A. An N/A requires dated qualified evidence that the conditional device/path is absent. Public handoff is status-only.

**Safety and human factors:** No live muting, guard bypass, fault injection, overrun stroke or hydraulic pressure test is authorized here. Make alignment, diagnostic access, guarded setup and reset simple enough that technicians do not feel compelled to defeat the safeguard. **G0/G1 HOLD; no personnel-exposed hazardous operation.**
