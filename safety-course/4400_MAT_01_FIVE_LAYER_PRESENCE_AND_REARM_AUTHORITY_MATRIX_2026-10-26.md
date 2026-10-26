# MAT-01 — Five-layer physical presence and rearm authority matrix

**Status:** design-method synthesis (INFERENCE), not a selected-machine architecture or measured result. Link into cumulative 2520–25F0 Safety Design Package.

| Layer / proposed ID family | Positive evidence that might support proposition | Invalid shortcut / adversarial counterexample | Independent witness needed | Status |
|---|---|---|---|---|
| BND/HAZ/HF: physical access geometry | Current as-built zone map, guard, door and bypass-route survey | A healthy mat cannot detect someone standing on a baseplate or in an unprotected recess | Qualified physical geometry review, all lifecycle modes | UNKNOWN |
| SF/SRS/PHY: sensor detection | Exact OEM detection scope and validated effective sensing area | Rockwell's 35 kg adult assurance does not prove detection of every person/posture | OEM rating, selected environmental/coverage proof | UNKNOWN |
| ARC/DEP/CHG: configured channels | Signed mat-to-channel map, both DIP banks, individual channel statuses | Both DIP rows agree on disabled input; no internal error yet coverage is incomplete | Independent as-built vs configured comparison | UNKNOWN |
| AUTH/ENE/PHY: independent stopping and holding | Validated safety-related controller/final elements, measured physical dangerous-state end | Green HMI tag, non-safety auxiliary output or ordinary LinuxCNC stop is not physical hold | Machine-specific stop/hold/pressure-zone evidence | UNKNOWN |
| SRS/HF/VAL/PT: reset/restart | Empty zone witness, controlled reset and separate fresh start | Auto reset can restore mat output when person steps off, or after power dip; prior motion command may persist | Qualified restart/fault recovery and personnel-detection validation | UNKNOWN |

**Safety hierarchy:** normal LinuxCNC/HAL/FPGA controls production motion; non-safety diagnostics display states; independent safety-related controls command and monitor protective functions; physical final elements and energy-removal/retention mechanisms establish the actual safe state. No single mat channel, indicator or reset grants permission for personnel exposure.

**Four mode-specific failure paths to trace:** normal approach; person remains inside after a mat clears; power loss/recovery; maintenance/cleaning with removed mats or disabled inputs. Include mechanical load retention and hydraulic energy isolation for gravity-loaded equipment.

**Human-factor gate:** if the approved route is dirty, slippery, too narrow, impossible to clean or makes ordinary tasks impractical, redesign trim/geometry and cleaning access so the safeguard is easier to use correctly than bypass.

**Evidence:** Rockwell 440F-UM001C-EN-P Dec 2024 (pp.13,19–26,38–39,51–61); Rockwell 440F-UM003A-EN-P Jan 2024 (pp.20–30); Banner 133487 Rev D Oct 2015 (§10.6). All are manufacturer DOC-CONFIRMED for their specified products. This matrix's cross-machine allocations are INFERENCE. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.**
