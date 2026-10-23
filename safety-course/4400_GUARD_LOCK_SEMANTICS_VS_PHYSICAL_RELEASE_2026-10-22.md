# 4400 — Guard-lock semantics versus physical safe-state access release

**Status:** public-source engineering lesson, 2026-10-22. Not a validated machine design, PL/SIL assessment, or authorization for exposed operation.

## Question and outcome

Does a two-channel "guard closed" safety output, a lock-status indication, and a LinuxCNC "machine disabled" indication together prove that access is safe? **No.** The exact switch variant determines what its safety outputs represent, and the physical machine hazard requires independent evidence. A production access release is not maintenance energy isolation.

### Manufacturer switching-state distinction

The EUCHNER CTP-I.-AP operating instructions, document **2126290-08-07/24**, §6.8, p. 8, specify that FO1A/FO1B remain ON with the guard **closed but not locked**. The exact order 136595 product page calls its locking *process protection* and explicitly says it lacks safe guard-lock monitoring. The CTP-L1 instructions, document **2124217-08-06/21**, §6.8, p. 9, specify FO1A/FO1B OFF in the closed-but-unlocked state. Order 123375 lists guard-lock monitoring as a safety function; safety of *controlling* guard locking depends on external control.

| Guard state in cited manuals | CTP-I1 AP FO1A/FO1B | CTP-L1 AP/AR FO1A/FO1B | Correct interpretation |
|---|---|---|---|
| Closed and locked | ON | ON | Does not prove the machine stopped or load is held. |
| Closed but unlocked | **ON** | **OFF** | The I1 safety outputs do not prove safe locking. |
| Open | OFF | OFF | The downstream physical protective action must still be verified. |

The CTP-L.-AP manual §10.1 explicitly requires evaluation of both safety outputs and forbids using monitoring outputs as safety outputs; §10.10 requires a receiver suitable for pulsed OSSD signals and separately discusses up-to-5-ms pulses on the *solenoid-control* interface. Those are distinct electrical contracts, not a universal 5-ms OSSD input filter. Its §7.3 requires an escape release operable without tools from inside and not reachable from outside. These are **DOC-CONFIRMED** product-specific constraints, not evidence that a particular installed gate meets them.

The manuals also distinguish the ordinary **OL** lock-monitoring and **OD** door-monitoring outputs from the specified safety-output function. Do not assume OL is a safety-rated locking witness or that the receiver can accept an output merely because its voltage is nominally 24 V. Connector/pin assignments and receiving safety-controller pulse/filter/startup behavior are selected-product questions.

**DOC-CONFIRMED** sources: EUCHNER CTP-I.-AP manual 2126290-08-07/24, §6.8, https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Operating-Instructions-Transponder-Coded-S%E2%80%A6_EN_08_07-24_2126290.pdf ; EUCHNER CTP-L1 manual 2124217-08-06/21, §6.8, https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Transponder-Coded-Safety-Switch-With-Guard%E2%80%A6_EN_08_06-21_2124217.pdf ; product orders 136595 and 123375 at https://www.euchner.com/en-us/products/transponder-coded-safety-switch-with-guard-locking-2/ctp/safety-switch-ctp-ap-2/ctp-i1-ap-u-ha-aec-sa-136595/ and https://www.euchner.com/en-us/products/transponder-coded-safety-switch-with-guard-locking-2/ctp/safety-switch-ctp-ap-2/ctp-l1-ap-u-ha-ae-sh-123375/ . These are manufacturer documentation, **not TEST-CONFIRMED** installed behavior.

## Four separate physical/authority propositions

1. **Guard state and access:** the correct safety-rated position/locking proposition is met for the selected guard geometry, mounting, actuator, cable and escape arrangement. A functioning FO output does not prove the door is physically openable from inside.
2. **Machine safe state:** independent evidence establishes the SRS-defined stop, holding/restraint and relevant stored-energy/pressure-zone condition. For a gravity-loaded hydraulic beam, neither a valve-position indication nor zero at one gauge establishes the complete machine safe state.
3. **Release authority:** an independent safety-related controller owns the safety function and the qualified rearm/unlock decision. LinuxCNC/HAL/normal FPGA may request, display or log; they do not acquire personnel-safety authority.
4. **Maintenance energy control:** servicing requires separately verified physical energy isolation, residual-energy disposition and restraint/blocking when applicable; production guard unlock is not LOTO.

The distinction in (2) is **INFERENCE** from the evidence hierarchy and hazard analysis, not a statement about a particular machine. Exact stop/hold time, hydraulic paths, pilot pressure, pressure threshold, guard retention, escape geometry and PL/SIL remain **UNKNOWN** without selected-machine evidence.

## Adversarial commissioning and substitution challenge

Hypothetical case: a replacement part changes from L1 to I1 without revalidating the receiving controller. The door is closed but unlocked. A technician sees FO1A/FO1B ON and an ordinary LinuxCNC status of "disabled." Simultaneously, a monitored hydraulic valve reports its expected position while an independent physical beam-motion witness contradicts the required stopped/held state.

Expected engineering response: create a `CHG-*` substitution record, mark the affected `ARC/DEP/VAL/PT` evidence STALE, and do not credit the I1 outputs as a locked-state safety witness. Credit valve feedback only for the exact target it observes. Mark the broader `PHY-*` machine safe-state proposition **NOT ESTABLISHED**, retain `UNK/RR` restrictions and withhold exposed-person access/rearm. Determine exact replacement equivalence, receiver interface, escape/guard mechanics and independent stop/hold/pressure evidence before release. If the basic protection proposition cannot be established, any experimental diagnosis must be isolated/remote with people outside the danger zone.

**Human factors:** the safe guard must be convenient to reinstall and troubleshoot. Provide accessible inside escape, clear separate indications for "guard position," "lock monitoring," "machine physically safe," and "maintenance isolation," and a remote inspection path so the easiest diagnostic action is not defeating the guard. Do not allow convenience overrides to replace independent safety functions.

## Cumulative Safety Design Package mapping

| IDs | Evidence obligation | Status in generic example |
|---|---|---|
| `BND/ENE/HAZ` | person/task/entry geometry; hydraulic/gravity/stored energy | UNKNOWN |
| `SF/PHY/SRS` | safe locking/access plus machine-specific stopped/held proposition | UNKNOWN / not validated |
| `AUTH/ARC` | selected safety controller, guard switch, energy-removal and restraint path | UNKNOWN |
| `DEP/HF` | shared power, actuator, lock solenoid, pilot, receiver, escape, bypass incentive | UNKNOWN |
| `VAL/PT` | closed-unlocked, substitution, power loss, jammed escape, feedback contradiction | NOT RUN |
| `CHG/UNK/RR` | change impacts, unresolved witnesses and operating restriction | OPEN |

**Lab decision:** no lab frozen. Manufacturer manuals resolve the output-state distinction. The missing evidence is selected-machine physical validation, not an unanswered software/simulation question. 2520–25F0 external/fresh evaluation remains open and information-separated.
