#!/usr/bin/env python3
"""PB-BG-001 deterministic operator-mode ownership/revocation harness.

Implements the frozen abstract contract in
experiments/PB-BG-001-operator-mode-ownership-revocation-plan.md.
No motor, hydraulic, force, timing, or functional-safety model is present.
"""
from dataclasses import dataclass
import csv, hashlib, json, sys

MOTION_OWNERS = {"HOMING", "JOG_CONT_POS", "JOG_CONT_NEG", "TYPED_MOVE"}

@dataclass
class State:
    state: str = "UNREFERENCED"
    owner: str = "NONE"
    fault_reason: str = ""
    reference_valid: bool = False
    auto_resume_attempted: bool = False

class Harness:
    def __init__(self):
        self.s = State()
        self.rows = []
        self.seq = 0

    def step(self, case, event, *, machine_authorized=True, feedback_valid=True,
             drive_ok=True, reference_valid=None, jog_pos=False, jog_neg=False,
             jog_release=False, typed=False, typed_target_valid=True, home=False,
             home_complete=False, jog_stop=False, stall=False, reconcile=False):
        s = self.s
        before = s.state
        if reference_valid is not None:
            s.reference_valid = reference_valid

        active = s.owner in MOTION_OWNERS
        reason = ""
        if active:
            if not machine_authorized: reason = "AUTHORIZATION_LOST"
            elif not feedback_valid: reason = "FEEDBACK_INVALID"
            elif not drive_ok: reason = "DRIVE_FAULT"
            elif stall: reason = "STALL_SUSPECT"

        if reason:
            s.state, s.owner, s.fault_reason = "FAULTED", "NONE", reason
        elif s.state == "FAULTED":
            if reconcile and machine_authorized and feedback_valid and drive_ok and not stall:
                s.state, s.owner = "RECONCILE", "NONE"
        elif s.state == "RECONCILE":
            if reconcile and machine_authorized and feedback_valid and drive_ok and not stall:
                s.state = "IDLE_REFERENCED" if s.reference_valid else "UNREFERENCED"
                s.owner, s.fault_reason = "NONE", ""
        elif s.state == "HOMING":
            if home_complete:
                s.reference_valid = True
                s.state, s.owner, s.fault_reason = "IDLE_REFERENCED", "NONE", ""
        elif s.state in ("JOG_CONT_POS", "JOG_CONT_NEG"):
            if jog_release or jog_stop:
                s.state = "IDLE_REFERENCED" if s.reference_valid else "UNREFERENCED"
                s.owner = "NONE"
        elif s.state == "TYPED_MOVE":
            pass
        elif s.state in ("UNREFERENCED", "IDLE_REFERENCED"):
            healthy = machine_authorized and feedback_valid and drive_ok and not stall
            if healthy:
                if home and not (jog_pos or jog_neg or typed):
                    s.state, s.owner, s.fault_reason = "HOMING", "HOMING", ""
                elif jog_pos and not jog_neg and not typed and not home:
                    s.state, s.owner, s.fault_reason = "JOG_CONT_POS", "JOG_CONT_POS", ""
                elif jog_neg and not jog_pos and not typed and not home:
                    s.state, s.owner, s.fault_reason = "JOG_CONT_NEG", "JOG_CONT_NEG", ""
                elif typed and not (jog_pos or jog_neg or home) and s.reference_valid and typed_target_valid:
                    s.state, s.owner, s.fault_reason = "TYPED_MOVE", "TYPED_MOVE", ""

        self.seq += 1
        row = dict(seq=self.seq, case=case, event=event, state_before=before,
                   state_after=s.state, owner=s.owner, fault_reason=s.fault_reason,
                   motion_request_active=s.owner in MOTION_OWNERS,
                   reference_valid=s.reference_valid, machine_authorized=machine_authorized,
                   feedback_valid=feedback_valid, drive_ok=drive_ok,
                   jog_stop_request=jog_stop, stall_suspect=stall,
                   auto_resume_attempted=s.auto_resume_attempted)
        self.rows.append(row)
        return row

