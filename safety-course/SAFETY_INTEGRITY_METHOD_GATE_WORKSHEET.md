# Safety Integrity Method Gate Worksheet

Use this only after the hazardous event, physical safe-state proposition, safety function/SRS, fault analysis, and architecture allocation exist.

| Field | Required entry |
|---|---|
| SF-ID | Stable safety-function identifier |
| Hazardous event | Exact event reduced by this function |
| Physical safe-state PROP | Physical proposition required for risk reduction |
| Modes/lifecycle | Modes and lifecycle phases where function applies |
| Trigger / reaction | Trigger and required reaction |
| Timing | Required timing or `UNKNOWN — measurement/derivation required` |
| Reset/restart | Conditions for reset/rearm and requirement for fresh start demand |
| Applicable machinery/type-C constraints | Standard/regulatory/project constraints or explicit UNKNOWN |
| Integrity method | ISO 13849-1 / IEC 62061 / other justified method |
| Exact edition/adoption | Edition and regional/project adoption |
| Target derivation | Risk-assessment evidence that establishes PLr/SIL requirement |
| Input subsystem | Architecture + applicable reliability + diagnostic evidence |
| Logic subsystem | Architecture/certification/application evidence |
| Output/final-element subsystem | Architecture + applicable reliability + diagnostic evidence |
| Shared DEP/CCF trace | Power, wiring, mechanics, environment, network, configuration, maintenance, energy source |
| Systematic-fault controls | Specification/design/software/configuration/change controls |
| Physical witness | What proves the required downstream physical proposition |
| Achieved-integrity evidence | Method-specific evidence; no guessed values |
| Validation | Functional, fault, recovery, maintenance/change cases |
| Open FIND/UNKNOWN | Items that block or qualify the claim |

## Stop rules

Stop the integrity claim and mark it `NOT PROVED` when any required field is unsupported. In particular:

- do not infer PLr/SIL from topology;
- do not infer whole-function integrity from a component certificate;
- do not convert a diagnostic/status bit into a physical process witness without an established equivalence;
- do not invent reliability, DC, CCF, timing, demand-rate, stopping-distance, pressure, or proof-interval values;
- do not treat ordinary LinuxCNC/FPGA state as personnel-safety authority.

## Review question

Before accepting the worksheet, ask:

> If the highest-rated component in this safety function were replaced by another equally rated component, would the physical proposition, common-cause analysis, final-element proof, and validation still be defensible?

If not, the design is relying on a component badge rather than a complete safety-function evidence chain.
