# 4400 OPB-XREADY-01 — fixed-high “AMPLIFIER OK” is power presence, not drive health

**Study:** 2026-10-29 UTC | **Status:** SOURCE-DEPTH / NON-GRADUATED / NO MACHINE TEST | **Machine:** proposed OpenPressBrake Rev1 ERMAK/Cybelec replacement | **Safety release:** G0/G1 HOLD.

## Precise engineering question

Can a retrofit safely use the legacy DNC J16/4 signal labeled `AMPLIFIER OK.` as a dynamic X-drive ready/healthy permissive or as a witness that the backgauge has stopped?

**Answer from the published Rev1 mapping: no.** The source mapping explicitly connects J16/4, wire 9, to the **L9 +24 V controller supply**, not to a verified changing drive fault contact. A label does not transform a power-feed observation into drive health, drive torque removal, standstill or personnel-safety evidence. This is an exact **source-derived endpoint distinction**, not a physical test or verification of the installed harness.

## Inspected public source provenance (not private machine drawings)

| Source / immutable Git blob in Bensend/OpenPressBrake | Direct observation | Claim class |
|---|---|---|
| `hardware/REV1_CONNECTOR_MAP.yaml` @ `4d1d5df43627964c91737f8936855e2f2dd35f0e` | J16/4: `wire: 9`, `net: L9`, `direction: power_presence`, `function_label: AMPLIFIER_OK`, note forbids invented dynamic feedback; J16/6 and /7 are ordinary X direction outputs; wire 63 Pilz→B4 bypasses ordinary board. | SOURCE-CONFIRMED *published contract* |
| `hardware/REV1_MACHINE_CONFIG.yaml` @ `2272a4e1dfd50e467d702a69a11224333be59f2b` | `X_DRIVE_J16_PIN4_SEMANTICS` = `SOURCE_LABEL_ONLY`; `dynamic_field_status: false`; X command ±10 V, wires 125/126, index 132 and independent wire 63 enumerated. | SOURCE-CONFIRMED *published contract* |
| `docs/IO_MAP.md` @ `e73ef3f24888854eb70582c353f2b3b621a32eac` | J16/4 is “tied to 24 V” and specifically says no dynamic drive feedback inferred. J16/6→4K10→B5; J16/7→5LS2→B6; Pilz wire 63→B4. L9/L06 is distinct from 11K2-switched L7/L07. | SOURCE-CONFIRMED *published map* |
| `docs/REV1_DNC_PVR_ENDPOINT_AUDIT.md` @ `717e7a07ab2d170b7727bb19c06734f5b31f83aa` | Repeats the source-derived J16/4 interpretation and independent power domains. | SOURCE-CONFIRMED *published audit* |

These are **source-derived public project descriptions** of legacy drawings, not direct inspection of an installed drive, live wire, safety PLC program or complete original OEM drive manual. No selected drive catalog/firmware/revision, actual fault relay, actual B4 behavior or as-built wiring was established here. Do not assert that the original DNC used the signal as a permissive; only the label and mapped connection are established.

## Failure-path discrimination (paper reasoning, NOT observed behavior)

| Hypothetical state | J16/4 / L9 expectation from mapped source | What it **cannot** prove | Required independent evidence |
|---|---|---|---|
| L9 present; drive internally faulted | Could remain high because J16/4 is mapped to L9, not a drive fault contact. | Drive healthy, output torque available/removed, standstill. | Exact drive model/manual, genuine fault/ready terminal and as-built mapping; selected physical stop witness. |
| L9 present; 11K2 removes switched L7/L07 | J16/4 can remain high while ordinary field output power is absent. | X-direction output effective, safe stop, reset eligibility. | Separate switched-domain validity, independent wire63/drive final-element evidence. |
| L9 present; Pilz wire 63 withdraws B4 drive enable | J16/4 can remain high; it is not a B4 monitor. | Actual drive disable/torque state, backgauge stopped. | Qualified selected-drive B4 truth, independent stop witness and restart controls. |
| L9 present; 4K10 or 5LS2 opens one direction path | J16/4 need not change. | Both directions inhibited, all hazards absent, final-element integrity. | Actual switch/contactor contact map and failure analysis; physical motion witness. |
| L9 present; X encoder disconnected/stale | J16/4 can remain high. | X position valid or backgauge stationary. | Encoder validity/staleness checks as ordinary diagnostics; independent protective function. |
| L9 absent | J16/4 may be low or unpowered, but receiver validity depends on actual circuit. | Drive fault *or* safe state. | Source/receiver rail validity, independent safety evidence. |

