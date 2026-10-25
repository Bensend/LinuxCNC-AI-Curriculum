# 4400-OSSD-01 — SICK TGS OSSD self-test pulses, unmonitored signal and downstream final-element proof
**Original manufacturer document directly inspected 2026-10-25; historical 2009 device; not an OpenPressBrake component claim.**

## Concrete source question
Can a safety light curtain's brief, deliberate OSSD LOW self-test be misinterpreted as a real protective stop by an incompatible downstream receiver, and can an unmonitored auxiliary signal be treated as an equivalent safety channel? **Pre-source prediction:** a pulsed active OSSD requires compatible downstream evaluation; an ordinary diagnostic/signal output may not have the same internal diagnostic integrity. Both require exact device evidence.

## Primary original source
**SICK AG, "TGS Testable Safety Light Curtain," Operating Instructions 8010478/TA96/2009-12-03**, directly opened original 36-page PDF, https://www.sick.com/media/docs/5/15/615/operating_instructions_tgs_testable_safety_light_curtain_en_im0014615.pdf .

- Printed **p. 21, §5.1**: OSSD cycles briefly LOW while otherwise active; manufacturer requires downstream control elements to tolerate the documented self-test pulses rather than undesirably switching off. This is **DOC-CONFIRMED** for TGS, not all OSSDs.
- Printed **p. 21, §5.1**: the additional **signal output is not monitored**. The manual nonetheless describes its role in a specific two-channel PLC integration so an OSSD fault can be signalled. This is not a claim that the signal output by itself is a safety-rated equivalent to OSSD.
- Printed **pp. 22–23, §5.2**: if the described two-channel connection cannot be used, the manual prescribes a particular external cyclic test approach; its controller must check OSSD and the final switching device, with special restart-lock conditions. Do not transfer the historical timing limits to current machines.
- Printed **p. 27, §7.1**: original device has product-specific pulse width, rate, load capacitance, permissible cable resistance and notes about output LOW recognition if 0 V is interrupted. These **do not establish** settings for a replacement light curtain, safety input or OpenPressBrake.
- Printed **p. 8 §2.4 and p. 9 §2.5**: protective-field bypass prevention, qualified configuration-change review, documented tests, safe power supply and maintenance inspection remain part of the protective function.

## Two distinct failure families
**Family A — nuisance shutdown / unsafe bypass incentive:** an otherwise healthy OSSD sends expected brief LOW self-test pulses. An incompatible input, relay, filter or long capacitive cable can produce nuisance fault/trips; a mechanic might disable monitoring or bypass the guard to keep production running. This *system-level consequence* is **INFERENCE**; the manufacturer **DOC-CONFIRMS** the compatibility requirement. The correct response is exact OEM compatibility review and qualified redesign, not suppressing the safety demand.

**Family B — unsafe confidence in auxiliary channel:** the TGS's unmonitored signal output is interpreted as a second safety-rated OSSD. The OEM explicitly distinguishes it; any claimed safety performance requires the **complete OEM-described evaluation**, fault handling and monitored final switching device. Do not wire it to an ordinary LinuxCNC input and call that a second independent safety channel.

## Cross-vendor contrast and boundary
- Rockwell 5034-IB8S/XT [input test-source audit](4400_ROCKWELL_PILZ_TEST_PULSE_SHARED_SOURCE_CROSS_SHORT_AND_SAFETY_INPUT_VARIANT_AUDIT_2026-10-25.md) concerns **receiver-sourced field-contact pulses**, not necessarily the same mechanism as a **sensor's own OSSD self-test**. The signal direction and diagnostic owner differ.
- Rockwell 5034-OB8S/XT [output SA+ backfeed audit](4400_ROCKWELL_POINTMAX_SAFETY_OUTPUT_SA_BACKFEED_DETECTED_NOT_SAFE_OEM_AUDIT_2026-10-25.md) concerns a **downstream load remaining energized despite a detected output fault**. Neither input self-test nor OSSD status proves actual Y1/Y2 hydraulic stop/hold.
- The SICK TGS is historically optimized for weaving machines; **do not infer press-brake compliance or apply 2009 numerical placement/timing data to OpenPressBrake**. Current protective-device selection requires current exact OEM and applicable machine standards.

## Practical G0 evidence request
Record exact protective device part/revision, monitored safety output(s) versus auxiliary status, self-test waveform from OEM documentation, receiver compatibility and input filter/mode, output cable capacitance/resistance/routing, final element/EDM monitoring, protective-field geometry and deliberate restart. Only qualified independent machine-specific physical evidence can close the actual stop/hold/guarding gate. Avoid energized pulse injection, guard defeat, invented filter delays or assumed PL/SIL.

## Claims ledger
| Claim | Class | Limit |
|---|---|---|
| TGS OSSD brief LOW self-test must be tolerated by downstream control | **DOC-CONFIRMED** | TGS original §5.1 |
| TGS additional signal output is not monitored | **DOC-CONFIRMED** | TGS original §5.1 |
| An ordinary second signal alone gives a second safety-rated channel | **NOT ESTABLISHED** | OEM requires specific evaluation |
| Exact replacement device/receiver accepts TGS waveform | **UNKNOWN** | Requires exact models and manuals |
| Selected OpenPressBrake light curtain, physical stop, hold or response time | **UNKNOWN** | No selected-machine evidence |
| New LinuxCNC SOURCE-CONFIRMED / TEST-CONFIRMED / external score | **NONE** | Documentary only |

**No compute justified:** the source resolves the component-specific documentary question. Independent physical acceptance and external competency evaluation remain NOT RUN.
