# D01-001 — pinned duplicated-coordinate kinematics source probe

Status: **NON-AUTHORITATIVE SOURCE-ALGORITHM VERIFICATION / PASS**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Purpose

Verify the surprising source-level implication discovered before D01 experiment freeze: duplicated-coordinate inverse kinematics fans one Cartesian target to all mapped joints, while the corresponding ordinary `trivkins` forward path reports the first/principal mapped joint rather than cross-checking the duplicates.

This is deliberately **not** an authoritative LinuxCNC runtime experiment. It is a deterministic transcription of the relevant mapping semantics from pinned `kins_util.c`, retained so the later runtime lab has a falsifiable prediction.

## Probe

Use coordinate mapping `XYY`:

- joint 0 -> X;
- joint 1 -> first/principal Y;
- joint 2 -> duplicate Y.

World command:

```text
X = 2.0
Y = 10.0
```

The transcribed inverse mapping produced:

```text
joint command = [2.0, 10.0, 10.0]
```

Then inject feedback disagreement:

```text
joint feedback = [2.0, 10.0, 9.0]
```

The transcribed forward mapping produced:

```text
X feedback = 2.0
Y feedback = 10.0
```

The duplicate Y joint's `9.0` does not alter reported Cartesian Y in this mapping because joint 1 is the principal Y joint.

## Falsifiable runtime prediction

A real pinned-LinuxCNC D01 lab using duplicated `trivkins` should be able to retain a state in which:

```text
Y world command ≈ principal-Y feedback
reported Cartesian Y ≈ principal-Y feedback
secondary-Y feedback != principal-Y feedback
secondary-Y following error/disagreement exposes the asymmetry
```

subject to the configured following-error threshold and update ordering.

If the real runtime does not reproduce this qualitative distinction, the source interpretation or test topology must be corrected before D01 can teach it.

## Adversarial conclusion

This probe falsifies the *algorithmic assumption* that duplicated-coordinate forward kinematics necessarily averages or validates all duplicate joint measurements. It does **not** prove runtime timing, fault behavior, physical geometry, sensor integrity, actuator authority or safety behavior.

## Next experiment requirement

Freeze the runtime experiment only after documenting the exact pinned update order from joint feedback/following-error processing through forward kinematics and motion disable. The authoritative D01 gate must require real LinuxCNC objects and retained realtime evidence, not this transcription.