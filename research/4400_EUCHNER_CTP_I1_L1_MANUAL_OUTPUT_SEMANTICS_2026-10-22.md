# 4400 — CTP-I1 versus CTP-L1: the same-looking guard lock with a different safety-output proposition

**Status:** manufacturer-manual `DOC-CONFIRMED` comparison. **Not** a compatible replacement recommendation, installed-machine test, achieved PL/SIL, or authorization to operate with people exposed. Inspected 2026-10-22.

## Concrete engineering question

Could a replacement with the same spring-to-lock/power-to-unlock behavior, coded actuator, mechanical locking force and two `FO1A/FO1B` safety outputs silently change the meaning of the signal delivered to the safety controller?

**Yes.** The manufacturer's actual switching-state tables explicitly distinguish `guard closed, unlocked` from `guard closed, locked` differently in the two families. This is a safety-function allocation difference, not merely a connector or diagnostic-label difference.

## Authoritative documents and scope

- EUCHNER, *Operating Instructions Transponder-Coded Safety Switch with Guard Locking for Process Protection CTP-I.-AP*, doc **2126290-08-07/24**, §§2, 6.1–6.8, 7.1–7.4, 11.3, 12; printed pp. 5–10, 20–21. Official PDF: https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Operating-Instructions-Transponder-Coded-S%E2%80%A6_EN_08_07-24_2126290.pdf . Its stated version scope is V1.0.X–V1.1.X; selected device must be checked against its own manual/datasheet.
- EUCHNER, *Operating Instructions Transponder-Coded Safety Switch with Guard Locking CTP-AP*, doc **2124217-08-06/21**, §§2–3, 6.1–6.8, 7, 10.10–10.11, 11.3, 12; printed pp. 5–9, 20–24. Official PDF: https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Transponder-Coded-Safety-Switch-With-Guard%E2%80%A6_EN_08_06-21_2124217.pdf .
- Product records for examples: I1 **CTP-I1-AP-U-HA-AEC-SA-136595** (M12 8-pin), https://www.euchner.com/en-us/products/transponder-coded-safety-switch-with-guard-locking-2/ctp/safety-switch-ctp-ap-2/ctp-i1-ap-u-ha-aec-sa-136595/ ; L1 **CTP-L1-AP-U-HA-AE-SH-123375** (M23 19-pole), https://www.euchner.com/en-us/products/transponder-coded-safety-switch-with-guard-locking-2/ctp/safety-switch-ctp-ap-2/ctp-l1-ap-u-ha-ae-sh-123375/ . Do not treat these two example connector variants as pin-compatible.

## Manufacturer switching-state evidence

Both manuals' diagrams were visually inspected, not inferred from an output name. Table below describes **normal operation in the documented state-table context**, not all transient or fault states:

| Actual guard state | I1 FO1A/FO1B | I1 OL | I1 OD | L1 FO1A/FO1B | L1 OL | L1 OD |
|---|---|---|---|---|---|---|
| Closed and locked | ON | ON | ON | ON | ON | ON |
| **Closed but unlocked** | **ON** | OFF | ON | **OFF** | OFF | ON |
| Open | OFF | OFF | OFF | OFF | OFF | OFF |

**`DOC-CONFIRMED`**: I1 doc 2126290 §6.8, printed p.8 (PDF p.8, zero-index 7); L1 doc 2124217 §6.8, printed p.9 (PDF p.9, zero-index 8). The decisive cell is `closed but unlocked`: I1 safety outputs are ON, L1 safety outputs are OFF. Both OL outputs are OFF, so merely observing OL in a diagnostic screen does not establish that the selected safety-input pair implements the same function.

**I1-specific nuance:** §6.1 says guard-lock position does not govern the safety-output state. §6.2 describes a *switch-on check* that may subsequently turn the safety outputs OFF if commanded locking fails; the manufacturer explicitly states this is **not safe guard-lock monitoring for personnel protection**. Do not mistake that conditional diagnostic behavior for the L1's safety-output allocation. I1's published PL e characteristic concerns **guard-position monitoring** (product record).

**L1-specific nuance:** §§2–3 and 6.1 say FO1A/FO1B monitor **guard locking**; the manufacturer separately allocates the **control of guard locking** to external safety-related control (for example, an appropriately justified standstill monitor). An L1 output being ON does not prove that the machine has actually stopped, that an unlock command is safe, or that a gravity-loaded axis is held. L1's published PL e concerns guard-lock monitoring in the specified context, not a complete machine safety function.

## Other non-interchangeable behaviors

1. **Identical spring-to-lock power-loss mechanics can trap a person.** Both I1 §6.6 and L1 §6.6 warn that closing an open guard during power loss can unintentionally lock a person in. `DOC-CONFIRMED` for product behavior; actual trapped-person geometry and egress remain `UNKNOWN`.
2. **Mechanical escape and outside emergency release have different access directions.** Both manuals distinguish an inside, tool-free escape release that must not be reachable from outside, from a separate outside emergency release. An auxiliary/key release is not automatically a suitable occupant escape device. These are manufacturer-specific instructions; the exact installed accessory and physical opening still need witnesses.
3. **Manual commissioning steps differ.** I1 §11.3 allows an application-specific process-lock test, then opening the guard must inhibit the machine. L1 §11.3 additionally requires that guard locking cannot be deactivated while operation is enabled and that the guard remain locked until injury risk ends. These are distinct acceptance propositions, not interchangeable tests.
4. **The illustrated I1 and L1 product examples use different connectors and pin assignments.** Nominal voltage, similar locking force and `FO1A/FO1B` labels do not establish wiring compatibility. Exact receiver test-pulse/filter and external solenoid-control behavior remain selected-design questions.
5. **Manual release affects signals but does not prove actual escape.** I1 §§7.1–7.3 document OL OFF and OD potentially undefined on mechanical release; L1 §§7.1–7.3 document safety outputs OFF on release. The physical latch, door opening, and human egress require their own witness.

