# 4400 field exercise — compact accumulator shut-off/discharge versus actual machine safe state

**Learner-visible adversarial exercise, NOT a validated hydraulic circuit.** Companion: `../research/4400_HYDAC_DSV10_LOW_COST_SHUTOFF_DRAIN_SOURCE_SCOPE.md`. Historical manufacturer brochure **HYDAC E 3.551.17/08.03**, printed pp. 10–12: https://www.hydac.com.au/pub/media/Ourcompanies/s/a/safetyvalveblocks.pdf . The source is dated 2003; current product support, conformity and installed applicability are **UNKNOWN**.

## Given documentary facts (DOC-CONFIRMED, not machine tests)

The DSV10 three-way manual changeover arrangement connects pump `P`, accumulator `S`, and tank `T`. During changeover the manufacturer says all three ports are briefly interconnected (negative switching overlap). The DSV10 manual and optional solenoid-discharge variants have different functions; `EY` and `EZ` have opposite de-energized discharge-valve states. The historical brochure calls the combined arrangement a lower-cost alternative to SAF10. It does **not** document the hydraulic circuit of a particular press brake.

## Technician problem

A proposed retrofit replaces two separate manual service valves with one compact DSV10. The operator sees a pressure gauge fall to zero after turning the handle. A heavy ram remains suspended above the tooling. The owner proposes a simple checklist: `pump off -> handle turned -> gauge zero -> safe for service`.

Complete this evidence record **before** deciding whether any person may enter the danger zone:

| Package field | Specific question | Evidence to collect | Status |
|---|---|---|---|
| `ENE/PHY` | Which accumulator and downstream pressure volumes are connected to P/S/T in *each* valve position and during overlap? | As-built hydraulic diagram; identified test ports/zone mapping | UNKNOWN |
| `SF/SRS` | Does removing accumulator pressure disable a protective stop/hold action, pilot supply or controlled retreat? | Selected circuit functional analysis and independent safety requirement | UNKNOWN |
| `ARC/DEP` | Is this exact M, EY or EZ configuration installed, and how does loss of supply affect it? | Full part code, installation instructions, physical inspection | UNKNOWN |
| `VAL` | Is the suspended load independently restrained when the gauge reads zero? | Suitable machine-specific physical witness, safe approved test method | NOT RUN |
| `PT/CHG` | Does replacement change service steps, trapped volumes, proof intervals or lockability? | Change record, technician review and revised validation scope | OPEN |
| `HF` | Can one clear, lockable, verifiable action replace multiple confusing steps without defeating safety? | Observed workflow friction and independent proof of unchanged protection | UNKNOWN |

## Adversarial reasoning prompts

1. If `P/S/T` overlap transiently, what pilot-pressure or load-holding dependencies **could** be affected? State them as hypotheses, not as an invented truth table.
2. Does a gauge connected to `M` prove every downstream cylinder, pilot and trapped cavity is depressurized? Explain the topology evidence required.
3. If the accumulator provides protective-cycle energy, can automatic discharge be assumed safer on loss of electrical power? Explain why the answer depends on the selected safety function.
4. Why does a historical catalog's lower-cost claim not establish a current safe, economical or conforming retrofit?
5. What physical witness would establish that a ram is restrained independently of the pressure indication, and how would you validate it without exposing a person?

**Disposition rule:** if the selected physical safe-state proposition is unproved, the machine must **not** be operated with people exposed. Only isolated/remote experimental operation with people outside the danger zone may be considered after separately controlling residual risk. Neither LinuxCNC, an FPGA, a valve handle, nor one gauge is a substitute for independent personnel-safety architecture and physical verification.

**Evidence classes:** historical device behavior `DOC-CONFIRMED`; potential pilot/hold interactions `INFERENCE`; installed topology, stopping/holding, pressure thresholds, safety integrity and proof interval `UNKNOWN`; physical test `NOT RUN`. No simulation or lab justified by the documentary question.
