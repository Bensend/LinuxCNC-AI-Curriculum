# 25E0 — Restart Persistence and Diagnostics vs Physical Proof

## Question

What safety information must survive an ordinary controller/HMI restart, and what can device/logic diagnostics actually prove about downstream physical final elements?

## Evidence trace

### Rockwell Guardmaster external-device monitoring

**DOC-CONFIRMED:** Rockwell Guardmaster safety relays provide reset/monitor inputs; external safety relays/contactors can be monitored by putting their N.C. contacts in the reset/monitor path. This establishes a professional pattern in which downstream device state is separately witnessed rather than inferred solely from the safety relay output command. Source: Rockwell Automation, *Guardmaster Safety Relays User Manual*, publication 440R-UM013I-EN-P, July 2024.

**DOC-CONFIRMED:** Rockwell SC300 external-device monitoring checks whether contactors actually de-energize when the protective device trips. If expected feedback is absent after reset/restart, outputs are disabled again; inability to reach a safe operational state can cause lockout. Source: Rockwell Automation, *SC300 Safety Sensor User Manual*, 442L-UM004C-EN-P.

**DOC-CONFIRMED:** Rockwell POINTMax safety-output documentation explicitly warns that the safety level shown for the module applies to the module itself and that connected devices require their own status monitoring to achieve the application safety level. This is a direct boundary between healthy safety-I/O diagnostics and proof of the external device/application. Source: Rockwell Automation, POINTMax 5034-OB8S/OB8SXT safety-output documentation.

### Pilz external final-element boundary

**DOC-CONFIRMED:** Pilz defines a feedback loop as monitoring externally connected contactors/relays using N.C. contacts to check whether those devices have assumed their safe state before they are re-operated. Source: Pilz, *Feedback loop monitoring*.

**DOC-CONFIRMED:** Pilz PZE X4VP documentation states that mechanical relay output contacts cannot automatically be tested while switched on and requires measures/checks to detect non-opening contacts under applicable conditions; status LEDs indicate channel/contact state but do not replace the prescribed functional checks. Source: Pilz PZE X4VP Operating Manual 1003202-EN-15.

## Engineering interpretation

**INFERENCE:** A safety output module, safety relay, safety PLC, LinuxCNC display, or ordinary FPGA can be internally healthy while the proposition that matters at the hazard remains stale or unproved. Examples include:

- safety output is OFF, but an external contactor's physical state has not been witnessed;
- contactor feedback is correct, but stopping performance used for safeguard separation is stale;
- drive STO diagnostics are healthy, but a gravity/load-holding proposition requiring a separate physical proof has not been revalidated after maintenance;
- guard sensor diagnostics are healthy, but mounting/alignment/guard structure evidence is stale.

The exact downstream proof depends on the declared `PROP-*` and machine architecture. Do not invent a universal witness.

## Restart adversarial exercise

State before ordinary controller power loss:

- `FIND-017`: maintenance discovered a safety-relevant final-element issue;
- `PROP-STOP-004`: physical stopping proposition is stale;
- `OBL-009`: machine contained; exposed production prohibited pending `VAL-STOP-012`;
- the safety controller itself reports no internal diagnostic fault.

Power to the ordinary LinuxCNC/HMI computer is lost. On reboot, LinuxCNC initializes successfully, HAL loads, communications return, and the normal HMI would otherwise show READY.

### Wrong conclusion

`All current diagnostics are green and the CNC restarted cleanly, therefore the machine is safe to resume.`

### Required reasoning

1. The reboot does not create new physical evidence for `PROP-STOP-004`.
2. The accepted-baseline ledger still marks its evidence stale.
3. `OBL-009` must be recovered from durable safety/maintenance state; it is not an ordinary volatile alarm.
4. The HMI may display the open obligation but is not authorized to erase it merely because software restarted.
5. Containment remains until `VAL-STOP-012` produces the required evidence and the designated acceptance authority closes the obligation.
6. Only after that closure do reset/rearm and a fresh ordinary demand occur as separate steps where required.

If durable obligation state cannot be recovered after power loss, the correct state is **UNKNOWN**, not implicitly clear.

## Why external-device monitoring is not the whole physical proof

EDM is valuable because it crosses one command/state boundary: it can witness a contactor/relay feedback contact instead of trusting the output command. It does **not** automatically prove every downstream proposition. A feedback contact cannot by itself prove, for example, actual machine stopping distance, pressure decay, load holding, guard geometry, or absence of hazardous stored energy unless the machine-specific architecture establishes that relationship and validates it.

Therefore the evidence graph should read:

`logic/output diagnostic -> external-device witness (when applicable) -> process/final physical proposition (when required)`

not:

`green safety diagnostic -> machine physically safe`.

## Learner freezes

- **VOLATILE CONTROLLER STATE LOST != SAFETY OBLIGATION CLEARED.**
- **SAFETY MODULE HEALTHY != EXTERNAL DEVICE STATE PROVED.**
- **EXTERNAL DEVICE FEEDBACK HEALTHY != EVERY DOWNSTREAM PROCESS PROPOSITION PROVED.**
- **REBOOT SUCCESS != RETURN-TO-SERVICE ACCEPTANCE.**
- **MISSING PERSISTENT RECORD != NO OPEN OBLIGATION.**

## Evidence classification / limits

The manufacturer claims above are `DOC-CONFIRMED`. The persistence record architecture is an engineering curriculum method (`INFERENCE`) built to preserve already-declared safety obligations; it is not claimed as a particular PL/SIL architecture. Machine-specific persistence technology, required redundancy, proof intervals, hydraulic truth tables, stopping limits, and acceptance authority remain design-specific or `UNKNOWN` until established for the actual machine.

No simulation or executable test is justified for this lesson: the unresolved question is lifecycle/evidence authority, and the manufacturer documentation directly establishes the diagnostic/final-element boundary.
