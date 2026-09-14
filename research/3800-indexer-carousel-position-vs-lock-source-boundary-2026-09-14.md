# 3800 — Indexer position versus mechanical lock: `carousel.comp` source boundary

Date: 2026-09-14
LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: SOURCE-CONFIRMED

## Purpose

Establish what LinuxCNC's native `carousel` component can legitimately contribute to a production indexer, and what must remain outside it.

## Source result

Pinned `src/hal/components/carousel.comp` supports multiple position encodings (`gray`, `binary`, `bcd`, `single`, `index`, `edge`, `counts`), unidirectional/bidirectional motion, homing/index search, final slow alignment and ratchet/reverse-pulse behavior.

Its documented completion semantics are explicit:

- while enabled it drives toward the requested pocket/station;
- when the requested position is reached it stops motor outputs;
- `active` goes false;
- `ready` goes true;
- `ready` is documented as **carousel in-position**.

The component can also provide a reverse pulse or hold duty cycle for mechanisms that mechanically settle against a stop.

## Critical 3800 boundary

`carousel.ready` is not a generic mechanical-lock proof.

The component has no universal input meaning:

- clamp closed;
- lock pin engaged;
- hydraulic/pneumatic clamp pressure valid;
- fixture seated;
- workpiece retained.

Therefore a production dial/index table requiring a separate unlock/lock mechanism needs an outer state machine such as:

`safe-to-index`
→ `unlock command`
→ `unlock proof`
→ `carousel enable / requested station`
→ `carousel.ready`
→ `lock command`
→ `lock proof`
→ `process authorization`.

If the mechanism's physical design inherently locks merely by the carousel motor reversing/holding against a stop, that can be a valid machine-specific design, but it must be established from that mechanism. It must not be generalized from `ready` alone.

## Other useful source boundaries

- `strobe` can qualify encoded position feedback validity for some encoding modes.
- parity checking is available for coded position feedback.
- `debounce` allows position stabilization across thread cycles.
- homing behavior differs by encoding mode.
- setting `enable` low does not halt an initial homing move, by design.
- jog inputs are explicitly documented as needing debounce and likely an idle-machine interlock.

These features improve station-position acquisition; they still do not create a general fixture/lock/workpiece readiness contract.

## Adversarial review

1. Does `carousel.ready=1` prove an external clamp is locked? **No.**
2. Does encoded station feedback prove a fixture/workpiece is usable? **No.**
3. Can `rev-pulse` be a valid locking mechanism on some hardware? **Yes, but only when the physical mechanism actually locks that way.**
4. Does `strobe` equal lock proof? **No; it qualifies encoded position feedback.**
5. Does a position debounce replace mechanical settling/lock proof? **No.**
6. Is the component useful outside toolchangers? **Its position/indexing mechanism is transferable, but the outer process contract remains machine-specific.**
7. Is this enough to freeze a full production-indexer playbook? **No; one real non-tool indexer with lock proof is still preferred.**

Result: **7/7 boundaries preserved.**

## Next evidence

Find one real index table / rotary transfer / station indexer with explicit unlock/lock sensing. Compare it against this source boundary before freezing 3800-I1. If no such public implementation is available, preserve the gap rather than equating `ready` with lock state.
