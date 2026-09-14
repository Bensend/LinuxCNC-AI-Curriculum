# 3300-L1 — native LinuxCNC laser source foundation

Date: 2026-09-14
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: SOURCE-CONFIRMED native vector/raster primitives + DOC-CONFIRMED synchronized-output semantics + COMMUNITY/CONFIG evidence from a real CO2 implementation

## Scope and process boundary

LinuxCNC contains native realtime primitives that are genuinely useful for laser work, but they do not amount to a QtPlasmaC-like integrated production laser controller. This pass traces the native components and simulator first, then compares them with an older real CO2 configuration. It deliberately does not project plasma concepts such as Arc OK, THC or IHS onto laser.

The first useful split is:

- **vector cutting/marking:** geometric feed moves plus a requested power trajectory;
- **raster engraving:** a spatial pixel stream mapped to one motion coordinate;
- **laser enable / source readiness / assist gas / focus / chiller / door or safety system:** machine/process integration layers not supplied by `laserpower.comp` itself.

Fiber/metal cutting, CO2 vector cutting and raster engraving must remain distinct later sub-branches because their process-readiness and focus/gas/source interfaces differ materially.

## `laserpower.comp`

Pinned source: `src/hal/components/laserpower.comp`.

Inputs:

- `min_power`, `max_power`
- requested and current motion velocity
- `enabled`
- raster/vector mode selector
- raster requested power
- vector requested power
- current move `distance_to_go`

Outputs include final `power`, pre-normalized `command_power`, interpolation start values, and velocity scale.

### Velocity scaling

Each realtime invocation computes:

`vel_scale = abs(current_velocity) / abs(requested_velocity)`

with scale forced to zero when either velocity is effectively zero. Final output, when enabled and command power is nonnegative, is:

`((max_power - min_power) * vel_scale * command_power/100) + min_power`

The component's explicit purpose is to reduce delivered power as actual motion slows relative to requested motion, avoiding excess energy density around tight corners/deceleration.

Important boundary: `min_power` is still added whenever the component is enabled with nonnegative command power. Therefore this source should not be described simplistically as `power = requested_percent * velocity_ratio`; min/max normalization is part of the contract.

### Vector mode

When raster mode is false, `vector_power` represents the desired power at the next control point. If the requested vector power changes or a new move is detected by increasing `distance_to_go`, the component freezes `start_power` and `start_distance`, then linearly interpolates command power as `distance_to_go` falls through that move.

This supports a move such as:

```gcode
M68 E2 Q0
G1 X5 M67 E2 Q25
```

where the simulator intends power to ramp from the prior level toward 25% across the following synchronized move instead of stepping immediately.

### Raster mode

When `raster_mode` is true, `command_power` comes directly from `raster_power`; velocity scaling and min/max normalization are still applied downstream.

### Enable semantics in the shipped simulator

`configs/sim/axis/laser/laser.hal` does not wire `enabled` to a generic spindle bit. It derives an enable from `motion.motion-type`: a bit-slice recognizes feed/arc motion types and enables `laser.control` only for those motion classes. That is simulator architecture, not a universal production requirement.

The simulator also wires:

- `motion.analog-out-00` -> min power limiter -> `laser.control.min-power`
- `motion.analog-out-01` -> max power limiter -> `laser.control.max-power`
- `motion.analog-out-02` -> vector power limiter -> `laser.control.vector-power`
- `motion.distance-to-go`, current velocity and requested velocity -> `laserpower`
- raster output -> `laser.control.raster-power`
- raster enabled -> raster mode

The simulated command chain is therefore:

`G-code synchronized/immediate analog command -> motion.analog-out-N -> HAL limit -> laserpower command interpolation + velocity normalization -> laser.control.power`

A physical PWM/analog laser-source interface is intentionally absent from this sim path.

## M62/M63/M67/M68 timing contract

Official LinuxCNC documentation establishes:

- M62/M63 digital and M67 analog changes are **queued/synchronized** and occur at the beginning of the next motion command;
- if no subsequent motion command occurs, the queued change does not happen;
- M64/M65 digital and M68 analog changes are immediate and break blending.

For laser architecture this creates a crucial distinction between **feature-boundary power/enable intent** and **immediate administrative cleanup/setup**.

It also creates a genuine future lab candidate: a queued M67 or M62 at the end of a program with no following motion should not be assumed to have reached the HAL output merely because the interpreter accepted the line.

No lab is launched yet because source/config work is still producing independent evidence.

## Native raster component

Pinned source: `src/hal/components/raster.comp`.

The component consumes one preprogrammed raster line from a HAL port. Program header fields are:

`program_offset ; bits_per_pixel ; pixels_per_unit ; number_of_pixels ; pixel_data`

`position` is slaved to the motion coordinate used for the raster sweep. At run start it stores the current `program_position`. Each realtime invocation computes:

`bitmap_position = (position - (program_position + program_offset)) * pixels_per_unit * direction`

where the sign of `program_offset` selects sweep direction.

It advances through pixel data as motion position crosses pixel indices. When the current position lies between two valid powered pixel values, it linearly interpolates between previous and current pixel values. An all-ones pixel value is reserved as an **off** sentinel and maps to `-1.0` rather than maximum power.

