# STO / Contactor / DC-Bus Stored-Energy Boundary Study — 2026-09-17

## Lane and scope

Independent LinuxCNC/OpenPressBrake safety-curriculum Lane B. At selection time current `main` ended at `18ea6919` (`checkpoint: preserve hydraulic safety commissioning next work`) after the primary lane added a HAWE monitored-hydraulic commissioning fault card. This study deliberately avoids that hydraulic module/evidence package and advances the independent electrical stored-energy/service-isolation boundary.

No executable verification was needed. No GitHub-hosted or self-hosted runner compute was consumed.

## Question

When a safety function removes motor torque with STO or opens an upstream contactor, what has actually been proved about hazardous electrical energy inside the drive and about safe maintenance access?

## Evidence provenance

### E1 — Rockwell PowerFlex 755T STO keeps the drive powered

**SOURCE-CONFIRMED.** Rockwell describes PowerFlex 755T Safe Torque Off as removing rotational power to the motor **without removing power from the drive**, specifically to permit faster startup after a safety demand.

Source: Rockwell Automation, PowerFlex 755T product page, accessed 2026-09-17:
https://www.rockwellautomation.com/en-us/products/hardware/vfds-variable-frequency-drives/powerflex-755t.html

### E2 — Rockwell service procedure requires direct DC-bus voltage verification

**DOC-CONFIRMED.** Rockwell's PowerFlex 750-Series service documentation warns of injury/death from electric shock and requires verification that bus capacitors have discharged before servicing. Depending on frame, it instructs measurement between DC+ and DC- and also from each bus pole to chassis/ground. This is physical electrical evidence, not an inference from STO, contactor state, an HMI bit, or an indicator lamp.

Source: Rockwell Automation, PowerFlex 750-Series Products with TotalFORCE Control, `Personal Safety`, accessed 2026-09-17:
https://www.rockwellautomation.com/en-us/docs/technical/powerflex/_online/750-tg100/powerflex-750-series-products-with-totalforce-cont/before-your-begin/personal-safety.html

### E3 — Schneider requires disconnect/lockout, waiting, and measured DC-bus voltage

**DOC-CONFIRMED.** Schneider's Altivar Process enclosed-drive instructions require disconnecting all power including external control power, locking the disconnect open, waiting for DC-bus capacitors to discharge, and then following a DC-bus voltage measurement procedure. The document explicitly states that the drive LED is not an indicator of absence of DC-bus voltage.

Source: Schneider Electric, Altivar Process Drives instruction bulletin, accessed 2026-09-17:
https://productinfo.se.com/altivarprocessdrivesib/nve92630-altivar-680-process-drive-ib/English/NVE92630%20%28bookmap%29_DD00770626.xml/%24/Introduction-5DCB4E2D

### E4 — Schneider explains why DC-bus discharge time is a personnel-safety issue

**SOURCE-CONFIRMED.** Schneider explains that published DC-bus discharge time exists to establish how long personnel must wait after power disconnection before touching live parts; the example is explicitly based on bus voltage decay, not on an STO indication or control-state bit.

Source: Schneider Electric FAQ FA364579, accessed 2026-09-17:
https://www.se.com/us/en/faqs/FA364579/

### E5 — Motor-side mechanical energy can regenerate voltage

**DOC-CONFIRMED.** Schneider's Altivar Process installation/maintenance instructions warn that motors can generate voltage when the shaft is rotated and instruct service personnel to block the motor shaft before work on the drive system. Thus even source disconnection is not a universal proof that every electrical node is incapable of becoming energized.

Source: Schneider Electric, Altivar Process 980 installation/maintenance instructions, accessed 2026-09-17:
https://productinfo.se.com/altivarprocessdrivesib/qgh27523-altivar-980-process-drive-ib/English/QGH27523%28bookmap%29_DD00779606.xml/%24/InstallationAndMaintenanceInstructi-74D22C50

## Frozen architecture distinctions

The curriculum shall preserve these as separate claims:

`STO ACTIVE`

`!= MOTOR TORQUE PRODUCTION ENABLED`

`!= DRIVE MAINS REMOVED`

`!= DC BUS DE-ENERGIZED`

`!= ALL EXTERNAL CONTROL POWER REMOVED`

`!= MOTOR/LOAD UNABLE TO REGENERATE VOLTAGE`

`!= ELECTRICAL SERVICE ISOLATION PROVED`

`!= MECHANICAL / HYDRAULIC / GRAVITY ENERGY CONTROLLED`

Also:

`UPSTREAM CONTACTOR OPEN COMMAND`

`!= CONTACTOR MAIN POLES PHYSICALLY OPEN`

`!= DC BUS ALREADY DISCHARGED`

`!= SAFE TO TOUCH DRIVE POWER CIRCUIT`

The earlier mirror-contact/EDM work remains useful evidence about commanded final-element state, but it must not be promoted into a claim that downstream capacitors are discharged or every hazardous energy source is absent.

## Practical OpenPressBrake architecture consequence

**INFERENCE.** OpenPressBrake should model at least three distinct purposes instead of collapsing them into one generic `SAFE` signal:

