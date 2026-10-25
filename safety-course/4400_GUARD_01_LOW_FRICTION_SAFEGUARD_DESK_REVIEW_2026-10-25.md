# 4400-GUARD-01 — No-energy safeguard feasibility and bypass-incentive desk review
**2026-10-25 | unexecuted engineering worksheet | NOT a live test, approval or safety PLC design**

Review each gate with the operator, maintainer, qualified safety designer and independent reviewer. Require signed references to actual selected hardware/modes, not just HMI screenshots. A “no” or UNKNOWN means **HOLD** for affected operation; do not bypass to collect evidence.

| Gate | Documentary question | Result |
|---|---|---|
| 01 | Machine type, jurisdiction, actual B11.3 edition and applicable regulations verified (no mechanical-power-press 1910.217 transposition)? | UNKNOWN |
| 02 | Front die, rear backgauge, sheet sweep, helper, maintenance and rescue exposures mapped per mode? | UNKNOWN |
| 03 | Physical guards/devices assessed for each job and actual infeasibility evidenced before any historic safe-distance exception considered? | UNKNOWN |
| 04 | Selected safety laser/guard model, firmware, field geometry, blanking/muting and installed reach coverage documented? | UNKNOWN |
| 05 | Y1/Y2 independent stop and gravity hold specified with physical final elements and witness? | UNKNOWN |
| 06 | Rear guard/backgauge protection and escape/occupancy independent of front point-of-operation status? | UNKNOWN |
| 07 | Selected response and stopping-distance measurement/acceptance method approved before any numerical guard position claimed? | UNKNOWN |
| 08 | Frequent setup, part removal, cleaning, tool changes and fault recovery achievable without guard removal/defeat? | UNKNOWN |
| 09 | Operator and maintainer identify at least three likely bypass incentives and design revisions that preserve protection? | UNKNOWN |
| 10 | Reset sightline, fresh start and retained-command suppression independently specified for every mode? | UNKNOWN |
| 11 | Energy isolation, residual pressure, gravity blocking and power-present/absent rescue owned by qualified responders? | UNKNOWN |
| 12 | Design change, fixture/tooling variation, replacement and periodic inspection trigger appropriate revalidation? | UNKNOWN |

## Review disposition
- **Source evidence:** original 1997 OSHA directive (https://www.labor.nc.gov/osh/osh-enforcement-procedures/cpl-02-01-025-cpl-2-125-guidelines-point-operation-guarding-power-press-brakes/open) §§D–J, O, and 1910.212/1910.147. Historical conditional safe-distance figures are not selected machine criteria.
- **Required outputs:** one task-by-zone matrix, physical-guard feasibility decision with alternatives considered, three bypass-incentive redesigns, versioned selected drawings, SRS-to-final-element map, qualified independent physical VAL/PT plan, signed review. All **NOT PROVIDED** in this generic template.
- **Blocking result:** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. No people-exposed testing; remote/isolated work requires separately qualified containment and personnel exclusion. No LinuxCNC/ordinary FPGA safety authority.
