# S07 — HAL CLI oracle semantics for lifecycle tests

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Why this exists

S07-017 attempt 2 exposed a general laboratory-design trap: a command can execute successfully without proving that the queried HAL object exists. Lifecycle tests must distinguish **command validity** from **object existence**.

## `halcmd show` is a reporting command, not an existence predicate

At the pinned revision, `src/hal/utils/halcmd_commands.cc::do_show_cmd()` dispatches recognized show types to print helpers such as `print_pin_info(...)`. Once the show type itself is recognized, the function returns `0`. No-match patterns are therefore not represented by a non-zero command result.

Consequence:

```sh
halcmd show pin joint.0.homed
```

may exit successfully even when the pattern produces no matching pin row. Exit status establishes that `show pin` was a valid command, not that `joint.0.homed` exists.

## `halcmd getp` is appropriate for an exact named-value existence gate

Pinned `do_getp_cmd()` constructs an exact named query and calls `hal_get_p()`. It prints the value only when the lookup succeeds and propagates lookup failure through its non-success path. For a lifecycle experiment that asks whether one exact pin still exists, `getp` therefore supplies the property the harness actually needs.

Use:

```sh
if halcmd getp joint.0.homed >/dev/null 2>&1; then
    echo 'exact pin still exists'
else
    echo 'exact pin is absent or HAL query is unavailable'
fi
```

The surrounding experiment must still distinguish pin absence from a broader HAL-query failure when that distinction matters. In S07-017 it is combined with launcher and service-port disappearance and is used only as one member of a multi-observable teardown barrier.

## Transferable test-design rule

Never use a CLI command's zero exit status as an existence oracle until the implementation or documentation establishes that **no match** is represented by failure. Reporting/listing commands often return success for an empty result set.

For lifecycle evidence, prefer the narrowest independent oracle that directly tests the predeclared property:

- exact named-value lookup for exact-object existence;
- process identity for process lifetime;
- socket reachability for service lifetime;
- separate physical/device evidence for physical truth.

Do not substitute one of these for another.

## Evidence classification

- `do_show_cmd()` recognized-type success behavior: **SOURCE-CONFIRMED** at the pinned revision.
- `do_getp_cmd()` exact lookup through `hal_get_p()`: **SOURCE-CONFIRMED** at the pinned revision.
- Attempt-2 false teardown conclusion caused by `show pin` status: **TEST-CONFIRMED harness failure**, not LinuxCNC state-persistence evidence.
