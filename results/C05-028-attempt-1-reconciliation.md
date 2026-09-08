# C05-028 attempt 1 reconciliation

Status: **HARNESS INVALID — no behavioral result**

Authoritative workflow: `34246869855`

Job: `102131002815`

Source commit: `5f4f0a765f577921e4c338953e016213a3b59f25`

Recorded lab interval: `2026-09-08T15:46:15Z` to `2026-09-08T15:49:34Z`

Workflow result commit: `6081e494074c8b808d7882e36833b4de57f940bb`

## Failure

The fixture reached LinuxCNC startup but failed before any decisive C05 phase with:

```text
<commandline>:0: pin 'c05-sensor-b.sel0': not writable
```

The inner lab exit was `1`.

## Root cause

The HAL file intentionally connected `c05-sensor-b.sel0` to the sampled signal `c05-sensor-freeze`:

```text
net c05-sensor-freeze c05-sensor-b.sel0 => sampler.0.pin.18
```

Once the mux selector pin is linked to that HAL signal, the shell harness cannot later change the **pin** with:

```text
halcmd setp c05-sensor-b.sel0 ...
```

The correct runtime operation is to drive the linked signal with:

```text
halcmd sets c05-sensor-freeze ...
```

This preserves the same selector topology and, importantly, preserves realtime observation of the selector in the sampler row.

## Classification

**HARNESS INVALID.** No frozen behavioral gate was reached, so this run says nothing about whether measured B can freeze while the independent toy plant state continues moving.

The result must not be counted as a Gate E/F failure and must not be used to retune gains, phase durations, thresholds, `Kc`, or the frozen measurement requirements.

## Correction permitted

Change only the shell's writes/reads of the linked selector from direct pin writes to the existing `c05-sensor-freeze` signal. Gates A-H and every numerical threshold remain unchanged.

Also validate the userspace freeze capture as a scalar float before publishing it; this is observation-harness hardening, not a behavioral change.

## Attempt-2 acceptance rule

One authoritative corrected run may be launched. Reconcile its raw trace and inner exit against the unchanged frozen plan. If it reaches the behavioral gates and validly fails them, treat that as behavioral evidence rather than further harness permission.
