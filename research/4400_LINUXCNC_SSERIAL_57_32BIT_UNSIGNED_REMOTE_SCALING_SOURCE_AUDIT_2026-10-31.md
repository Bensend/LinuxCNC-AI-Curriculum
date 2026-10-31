# 4000-LC-SSERIAL-57 — 32-bit unsigned Smart Serial process-field scaling

**Status:** SOURCE-CONFIRMED conditional C arithmetic issue; NOT TEST-CONFIRMED; NON-GRADUATED. First audited 2026-10-31. Relevant to custom Mesa/HostMot2 Smart Serial remote firmware, not evidence that a specific stock card is affected.

## Source versions and field contract
- LinuxCNC stable **v2.9.10**, `src/hal/drivers/mesa-hostmot2/sserial.c`, blob `2d23131f41f25e0836db53fe2e77d09975a8c744`, [`hm2_sserial_read_pins` lines 1908–1946](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/sserial.c#L1908-L1946).
- LinuxCNC development **537cf2d765c96b6e75ae1db44e1dc0b9dba906a1**, blob `bf70a0cc307dfbae72de8b3fe8d790184923cf9c`, [`hm2_sserial_read_pins` lines 1826–1863](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/sserial.c#L1826-L1863).
- Stable `src/hal/drivers/mesa-hostmot2/sserial.h`, blob `3e6176b77526d3ba54e2a84d49cadb0267579609`, [data descriptor and built-in remote tables](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/sserial.h#L76-L94).

## Exact implementation
`hm2_sserial_create_pins` accepts an `LBP_UNSIGNED` descriptor as a HAL float process pin and counts `DataLength` bits toward the remote's TRAM registers; it does not reject a 32-bit unsigned process descriptor. `getbits` assembles the process data into an unsigned 64-bit value. But the `LBP_UNSIGNED` read conversion uses:

```c
*pin->float_pin = (buff * pin->fullscale) / ((1 << conf->DataLength) - 1);
```

In both pinned revisions, the left operand `1` is a signed C `int`. On the conventional 32-bit-int LinuxCNC target, shifting by **32** is undefined behavior; even a 31-bit shift into the sign bit is undefined for signed int. The corresponding **output** packing path instead constructs its bit mask using a 64-bit unsigned expression. The input/output width handling is therefore asymmetric.

**SOURCE-CONFIRMED:** a custom Smart Serial remote advertising an unsigned process input of length 32 reaches a scaling expression with undefined C semantics. **UNKNOWN:** which, if any, stock remote firmware publishes a 32-bit `LBP_UNSIGNED` *process* input. The built-in 8I20/7I64 process tables inspected here use 16-bit unsigned analog/temperature/voltage values; an 8I20 32-bit `unitnumber` entry is in the separate globals/parameter table and does **not** by itself establish exposure to this process-read path.

## Proposed bounded implementation correction (review only)
Validate that the process field width is in the supported 1..64 range, then calculate a nonzero unsigned 64-bit denominator using a width-64 special case, e.g. `width == 64 ? UINT64_MAX : ((1ULL << width) - 1ULL)`. Cast the numerator and denominator to double for scaling. This is an implementation proposal, not a tested patch; check RTAPI types, the 64-bit field read path, and whether 64-bit process fields are permitted before merging.

## Frozen test discriminator (NOT RUN)
- U1: Fake remote advertises `LBP_UNSIGNED`, `DataLength=16`, `fullscale=10`, raw `0x8000`; expect approximately `5.0000763` in the existing implementation (control).
- U2: Same remote, `DataLength=32`, `fullscale=10`, raw `0x80000000`; expect a corrected implementation to produce approximately `5.000000001`, with no shift sanitizer diagnostic.
- U3: Compile original expression under a qualified UBSan-enabled disconnected unit harness for U2; predicted undefined-shift diagnostic, but **not observed**.
- U4: Reject width 0 or unsupported >64 rather than constructing a zero denominator or invalid shift.

No physical card, compiler, simulator or Actions runner was used. Test results remain UNKNOWN. A source-only condition does not prove a machine malfunction.

## Evidence ledger and priority
| Claim | Class | Proof / limitation |
|---|---|---|
| 32-bit unsigned process field reaches signed shift by 32 | SOURCE-CONFIRMED | Both pinned source revisions |
| Actual numerical result on a given compiler | UNKNOWN | Undefined behavior, must not predict a single value |
| Built-in 8I20 analog fields affected | NOT ESTABLISHED | Inspected built-in process entries are 16-bit |
| Corrected 64-bit denominator behavior | INFERENCE | Requires compiled tests |
| Hardware and safety impact | UNKNOWN | Independent physical evidence required |

**Next:** a bounded source fixture U1–U4 on an approved isolated `[self-hosted, openpressbrake]` runner, if qualified; otherwise rotate to another unworked LinuxCNC implementation question. No graduation or independent safety claim.
