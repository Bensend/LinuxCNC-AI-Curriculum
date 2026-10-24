# 4400-RAD-02 — Cableless control standards scope and mobile/tablet authority boundary
**Date:** 2026-10-24. **Purpose:** distinguish a purpose-built certified radio STOP system from a general Wi-Fi/tablet/phone HMI. **Status:** source research, not a normative compliance determination or selected-machine test.

## Primary publisher and industry source
- **IEC 62745:2017 edition 1.0**, *Safety of machinery — Requirements for cableless control systems of machinery*. [Official IEC publisher record](https://webstore.iec.ch/en/publication/31998), dated **2017-03-07**, 27 pages, IEC TC44. The publisher's abstract confirms the scope covers cableless communication between portable operator stations and machine control. The **complete normative standard was not licensed/read here**. Official publisher metadata only is **DOC-CONFIRMED**; detailed clause interpretations are not independently verified from the official text.
- **FME (Dutch federation of technological-industry enterprises), `Cableless control of machinery`**, 11-page original [FME PDF](https://www.fme.nl/system/files/publicaties/2024-04/FME%20Brochure_A4_Cables%20of%20control%20of%20machinery_LR.pdf), uploaded April 2024; internal scope says **status March 2023**. Directly inspected pp.1–8. It is an **industry guideline, not an IEC/ISO standard, certification, regulation or selected-machine proof**.
- **IEC 62745:2017+A11:2020** appears in [EVS standards publisher catalog](https://www.evs.ee/en/evs-en-62745-2017-a11-2020-consolidated) as a European consolidated edition; **prEN IEC 62745:2025** is listed as a draft, not assumed adopted or superseding. The exact applicable edition and local jurisdiction require separate assessment.

## Direct FME document findings (DOC-CONFIRMED *industry guidance*, not normative requirements)
FME's own scope primarily addresses general-purpose wireless devices **not originally designed for machine safety** (mobile phones, tablets, laptops); its document explicitly excludes purpose-built radio products from its main scope. The guideline calls for an additional hardwired local start/stop station, an independent fixed emergency stop, authorization/identity management, unambiguous connection-state indication, monitoring of communication, deliberate reconnection, and preventing link restoration from causing automatic machine motion or resetting an emergency stop. It distinguishes initial machine/system start from process or manual movement after initialization.

FME presents a **0.5-second** connection-loss upper bound as its **guideline recommendation**; **do not** transplant that number into a selected machine's radio safety response budget or call it an IEC 62745 universal requirement. The selected machine's hazard analysis, chosen safety product and applicable normative edition govern. FME's table discussing functions on general-purpose devices is guidance only and cannot qualify a tablet touch control as a personnel-safety device.

## Engineering reconciliation
- A general-purpose **Wi-Fi tablet, browser or phone** can display normal CNC diagnostics, send permitted non-safety commands or stage recipes **only when** independent machine safeguarding and motion authorization remain effective. An onscreen STOP or green 'connected' badge is **not** an independently certified safety stop.
- A purpose-built radio pendant can have a certified STOP subsystem, but its exact paired hardware, firmware, safety-mode settings, safety terminals and physical final elements must be verified. The manufacturer's STOP subsystem claim does not automatically certify its normal motion controls.
- **Automatic stop on communication loss** is a different function from **manual emergency stop** and from **normal command stop**. A broken Wi-Fi link may leave a retained LinuxCNC motion request or a last output; safety must be implemented outside ordinary LinuxCNC/FPGA and software link indicators.
- **Fixed local E-stop and guarded local access** remain the practical baseline for the studied machine classes unless a risk assessment and applicable requirements justify alternatives. A phone can be lost, powered off, locked, or taken out of range, making it unsuitable as the only readily accessible emergency intervention.
- **Restore connection != restore motion.** A fresh link and successful authentication do not prove clear hazardous space, stopped/held Y1/Y2, safe tool retention, valid setup mode, or deliberate new start.
- Remote HMI should be **read-only by default**; if local process commands are permitted, use explicit local enable, time-limited authorization, visible identity and independent guard/stop/holding architecture. Do not create a remote safety-reset or maintenance-isolation bypass.

## Adversarial failure paths
| Shortcut | Consequence | Practical better default |
|---|---|---|
| Replace fixed E-stop with touchscreen red square | Battery/app/network failure removes access to emergency intervention | Keep physically accessible hardwired local emergency-stop controls |
| Use Wi-Fi heartbeat to drive normal LinuxCNC feed-hold only | Motion may persist on stale HAL/FPGA demand or software crash | Independent qualified safety chain and physical final-element proof |
| Permit reconnection to resume held cycle | Surprise motion while operator is clearing jam | Latch inhibit; fresh deliberate machine start after visibility and occupancy check |
| Let any paired phone assume control | Unobserved operator takeover or malicious/accidental commands | One active owner, explicit local handoff and audit trail |
| Reduce radio timeout to prevent nuisance stops without checking physics | Inadequate hazard response or nuisance-induced bypass | Selected safety subsystem configuration plus risk-based total reaction and human-factor review |
| Use safety PLC green status as proof | Welded contactor or falling ram can remain | Independent terminal, mechanical/hydraulic stop/hold witness |

## Transfer and limits
For press brakes, preserve separate Y1/Y2 stop, gravity holding, front/rear guarding and deliberate cycle start. For mills/lathes, preserve spindle/tool and door/access safe state; for robots/cells, preserve workspace occupancy and suspended payload retention. The precise protection architecture is machine-specific. **UNKNOWN:** selected machine's use of any phone/tablet or radio pendant, actual connection timeout, end-to-end PL/SIL, physical stop/hold and jurisdictional edition. **No physical tests or compute**. No full licensed IEC 62745 text read; do not claim detailed normative conformance.
