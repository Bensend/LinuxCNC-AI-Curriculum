#!/usr/bin/env python3
"""
Read-only LinuxCNC Python/NML status sampler for a future ROS 2 adapter.
SOURCE-DERIVED, NOT EXECUTED OR VALIDATED. No motion, HAL writes or ROS imports.
Run only in a disconnected LinuxCNC environment with the linuxcnc Python module.

Development exposes stat.heartbeat and stat.taskbeat; v2.9.10 does not.
"progress" means the sampled producers advanced; it is NOT proof of fresh
drive feedback, correct motion, or any personnel-safety condition.
"""
import argparse
import json
import sys
import time

try:
    import linuxcnc
except ImportError as exc:
    raise SystemExit("linuxcnc Python module unavailable: run inside a LinuxCNC environment") from exc


def snapshot(status):
    """Copy a small subset immediately after a poll; no writes or commands."""
    status.poll()  # Returns None even when the stored NML snapshot was not updated.
    out = {
        "echo_serial_number": getattr(status, "echo_serial_number", None),
        "task_state": getattr(status, "task_state", None),
        "interp_state": getattr(status, "interp_state", None),
        "joint_position": list(getattr(status, "joint_position", ())),
        "machine_position": list(getattr(status, "position", ())),
    }
    for name in ("heartbeat", "taskbeat"):
        out[name] = getattr(status, name, None)
    return out


def observe_producers(sample, state, now, stall_seconds):
    """Track *producer advancement*, not freshness of every machine input."""
    motion, task = sample["heartbeat"], sample["taskbeat"]
    if motion is None or task is None:
        return "UNKNOWN_NO_PRODUCER_COUNTERS"
    if state["last"] is None:
        state["last"] = (motion, task)
        state["motion_advanced_at"] = now
        state["task_advanced_at"] = now
        return "BASELINE_ONLY"
    prev_motion, prev_task = state["last"]
    if motion != prev_motion:
        state["motion_advanced_at"] = now
    if task != prev_task:
        state["task_advanced_at"] = now
    state["last"] = (motion, task)
    motion_age = now - state["motion_advanced_at"]
    task_age = now - state["task_advanced_at"]
    sample["motion_advance_age_s"] = round(motion_age, 3)
    sample["task_advance_age_s"] = round(task_age, 3)
    if motion_age > stall_seconds and task_age > stall_seconds:
        return "BOTH_PRODUCERS_STALLED"
    if motion_age > stall_seconds:
        return "MOTION_PRODUCER_STALLED"
    if task_age > stall_seconds:
        return "TASK_PRODUCER_STALLED"
    return "BOTH_PRODUCERS_PROGRESSING"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--period", type=float, default=0.2, help="seconds between polls")
    ap.add_argument("--stall-seconds", type=float, default=1.0)
    ap.add_argument("--count", type=int, default=20, help="0 means run until interrupted")
    args = ap.parse_args()
    if args.period <= 0 or args.stall_seconds <= 0 or args.count < 0:
        ap.error("period and stall-seconds must be positive; count >= 0")
    status = linuxcnc.stat()
    state = {"last": None, "motion_advanced_at": None, "task_advanced_at": None}
    n = 0
    while args.count == 0 or n < args.count:
        now = time.monotonic()
        try:
            row = snapshot(status)
            row["producer_progress"] = observe_producers(row, state, now, args.stall_seconds)
            row["adapter_receipt_monotonic_s"] = round(now, 6)
            row["status_poll_error"] = None
        except Exception as exc:
            # Do not republish the previous good snapshot as newly received.
            row = {
                "adapter_receipt_monotonic_s": round(now, 6),
                "producer_progress": "POLL_ERROR",
                "status_poll_error": repr(exc),
            }
        print(json.dumps(row, sort_keys=True), flush=True)
        n += 1
        time.sleep(args.period)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(130)
