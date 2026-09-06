# IO05 — Smart Serial analog-output source guide

Course level: 1000  
Status: SOURCE  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

This guide traces the host-side production path used by descriptor-driven Smart Serial numeric outputs, with a 7I77 servo analog command as the representative interface. It intentionally stops at the HostMot2 Smart Serial register/TRAM boundary. Remote firmware DAC behavior, physical +/-10 V accuracy/polarity, enable-terminal electrical behavior, amplifier behavior, and functional safety are separate evidence domains.

## Public interface

Current LinuxCNC `sserial(9)` documentation states that 7I77 analog outputs are Smart Serial devices while its encoder channels are conventional HostMot2 encoders. It exposes `analogoutN`, `analogena`, `analogoutN-scalemax`, `analogoutN-minlim`, and `analogoutN-maxlim`.

The docs describe `scalemax` as the requested engineering-unit value corresponding to full scale and min/max as command limits. That public model agrees with the pinned host scaling implementation described below.

## Discovery and HAL creation

Pinned `sserial.c::hm2_sserial_setup_remotes()` discovers a remote, reads its process-data descriptors, creates HAL pins/parameters, and registers the remote's process-data registers with HostMot2 TRAM.

`hm2_sserial_read_configs()` obtains `hm2_sserial_data_t` process descriptors from the remote. Process-field ordering, `DataType`, `DataDir`, `DataLength`, `ParmMin`, `ParmMax`, and field names therefore come from descriptor metadata rather than a hard-coded `7i77 analog` switch in the generic host packing loop.

`hm2_sserial_create_pins()` maps descriptor directions:

- `LBP_IN` -> HAL output and contributes read bits;
- `LBP_IO` -> HAL IO and contributes both read/write bits;
- `LBP_OUT` -> HAL input and contributes write bits.

For `LBP_UNSIGNED` and `LBP_SIGNED` process fields, it exports a HAL real pin and a `*-scalemax` parameter initialized from `ParmMax`. For command-capable fields it also exports `*-maxlim` and `*-minlim`, initialized from descriptor `ParmMax` and `ParmMin`.

This is why 7I77 analog-output scaling is a generic Smart Serial numeric-field behavior even though the actual physical output semantics belong to the remote device.

## TRAM registration

`hm2_sserial_register_tram()` registers:

- remote CS/status read and write register;
- each process-data read register required by `num_read_regs`;
- each process-data write register required by `num_write_regs`.

The resulting `chan->write[i]` pointers point into HostMot2's allocated TRAM write image. No physical remote transfer occurs merely because a HAL pin was created or because `chan->write[]` memory changed.

## Runtime write path

### `hm2_sserial_prepare_tram_write()`

Generic HostMot2 calls this during cyclic write preparation. For each Smart Serial instance, it runs a port state machine. In normal state 3, provided the run pin remains asserted, it calls `hm2_sserial_write_pins()`.

Other states start/stop ports, update remote parameters, or hold a serious-fault state. Therefore a valid HAL analog command does not guarantee it will be packed on a cycle if the Smart Serial port is not in normal-running state.

### `hm2_sserial_write_pins()` communication gates

Before packing process outputs, the function checks remote/local communication status.

Important branches:

1. If accumulated `fault-count` exceeds `fault-lim`, the port is moved to serious-error state 10 and a stop command is queued.
2. If the previous Do-It command has not cleared, the fault count is increased, bit 31 is written as an ignored command, and the function returns without packing a fresh transfer.
3. If the preceding data-register status indicates a failed transfer, the fault count is increased.
4. Otherwise the fault count decays by `fault-dec`, bounded at zero.
5. For a particular remote, if its prior transfer-error bit is set, that channel's pins are skipped for this cycle.

This means a visible HAL analog command can remain correct while no fresh Smart Serial command is accepted or prepared.

## Numeric output scaling and packing

For each remote, `hm2_sserial_write_pins()` first zeroes the registered `chan->write[]` process-data words, then walks process descriptors in descriptor order. Command-capable fields contribute their `DataLength` bits sequentially through `setbits()`.

### Unsigned field

For `LBP_UNSIGNED`:

1. read the HAL real pin;
2. clamp it to `maxlim` and `minlim`;
3. normalize by `fullscale` / `scalemax`;
4. multiply by the maximum unsigned integer representable by the field's `DataLength`;
5. cast to `rtapi_u64`;
6. insert exactly `DataLength` bits at the current packed bit offset.

### Signed field

For `LBP_SIGNED` (the code comments that this implementation only works for `DataLength <= 32`):

1. read the HAL real pin;
2. clamp it to `maxlim` and `minlim`;
3. normalize by `fullscale` / `scalemax`;
4. scale against signed 32-bit positive full scale `2147483647`;
5. right-shift to the field width;
6. mask to exactly `DataLength` bits;
7. insert the field at the current packed bit offset.

