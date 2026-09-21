# 25C0 exercise — exceptional commissioning state positive-clear handoff

Date: 2026-09-21

## Scenario

A machine has just completed commissioning. The safety application is locked/signed and all independent safety devices report healthy. During troubleshooting, an ordinary PLC input was forced to simulate a permissive. The technician says: “I closed the programming laptop, power-cycled the controller, and it is back in RUN. We are good for production.” The next shift did not participate in commissioning.

## Learner task

Produce a return-to-service decision without assuming platform behavior not supplied by evidence. Separate:

1. independent personnel-safety readiness;
2. temporary commissioning/force state;
3. ordinary field-I/O integrity;
4. reset/rearm authority;
5. fresh production START authority.

Identify which statements can be accepted from the scenario, which require positive evidence, and what should block production.

## Expected reasoning contract

A passing answer must reject reboot/RUN mode/safety signature as universal proof that an ordinary force was removed. It should require platform-specific inspection of force/simulation/override state and explicit removal/clearance where present. If the force could have masked a real permissive input or wiring/device failure, it should require an appropriate ordinary physical-path functional check after the force is removed.

The answer must not incorrectly claim that the ordinary PLC force is itself a safety-rated function merely because the independent safety system remains healthy. Conversely, it must not declare the machine production-ready merely because the independent safety layer can still stop hazardous motion: normal production control can remain invalid or unexpectedly permissive.

Reset/rearm must not be collapsed into a motion command. Production release ends in a fresh ordinary START after exceptional state is cleared, required validation is complete, safeguards are restored, and personnel are clear.

## Adversarial variants

### Variant A — forces disabled but installed

The controller indicates forces are disabled, but also indicates force values exist. The learner must distinguish **inactive exceptional data** from **removed exceptional data** and require disposition before handoff.

### Variant B — nonvolatile image loads on power-up

The controller is configured to load a stored image at power-up. The learner must not treat the power cycle as proof of production restoration without establishing what state/configuration the stored image represents and how the platform handles the exceptional mechanism.

### Variant C — forced sensor was physically failed

After explicit force removal, the real sensor does not transition. The learner must reject “the force is gone, therefore production is restored.” The force had masked a physical defect; correction and the affected functional retest are required.

### Variant D — safety healthy, ordinary permissive still wrong

The independent safety chain correctly removes hazardous-motion authority on demand, but an ordinary permissive remains forced. The learner must preserve the boundary: personnel-safety authority may remain intact while ordinary production configuration is still unacceptable for release.

## Frozen lesson

**PRODUCTION HANDOFF REQUIRES POSITIVE DISPOSITION OF EXCEPTIONAL COMMISSIONING STATE; ABSENCE MUST NOT BE INFERRED FROM REBOOT, TOOL CLOSURE, RUN MODE, OR A SAFETY SIGNATURE.**

## Evidence basis

- Siemens S7-1200 documentation: forced elements can remain active in the CPU after STEP 7 closes until explicitly cleared.
- Siemens STEP 7 documentation: force job exists on CPU and has an explicit delete operation.
- Rockwell current controller documentation: force values can exist while forces are disabled; enabling them can activate existing values immediately.
- Rockwell nonvolatile-load documentation: power-up can reload a stored project, so reboot is not a universal sanitization operation.
- Existing FANUC curriculum evidence: production-check alarm can block automatic operation while simulation remains active.

No physical-machine exercise is required or authorized by this curriculum artifact.
