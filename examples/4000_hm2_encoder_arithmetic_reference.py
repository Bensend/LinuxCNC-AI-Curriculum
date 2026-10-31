#!/usr/bin/env python3
"""Source-derived HostMot2 encoder arithmetic reference; NO hardware access.

Research-only model for LinuxCNC v2.9.10 encoder.c and pinned development
537cf2d765c96b6e75ae1db44e1dc0b9dba906a1, paired with archived
HostMot2 qcounterate.vhd / qcounteratesk.vhd / timestamp.vhd.

NOT RUN or verified in the curriculum at publication. Run only as a
reviewed pure-software fixture on qualified isolated self-hosted compute.
Does not load LinuxCNC, open HAL, or contact a Mesa board.
"""

MASK32 = 0xFFFFFFFF
MASK16 = 0xFFFF
CLOCK = 33_000_000  # illustrative, NOT a real-board measurement


def driver_filter_rate(clock: int, requested: int) -> tuple[int, int]:
    """Model unsigned-u32 divider and the driver's mutated HAL input."""
    if not (0 <= clock <= MASK32 and 0 <= requested <= MASK32):
        raise ValueError("u32 inputs required")
    if requested == 0:
        raise ZeroDivisionError("source: clock / requested")
    quotient = clock // requested
    reg = 0xFFF if quotient == 1 else (quotient - 2) & MASK32
    denominator = (reg + 2) & MASK32
    if denominator == 0:
        raise ZeroDivisionError("source: clock / (filter_rate + 2) wraps to zero")
    published_pin = clock // denominator
    return reg, published_pin


def archived_fpga_rate(clock: int, register: int) -> int:
    """Archived qcounterate VHDL / regmap: 12-bit divider, MSb bypass.

    Integer frequency only; actual FPGA waveform/board firmware unverified.
    """
    divider = register & 0xFFF
    return clock if (divider & 0x800) else clock // (divider + 2)


def observed_timestamp_ticks(previous: int, elapsed_ticks: int) -> tuple[int, int, int]:
    """One driver observation after elapsed ticks, without intermediate reads.

    Mirrors the source's one-wrap-if-current-less-than-previous inference.
    Does not model event timestamps, motion state, or a real servo scheduler.
    """
    current = (previous + elapsed_ticks) & MASK16
    wraps = int(current < previous)
    inferred = (current - previous) + (wraps << 16)
    return current, wraps, inferred


def main() -> None:
    cases = [
        ("F1", 1_000_000, (31, 1_000_000, 1_000_000)),
        ("F2", 16_500_000, (0, 16_500_000, 16_500_000)),
        ("F3", 25_000_000, (0xFFF, 8_054, CLOCK)),
        ("F4", 8_054, (0xFFF, 8_054, CLOCK)),
    ]
    for name, request, expected in cases:
        register, readback = driver_filter_rate(CLOCK, request)
        actual_by_archived_rtl = archived_fpga_rate(CLOCK, register)
        result = register, readback, actual_by_archived_rtl
        assert result == expected, (name, result, expected)
        print(name, "register", hex(register), "HAL", readback, "RTL", actual_by_archived_rtl)

    for name, request in (("F5", 0), ("F6", CLOCK + 1)):
        try:
            driver_filter_rate(CLOCK, request)
        except ZeroDivisionError as error:
            print(name, "expected invalid-input division:", error)
        else:
            raise AssertionError(name + " failed to detect division-by-zero path")

    for name, tick_rate, elapsed_ticks, expected in (
        ("T1", 10_000_000, 10_000, 10_000),
        ("T2", 10_000_000, 100_000, 34_464),
        ("T3", 2_000_000, 80_000, 14_464),
    ):
        current, wraps, inferred = observed_timestamp_ticks(0, elapsed_ticks)
        assert wraps == 0 and inferred == expected, (name, current, wraps, inferred)
        print(name, "ticks", elapsed_ticks, "observed", current,
              "inferred", inferred, "inferred_s", inferred / tick_rate)

    print("Reference arithmetic checks completed (NOT a LinuxCNC/FPGA test).")


if __name__ == "__main__":
    main()