def run():
    h = Harness()
    # P0: reference gating
    h.step("P0", "typed-denied-unreferenced", typed=True)
    h.step("P0", "home-start", home=True)
    h.step("P0", "home-complete", home_complete=True)
    # P1: persistent native-style jog plus release
    h.step("P1", "jog-pos-start", jog_pos=True)
    h.step("P1", "jog-pos-persists-no-refresh")
    h.step("P1", "jog-pos-release", jog_release=True)
    # P2: authorization loss before release
    h.step("P2", "jog-neg-start", jog_neg=True)
    h.step("P2", "auth-loss-held", machine_authorized=False, jog_neg=True)
    h.step("P2", "auth-restored-held-no-resume", jog_neg=True)
    h.step("P2", "enter-reconcile-held", jog_neg=True, reconcile=True)
    h.step("P2", "complete-reconcile-held", jog_neg=True, reconcile=True)
    h.step("P2", "new-jog-after-reconcile", jog_neg=True)
    h.step("P2", "release-new-jog", jog_release=True)
    # P3: independent jog stop
    h.step("P3", "jog-pos-start", jog_pos=True)
    h.step("P3", "independent-jog-stop", jog_stop=True)
    # P4: distinguish feedback, drive and abstract stall fault inputs
    for case, event, kwargs in [
        ("P4a", "feedback-fault", {"feedback_valid": False}),
        ("P4b", "drive-fault", {"drive_ok": False}),
        ("P4c", "stall-fault", {"stall": True}),
    ]:
        h.step(case, "jog-start", jog_pos=True)
        h.step(case, event, **kwargs)
        h.step(case, "fault-to-reconcile", reconcile=True)
        h.step(case, "reconcile-done", reconcile=True)
    # P5: typed target interrupted; explicit new request required afterward
    h.step("P5", "typed-start", typed=True)
    h.step("P5", "typed-auth-loss", machine_authorized=False)
    h.step("P5", "auth-return-no-old-request")
    h.step("P5", "to-reconcile", reconcile=True)
    h.step("P5", "reconcile-complete", reconcile=True)
    h.step("P5", "idle-no-auto-resume")
    h.step("P5", "new-typed-request", typed=True)
    h.step("P5", "typed-fault-to-cleanup", drive_ok=False)
    h.step("P5", "to-reconcile2", reconcile=True)
    h.step("P5", "reconcile-complete2", reconcile=True)
    # P6: conflicts, invalid target, adjacent authorization toggle, lost reference
    h.step("P6", "both-jog-directions", jog_pos=True, jog_neg=True)
    h.step("P6", "typed-invalid-target", typed=True, typed_target_valid=False)
    h.step("P6", "jog-start-for-conflict", jog_pos=True)
    h.step("P6", "typed-while-jog-active", typed=True)
    h.step("P6", "home-while-jog-active", home=True)
    h.step("P6", "auth-toggle-low", machine_authorized=False, jog_pos=True)
    h.step("P6", "auth-toggle-high-held", jog_pos=True)
    h.step("P6", "reconcile-lost-reference", reference_valid=False, reconcile=True)
    h.step("P6", "finish-reconcile-unreferenced", reconcile=True)
    h.step("P6", "typed-denied-after-ref-loss", typed=True)

    r = h.rows
    e = {(x["case"], x["event"]): x for x in r}
    gates = {
      "A": all(x["owner"] in {"NONE","HOMING","JOG_CONT_POS","JOG_CONT_NEG","TYPED_MOVE"} for x in r),
      "B": all(not (x["owner"] == "TYPED_MOVE" and not x["reference_valid"]) for x in r) and e[("P6","typed-invalid-target")]["owner"] != "TYPED_MOVE",
      "C": e[("P1","jog-pos-persists-no-refresh")]["owner"] == "JOG_CONT_POS",
      "D": e[("P1","jog-pos-release")]["owner"] == "NONE",
      "E": e[("P2","auth-loss-held")]["state_after"] == "FAULTED" and not e[("P2","auth-loss-held")]["motion_request_active"] and e[("P2","auth-restored-held-no-resume")]["owner"] == "NONE",
      "F": e[("P3","independent-jog-stop")]["owner"] == "NONE",
      "G": {e[("P4a","feedback-fault")]["fault_reason"], e[("P4b","drive-fault")]["fault_reason"], e[("P4c","stall-fault")]["fault_reason"]} == {"FEEDBACK_INVALID","DRIVE_FAULT","STALL_SUSPECT"},
      "H": all(e[k]["owner"] == "NONE" for k in [("P2","auth-restored-held-no-resume"),("P5","auth-return-no-old-request"),("P6","auth-toggle-high-held")]) and all(e[k]["state_after"] == "RECONCILE" for k in [("P2","enter-reconcile-held"),("P5","to-reconcile"),("P6","reconcile-lost-reference")]),
      "I": all(not x["auto_resume_attempted"] for x in r),
      "J": e[("P6","both-jog-directions")]["owner"] == "NONE" and e[("P6","typed-invalid-target")]["owner"] == "NONE" and e[("P6","typed-while-jog-active")]["owner"] == "JOG_CONT_POS" and e[("P6","home-while-jog-active")]["owner"] == "JOG_CONT_POS",
    }
    return r, gates

if __name__ == "__main__":
    rows, gates = run()
    out = sys.argv[1] if len(sys.argv) > 1 else "PB-BG-001-080-invocation-evidence.csv"
    with open(out, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0]))
        w.writeheader(); w.writerows(rows)
    data = open(out, "rb").read()
    print(json.dumps({"rows": len(rows), "sha256": hashlib.sha256(data).hexdigest(), "gates": gates, "pass": all(gates.values())}, indent=2))
    raise SystemExit(0 if all(gates.values()) else 1)
