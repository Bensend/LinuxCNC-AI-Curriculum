#!/usr/bin/env python3
"""Strict offline LinuxCNC COMP_FILE preflight (reference; no HAL, no machine I/O).

This intentionally rejects headers, blanks and trailing tokens, although the
native sscanf loader accepts trailing tokens and silently stops on malformed
lines. The interpolation is a target-trim reference, not the realtime filter.
All embedded tests were NOT RUN when this file was committed.
"""
import argparse
from dataclasses import dataclass
import math
from pathlib import Path
import unittest


@dataclass(frozen=True)
class Point:
    nominal: float
    forward_trim: float
    reverse_trim: float


def parse_table(text: str, file_type: int) -> list[Point]:
    if file_type not in (0, 1):
        raise ValueError("COMP_FILE_TYPE must be 0 or 1")
    points: list[Point] = []
    for line_number, line in enumerate(text.splitlines(), 1):
        fields = line.split()
        if len(fields) != 3:
            raise ValueError(f"line {line_number}: exactly 3 numbers required; no blanks/comments")
        try:
            nominal, forward, reverse = (float(value) for value in fields)
        except ValueError as exc:
            raise ValueError(f"line {line_number}: nonnumeric field") from exc
        if not all(math.isfinite(value) for value in (nominal, forward, reverse)):
            raise ValueError(f"line {line_number}: nonfinite value")
        if points and nominal <= points[-1].nominal:
            raise ValueError(f"line {line_number}: nominal must increase strictly")
        if len(points) >= 256:
            raise ValueError(f"line {line_number}: more than 256 rows")
        if file_type == 0:
            forward, reverse = nominal - forward, nominal - reverse
        points.append(Point(nominal, forward, reverse))
    if not points:
        raise ValueError("at least one compensation row required")
    return points


def target_trim(points: list[Point], nominal: float, direction: int) -> float:
    if direction not in (-1, 1):
        raise ValueError("direction must be +1 or -1")
    if not math.isfinite(nominal):
        raise ValueError("nonfinite target position")
    field = "forward_trim" if direction == 1 else "reverse_trim"
    if nominal <= points[0].nominal:
        return getattr(points[0], field)
    if nominal >= points[-1].nominal:
        return getattr(points[-1], field)
    for left, right in zip(points, points[1:]):
        if left.nominal <= nominal <= right.nominal:
            fraction = (nominal - left.nominal) / (right.nominal - left.nominal)
            return getattr(left, field) + fraction * (
                getattr(right, field) - getattr(left, field)
            )
    raise AssertionError("unreachable for a validated ascending table")


class PreflightTests(unittest.TestCase):
    def test_type0_target(self):
        rows = parse_table("0 0.002 -0.003\n10 10.004 9.998\n", 0)
        self.assertAlmostEqual(target_trim(rows, 5, 1), -0.003)
        self.assertAlmostEqual(target_trim(rows, 5, -1), 0.0025)

    def test_type1_equivalent(self):
        rows = parse_table("0 -0.002 0.003\n10 -0.004 0.002\n", 1)
        self.assertAlmostEqual(target_trim(rows, 5, 1), -0.003)
        self.assertAlmostEqual(target_trim(rows, 5, -1), 0.0025)

    def test_header_rejected(self):
        with self.assertRaises(ValueError):
            parse_table("# header\n0 0 0\n", 0)

    def test_blank_line_rejected(self):
        with self.assertRaises(ValueError):
            parse_table("0 0 0\n\n1 1 1\n", 0)

    def test_nonmonotonic_rejected(self):
        with self.assertRaises(ValueError):
            parse_table("0 0 0\n0 0 0\n", 0)

    def test_nonfinite_rejected(self):
        with self.assertRaises(ValueError):
            parse_table("0 nan 0\n", 0)

    def test_capacity_rejected(self):
        with self.assertRaises(ValueError):
            parse_table("".join(f"{i} {i} {i}\n" for i in range(257)), 0)

    def test_empty_rejected(self):
        with self.assertRaises(ValueError):
            parse_table("", 0)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("file", nargs="?", type=Path)
    parser.add_argument("--type", type=int, default=0, choices=(0, 1))
    parser.add_argument("--at", type=float, default=None, help="nominal position")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if args.self_test:
        unittest.main(argv=["preflight"], exit=False)
        return
    if args.file is None:
        parser.error("file is required unless --self-test is set")
    points = parse_table(args.file.read_text(encoding="utf-8"), args.type)
    print(f"VALID: {len(points)} rows, {points[0].nominal}..{points[-1].nominal}")
    if args.at is not None:
        print(f"at {args.at}: forward={target_trim(points, args.at, 1):.9g}, "
              f"reverse={target_trim(points, args.at, -1):.9g}")


if __name__ == "__main__":
    main()
