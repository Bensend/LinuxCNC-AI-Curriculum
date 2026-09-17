# Drive STO restart / command-edge evidence trace

Date: 2026-09-17
Lane: independent safety curriculum Lane B

## Question

When a drive-integrated safety function such as STO is removed, what prevents a pre-existing ordinary run command from immediately becoming motion again?

This trace narrows the previous stale-command study to manufacturer-documented drive behavior. It does **not** define OpenPressBrake behavior.

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by identified manufacturer documentation.
- **DOC-CONFIRMED** — confirmed by an applicable machine/project document.
- **TEST-CONFIRMED** — demonstrated on the applicable machine/configuration.
- **COMMUNITY-REPORTED** — useful experience report, not design proof.
- **INFERENCE** — engineering conclusion from bounded evidence.
- **UNKNOWN** — not established for the installed OpenPressBrake machine.

## Siemens SINAMICS S120 restart sequence

**SOURCE-CONFIRMED:** Siemens SINAMICS S120 Drive Functions Function Manual, 06/2019, section 11.4, documents an explicit restart sequence after STO:

1. Deselect STO.
2. Set the drive enables.
3. Cancel the drive's `switching on inhibited` state and switch the drive back on using transitions at `ON/OFF1`: a 1→0 edge cancels the inhibit, then a 0→1 edge switches the drive on.

This is strong evidence against the unsafe generic assumption that simply restoring STO authority is equivalent to a new ordinary start command. In this documented SINAMICS configuration, restart includes additional state/edge requirements after STO deselection.

Source: Siemens, *SINAMICS S120 Drive Functions Function Manual*, 06/2019, 6SL3097-5AB00-0BP2, §11.4 Safe Torque Off (STO), p.647.

## Schneider Electric safe-motion restart inhibit

**SOURCE-CONFIRMED:** Schneider Electric's current EcoStruxure Machine Expert Safety documentation states that after an STO request is removed, a restart inhibit is automatically active. The inhibit is removed only by a rising edge at the safety-related function block's `Reset` input. The corresponding SS1 documentation states the same restart-inhibit behavior after SS1 is removed.

**SOURCE-CONFIRMED:** Schneider's drive Inverter Enable/STO documentation separately requires an appropriate external safety-related circuit to prevent unintended restart after a stop. It also distinguishes STO from stopping behavior: STO removes torque-producing power but an axis may coast and external forces may require additional measures.

Sources:
- Schneider Electric, *STO - Safe Torque Off Function*, EcoStruxure Machine Expert Safety, V2.2.
- Schneider Electric, *SS1 - Safe Stop 1 Function*, EcoStruxure Machine Expert Safety, V2.2.
- Schneider Electric, *Inverter Enable Function*, Lexium 62 hardware documentation.

## Rockwell start-inhibit evidence

**SOURCE-CONFIRMED:** Rockwell Automation Studio 5000 documentation exposes separate drive start-inhibit conditions for `Safe Torque Off` and `Safety Reset Required`. This is useful architecture evidence that safety removal and permission to start are represented as distinct conditions rather than one collapsed `safe` bit.

Source: Rockwell Automation, *Specific Start Inhibits*, Studio 5000 Logix Designer v37 online help.

## Cross-manufacturer architecture result

The sources support this bounded state model:

`SAFETY DEMAND` → `TORQUE AUTHORITY REMOVED` → `DEMAND CLEARED` → `RESTART/START INHIBIT STILL ACTIVE` → `SAFETY RESET / DRIVE ENABLE SEQUENCE` → `ORDINARY START EDGE/COMMAND` → `MOTION POSSIBLE`

Exact names and ordering are product/application dependent. Do not turn this into a universal drive state machine.

### What the evidence proves

- **SOURCE-CONFIRMED:** STO demand removal need not equal restart permission.
- **SOURCE-CONFIRMED:** Manufacturer implementations can require a post-STO reset, drive-enable sequence, and/or a new command edge before motion can resume.
- **SOURCE-CONFIRMED:** STO itself is not hazardous-energy isolation and does not prove absence of coast, gravity, stored fluid energy, or other external force.
- **INFERENCE:** A controller architecture that relies only on the drive to reject a stale ordinary command is unnecessarily fragile across drive families/configurations. The ordinary controller should also invalidate hazardous command freshness across the safety boundary and require deliberate rearm/new command generation.

### What remains UNKNOWN for OpenPressBrake

- exact servo/VFD drive family and configured restart semantics;
- whether maintained run/velocity/step/current commands survive STO or safety-demand transitions;
- whether LinuxCNC/HAL state is cancelled, held, regenerated or replayed;
- FPGA/field-I/O retained state across asymmetric power/reset events;
- drive-enable sequencing and any local drive restart-inhibit configuration;
- hydraulic/proportional command state when safety authority returns;
- physical motion, stopping distance/time, pressure behavior and load behavior;
- any required PL/SIL/category/DC or quantitative acceptance threshold.

## OpenPressBrake validation implications

Treat the following as questions to prove on the actual selected hardware/configuration, not assumed requirements copied from Siemens, Schneider or Rockwell:

| Test question | Required observation | Evidence state now |
|---|---|---|
| STO asserted while ordinary run command is active | torque/motion authority response plus ordinary command state | UNKNOWN |
| STO request removed while old run command remains logically asserted | whether drive stays inhibited or resumes | UNKNOWN |
| Safety reset performed without a new ordinary start | whether motion remains absent | UNKNOWN |
| New ordinary start edge issued after reset | defined restart behavior | UNKNOWN |
| LinuxCNC remains powered while drive/safety layer resets | stale command/rearm behavior | UNKNOWN |
| Drive remains powered while LinuxCNC/FPGA resets | startup defaults and old-command rejection | UNKNOWN |
| Communications/watchdog recovers with pre-fault command nonzero | freshness generation and rearm behavior | UNKNOWN |
| Hydraulic command was nonzero at protective demand | post-reset command invalidation before hydraulic authority returns | UNKNOWN |

## Practical architecture rule

**INFERENCE / candidate OpenPressBrake contract:** use two independent barriers against stale-command restart:

1. the safety/drive layer retains its manufacturer-required restart inhibit/reset/enable behavior; and
2. ordinary LinuxCNC/FPGA control invalidates hazardous command freshness on safety demand or loss of authority, then requires a deliberate post-boundary rearm/new command.

Do not make LinuxCNC or the FPGA the personnel-safety authority. Their stale-command invalidation is defense-in-depth and state-integrity control; the independent safety function remains authoritative for personnel protection.

## Boundary with servicing

A successful restart interlock test is not evidence of hazardous-energy isolation. STO/reset/start sequencing does not prove electrical disconnect, hydraulic pressure removal, blocked fluid flow, gravity-load restraint, pneumatic dump, mechanical blocking, or absence of stored energy. Servicing remains governed by the applicable energy-control/isolation procedure.

## Next independent work

Build an asymmetric power-restoration validation matrix spanning safety controller, LinuxCNC host, FPGA/field I/O and drive layers. For each one-layer/two-layer reset combination, ask what state survives, what evidence becomes stale, what authority is unavailable, and what deliberate action is required before hazardous output can return. Keep every actual OpenPressBrake retained-state result `UNKNOWN` until documentation or installed-machine testing proves it.