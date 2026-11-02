#!/usr/bin/env python3
"""Bounded offline G64 P/Q preflight for simple literal CAM output.

Not a G-code interpreter, simulator, safety validator, or contour-error proof.
Reject ambiguous/dynamic G64 blocks rather than guessing modal semantics.
"""
import argparse
import re
from pathlib import Path

G64 = re.compile(r"G\s*64(?:\.0+)?(?![0-9.])", re.IGNORECASE)
GWORD = re.compile(r"G\s*\d+(?:\.\d+)?", re.IGNORECASE)
PQ = re.compile(r"([PQ])\s*([+-]?(?:\d+(?:\.\d*)?|\.\d+))", re.IGNORECASE)


def strip_comments(line):
    out, depth = [], 0
    for ch in line:
        if ch == ";" and depth == 0:
            break
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
            if depth < 0:
                raise ValueError("unmatched closing parenthesis")
        elif depth == 0:
            out.append(ch)
    if depth:
        raise ValueError("unclosed parenthetical comment")
    return "".join(out)


def inspect(line):
    """Return (status, detail) for a G64 block, or None for other lines."""
    code = strip_comments(line).upper()
    match = G64.search(code)
    if not match:
        return None
    if "#" in code or "[" in code or "]" in code:
        return "UNKNOWN", "dynamic expression on G64 line"
    if len(GWORD.findall(code)) != 1:
        return "UNKNOWN", "multiple G words on G64 line"
    suffix = code[match.end():]
    words = PQ.findall(suffix)
    if len(words) != len(set(key for key, _ in words)):
        return "UNKNOWN", "duplicate P or Q word"
    if PQ.sub("", suffix).strip():
        return "UNKNOWN", "extra/unsupported word or nonliteral numeric suffix"
    values = {key: float(val) for key, val in words}
    if any(value < 0 for value in values.values()):
        return "UNKNOWN", "negative tolerance"
    # A literal P/Q token that did not parse is unsupported.
    for key in "PQ":
        if re.search(r"(?<![A-Z])" + key, suffix) and key not in values:
            return "UNKNOWN", "non-literal or unsupported " + key
    if "P" not in values:
        return "UNKNOWN", "P omitted: version/INI default must be resolved"
    p = values["P"]
    q = values.get("Q", p)  # pinned stable/dev behavior for explicit P
    if q > p:
        return "REVIEW", f"Q={q:g} > P={p:g}; geometry may be simplified before TP"
    if q == 0:
        return "Q_DISABLED", f"P={p:g}, Q=0; naive-CAM prefilter disabled"
    return "TWO_STAGE", f"P={p:g}, Q={q:g}; both preprocessing and TP tolerances apply"


def selftest():
    cases = {
        "G64P0.01Q0.5": "REVIEW",
        "G64 P0.01 Q0": "Q_DISABLED",
        "G64 P0.01": "TWO_STAGE",
        "G64 P[#1]": "UNKNOWN",
        "G64": "UNKNOWN",
        "G64 P0.01 (Q0.5)": "TWO_STAGE",
        "G64 P0.01; Q0.5": "TWO_STAGE",
        "G64 P0.01 Q0.01": "TWO_STAGE",
        "G64 P1e-3": "UNKNOWN",
        "G64 P0.01 Q0.5 R0.5": "UNKNOWN",
    }
    for code, expected in cases.items():
        got = inspect(code)
        assert got is not None and got[0] == expected, (code, got, expected)
    print(f"PASS: {len(cases)} offline scanner cases; LinuxCNC NOT RUN")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("files", nargs="*", type=Path)
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()
    if args.selftest:
        selftest()
    if not args.files:
        if not args.selftest:
            ap.error("supply G-code files or --selftest")
        return 0
    review = False
    for path in args.files:
        for n, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            try:
                result = inspect(line)
            except ValueError as exc:
                result = ("UNKNOWN", str(exc))
            if result:
                status, detail = result
                print(f"{path}:{n}: {status}: {detail}")
                review |= status in {"REVIEW", "UNKNOWN"}
    print("OFFLINE ONLY: does not certify path geometry or machine behavior")
    return 2 if review else 0


if __name__ == "__main__":
    raise SystemExit(main())
