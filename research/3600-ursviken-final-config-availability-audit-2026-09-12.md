# 3600 Ursviken final-config availability audit

Date: 2026-09-12

## Purpose

Resolve whether the previously promised final Ursviken/Pullmax tandem Y1/Y2 configuration has become publicly inspectable. This is the highest-value open evidence item in the current 3600 tandem checkpoint because the community chronology already reports successful bending but does not expose the exact HAL execution graph.

## Evidence searched

LinuxCNC forum thread: **Ursviken Pullmax Optima 130 press brake retrofit with 4 axis backgage**, NWE, all four currently exposed pages, freshly crawled on 2026-09-12.

Important chronology:

- 2025-12-09: NWE attached a then-current “complete config,” explicitly saying most working content was joint 6 and that more was to come. This predates the later Y1/Y2 tandem implementation and therefore is not the promised final tandem configuration.
- 2025-12-18: NWE wrote that once a complete working config existed it would be attached to the first post.
- 2026-02-10 to 2026-02-13: the architecture was still evolving. NWE split press-state responsibility from a machine-specific `pullmax-optima` hardware interface concept and described an intended standard command boundary (`y_cmd_pos`, `y_cmd_vel`, `y_cmd_tonnage`, pedal status, and `motion_type_cmd`). This is design discussion, not inspectable final implementation.
- 2026-02-13: field test used per-side position -> velocity PID cascade. The report identifies signal roles but does not expose the final HAL scheduling/correction graph.
- 2026-07-20: NWE reported improved control with the hydraulic flow divider emulated electronically in LinuxCNC HAL.
- 2026-07-22: NWE reported a successful 90-degree bend and described two position PIDs plus a synchronization PID (`command=0`, feedback from Y1-Y2, slowing the leading side), then explicitly said: **“Some more loose ends then I will share the config.”**
- The currently exposed thread ends at that 2026-07-22 post. No later post or first-post edit contains the promised final tandem configuration. The first post still shows its last edit as 2025-12-18.

## Evidence classification

### COMMUNITY-REPORTED

The machine reportedly bent a 1.5 x 10 x 3/16 in steel sample to 90 degrees using two position PIDs and a differential synchronization PID. The sync PID is reported to receive `command=0`, feedback `Y1-Y2`, and to act by slowing whichever side is ahead.

### SOURCE UNAVAILABLE / UNKNOWN

The public thread still does **not** expose enough final implementation source to reconstruct:

`hardware read -> Y1/Y2 feedback -> differential -> side PIDs -> sync PID -> correction insertion -> downstream limiting/mapping -> hardware write`

Specifically still unknown:

- exact final `addf` order;
- exact source/units/freshness semantics of all Y1/Y2 feedback used by the final loops;
- sync correction sign convention and selection logic;
- where the sync correction is inserted relative to the per-side position loops;
- whether the earlier inner velocity PID cascade remained in the July configuration;
- downstream command clipping/saturation and whether sync correction can be lost behind later limits;
- valve dither/deadband/nonlinearity compensation in the final configuration;
- press-cycle/process-state gating of each controller;
- per-side following-error ownership;
- encoder disagreement/stale-feedback handling;
- fault, disable, restart and recovery semantics.

## Source-availability conclusion

The final tandem configuration is **not publicly inspectable in the currently exposed thread as of this audit**. This is stronger than a generic search miss: all four currently exposed pages were inspected, the thread terminates at the July 22 promise to share the configuration later, and the first post was not subsequently updated with that final config.

The old December “complete config” must not be mistaken for the final tandem implementation. It was explicitly an early snapshot centered on joint 6 and predates the later Y1/Y2 control architecture.

## Adversarial boundary check

1. **Can the July field report prove the exact correction insertion point?** No.
2. **Can the February cascade be assumed to still exist in the July successful configuration?** No; chronology shows design evolution but no final source.
3. **Can the December attached config be used as the final tandem config?** No; it predates the tandem implementation and was explicitly incomplete for the later machine state.
4. **Does a successful physical bend prove all fault/recovery semantics?** No.
5. **Does absence of a later forum post prove the author never created the config?** No; it proves only that it is not publicly inspectable in the currently exposed thread.
6. **Is another synthetic `addf` or PID fixture justified by this result?** No; generic ordering/controller behavior is already source/documentation-confirmed. The missing information is machine implementation evidence.

Result: **6/6 boundary checks passed.**

## Curriculum effect

- Preserve PB-PREP-001 as **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**.
- Preserve the July tandem topology as **COMMUNITY-REPORTED FIELD SUCCESS WITH DISCLOSED HIGH-LEVEL TOPOLOGY**.
- Preserve the exact final implementation graph as **SOURCE UNAVAILABLE / UNKNOWN**.
- Do not spend lab compute on another generic tandem/cascade simulation to compensate for absent machine source.
- Reopen this branch only if NWE publishes the promised final config/component, an attachment becomes directly inspectable, or an equivalent real implementation exposes the missing execution graph and recovery semantics.
