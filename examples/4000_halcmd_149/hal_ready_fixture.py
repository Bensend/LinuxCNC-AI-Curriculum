#!/usr/bin/env python3
"""Software-only LinuxCNC HAL userspace readiness fixture. NOT RUN in curriculum.
Never attach this component to machine outputs or safety functions.
Run only in a qualified disconnected halrun environment with an external timeout.
"""
import argparse
import signal
import sys
import time

import hal


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--name", default="fixture")
    parser.add_argument("--ready-delay", type=float, default=0.05)
    parser.add_argument("--exit-before-ready", action="store_true")
    parser.add_argument("--exit-after-ready", type=float, default=None)
    args = parser.parse_args()
    if args.ready_delay < 0 or (
        args.exit_after_ready is not None and args.exit_after_ready < 0
    ):
        parser.error("delays must be nonnegative")

    component = hal.component(args.name)
    component.newpin("heartbeat", hal.HAL_BIT, hal.HAL_OUT)
    component["heartbeat"] = False
    if args.exit_before_ready:
        component.exit()
        return 7

    time.sleep(args.ready_delay)
    component.ready()
    if args.exit_after_ready is not None:
        time.sleep(args.exit_after_ready)
        component.exit()
        return 0

    running = True

    def stop(_signum, _frame):
        nonlocal running
        running = False

    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    bit = False
    try:
        while running:
            bit = not bit
            component["heartbeat"] = bit
            time.sleep(0.1)
    finally:
        component.exit()
    return 0


if __name__ == "__main__":
    sys.exit(main())