1. **Personnel safety motion authority:** e.g. an independent safety function can remove hazardous torque/motion authority while the drive remains electrically powered if the selected architecture and validated safety function permit it.
2. **Operational power state:** whether ordinary machine power/contactors/drives are commanded and proven in their expected operating state.
3. **Maintenance/service isolation:** a separate physical energy-control condition requiring the machine-specific disconnect/lockout/discharge/blocking procedure and, where required by the equipment documentation, direct voltage verification.

LinuxCNC/HAL/ordinary FPGA may display diagnostic state, request ordinary shutdown, or report a safety permissive. They must not synthesize `SAFE TO SERVICE` merely from `STO=active`, `drive ready=false`, `K1/K2 commanded off`, EDM healthy, loss of communications, or a dark drive display.

This is an architecture teaching rule, not a claim that a particular OpenPressBrake VFD, servo drive, disconnect, contactor, or discharge circuit has already been selected.

## Failure-path matrix

| Fault / condition | What may still be true | What is NOT proved | Required curriculum response |
|---|---|---|---|
| STO asserted normally | Torque-producing output is inhibited per the validated drive safety function | Drive mains absent; DC bus discharged | Keep motion-safety state separate from service-isolation state |
| K1/K2 open correctly | Upstream feed may be interrupted | Downstream bus is already discharged | Follow equipment-specific discharge/verification procedure |
| HMI/drive LED dark | Indicator/control state changed | Bus voltage absent | Never use lamp/display state as sole service proof |
| Drive control powered from separate 24 V | Main power may be absent while logic remains alive | All electrical sources isolated | Identify and isolate external/control supplies relevant to the task |
| Bus discharge resistor open/degraded | Input contactor can still open | Expected passive discharge behavior remains valid | Treat discharge circuit as a component/failure path; verify voltage as required |
| Rotating motor/load after source isolation | Mains may be disconnected | Motor-side conductors cannot be energized | Control mechanical motion; follow manufacturer service procedure |
| EDM reports contactors open | Feedback is consistent with monitored contactor state | Stored downstream energy absent | EDM is diagnostic witness, not stored-energy measurement |
| LinuxCNC says machine OFF | Ordinary control requested OFF | Safety authority state or physical isolation | Do not grant ordinary software physical-safety authority |

## Commissioning / validation questions

These are questions, not invented acceptance values:

- What exact drive family is installed and what does its safety manual say STO removes and retain?
- Which electrical sources remain energized when the safety function demands STO?
- Which sources remain energized when upstream machine contactors open?
- Where are the manufacturer's permitted DC-bus measurement points?
- What wait/discharge procedure does the selected drive require?
- Does the selected drive expose a bus-voltage diagnostic, and is that diagnostic explicitly acceptable for service isolation? Do not assume it is.
- Can motor/load motion regenerate hazardous voltage after source isolation?
- Are external 24-V, brake, regenerative, common-DC-bus, UPS, or auxiliary supplies present?
- What physical disconnect/LOTO points control each source?
- What stored mechanical, pneumatic, hydraulic, spring, gravity, or thermal energy remains after electrical isolation?
- What evidence must be re-established before ordinary restart after maintenance?

## Evidence-status ledger

- **SOURCE-CONFIRMED:** Rockwell states STO can remove rotational motor power without removing power from the drive.
- **DOC-CONFIRMED:** Rockwell requires DC-bus voltage measurement before service on the cited PowerFlex family.
- **DOC-CONFIRMED:** Schneider requires disconnect/lockout, capacitor-discharge wait, and DC-bus measurement on the cited Altivar Process equipment and says the LED is not absence-of-voltage proof.
- **SOURCE-CONFIRMED:** Schneider identifies DC-bus discharge timing as a personnel electrical-safety concern.
- **DOC-CONFIRMED:** Schneider warns a rotating motor can generate voltage and requires mechanical blocking in the cited service context.
- **INFERENCE:** OpenPressBrake should expose separate motion-safety, operational-power, and service-isolation concepts and prohibit ordinary software from deriving `SAFE TO SERVICE` from STO/EDM alone.
- **TEST-CONFIRMED:** none in this study.
- **COMMUNITY-REPORTED:** none relied upon.
- **UNKNOWN:** actual OpenPressBrake drive family, bus capacitance, discharge circuit, discharge time, voltage threshold, measurement points, external supplies, common-bus/regeneration topology, contactor/disconnect architecture, service-isolation procedure, and mechanical/hydraulic residual-energy behavior.

## Explicit non-transfer rule

Do not copy Rockwell or Schneider wait times, voltage limits, wiring, drive architecture, STO performance, PL/SIL/category, discharge behavior, or service procedure onto OpenPressBrake. The selected hardware's current manufacturer documentation and machine measurements must supply those facts.

## Precise next independent work

Highest-value continuation if the primary lane remains on hydraulic/fall-protection work:

**Trace a professional drive/common-DC-bus implementation that exposes upstream disconnect/contactors, DC-link discharge path, STO, external control power, motor regeneration/backfeed, measurement points, and return-to-service sequence in one evidence package.** Produce a source-to-physical-energy map distinguishing motion inhibition from electrical service isolation.

If the primary lane moves onto that package first, rotate Lane B to one of these independent branches rather than duplicate it:

1. safety-output/contactor coil backfeed and separate-supply common-cause fault injection worksheet; or
2. brake-release / gravity-axis sequencing boundary: STO can remove torque while a mechanically held vertical axis has a distinct brake/load-retention safety question.
