# X01-002 — Sampler retention integrity, redesigned loss oracle

Status: **FROZEN BEFORE FIRST RUN**  
Course level: **2000**  
LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Why this is a new experiment lineage

X01-001 reached its three-attempt ceiling. Attempt 3 successfully exercised the fixture and falsified one frozen oracle: FIFO-full producer losses did not force gaps in the implicit `halsampler -t` sequence. The retained deterministic payload counter did expose missing producer records while `sampler.0.overruns` accumulated. Per the three-attempt rule this is a material model redesign, not attempt 4.

## Objective

Establish a recorder-integrity contract that distinguishes:

1. ordering of successfully retained HAL-stream records;
2. missing producer records caused by sampler FIFO saturation;
3. continued execution of the deterministic realtime source while recorder records are lost; and
4. measured recorder execution cost without claiming functional-safety or deadline guarantees from a cloud runner.

## Frozen fixture

Use the same pinned standalone 1 ms realtime fixture and deterministic source family as X01-001 attempt 3. `x01_source` executes before `sampler.0`. Retain a monotonic deterministic payload cycle counter plus deterministic companion fields and marker. Retain exact source revision, experiment commit, HAL topology, thread order, sampler configuration, raw `halsampler -t` traces, producer health (`overruns`, `curr-depth`, `full`), process statuses and timing evidence.

## Frozen phases

### P0 — provenance

Prove pinned source revision, 1 ms period, source-before-sampler function order, sampler depth/configuration and field mapping.

### P1 — normally drained baseline

Retain at least 2,000 records while draining concurrently. Require contiguous successful-stream `-t` tags, contiguous deterministic payload cycle counter, deterministic same-row relationships and producer overruns exactly zero.

### P2 — bounded stop then drain

Enable sampling without a reader long enough to accumulate a nonempty FIFO without saturation, disable sampling, record FIFO depth and source counter, then boundedly drain exactly the recorded depth. Require clean bounded-reader exit, zero producer overruns and terminal retained payload counter at or within the predeclared observation tolerance of the stop boundary.

Frozen stop-boundary tolerance: observed source counter minus last retained payload counter must be `0..3` cycles, preserving X01-001's scheduler/userspace observation allowance.

### P3 — forced FIFO saturation with payload loss oracle

Use FIFO depth 64. Withhold userspace draining for 250 ms while the realtime source and sampler continue, then record producer health and start a bounded 220-record reader while production continues. After the reader completes, disable sampling and record health again.

Require all of the following:

- pre-drain `full=TRUE`;
- pre-drain `sampler.0.overruns > 0`;
- post-drain overruns >= pre-drain overruns;
- deterministic source counter advances from the pre-drain to post-drain observation;
- retained deterministic payload counter contains at least one forward discontinuity greater than one cycle, proving missing producer records in the recorder;
- successful-stream `-t` tags may remain contiguous and are **not** a required loss oracle;
- analysis must not call recorder loss proof of a source/control-loop cycle skip.

### P4 — recorder load comparison

Repeat the narrow (`ffffb`) and wide (`fffffffffffffffb`) configurations with 2,000 retained records each, zero producer overruns, and retained `servo-thread.time` / `servo-thread.tmax` evidence. Require only quantitative evidence. No fixed claim that wide must always exceed narrow on every instantaneous timing observation; compare retained values and state cloud-runner limitations.

### P5 — bounded sustained publication proof

After P0–P4 preflight validity, an authoritative run must include a bounded longer capture chosen before launch, with raw trace, provenance and recorder-health files published together. The duration need only demonstrate sustained drain/publication integrity within compute budget.

## Frozen Gates A–J

- **A — provenance:** exact LinuxCNC revision, experiment commit, topology, 1 ms thread period/order and sampler mapping retained.
- **B — baseline retained ordering:** P1 `-t` tags and deterministic payload cycles are each contiguous across the accepted interval.
- **C — baseline producer health:** P1 producer sampler overruns exactly zero.
- **D — atomic deterministic integrity:** P1 companion fields obey their deterministic relation to the payload cycle counter with no torn-row contradiction.
- **E — stop/drain terminal retention:** P2 bounded drain count equals frozen remaining depth, exits cleanly, has zero producer overruns, and reaches the frozen `0..3`-cycle terminal tolerance.
- **F — forced recorder-loss detection:** P3 has FIFO-full + nonzero producer overruns + at least one deterministic payload-cycle discontinuity >1.
- **G — recorder/control distinction:** P3 source counter advances across the loss interval and the analysis does not infer a source/control-loop skip from recorder loss.
- **H — perturbation measurement:** P4 retains quantitative narrow and wide thread timing evidence with zero producer overruns in both timing captures.
- **I — sequence semantics bounded:** analysis explicitly treats `-t` tags as ordering of successfully retained stream records at this pinned revision and does not require their discontinuity to prove producer-record loss.
- **J — durable evidence:** raw traces, phase health, topology/provenance, process statuses, scoring output and exact experiment lineage are retained.

## Preflight / authoritative policy

First X01-002 execution is non-authoritative. Correct only defects that prevent this frozen redesigned model from being exercised. Do not change the P3 starvation duration, FIFO depth, bounded read count, terminal tolerance or Gates A–J after seeing a run merely to obtain a pass. A valid preflight permits a separate unchanged authoritative run.

## Acceptance consequence

Passing authoritative X01-002 supplies the independent recorder-integrity evidence required to finish X01's failure analysis/exam/handoff and unblock X02. It does not by itself prove that diagnostic recording is non-perturbing, deadline-safe, safety-rated, or representative of physical hardware timing.
