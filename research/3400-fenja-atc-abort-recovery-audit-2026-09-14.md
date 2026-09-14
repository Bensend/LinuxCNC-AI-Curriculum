# 3400 — FENJA/Groot ATC abort and recovery audit

Date: 2026-09-14
Public machine repository: `GuiHue/myfenjalinuxcnc`
Pinned inspected revision: `16af9ade9484e9f6897b19bd6453ab4bbe79c0ac`
Status: **SOURCE/CONFIG RECOVERY AUDIT — important reconciliation gap preserved**

## Question

After the first ATC source pass showed distinct clamp/tool witnesses, the highest-consequence remaining question was what the public configuration actually does when M6 aborts in an intermediate physical state.

## 1. The INI contains an abort hook, but it is disabled

`groot.ini` contains the comment:

`# is the sub, which is called when a error during tool change happens`

followed by:

`#ON_ABORT_COMMAND=O <on_abort> call`

The leading `#` means the configured ON_ABORT_COMMAND is **commented out** at the inspected revision.

Therefore the existence of `macros/on_abort.ngc` must not be mistaken for evidence that the machine invokes it automatically during remap abort.

## 2. Even the preserved `on_abort.ngc` does not reconcile ATC outputs/state

The `on_abort.ngc` file contains only:

- `G90` — restore absolute distance mode;
- `G40` — cancel cutter compensation;
- `G49` — cancel tool length compensation.

It does not visibly:

- close/release the drawbar;
- clear the automatic ATC digital request;
- verify tool-present state;
- inspect drawbar state;
- inspect air pressure;
- move away from or toward the rack;
- reconcile current tool/pocket identity;
- restore a known rack inventory state.

Thus, even if the hook were enabled as preserved, it would reset interpreter/modal state rather than implement a physical ATC recovery state machine.

## 3. Immediate output commands make physical state reconciliation important

The rack-change macro uses `M64` / `M65` on the configured motion digital output to command the drawbar. Current LinuxCNC documentation defines:

- M64 = turn the selected digital output on **immediately**;
- M65 = turn it off **immediately**;
- unlike queued M62/M63, they are not synchronized to the next motion and break blending.

The public documentation does not, by itself, let this audit assert the exact value of that output after every possible Task/interpreter abort path. Therefore the correct curriculum classification is:

**abort-time automatic-output reconciliation is not proven by this machine config and must be established explicitly before teaching safe restart behavior.**

Do not infer “the abort will obviously turn it off.”

## 4. The macro has local fault branches but they are not a whole-cycle recovery model

`rack_change.ngc` checks several expected states and returns/ends on errors, including:

- drawbar failed to open;
- tool remained in spindle after dropoff;
- drawbar failed to close;
- no tool detected after pickup.

Those are useful detection points. But they occur at different physical locations and after different commands. A return from one of those checks can leave the machine in a materially different state from a return at another.

Examples of distinct interrupted states include:

1. spindle at rack, drawbar commanded open, old tool still retained;
2. spindle at rack, old tool deposited, spindle empty, logical old-tool state not yet fully reconciled;
3. new tool physically engaged but drawbar not confirmed closed;
4. new tool clamped and physically present but `M61 Q<newtool>` not yet reached;
5. logical tool updated but subsequent fixed-setter measurement not completed.

A generic “retry M6” policy cannot be assumed safe/correct across all five.

## 5. M66 comments reveal a second recovery/diagnostic limitation

As documented in the first source audit, many sensor checks use:

`fixed G4 dwell -> M66 ... L0 -> inspect #5399`.

Official LinuxCNC documentation defines M66 mode 0 as **IMMEDIATE — no waiting**. Transition-wait modes are L1–L4 with optional Q timeout.

Therefore this machine's checks provide a snapshot after a chosen settling delay. They do not provide a measured transition time or distinguish “never moved” from “moved late but after snapshot” except through the final sampled state.

For recovery diagnostics, a future implementation may benefit from explicit wait-with-timeout semantics or a realtime state machine where the physical mechanism warrants it.

## 6. Recovery authority model for the 3400 playbook

A production router ATC should preserve at least these independent pieces of provenance across an interruption:

- requested tool and target pocket;
- last confirmed physical tool-present state;
- last confirmed drawbar state;
- whether the spindle is inside rack transfer geometry;
- whether tool storage was known occupied/empty before the attempt;
- automatic ATC output state;
- spindle/VFD stopped/fault state;
- pneumatic pressure state;
- LinuxCNC logical tool-in-spindle state;
- whether tool length has been measured/applied since acquisition.

Recovery should begin by **observing/reconciling those states**, not by blindly replaying the nominal M6 sequence.

## 7. Safety boundary

This audit concerns ordinary machine-control recovery. A VFD `is-running` bit, LinuxCNC digital output, G-code remap or software abort handler is not evidence of a safety-rated spindle standstill or pneumatic-energy isolation function.

Physical access to an ATC, spindle, rack or tool remains subject to the machine's independent safeguarding and energy-control design.

## Adversarial review — 7/7

1. Does the presence of `on_abort.ngc` prove it is active? **No; the INI hook is commented out at the inspected revision.**
2. Would the preserved `on_abort.ngc` physically reconcile the drawbar/rack? **No; it only resets G90/G40/G49.**
3. Do local error checks equal a complete recovery state machine? **No.**
4. Can the curriculum assert M64's ATC output is automatically cleared on every abort from this evidence? **No. Preserve it as unknown until the relevant Task/Motion abort path or runtime is traced.**
5. Can an operator safely assume retrying M6 is idempotent after any interrupted pickup/dropoff? **No; physical and logical tool states can diverge.**
6. Does M66 L0 provide a transition timeout? **No; it is an immediate sample.**
7. Is this gap sufficient reason for a synthetic lab now? **Not yet. First trace generic LinuxCNC abort/output behavior and inspect another production ATC recovery architecture; then freeze a lab only if a nonduplicate question remains.**

## Exact next work

1. Source-trace LinuxCNC Task/Motion handling of motion digital outputs across interpreter abort, program abort and machine-off to determine what generic behavior the config can rely on.
2. Inspect whether a later revision of this machine enabled or expanded ON_ABORT_COMMAND.
3. Compare with another router ATC that explicitly records/reconciles intermediate toolchange state.
4. Search real vacuum-table/dust-collection authority paths to continue 3400 breadth rather than overfocusing ATC.

No lab was launched; source/config work still has higher information gain.
