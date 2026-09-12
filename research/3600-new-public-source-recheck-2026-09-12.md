# 3600 press-brake public implementation recheck — 2026-09-12

## Purpose

Dependency-safe evidence recheck while F02 remains externally blocked. This pass asks whether genuinely new public implementation evidence resolves either of the two highest-value open branches: tandem Y1/Y2 implementation detail or measured-angle/sensor-bending implementation detail.

## Search result

A fresh bounded public search on 2026-09-12 found no new inspectable LinuxCNC press-brake implementation that exposes the required tandem or sensor-bending internals.

### Tandem Y1/Y2

The search again surfaced `hardwork-machines/Linuxcnc-Press-Brake`. Its public README still describes the project as trying to develop an open-source press brake and says the next step is to design the controller in LinuxCNC. It does not supply the mature runtime HAL/INI/COMP implementation needed to establish:

- Y1/Y2 scale producers and freshness;
- common command ownership;
- differential-error sign and correction insertion;
- downstream correction limiting/final saturation;
- realtime `addf` order;
- per-side following-error ownership;
- per-side disable/fault/recovery behavior.

Therefore the existing bounded classification remains: **SOURCE UNAVAILABLE for a mature inspectable tandem implementation**. PB-PREP-001 remains INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION.

### Measured-angle / sensor bending

The fresh search did not find an inspectable public LinuxCNC press-brake sensor-bending implementation exposing:

- measurement generation/freshness;
- bend-cycle phase qualification;
- correction insertion point;
- Y1/Y2 interaction;
- correction/output saturation;
- stale/fault handling;
- abort/restart/reconciliation behavior.

Therefore the existing classification remains **SOURCE UNAVAILABLE / UNKNOWN**. Do not synthesize an angle PID merely to create activity.

## Negative controls / irrelevant hits

General LinuxCNC machine configuration repositories and upstream examples were intentionally not promoted as press-brake evidence. They can establish generic HAL mechanisms but cannot resolve the press-specific tandem/sensor ownership questions above.

## Information-gain conclusion

No new public implementation evidence crossed the threshold required to reopen either branch. The deliberate 3600 information-gain stop remains justified. Resume these branches only when a concrete new implementation, attachment, repository, or machine-specific source becomes available.

## Next checkpoint

1. Re-check the exact F02 transfer evaluation first.
2. If F02 remains externally blocked, do not create another synthetic tandem or angle fixture.
3. Only reopen 3600 generic preparation for genuinely new source that resolves a listed implementation ambiguity.
