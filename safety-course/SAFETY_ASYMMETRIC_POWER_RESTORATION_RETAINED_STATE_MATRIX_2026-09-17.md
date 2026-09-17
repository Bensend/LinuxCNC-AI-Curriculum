# Safety asymmetric power-restoration / retained-state matrix

Date: 2026-09-17
Course: 4000-series safety/design curriculum
Session start UTC: 2026-09-17T20:35:47Z

## Purpose

Challenge the dangerous assumption that a machine-wide power event is symmetric. Safety controller, LinuxCNC host, FPGA/field I/O, drive control power, drive power stage, and hydraulic/pneumatic final elements can lose and regain power at different times while commands, diagnostics, physical energy, and restart state survive differently.

## Evidence basis

- **DOC-CONFIRMED — Rockwell PowerFlex 750 STO (Publication 750-UM002P-EN-P, Jan 2026):** after a guard closes and the stop command is reset, a valid start command is required before hazardous motion resumes. STO disables torque-producing output devices but is not electrical isolation.
- **DOC-CONFIRMED — Rockwell GuardLogix DCST:** cold-start behavior is an explicit configuration choice. Manual cold start does not energize the safety output merely because valid inputs return; automatic cold start can energize once valid enabling conditions exist. Therefore power-up behavior must be established, not assumed.
- **DOC-CONFIRMED — Rockwell Safe Brake Control:** cold start can deliberately require a successful reset before brake release/subsequent operation. Brake feedback and brake command are distinct evidence.
- **DOC-CONFIRMED — PowerFlex 755T:** separate main/control power domains exist; some asymmetric de-energization/re-energization sequences create functional-safety faults that require control-power cycling.
- **DOC-CONFIRMED — PowerFlex Integrated Safety:** safety fault/reset-required/start-inhibited states are distinct; reset uses an explicit transition.
- **INFERENCE:** OpenPressBrake should invalidate ordinary hazardous-command freshness across loss/restart of safety authority or ordinary controller layers and require deliberate rearm/new command. This is defense in depth, not personnel-safety authority.
- **UNKNOWN:** actual OpenPressBrake retained RAM/nonvolatile command state, FPGA startup output state, drive input semantics, safety-controller cold-start configuration, field-output power sequencing, hydraulic retained pressure, and brake/load state until selected hardware and installed-machine evidence prove them.

## State classes that must not be collapsed

1. **Safety authority** — may hazardous energy be enabled under the independent safety system?
2. **Ordinary command state** — what LinuxCNC/HAL believes it is commanding.
3. **FPGA/I/O output state** — what physical command interface is presently asserting.
4. **Drive/controller restart state** — inhibited, reset-required, enabled, faulted, or accepting a fresh command.
5. **Physical energy state** — bus voltage, hydraulic pressure, accumulator charge, gravity load, brake state, trapped pneumatic energy.
6. **Diagnostic freshness** — whether displayed evidence was produced after the relevant restart boundary.

A reassuring state in one class is not proof of the others.

## Asymmetric restoration challenge matrix

| Event | State that may survive | Evidence that becomes stale/unknown | Required safe-side behavior before hazardous output returns |
|---|---|---|---|
| Safety controller resets; LinuxCNC + FPGA remain powered | maintained ordinary command; FPGA registers; drive command input | prior safety-permissive/status and prior final-element proof | safety authority must reacquire valid inputs and its configured reset/restart conditions; ordinary command must not be treated as fresh solely because it stayed asserted |
| LinuxCNC host resets; safety controller + FPGA remain powered | FPGA output/register state; drive enable state; physical energy | host HMI/status and command ownership | FPGA/ordinary-control watchdog should reach defined nonhazardous ordinary state; after host recovery require explicit rearm/new command before resuming hazardous command |
| FPGA resets; LinuxCNC + safety controller remain powered | host command request; safety permission; drive physical state | FPGA output/status/feedback until reinitialized | outputs start from documented safe ordinary defaults; host must not replay pre-reset hazardous command as if continuously valid |
| Drive control power resets while safety + host + FPGA remain powered | external maintained command and safety demand; motor/load mechanical state | drive ready/STO/reset/fault status | establish selected drive cold-start/restart behavior; require drive-ready and safety state to be freshly proved; do not assume maintained command is either accepted or rejected |
| Drive main power drops but control power remains | controller logic, network connection, commands and diagnostics may survive | actual torque capability/bus state during transition | prove actual product sequencing; restoration of main power must not silently convert an old command into motion authority |
| Drive control power drops but main/DC energy remains | DC bus/stored electrical energy may remain while diagnostics disappear | all drive-reported safety/ready feedback | treat drive state as unknown; restore according to manufacturer sequence and reacquire fresh safety/drive evidence |
| Field 24 V output power drops; FPGA logic remains | FPGA command bits | coil/current/valve/contactor physical state | field restoration must not automatically replay stale hazardous outputs without intended architecture and fresh permissive/rearm |
| Safety I/O supply drops; safety CPU remains | safety program internal state | protective-device channel truth | fail safe; reacquire valid dual-channel/device state and required reset/test before enabling outputs |
| Network path drops; all controllers remain powered | local commands and physical outputs can survive depending on design | remote HMI/HAL diagnostics immediately become stale | stale status must be shown unknown; ordinary communication watchdog policy must be explicit and independent safety authority must remain effective without network diagnostics |
| Complete control-power loss; hydraulic/gravity energy remains | trapped pressure, accumulator charge, suspended load, mechanical position | all electronic diagnostics | electronic reboot is irrelevant to stored-energy proof; physical load/pressure restraint remains a separate verification task |
| Safety controller remains off while ordinary control returns | ordinary software may boot normally | safety authority unavailable | hazardous output cannot be authorized; ordinary control may diagnose but cannot substitute for missing safety authority |
| Ordinary control remains off while safety system returns healthy | safety inputs/outputs may become healthy | process command ownership unavailable | safety reset/permissive must not itself become START; wait for deliberate ordinary-control rearm/start |
| Two layers reboot in different order | retained state can differ at each boundary | cross-layer status snapshots | prove each interface's startup defaults and handshake; require fresh evidence generated after the last relevant boundary, not before the first reboot |

