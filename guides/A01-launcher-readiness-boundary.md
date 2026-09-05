# A01 — LinuxCNC launcher readiness boundary

## Scope

Module: A01 process/component architecture  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Evidence classes used below: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `INFERENCE`, `UNKNOWN`.

This note tightens the observation boundary for experiment `004-a01-runtime-topology.sh`. It does not claim a root cause for prior timeout run `33965517203`; it identifies a source-grounded readiness condition that the next single paid rerun should enforce.

## Finding 1 — `milltask` + `linuxcncsvr` is not a sufficient "startup complete" condition

**SOURCE-CONFIRMED.** In pinned `scripts/linuxcnc.in`, startup order is:

1. start `linuxcncsvr` (NML server),
2. start realtime/HAL infrastructure,
3. load trajectory/homing realtime modules,
4. start Task through `halcmd loadusr -Wn inihal "$EMCTASK" ...`,
5. execute HAL files and discrete HAL commands,
6. execute `halcmd start`,
7. run configured applications,
8. perform a trajectory-value readiness loop using `halcmd getp ini.traj_max_velocity`,
9. only then launch the configured display.

Therefore seeing both `linuxcncsvr` and `milltask` proves important controller processes exist, but it does **not** prove the launcher's HAL setup has completed or that the configured display has been reached.

This matters because the prepared `004` branch currently begins external `halcmd list comp` probes as soon as those two processes are visible. That can cause the experiment to begin observing HAL while the launcher is still performing its own HAL commands.

## Finding 2 — the launcher has another nominally bounded loop containing an unbounded inner HAL command

**SOURCE-CONFIRMED.** Immediately before starting the display, pinned `linuxcnc.in` computes a ten-second `RACE_TIMEOUT`, but both the initial and repeated reads are plain:

`halcmd getp ini.traj_max_velocity`

The elapsed-time test is outside the command substitution. If one `halcmd getp` blocks in HAL attachment/shared locking, the nominal ten-second loop is not a wall-clock bound. This is the same general control-flow mistake already identified in the curriculum's original external readiness loop: a bounded outer loop does not bound an unbounded inner command.

This is a launcher robustness observation, not evidence that this exact line caused run `33965517203` to stall.

## Finding 3 — `linuxcncrsh` is a stronger phase marker for this exact test configuration

**DOC-CONFIRMED.** Current LinuxCNC documentation describes `linuxcncrsh` as a full text-mode UI that may substitute for a normal graphical UI when selected as `[DISPLAY] DISPLAY=linuxcncrsh`.

**SOURCE-CONFIRMED.** In pinned `linuxcnc.in`, the `linuxcncrsh` display is invoked in the foreground only after HAL files, `halcmd start`, configured applications, and the trajectory readiness loop above. The launcher does not proceed to normal `Cleanup()` until that display returns.

For the upstream `tests/linuxcncrsh/linuxcncrsh-test.ini` experiment, observing a live `linuxcncrsh` process is therefore a materially stronger startup-phase marker than observing only `milltask` and `linuxcncsvr`.

Prior cancelled-run cleanup logs did show a live `linuxcncrsh`, which proves that run eventually reached the display phase. They do not prove when the curriculum's external `halcmd` probe began or where that probe was blocked.

## Required experiment correction

Before the next paid `004` run, change controller-process readiness so the experiment does not issue its first external HAL query until all three expected userspace processes are observable:

- `linuxcncsvr`
- `milltask`
- `linuxcncrsh`

Record progress markers separately for each process. If `milltask`/`linuxcncsvr` appear but `linuxcncrsh` does not, capture launcher/process state and the launcher's stdout/stderr rather than starting an external HAL probe. This distinguishes "controller processes started" from "configured display phase reached."

After `linuxcncrsh` is observed, retain the existing bounded external `halcmd` probe and live-PID backtrace logic. Requiring the display phase does **not** make HAL locking impossible; it simply removes a known startup-phase ambiguity.

## Adversarial checks

1. **Misleading premise:** "`milltask` exists, therefore LinuxCNC startup is complete."  
   **Correction:** false at the pinned revision. Task starts before HAL-file execution, `halcmd start`, the trajectory readiness loop, and display launch.

2. **Misleading premise:** "The launcher trajectory readiness loop has `RACE_TIMEOUT=10`, so it cannot hang longer than ten seconds."  
   **Correction:** false as a wall-clock guarantee. The timeout check cannot execute while an inner `halcmd getp` call is blocked.

3. **Misleading premise:** "Seeing `linuxcncrsh` proves an external `halcmd list comp` cannot hang."  
   **Correction:** false. It proves the launcher reached the display phase; external HAL attachment/query locking remains separately observable and must stay bounded.

4. **Failure interpretation:** If `linuxcncsvr` and `milltask` are live but `linuxcncrsh` never appears, do not classify an external `halcmd` stall because no external HAL probe should have begun yet. Diagnose launcher startup from its preserved output/process state.

## Evidence boundary / open questions

- `SOURCE-CONFIRMED`: pinned launcher ordering and the placement of the `halcmd getp` loop.
- `DOC-CONFIRMED`: `linuxcncrsh` is a supported text-mode UI/display.
- `INFERENCE`: waiting for `linuxcncrsh` should reduce normal startup-phase contention/ambiguity in `004`.
- `UNKNOWN`: exact blocking frame in the previous external observation hang; only the corrected live-stack experiment may promote that to test evidence.

## Next source/experiment checkpoint

During the next laboratory-budget window, reconcile `a01-bounded-observation` with `main`, then modify `004` so its first HAL query is gated on `linuxcncrsh` as well as `milltask` and `linuxcncsvr`. Re-audit all bounded paths once more and permit exactly one corrected run.
