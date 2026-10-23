# 4400 — Guard-release and lock-variant traceability worksheet

Status: learner-facing template, no installed machine selected. One row per distinct physical proposition, not one 'safe' bit.

| Linked IDs | Hazard / lifecycle / person | Selected device + exact suffix | Lock principle / power-loss state | Inside escape / outside emergency / auxiliary access | Normal controller request | Independent safety decision / final element | Physical stop/hold/escape witness | Dependencies / CCF | Unknown / status |
|---|---|---|---|---|---|---|---|---|---|
| BND-___ ENE-___ HAZ-___ SF-___ PHY-___ SRS-___ AUTH-___ ARC-___ DEP-___ VAL-___ | | | | | | | | | |

## Conditional validation matrix

| VAL/PT | Initial state | Contradiction / fault | Narrow device indication | Physical proposition to establish independently | Required evidence / acceptance source | Result / status |
|---|---|---|---|---|---|---|
| VAL-___ | Hazard active, guard locked | Power loss with power-to-lock | Magnet off / guard may unlock | No access before danger ends | Selected machine stop/access-time evidence | NOT RUN |
| VAL-___ | Worker inside, guard locked | Power loss with power-to-release | Guard remains locked | Inside escape available and operable | Exact product, actual geometry, unobstructed reach | NOT RUN |
| VAL-___ | Guard closed | Wrong lock-monitoring variant Z -> B | OSSD semantics changed | Guard locking state actually supervised as required | Exact part/suffix and manufacturer §6.2 | NOT RUN |
| VAL-___ | Release used | Release restored, old start held | Guard/lock healthy | No hazardous restart without deliberate start | Independent restart architecture and witness | NOT RUN |
| VAL-___ | Guard closed | HMI diagnostic healthy, independent witness disagrees | Diagnostic output high | Actual guard/physical safe state | Qualified physical witness; mismatch retained | NOT RUN |

### Change record

`CHG-___`: selected lock principle, suffix, actuator, escape/emergency mechanism, guard geometry, lock power source or stop/standstill evidence changed. Mark dependent `SRS/PHY/AUTH/DEP/ARC/VAL/PT` STALE; preserve old evidence for history. `UNKNOWN` machine physical facts remain open. A new release mechanism must not be treated as a substitute for maintenance lockout or a separate ordinary start.

### Human-factor design review

Can a trapped person find/reach/use the escape release in darkness, after power loss and with workpieces/fixtures obstructing the path? Is it easier to use the safe inspection method than to defeat the guard? Is a replacement keyed/clearly labeled? Can a technician prove guard restoration without hazardous exposed testing? If not, record `HF-*` and redesign.
