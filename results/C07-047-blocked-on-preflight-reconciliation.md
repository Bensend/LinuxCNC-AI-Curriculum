# C07-047 — Blocked Machine-ON Preflight Reconciliation

Status: **NON-AUTHORITATIVE PREFLIGHT PASS**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Workflow: `34314733007`  
Job: `102348466843`  
Artifact: `10089716849` (`linuxcnc-lab-047-c07-blocked-on-preflight-34314733007-1`)  
Artifact digest: `sha256:c458fde6dfa4a52b9ac51a568e4d2c6f57665b78d8a3c2bbfa52e3b53dba67a7`  
Head commit: `cc019f8c2d7daabb95dfd07d2844564e466dd790`  
Job wall-clock runtime: 2026-09-09T05:24:57Z to 2026-09-09T05:28:23Z = **3m26s (3.43 min)**.

## Evidence boundary

This run was explicitly predeclared as **NON-AUTHORITATIVE**. It tests only the source-grounded topology/readiness and the blocked-transition seam required before implementing the full sequencer. It does **not** score frozen C07-047 Gates A–J, and no gate was altered after seeing output.

## Provenance / source integrity

The job checked out exactly `8bf4605ae81042248add031e94c77300406e0413`, built the RIP environment, and retained SHA-256 values for the production files used by the call-flow argument:

```text
ae4133b493a47383a3257ad0fc9b588ac8affd60ebddfe54348a00808a54795c  src/emc/usr_intf/halui.cc
0c195d3434e93ca622df85f6212df7e58b7954c280369cdcd9ee8c9df1bf0f5f  src/emc/task/emctask.cc
94b87f79480abf598b44db13e14ac0f8df551ba33e9dc509b9ee90a6eebaf377  src/emc/task/emctaskmain.cc
862325521c33998cb6b652b446d557c766978dbfbf2f53e1f741ab9cb0ed30f6  src/emc/task/taskintf.cc
eba565692dee677bae601284621deaacab440db26ad98867787d821361475806  src/emc/motion/command.c
b242df4a4c7ce256e01f87665a191bafc8ccd0c6fd9819a84de8dc51cecab168  src/emc/motion/control.c
559a470408cbf6f551cab75737598b2b89ba82f8c1a7c13a342100861affb62a  src/emc/motion/motion.c
```

The job modified only the copied test INI to start HALUI and used normal HAL pin manipulation; it did not patch these production source files.

## Actual-object readiness

The test did not rely on `halcmd show` exit status alone. It required returned output to contain the named real objects. Readiness passed at probe 3 with these objects present:

- `halui.machine.on`
- `halui.machine.is-on`
- `halui.estop.reset`
- `motion.enable`

The test also observed `motion.motion-enabled` for the realtime achieved-enable intermediate.

## Baseline

After a fresh E-stop-reset request and explicit machine-off request:

```text
halui.estop.is-activated=false
halui.machine.is-on=false
baseline motion.enable=TRUE machine.is-on=FALSE estop=FALSE
```

This establishes the required out-of-estop but machine-not-on topology before the blocked request.

## Blocked request result

The harness set `motion.enable=0`, verified it false, then emitted exactly one fresh HALUI machine-on pulse (`0 -> 1 -> 0`). After the request:

```text
after-blocked-request machine.is-on=FALSE motion.motion-enabled=FALSE
blocked-request=PASS
```

This is the expected source-grounded discriminator: a valid upper-layer machine-on request did not create achieved ON because the lower realtime prerequisite was false.

## No implicit retry after prerequisite restoration

The harness then set `motion.enable=1` **without a new machine-on edge** and observed:

```text
after-prereq-restore-no-edge machine.is-on=FALSE
no-implicit-retry=PASS
```

This confirms the planned topology exposes HALUI's pinned rising-edge request contract rather than treating a previously consumed request as a persistent level command.

## Fresh explicit retry

Only after emitting a new request pulse with the prerequisite restored did both achieved-state observations become true:

```text
halui.machine.is-on=true
motion.motion-enabled=true
explicit-retry=PASS
```

Final retained state:

```text
final motion.enable=TRUE motion.motion-enabled=TRUE machine.is-on=TRUE estop=FALSE
```

## Adversarial interpretation

The preflight falsifies three unsafe/easy sequencing shortcuts in the selected software-only topology:

1. **"I emitted machine ON, therefore the machine state is ON"** — false in the blocked case.
2. **"The prerequisite recovered, therefore my old request will eventually succeed"** — false without a fresh edge.
3. **"A request variable can stand in for achieved-state feedback"** — false because the real returned `machine.is-on` and realtime `motion.motion-enabled` remain false while the request has already been consumed.

These are preflight observations, not yet evidence that the planned test sequencer itself obeys the frozen no-auto-restart and guarded-recovery policy.

## Benign/non-central runtime output

The inherited `linuxcncrsh` simulation emitted background messages including unsupported `EMC_SPINDLE_SPEED_NACK` behavior from that test configuration. They did not alter the tested machine-on/`motion.enable` path and did not cause the job to fail. The authoritative harness should minimize or explicitly retain such background messages so unrelated simulator behavior cannot be mistaken for C07 fault evidence.

## Decision

**PREFLIGHT PASS.** The selected pinned simulation can expose real HALUI request/status pins, provide a single controllable `motion.enable` prerequisite, reproduce the blocked ON request, preserve the no-implicit-retry edge behavior, and achieve ON after a fresh explicit retry.

Frozen C07-047 **Gates A–J remain UNSCORED**.

## Exact continuation

Construct the test-only sequencer defined in `experiments/C07-047-sequencer-construction-notes.md` on this passing topology. Add ordered observation for P0–P8, including separate `start_authorize`, sequencer state, request edge, `motion.enable`, `motion.motion-enabled`, `halui.machine.is-on`, and cycle permission. Because HALUI status is userspace-mediated, prove monotonic transition ordering in a non-authoritative full phase/observation preflight before launching the authoritative run. Then run C07-047 once against unchanged Gates A–J.
