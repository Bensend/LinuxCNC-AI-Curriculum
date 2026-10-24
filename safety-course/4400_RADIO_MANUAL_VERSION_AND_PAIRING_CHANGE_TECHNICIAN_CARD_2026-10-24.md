# 4400-RAD-03 — Receiver manual/firmware/transmitter version-transfer scenarios
**8 PAPER-only scenarios; no blind score or machine tests.** Read [direct v09/v11 original OEM comparison](../research/4400_TELE_RADIO_R15_V09_V11_VERSION_SCOPE_AND_POWER_CYCLE_AUDIT_2026-10-24.md). For each identify the exact documented claim, edition limit, selected evidence needed, change-control action and physical safety boundary.

1. A maintenance team uses v09's transmitter list to reject a T29-12 while another team cites v11. What can and cannot be concluded without installed firmware and certification?
2. A receiver reports SW0014-14v23 but the technician follows v11. What manual gate has been violated?
3. After selecting mode 5, normal control still works. What is the documented radio STOP classification in both manuals?
4. The PLd LED is OFF after reconfiguration; a welded downstream contactor is not inspected. What is missing?
5. A technician changes from PLd to non-PLd configuration and does not power-cycle the receiver. Which v11-specific instruction was missed? Does complying with it prove machine safety?
6. A replacement receiver uses Custom ID ON to accept an older transmitter, while the machine's risk assessment credited the v09/v11 PLd configuration. What happens to the claimed configuration?
7. A receiver power interruption restores a prior held normal CNC demand; Require start ON blocks radio STOP relays until start packet. What *additional* machine rearm and physical hold evidence is required?
8. A T19-02 is swapped for a T29-12 because v11 lists both. Which exact transmitter instructions, safety output wiring, firmware, independent stop and restart evidence must be reviewed?

**Status:** learner-visible non-blind paper work. Do not self-score or turn into a sealed answer key.
