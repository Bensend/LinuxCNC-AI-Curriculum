# Active Curriculum Session State

Session start UTC: `2026-09-12T15:14:29Z`
Session end UTC: `2026-09-12T15:17:51Z`
Actual elapsed: **3.4 minutes**
Status: **CLOSED — F02 external gate preserved; 3600 gravity-loaded auxiliary-axis brake/PID authority field failure reconciled with stock LinuxCNC source.**

## Critical path

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains **PREPARED / UNSCORED**. Repository code/issue checks found no correctly routed information-separated F02 evaluator response. F02 remains the sole known 2000-series graduation gate and was not self-scored.

## Work completed

New durable artifacts:

- `research/3600-gravity-axis-brake-pid-authority-field-failure-2026-09-12.md`
- `checkpoints/3600-gravity-axis-brake-authority-next-2026-09-12.md`

A public Ursviken/Pullmax press-brake retrofit chronology supplies a concrete gravity-loaded R-axis failure case: with a mechanical holding brake preventing expected motion while closed-loop authority remained active, persistent position error drove the DC servo until it overheated and was destroyed. The same field chronology later records brake logic momentarily re-applying during sufficiently slow commanded motion and a separate feedback/hard-stop high-power event. These observations remain **COMMUNITY-REPORTED**; the exact machine configuration attachment is not publicly inspectable from the source used here.

Pinned LinuxCNC source at `f325d51f52da7d5e0e227ac35e3672ee6f873b4f`, `src/hal/components/pid.c`, confirms the controlling software boundary. While enabled, PID computes from command/feedback and its configured limits. Its anti-windup behavior is tied to its own `maxoutput` limit state, and `pid.N.saturated`/duration/count report that internal clipping state. They do not prove mechanical brake release, amplifier readiness, external current/torque saturation, freedom from a hard stop, encoder validity, or actual actuator motion. Disabling PID resets its integral accumulator and forces output to zero, but does not by itself validate those downstream states.

The 3600 ordinary-control model therefore now makes **mechanical holding-brake state/authority explicit and separate** from position/TargetSet demand, PID output, LinuxCNC enable request, amplifier readiness/fault, feedback freshness/tracking, limits, and completion.

A 5/5 adversarial boundary check passed. No synthetic laboratory run was launched: the software mechanism is directly inspectable in stock LinuxCNC source, while a software-only fixture cannot validate physical brake or motor thermal behavior. Laboratory compute is unchanged.

## Next checkpoint

1. Re-check F02 first and preserve evaluator identity/header plus the full response before changing F02 status.
2. Correctly routed F02 PASS/no corrections closes F02 and the 2000 series; do not self-certify it.
3. If F02 remains blocked, reopen the gravity-axis/brake branch only for a complete inspectable config/component exposing brake release/engage, drive readiness/enable, stall/tracking, homing and recovery semantics; do not invent universal delay/current/stall values.
4. Keep PID saturation classified as an internal controller witness unless downstream evidence explicitly establishes more.
5. Preserve the prior source gates for tandem Y1/Y2, active sensor bending, and explicit-datum tooling/gauging-surface backgauge target calculation.
6. Preserve PB-PREP-001 as **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION** and do not launch another ownership-only synthetic fixture merely to consume a lesson.

Overlap: **No overlap.** Previous completed canonical lesson ended `2026-09-12T14:16:01Z`; this session began `2026-09-12T15:14:29Z`, **58m28s later**.

Short-session continuation check: after the initial allowed-source search, this session continued into a new field-failure trace, pinned LinuxCNC PID source reconciliation, failure-path analysis, and adversarial boundary checks. Further same-branch work is source-gated by the missing complete public brake/drive/stall implementation rather than by lack of a synthetic fixture.
