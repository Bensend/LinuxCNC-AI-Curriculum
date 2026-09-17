# Professional Press-Brake BendGuard Periodic Validation Trace

Date: 2026-09-17
Scope: curriculum evidence trace joining the TRUMPF TruBend machine-level safeguard to the SICK V4000 Press Brake device-level functional test. This is not an OpenPressBrake design specification and does not universalize OEM intervals or values.

## Provenance labels

- `DOC-CONFIRMED` — stated by cited manufacturer documentation.
- `SOURCE-CONFIRMED` — stated by an authoritative non-manufacturer source.
- `INFERENCE` — engineering conclusion drawn from labeled evidence.
- `UNKNOWN` — not established by the inspected public evidence.

## 1. Machine-level safety function

`DOC-CONFIRMED` — TRUMPF describes BendGuard as monitoring the region below the upper tool with a light field. The TruBend Series 2000 manual further describes BendGuard monitoring such that raising the BendGuard by an obstacle during bending stops the press beam.

Machine-level consequence: the relevant proof is not merely that the optical device powers up or reports healthy. The credited machine safeguard must detect the defined intrusion/obstruction and cause the intended press-beam stopping behavior.

## 2. Device-level functional challenge

`DOC-CONFIRMED` — SICK V4000 Press Brake operating instructions define a functional test that checks multiple distinct aspects: protective function with the specified test body/test rod, distance to the tool, emergency-stop behavior, and overrun/stopping travel. The procedure requires the press to be tooled across the working length, transmitter/receiver initial alignment to be correct, the V4000 PB powered, standard protective-volume mode selected, and the startup cycle performed before the functional test.

`DOC-CONFIRMED` — the SICK instructions identify the protective-function challenge as using a test rod/object of 14 mm in the documented procedure. This value is manufacturer/device-specific evidence and is not promoted into a universal press-brake or OpenPressBrake acceptance value.

## 3. Device self-test is not the complete machine proof

`DOC-CONFIRMED` — SICK documents reset/power-up as including self-test and a startup cycle. It separately documents the functional test described above.

`INFERENCE` — therefore successful self-test/startup is evidence about device diagnostics, but it does not replace the separate physical functional challenge. Curriculum rule:

> DEVICE HEALTHY != PROTECTIVE FUNCTION PHYSICALLY VALIDATED.

Likewise, a LinuxCNC bit, HAL state, FPGA register, safety-controller status word, HMI icon or successful production cycle cannot substitute for the physical challenge when the credited safeguard requires one.

## 4. Setup, tool and material changes can alter the relevant boundary

`DOC-CONFIRMED` — TRUMPF bending-tool guidance says correct BendGuard setup/mute-point treatment must account for wide tools, stop plates, positioning plates and other tool-mounted geometry. It also warns that pneumatically/hydraulically controlled tools are not monitored by BendGuard.

`DOC-CONFIRMED` — SICK V4000 PB instructions require re-teaching when sheet/workpiece thickness changes in the documented operating mode.

`INFERENCE` — safeguard validity therefore depends on more than unchanged safety-controller logic. Tool geometry, device alignment/position, protective-volume setup, mute/tool-change treatment and workpiece-dependent teaching can alter what the protective system actually sees. A configuration checksum alone cannot prove those physical relationships remain valid.

## 5. Periodic / change-triggered challenge chain

Use the applicable machine and device manuals to determine the real interval and trigger. Do not substitute this curriculum artifact for them.

For each required challenge, record:

1. **Installed identity** — machine, BendGuard/V4000 device identity, applicable manual/revision and current tooling/configuration.
2. **Preconditions** — tool coverage, alignment, selected protective mode, startup state and any required teaching/configuration state.
3. **Physical challenge** — correct manufacturer-specified test object/procedure at the required locations/conditions.
4. **Device observation** — device detects the challenge without an unexplained fault or bypass state.
5. **Machine observation** — hazardous press-beam behavior reaches the OEM-defined safe result; do not infer this solely from a controller indication.
6. **Stopping/overrun evidence** — where the OEM procedure requires this, use the specified method and acceptance basis. Never invent a distance or time.
7. **Damage/alignment inspection** — inspect mounting, optics/device body, alignment and relevant installation condition where required.
8. **Fault disposition** — failed or ambiguous challenge means the affected exposed operating state is NOT CLEARED until cause is corrected and the required proof is repeated.
9. **Change trigger** — after relevant collision, tool/setup change, device movement/replacement, wiring/configuration change or other OEM-defined trigger, reopen the affected validation scope.
10. **Restoration** — confirm temporary test/setup states are removed and ordinary production mode is restored before release.

## 6. Failure-path analysis

### A. Healthy diagnostics, failed physical protection
Possible families include physical misalignment, changed geometry, incorrect protective-volume/mute setup, obstruction/damage or an installation relationship not represented by controller diagnostics. Do not defeat the safeguard to recover production; diagnose the physical chain.

### B. Device detects challenge, machine does not reach required stopping result
Treat this as a machine-level safety-chain failure until resolved. Investigate the path from safeguard output through safety logic to final elements and physical hazardous motion. Do not declare success because the sensor itself changed state.

### C. Tool or accessory creates an unmonitored hazard
TRUMPF explicitly warns that some pneumatically/hydraulically controlled tool hazards are not monitored by BendGuard. BendGuard coverage therefore must not be generalized to every crushing/shearing hazard around the tooling.

### D. Repeated nuisance trips create bypass pressure
Do not widen mute behavior, move the device, suppress diagnostics or normalize a bypass merely because production is inconvenienced. Determine whether geometry, alignment, setup workflow, contamination/damage or another correctable cause is creating the recurring demand. Make correct safeguard use easier than defeat.

## 7. OpenPressBrake transfer lesson

The transferable architecture is not "copy BendGuard." It is:

`protective-device physical challenge -> device detection -> independent safety logic -> final-element action -> physical hazardous-motion result -> deliberate restart/rearm`

Normal LinuxCNC/FPGA may display status, record diagnostics and participate in ordinary sequencing, but it must not become sole personnel-safety authority merely because the machine UI knows the tool or program.

If an OpenPressBrake retrofit uses a press-brake protective device, its exact device manual, installed geometry, machine stopping capability, safety logic/final elements and commissioning evidence must establish the real acceptance procedure. Until those facts exist, stopping distance/time, mute point, PL/SIL/DC, device placement and hydraulic truth tables remain `UNKNOWN`.

## 8. Sources inspected

- TRUMPF TruBend Series 2000 (B35) operator/install manual B1161en, 2023-05-01.
- TRUMPF Supplement to operator's manual — Bending tools, M616en, 2024-06-01.
- SICK V4000 Press Brake operating instructions, document 8010502/TL63/2009-11-27.

## Frozen curriculum rule

> A protective-device self-test proves only what the self-test actually observes. Periodic validation must challenge the credited protective function through to the physical machine result, and relevant setup/tool/device changes must reopen the affected validation scope.
