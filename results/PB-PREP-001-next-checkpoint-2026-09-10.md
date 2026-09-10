# PB-PREP-001 next-work checkpoint

State at close of this study session:

- P0/P1 preflight is independently audited and accepted as harness validation only.
- P2-P7 has **not** executed and no A/B/C ranking exists.
- Remaining behavioral constants and analysis windows are frozen in `experiments/PB-PREP-001-behavioral-execution-freeze.md` before comparative observation.
- F02 remains blocked on genuinely information-separated fresh-AI evaluation of S02/E20/X01/X02. PB-PREP-001 does not bypass that dependency.
- Accepted preflight run/job identity is known, but its compute duration is not added until an exact job start/completion interval is available.

## Exact next action

Implement a new P2-P7 lab runner by extending the accepted revision-1 fixture without mutating the accepted P0/P1 result. The new runner must expose atomic phase/plant-parameter/ferror/final-saturation witnesses required by the parent Gates A-J, execute A/B/C from clean resets using the already-frozen constants, and retain raw traces plus analyzer source. Before accepting behavior, adversarially verify disturbance isolation, independent Y feedback, zero producer overruns/payload gaps, downstream-vs-PID saturation observability for B, and P7 first-cycle disable behavior. If P6 does not exercise B's downstream-only saturation discriminator, classify the frozen experiment INCONCLUSIVE rather than changing the disturbance.