## Adversarial cases

### A. Maintained LinuxCNC command across safety-controller reset

A HAL output remains TRUE while the safety controller reboots. When safety authority returns, replaying the still-TRUE ordinary command without a new edge can create unexpected motion on hardware configured for maintained/two-wire commands.

**Rule:** safety reset/restoration is not ordinary START. Defense-in-depth ordinary control should invalidate hazardous command freshness across this boundary.

### B. FPGA reboot under a healthy safety permissive

If FPGA startup registers restore to a commanded value or the host immediately republishes the last setpoint, the independent safety chain can be completely healthy while ordinary motion resumes unexpectedly.

**Rule:** FPGA startup/output defaults and host rearm semantics require explicit evidence. Safety permissive means the safety system permits operation; it does not mean an old process command is newly intended.

### C. Drive control-power reboot with maintained RUN

Manufacturer implementations differ. Some require reset/start sequencing; some applications permit automatic restart under bounded conditions. The course must not assume universal behavior.

**Rule:** selected drive configuration is a commissioning item. Demonstrate restart from each relevant power-loss state with people outside the hazard during initial validation.

### D. Electronics reboot while hydraulic energy never left

A press can reboot every controller while accumulator pressure or a gravity-loaded ram remains hazardous.

**Rule:** controller startup state and stored-energy state are separate proof domains. Do not label the machine maintenance-safe because electronics restarted in an inhibited state.

## Freshness rule

Any evidence crossing a restart boundary must be classified:

- **fresh:** generated after the last relevant reset/power restoration and tied to the current physical state;
- **stale:** last-known-good value from before the boundary;
- **unknown:** source unavailable, initializing, contradictory, or not yet challenged.

HMI design should prefer `UNKNOWN / INITIALIZING / RESET REQUIRED` over retaining a reassuring green state.

## Commissioning challenge set

For each actual OpenPressBrake layer, record and physically test where justified:

1. startup output state with every other layer already powered;
2. one-layer power loss and restoration;
3. pairwise loss/restoration in both orders for safety controller / ordinary controller / field I/O / drive where credible;
4. maintained command present during restoration;
5. safety demand active during restoration;
6. reset button held during restoration;
7. communications unavailable during restoration;
8. physical stored energy present during electronics restart;
9. feedback unavailable or contradictory at restart;
10. requirement for fresh reset, ordinary rearm and new START/command edge.

Do not execute hazardous validation with personnel exposed. Initial uncertain restart tests belong in isolated/remote commissioning with the danger zone clear.

## OpenPressBrake boundary

Personnel-safety authority remains independent of LinuxCNC and the normal FPGA. LinuxCNC/FPGA restart inhibition, command freshness and watchdog behavior are useful defense in depth and process control, but they do not replace the independent safety function or physical final elements.

Actual OpenPressBrake behavior remains **UNKNOWN** until selected component documentation, configuration and installed-machine tests close each row.

## Frozen lesson

**POWER RESTORED != SAFETY AUTHORITY RESTORED != DIAGNOSTICS FRESH != DRIVE READY != ORDINARY COMMAND FRESH != START AUTHORIZED != PHYSICAL HAZARD CONTROLLED.**
