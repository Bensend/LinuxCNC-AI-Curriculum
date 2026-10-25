# 4400-SD-02 — One device, different rated functions: AZM40 interlock vs guard lock
**2026-10-25 | Exact Schmersal part 103037334 | SOURCE: manufacturer product data, directly opened | NON-GRADUATED**

## Frozen question
Can a manufacturer's high-rated **interlocking** function be assumed to establish the same performance level for its **guard-locking** function, and does an ordinary diagnostic warning imply that safety outputs are already OFF?

## Original exact-part evidence
- Schmersal official product page for **AZM40Z-I1-ST-1P2P-PH**, order no. **103037334**: https://products.schmersal.com/en_US/azm40z-i1-st-1p2p-ph-103037334 . Directly opened 2026-10-25. The manufacturer's separately labeled safety-classification fields specify **interlocking** up to **PL e / category 4**, while **guard locking** is **PL d / category 2**. Product page also specifies **bistable** locking. These are component function claims, not complete machine PL/SIL or physical validation.
- Search-indexed manufacturer operating text under the same exact product page, not visible in the direct opened viewport, reports that certain non-immediate faults can give a warning while safety outputs remain enabled for a controlled process stop, with a **30-minute** warning period, and that the diagnostic OUT is not a safety output. Treat these operating-paragraph details as **INDEXED-ONLY, not independently direct-page verified** in this study.
- Schmersal 2023 original serial-diagnostics brochure, directly opened: https://products.schmersal.com/upload/orig/10/00/34/91/DOC_MAR_BRO_b-sd_SEN_AIN_V3.pdf ; directly verifies separate safety OSSD vs ordinary SD and product-family warning delay. See [SD-01 source audit](4400_SCHMERSAL_SD_NONSAFE_LOCK_COMMAND_WARNING_DELAY_AND_PILZ_ESCAPE_SOURCE_AUDIT_2026-10-25.md).

## Evidence table
| Claim | Evidence status | What cannot be inferred |
|---|---|---|
| Exact 103037334 product has different published ratings for interlocking and guard locking | **DOC-CONFIRMED** directly opened product page, separate fields | One PL e label does not transfer to the locking function or to an entire press brake. |
| AZM40 exact product has bistable locking principle | **DOC-CONFIRMED** product page | Retention under power failure is not inside escape, no hazard, or restart proof. |
| Schmersal SD family has separate safety OSSD and ordinary SD diagnostics | **DOC-CONFIRMED** directly opened 2023 brochure | A non-safe bus command is not safety-rated unlock permission. |
| AZM40 exact model noncritical warning can leave outputs enabled until a 30-minute threshold | **INDEXED-ONLY manufacturer operating text** | Do not claim physical machine state or universal fault timing without selected manual/revision. |
| Selected OpenPressBrake model, release function, physical Y1/Y2 stop/hold and guard geometry | **UNKNOWN** | No personnel-exposed machine operation or selected PL/SIL claim. |

## Architecture and failure consequences
1. **Label transfer error:** safety-switch *interlocking* integrity cannot substitute for *locking* integrity. Safety requirement must identify the function being claimed, exact part, category, architecture, diagnostics and fault exclusions.
2. **Locking versus hazard removal:** even a qualified lock can hold the gate while the ram remains gravity-loaded. Access request must not rely on ordinary LinuxCNC/FPGA command.
3. **Fault-warning misunderstanding:** a warning may be a controlled-shutdown opportunity rather than immediate safety output OFF; the actual output/final-element and physical state require separate verification.
4. **Human factors:** if a warning is cryptic and guard remains inaccessible, technicians may defeat it. Provide accessible explanation, visible wait/repair path and inside escape without granting unsafe access.
5. **Part replacement:** matching form factor or higher number in one function's rating cannot prove equivalent release behavior. Compare exact variant, manual, guard locking, OSSD, safe actuation and escape.

## Release and computation
G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED. No physical, simulator, hosted or self-hosted job; no independent evaluator. Do not extrapolate component ratings or 30-minute warning to OpenPressBrake. No new LinuxCNC source trace (SOURCE-CONFIRMED none); no TEST-CONFIRMED or COMMUNITY-REPORTED claim. Exact selected manual remains a G0 prerequisite.
