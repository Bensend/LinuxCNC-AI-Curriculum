# T05 research — custom operator interface patterns

Status: **RESEARCH**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

T05 builds on T03 command/result semantics and T04 GUI freshness by asking how to design a custom operator interface that preserves those boundaries deliberately rather than accidentally depending on one stock GUI implementation.

The 1000-level target is not to catalogue every LinuxCNC UI toolkit. It is to identify reusable patterns for command ownership, status freshness, HAL integration, operator diagnostics, lifecycle, interlocks and failure handling.

## Current documentation baseline

Current LinuxCNC documentation presents multiple legitimate interface mechanisms:

- **QtVCP** — custom CNC screens/panels composed from a Qt Designer `.ui` file plus optional Python handler logic and prebuilt LinuxCNC widgets/actions;
- **HALUI** — a HAL-based user interface that converts HAL pins into NML commands and exposes traditional operator-control functionality through HAL;
- **Python UI interface** — direct `linuxcnc.command()`, `linuxcnc.stat()` and error-channel access for custom applications;
- stock/custom GUIs such as AXIS, GMOCCAPY, QtDragon and others which can be extended or used as references.

These mechanisms are not interchangeable evidence domains. A robust custom interface should decide explicitly which mechanism owns each operator action and indication.

## Inherited non-negotiable boundaries

From T03:

```text
command sent/echoed != semantic DONE != physical action != safe state
```

From T04:

```text
widget state != fresh controller observation
fresh controller observation != physical/safety truth
```

T05 should prefer patterns that make these distinctions visible in the architecture.

## Initial pattern taxonomy

### Pattern 1 — command gateway with one owner

Route operator commands through one clearly defined application/gateway when practical. Preserve command serial/result ownership and avoid letting unrelated widgets/background helpers independently race command traffic without a correlation policy.

### Pattern 2 — explicit freshness contract

Every controller-derived display that matters to operator decisions should have a freshness/validity rule. QtVCP's `Status.is_status_valid()` is one available mechanism; custom clients can use last-successful-poll timestamps/timeouts. Label retained values as last-known when appropriate.

### Pattern 3 — advisory widget gating plus controller enforcement

Use GUI enable/disable state to guide the operator, but never rely on widget state as the only enforcement of machine preconditions. Authoritative controller/HAL/safety interlocks must remain below the presentation layer as appropriate.

### Pattern 4 — diagnostic channel separated from result channel

Show error/operator messages, but grade command success from the matching semantic result rather than popup presence/absence. Design one deliberate error-channel consumer or an explicit fan-out mechanism rather than accidental competing consumers.

### Pattern 5 — HAL for machine-oriented signals, not presentation shortcuts

HALUI and GUI HAL pins are useful for physical buttons, selector switches, lamps and machine-state integration. Trace pin direction, ownership and signal source. Do not convert a convenient GUI/HAL indicator into a safety claim without a separate safety architecture.

### Pattern 6 — fail-defined UI lifecycle

Define startup, controller-not-ready, reconnect/status-invalid and shutdown behavior. A custom screen should not silently boot into apparently authoritative default values or keep stale controls active after losing its observation path unless that is an intentional, documented policy.

## Candidate failure paths to study

1. **startup default-state hazard** — UI appears usable before first valid controller snapshot;
2. **multiple command producers** — local UI and external automation race command ownership/result correlation;
3. **physical button through HALUI versus GUI callback** — compare ordering, ownership and observable status boundaries;
4. **error-channel fan-out** — one consumer drains diagnostics another interface expected to show;
5. **status-invalid control policy** — custom screen continues enabling actions after loss of status freshness.

T05 should choose one representative architecture pattern and one negative/fault case for its first frozen experiment rather than retesting all of T03/T04.

## First source-analysis checkpoint

Trace these pinned implementation paths next:

- QtVCP handler loading/lifecycle and the `Action`/`Status` singleton pattern;
- HALUI input-pin -> command dispatch and status -> output-pin path;
- one minimal direct-Python UI example demonstrating explicit command/status/error ownership;
- startup/reconnect/failure behavior for each representative path.

Then build a custom-OI responsibility matrix with columns:

```text
operator intent | local UI owner | command transport | semantic result oracle |
status source | freshness rule | HAL/physical source | diagnostic owner | safe-state owner
```

## Likely first experiment direction

Prefer a **startup/freshness interlock** experiment over another stale-runtime test: create a minimal custom status/action layer that refuses to enable an operator action until at least one valid status poll establishes the required controller state, then contrast it with a deliberately unsafe default-enabled variant. The experiment must still let Task be the final semantic authority and must not claim GUI disablement is a safety function.

An alternative is a HALUI-versus-Python command ownership experiment if source analysis reveals a more important integration ambiguity.

## Sources

Current official documentation:

- QtVCP: https://linuxcnc.org/docs/stable/html/gui/qtvcp.html
- HALUI: https://linuxcnc.org/docs/html/gui/halui.html
- LinuxCNC documentation index / UI programming references: https://linuxcnc.org/docs/devel/html/

Pinned source paths to inspect next:

- `lib/python/qtvcp/`
- `src/emc/usr_intf/halui.cc`
- `src/emc/usr_intf/axis/scripts/` and minimal Python UI examples as comparison points

## Exact next checkpoint

1. Trace pinned HALUI input pin -> NML command and status -> HAL output behavior.
2. Trace QtVCP handler lifecycle/startup ordering relative to first valid `Status` poll and widget initialization.
3. Build the custom-OI responsibility matrix.
4. Search community reports for startup/reconnect/multi-producer custom-UI failures and classify them as hypothesis evidence.
5. Freeze T05's first experiment only after the above paths identify the highest-value fault case.