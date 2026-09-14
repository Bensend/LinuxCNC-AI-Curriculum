# 3200 — Constant surface speed (G96) and X-origin control boundary

Date: 2026-09-14
LinuxCNC source revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`

## Purpose

Establish a source-grounded lathe CSS boundary so later 3200 work does not treat G96 as merely a spindle RPM mode. CSS couples spindle command to machine/tool radial geometry and therefore crosses interpreter, canonical spindle state, X-coordinate/tool-offset semantics, Motion readiness, and the physical spindle drive.

## Documentation contract

Official LinuxCNC lathe documentation states that constant surface speed computes spindle RPM from surface speed and the tool's radial distance from the axis of rotation. It specifically depends on the machine X origin and tool X offset, so the reference geometry of X=0 at spindle centerline is not merely cosmetic DRO setup.

G96 can use D as a maximum RPM cap. G97 returns to constant-RPM mode.

Classification: `DOC-CONFIRMED`.

## Interpreter state

Pinned `interp_convert.cc` stores per-spindle mode as either `SPINDLE_MODE::CONSTANT_RPM` or `SPINDLE_MODE::CONSTANT_SURFACE`. G97 clears the CSS maximum and queues spindle mode 0; G96 records constant-surface mode and accepts the D-word maximum where supplied.

Pinned `interp_internal.hh` keeps per-spindle speed, spindle mode and `css_maximum`, so CSS is explicitly a spindle-selection-sensitive interpreter state rather than a global display option.

Classification: `SOURCE-CONFIRMED`.

## Geometry/capability check

Pinned `interp_check.cc` contains a CSS speed calculation used by spindle-synchronized capability checks. For a move whose minimum radius is nonzero it computes an RPM proportional to:

`surface_speed / min_radius`

with inch/mm unit conversion and applies `css_maximum` as a cap when positive. The source separately handles the case where the move reaches the center of rotation, where radius-based RPM would diverge and only configured caps can bound it.

This reinforces a central engineering fact: **CSS has a mathematical singularity at zero radius unless a finite machine/program limit bounds commanded spindle speed.**

Classification: `SOURCE-CONFIRMED`.

## Canonical/task boundary

`emccanon.cc` carries CSS state in its canonical spindle structure (`css_maximum`, `css_factor`) and recomputes/updates spindle speed as motion geometry changes. CSS therefore is not implemented solely by sending one fixed RPM when G96 is parsed; the spindle command can evolve with X motion.

The spindle status/NML structures also retain CSS-related state separately from ordinary speed and override.

Classification: `SOURCE-CONFIRMED`.

## Readiness boundary

Official Motion documentation says `spindle.N.at-speed` can gate the transition from rapid to feed when CSS is active. That matters because a large X move may materially change the requested RPM. The tool can arrive at a new radius before the spindle has physically settled to the corresponding surface-speed command.

Thus a robust CSS path is:

`programmed surface speed + D cap + active spindle + X machine/tool geometry`
`-> computed/capped RPM command`
`-> machine-specific drive conversion`
`-> physical spindle response`
`-> readiness witness (spindle.N.at-speed)`
`-> cutting-feed authorization`

Again, command and readiness are different surfaces.

## Geometry provenance

CSS depends on more than current displayed X:

- machine X origin relative to spindle centerline;
- tool X offset;
- radius/diameter interpretation in the program/UI;
- current commanded/trajectory X location;
- spindle selection;
- surface-speed units and programmed maximum.

A machine whose X home/offset convention does not preserve a trustworthy spindle-center datum can have apparently functional motion while commanding incorrect CSS RPM.

## Community failure reconciliation

The previously inspected 2025 LinuxCNC forum case where G96 worked under M3 but stalled under M4 was traced to an incorrectly constructed at-speed predicate using an absolute spindle-command quantity. Changing to signed semantics fixed CCW CSS operation.

That case is valuable because the CSS calculation itself was not the failure. The defect was at the downstream readiness boundary.

Classification: `COMMUNITY-REPORTED`, reconciled with documented `spindle.N.at-speed` gating.

## Failure cases

1. **X center datum wrong** — RPM calculation is systematically wrong even if VFD control and encoder feedback are perfect.
2. **No finite maximum near X=0** — ideal CSS demand tends toward unbounded RPM; physical/configuration limits become essential.
3. **Tool X offset wrong** — surface-speed computation uses the wrong effective radius.
4. **Readiness predicate loses sign/direction semantics** — reverse spindle operation can remain blocked or be falsely authorized.
5. **Drive command scaling wrong** — correct CSS RPM calculation does not guarantee correct physical spindle RPM.
6. **At-speed forced true on a slow-changing VFD spindle** — rapid-to-feed may occur before spindle settling after a large radius change.
7. **Diameter/radius mental-model mixup** — program/tool geometry can be interpreted inconsistently even though LinuxCNC internally maintains the required radial relationship.

## Adversarial review

1. Is G96 just a spindle mode independent of axis geometry? **No.**
2. Is machine X=0 at spindle center merely a display convention? **No; it affects CSS geometry.**
3. Does a D-word maximum replace hardware/configured spindle limits? **No; it is one command-level cap, not a safety-rated or universal physical limit.**
4. Does correct calculated RPM prove the spindle is ready to cut? **No.**
5. Can the CSS calculation become singular near centerline? **Yes, absent finite limiting.**
6. Can an at-speed logic defect make CSS appear broken even when the RPM formula is correct? **Yes.**
7. Does this pass prove every lathe's VFD/servo command mapping? **No; drive conversion is machine-specific.**

Result: **7/7 PASS** for bounded claims.

## Lab decision / next work

No synthetic CSS lab was launched. Source, official docs and an independent field failure already establish the ownership boundary. A useful future experiment would deliberately perturb X datum/tool offset and independently perturb at-speed to verify command-vs-authorization effects only after a frozen prediction is written.

Continue 3200 with the iocontrol/turret abort-recovery trace and TP spindle-sync pause/index failure semantics before deciding whether such a lab adds evidence beyond existing source/tests.
