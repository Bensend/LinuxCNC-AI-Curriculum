# Press-brake 3600 — HMI state/provenance contract

Date: 2026-09-12
Status: DOC/COMMUNITY/SOURCE-INFORMED HMI CONTRACT

## Purpose

Define what a press-brake operator interface should display so that program state, target provenance, stale/invalidation state and LinuxCNC controller state are not collapsed into misleading green indicators.

The goal is not to prescribe one screen layout. It is to preserve ownership and diagnostic truth in whatever QtVCP/GladeVCP/custom interface is eventually used.

## LinuxCNC UI capabilities

Current QtVCP documentation exposes controller actions and status separately. `ActionButton` can issue controller operations such as Run, Pause and Abort. Status widgets can display machine/interpreter state, selected G-code line, file identity, homed state, mode, and arbitrary HAL-pin status.

This separation is important: a UI control that can issue `run` or `abort` is not itself evidence that the requested state occurred physically, and a machine-state label is not evidence that a press-specific BendStep or TargetSet is valid.

Official QtVCP documentation also distinguishes interpreter/controller states including Running, Stopped, Paused, Waiting and Reading. That gives a generic controller-state surface on which press-specific state can be layered rather than hidden.

## Public press-brake UI evidence

The inspected public Accurpress field implementation exposed manual/jog, semi-auto-repeat and G-code automatic modes. A separate 2026 LinuxCNC community GUI concept proposed a dedicated Run screen with a program-bends table and a separate program editor. The latter remained conceptual, while the 2022 field implementation explicitly reported that its intended sequence/wizard workflow was never completed.

Therefore a useful press-brake HMI contract may include a bend-program table, but public evidence does not justify assuming a canonical LinuxCNC bend-row lifecycle.

## Minimum state layers to show separately

### 1. LinuxCNC controller state

Examples:

- ESTOP / ESTOP RESET / MACHINE ON;
- Manual / MDI / Auto;
- Running / Paused / Stopped / Waiting;
- homed/reference state;
- loaded program/file and selected/current line when relevant.

Source: LinuxCNC/QtVCP status.

### 2. Press program state

Examples:

- product/program ID and revision;
- selected BendStep ID;
- step status such as READY, TRIAL, ACCEPTED, REWORK, RECONCILE_REQUIRED;
- explicit current/next row indicator;
- whether row selection is merely operator context or currently owns an authorized runtime episode.

This layer is application-owned.

### 3. Target provenance

For every mechanism target that matters to the bend:

- nominal target;
- active correction and scope;
- effective target;
- TargetSet generation;
- machine/calibration revision;
- calculation-method revision;
- tool/material dependencies where relevant;
- status: VALID, REVIEW_REQUIRED, STALE, INVALID.

A bare number such as `X = 125.000` is insufficient when the number may be stale or derived under an old calibration/tool revision.

### 4. Runtime episode/authorization

Show separately:

- current ExecutionEpisode ID/generation;
- requested command/mode;
- authorization/rearm state;
- current ordinary fault/reconciliation state;
- whether the target is merely selected, queued, active, complete or invalidated.

Same-number reissue must visibly become a new episode even when the displayed target value is unchanged.

### 5. Physical/diagnostic witnesses

Examples:

- X/R/Z/Y1/Y2 measured feedback;
- differential Y1-Y2 witness;
- command versus feedback residual where meaningful;
- pressure/process witness if the machine provides it;
- backgauge at-position predicate result and its validity inputs;
- recorder/diagnostic health when using retained traces for troubleshooting.

Do not replace independent side values with only an average/master position.

### 6. Safety-chain observation boundary

The HMI may display externally supplied safety-chain status, but ordinary LinuxCNC UI/HAL state must not be labelled as proof that the safety function is satisfied unless the actual safety architecture provides and defines that status. Avoid labels such as `SAFE` when the software only knows `ordinary motion authorized`.

## Stale-state presentation rule

Staleness should be represented as a first-class state, not merely by leaving the last number on screen.

For any important displayed value, define at least:

```text
value
source/generation
validity
last-update/generation witness where relevant
reason invalid/stale
```

Examples:

- `X target 125.000 mm — STALE: machine calibration revision changed`;
- `Y1 42.31 / Y2 42.36 — feedback current, differential 0.05`;
- `Bend 4 selected — RECONCILE REQUIRED after abort; no active execution episode`.

The numeric value can remain visible for operator context while authority is explicitly revoked.

## Color/indicator semantics

Do not make color the sole carrier of authority or fault meaning. Text/state should remain explicit.

A recommended semantic distinction is:

- selected/context only;
- valid/ready but not authorized;
- active/current episode;
- complete/accepted;
- warning/review required;
- fault/invalidated/reconciliation required.

Exact colors/icons are a design-system question; the HMI contract is the semantic distinction.

## Run/Pause/Abort controls

QtVCP provides generic Run, Pause and Abort actions. A press-brake HMI should gate and label them according to the application state:

- **Pause** is available only for a genuinely resumable controller/application state;
- **Abort** immediately invalidates the current press ExecutionEpisode and transitions the application to reconciliation as appropriate;
- **Run** from a selected BendStep after abort must create a fresh authorized episode; row selection alone is not permission to resume;
- generic Run From Line must not be presented as automatic physical-bend recovery without a machine-specific reconciliation workflow.

## Program-row table contract

A bend table should distinguish at least:

```text
BendStep ID
sequence/order
accepted recipe/geometry revision
TargetSet status/generation
trial/accepted/rework state
current selected row
current authorized row/episode (if any)
correction status/scope
```

The selected row and currently authorized row can differ during review/reconciliation. The UI must not silently conflate them.

## Operator correction workflow in the HMI

For first-piece correction:

1. keep current BendStep selected;
2. capture/display measured result and source;
3. show proposed correction separately from nominal program value;
4. require correction scope review where broadening beyond the bend;
5. generate a new TargetSet generation after acceptance;
6. issue a fresh runtime episode for the repeated trial;
7. only advance when the bend is accepted or explicitly skipped/reworked under a defined workflow.

This matches commercial controller workflow evidence without copying proprietary math.

## Diagnostic mode

A diagnostic view should expose provenance and low-level state more explicitly than the production view, including:

- LinuxCNC revision/config revision;
- machine calibration revision;
- raw/current feedback values;
- target generation/episode identity;
- relevant fault latches/history;
- thread/recorder health when diagnosing timing;
- source of each important authorization input.

Production mode can be simpler, but it must not hide stale/invalid state behind a simplified green indicator.

## Failure cases the contract prevents

- operator sees last valid target after calibration change and assumes it is still authorized;
- same numeric target reissue appears complete because prior at-position state remained displayed;
- a selected bend row after abort is mistaken for an active/resumable motion episode;
- Cartesian/master Y appears normal while one physical side is wrong;
- a green network/driver status is interpreted as machine reauthorization;
- a product correction is shown as if it were a machine calibration value;
- a UI action button state is treated as proof of physical completion.

## Claims boundary

This document defines HMI information architecture and ordinary-control semantics. It does not validate ergonomics, touchscreen dimensions, safeguarding/HMI safety requirements, color standards, or a final production interface. Those require user testing and machine/risk-specific design.

## Next work

A useful later implementation test should exercise the HMI against deliberately stale TargetSet generations, same-number fresh episodes, abort/reconcile transitions, one-side feedback invalidation and transport recovery without machine reauthorization. Until executable HMI code exists, another synthetic state fixture would add little information.
