# 3600 — pinned LinuxCNC jog command path for backgauge operator modes

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Python UI boundary

`src/emc/usr_intf/axis/extensions/emcmodule.cc::jog()` exposes three distinct requests:

- `JOG_STOP` -> `EMC_JOG_STOP`
- `JOG_CONTINUOUS` -> `EMC_JOG_CONT`
- `JOG_INCREMENT` -> `EMC_JOG_INCR`

The wrapper places `joint_or_axis`, `jjogmode`, velocity, and (for incremental jog) increment into the NML command and sends it with `emcSendCommand()`.

This confirms that a press-brake hold-arrow control has a native continuous-jog/start and explicit jog-stop semantic. It should not be implemented by continuously synthesizing target positions.

## Existing UI helper authorization

At the same pinned revision, `src/emc/usr_intf/shcom.cc` provides a useful reference implementation:

`sendJogCont()` rejects the request if Task state is not ON. It also rejects joint jogging while trajectory mode is TELEOP and teleop/axis jogging while trajectory mode is not TELEOP. It validates joint/axis selection before constructing `EMC_JOG_CONT`.

`sendJogIncr()` applies the same machine-ON and joint-vs-teleop mode checks.

`sendJogStop()` constructs a separate `EMC_JOG_STOP`; importantly, its shown helper path does not first require Task state ON. This is directionally appropriate for a stop/revoke path: an HMI should not gate its attempt to stop merely because authorization state has changed.

## Press-brake implication

For a first-stage X/R/Z backgauge HMI:

1. arrow/button press in a valid manual mode requests `JOG_CONTINUOUS`;
2. release requests `JOG_STOP` immediately;
3. mode/authorization/fault loss must also generate or independently enforce stop/revocation rather than relying solely on a GUI release event;
4. fine-step buttons may use `JOG_INCREMENT` as a separate operator intent;
5. typed absolute position should use a separately authorized positioning path after reference validity, not masquerade as continuous jog.

## Remaining source trace

The UI/NML boundary is source-confirmed here. Next inspect `emctaskmain.cc` handling of `EMC_JOG_CONT`, `EMC_JOG_INCR`, and `EMC_JOG_STOP`, and the corresponding motion command handoff. That trace must establish which checks are performed downstream and what happens to an active jog when Task/machine state changes. Do not claim same-cycle stop timing or functional-safety behavior from this UI trace alone.
