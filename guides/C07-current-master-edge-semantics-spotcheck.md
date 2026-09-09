# C07 — Current-Master HALUI Edge-Semantics Spot-Check

Date checked: 2026-09-09 UTC

1000-level authoritative C07 source conclusions remain pinned to LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`. This note is a compatibility/version-surface spot-check only.

## Current upstream master checked

At the time of this check, upstream `LinuxCNC/linuxcnc` master resolved to:

`64efb28cd77a16b45ade81e576c784cdc574f40e`

The current-master `src/emc/usr_intf/halui.cc` still defines `check_bit_changed(bool halpin, bool &newpin)` so that a changed input updates the stored prior value and returns the *current boolean*. Therefore a 0->1 change returns true, while a 1->0 change records the new false state but returns false. Current master still wraps `sendMachineOn()` and the corresponding machine/estop/mode commands in `if (check_bit_changed(...) != 0)`.

Compatibility observation: the rising-edge request behavior used by C07's pinned experiment is therefore still present in this current-master spot-check. This does **not** prove all C07 Task/Motion behavior is unchanged across revisions; only this HALUI request-edge surface was checked.

## Current official documentation cross-check

Current official HALUI documentation still describes HALUI as connecting HAL pins to NML commands, lists `halui.machine.on` as an input for *requesting* machine on, and lists `halui.machine.is-on` as a separate output indicating machine-on status. The HALUI man page also says HALUI acts when input changes are noticed and expects physical inputs to be debounced.

This remains consistent with C07's retrieval rule:

```text
request surface != achieved-state surface
```

It does not independently establish the exact pinned internal edge implementation; source does that.

## Engineering consequence

A custom operator/sequencing layer should continue to use returned status to decide whether a transition was achieved rather than treating its own request history as the authoritative machine state. Version-specific code should still be checked when exact edge/retry semantics matter.

Evidence classes:
- current-master edge implementation: **SOURCE-CONFIRMED for master `64efb28c...` only**;
- current public HALUI request/status terminology: **DOC-CONFIRMED**;
- cross-version equivalence of the full C07 Task/Motion path: **UNKNOWN / not claimed by this spot-check**.
