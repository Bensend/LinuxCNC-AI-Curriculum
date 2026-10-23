# 4400 — Remote support / web UI authority without transferring personnel safety to the network
**Original R&D reference contract | 2026-10-23 | paper design, not a certified safety function or selected-machine release.**

## Question and source provenance
How can a small LinuxCNC/OpenPressBrake development machine support remote diagnostics and useful troubleshooting **without** allowing a web server, VPN session or remote user to become the authority for E-stop release, hazardous motion, access, hydraulic holding or personnel-safety restart?

1. **Manufacturer observation — DOC-CONFIRMED:** TRUMPF *TruBend Series 2000 (B35)*, B1161en, 2023-05-01, printed 1-19, official PDF https://www.trumpf.com/filestorage/TRUMPF_US/user_upload/PIM_TruBend_Serie_2000_B35_us_V3.pdf . Manufacturer warns remote support can access UI for analysis and sometimes problem resolution and identifies injury/damage risks. This does **not** establish that remote staff can initiate motion. See [exact OEM audit](../research/4400_TRUMPF_B35_SIDE_DOOR_ASYMMETRY_MUTE_REMOTE_SUPPORT_AND_DISASSEMBLY_AUDIT_2026-10-23.md).
2. **National guidance — DOC-CONFIRMED:** NIST *Guide to Operational Technology (OT) Security*, **SP 800-82 Rev. 3, final September 2023**, §6.2.10 printed pp. 122–124 and OT overlay AC-17(9)/(10) printed pp. 233–234, https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-82r3.pdf . Remote access should be justified, limited to business need, not negate safety/security, and consider MFA, temporary enablement, unique accounts, monitoring and removal of access. OT overlay discusses remote disconnect and command authentication. **Revision 4 is a 2026 public draft, not the final edition relied upon here.**
3. **Selected-machine evidence:** no OpenPressBrake as-built wiring, network architecture, safety function, remote support implementation, motion-command authorization or physical test. All selected behavior UNKNOWN.

This is a minimal **engineering proposal (INFERENCE)** built from those sources, not a claim that TRUMPF or NIST prescribes the exact endpoints below.

## Lightweight four-authority contract
| Action / proposition | Remote browser/support | Local ordinary HMI/LinuxCNC | Independent safety hardware / physical mechanism |
|---|---|---|---|
| Read telemetry, logs, alarms, machine status | Allowed with authenticated scoped session | Allowed | Can report states; diagnostic display never grants safety authority |
| Request a *normal* stop | May be allowed as a non-safety request, after design review | Allowed | Independent protective stop remains functional without browser/network |
| Edit ordinary non-safety settings | Stage only; revisioned and audited; activate only under approved local maintenance conditions | Local review/activation | Cannot alter safety-rated thresholds, safety outputs or bypass physical guards |
| Request a new production cycle / jog | **Denied by default** in R&D remote session | Local authorized operator and mode | Safety chain independently permits/blocks hazardous energy, local deliberate start |
| Clear E-stop, guard fault or safety reset | **Never remotely authorized** | HMI may display guidance, not substitute physical reset | Only qualified independent safety reset with required physical checks; reset is not motion start |
| Defeat interlock / force safety output / mute AOPD | **Denied** | Ordinary UI cannot override independent safety function | Design-validated mode-dependent safety behavior only |
| Disconnect remote session | Locally visible and locally controllable; timed expiry | Local operator can terminate | Must not stop or bypass independent safety; no reliance on internet |
| Energy isolate, block ram, release trapped person | No remote authority | Status display and instructions only | Physical isolators, load restraint, rescue equipment and competent personnel |

