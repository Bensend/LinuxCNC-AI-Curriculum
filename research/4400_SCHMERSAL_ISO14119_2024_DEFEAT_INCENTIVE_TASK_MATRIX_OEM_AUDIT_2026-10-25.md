# 4400-GUARD-02 — ISO 14119 defeat-incentive reasoning from original Schmersal guide
**2026-10-25 | original manufacturer guide directly inspected | non-graduated**

## Source and precise strength
Original Schmersal **Design of Safety Guards under Observation of ISO 14119**, 28-page manufacturer PDF: https://products.schmersal.com/media/documents/DOC_MAR_BRO_b-isop01_SEN_AIN_V3.pdf ; inspected PDF p.2 introduction, pp.10–12 (PDF zero-based pages 9–11) *Rate defeat incentives*, p.9 stop/access discussion. **DOC-CONFIRMED manufacturer's interpretation**, not a directly inspected paid ISO 14119 standard and not a selected machine approval.

Manufacturer says its guide interprets ISO 14119:2024-09 and notes a German 2025 edition/transition. Exact jurisdiction and adopted edition for OpenPressBrake **UNKNOWN**. Manufacturer distinguishes interlock position monitoring from guard locking and states risk assessment includes the machine's lifecycle and modes.

## Primary technical finding: defeat is a design input, not merely operator misconduct
The manufacturer's illustrated ISO 14119 method explicitly asks **whether a foreseeable incentive to bypass exists**; if yes, it first considers eliminating or reducing that incentive by design or alternative modes, then anti-defeat measures. Its example task matrix crosses machine **tasks and modes** with potential advantages of defeating the guard: better view, faster throughput, larger workpiece, precision, reduced effort, fewer trips, easier manual adjustment, cleaning and maintenance. It is a manufacturer interpretation/example matrix, **not** a verified full normative requirement.

**Independent corroboration:** OSHA machine-guarding eTool *Additional Safety Considerations*, https://www.osha.gov/etools/machine-guarding/introduction/safety-considerations , explicitly says interfering safeguards are liable to be overridden/disregarded, calls for guards that do not create new hazards and for safe maintenance access. OSHA general guards page https://www.osha.gov/etools/machine-guarding/introduction/guards describes fixed/interlocked/adjustable tradeoffs and cautions guard replacement must not automatically restart the machine. **DOC-CONFIRMED** OSHA public guidance, not a press-brake machine-specific PL/stop-time guarantee.

## Derived practical decision model (INFERENCE)
For each frequent job: identify who does it, whether it is allowed in the current mode, whether it can be completed with protection intact, what makes bypass attractive, then redesign access/fixture/visibility/reset/cleaning *without relaxing protective coverage*. Finally check whether deliberate defeat remains easy and address it with selected qualified guard hardware and supervision. Do not claim an interlock is safe merely because it is coded or difficult to fool; physical stop/hold/access and restart still need independent proof.

| Task / mode | Foreseeable bypass motive | Engineering alternative to review | New hazard to verify |
|---|---|---|---|
| Frequent die changes / setup | Slow removal, lost bolts | Captive accessible guards, tooling access and safe change mode | Inadequate coverage in setup; gravity ram |
| Short-run bending | Poor part view, laser nuisance | Guard sightline/optical cleanliness, workpiece support, approved protective-field configuration | Muting/blanking blind spots; part whip |
| Rear gauge setup | Long walk to reset | Protected local reset with complete hazard sightline | Hidden helper, rear occupancy, unexpected restart |
| Scrap/cleaning | Guard must be removed | External scrap access and safe service position | Stored pressure and jam release |
| Fault diagnosis | Unclear fault reason | Clear diagnostic/status and fault-specific maintenance procedure | Mistakenly treating ordinary status as safety authority |

**Crucial distinction:** an **unpowered ergonomic mock-up** can show a guard is usable and quick to reinstall; it **cannot** prove safety-rated stop response, guard locking, ram gravity hold, hydraulic isolation, or reset/restart performance. Selected machine G0/G1 HOLD, G3/G4 NOT AUTHORIZED.

## Claim ledger
- **DOC-CONFIRMED:** Schmersal original manufacturer guide, specific pages and manufacturer interpretation; OSHA general machine-guarding guidance.
- **INFERENCE:** proposed task matrix and engineering redesign priorities.
- **SOURCE-CONFIRMED:** no new LinuxCNC code studied.
- **TEST-CONFIRMED:** none; no real usability trial yet.
- **COMMUNITY-REPORTED:** none.
- **UNKNOWN:** actual guard/part/mode, operator feedback, geometry, stop/hold, PL/SIL, numerical thresholds, machine performance, adopted edition.

Do not energize an unqualified machine, defeat an interlock, or use a mock-up as permission for exposed operation.
