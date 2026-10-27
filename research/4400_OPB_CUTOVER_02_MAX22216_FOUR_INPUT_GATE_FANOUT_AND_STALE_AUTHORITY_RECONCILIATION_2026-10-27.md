# 4400-OPB-CUTOVER-02 follow-up — source precedence: actual Rev 1 four-input hardware permit and two MAX22216 ENABLE sinks

**2026-10-27 | second original cross-repository implementation-source audit | documentary-only, no bench or machine test**

## Why this follow-up matters

The [first endpoint audit](4400_OPB_CUTOVER_02_PILZ_MUTE_GATE_POWER_DOMAIN_CROSS_REPOSITORY_SOURCE_AUDIT_2026-10-27.md) established wire 75 as a **design-intended** proportional hardware gate. That is too coarse for implementation review. A deeper read of the current OpenPressBrake board-integration authorities reveals **exact aggregation logic, source precedence, fanout and remaining field-conditioning blockers**. It also exposes a **real historical document/version trap**: an older prose equation includes `ENABLE_PATH_HEALTHY` as a fifth Boolean input, while the current machine-readable schema v3 explicitly removes that circular term.

This is **new exact implementation evidence**, not new personnel-safety authority. The safety-course [FS-IF contract](../hardware/SAFETY_BLOCK_INTERFACE_CONTRACTS.md) and generic cutover lesson already teach the principle.

## Directly inspected sources (Git blob identities)

| Source | Evidence at inspected revision | Narrow result |
|---|---|---|
| [`REV1_OUTPUT_INHIBIT_AUTHORITY.yaml`](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/integration/REV1_OUTPUT_INHIBIT_AUTHORITY.yaml), blob `91e1a64c502c8cd7001b8c13d0933f591b824147` | schema_version **3**, status `BOARD_INTEGRATION_BASELINE_AGGREGATION_FROZEN` | **Current machine-readable four-input gate authority**, candidate TI AND3/AND2, 100 kΩ fail-low biases, two MAX22216 sinks, and explicit implementation-proof OPEN |
| [`REV1_OUTPUT_INHIBIT_AUTHORITY_CHECKPOINT.md`](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/integration/REV1_OUTPUT_INHIBIT_AUTHORITY_CHECKPOINT.md), blob `96c3cc32a15f05be2f7385018a7581c93521343d` | earlier 2026-09-18 prose | Historical equation adds `ENABLE_PATH_HEALTHY` as if Boolean; do **not** use as current truth table |
| [`REV1_PILZ_VALVE_ENABLE_FANOUT_AUTHORITY.yaml`](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/integration/REV1_PILZ_VALVE_ENABLE_FANOUT_AUTHORITY.yaml), blob `b7680f1bc8e0af0a8c9a6335af57344243b62758` | one physical X14/2 pin/wire 75, two downstream consumers | One conditioned hardware-permit input **plus one ordinary diagnostic digital-input instance**; diagnostic path cannot feed/override the permit |
| [`REV1_PROPORTIONAL_ENABLE_FANOUT_CONTRACT.md`](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/integration/REV1_PROPORTIONAL_ENABLE_FANOUT_CONTRACT.md), blob `0c0d5fa48cc81dbdc334d31d0673088299fb1fa4` | exact two-device fanout, manufacturer ENABLE semantics, open qualifier | Hardware permit to **both** MAX22216 ENABLE pins; field 75 conditioning and voltage/polarity still VERIFY_AT_MACHINE |
| [`REV1_SCHEMATIC_RELEASE_GATE_MATRIX.md`](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/integration/REV1_SCHEMATIC_RELEASE_GATE_MATRIX.md), blob `c2fec1ba56e7fd935d4fa4c5485de926064eda5f` | schematic-release gate | Output-enable **contract frozen, implementation proof OPEN**; no physical safe-state or machine release claim |

**SOURCE-CONFIRMED** means the repository's published design contract actually says these things. It does **not** mean the gate was built, wired, electrically tested, safety-rated, or verified on the machine.

## Correct current ordinary-control Boolean contract

```text
HARDWARE_OUTPUT_ENABLE =
  PILZ_VALVE_ENABLE_LOGIC
  AND WATCHDOG_OK
  AND FPGA_CONFIGURED
  AND CORE_POWER_GOOD
```

- `PILZ_VALVE_ENABLE_LOGIC` is the **conditioned logic-domain representation** of physical wire 75; the actual 24 V-class field voltage, polarity, any interposing inversion or test pulses are **VERIFY_AT_MACHINE**.
- Proposed aggregator: TI `SN74LVC1G11` three-input AND then `SN74LVC1G08` two-input AND; each input, intermediate node and final permit has a declared 100 kΩ fail-low bias. Exact orderable pin mapping and rendered schematic remain OPEN.
- One `HARDWARE_OUTPUT_ENABLE` drives **two MAX22216 ENABLE pins**, with a separate local fail-low pull-down at each IC. SPI `CNTL` bits are **not** a substitute.
- The **diagnostic observation** of wire 75 is a separate ordinary digital-input consumer. It cannot synthesize a hardware permission or become a safety witness.
- The contract requires safe driver startup/configuration/readback and a **fresh current command** after re-enabling. Stale SPI command restoration is explicitly prohibited.
- `ENABLE_PATH_HEALTHY` is **implementation-health evidence**, not a fifth input. The v3 authority explicitly corrects the earlier circular equation.