## Small practical R&D implementation proposal
- **Default:** local HMI and independent safety chain work with network unplugged. Remote view-only diagnostic access is opt-in, time-limited and locally enabled. A physical or local-panel “remote session active” indicator is visible to people at the machine.
- **Simple connection path:** avoid direct public inbound access to LinuxCNC. Use a managed, authenticated, encrypted remote path with the smallest permissions needed; close it when not in use. Avoid shared always-on vendor accounts. Use MFA where feasible. These are security controls, **not** a PL/SIL claim.
- **Staged configuration:** remote user may prepare a candidate normal-control configuration with an audit trail (actor, timestamp, change diff, source version); only a local authorized operator can activate after appropriate machine conditions. A remote web API cannot write the independent safety controller or alter mechanical/energy isolation.
- **No remote safety reset:** remote loss, reconnect, browser reload, HMI process restart, stale telemetry, server upgrade or restored power must not cause new hazardous motion. The separate physical safety chain is authoritative, and deliberate local start is a separate act from clearing a fault.
- **Practical usability:** remote access enable/disable should be one clearly labeled local action, not a hidden network-admin ritual. The active remote session, its permitted capabilities and expiry should be obvious; make safe troubleshooting easier than installing a permanent bypass or leaving a VPN open.
- **Machine diagnostics:** timestamp and identify stop requests, actual safety-state indications, remote connection state, configuration version, communication freshness and local start authorization separately. Do not turn an ordinary “safe=true” API response into an independent safety proof.

## Concrete negative-path paper acceptance plan (NOT RUN)
| ID | Failure / misuse scenario | Required architecture response | Evidence to obtain before real deployment |
|---|---|---|---|
| REM-01 | Browser refresh or reconnect resends prior start command | No hazardous restart; remote start unavailable by default | Endpoint permission map, command idempotency design, local start witness |
| REM-02 | Remote support disconnects during hazardous cycle | Safety remains independent; normal control handles loss per its design without exposing personnel | Network-loss hazard analysis, independent safety wiring and qualified witness |
| REM-03 | Stale “guard closed” telemetry shown remotely | Mark stale, never treat as permission for motion or access | Source timestamps, age threshold selected by system design, actual guard witness |
| REM-04 | Remote user changes speed/mute configuration | Safety-critical parameters cannot be written through ordinary API; no unreviewed activation | Authorization map, config separation and selected safety controller |
| REM-05 | Remote service session left enabled | Visible session state, bounded expiry, easy local disconnect | Actual access gateway and local disconnect evidence |
| REM-06 | Remote user clicks E-stop reset | Denied; independent physical reset and separate deliberate local start | Safety schematic, local restart qualification |
| REM-07 | Network down during maintenance | Local physical LOTO, ram restraint and emergency escape still work | Physical `PHY-ENERGY/HOLD/ESCAPE` witness |
| REM-08 | Remote operator claims a web HMI's green “STO active” means ram safe | Reject; actual beam hold and access proof independent | `PHY-STOP/HOLD/ACCESS` and selected drive/valve evidence |

## Counterfactual/adversarial review
A VPN with MFA can be perfectly secure while an authenticated remote engineer sends an unsafe command. A safety relay can be independent while an inconvenient maintenance UI incentivizes bypass. A remote stop request can be helpful without being a rated protective stop. A network disconnect button can be a valuable security control without being an emergency stop. Therefore **security, normal-control convenience, safety-related control and physical energy isolation must remain separate propositions**.

## Scope and current state
**DOC-CONFIRMED:** NIST Rev.3 §6.2.10/OT AC-17 and TRUMPF remote-service warning. **INFERENCE:** the permission table and minimal R&D architecture. **SOURCE-CONFIRMED:** no new LinuxCNC source trace. **TEST-CONFIRMED:** none. **UNKNOWN:** actual machine API/remote capability, local safety implementation, safety performance and physical stopping/holding/escape. No machine-specific safety ratings, stopping distances, times or network failure behavior invented. `IN-01..10 UNKNOWN`, `PHY-*` UNKNOWN, `REM-01..08 NOT RUN`, `VAL/PT NOT RUN`; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed hazardous operation without demonstrated minimum safety; isolated/remote experiments still require people outside danger zone and reviewed residual risk.

**Compute decision:** no simulation or GitHub Action justified; the immediate question is authority allocation and source reconciliation. The selected-machine physical proof remains blocked by missing as-built evidence. Historical exact archive backlog 6/85, external 2520–25F0 evaluation gates OPEN.
