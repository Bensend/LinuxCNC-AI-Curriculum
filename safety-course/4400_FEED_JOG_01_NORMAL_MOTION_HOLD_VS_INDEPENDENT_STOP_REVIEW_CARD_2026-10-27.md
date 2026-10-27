# 4400-FEED-JOG-01 — Four ordinary motion inputs, four different behaviors

**Read:** [exact pinned source audit](../research/4400_LINUXCNC_FEED_HOLD_INHIBIT_JOG_STOP_SAFETY_AUTHORITY_SOURCE_AUDIT_2026-10-27.md) and [normal M0/M1 pause card](4400_PAUSE_01_NORMAL_PAUSE_VS_SAFE_ACCESS_OPERATOR_REVIEW_CARD_2026-10-27.md). **Status:** documentary source review, not a safety certification or graded test.

| Input | Normal scope | Practical caution |
|---|---|---|
| `motion.feed-hold` | G-code feed only **when M53 enables it**. | Not a jog inhibit, not an independent stop, and M53 P0 can make it ineffective. |
| `motion.feed-inhibit` | G-code motion inhibition; synchronized move may finish first. | Not a jog inhibit, not a fixed stop time, not a safe-access permission. |
| `motion.jog-inhibit` | Rejects new joint/axis jog commands. | Do not assume it independently terminates an already active jog. |
| `motion.jog-stop` / `jog-stop-immediate` | Request stopping active normal jog; immediate variant may cause following error. | Neither is an independent safety stop or proof of gravity-load retention. |

**Design-review action without energizing a machine:** locate the actual HAL signal source, whether M53 is enabled, which motion mode is active, and which separate physical safety function remains effective if the host freezes, HAL input sticks, a jog is already running, or the normal control misses a transition. For a press brake, review both normal Y1/Y2 jog controls and the separate AKAS/Pilz protective stop, independent speed, hydraulic final elements, and ram holding. Never infer safe access from a single HAL pin or HMI light.

**Make the safe workflow easy:** provide a visible distinction between Feed Hold, Jog Inhibit, Protective Stop and maintenance energy isolation; make legitimate setup/jog accessible under the correct independent protective mode, with deliberate restart and no nuisance incentive to bypass guards. **G0/G1 HOLD; physical proof and external evaluation NOT RUN.**


**Homing addendum:** `motion.homing-inhibit` rejects **starting** a home command; it is not documented as an active-homing protective stop. The pinned [motion command check](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/motion/command.c#L1520-L1535) occurs before `do_home_joint`. Do not rely on asserting this input mid-home to protect access or retain a gravity-loaded axis. Independent protective stop/holding remains required.
