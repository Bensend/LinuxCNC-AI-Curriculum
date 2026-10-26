# 4400-RF-PEDAL-03 — Wireless foot control: radio reconnection is not a new start

Date: 2026-10-26. **Safety documentary/source-gap audit; NON-GRADUATED.** Rotated after PEDAL-01/02 to a distinct *cableless command/reconnect* failure path. No claim OpenPressBrake uses wireless controls. No radio experiment, machine test or Actions compute.

## Core question

If a foot pedal is pressed while the receiver loses communication, **what does the receiver output do, and can communication restoration replay a hazardous command without a fresh deliberate action?** A published radio range, battery life, CRC or momentary switch is not an answer. Neither is a normal LinuxCNC input status or software E-stop.

## Evidence ledger

| Source | Classification | Confirmed scope | Still UNKNOWN |
|---|---|---|---|
| [IEC 62745:2017 official publication](https://webstore.iec.ch/en/publication/31998), published **2017-03-07** | **DOC-CONFIRMED official abstract/scope ONLY** | Standard concerns cableless (radio/infrared) control between portable operator station and machine; includes interface/functionality requirements. | Exact normative clauses **not verified from the official purchased text**; no claim of any product conformity or numerical machine stop-time. |
| [Public EN 62745:2017 textual preview](https://standards.iteh.ai/catalog/standards/clc/0099edf8-5f7a-4a97-b9e2-9a840e61a705/en-62745-2017) | **DOCUMENT PREVIEW, NOT official purchased edition** | Preview exposes headings on neutral frame/re-establishment, safety-related stop/automatic stop, loss of valid signal, reset, multiple stations and loss of supply; suggests important review topics. | Exact edition/amendment applicability and all technical obligations require authoritative licensed verification for actual design. No copied normative design value is frozen here. |
| [Linemaster RF Wireless Hercules product SP-831-111000XA](https://linemaster.com/product/475/radio-frequency-wireless-hercules/SP-831-111000XA/) | **DOC-CONFIRMED OEM indexed product page** | Product listed as wireless momentary footswitch, 3 AA transmitter batteries, radio range and receiver; product currently marked unavailable. **Internal inconsistencies**: summary 400 h battery vs feature 700 h, “SPDT” versus feature text “SPST” on same product page. | Receiver loss-of-link timeout/output state, low-battery behavior, pairing, restart on reconnect, suitability for personnel-safety functions. Do not choose a battery life/contact configuration from conflicting page fragments. |
| [Linemaster RF Twin Aero](https://linemaster.com/product/513/rf-double-aero-wireless/) | **DOC-CONFIRMED OEM product page** | Advertises channel hopping, receiver relay output, battery indication, and a **typical latency** for that exact family. | Latency is **not** certified safety reaction time or the selected machine's physical stopping time. |
| [Schmersal current safety foot-switch product family](https://products.schmersal.com/en_US/foot-switch-1000075979) | **DOC-CONFIRMED OEM** | Positive-opening NC panic overtravel and mechanical reset belong to selected **wired device** variants. | No reason to transfer their panic/stop behavior to an ordinary wireless RF pedal. |

## Threat/fault model (INFERENCE, not observed behavior)

- **Held input on disconnect:** if the receiver output latches or retains last state, hazardous command could persist despite lost operator authority. This is a *hypothesis*, not a measured behavior of Linemaster.
- **Reconnection while held:** an ordinary input could reassert without release/new press. Require a qualified deliberate fresh-start contract; do not assume link reconnection itself constitutes intent.
- **Receiver power loss and restart:** a relay's contact state, machine PLC scan and HMI display are separate; evaluate physical final elements.
- **Wrong transmitter/receiver pairing or duplicate stations:** location/occupancy, handover and authorized station are independent of radio signal strength.
- **Low battery or interference:** indicator presence, range and CRC do not prove safe stop, stop latency or fault diagnostic coverage.
- **Footwear/guard relocation:** wireless removes a cable trip hazard but permits easier station relocation into an unsafe visibility zone; ergonomic gain creates a new configuration/authorization issue.

## Boundary architecture

`RF pedal -> receiver -> ordinary machine-cycle request` remains **normal control**, even if encrypted or CRC-protected. Independently selected safeguarding/E-stop and safety-related controller/final elements must enforce stop/hold regardless of wireless command; qualified cableless safety control is a different, explicitly designed and validated architecture. Do not repurpose ordinary radio packets, LinuxCNC HAL filtering or a normal FPGA watchdog as the only personnel-safety stop. For press brakes, prove Y1/Y2 physical stop/hold, gravity restraint, rear/die coverage and deliberate restart separately.

## Documented information-gain stop

No directly inspected exact Linemaster receiver installation manual in this pass established loss-of-link timeout, relay deenergization, battery-fault behavior, pairing or fresh-neutral-frame requirement. **These remain UNKNOWN**, not evidence of unsafe behavior or safety compliance. A frozen bench test is **not justified** without exact selected equipment and a specific unresolved question that authoritative documentation cannot answer. If the selected machine does use RF, obtain OEM receiver model/revision and manual first; qualified, isolated, no-person-exposure validation only after a machine SRS.

## Status

**SOURCE-CONFIRMED new LinuxCNC:** none. **DOC-CONFIRMED:** IEC official scope and exact OEM catalog claims with conflicts. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied upon. **INFERENCE:** failure paths above. **UNKNOWN:** installed radio/control, receiver output on link loss, stop performance, selected PL/SIL, independent physical machine evidence. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** 0 hosted/0 local compute, no Actions or physical tests.

## Same-session evidence upgrade — FCC-filed manufacturer industrial manual found

**This section supersedes the earlier “no directly inspected exact Linemaster receiver manual” source-availability statement above.** An original **manufacturer-authored, 17-page PRELIMINARY “RF Industrial Wireless Footswitch Operators Manual,” P/N RF Industrial Rev 005**, was retrieved from the public [FCC ID VPA-SP-831 filing, exhibit 1021767](https://fccid.io/VPA-SP-831/User-Manual/Users-Manual-1021767.pdf), submitted 2008-10-27, available 2008-11-03. This is **DOC-CONFIRMED for the historical industrial manual only**, not proof of current product firmware or installed OpenPressBrake equipment.

- **PDF p6 / printed p6, “Loss of signal”:** the examined receiver is documented to switch outputs off after **1,050 ms without a signal**; on signal restoration the manual says it resumes normal functioning. **It does not explicitly prove release-before-repress/neutral-frame gating** on reconnection. The 1,050 ms is a *documented historical receiver timeout*, **not** an acceptable press-brake safety stopping time or certified safety-function latency.
- **PDF p6:** tipping the transmitter ≥60° triggers an inhibit/LED indication, with behavior contingent on duration; pairing/station identity is described on printed p9. **No assertion** that this tip switch is a personnel-safety stop.
- **PDF p4:** manufacturer expressly warns against use with an unguarded point of operation. **PDF p16:** typical RF command latency is listed separately as **50 ms**. Do **not** conflate latency, 1,050 ms link-loss detection, final-element response or machine stop time.
- **Manual limitation:** stamped **PRELIMINARY** and dated 2008; it cannot establish current 2026 industrial RF model behavior. The same FCC filing includes a separate [RF Medical Wireless Footswitch rev 001 manual](https://fccid.io/VPA-SP-831/User-Manual/Users-Manual-1021772.pdf), which also describes 1,050 ms but has **different** medical contact/rating/environment details. Do not transfer medical ratings or manual instructions to industrial units.
- **Standards/era caution:** the official IEC 62745 publication is dated 2017. A public third-party preview discusses re-establishment, deliberate new initiation and automatic stop. An old 2008 preliminary OEM timeout and a 2017 safety-standard preview cannot be declared either conformant or nonconformant without exact system function, normative licensed edition and machine risk assessment. **Potential discrepancy remains OPEN**; do not quietly treat 1,050 ms as the standard's recommended value.

**Updated unresolved question:** For a *selected and identified* receiver/firmware, does reconnection while a transmitter pedal is held regenerate an asserted output without a neutral/release cycle? The historical phrase “function normally” is insufficient. The next evidence should be current OEM receiver instructions and machine SRS; only then decide whether a bounded isolated bench experiment is justified. No lab was run.
