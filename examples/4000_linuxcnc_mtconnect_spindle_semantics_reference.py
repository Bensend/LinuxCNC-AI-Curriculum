#!/usr/bin/env python3
"""Unexecuted, hardware-free reference for LinuxCNC MTConnect spindle telemetry.

Pinned source:
  LinuxCNC 537cf2d765c96b6e75ae1db44e1dc0b9dba906a1
  lib/python/mtc/lcnc_source.py sample_values() lines 146-157
  lib/python/mtc/observations.py lines 123-130
  docs/src/config/python-interface.adoc lines 526-554

This is a REFERENCE MODEL, NOT LinuxCNC/ROS 2/MTConnect runtime evidence.
Run only on independently qualified isolated [self-hosted, openpressbrake]
if execution is justified. No hardware, NML, sockets, ROS or LinuxCNC imports.
"""
from __future__ import annotations

import unittest
from typing import Any, Mapping, Optional


def source_spindle_fields(spindle_zero: Mapping[str, Any]) -> dict[str, float]:
    """Replicate the inspected development LcncSource calculation, not RPM sensing."""
    speed = float(spindle_zero.get("speed", 0.0))
    override = (float(spindle_zero.get("override", 1.0))
                if spindle_zero.get("override_enabled", True) else 1.0)
    return {
        "spdl_speed_cmd": round(speed, 3),
        # Upstream declares this ACTUAL; no independent tachometer is read.
        "spdl_speed": round(speed * override, 3),
    }


def conservative_bridge_snapshot(
    *,
    poll_ok: bool,
    spindle_zero: Mapping[str, Any],
    heartbeat: Optional[int],
    previous_heartbeat: Optional[int],
    last_heartbeat_change_s: Optional[float],
    monotonic_now_s: float,
    stale_after_s: float,
) -> dict[str, Any]:
    """Illustrative read-only bridge contract, never a machine authorization."""
    if stale_after_s <= 0:
        raise ValueError("stale_after_s must be positive")
    if not poll_ok:
        return {
            "validity": "DISCONNECTED",
            "spindle_status_speed_rpm": None,
            "spindle_measured_speed_rpm": None,
            "last_heartbeat_change_s": last_heartbeat_change_s,
        }

    if heartbeat is not None and heartbeat != previous_heartbeat:
        last_heartbeat_change_s = monotonic_now_s
    fresh = (last_heartbeat_change_s is not None
             and monotonic_now_s >= last_heartbeat_change_s
             and monotonic_now_s - last_heartbeat_change_s <= stale_after_s)
    return {
        "validity": "HEARTBEAT_ADVANCING_RECENTLY" if fresh else "STALE",
        "spindle_status_speed_rpm": float(spindle_zero.get("speed", 0.0)),
        "spindle_measured_speed_rpm": None,  # requires independent sensor
        "last_heartbeat_change_s": last_heartbeat_change_s,
    }


class ReferenceContractCases(unittest.TestCase):
    """Frozen expected results; NOT RUN in the source-inspection session."""

    def test_override_is_not_tachometer(self):
        vals = source_spindle_fields(
            {"speed": 1000, "override": 0.8, "override_enabled": True}
        )
        self.assertEqual(vals, {"spdl_speed_cmd": 1000.0, "spdl_speed": 800.0})

    def test_override_disabled(self):
        vals = source_spindle_fields(
            {"speed": 1000, "override": 0.8, "override_enabled": False}
        )
        self.assertEqual(vals["spdl_speed"], 1000.0)

    def test_heartbeat_freeze(self):
        snap = conservative_bridge_snapshot(
            poll_ok=True, spindle_zero={"speed": 1200}, heartbeat=42,
            previous_heartbeat=42, last_heartbeat_change_s=1.0,
            monotonic_now_s=4.0, stale_after_s=2.0
        )
        self.assertEqual(snap["validity"], "STALE")
        self.assertIsNone(snap["spindle_measured_speed_rpm"])

    def test_heartbeat_change(self):
        snap = conservative_bridge_snapshot(
            poll_ok=True, spindle_zero={"speed": 1200}, heartbeat=43,
            previous_heartbeat=42, last_heartbeat_change_s=1.0,
            monotonic_now_s=4.0, stale_after_s=2.0
        )
        self.assertEqual(snap["validity"], "HEARTBEAT_ADVANCING_RECENTLY")
        self.assertEqual(snap["last_heartbeat_change_s"], 4.0)

    def test_disconnected_does_not_publish_status_speed(self):
        snap = conservative_bridge_snapshot(
            poll_ok=False, spindle_zero={"speed": 1200}, heartbeat=None,
            previous_heartbeat=42, last_heartbeat_change_s=1.0,
            monotonic_now_s=4.0, stale_after_s=2.0
        )
        self.assertEqual(snap["validity"], "DISCONNECTED")
        self.assertIsNone(snap["spindle_status_speed_rpm"])


if __name__ == "__main__":
    unittest.main()
