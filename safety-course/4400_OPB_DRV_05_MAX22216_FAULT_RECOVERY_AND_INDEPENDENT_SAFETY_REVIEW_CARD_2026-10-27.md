# 4400-OPB-DRV-05 — driver fault/recovery review without granting the driver safety authority

**2026-10-27 | One-pass practical reviewer card | NON-GRADUATED | NO ENERGIZED TEST**

**Use after:** [original MAX22216 Rev. 2 source audit](../research/4400_OPB_MAX22216_FAULT_AUTORECOVERY_CRC_STALE_COMMAND_AND_ENABLE_EVIDENCE_AUDIT_2026-10-27.md), [four-input wire-75 hardware-permit audit](../research/4400_OPB_CUTOVER_02_MAX22216_FOUR_INPUT_GATE_FANOUT_AND_STALE_AUTHORITY_RECONCILIATION_2026-10-27.md), and the [restricted OPB-D01..D08 card](4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md). This is an incremental manufacturer source-depth card, **not** another public scored challenge bank.

## Four independent questions for the qualified reviewer

| Question | What the ordinary MAX22216 can report/do | What remains separate and must be independently justified |
|---|---|---|
| **Did a driver report a fault?** | Active-low open-drain `N_FAULT`; SPI STATUS and per-channel flags. Some indications may be masked or cleared on ENABLE-low; a hit-current fault need not turn a channel off. | Was the report captured before inhibit? Which channel/fault and which valid supply/communication state? No fault bit is proof of ram safety. |
| **Did a normal command take effect?** | CRC-enabled bad SPI write is rejected, preserving prior configuration; COMER appears in the next status. Read data is pipelined to a later transaction. | Did the firmware actually confirm the intended OFF/current setting? If not, ordinary control must fail inactive by design; independent Pilz/final elements still own personnel safety. |
| **Can it resume after a fault or power dip?** | OVT automatically resumes after cooling; VM undervoltage tri-states outputs but can preserve logic registers until digital POR; ENABLE reassertion requires a valid startup sequence. | Is the **actual** safety program still withholding hazardous energy? Does a separate deliberate new start follow physical guard/occupancy/stop/hold verification? |
| **Does ENABLE LOW make the machine safe?** | Manufacturer-defined driver disabled state; project requires fail-low at **both** MAX22216 ENABLE pins, conditioned wire 75 and four-input hardware gate. | Hydraulic valves/ram may have independent load/pressure hazards. Wire 75, 11K2, Pilz/AKAS, guards, final elements and physical witnesses remain a distinct safety case. |

## No-bypass review sequence (documents only)

Compare the **current** as-built/board authority to the manufacturer Rev. 2 datasheet and project schema v3. Trace the conditioned wire-75 input, both ENABLE sinks, local pull-downs, `CRC_EN` straps, two independent `N_FAULT` pull-ups and SPI readback. Check that a thermal auto-recovery or rejected SPI write cannot silently reinstate a stale normal command. Identify how the normal diagnostic log records a fault **without holding ENABLE high** or postponing independent inhibit. Do not attempt a hot-wire, forced-fault, shorted-contact or hydraulic test from this card.

For maintainability, show technicians **why a fault disappeared** (`driver reset / log not retained / diagnostics invalid`) rather than a misleading green `healthy` light. Make a supported replacement/backup and fault-history retrieval simpler than bridging a wire or bypassing the guard. Never offer a `force safe`, `force valve` or `override Pilz` HMI control.

**Scope:** source/manufacturer evidence only. No actual OpenPressBrake machine proof, no hardware timing, no test-confirmed driver state, no new PL/SIL or pressure/stopping limits. Existing G0/G1 **HOLD**, G2 **NOT RUN**, G3/G4 **NOT AUTHORIZED**, G5 **HOLD**; independent 2520–25F0 evaluator remains NOT RUN. People must not be exposed to hazardous operation until the independent safety case is validated.
