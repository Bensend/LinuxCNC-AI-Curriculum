# 4400-OPB-CUTOVER-02 — restricted Stage B delta card: six Pilz inputs, two direct enables and switched returns

**2026-10-27 | blank evidence request; NO machine evidence received | NOT a physical test plan or commissioning permission**

Use **only after** the [one-page Stage A A–G request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) establishes that this Rev 1 Pilz/DNC/PVR architecture actually applies. This card requests **existing** as-built documents in a restricted machine workspace. Do not publish machine wiring, Pilz application, serials, credentials, safety test procedures or personal information in the public curriculum.

| Delta ID | Exact unresolved design claim | Minimum restricted evidence / qualified reviewer question | Current state |
|---|---|---|---|
| OPB-D01 | DNC→Pilz inputs wires 42–47 | As-built Pilz application/export, program/version identity and input terminal map. For each input, classify request vs safety-credited condition; polarity, qualification, transition and stale/fault response. | UNKNOWN |
| OPB-D02 | Wire 44 MUTE COMMAND | Which installed AKAS/guard mode and independent sensor/position/speed conditions qualify any muting? Does held/high/replayed command fail safe? Do not assume that this signal alone mutes. | UNKNOWN |
| OPB-D03 | Wire 45 CNC OK | Is the condition static, edge-qualified or freshness-checked by the actual safety program? Which failure paths are detected? | UNKNOWN |
| OPB-D04 | Wire 75 Pilz→PVR gate | Revision-matched schematic/parts show independent hardware dominance over all intended proportional current stages, including boot, unconfigured FPGA and common-power faults. Physical stop/hold still separately unproved. | UNKNOWN |
| OPB-D05 | Wire 63 X-drive and Pilz-owned 11Y4/11Y6/11Y8 | As-built route to X drive B4; retained direct Pilz valve outputs and proving wires 30–32; explicit no-migration to normal FPGA. | UNKNOWN |
| OPB-D06 | 11K2 switched L7/L07 | Both poles, 0 V/reference, return paths and proposed PCB wiring; show no bypass via L07–L06, shield, instrumentation or alternate supply. | UNKNOWN |
| OPB-D07 | PVR X2 and duplicated wire 111 | Physical high-current return/harness and contact ratings; signed distinction between Y2S2 wire 111 and X encoder wire 111. | UNKNOWN |
| OPB-D08 | Physical function and fresh restart | For each hazard, exact final element, independent stop/hold/pressure/guard/energy witness, and separate reset vs new start; qualified remote/isolated proof concept. | UNKNOWN |

**Public status-only handoff:** `OPB-Dxx | source revision hash | qualified reviewer role | hazard/SF ID | RECEIVED/REVIEWED/CONTRADICTORY/UNKNOWN/STALE | next restricted evidence ID | date`. An upload is **RECEIVED/UNREVIEWED**, never automatically PASS. Mark N/A only when dated as-built evidence proves the conditional item absent. If any claim conflicts, mark **CONTRADICTORY / HOLD** and reopen affected `AUTH/DEP/ARC/PHY/VAL/CHG` records.

**Review sequence:** match exact machine revision and Pilz program; review input trust and final-element independence; trace switched returns and hard inhibits; reconcile physical energy and load restraint; review usability; then decide whether G0 documentary readiness can advance. G0 never grants G1/G2 or personnel-exposed operation.

**Status:** G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No machine evidence, independent evaluation or physical validation has been received. See [source audit](../research/4400_OPB_CUTOVER_02_PILZ_MUTE_GATE_POWER_DOMAIN_CROSS_REPOSITORY_SOURCE_AUDIT_2026-10-27.md) and [technician module](4400_OPB_CUTOVER_02_PILZ_MUTE_GATE_POWER_DOMAIN_FIELD_REVIEW_2026-10-27.md).