**Do not assert** that the selected gate's physical timing, leakage, fault coverage, electrical thresholds or fail-safe performance is TEST-CONFIRMED. The cited TI logic and MAX22216 semantics are **reported in project integration authority** here; their datasheets and fabricated schematic were not independently re-verified in this follow-up.

## Seven negative source-review cases — no energized fault injection

| Case | Counterfactual source/implementation change | Required review disposition |
|---|---|---|
| F1 | Renderer copies the older five-term `ENABLE_PATH_HEALTHY` equation | Reject stale source precedence; use v3 four-prerequisite truth contract, separately review path health. |
| F2 | Physical wire 75 is connected directly to 3.3 V LVC gate | Block: field polarity/voltage and conditioning not established; risk of interface damage or false state. |
| F3 | Wire 75 goes only to diagnostic input; hardware permit is sourced from FPGA status | Block: ordinary software now substitutes for physical prerequisite. |
| F4 | Aggregator drives MAX22216 U1 only, not U2 | Block: second device can retain ordinary command authority; exact both-sink fanout must be reviewed. |
| F5 | One shared remote pull-down replaces the local fail-low pull-down at each ENABLE pin | Reopen power-loss/open-circuit/assembly fault reasoning; cannot claim manufacturer-local fail-low behavior. |
| F6 | SPI re-enable resumes an old nonzero command without safe configuration/readback/new request | Block stale-command restart; verify normal-controller recovery independently of safety reset. |
| F7 | Renderer/bench verifies Boolean gate while the Pilz safety program or hydraulic final elements remain unknown | Credit only the ordinary inhibit proposition; **do not** upgrade G0/G1 or personnel-safety claims. |

All seven are **DESK REVIEW EXERCISES / NOT RUN**, not lab results. An actual test would need a frozen, bounded unresolved electrical question and the local self-hosted runner only; there is no justified compute question here because the authoritative design already states the logic and the remaining blocker is physical machine input evidence.

## Separate source-version caution: X-axis command envelope

The older [Rev 1 I/O map](https://github.com/Bensend/OpenPressBrake/blob/main/docs/IO_MAP.md) describes a `+/-10 V` X-axis command. The later [schematic-release gate matrix](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/integration/REV1_SCHEMATIC_RELEASE_GATE_MATRIX.md) explicitly says this direct bipolar T4 assumption was **superseded** by a manufacturer-backed **0–10 V** Commander SK T4 contract, while installed T4/B5/B6 parameterization remains OPEN. **SOURCE-CONFIRMED source-precedence conflict, not a verified drive response.** This illustrates why an old field map must not silently override a later integration authority. Routine X-axis analog-output design remains with the separate board-development lane; safety reviewers must still establish independent X-drive stopping via retained Pilz wire 63 and actual physical witness.

## Machine evidence and release

**Still UNKNOWN:** actual wire 75 electrical class and polarity; conditioning component; assembled PCB netlist; every MAX22216 ENABLE physical response; actual Pilz safety program; Y1/Y2 stop/hold and hydraulic isolation; X-drive safe behavior; guarding/muting; reset/start; PL/SIL and stopping limits.

**Next:** qualified restricted Stage A evidence plus [eight-field exact delta card](../safety-course/4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md); inspect current board netlist against the four-input contract when the board lane has produced it. Never infer that passing ordinary logic checks proves personnel safety. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No GitHub-hosted or local compute, no physical tests, no evaluator score.

## Further same-session source-precedence audit: old netlist is explicitly quarantined

A second direct read found that [`REV1_NETLIST_STALE_AUTHORITY_GATE.md`](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/integration/REV1_NETLIST_STALE_AUTHORITY_GATE.md), blob `9af31fb6d4a08827e2c6f5befda67d90defebd0e`, explicitly marks `hardware/rev1_schematic/NETLIST_CONTRACT.yaml` **NOT SAFE TO RENDER AS-IS** because of retired proportional-current ADC ownership and other stale fields. The current [`REV1_NETLIST_CONTRACT_RECONCILIATION.yaml`](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/integration/REV1_NETLIST_CONTRACT_RECONCILIATION.yaml), blob `8aeadcea45d4db797fb4dd782e6b29cd9cc4f630`, provides field-level precedence: `HARDWARE_OUTPUT_ENABLE` must feed both MAX22216 ENABLE pins, no host-only permit; direct bipolar T4 command must not render; automatic chassis/return bonds must not be invented. The [safety-interface block checklist](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/blocks/safety_interface/STATUS_CHECKLIST.md), blob `2f12be48e4b82523dbb62f11894283f49b765679`, still says **BEHAVIORAL ONLY / NOT SCHEMATIC-READY**. These are **SOURCE-CONFIRMED repository statuses**, not independently executed renderer checks.

**New integration gate F8 (DESK REVIEW / NOT RUN):** refuse any full-board schematic that directly consumes the quarantined legacy netlist without the reconciliation authority, even if its wire-75 net looks present. Require exact current field-to-gate-to-both-sinks connectivity, the separate diagnostic consumer, no L07/L06 bridge, and no invented PE bond. This gate is **not** a claim that the current renderer already violates the rules. The board-design lane owns the actual netlist correction and any bounded self-hosted validation; this safety curriculum records the independent authority/witness boundary.
