# 4400-CONFIG-01 — Sixteen technician decisions (PAPER / UNSCORED)
**2026-10-25 | Practice only, not blind evaluation or physical validation.** For each case, trainee must state (1) known OEM fact, (2) missing physical witness, (3) safe HOLD/continue documentary decision, (4) which qualified role owns the next evidence, (5) what normal LinuxCNC cannot authorize.

| # | Paper scenario | Specific decision question |
|---|---|---|
| 01 | Safety signature matches; ordinary LinuxCNC program changed stop-to-restart sequencing. | Does signature alone approve return to production? |
| 02 | Signature matches but machine serial/selected controller not identified. | What identity evidence is missing? |
| 03 | Safety controller reports READY; one contactor may be welded. | What independent final-element witness is required? |
| 04 | Guard I/O replaced; same network address but unknown SNN. | Does address match prove replacement? |
| 05 | Rockwell permissive auto-replacement selected during a safety-dependent service period. | Which OEM limitation applies? |
| 06 | Out-of-box safety module auto-configures and connects. | What OEM functional test/authorization remains? |
| 07 | Siemens online and offline collective F-signatures match but technician is online with a different F-CPU. | Why is signature comparison insufficient? |
| 08 | Siemens F-block versions differ despite apparent program identity. | Which version-specific discrepancy remains? |
| 09 | Rockwell 2012 signature match and standard-only download. | What safety-tag reinitialization hazard does the old manual describe? |
| 10 | Technician applies 2012 Table 34 to a firmware 38 GuardLogix 5580. | Why is this transfer invalid without current OEM evidence? |
| 11 | Safety signature deleted to make a quick edit. | What safety-release state and revalidation obligation follow? |
| 12 | Maintenance restores guard wiring but leaves a test jumper. | How should usability and post-service verification be redesigned? |
| 13 | Correct I/O module and safety signature, but hydraulic ram load-holding path unverified. | Can G0 or personnel-exposed operation be released? |
| 14 | Safety task unchanged, but standard HMI resets and immediately reissues prior motion. | What is the fresh-command failure path? |
| 15 | Safety I/O configuration updated after changing an OSSD sensor. | Which sensor pulse/receiver/filter and physical geometry dependencies need review? |
| 16 | Automatic network reconnection after power restoration, operator inside a robot cell. | What must independently prevent unexpected hazardous motion? |

## Unscored reviewer expectations (NOT a hidden answer key)
The learner must **never** equate MATCH/READY/CONNECTED with physically safe. For 01, 09, 10 and 14, articulate standard-versus-safety software boundaries and firmware/generation scope. For 04–06 and 15, name exact device identity, SNN, mode, wiring, OEM functional retest and independent physical response. For 03, 12, 13 and 16, require independent physical final-element/guard/occupancy/restart proof. For 07–08, explain target F-CPU and F-block-version checking. All sixteen are **PAPER / UNSCORED**, not an information-separated competency score.

## Blank restricted-machine witness (do not fill from inference)
| Item | Owner/revision | Evidence ID (restricted) | Status |
|---|---|---|---|
| Selected machine and controller identity | UNKNOWN | — | MISSING |
| Accepted safety signature and online compare | UNKNOWN | — | NOT RUN |
| Standard LinuxCNC/FPGA change impact | UNKNOWN | — | NOT RUN |
| Safety I/O module/suffix/SNN/replacement mode | UNKNOWN | — | NOT RUN |
| Guard/front/rear/occupancy and fresh command | UNKNOWN | — | NOT RUN |
| Physical Y1/Y2 stop/hold, hydraulic isolation, service restraint | UNKNOWN | — | NOT RUN |
| Independent reviewer and safe test plan | UNKNOWN | — | NOT RUN |

**No energized test, controller download, safety force, guard defeat or people-exposed operation is authorized.** Store any as-built sensitive data in restricted machine workspace, not this public curriculum.
