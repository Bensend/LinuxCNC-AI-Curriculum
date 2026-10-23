# 4400 — GuardLink authority and reset architecture card

**Purpose:** show where a LinuxCNC/OpenPressBrake normal controller may participate without becoming a personnel-safety controller. Generic architecture only, **NOT A WIRING DIAGRAM**. Exact selected devices, wiring, machine safety-function integrity and physical validation remain UNKNOWN.

## A. DG + ENETR architecture (manufacturer-supported family, not a selected design)

```text
Guard / E-stop devices (selected OSSD, EMSS, native GuardLink)
   -> selected GuardLink taps / cable / terminator
   -> 440R-DG2R2T safety relay (independent safety evaluation)
       -> documented safety outputs / selected downstream safety logic
           -> independent final elements (contactor / STO / monitored valve / brake)
               -> ACTUAL PHYSICAL MACHINE HAZARD RESPONSE (requires proof)

440R-ENETR <-- optical status/commands --> DG / GuardLink taps
   <---- ordinary EtherNet/IP status + NON-SAFETY commands ---->
LinuxCNC HMI / ordinary FPGA / machine diagnostics
   [no personnel-safety decision authority]
```

The 440R-ENETR manufacturer manual (440R-UM009E, p. 75) explicitly says the interface is not safety-rated. A displayed safety input state is not a machine-level stop, restraint or isolation witness.

## B. Distinct 432ES architecture

```text
GuardLink taps -> 432ES-IG3 -> CIP Safety network -> selected safety-rated controller
                                               -> selected safety final elements
                                               -> physical hazard response / validation

Ordinary diagnostics/HMI remains separate from the safety decision.
```

GLINK-AT001A p. 3 describes this CIP Safety-capable product-family arrangement. It does not supply a complete selected-machine design or license treating an ordinary LinuxCNC Ethernet interface as CIP Safety.

## C. Never collapse these into one HMI button

```text
1. Clear device fault:          FaultResetCmd -> tap/device power cycle
2. Clear relay fault:           FaultReset    -> relay power cycle
3. Request relay reset:         Reset1        -> relay reset input equivalent
4. Restore guard lock:          LockCmd       -> lock REQUEST; physical lock proof separate
5. Authorize ordinary cycle:    NEW START     -> separate machine SRS/ordinary command
```

A network command cannot prove personnel clear, mechanical guard alignment, stopped motion, hydraulic depressurization, gravity restraint, or maintenance isolation. A green HMI is **not** a sixth safety function. Do not permit exposed-person operation without independent machine-specific physical proof.

**Evidence:** Rockwell GLINK-AT001A (July 2023) pp. 3, 8–9 and 440R-UM009E (February 2026) pp. 39, 75; manufacturer `DOC-CONFIRMED`. Physical/selected application `UNKNOWN`. No tests.
