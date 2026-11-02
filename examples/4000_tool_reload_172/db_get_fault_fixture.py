#!/usr/bin/env python3
"""Disposable LinuxCNC DB_PROGRAM protocol fault fixture, review-only / NOT RUN.

For an independently isolated, physically disconnected simulator ONLY.
Do not connect to a real toolchanger or use a production tool database.

INI example (copy to an isolated simulator directory):
  [EMCIO]
  DB_PROGRAM = /usr/bin/python3 ./db_get_fault_fixture.py --scenario comment
  RANDOM_TOOLCHANGER = 0

Scenarios:
  valid:      two tools + upstream-compatible annotated FINI, separate flushes
  comment:    first tool comment contains FINISHED_SETUP, separate flushes
  coalesced:  two tool rows + FINI in one os.write
  split:      first tool row split across two writes, then second + FINI
  g-nak:      NAK instead of tool rows after g (no complete table)
This deliberately does not persist offset updates. It is NOT a test result.
"""
import argparse
import os
import sys
import time


def emit(line: str) -> None:
    sys.stdout.write(line + "\n")
    sys.stdout.flush()


def get_all(scenario: str) -> None:
    first = "T1 P1 Z0.500 ; FINISHED_SETUP" if scenario == "comment" else "T1 P1 Z0.500 ; OK"
    second = "T2 P2 Z1.500 ; OK"
    sentinel = "FINI (get_cmd)"  # bundled upstream lib/python/tooldb.py
    if scenario == "g-nak":
        emit("NAK intentional_get_failure")
    elif scenario == "coalesced":
        os.write(sys.stdout.fileno(), (first + "\n" + second + "\n" + sentinel + "\n").encode())
    elif scenario == "split":
        raw = (first + "\n").encode()
        os.write(sys.stdout.fileno(), raw[:8])
        time.sleep(0.1)
        os.write(sys.stdout.fileno(), raw[8:])
        emit(second)
        emit(sentinel)
    else:
        emit(first)
        emit(second)
        emit(sentinel)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--scenario", choices=("valid", "comment", "coalesced", "split", "g-nak"), default="valid")
    args = parser.parse_args()

    emit("v2.1")
    for line in sys.stdin:
        command = line.strip()
        if not command:
            emit("NAK empty_command")
            continue
        op = command.split(None, 1)[0].lower()
        if op == "g":
            get_all(args.scenario)
        elif op in ("p", "l", "u"):
            # Not a persistence oracle. For offset-persistence tests, extend
            # upstream tests/tooldb/db-g10-offset instead.
            emit("FINI (update recvd)")
        else:
            emit("NAK unknown_command")


if __name__ == "__main__":
    main()
