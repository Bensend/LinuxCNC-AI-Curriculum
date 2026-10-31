# 4000-LC-SSERIAL-56 — real Mesa 8I20 configuration, channel freshness, and 7I77 integration

**Status:** SOURCE/DOC-CONFIRMED static; machine behavior conditional INFERENCE; NOT TESTED; NON-GRADUATED. First audited 2026-10-31.

## Real source/configuration provenance
- LinuxCNC **v2.9.10** `configs/by_machine/smithy/1240combined.hal`, blob `e636353f82d783073a42927943bb4249402ace1b`, [source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/1240combined.hal).
- Companion `configs/by_machine/smithy/8i20postgui.hal`, blob `598994b5e8f803c836b07b70a7c371bcd0b81ae0`, [source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/8i20postgui.hal).
- Driver `src/hal/drivers/mesa-hostmot2/hostmot2.c`, blob `75619ae3f6925087a6693c5421bbf629f4459d94`, [read/write callbacks](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.c#L94-L150); `sserial.c` blob `2d23131f41f25e0836db53fe2e77d09975a8c744`, [input/output callbacks](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/sserial.c#L1707-L2087).
- Official [2.9 HostMot2](https://linuxcnc.org/docs/2.9/html/man/man9/hostmot2.9.html) and [Smart Serial](https://linuxcnc.org/docs/2.9/html/man/man9/sserial.9.html) docs; development [dual-PID 7I92/7I77 example](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/motion/dual-pid-example.adoc) (blob `36fa1770a3704c8c71fbaa3aabeebbfd9418b31d`).

## Architecture and timing
Smithy loads `hm2_pci` with `sserial_port_0=0xxxxxxx`: channel 0 in mode 0, channels 1–7 disabled. Its 8I20 remote supplies a Smart Serial `current` command, while spindle revolution/index feedback comes from the **separate HostMot2 encoder**. The 7I77 documentation likewise distinguishes Smart Serial analog outputs and conventional HostMot2 encoders; they are not one shared serial feedback path.

The actual Smithy servo function order is:
```
hm2.read → motion-command-handler → motion-controller
→ limit2 → pid → lowpass/near/abs/comp/and2 → debounce → or2
→ hm2.write → bldc → charge-pump
```
In `hostmot2.c`, `hm2_read` completes TRAM then publishes Smart Serial remote pins; `hm2_write` packs Smart Serial outputs before the TRAM write. **SOURCE-CONFIRMED:** `bldc.0.out` is wired to `hm2_5i20.0.8i20.0.0.current`, but `bldc.0` runs **after** `hm2.write`. Thus a new BLDC output calculated in servo iteration N is not packed into the 8I20 command until a later write (normally N+1), unlike PID and motion outputs computed before the write. This is a HAL-order latency dependency, not a measured instability or evidence of incorrect motor operation. The stock example's charge-pump also executes after the write.

The post-GUI file exposes `8i20.*.comms`, `*.fault`, `*.status`, temperature, voltage, `sserial.port-0.fault-count`, and `port_state` as PyVCP indicators. The shown HAL does **not** demonstrate that these displays independently inhibit motion. The Smart Serial `run` pin is driven by the debounced machine-on signal, which also drives the remote amplifier enable.

## Separate freshness/error mechanisms
- `hm2_read` returns before publishing *any* refreshed HAL values if board-level `io_error` is set or `hm2_finish_read` yields `-EAGAIN`. This is the earlier hm2_eth/low-level communication boundary.
- If a board read completes, `hm2_sserial_process_tram_read` visits every remote in state 3 and calls `hm2_sserial_read_pins` **without checking the per-channel transfer-error bits**. The reader converts TRAM data into HAL input pins. A failed remote transfer therefore has **no explicit per-channel freshness gate at this call site**. Whether its registers retain prior values, change, or represent invalid data requires a hardware/fixture oracle.
- On write, `hm2_sserial_write_pins` *does* skip repacking a remote's output data if that channel's transfer-error bit is set, yet still issues a port DoIt command. Do not assume that stale/unchanged command registers prove a fresh successful remote output.
- `fault-count` increments by 10 for a busy DoIt or failed transfer and (when not busy) decays by 1 in the same iteration; default limit 200 is checked with strict `>` **before** that iteration's update. From zero, 23 consecutive completed-but-failed transfers yield 207; a 24th call reaches the stop check, assuming no intervening reset/overflow. This is a **source arithmetic prediction**, not measured timing. Remote status-bit faults are not the same predicate as the counter.
- Port state 10 requires `run` LOW before returning to idle; the later HIGH transition can restart. Restart resets the fault counter, not evidence that a remote's physical fault cleared.

## Documentation and community reconciliation
The 2.9 sserial manpage describes `.run_state` and `.error-count` generically, while inspected source creates `.sserial.port-N.port_state` and `.sserial.port-N.fault-count`; the real Smithy PyVCP uses the latter. Its prose also says the threshold is reached, whereas code checks strict `>`. **Practical rule:** use `halcmd show pin` on the installed version rather than copy a prose pin name.

A [2023 LinuxCNC forum report](https://forum.linuxcnc.org/27-driver-boards/48323-bookworm-on-armbian-7i76e-errors) described a one-time DoIt warning with `fault-count=0`; this is a COMMUNITY-REPORTED diagnostic lead consistent with a counter that later decays, **not** a verified instance of the specific bugs in SSERIAL-54/55. A separate [2016 developer reply](https://www.forum.linuxcnc.org/9-installing-linuxcnc/30323-rtapi-error-unexpected-realtime-delay-on-task-1) recommended 1 kHz rather than an excessively fast servo thread for a velocity-mode servo setup; this is contextual guidance, not a universal rate guarantee.

## Evidence and next experiment
SOURCE-CONFIRMED: exact HAL order, data paths, per-channel read/write asymmetry, counter math. DOC-CONFIRMED: HostMot2/7I77/8I20 architecture. COMMUNITY-REPORTED: cited forum symptoms. INFERENCE: downstream stale-data and one-cycle actuator effect. UNKNOWN: physical outputs, installed firmware, real timing, safety. TEST-CONFIRMED: none.

A disconnected acceptance matrix is in [the Smart Serial implementation guide](../guides/4000-linuxcnc-mesa-smart-serial-fault-freshness-acceptance-2026-10-31.md). No real drive, FPGA, build, simulation, Actions job or independent evaluation was used.
