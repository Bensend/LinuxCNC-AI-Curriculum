#!/usr/bin/env python3
"""LINC-159: offline preflight for literal LinuxCNC lincurve HAL setp tables.

Only reads a HAL text file; never connects to HAL, LinuxCNC or a machine.
Requires a complete table in the selected file and does not expand includes,
INI substitutions, Tcl expressions, variables or dynamic runtime writes.
"""
import argparse
from bisect import bisect_right
from math import isfinite
from pathlib import Path
import re
import sys


def load_table(path: Path, instance: str, personality: int):
    if not 2 <= personality <= 16:
        raise ValueError("personality must be in [2,16]")
    found = {"x": {}, "y": {}}
    prefix = instance + "."
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        fields = line.split("#", 1)[0].split()
        if not fields or fields[0] != "setp" or len(fields) < 2:
            continue
        name = fields[1]
        if not name.startswith(prefix):
            continue
        suffix = name[len(prefix):]
        if not (suffix.startswith("x-val-") or suffix.startswith("y-val-")):
            continue
        match = re.fullmatch(r"([xy])-val-([0-9]{2})", suffix)
        if match is None or len(fields) != 3:
            raise ValueError(f"{path}:{line_number}: malformed lincurve setp: {line}")
        axis, index_text = match.groups()
        index = int(index_text)
        if index >= personality:
            raise ValueError(f"{path}:{line_number}: {name} exceeds personality {personality}")
        if index in found[axis]:
            raise ValueError(f"{path}:{line_number}: duplicate assignment for {name}")
        try:
            value = float(fields[2])
        except ValueError as exc:
            raise ValueError(f"{path}:{line_number}: {name} is not a number") from exc
        if not isfinite(value):
            raise ValueError(f"{path}:{line_number}: {name} must be finite")
        found[axis][index] = value

    for axis in ("x", "y"):
        missing = [f"{axis}-val-{i:02d}" for i in range(personality) if i not in found[axis]]
        if missing:
            raise ValueError(f"{path}: missing {instance} parameters: {', '.join(missing)}")
    xs = [found["x"][i] for i in range(personality)]
    ys = [found["y"][i] for i in range(personality)]
    for i in range(personality - 1):
        if not xs[i] < xs[i + 1]:
            raise ValueError(
                f"{path}: X not strictly increasing at {i:02d}/{i+1:02d}: "
                f"{xs[i]:g} >= {xs[i+1]:g}; sort paired (X,Y) values"
            )
    return xs, ys


def interpolate(xs, ys, x):
    if not isfinite(x):
        raise ValueError("sample X must be finite")
    if x <= xs[0]:
        return ys[0]
    if x >= xs[-1]:
        return ys[-1]
    i = bisect_right(xs, x) - 1
    f = (x - xs[i]) / (xs[i + 1] - xs[i])
    return ys[i] + f * (ys[i + 1] - ys[i])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("hal_file", type=Path)
    parser.add_argument("--instance", default="lincurve.0")
    parser.add_argument("--personality", type=int, required=True)
    parser.add_argument("--sample", type=float, action="append", default=[])
    args = parser.parse_args()
    try:
        xs, ys = load_table(args.hal_file, args.instance, args.personality)
        print(f"PASS: {args.instance}, {len(xs)} finite, strictly increasing X/Y pairs")
        for i, (x, y) in enumerate(zip(xs, ys)):
            print(f"  {i:02d}: X={x:.9g} Y={y:.9g}")
        for x in args.sample:
            print(f"  sample X={x:.9g} -> Y={interpolate(xs, ys, x):.9g}")
    except (ValueError, OSError) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
