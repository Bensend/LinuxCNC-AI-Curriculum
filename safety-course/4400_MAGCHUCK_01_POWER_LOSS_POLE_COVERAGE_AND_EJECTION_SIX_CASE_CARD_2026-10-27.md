# 4400-MAGCHUCK-01 — Magnetic workholding six-case physical retention card

**Status:** PUBLIC PAPER only, six scenarios **UNSCORED**, eight documentary gates **NOT RUN**. Read [direct HSE/Walker/Walmag source audit](../research/4400_MAGCHUCK_01_HSE_WALKER_WALMAG_POWER_LOSS_CONTACT_AND_EJECTION_SOURCE_AUDIT_2026-10-27.md). Applies only if a selected machine uses a magnetic chuck; OpenPressBrake applicability UNKNOWN.

## Six cases for an independent fresh learner

For each, identify `BND/ENE/HAZ/SF/PHY/AUTH/DEP/HF/CHG/VAL/UNK`, state which proposition is proven and which is not, and select the first safe documentary or isolated inspection step. Do not treat this public exercise as a blind evaluation.

1. **MAGC-P01 — Outage does not release.** An electro-permanent chuck retains its field after power loss, and the operator assumes the part is safe to touch. Separate magnetic retention, residual crush attraction, motion standstill and maintenance access.
2. **MAGC-P02 — One-pole trap.** A narrow steel part contacts only one pole and the HMI reports magnet ON. Identify the exact physical contact/fixture problem before any grinding.
3. **MAGC-P03 — New alloy.** A fixture proven on low-carbon steel is reused for hardened alloy steel. Why does the prior holding witness become stale even though part dimensions and program are unchanged?
4. **MAGC-P04 — Dirty face.** A burr/rust patch creates an air gap; the operator compensates by reducing feedrate. Explain why normal program adjustment is not a verified substitute for adequate holding and ejection protection.
5. **MAGC-P05 — Technology swap.** A powered electromagnetic chuck is replaced by an electro-permanent unit without updating stop/release/maintenance instructions. What changes on power failure and deliberate demagnetization? Do not assume either behavior without exact selected evidence.
6. **MAGC-P06 — Green feedback after maintenance.** The machine shows 'clamped', but a pole extension is missing and a guard was removed for access. Explain why the correct release action is HOLD until physical restoration, independent witness and fresh restart.

## Eight conditional verification gates — ALL NOT RUN

| Gate | Evidence | Status |
|---|---|---|
| MAGC-G01 | Exact chuck model, permanent/electromagnetic/electro-permanent technology, manuals and installation recorded. | NOT RUN |
| MAGC-G02 | Workpiece alloy/magnetic properties, thickness, pole coverage, geometry, surface/air gap and location established. | NOT RUN |
| MAGC-G03 | Actual machining forces, shear/normal holding, stops/fixtures and ejection trajectories competently assessed. | NOT RUN |
| MAGC-G04 | Power-loss, restart, commanded OFF and unintended release behavior allocated to actual selected hardware. | NOT RUN |
| MAGC-G05 | Independent physical workpiece-retention evidence and correct guard/enclosure condition documented. | NOT RUN |
| MAGC-G06 | Magnetic attraction/crush and residual force during maintenance isolated/managed with safe part support. | NOT RUN |
| MAGC-G07 | Guard, pole extension and stop installation is practical and resists predictable bypass; fresh deliberate rearm validated. | NOT RUN |
| MAGC-G08 | `CHG` trigger for part alloy, dimensions, surface, chuck technology, fixture, spindle program, guard or maintenance procedure; dependent `VAL/PT` marked STALE. | NOT RUN |

## Authority and release

Ordinary LinuxCNC/FPGA 'magnet ON', 'spindle disabled' or E-stop is **not** physical workpiece-retention proof. A permanent magnet can retain dangerous attraction after electrical isolation; an electromagnetic chuck may have different power-loss behavior. No actual chuck, part, selected safety circuit, holding force, PL/SIL, test or external evaluator has been identified here. **Do not run exposed-person machining if holding or ejection protection is unresolved.** Remote testing is not a shortcut around ejection-zone exclusion and competent physical validation. No lab or Actions compute.
