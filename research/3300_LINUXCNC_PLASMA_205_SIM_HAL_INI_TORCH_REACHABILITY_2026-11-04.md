# PLASMA-205 — pinned QtPlasmaC simulation HAL/INI and ignition reachability (3300, NON-GRADUATED)

## Scope and provenance
Follow-on to PLASMA-204, focused on **actual configuration** rather than only a component's documented pins. Read START_HERE, governance, blind feedback log and compute ledger. Source revision: LinuxCNC/linuxcnc development `cdf957bd` (not a claim about stable 2.9.10). This is source/config inspection only; **no LinuxCNC execution or machine validation**.

Pinned files and Git blobs:
- [qtplasmac_p_metric.ini](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd/configs/sim/qtplasmac/qtplasmac_p_metric.ini), blob `548fc0200029f7941f6afcc06410839e3a522927`, includes `qtplasmac_metric_ini.inc`.
- [qtplasmac_metric_ini.inc](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd/configs/sim/qtplasmac/qtplasmac_metric_ini.inc), blob `12e6c3fb39e37f40ffe0afa2d24d063b8e24b804`, HALFILE sequence and machine model.
- [sim_no_stepgen.tcl](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd/configs/sim/qtplasmac/sim_no_stepgen.tcl), blob `44cceff7ab2c7da24fcfdf4551e3a6fea2e65a0d`, realtime order and simulated joint feedback.
- [qtplasmac_comp.hal](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd/lib/hallib/qtplasmac_comp.hal), blob `35356761267aa42519ecc08e142edd2169985843`, authoritative common HAL nets.
- [sim_postgui.hal](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd/configs/sim/qtplasmac/sim_postgui.hal), blob `f9196162591dc6c49b30b23c671e7c0300b43dad`, simulated torch and UI wiring.
- [plasmac.comp](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd/src/hal/components/plasmac.comp), key switch cases `IDLE`, `PROBE_HEIGHT`, `PROBE_DOWN`, `PROBE_UP`, `ZERO_HEIGHT`, `PIERCE_HEIGHT`, `TORCH_ON`, `ARC_OK`; see especially lines ~985–1065 and ~1190–1560.

## What the *actual* simulator connects
**CONFIG-CONFIRMED:** `qtplasmac_p_metric.ini` includes the shared INI. That shared file selects `sim_no_stepgen.tcl` (the stepgen alternative is commented), then `qtplasmac_comp.hal`, `custom.hal`, and post-GUI `sim_postgui.hal`. Its `[TRAJ]` uses three spindles and `[KINS]` uses four joints `xyyz`; `SERVO_PERIOD=1000000` ns.

**CONFIG-CONFIRMED:** `sim_no_stepgen.tcl` loads `plasmac` and runs `motion-command-handler` → `motion-controller` → `plasmac` → simulated joint PID/mux/velocity and simulated home switches in the servo thread. PID has FF0=1 with P/I/D=0; mux feedback is a simulation loopback, not independently sensed axis position. The example therefore cannot validate encoder feedback, hardware response time or physical torch isolation.

**CONFIG-CONFIRMED:** `qtplasmac_comp.hal` explicitly connects `spindle.0.on => plasmac.cutting-start`; spindle 1 and 2 serve scribe and spotting. It also connects `halui.program.is-running`, `halui.machine.is-on`, `motion.is-all-homed`, sensor debounce outputs and `motion.digital-out-03 => plasmac.torch-off`. The component's `plasmac.torch-on` creates net `plasmac:torch-on` without a hardware output in that file.

**CONFIG-CONFIRMED:** `sim_postgui.hal` connects `plasmac:torch-on => qtplasmac_sim.torch_on sim-torch.start`. This proves the endpoint **in this simulator** is the simulated torch and QtVCP display, not a Mesa pin, relay or physical torch. `sim-torch.voltage-out => plasmac.arc-voltage-in` and GUI `arc_ok => db_arc-ok.in` provide synthetic arc feedback. Do not confuse the adjacent `configs/sim/axis/plasma` directory (PlasmaC2/AXIS) with this QtPlasmaC configuration.

