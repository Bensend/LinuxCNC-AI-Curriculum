# 4400-RCD-01 — A nuisance trip is a design question, not permission to defeat protection
**Status:** PUBLIC OPEN-BOOK TECHNICIAN TRAINING / NON-GRADUATED / all cases UNSCORED. **No energized learner lab.**

## Read first
[Original ABB/Rockwell/Schneider/OSHA source audit](../research/4400_RCD_01_ROCKWELL_PF527_ABB_SCHNEIDER_WAVEFORM_AND_LEAKAGE_OEM_AUDIT_2026-10-26.md), then existing [PANEL-01](4400_PANEL_01_MULTIFEED_SCCR_ARC_FLASH_ISOLATION_AND_RAM_HOLD_MODULE_2026-10-25.md), [BOND-01](4400_BOND_01_PE_DOOR_HINGE_EMC_AND_CHANGE_TECHNICIAN_CARD_2026-10-25.md) and [DCB-01](4400_DCB_01_COMMON_BUS_ENERGY_AND_MOTION_AUTHORITY_MODULE_2026-10-24.md).

## Minimum mechanism to teach
A residual-current device measures the imbalance between current-carrying conductors, not a generic “safe” status. An inverter's rectifier, switching stages, EMC filter and motor cable can produce residual-current waveforms unlike a sinusoidal 50/60 Hz fault. **Type A high-immunity** may reduce unwanted trips but does **not** gain Type B smooth-DC detection merely by being “industrial.” An exact manufacturer's upstream RCD/RCM restriction outranks a generic internet recommendation for another drive. A separate equipment grounding conductor must remain effective. None of these proves a stopped or held machine.

| Function | Ordinary controller/HAL | Electrical protective design | Independent machine safety | Physical isolation |
|---|---|---|---|---|
| Diagnose “RCD tripped” | Can display event if available; not safety authority | Qualified RCD/RCM, PE, protection coordination and OEM matching | Must evaluate unintended power-loss effect on dangerous axes | Qualified lockout and absence-of-voltage verification for service |
| Stop hazardous ram/spindle | May request normal stop | RCD may disconnect supply on electrical fault; **not a controlled-motion guarantee** | Independently qualified stop, load hold, guarding, reset/rearm | Electrical isolation alone cannot restrain gravity load |
| Reconnect/replace drive | No permission from green HMI | Revalidate waveform, PE, protection selection, supply and manufacturer variant | Revalidate affected stopping/holding behavior and restart | No live learner fault tests |

## Six PUBLIC PAPER scenarios — all UNSCORED
**RCD-P01.** A Type A RCD trips whenever a new three-phase drive is enabled. Technician proposes removing the motor-cable shield and the PE jumper. Identify the two separate protection functions affected, safer diagnostic route and minimum qualified evidence.

**RCD-P02.** A service contractor cites Schneider ATV12 Type A SI guidance to replace the upstream RCD for a Rockwell PowerFlex 527. What exact product-specific manual statement blocks direct transfer, and which machine facts remain unknown?

**RCD-P03.** A 30 mA device nuisance-trips with several drives sharing the feeder. Production proposes a 300 mA unit without review. Explain why nuisance immunity, sensitivity, waveform detection, coordination and legally applicable protection requirements must be considered separately. Do not choose a number.

**RCD-P04.** The RCD passes its front test button but a drive's PE conductor was detached during panel retrofit. Explain why the button alone does not prove fault-current path adequacy or installed-drive compatibility.

**RCD-P05.** A three-phase VFD trips upstream protection during a power event and a vertical press ram begins drifting. Which physical machine safety proposition is now exposed, and why is the RCD's correct electrical action insufficient?

**RCD-P06.** A supplier replaces an inverter with an apparently similar model and the nuisance trips disappear. What exact source/version/topology/PE/protection and restart records must be reviewed before crediting the change?

## Eight NO-ENERGY documentary gates — all NOT RUN
| Gate | Reviewer must show | Status |
|---|---|---|
| RCD-G01 | Selected exact drive model, supply, firmware/revision and installation manual | NOT RUN |
| RCD-G02 | As-built single-line identifying RCD/RCM and all drives/filters downstream | NOT RUN |
| RCD-G03 | Applicable manufacturer restriction on RCD waveform type and contact protection | NOT RUN |
| RCD-G04 | RCD/RCM exact product, type, sensing capability, coordination and approved sizing basis | NOT RUN |
| RCD-G05 | Qualified protective-earthing and exposed-metal bonding review, including modifications | NOT RUN |
| RCD-G06 | Written qualified nuisance-trip diagnostic and replacement/change-control route, no bypass | NOT RUN |
| RCD-G07 | Separate qualified lockout, stored-energy and absence-of-voltage service procedure | NOT RUN |
| RCD-G08 | Independent physical machine safe-state / loss-of-power / fresh-restart evidence, G0-approved | NOT RUN |

**Do not score** a gate as passed from a catalog page, LinuxCNC HAL signal, generic RCD test button or this worksheet. Record reviewer, exact source/edition, evidence location, discrepancies and unresolved risks. If any required selected-machine witness is missing, **HOLD**.

## Safer-by-default retrofit pattern
Put an easy-to-find panel-side card showing the exact approved drive/RCD pairing, PE path, lockable isolation and what to do on repeated trips; stock the approved replacement, not a “similar” substitute. Make it faster to repair the nuisance condition correctly than to disconnect PE, remove filters or bridge protection. If the safe-to-operate threshold is not demonstrated, **no personnel-exposed hazardous operation**; isolated/remote investigation only under qualified engineering controls.

## Evidence and evaluation boundary
The OEM source findings are **DOC-CONFIRMED** for their products; cross-device transfer and human-factor predictions are **INFERENCE**; selected machine remains **UNKNOWN**. No physical test, machine-specific leakage/threshold, RCD type selection, safety performance level or independent evaluator score has been produced. Do not treat these public prompts as an information-separated competency test.
