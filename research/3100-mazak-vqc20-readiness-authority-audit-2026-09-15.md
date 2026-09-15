# 3100 — Mazak VQC20 readiness/authority audit — 2026-09-15

## Scope

Inspected `agant172/mazak-vqc20-linuxcnc-retrofit` at pinned revision `309875b7a8d940adfb554ab7c38f4c630e679166`, focusing on `linuxcnc/field_7i84u.hal`. This is a valuable production-retrofit artifact because it explicitly records which field statuses are authoritative, warning-only, unverified, or commissioning-pending.

## Findings

### Status availability is deliberately not equivalent to authority

The configuration maps `lube-ok` from a head-lube pressure switch, `door-interlock` from a door chain, and `thermal-alarm` from motor thermal contacts, but comments explicitly classify all three as **WARNING-ONLY** with the PyVCP warning panel as sole consumer. The comments also preserve that this is a deliberate deviation from the OEM PLC's halting alarms.

This is unusually strong evidence for the curriculum rule:

`physical status exists -> HAL status exists -> consumer exists` does **not** imply `status gates machine/process authority`.

### Coolant level is not yet trustworthy evidence

`coolant-low` has a proposed field input, but the source comment says its source conductor is still unlocated after an audit corrected a previous mistaken assignment. Therefore the signal name must not be promoted as proven physical coolant-level feedback.

### Spindle readiness/fault have stronger authority

The configuration maps a commissioning-pending FR-SX up-to-speed output to `spindle.0.at-speed`, with polarity explicitly left for bench verification. A separate spindle fault is routed to `spindle.0.amp-fault-in`.

The output side builds a broader `spindle-motion-permit` and gates forward, reverse, run, PWM enable and orientation paths through it. A global commissioning hold is intentionally initialized false until drive architecture/polarity are proven. This is materially stronger than merely displaying spindle status.

### Gravity-axis brake sequencing exposes readiness debt

The Z brake/drive sequence intentionally asserts drive enable before releasing the brake, and retains drive torque briefly while the brake engages on shutdown. But the source explicitly labels the 100 ms timing as open-loop and notes that an actual drive-ready contact is not yet used in that brake-release gate. A combined `SERVO_READY` signal may already exist and must be confirmed before redesign.

This cleanly separates:

- command/request;
- fixed timing assumption;
- actual drive-ready feedback;
- mechanical brake state;
- commissioning measurement needed to justify the timing.

### Tool clamp proof exists

The field map includes separate `tool-clamped` and `tool-unclamped` physical inputs. As with earlier ATC work, this supports treating clamp state as a physical witness separate from logical tool identity.

## Architecture/playbook consequences

1. Preserve each readiness signal's **authority class**: warning/display, process permissive, motion fault, commissioning-only, or safety/hardwired external layer.
2. Preserve provenance quality separately from logical wiring. A beautifully named HAL net whose field conductor/polarity is unverified is not production evidence.
3. A fixed delay can be a temporary commissioning mechanism but must not be silently upgraded into 'drive ready'.
4. Production retrofit documentation should retain deliberate deviations from OEM interlock behavior; otherwise later maintainers may mistake warning-only wiring for accidental omission.
5. Readiness design should record both positive evidence and what remains deliberately untrusted.

## Adversarial review

- `lube-ok` goes false. Does this config prove LinuxCNC stops? **No; source says warning-only.**
- `coolant-low` is named in HAL. Is its physical source proven? **No; source explicitly says unlocated.**
- spindle at-speed is wired. Is its polarity commissioned? **No; pending bench verification.**
- 100 ms expires after Z drive enable. Does that prove holding torque exists? **No; source calls it open-loop and identifies drive-ready feedback as the stronger future gate.**
- tool-clamped true proves the tool table's logical identity? **No.**

5/5 pass.

## Evidence-gain stop / rotation

3100 now has strong breadth evidence for ATC/tool identity, spindle orient/readiness, probing/WCO versus persistent tool calibration, sensor conditioning, lube/coolant status provenance, and gravity-axis brake/readiness sequencing. Remaining production auxiliaries (chiller/chip/pallet) are useful but no longer justify repeated generic searching in this pass. Checkpoint 3100 and rotate to underdeveloped 3900 on the next coherent work unit.

No lab is justified: the key authority distinctions are explicit in real configuration source.
