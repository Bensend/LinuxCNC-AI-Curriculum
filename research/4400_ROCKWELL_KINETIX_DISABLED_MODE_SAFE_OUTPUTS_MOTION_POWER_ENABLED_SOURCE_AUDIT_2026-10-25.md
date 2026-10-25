# 4400-COMM-01 — Original-OEM disabled safety mode: safe-looking outputs while commissioning motion power remains enabled
**2026-10-25 | DOC-CONFIRMED exact Rockwell 2013 mode, not an OpenPressBrake as-built claim**

## The new failure-path discriminator
The phrase **“all safety outputs are in their safe state”** does **not** prove that the drive has removed motion power or that machine hazards are controlled in every configuration. The original Rockwell Kinetix manual documents an explicit commissioning exception.

## Primary evidence
Rockwell Automation *Kinetix 6200 and Kinetix 6500 Safe Speed Monitoring Safety Reference Manual*, **2094-RM001C-EN-P May 2013**, original OEM PDF https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/2094-rm001_-en-p.pdf . Chapter 2, **printed p.22 (PDF page 21)** directly opened and visually inspected. The product supports eleven operation modes. Its **Disabled** mode explicitly says:
- all safety functions disabled;
- input/output/speed-monitor diagnostics do not take place;
- all safety outputs in their safe state;
- **motion power enabled for drive commissioning**;
- Safe Stop motion monitoring operates in other modes, **not Disabled**.

**DOC-CONFIRMED** for this product/edition only. “Motion power enabled” is availability, **not** a claim that motion occurs automatically or that a particular machine was configured this way. Do not infer the external wiring from the internal output label.

## Why this matters
An ordinary status/HMI may show a deenergized safety output, a zero speed command, or a disabled-safety mode label, while a separate commissioning control path can still enable motor power. It is incorrect to translate **output safe state** into **machine physical safe state** without tracing the complete power/torque path and active configuration.

| Proposition | This OEM Disabled mode can establish | It cannot establish |
|---|---|---|
| Safety option monitoring | Not operating (documented) | Any validated protective stop |
| Safety outputs | In their configured safe states | Motor power removed or hazardous load physically held |
| Commissioning motion power | Available/enabled in this mode | Motor is necessarily moving or safe to approach |
| Guard release | Must be assessed independently | Occupancy/escape, pressure, gravity and coast-down controlled |
| Change control | Exact mode matters | Automatic restoration of a validated safety configuration after commissioning |

**Counterfactual:** If a retrofit uses ordinary LinuxCNC/FPGA stop logic while a safety option is in Disabled mode, a nominally green output/diagnostic view could coexist with an uncontrolled hazardous motor-power path. This is **INFERENCE** until exact installed circuit/configuration is known, not proof of a field defect.

## Safe commissioning pattern
Qualified team defines a temporary **isolated/remote commissioning boundary** with people outside the danger zone, independent energy controls, documented mode and access authority, explicit controlled enable, visible physical exclusion, and a restoration/revalidation checklist. Never defeat a guard or rely on ordinary LinuxCNC emergency-stop alone to compensate for an inactive safety function. Before release, verify the intended safety mode and configuration, each input/output/final element, guard/escape, gravity/hydraulic restraint and deliberate restart; commissioning authority must not silently carry into production.

## Related source distinctions
- [ACCESS-01](4400_ROCKWELL_KINETIX_SAFE_STOP_UNCHECKED_UNLOCK_STATUS_ONLY_AND_POWER_TO_LOCK_SOURCE_AUDIT_2026-10-25.md): timer-only unlock, status-only SLS, and power-to-lock output polarity are separate *active-mode* limitations.
- [ENC-01](4400_KINETIX_SINGLE_ENCODER_SIL_CLAIM_COUPLING_EXCLUSION_AND_MOTION_DEPENDENT_DIAGNOSTICS_AUDIT_2026-10-25.md): even an active monitor's safety integrity depends on qualified sensor-to-load mechanical coupling and diagnostics.
- This COMM-01 **Disabled** state is not the same as an E-stop, safety-rated STO, lockout, or safe service access.

## Claim and test status
**DOC-CONFIRMED** exact 2013 original manual p.22, visually checked. **SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **INFERENCE:** machine-specific exposure risk and commissioning restoration design. **UNKNOWN:** selected machine configuration, actual motor-power contactor path, Y1/Y2 hydraulic/gravity hold, guards/escape, PL/SIL, qualified physical test and evaluator. No compute justified: the manual resolves exact-mode behavior; do not simulate a hazard to reprove it. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD; no people-exposed operation.