## Source-grounded state-entry path
- `plasmac.comp` tool selection maps `cutting_start` to `CUTTING` when not dry-running (PLASMA-204). In `IDLE`, normal cutting entry additionally requires `(tool == CUTTING || tool == SPOTTING || probe_test)`, acceptable `stop_type`, and `homed`. The `tube_cut` branch can select `TORCH_ON` directly when `torch_enable`; ordinary cutting instead selects `PIERCE_HEIGHT` on a skip-IHS path or proceeds through probing.
- Normal path: `IDLE → PROBE_HEIGHT → PROBE_DOWN → PROBE_UP → ZERO_HEIGHT → PIERCE_HEIGHT → TORCH_ON → ARC_OK`. The path is conditional: probing contact, travel limits, offsets, configured pierce/cut height and voltage, and target-position attainment matter. `ZERO_HEIGHT` is explicitly a waypoint. `PIERCE_HEIGHT` sets `TORCH_ON` only for CUTTING/SPOTTING with `torch_enable` and satisfied offset conditions; when torch is disabled it instead selects `PIERCE_DELAY`.
- `TORCH_ON` checks start attempts/restart timing and then `torch_enable` before setting `torch_on` TRUE. `ARC_OK` observes arc feedback *after* that attempt. Separate `TORCHPULSE` entry from `IDLE` requires pulse request, torch enable, and inactive breakaway/float/ohmic inputs; it is not the ordinary M3 path.
- **SOURCE/CONFIG-CONFIRMED narrowly:** no explicit `M190`, `M66`, `#5399`, or material-transaction ID appears in the inspected `IDLE`/pierce/`TORCH_ON` guards or the traced simulator torch net. **UNKNOWN:** whether UI/Task error handling prevents reaching M3 after a particular material failure, and actual behavior on a physical installation. Do not claim failed material ACK causes ignition.

## Reproducible disconnected review exercise (not executed)
Start from `qtplasmac_p_metric.ini`; follow `#INCLUDE`, `[HAL] HALFILE`, `POSTGUI_HALFILE`, then net producer/consumer. Independently draw (A) M190/M66 material acknowledgment; (B) G-code M3 → spindle.0.on → cutting-start; (C) state machine → torch-on; (D) simulator endpoint. Classify each arrow CONFIG, SOURCE, TEST or UNKNOWN. Inspect `sim_no_stepgen.tcl` before assuming feedback is physical.

Predicted, **unexecuted** discriminating cases:
1. M3 with `homed=FALSE`: normal IDLE cutting entry not taken; check alternative branches and state.
2. M3, homed, probe never contacts: no ordinary PROBE_UP→PIERCE_HEIGHT→TORCH_ON transition; probing limit may pause.
3. Valid probe and pierce target, torch_enable TRUE: ordinary path may enter TORCH_ON and set simulator `sim-torch.start`; no physical-output conclusion.
4. Invalid cut height/pierce height/cut volts: PIERCE_HEIGHT pauses rather than normal ignition.
5. Manual torch pulse with torch_enable TRUE and sensors clear: separate TORCHPULSE path can drive the same simulator torch net.
6. M66 timeout before M3: no material acknowledgment dependency in traced realtime branches; Task/UI progression still requires a dedicated end-to-end test.

## Evidence ledger, implications and limits
| Finding | Class | Limit |
|---|---|---|
| Selected QtPlasmaC metric simulation loads named common HAL and postgui files | CONFIG-CONFIRMED | Selected variant only |
| M3 maps via spindle.0.on to plasmac.cutting-start | CONFIG-CONFIRMED | Not proof of any physical output |
| torch-on ends at sim-torch.start and qtplasmac_sim.torch_on | CONFIG-CONFIRMED | Simulator only |
| Homing, probing and pierce conditions precede normal TORCH_ON | SOURCE-CONFIRMED | Pinned development revision |
| Material ACK is not a direct input to inspected realtime ignition guards | SOURCE-CONFIRMED narrow | End-to-end failure behavior UNKNOWN |
| Proposed scenario outcomes | INFERENCE / NOT TESTED | Need disconnected LinuxCNC execution |

**Learning improvement:** The prior source-only pin declaration was insufficient to infer an output path. The pinned HAL net closes the simulation path and identifies its exact endpoint; never promote that to physical verification.

**Next:** inspect a real QtPlasmaC material-change failure scenario in a disconnected simulation, only after confirming permitted isolated self-hosted runner and checking historical lab evidence; otherwise rotate to an inspectable open-source CAM postprocessor or deeper interpreter path. No hosted Actions. Preserve existing graduations, blind evaluation separation, independent personnel-safety authority and physical machine HOLD.
