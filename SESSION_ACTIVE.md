START 2026-09-09T07:10:13Z
END 2026-09-09T07:12:25Z
ELAPSED_MIN 2.2
MODULE C08 diagnostics and trace capture
STATUS EXPERIMENT DESIGN
SUMMARY Resolved pinned hal_stream create/attach/write/read semantics, including depth-1 capacity and the key result that rejected full-FIFO writes increment producer overrun without incrementing successful-enqueue sample numbers. Traced Task emcOperatorError -> process print + NML error channel -> userspace updateError, separated command status from error text, expanded evidence matrix, added function guide and fault-to-retained-evidence call flow, and advanced C08 to experiment design.
CHECKPOINT Freeze C08 two-hypothesis experiment before implementation: same coarse symptom from different realtime cause ordering; require sampler function-order provenance, producer overrun/full/depth evidence, collector attach/exit/stderr/tags, and explicitly reject consumer continuity or sequential halcmd reads as sufficient atomic/no-loss evidence. Then non-authoritative topology/order/collector-readiness preflight before authoritative run.
PREVIOUS_SESSION_END 2026-09-09T06:29:13Z
OVERLAP NO: this session began 41m00s after the previous canonical end.
