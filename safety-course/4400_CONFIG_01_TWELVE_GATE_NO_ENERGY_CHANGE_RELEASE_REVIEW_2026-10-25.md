# 4400-CONFIG-01 — 12-gate no-energy configuration/change-control release review
**2026-10-25 | DOCUMENTARY PREPARATION ONLY | ALL GATES UNKNOWN / NOT RUN**

| Gate | Required proof / acceptance question | Current state |
|---|---|---|
| CFG-G0-01 | Selected machine ID, modes, lifecycle and exposed people/hazard map | UNKNOWN |
| CFG-G0-02 | Approved SRS, independent safety functions and accepted change-control baseline | UNKNOWN |
| CFG-G0-03 | Exact safety controller model, firmware, project version and correct physical target | UNKNOWN |
| CFG-G0-04 | Online/offline safety signature or equivalent accepted configuration identity and signed record | NOT RUN |
| CFG-G0-05 | Scope of signature and separately tracked standard LinuxCNC/HAL/FPGA/HMI code revision | UNKNOWN |
| CFG-G0-06 | Impact analysis for changes in ordinary motion sequencing, reset, start and timing | NOT RUN |
| CFG-G0-07 | Exact safety I/O model/suffix/SNN/DeviceID and auto-replacement policy | UNKNOWN |
| CFG-G0-08 | Replaced-device wiring, sensor mode/OSSD filtering, field fault paths and physical geometry | UNKNOWN |
| CFG-G0-09 | Safety output/final element/EDM, backfeed and welded/contaminated fault response | UNKNOWN |
| CFG-G0-10 | Independent Y1/Y2 stop, gravity hold, pressure isolation, guards, service support and rescue proof | NOT RUN |
| CFG-G0-11 | Power-return, fault-clear, reset and **fresh** motion-command acceptance, including helper/occupancy | NOT RUN |
| CFG-G0-12 | Qualified independent review, restricted physical test plan, revalidation evidence and release decision | NOT RUN |

**Status semantics:** A signature match can support CFG-G0-04 only; it cannot mark 05–12 PASS. Device network connection cannot mark 08–12 PASS. No partial pass from HMI or safety PLC healthy bit. If a relevant configuration mismatch is found, maintain HOLD until qualified correction/revalidation. No simulation/physical test was performed.

**Architecture:** ordinary LinuxCNC/FPGA = motion control and non-safety diagnostics; independent safety controller/qualified logic = safety-function decisions; independently rated final elements and mechanical/hydraulic isolation = physical risk reduction. Do not delegate personnel safety to normal HAL/FPGA or signature verification.

**Practical service design:** keep a one-page machine-specific compare record and labeled approved spares at the machine; make restoring guards, exact module config and deliberate rearm faster than jumper/bypass workarounds. Maintain versioned status-only public evidence; proprietary wiring and actual as-built settings stay restricted.

**Release:** selected OpenPressBrake G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No people-exposed hazardous operation. A qualified, separately approved isolated/remote experimental plan would need people outside danger zone and explicit residual risk, not this worksheet.
