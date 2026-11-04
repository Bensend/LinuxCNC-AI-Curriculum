# PLASMA-204 — QtPlasmaC realtime torch/M3 authority versus material ACK (3300, non-graduated)

## Question and evidence scope
Does a failed M190/M66 material-change acknowledgment itself prevent a later M3 from energizing the torch? This is a **source-path audit**, not a physical or executable proof. Predecessors: PLASMA-200–203; PLASMA-202 corrects the mistaken PLASMA-201 L3 rising-edge interpretation. Do not reintroduce that mistake.

**Pinned primary source:** LinuxCNC/linuxcnc development commit `cdf957bd`, `src/hal/components/plasmac.comp`, https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd/src/hal/components/plasmac.comp (line numbers below refer to this revision). Earlier interpreter and UI material-handshake provenance is in PLASMA-200–203. This audit did not verify physical output wiring, specific installed HAL, or other versions.

## Concrete realtime path
1. **Input declaration:** `cutting_start` is a HAL bool input documented as connected to `spindle.0.on`; `torch_enable`, `torch_off`, `machine_is_on`, `program_is_running`, `arc_ok_in`, and other controls are separate pins. `torch_on` is the component's HAL output intended for a torch output connection. A documented intended connection is **not** proof of a specific HAL net or electrical output.
2. **Tool selection, lines 559–568:** `if(cutting_start && !dry_run) tool=CUTTING;` else alternative scribe/spotting or EMPTY. This selection contains **no material number, M190 result, M66 result or #5399 check**. This does not imply unconditional ignition: the later state machine has other prerequisites.
3. **Active-cycle stop/pause logic, lines 688–790:** For `auto_cut`, sensor active at IDLE can force torch off/pause; active cut states can stop/pause on program idle, pause, tool EMPTY, breakaway, float/ohmic sensors, or lost arc. In particular the `tool == EMPTY` branch (740–753) can end a cut. No material-change acknowledgment condition appears in these inspected branches.
4. **Ignition, lines 1513–1548:** In state `TORCH_ON`, after restart delay and attempt-limit checks, `if(torch_enable) {torch_on_set(TRUE); pierce_count_set(...);}` then state becomes `ARC_OK`. This is the **specific observed torch-on assignment** in normal cutting, not an unconditional consequence of M3. The state entry path, full state preconditions, and external output gate must also be audited before claiming reachability.
5. **Arc confirmation, lines 1551 onward:** `ARC_OK` waits for arc evidence with a failure timer, and on timeout turns torch off/retries; this occurs **after** the attempted torch-on assignment, not as a material selection check.
6. **Distinct pulse path, lines 2138–2159:** `TORCHPULSE` can set `torch_on` TRUE under its own pulse/enable conditions. Any claim that normal M3 is the only torch-on path is false.
7. **External torch-off, lines 637–649:** `torch_off` drives output FALSE in its tested branch. This is not an independent personnel-safety circuit and does not prove a final hardware relay is deenergized.

## Narrow conclusion
**SOURCE-CONFIRMED:** In the inspected `plasmac.comp` tool selection and normal TORCH_ON ignition branch, material-change acknowledgment and `#5399` are not explicit gating inputs. Therefore **a QtPlasmaC GUI material error cannot be assumed to be a realtime torch-output interlock**. This is a missing *direct dependency in inspected branches*, not proof that cutting occurs after timeout. Task state, UI errors, program pause/abort, state entry guards, HAL wiring, and physical independent protection may prevent it. The missing link is a complete pinned simulation config plus observed end-to-end behavior.

## Review-only disconnected discrimination matrix (NOT RUN)
| Case | Inputs/event | Predicted source-local result | What would falsify end-to-end conclusion |
|---|---|---|---|
| A | M190 failure, M66 timeout, later M3 issued | Tool selection sees cutting_start independent of material ACK; ignition requires reaching TORCH_ON and torch_enable | Task/GUI aborts before M3 or state never enters TORCH_ON |
| B | M66 HIGH already asserted from prior transaction | L3 can succeed without proving fresh material selection (PLASMA-202) | Explicit material transaction identity enforced elsewhere |
| C | torch_enable FALSE in TORCH_ON | No normal ignition TRUE assignment in the shown `if(torch_enable)` branch | Another output writer/physical circuit drives torch |
| D | arc never OK after ignition attempt | ARC_OK timeout switches torch off/retries | Arc-OK bypass mode or different state path changes behavior |
| E | manual torch pulse requested | Separate TORCHPULSE output path exists | Pulse feature disabled/blocked in actual configuration |
| F | M3 removed/tool EMPTY during active cut | Stop/wait path turns torch off subject to pause-at-end logic | External output or other state path differs |

These are predictions from code, **not** verified test results. Do not dispatch hosted Actions. If runtime evidence is justified, first reconcile existing lab compute/results and confirm isolated `[self-hosted, openpressbrake]` availability.

## Implementation exercise for another AI engineer
Given a pinned `plasmac.comp` and complete QtPlasmaC HAL/INI, draw four distinct paths: (1) material request/ACK via M190/M66, (2) G-code M3 to `spindle.0.on` to `cutting_start`, (3) `TORCH_ON` state to `torch_on` output, and (4) actual output wiring and independent personnel-safety authority. Mark each transition SOURCE-CONFIRMED, CONFIG-CONFIRMED, TEST-CONFIRMED or UNKNOWN. Show why a timeout in (1) is not logically equivalent to a disable in (3).

## Adversarial comprehension prompts
- Does `torch_enable=TRUE` alone energize the torch? **No**: TORCH_ON state and additional conditions are required.
- Does `#5399=1` prove the requested material was selected? **No**: L3 HIGH is level-based, may be stale.
- Does `arc_ok_out` necessarily gate the *first* torch-on edge? **No**: the normal code turns torch on before waiting for ARC_OK.
- Can a torch pulse bypass the normal M3 state? **There is a separate TORCHPULSE path**; actual UI/config reachability is unresolved.

## Dependency ledger and next checkpoint
- **SOURCE-CONFIRMED:** direct code lines 559–568, 688–790, 1513–1548, 1551 onward, 2138–2159; source revision as above.
- **INFERENCE:** a material timeout could be followed by a cutting-start request absent other gates; end-to-end reachability unverified.
- **UNKNOWN:** actual HAL output nets, M3 wiring, UI abort/pause side effects, physical relay state, exact simulator state-entry behavior, 2.9.10 parity.
- **Next highest-value:** inspect the pinned QtPlasmaC simulation HAL/INI wiring and the IDLE→PROBE_HEIGHT→TORCH_ON state-entry guards. If source retrieval fails, rotate to a real open-source CAM postprocessor instead of repeating M66.
- Graduated levels, blind evaluator separation, independent safety authority and OpenPressBrake physical HOLD unchanged. No lab compute, builds, workflows or machine operations performed.
