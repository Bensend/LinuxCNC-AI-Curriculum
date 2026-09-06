# IO05 call flow — 7I77-style analog command through Smart Serial

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

Representative host-side flow for a descriptor-driven Smart Serial analog output such as 7I77 `analogoutN`. This stops at LLIO. It does not claim FPGA Smart Serial timing, remote DAC implementation, exact physical voltage, amplifier response, or safety behavior.

## Registration / discovery

1. `hm2_sserial_parse_md()` discovers HostMot2 Smart Serial instances and enabled channels.
2. `hm2_sserial_setup_remotes()` identifies each remote and reads its process descriptors.
3. `hm2_sserial_read_configs()` obtains descriptor order, data direction, data type, bit length and engineering limits.
4. `hm2_sserial_create_pins()` exports HAL objects from those descriptors. Writable signed/unsigned numeric fields become HAL real inputs with `scalemax`, `minlim`, and `maxlim`; writable boolean fields become HAL bit inputs.
5. `hm2_sserial_register_tram()` registers the channel process-data write words as `chan->write[]`, CS/status state, and related read/write regions in HostMot2 TRAM.

The 7I77 name and physical function are remote metadata/device semantics. The generic runtime packing loop operates on descriptors.

## Cyclic runtime

### 1. HAL command exists

A motion/PID/spindle/custom HAL source drives the relevant remote HAL command, e.g. `...7i77....analogout0`. A machine-control signal may also drive `analogena`.

Changing the HAL pin alone does not transmit anything.

### 2. HostMot2 cyclic write preparation

The scheduled HostMot2 board write function reaches `hm2_sserial_prepare_tram_write(hm2, period)` before the combined TRAM write.

For a port in normal-running state 3 with `run=true`, it calls `hm2_sserial_write_pins()`.

If the port is starting, stopping, updating parameters, or latched in serious-error state, the normal command-packing branch does not run.

### 3. Prior-transfer/error gate

`hm2_sserial_write_pins()` first checks Smart Serial status.

- excessive accumulated faults -> queue stop and enter state 10;
- previous Do-It still uncleared -> increment fault accumulator, mark command ignored, return;
- previous transfer error -> increment accumulator;
- healthy cycles decrement the accumulator;
- a per-remote transfer-error bit skips fresh pin packing for that remote.

So stale/unchanged physical output can coexist with a correct current HAL value when communication state blocks fresh publication.

### 4. Clear outbound process words

For each eligible remote, every registered process-data write word is zeroed before the descriptor walk.

### 5. Pack descriptors in order

The code walks `chan->confs[]` in remote descriptor order. A running `bitcount` determines the bit offset used by `setbits()`.

For a signed analog command field:

`HAL real -> clamp(minlim,maxlim) -> divide by scalemax -> signed full-scale conversion -> reduce to DataLength bits -> setbits(chan->write[], bitcount, DataLength)`

For an unsigned numeric command the same sequence uses the field-width unsigned maximum.

For a writable boolean field such as an enable-like remote descriptor:

`HAL bool -> optional output invert -> DataLength all-0/all-1 field -> setbits(...)`

Therefore analog command and analog-enable-like fields are not inherently separate host transactions. Their exact offsets/order are defined by the remote descriptor set.

### 6. Queue Smart Serial Do-It

After packing, `hm2_sserial_write_pins()` sets `*inst->command_reg_write = 0x1000 | inst->tag`.

This command register and `chan->write[]` are TRAM-backed host images.

### 7. HostMot2 TRAM -> LLIO

Generic HostMot2 later performs its combined TRAM write. The LLIO provider publishes the Smart Serial process words and command register toward the FPGA.

At this point the software evidence ends for IO05:

`HAL -> sserial host packing -> HostMot2 TRAM -> LLIO`

Downstream is:

`FPGA Smart Serial engine -> remote protocol/firmware -> DAC/output electronics -> drive input`.

Those stages need their own source/firmware/manual/hardware evidence.

## Debugging trace

When `analogoutN` changes but expected machine response does not:

1. verify the correct Smart Serial remote/channel/mode was discovered;
2. verify port `run` and serious-fault state;
3. inspect Smart Serial fault count and communication errors;
4. verify finite nonzero `scalemax` and intended min/max limits;
5. verify `analogena` or other enable semantics separately from numeric command;
6. verify generic HostMot2/transport `io_error` separately from Smart Serial faults;
7. only then cross into remote-board manual, wiring, measured voltage, amplifier enable/fault, and physical-machine diagnostics.

A visible HAL command is evidence of the requested host value, not evidence that a fresh packet was accepted or that a voltage/torque was produced.

## Failure-state distinctions

- Smart Serial accumulated transfer fault: remote-port-specific host state.
- HostMot2 LLIO `io_error`: board transport/generic HostMot2 communication state.
- HostMot2 watchdog bite: separate FPGA/host watchdog mechanism.
- Smart Serial remote watchdog: remote-specific mechanism.
- amplifier fault / STO / contactor state: external machine hardware.

Do not treat these as interchangeable.
