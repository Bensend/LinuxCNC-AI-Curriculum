# OpenPressBrake G0 Stage B — cableless pedal/control evidence card

**2026-10-26 | CONDITIONAL, RESTRICTED DOCUMENTARY HANDOFF | NO TEST / NO SAFETY RELEASE**

**Open this card only if** qualified private Stage A [A–G evidence request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) establishes that a wireless/cableless foot switch, pendant or remote operator station is actually installed. **Do not assume RF exists.** If no cableless equipment is installed, document that fact and mark this conditional card N/A; essential guarding, independent stop/hold, LOTO and restart requirements remain mandatory.

## Ten restricted existing-record questions (all public status UNKNOWN)

| Item | Qualified reviewer question / existing records | Public status |
|---|---|---|
| RF-B01 | Exact transmitter and receiver type plates, serial pairing, hardware/firmware and OEM manual revision | UNKNOWN |
| RF-B02 | All stations that can request hazardous motion; location, visibility, operator identity and authorized ownership | UNKNOWN |
| RF-B03 | Receiver output contact/wiring and ordinary LinuxCNC/FPGA versus independent safety-input boundary | UNKNOWN |
| RF-B04 | Exact receiver documented response to loss of valid frames, interference, low battery and receiver power loss | UNKNOWN |
| RF-B05 | Does restored communication require neutral/released pedal plus fresh deliberate command, rather than replay? | UNKNOWN |
| RF-B06 | Pairing/replacement and multi-transmitter behavior; how to prevent unexpected control transfer | UNKNOWN |
| RF-B07 | Selected SRS's stop and rearm contract for remote-station disable, E-stop and loss of control | UNKNOWN |
| RF-B08 | Local visible indicators, operator access to a working E-stop, cableless station storage and maintenance | UNKNOWN |
| RF-B09 | Independent physical Y1/Y2 stop, gravity holding, hydraulic energy isolation, guard coverage and qualified validation records | UNKNOWN |
| RF-B10 | Dated change records for receiver firmware, battery, RF environment, moved station, guarding, safety logic and physical revalidation | UNKNOWN |

## Review logic

1. **Historical values do not qualify this machine.** A [2008 PRELIMINARY Linemaster RF Industrial manual filed with FCC](https://fccid.io/VPA-SP-831/User-Manual/Users-Manual-1021767.pdf) states 1,050 ms no-signal output-off and typical 50 ms command latency. These are different quantities, not a current installed receiver guarantee or machine stop-time acceptance. Reconnection behavior while a pedal is held is not established.
2. **A paired radio is not safety authorization.** Signal strength, CRC, power LED, receiver relay indication and LinuxCNC GUI state cannot substitute for a selected safety-related function or physical stop/hold.
3. **Do not treat IEC 62745 scope as a certificate.** The official 2017 publication covers cableless machinery control; exact current-edition normative compliance, architecture and safety integrity need qualified source and design evidence. Never invent PL/SIL, link-loss timeout or stopping distance.
4. **Make correct use easy.** Choose stable, accessible pedal position, protected shoes/guard, visible active-station identity, convenient battery service and reliable handover. Avoid permanent nuisance faults that encourage bypass or hidden alternate stations.
5. **Privacy:** collect drawings, exact wiring, serials, firmware, physical evidence and reviewer signatures **privately**. The public repo records only item ID and status: UNKNOWN, RECEIVED/UNREVIEWED, REVIEWED/IN-SCOPE, CONTRADICTORY, STALE or N/A WITH PROOF.

No RF experiment or machine actuation is authorized by this card. If basic minimum protection cannot be established, **do not operate with people exposed**; any separately authorized experimental operation must isolate everyone outside the danger zone and document residual risk.

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No selected machine evidence, no test, no hosted/local compute. [RF source audit](../research/4400_RF_PEDAL_03_IEC62745_WIRELESS_FOOT_COMMAND_RECONNECTION_AND_OEM_GAPS_2026-10-26.md) and [public unscored cases](4400_RF_PEDAL_03_EIGHT_UNSCORED_RECONNECT_AND_STATION_HANDOVER_CASES_2026-10-26.md).