**INFERENCE** rows are conditional; no electrical levels, timing, stopping distance, PL/SIL, physical holding or fault coverage are assigned. `L9 HIGH` is not a diagnostic for `L7/L07 VALID`, `B4 SAFE`, `DRIVE READY` or `X STOPPED`. Distinguish four propositions: **power present**, **drive operational status**, **safety function commanded/monitored**, **physical motion/energy state**. They require different witnesses.

## Human-factors and implementation handoff

- Keep J16/4 labeled **“L9 controller 24 V presence (legacy label AMPLIFIER OK; NOT drive-ready)”** in any ordinary I/O inventory. Do not expose it to an HMI as green “X drive OK,” count it in a safety status aggregate, or use it to auto-rearm.
- If dynamic X drive fault/ready feedback is desired, **do not repurpose an unverified legacy pin**. Identify the exact installed drive and manufacturer terminal/behavior, document wiring/validity/power-loss semantics and allocate a separately qualified ordinary diagnostic input. This is not permission to modify the independent Pilz circuit.
- Show **UNKNOWN/UNAVAILABLE** when validity is not established. Make safe, passive existing-record review easier than tempting a technician to open a cabinet or trigger a cycle for a green status.
- Preserve Pilz wire 63 direct-to-B4 as the *published intended independent path*, but do not call it a validated stop function until the installed safety application, drive function, actual stopping and restart are qualified. Keep Y1/Y2 independent hydraulic holding separately unresolved.

## Predecessor comparison and incremental value

- [OPB-CUTOVER-02](4400_OPB_CUTOVER_02_PILZ_MUTE_GATE_POWER_DOMAIN_CROSS_REPOSITORY_SOURCE_AUDIT_2026-10-27.md) established the 11K2 switched-domain and independent Pilz/FPGA authority split.
- [OPB-ISO-03](4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md) established STISO/IPS driver fault validity and the two-pole 11K2 cases.
- [OPB-ARCH-AUTH-01](4400_OPB_ARCH_AUTH_01_README_ARCHITECTURE_SAFETY_AUTHORITY_AND_BENCH_SERVICE_SOURCE_CORRECTION_2026-10-29.md) corrected top-level installed-authority and service-mode claims.

**Incremental discriminator:** a **specific legacy J16/4 label** looks like a dynamic amplifier-health signal but the published electrical map says it is **fixed to L9 power**. The previous 11K2/FLT audits do not establish this J16/4-specific false-ready failure path. This is a source-depth/human-interface correction, **not** a new safety competency, physical test, machine defect finding or new owner questionnaire.

## Qualified next evidence and release boundary

Stage A A–G existing records remain the first dependency: selected Pilz/AKAS and safety program, 11K2/63/75, actual drive model and protective final elements, guard/restart behavior, physical Y1/Y2 stop/hold, stored-energy control and independently witnessed no-exposure tests. Ask for existing dated records, not new energized measurements under a public checklist. If the exact X drive is later selected, reconcile its original manual with the B4 function and independent protective stop; do not invent a safety rating from the terminal name. Physical G1/G2 validation needs a separately approved qualified plan, not this paper matrix.

**Evidence:** SOURCE-CONFIRMED public repository mappings; INFERENCE conditional failure cases/HMI guidance; UNKNOWN installed wiring, actual X-drive health, Pilz application, stop/hold and human adoption; TEST-CONFIRMED **none**. No workflow, build, simulation, machine operation or lab compute. **G0/G1 HOLD; no personnel-exposed hazardous operation.**
