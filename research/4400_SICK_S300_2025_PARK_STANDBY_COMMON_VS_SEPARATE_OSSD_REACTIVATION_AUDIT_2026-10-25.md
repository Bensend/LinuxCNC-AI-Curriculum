# 4400-SCAN-03 — Park/standby and common versus separate OSSDs
**2026-10-25 | DOC-CONFIRMED original SICK S300 manual | NON-GRADUATED**

## Question and direct source
Does parking one scanner always remove both scanners' safety outputs, and does 'not an error' mean protective scanning is active? **No to both generalizations.** Original SICK S300 *Operating Instructions* **8010948/ZD76/2025-08-19**, §7.13.6 printed **pp.104–105** and troubleshooting printed **p.121**:
https://www.sick.com/media/docs/3/13/613/operating_instructions_s300_safety_laser_scanner_en_im0017613.pdf

**DOC-CONFIRMED exact OEM:** Park/standby can turn the laser OFF and OSSDs OFF for specified mobile applications. In an EFI pair using **common OSSDs**, parking either scanner turns the common OSSDs OFF. With **separate OSSDs**, only the parked scanner's OSSDs turn OFF. Park mode is selected as a monitoring case; standby has a dedicated **single-channel STBY input** or EFI command. The troubleshooting display identifies park/standby with OSSDs OFF and laser OFF as **not an error**; readiness returns when the park/standby criteria are withdrawn. Park-to-active transition takes the configured response time.

## Why it matters
An operator may see 'no fault' while the optical protective function is intentionally unavailable; a technician may assume parking either scanner inhibits all hazardous zones, even though output grouping determines the effect. Conversely, restoring active mode does not itself establish empty hazard zone, downstream manual rearm, fresh motion request, physical stop/hold or measured stop time. **INFERENCE:** park/standby authority must be allocated to the safety-related design with mode-dependent guarding and independently reviewed restart; ordinary LinuxCNC HMI must not decide personnel-safe protective coverage.

## Failure-path questions
1. Which exact scanner is parked and by which rated input/command?
2. Common versus separate OSSD architecture and actual protected zones?
3. Is laser OFF visible to operator as *not monitoring* rather than *safe to enter*?
4. Does removing standby cause automatic OSSD restoration, or are there external interlocks? **UNKNOWN until exact configuration and OEM full-path review.**
5. What independent physical final elements maintain safe Y1/Y2 stop/hold while scanning is absent?
6. Are maintenance isolation and rescue handled separately from mobile charging convenience?

## Boundaries
**DOC-CONFIRMED** OEM behavior above; **SOURCE-CONFIRMED new LinuxCNC:** none; **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none relied on; **INFERENCE** independent rearm and mode/access design; **UNKNOWN** installed OpenPressBrake equipment, PL/SIL, pressure isolation, actual stop/hold and evaluator. This is not evidence of automatic machine motion, and not a recommendation to use standby as a press-brake safety mode. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD**. No compute or personnel-exposed testing.
