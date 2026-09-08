# T04 source note — GUI status freshness oracle

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Finding

`common.hal_glib.GStat` does not merely cache status; it exposes the adapter's observation-health state through:

```python
def is_status_valid(self):
    return self._status_active
```

Pinned `GStat.update()` sets `_status_active=True` only after `self.stat.poll()` succeeds. If polling raises, it sets `_status_active=False`, emits only the generic `periodic` signal and returns without merging a new controller snapshot.

This means a QtVCP/custom-GStat integration has an explicit freshness/validity signal available in addition to the retained values themselves.

## Engineering consequence

A widget or custom handler that continues presenting a retained controller-derived value while `STATUS.is_status_valid()` is false must not label the retained value as current without an additional freshness policy. The stale value can still be useful as "last known" state, but **last known** and **current** are different claims.

Conversely, `is_status_valid()==True` means the status adapter's latest poll path succeeded. It does not prove:

- every field came from the same physical source or timestamp;
- field-device/encoder data is fresh below LinuxCNC;
- physical actuation occurred;
- the machine is in a safety-rated state.

`GStat.merge()` combines ordinary `linuxcnc.stat` fields with selected direct HAL reads, so validity remains an observation-path concept rather than universal device provenance.

## T04-021 implication

Frozen T04-021 deliberately grades `_status_active` alongside cached/presented state and an independent controller observer. On acceptance, the durable UI recommendation should be to make freshness visible or fail-safe in custom interfaces where stale presentation could mislead an operator, using `is_status_valid()` or an equivalent explicit freshness mechanism rather than assuming periodic callbacks imply fresh data.

## Source basis

- `lib/python/common/hal_glib.py` — `GStat.update()`, `merge()`, `is_status_valid()`
- `lib/python/qtvcp/core.py` — QtVCP `Status(GStat)` singleton