Thus a negative signed command is represented as the low `DataLength` bits of the shifted signed value; the generic host does not create a separate direction signal for this Smart Serial numeric path.

### Boolean fields, including an enable-like descriptor

`LBP_BOOLEAN` command fields are packed in the same descriptor walk. For output-direction fields, the generic host can apply the field's invert parameter before filling all bits in that descriptor field with zero or one.

Therefore a 7I77 `analogena` field is not published through a separate special-purpose host-side analog-enable transaction: when the remote descriptor presents it as a writable boolean process field, it shares the remote's descriptor-ordered packed write image. Exact field offset relative to `analogoutN` is remote-descriptor data, not a universal LinuxCNC constant.

## Do-It command

After packing all eligible remotes, `hm2_sserial_write_pins()` writes:

`0x1000 | inst->tag`

to `*inst->command_reg_write` in the TRAM image. The tag identifies active remote channels. HostMot2 later transfers the registered TRAM write regions through the board's LLIO provider.

The host-side architecture is therefore:

`HAL analogout/analogena -> descriptor-driven clamp/scale/pack -> chan->write[] + command_reg_write -> HostMot2 TRAM -> LLIO -> FPGA Smart Serial engine -> remote firmware/electronics -> physical interface`.

Only the path through LLIO is SOURCE-CONFIRMED here.

## Error/recovery implications

The Smart Serial port owns a fault accumulator rather than treating one failed transfer as immediate permanent failure. The previous command must clear before a fresh process transfer is packed. Persistent errors can stop the port and require the run pin to cycle before state 10 returns to idle.

This is distinct from generic HostMot2 LLIO `io_error` and distinct again from a remote device's own watchdog/electrical fault behavior. A fresh AI should not collapse these into one generic `watchdog fault`.

## Pathological scaling boundary

The pinned `LBP_SIGNED` / `LBP_UNSIGNED` output code divides by `fullscale` without an explicit local zero/NaN/Inf guard. The 1000-level guidance is therefore to treat `scalemax` as a required finite, nonzero engineering parameter and not rely on behavior for pathological values. Exact pathological floating-point/cast behavior is promoted to 2000/HIGH because it is both version/compiler sensitive and unnecessary for normal current-level operation.

## Community/field findings

Community troubleshooting reinforces two debugging rules without becoming implementation evidence:

- seeing FPGA-resident encoders/stepgens does not prove a Smart Serial daughtercard is present or healthy;
- valid HAL `analogout` values do not by themselves prove physical output voltage, because wrong Smart Serial mode/port selection, communication faults, enable state, wiring, or board power can intervene.

These are COMMUNITY-REPORTED leads consistent with the source boundaries above.

## Evidence ledger

| Claim | Class | Evidence boundary |
|---|---|---|
| 7I77 analog outputs are Smart Serial, encoders conventional HostMot2 | DOC-CONFIRMED | current `sserial(9)` |
| signed/unsigned HAL objects and scale/limits come from remote descriptors | SOURCE-CONFIRMED | pinned `sserial.c` |
| numeric command is clamp -> normalize -> integer encode -> descriptor-order packing | SOURCE-CONFIRMED | `hm2_sserial_write_pins()` |
| boolean command fields share descriptor-ordered packet | SOURCE-CONFIRMED generic path | exact 7I77 field offset remains descriptor data |
| persistent Smart Serial transfer errors can stop port state machine | SOURCE-CONFIRMED | `hm2_sserial_write_pins()` / `hm2_sserial_prepare_tram_write()` |
| requested full-scale maps to physical +/-10 V on representative 7I77 | DOC-CONFIRMED for applicable board/public docs only | not cloud TEST-CONFIRMED |
| physical disabled/fault voltage and drive torque state | UNKNOWN here | hardware/commissioning/safety evidence required |

## Higher-level promotion queue

| Item | Destination | Priority | Blocks 1000 graduation? |
|---|---|---:|---|
| zero/NaN/Inf `scalemax` and cast behavior | 2000 | HIGH | No; normal guidance requires finite nonzero scale |
| exact 7I77 descriptor field ordering/bit widths across firmware versions | 2000 / hardware fixture | MEDIUM | No; generic packing architecture is established |
| mutable fake Smart Serial remote exercising production pack/fault state | 2000 | HIGH | No if current fixture audit shows no existing production-path oracle |
| physical voltage transfer, polarity, offset, disabled state and accuracy | commissioning | CRITICAL | No; explicitly outside software-only guidance |
| remote watchdog versus HostMot2 watchdog interaction | S02/S03/2000 | HIGH | No for IO05 command-path objective |
| functional-safety interpretation of analog enable/drive enable | safety analysis | CRITICAL | No; current guide explicitly forbids assuming safety rating |
