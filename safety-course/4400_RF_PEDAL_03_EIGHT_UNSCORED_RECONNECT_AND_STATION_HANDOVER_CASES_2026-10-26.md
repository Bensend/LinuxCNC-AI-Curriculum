# 4400-RF-PEDAL-03 — Wireless foot pedal: lost link, held command, new start

Date: 2026-10-26. **NON-GRADUATED / PAPER ONLY.** [Exact IEC/OEM source and gap audit](../research/4400_RF_PEDAL_03_IEC62745_WIRELESS_FOOT_COMMAND_RECONNECTION_AND_OEM_GAPS_2026-10-26.md). The installed OpenPressBrake pedal/network is UNKNOWN. Do not assume it is wireless.

## Practical question

A wireless foot switch improves floor access and removes a damaged-cable/trip hazard. What new risks arise when radio communication drops, returns, or changes stations? Distinguish **normal request**, **safety-related stop**, **receiver state**, **physical stop/hold** and **deliberate restart**.

## Eight PUBLIC PAPER cases — all UNSCORED

For each, provide: expected state *only if source-confirmed*; unknown evidence; safe no-energy check; failure consequence; practical operator-friendly redesign. Do not invent a radio timeout or receiver truth table.

1. A foot pedal is held down when the transmitter battery dies. Someone assumes the receiver output opens instantly.
2. The receiver regains signal while the pedal is still held. The programmer treats the first valid packet as a fresh start.
3. A second portable pedal is paired during service, but the original is still within range. Operators cannot tell which station owns control.
4. A transmitter has an LED indicating power. A technician calls this proof that the machine's safety-related stop is available.
5. A generic catalog lists a typical radio latency. The designer inserts that number directly into a press-brake stopping-distance calculation.
6. An RF catalog page reports conflicting battery-life and contact-type specifications. Decide what exact document/part evidence is needed.
7. A wireless station is moved behind a tall sheet for convenience. The radio still works but the operator no longer sees the rear hazard zone.
8. A safety-related E-stop has been reset and the wireless link returns. An ordinary LinuxCNC status bit becomes green; no Y1/Y2 physical hold proof exists.

## Eight documentary gates — all NOT RUN

| Gate | Required witness |
|---|---|
| RF-G01 | Exact installed transmitter, receiver, firmware and OEM manual (or UNKNOWN) |
| RF-G02 | Receiver relay/contact state on loss of valid radio frames |
| RF-G03 | Battery low, dead and replacement behavior, including indications |
| RF-G04 | Link re-establishment with held input: neutral/new deliberate command behavior |
| RF-G05 | Pairing, station ownership, multi-station handover and unauthorized activation |
| RF-G06 | Position/visibility, guarded pedal, footwear and relocation change control |
| RF-G07 | Independent safety-related stop/hold and actual physical Y1/Y2 witness |
| RF-G08 | Qualified SRS, versioned validation and independent evaluator precommitment |

All eight remain **NOT RUN**; no external score. IEC 62745 official abstract establishes the cableless-control topic; its technical clauses are not adopted as verified machine requirements without the selected edition/full authoritative source. Ordinary radio packet redundancy/CRC, an HMI lamp and a normal LinuxCNC/FPGA inhibit cannot substitute for a qualified independent protective function.

**Release:** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed hazardous operation. Any separately authorized experimental operation must be isolated/remote with people outside the danger zone; no lab is authorized by this worksheet.
