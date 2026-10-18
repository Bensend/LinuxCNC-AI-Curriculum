# 4400 safety — overrun-proof owner and power-restoration checkpoint (2026-10-18)
Session began 2026-10-18T17:37:45Z. Main verified at f1f1a5a4feba59228e516a2cb00c6dbf2ee1b493 before attempted publication. 1000/2000/3000 closed; 2500 external competency gates open; 4400 safety active.

DOC-CONFIRMED: Fiessler AKAS-LC II M/F, Doku 986, 2024-02-14, printed pp.21, 26 and 29 describe mode-dependent ownership of the overrun check after voltage reset, but give CONFLICTING integrated-check repeat intervals: 24h in detailed passages (pp.21,29) versus 30h in the integrated-function summary (p.26). The official English document 1281 repeats this internal discrepancy. When AKAS does not perform the check, the manual allocates it to the machine control; do NOT infer that the correct selected-machine interval is known. Exact proof interval remains UNKNOWN pending manufacturer/product/configuration clarification. Printed p.30 assigns stop-valve monitoring to an additional safety controller in external-controller modes. Printed pp.34–35 show paired hex switches that alter monitored functions. Healthy OSSD/HMI/valve status does not prove physical stop/hold performance.

New research and exercise prepared:
- research/4400_AKAS_OVERRUN_PROOF_OWNERSHIP_POWER_RESTORE_2026-10-18.md
- safety-course/exercises/4400_POWER_RESTORE_OVERRUN_OWNER_TRANSFER_EXERCISE_2026-10-18.md

Official manufacturer manual: https://www.fiessler.de/default-wAssets/docs/download/AKAS-LC/bdh-akas-lcii-m-f-dt-doc986-v1.0.pdf

UNKNOWN: actual OpenPressBrake AKAS installation, selected mode/hex settings, safety PLC program, overrun-test authority, cam/valve wiring, stop/hold measurements, hydraulic safe state and PL/SIL targets. No lab justified; no Actions or hosted compute.

Next: obtain one as-built evidence packet (safety controller project, wiring, hydraulic schematic, physical stop/hold evidence), reconcile to existing Safety Design Package IDs rather than adding empty forms. Preserve external evaluation separation and operation restrictions. Generic safety schematics NOT FROZEN. No exposed-person operation before independent safeguarding is validated. Canonical TIMING_APPEND_REQUEST is occupied by an older row; never overwrite it or a truncated LESSON_LOG.