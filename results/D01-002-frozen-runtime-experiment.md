# D01-002 — Frozen runtime experiment: hidden duplicate-joint divergence

Status: **FROZEN BEFORE IMPLEMENTATION**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413` (`v2.9.4-743-g8bf4605ae8`).

## Question

Can a real LinuxCNC duplicated-coordinate configuration report apparently correct Cartesian axis feedback while one of the duplicated joints has independently diverged, and does LinuxCNC still retain joint-level following-error authority capable of revoking motion?

## Competing interpretations

**Interpretation A — axis feedback authenticates the tandem geometry.** If Cartesian Y is correct, the two Y joints must be agreeing closely enough to treat the coupled geometry as aligned.

**Interpretation B — Cartesian Y is a kinematic projection with asymmetric feedback authority.** Both Y joints receive the duplicated world command, but Cartesian Y can follow only the selected principal mapped joint; an isolated duplicate-joint error can therefore be hidden in the world coordinate until joint-level fault handling acts.

The experiment is discriminating only if the same runtime captures a period where Cartesian Y remains principal-looking while the duplicate-joint feedback is measurably wrong.

## Fixture requirements

Use real pinned LinuxCNC `motmod` plus `trivkins coordinates=XYY kinstype=BOTH` (or the smallest equivalent duplicated-Y configuration). Do not replace motion or trivkins with a source-algorithm surrogate.

The simulated plant must provide independent feedback paths for the two Y joints. Baseline feedback is command loopback. A test-only realtime fault injector adds a controlled offset to **only the duplicate Y feedback path**. The principal Y feedback path remains unmodified.

Set deterministic per-joint following-error limits so the experiment has two intentional mismatch regimes:

- `OFFSET_LOW`: clearly nonzero but strictly below the duplicate joint's instantaneous following-error limit after settling;
- `OFFSET_HIGH`: clearly above the duplicate joint's permitted following-error limit.

All scored causal observations come from one realtime sampler stream. The sampler executes after the relevant motion-controller processing and after any phase/fault-injector function needed to make the commanded experiment state observable. Producer-side recorder health is retained.

## Frozen phases

A phase value must become observable **before** the mutation it labels; the C06 phase-label race must not recur.

- **P0 BASELINE_DISABLED** — LinuxCNC ready, motion disabled, both Y feedback paths aligned, offset zero.
- **P1 ENABLED_ALIGNED** — machine enabled; duplicated Y command/feedback paths agree.
- **P2 COMMANDED_AND_SETTLED** — a nonzero Y world command has settled; joint-1 and joint-2 commands agree within tolerance and both feedback paths track.
- **P3 LOW_OFFSET_ARMED** — phase published before applying `OFFSET_LOW` to duplicate Y feedback only.
- **P4 LOW_OFFSET_ACTIVE** — duplicate feedback differs from principal feedback by the frozen low offset; Cartesian Y remains principal-looking; duplicate ferror is nonzero but below threshold; motion remains enabled.
- **P5 HIGH_OFFSET_ARMED** — phase published before changing the duplicate-only offset to `OFFSET_HIGH`.
- **P6 HIGH_OFFSET_ACTIVE** — duplicate ferror exceeds its limit and duplicate following-error state asserts; principal joint remains non-faulted; Cartesian Y remains attributable to principal feedback; motion enable is revoked within the frozen bounded observation window.
- **P7 OFFSET_CLEARED** — offset returns to zero and joint feedback agreement is restored. Clearing the physical/simulated cause alone must not be scored as automatic successful reauthorization.
- **P8 FRESH_REENABLE** — a fresh explicit machine-enable action is issued only after aligned feedback is restored; achieved enable may return if LinuxCNC prerequisites permit it.

## Frozen hypotheses

H1. Under world-coordinate motion, both Y-mapped joints receive the same position command to numeric tolerance.

H2. During duplicate-only feedback divergence, Cartesian Y remains equal/near the principal mapped Y feedback and does not become an agreement check or average of both Y joints.

H3. In P4, duplicate-joint divergence can coexist with apparently correct Cartesian Y and continued motion enable when divergence remains below the joint ferror threshold.

H4. In P6, the duplicate joint independently crosses its ferror threshold and can revoke global motion enable even though Cartesian Y remains principal-looking.

H5. Clearing the duplicate-only offset does not itself prove coupled geometry is physically safe or authorize automatic restart.

## Frozen gates A–J

These gates may not be weakened after seeing runtime output. A harness-invalid run does not score behavioral gates.

**Gate A — provenance and topology.** Retained evidence identifies the exact pinned LinuxCNC SHA, shows real `motmod` and real `trivkins` with a duplicated Y mapping, and demonstrates independent principal/duplicate feedback paths. Production LinuxCNC source is unchanged except any explicitly retained test-only fixture patch required to build/run the lab.

**Gate B — recorder validity.** The scored stream is realtime and atomic for the decisive signals. `sampler.0.overruns == 0`; collector stderr is empty/nonfatal; sample indices are monotonic; stream depth is sufficient; producer-side recorder health is retained. Consumer tag continuity alone is not accepted as a no-loss oracle.

**Gate C — phase-before-mutation ordering.** Retained thread/function ordering and samples prove P3 is observable before low-offset mutation and P5 before high-offset mutation. No decisive gate depends on sequential `halcmd getp` ordering.

**Gate D — duplicated command.** In P2/P4/P6, principal-Y and duplicate-Y joint position commands agree within `1e-6` machine units (or a tighter explicitly retained numeric tolerance).

**Gate E — hidden low-level divergence.** At least one valid P4 sample has `abs(duplicate_fb - principal_fb) >= 0.5 * abs(OFFSET_LOW)`, duplicate ferror nonzero, duplicate following-error fault clear, and motion enabled.

**Gate F — Cartesian authority discriminator.** In the same P4 evidence window, `abs(cartesian_y - principal_y_fb) <= 1e-6` while `abs(cartesian_y - duplicate_y_fb) >= 0.5 * abs(OFFSET_LOW)`. This rejects Interpretation A for the pinned fixture.

**Gate G — duplicate-only threshold crossing.** In P6, duplicate-joint absolute following error exceeds its applicable limit and duplicate following-error fault asserts while the principal Y joint does not assert following error.

**Gate H — global consequence.** Following the P6 threshold crossing, `motion.motion-enabled` becomes false within at most 3 servo samples. The run must retain the decisive transition rather than only an asynchronous final state.

**Gate I — cause clear is not authority proof.** P7 restores principal/duplicate feedback agreement but does not claim physical squareness or functional safety. If motion remains disabled until P8, retain that evidence; if LinuxCNC behavior differs, record it without weakening Gates A–H and treat restart semantics as a correction/secondary finding rather than falsifying the core experiment.

**Gate J — evidence completeness.** Retain: exact job script; LinuxCNC config/HAL; any test component source; source/build patch; startup stdout/stderr; HAL topology and thread order; full atomic sample stream; recorder-health output; gate-analysis output; and runtime metadata.

## Numeric preflight rule

Before an authoritative run, a **non-authoritative preflight** must demonstrate all of the following without scoring Gates A–J:

1. the real duplicated-coordinate fixture starts headlessly;
2. both Y joint commands can be observed;
3. the duplicate feedback path can be offset independently;
4. low offset remains below ferror threshold for a bounded dwell;
5. high offset produces duplicate-only following error and global disable;
6. Cartesian Y remains measurable in the same atomic stream;
7. phase/order and recorder-health predicates are valid.

If numeric thresholds or a pin name must change because the preflight shows the planned value/name is invalid, record the reason and revise this document **before** the first authoritative run. Behavioral hypotheses and conceptual gates may not be tuned to fit observed results.

## Evidence boundary

Passing this experiment would establish LinuxCNC software behavior at the pinned revision. It would not establish press-brake/tandem-axis mechanical stability, encoder mounting integrity, hydraulic force balance, safe stopping distance, STO performance, or any safety integrity level/category.