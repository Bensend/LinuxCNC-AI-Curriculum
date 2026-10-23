# 4400 — Current HYDAC SAF catalog confirms padlock can secure OPEN as well as CLOSED

**Study UTC:** 2026-10-23. **Manufacturer source:** HYDAC, *Safety and shut-off block SAF/DSV*, **EN 3551.25/05.24** (May 2024), printed pp. 161–172, especially model-code p.165 and additional equipment pp.171–172. Official manufacturer-hosted PDF: https://www.hydac.com.au/media/productattach/e/n/en3551-25-05-24_saf-dsv.pdf

**Status:** DOC-CONFIRMED for this published SAF family and exact options; INFERENCE for generic human-factors/fault-path lessons; UNKNOWN for the installed machine. No physical test or selected-machine validation.

## New evidence and correction to historical-only scope

The earlier [August 2003 SAF lockable-shutoff audit](4400_HYDAC_HISTORICAL_LOCKABLE_SHUTOFF_POSITION_WITNESS_2026-10-22.md) preserved a cautious historical-edition boundary. The May 2024 HYDAC document **independently confirms the same important current-family design feature**: additional device `L` is a padlockable main shut-off that can be locked **OPEN OR CLOSED** (section 4, printed p.171). This strengthens the generic lesson, but still does not identify an installed part or validate a specific hydraulic circuit.

The 2024 model code on printed p.165 distinguishes `L` (lockable shut-off), `LPI` (with inductive position monitoring), `LPM` (with mechanical roller-lever position monitoring), and `LS` (lockable pressure-release valve). Section 4, pp.171–172 describes these as different additional devices. It does not say that a position switch proves hydraulic isolation or every trapped pressure zone safe.

## Current edition model/option contrast

| Question | DOC-CONFIRMED May 2024 evidence | Engineering implication / UNKNOWN |
|---|---|---|
| Does a padlock prove the shut-off is CLOSED? | **No.** `L` may lock either open or closed. | Verify actual handle/valve position and selected energy path; label positions unambiguously. |
| Does `LPI` or `LPM` prove zero accumulator pressure? | Catalog defines them as **position monitoring** options. | No: actual connected volumes, pressure, isolation and load restraint need independent evidence. |
| Does `LS` lock the same function as `L`? | Catalog calls `LS` a lockable **pressure-release** valve. | Separate its authority and failure modes from main shut-off; do not conflate. |
| Are all SAF blocks automatic-discharge? | §1.2 states the solenoid-operated release is **optional**; section 3.2 distinguishes `M`/`E` and Y/Z valve families. | Identify exact selected suffix/assembly and hydraulic topology; no generic power-loss truth table. |
| Does a brochure's compact circuit diagram prove the ram is held? | No such installed-machine proof is supplied. | Gravity restraint, pilot pressure, trapped chambers, gauge location and reaccumulation remain UNKNOWN. |

**Important version discipline:** May 2024 confirms the option semantics, not interchangeability of 2003 2SV5 and later WSM components, nor availability of every option on every catalog model. Do not infer pressure thresholds, leakage rates, response times, PL/SIL or a selected-machine hydraulic truth table.

## Adversarial commissioning/maintenance case

A maintainer sees a padlock on an SAF block with `LPI` and a green `VALVE POSITION OK` HMI lamp. The lock is holding the shut-off **OPEN** for a normal operating mode. The HMI status may be accurate as a process-position indication while the maintenance isolation proposition is false. An adjacent gauge may read zero on the wrong side of a shut-off or bleed path. A gravity-loaded beam may still move even when the pump is off.

**INFERENCE:** The appropriate response is not to rewrite the HMI label to `SAFE`; it is to design clear `OPEN — NOT ISOLATED` / `CLOSED — VERIFY ISOLATION` labeling, accessible task-specific test points, lockout arrangements that prevent foreseeable wrong-position use, independent load restraint, and an explicit maintenance verification procedure. Avoid requiring a worker to remove/bypass a guard to read the only trustworthy indicator.

## Traceability and disposition

- `BND/ENE/HAZ`: actual accumulator, cylinder, pilot and elevated-load energy boundaries, all currently **UNKNOWN**.
- `SRS/PHY/AUTH/ARC`: distinguish physical shut-off, pressure release, position feedback, production protective stop, independent safety control and maintenance isolation.
- `DEP/VAL/PT`: identify connected ports/gauge taps and validate selected physical isolation, stored-energy/reaccumulation and load restraint; **NOT RUN**.
- `HF/CHG/UNK/RR`: address wrong-position padlocking, label and test-point ergonomics; mark dependent evidence STALE on valve/option replacement.

**Operational restriction:** documentary product-family information does not authorize personnel-exposed hazardous operation or maintenance. Require selected-machine physical evidence; isolated/remote experimental work must keep people outside the danger zone with residual risks controlled.

**No simulation or bench test was justified for this question:** the current-family lock-position semantics are resolved by the manufacturer's catalog. Installed-machine behavior remains a separate physical-validation dependency.
