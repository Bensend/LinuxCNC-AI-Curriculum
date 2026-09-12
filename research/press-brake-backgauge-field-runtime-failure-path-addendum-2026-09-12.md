# 3600 Press-Brake Research — Backgauge Runtime Failure-Path Addendum

Date: 2026-09-12
Source pin: `aleadvea/press-brake-cnc-upgrade@95cf12f639b036f80541b00128e0a31c5dcc9050`
Companion audit: `research/press-brake-backgauge-field-runtime-source-audit-2026-09-12.md`

## Purpose

The first source audit established the real AUTO-cycle call flow and its completion/freshness boundaries. This addendum traces transport failure and reset/restart paths because those decide whether HMI state is actually bound to a command accepted by the motor-side controller.

## F9 — AUTO publishes a local move episode even when the send helper's result is ignored

`espnow_hmi_send_move_abs()` returns `false` when ESP-NOW is uninitialized or when `esp_now_send(...) != ESP_OK`. The AUTO `go_to_step()` call site invokes that helper but does not branch on its Boolean result; it then records the target and enters `AS_MOVING`.

Therefore the HMI can publish a local `AS_MOVING` state without evidence, at that call site, that the transport API accepted the MOVE request. Even a `true` return would only establish what this wrapper tests — `esp_now_send(...) == ESP_OK` — because the inspected protocol contains no remote command acknowledgement or command ID.

**Classification:** SOURCE-CONFIRMED for ignored local Boolean result and lack of protocol acknowledgement. The consequence for a particular RF loss event is INFERENCE and must not be presented as a reproduced field failure.

### Reachable stale-state consequence

Because the HMI later decides progress from cached `g_machine` state, an unsuccessful MOVE send plus stale IDLE/position can produce either:

- a stall in `AS_MOVING` when cached position is not within the special no-movement target tolerance; or
- apparent completion in the no-movement branch if cached position already lies within that tolerance.

This is a source-reachable state-machine consequence, not proof that it has occurred on the physical machine.

## F10 — alarm reset mutates local HMI state optimistically

`reset_alarm_cb()` calls `espnow_hmi_send_clear_alarm()` but ignores its Boolean result. It then immediately sets:

- `g_machine.alarm_active = false`; and
- a local message stating that the alarm was cleared and homing is required.

Thus local HMI alarm presentation is changed before any remote acknowledgement exists. If communication is unavailable, the HMI can display its locally cleared state until a later status packet overwrites it; the inspected state model has no explicit communication-freshness predicate to qualify that presentation.

**Classification:** SOURCE-CONFIRMED for local mutation and ignored result; communication-loss display duration/consequence is INFERENCE.

## F11 — paired restart is also optimistic at the HMI boundary

`restart_both_cb()` calls `espnow_hmi_send_restart()` and does not inspect its result. It unconditionally schedules the HMI's own restart roughly 600 ms later. Therefore a failed motor-side restart request is not distinguished before the HMI resets itself.

This reinforces the same ownership rule: local UI lifecycle state is not evidence of a remotely accepted semantic action.

## Refined command-ownership rule

A robust backgauge runtime should distinguish at least:

1. **operator/program intent** — row/target selected;
2. **local command publication** — HMI/controller created a fresh command episode;
3. **transport acceptance** — local transport accepted the request;
4. **remote semantic acceptance** — intended motor/controller accepted the matching command generation;
5. **motion/progress observation** — current, fresh status tied to the same source generation;
6. **target qualification** — final target error/physical feedback criteria satisfied;
7. **process-phase qualification** — bend/retract phase permits row advancement.

Not every architecture needs a network protocol, but collapsing these stages makes stale state and recovery ambiguity harder to diagnose.

## Adversarial checks

1. **Does `go_to_step()` refuse to enter MOVING when MOVE send returns false?** No — result is ignored.
2. **Does `CmdPacket` contain an ID that remote status echoes as acceptance/completion?** No.
3. **Does reset-alarm wait for motor acknowledgement before clearing local alarm state?** No.
4. **Does restart-both verify the motor restart request before restarting the HMI?** No.
5. **May a future status packet overwrite the optimistic local alarm state?** Yes; receive callback overwrites `g_machine` from status. This does not supply an explicit stale/fresh contract.

Result: **5/5 source questions resolved**.

## Curriculum correction

No existing PB-BG result is invalidated. Add one explicit distinction to the 3600 playbook:

> A fresh `ExecutionEpisode` is application ownership state, but distributed implementations also need to distinguish local episode creation from remote command acceptance. Do not call a command "accepted" merely because the sender advanced its own UI state.

This is especially important when status/feedback freshness is independently transported.

No laboratory compute was consumed in this addendum.
