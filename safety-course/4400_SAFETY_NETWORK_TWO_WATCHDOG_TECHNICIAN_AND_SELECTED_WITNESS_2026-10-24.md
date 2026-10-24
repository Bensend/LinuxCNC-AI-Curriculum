# 4400-NET-01 — Twelve technician discrimination cases and blank selected-machine witness
**Status:** learner-visible PAPER exercise and unfilled qualified witness; 2026-10-24. **Not an answer key, physical test, independent evaluation, or authorization to expose personnel.** Complete using [NET-01](4400_NET_01_SAFETY_NETWORK_WATCHDOG_DUAL_LINK_REACTION_AND_PHYSICAL_BOUNDARY_MODULE_2026-10-24.md).

## Technician cases (no hidden answers)
For each case provide: (a) which of normal control, ordinary bus, certified safety communication, independent safety logic, final element, or physical energy state is implicated; (b) what can be concluded from available evidence; (c) what is **UNKNOWN**; (d) a discriminating **safe** verification step; (e) a bypass-resistant correction; and (f) the explicit non-authorized live test.

1. **Normal bus alive:** LinuxCNC position updates at 1 kHz and EtherCAT master says OP; guard status on safety HMI is stale.
2. **Zero ordinary watchdog:** a service engineer sets an ordinary EtherCAT SM watchdog field to 0 to stop nuisance trips; the machine still responds to jog.
3. **UI versus register:** watchdog UI shows a changed value, but the download-at-startup checkbox was not enabled.
4. **PDI fault:** EtherCAT network frames continue while the ESC-to-local-processor path stops updating.
5. **One safety link breaks:** a guard trips exactly when the safe input-to-logic safety telegram path fails.
6. **Two links break:** the same guard transition coincides with loss of input-to-logic and then logic-to-safe-output safety communication.
7. **CRC failure:** FSoE diagnostic reports invalid CRC while the normal bus remains healthy.
8. **Address collision:** replacement safety terminal has a duplicated or incorrect configured safety address.
9. **Acknowledgement mismatch:** safety connection has recovered but per-connection ComErrAck and group ErrAck are not both satisfied.
10. **Physical final-element fault:** safety logic shows false output, but one gravity-loaded axis drifts.
11. **Power return:** all network links report healthy and an old CNC jog/auto command is still present.
12. **Operator bypass incentive:** frequent nuisance stops prompt a request to disable safety communication timeout permanently.

## Selected-machine evidence contract — blank
**Do not execute a fault injection or hazardous motion on an unverified machine.** The qualified team must first authorize a protected, isolated procedure with personnel outside the hazard zone and mechanical/energy restraints as applicable.

| Evidence proposition | Required source / qualified witness | Result |
|---|---|---|
| Exact selected network(s), safe devices, firmware and certified variants | As-built inventory, labels, OEM certificates and manuals | UNKNOWN / NOT COLLECTED |
| Ordinary EtherCAT SM/PDI watchdog settings and actual downloaded registers | Qualified configuration and nonhazardous readback | UNKNOWN / NOT COLLECTED |
| Safety-channel identity, addressing, CRC and watchdog on both links | Exact certified safety configuration, signatures, OEM response model | UNKNOWN / NOT COLLECTED |
| Safe input -> logic -> safe output fault reaction, including two-link worst case | Qualified design calculation and bounded isolated terminal observation | NOT RUN |
| Independent safe output terminal -> final element behavior | Wiring proof, contactor/valve feedback and safe isolated witness | NOT RUN |
| Physical stop/hold with loss of command, power or communication | Approved physical test plan, restraints, calibrated measurements, Y1/Y2 separately and jointly | NOT RUN |
| Guard/occupancy, restart and stale-command inhibition | Qualified reset/rearm/fresh-start witness after safe state | NOT RUN |
| Maintenance bypass/replacement, documentation and sign-off | Change log, sealed settings, spare variant and return-to-service sign-off | UNKNOWN / NOT COLLECTED |

**Stop condition:** if a final element cannot demonstrably stop and hold the hazardous load, or a guard/occupancy boundary is unknown, **no personnel-exposed operation**. Isolated remote experiments are only possible with a separately approved risk assessment and exclusion; do not use this worksheet as permission.

**Evidence classes:** manufacturer documentation = DOC-CONFIRMED for exact version; inspected code = SOURCE-CONFIRMED only at pinned commit; observed independent qualified test = TEST-CONFIRMED with raw evidence; unverified installed behavior = UNKNOWN. No scores or tests are recorded by this worksheet.