## Fault-path / adversarial substitution

Assume a guarded cell's `SRS-###` requires *guard remains locked until hazardous motion is independently shown ended*. A technician substitutes the I1 for an L1, then adapts wiring and sees FO1A/FO1B ON with the door closed but unlocked. The safety controller's input may now be permissive for a **guard-position** proposition where the original design required a **guard-locking** proposition. This is an `INFERENCE` about a hypothetical system using the `DOC-CONFIRMED` state tables; it is not an assertion that a particular installed machine would restart. A real receiver could reject the replacement or other interlocks could prevent motion. Both outcomes require actual wiring/configuration evidence.

Minimum change impact: `CHG-###` marks dependent `SRS/PHY/AUTH/ARC/DEP/VAL/PT` evidence STALE. Compare exact part/revision, function assignment, output state table, connection, external unlock authority, selected standstill/holding witness, manual release, inside escape, reset/rearm and independent ordinary start. No credit from matching `PL e`, equal tabulated `FZh`, an OL LED, or apparent operation during one cycle.

## Eight-field final-element witness contract (selected guard lock)

| Field | Required evidence |
|---|---|
| Safety demand | Prevent hazardous access until the selected physical stop/hold proposition is established; distinguish stop request from unlock request. |
| Physical final element | Exact guard latch/actuator, door/hinge/bracket, and independent machine stop/holding elements. |
| Feedback target | FO1A/FO1B target **guard position on I1** versus **guard locking on L1**; OL diagnostic status separately. |
| Narrow supported proposition | Only the manufacturer-documented function in the selected application. |
| Shared dependencies | Coded actuator, supply, wiring/connector, mounting/door, external unlock controller, sensing and receiver configuration. |
| Residual hazard | Moving spindle/robot/beam, trapped pressure, gravity load, stored energy, trapped occupant, access geometry. |
| Machine-level physical witness | Actual hazard ended/held before access, actual lock/door/egress function, and retained-start/rearm behavior. |
| Maintenance boundary | Guard lock/escape/FO/OL are not electrical or hydraulic LOTO, pressure exhaustion, or approved load restraint. |

## Technician-proof cases (not instructions for unsafe live fault injection)

- `VAL-1`: Present documented *closed, unlocked* state tables for both variants. Ask whether FO ON establishes locked access. **I1: no; L1: normal-state table indicates FO OFF when unlocked.** Do not infer full machine safety from either.
- `VAL-2`: After replacement, OL appears OFF while door is closed. Require distinction between diagnostic OL and safety outputs, then inspect receiver wiring and expected `SRS` before crediting the input.
- `VAL-3`: On power loss, a gate closes with a person inside. Require independently justified inside escape and physical egress, not only E-stop status or motor STO.
- `VAL-4`: After guard mechanical release, outputs change but door remains physically jammed. Mark escape `PHY` unproved; separately assess hazardous motion/energy.
- `VAL-5`: Re-enable after maintenance with retained normal start. Require deliberate safety reset/rearm and independent ordinary start, with occupancy strategy and actual stop/hold proof.

Documentary desk checks can compare state tables without running hardware. Any physical release/egress check must follow the selected manufacturer's commissioning requirements, with people outside the danger zone and energy controls appropriate to the test. Do **not** conduct hazardous live fault injection to make this lesson 'TEST-CONFIRMED'.

## Provenance/unknowns

`DOC-CONFIRMED`: exact state-table differences; I1 switch-on-check limitation; L1 external unlock-control allocation; manuals' inside/outside release distinction; manufacturer commissioning procedures; example SKU connectors.

`INFERENCE`: a receiver may accept the wrong safety proposition after a substitution; mechanical lock and guard feedback can be misleading if the SRS requires a different physical fact.

`UNKNOWN`: any installed product/revision, actual receiver wiring and pulse compatibility, guard forces/structure, stop/access time, required integrity, actual occupancy/egress, selected-machine residual energy and hydraulic truth, physical validation. `TEST-CONFIRMED`: **none**.

**Release boundary:** If the minimum safe-to-operate function cannot be independently established, do not expose people to the hazard; experimental operation must be isolated/remote with people outside the danger zone and residual risk recorded. Normal LinuxCNC/HAL/FPGA status remains diagnostics/production control, not independent personnel-safety authority.

### Relationship to the earlier Pilz release-label ambiguity

EUCHNER's manuals provide a clear **independent product example** distinguishing outside emergency release from inside escape release. They do **not** correct, supersede, or resolve the earlier noted English-language ambiguity in Pilz PSEN ml s 1.1 §4.8. Keep that Pilz document issue `UNKNOWN` for its own selected product/edition; do not transplant EUCHNER accessory instructions into a Pilz installation.
