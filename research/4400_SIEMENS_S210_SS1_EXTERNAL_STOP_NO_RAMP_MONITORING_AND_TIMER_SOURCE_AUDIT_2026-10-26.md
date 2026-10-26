# 4400-SS1E-01 — “Safe Stop 1” with external stop: who actually brakes?

**Status:** original exact-variant manufacturer source audit, 2026-10-26; DOC-CONFIRMED for the inspected 07/2021 Siemens configuration only. No physical test or selected OpenPressBrake claim.

## Inspected original

Siemens *SINUMERIK MC Safety Integrated Commissioning Manual*, **07/2021 A5E47011139B AC**, valid for SINUMERIK MC/SINAMICS S210 with specified 2021 software, direct [original PDF](https://cache.industry.siemens.com/dl/files/295/109801295/att_1077953/v1/S210_MC_SI_commiss_man_0721_en-US.pdf); §§5.1.3/5.2.3 (printed pp. 120–123, 129–132) and §7.4 (printed pp. 226–228).

## Three different functions hidden behind similar names

| Configuration | OEM-described actual deceleration | OEM-described monitoring | What is automatic |
| --- | --- | --- | --- |
| **SS1-t with OFF3** | Drive commands OFF3 ramp | OEM says **OFF3 braking is not monitored** in this time-controlled variant | STO when SS1 delay expires, **regardless of actual speed** |
| **SS1E-t with external stop** | Higher-level control must issue an appropriate deceleration setpoint; **OFF3 not activated** | No claim that SS1E-t monitors the externally generated deceleration | STO after selected safe delay, independent of speed |
| **SS1 external stop in Extended Functions** | OEM says **no drive OFF3 braking**; responsible higher-level controller must brake | Explicitly **no SBR, no SAM, no standstill detection** in the cited configuration | Only STO/SBC after p9556 delay; OEM says selected timer completes even if SS1 is deselected in the interval |

**DOC-CONFIRMED:** §7.4 printed p. 227 expressly says external stop has no OFF3 ramp and no brake-ramp/acceleration monitoring or standstill detection. It also describes a transient STO/SBC selection/deselection after a timer expires if the SS1 request was deselected earlier. **DOC-CONFIRMED:** printed p. 228 warns that unplanned axis movement is possible during the SS1 external-stop delay (p9652 in the basic/time-controlled configuration). The document uses **p9652** for the basic SS1-t/external-stop delay and **p9556** for the extended external-stop variant; do not collapse the two parameter scopes.

**DOC-CONFIRMED:** §5.1.3 says OFF3 deceleration is not monitored for the examined time-controlled SS1-t. STO is applied at delay expiry even if the drive is not at zero speed. Therefore a “Safe Stop 1 active” indication cannot be used as proof of achieved standstill.

## Failure path / transfer

- **INFERENCE:** LinuxCNC or another ordinary controller supplying the external deceleration setpoint may fail, hang, lose communications or request a ramp that is too slow. The safety system can still reach its timer and apply STO while the motor/load is moving; STO cannot supply controlled deceleration after it has removed torque. A gravity axis may continue moving or drop if independent holding is absent.
- **INFERENCE:** if a coupled-axis group depends on coordinated stop, an external-stop choice must be justified by a system-level safe-stop proposition, not selected because the normal motion planner happens to stop both axes.
- **UNKNOWN:** any OpenPressBrake drive selection, external-stop mode, p9652/p9556 values, actual speed, stop-time/hold performance, pressure/ram behavior, PL/SIL or operator access. The Siemens manual is not a hydraulic press-brake control schematic.

## Design gate

Define a **braking-authority witness** separately from the **STO-timer witness**: who creates deceleration, what independently detects failure, what final element removes energy, what holds the load, what occurs if the normal controller is dead or late, and what prevents rearm. If these are not physically established for the selected machine, **G0/G1 HOLD**. Never run a live fault-injection or timed stop test around people; use qualified isolated/remote procedures only after physical risk controls and authorizations exist.

**Evidence ledger:** DOC-CONFIRMED original Siemens manual pp. 120–123, 129–132, 226–228; INFERENCE cross-machine failure analysis; UNKNOWN installed system; no new LinuxCNC SOURCE-CONFIRMED, TEST-CONFIRMED or blind external score. No hosted/local compute.