### Raster fault surfaces

The source explicitly faults for:

1. invalid program offset;
2. invalid bits-per-pixel (must be 4-32 and divisible by 4);
3. nonpositive pixels-per-unit;
4. invalid count (<2);
5. pixel-data size mismatch;
6. bad pixel data while running.

`reset` returns the state machine to IDLE, clears the fault and clears the program port.

This is a real realtime state machine with bounded input validation; it is not merely a GUI image helper.

## Shipped raster simulator call flow

`configs/sim/axis/laser/laser.ini` remaps M10-M13 to Python functions:

- M11 -> `rasterBegin`
- M12 -> `rasterData`
- M13 -> `rasterStart`
- M10 -> `rasterStop`

The Python remap deliberately yields `INTERP_EXECUTE_FINISH` before begin/start/stop so prior queued motion completes before mutating the raster programming/run state.

The example `raster_test.ngc` programs the raster header with M11, appends pixel hex data using one or more M12 lines, calls M13, performs a feed sweep, then M10 stops the raster. A second line uses a negative program offset and reverse X sweep, demonstrating bidirectional raster direction handling.

The simulator therefore separates:

`userspace/interpreter raster programming -> HAL port buffer -> realtime raster state machine -> spatial power request -> laserpower velocity scaling -> output command`

That separation is architecturally important for later diagnostics: successful Python programming does not itself prove that realtime position-to-pixel execution is valid.

## Real CO2 implementation comparator — `bjj/2x_laser`

A public LinuxCNC 2.5 configuration for a Buildlog.net 2.x CO2 laser exposes a materially different architecture from the current native sim:

- M3/M5 is treated as a master laser enable, with the explicit commissioning goal that abort/spindle-off prevents firing;
- firing can be controlled by synchronized digital I/O or by a synthetic negative Z convention for compatibility with router CAM;
- analog power is set through M68 E0;
- pulse-per-distance behavior is implemented by a custom realtime `laserfreq.comp`;
- raster engraving uses custom M scripts/Python plus realtime streaming rather than the later native `raster.comp` path;
- coolant/assist air is tied to laser master enable with a post-M5 hold time;
- raster overscan is intentionally large enough for the carriage to complete deceleration/reversal/acceleration outside the image, preventing darker edges caused by variable speed.

This configuration is historical and version-specific, but it provides field evidence for two lessons that transfer directly:

1. laser power authority and machine/process enable authority should not be collapsed into one scalar;
2. raster quality depends on motion dynamics at reversals, so spatial power scheduling must account for acceleration rather than only pixel values.

A 2018 LinuxCNC forum engraving report independently described dark/deep burning adjacent to raster direction reversals and recommended overscan so the laser re-enters the image at full speed. This is consistent with why the newer native `laserpower.comp` explicitly scales power by actual/requested velocity.

## Initial architecture contract — deliberately bounded

Native LinuxCNC source supports the following reusable chain:

### Vector

`CAM/G-code power intent -> queued M67 / immediate M68 analog output -> motion.analog-out -> HAL normalization -> laserpower spatial interpolation -> actual/requested velocity scaling -> physical laser power interface`

### Raster

`image/raster preparation -> userspace/interpreter line programming -> HAL port -> realtime raster(position) -> spatial raster power -> laserpower velocity scaling -> physical laser power interface`

Do **not** yet extend this to a complete production laser architecture. Public source inspected so far does not establish a universal contract for:

- laser-source READY/FAULT handshake;
- CO2 tube chiller/flow permissive;
- fiber laser source state and emission handshake;
- assist-gas valve/pressure qualification;
- capacitive height control/focus servo;
- pierce timing for metal cutting;
- door/guard or functional-safety architecture;
- controlled abort with queued power changes;
- CAM/material recipe provenance for a modern production laser.

Those require real contemporary implementations and process-specific evidence.

## Adversarial boundary review — 9/9

1. Is `laserpower.comp` a complete laser controller? **No; it is a realtime power-scaling primitive.**
2. Does M67 change analog output immediately? **No; it is applied at the beginning of the next motion command.**
3. Is a queued M67 guaranteed to happen if the program ends with no later motion? **No.**
4. Is raster pixel all-ones maximum laser power? **No; all ones is the off sentinel.**
5. Does raster userspace programming directly generate hardware PWM? **No; it fills a HAL-port program consumed by a realtime component.**
6. Does the shipped sim prove production CO2/fiber readiness handling? **No.**
7. Does velocity scaling remove the need for raster overscan/dynamic planning? **Not proven.** It reduces energy-density error but does not establish all reversal/process-quality constraints.
8. Can the old `2x_laser` synthetic-Z convention be declared the modern native architecture? **No; it is a historical machine-specific compatibility strategy.**
9. Does LinuxCNC software enable logic constitute functional safety? **No.**

## Next evidence path

Continue L1 with at least two more real implementations, prioritizing one contemporary LightBurn/M67 vector machine and one fiber/metal-cutting or capacitive-height implementation. Trace the hardware command path from `laserpower.power` or `motion.analog-out` to PWM/analog hardware. Then decide whether the queued-output/no-following-motion and raster pixel-boundary questions justify a bounded lab.
