# 4400-MWF-01/02 — Two independent clearance questions and a maintenance third

**2026-10-27 | Integrated architecture/failure-path review | NON-GRADUATED.** Prerequisites: [MWF-MIST-01](4400_MWF_MIST_01_SPINDLE_STOP_VS_BREATHING_ZONE_CLEARANCE_FIELD_MODULE_2026-10-27.md), [MWF-QUALITY-02](4400_MWF_QUALITY_02_MICROBIAL_SKIN_GLOVES_AND_SERVICE_FIELD_MODULE_2026-10-27.md), [original-source audit](../research/4400_MWF_01_02_NIOSH_HSE_OSHA_MIST_SKIN_MICROBIAL_EXPOSURE_SOURCE_AUDIT_2026-10-27.md). Does not add scored cases or executed gates.

## Why an ordinary 'cycle complete' light is inadequate
A machining cycle can finish while (a) the spindle is still coasting, (b) coolant aerosol remains suspended, (c) the extractor has failed, (d) the fluid itself has deteriorated, or (e) stored electrical/pneumatic/hydraulic energy remains. These are different physical states with different consequences. **HSE MW1** directly supports residual mist after stop and machine-specific extraction/clearance; **HSE MW5** supports separate microbial-quality controls; the combined sequence is an **INFERENCE** for curriculum design.

| Proposition | What the operator needs to know | Ordinary control/diagnostic contribution | Actual independent witness and authority |
|---|---|---|---|
| **MOTION-SAFE-ACCESS** | Can I reach the tool/workpiece without hazardous movement? | M5, spindle speed display, guard request | Qualified machine-specific guard, stop/standstill, access and rearm safety design; actual physical motion/geometry proof |
| **MIST-CLEAR-ACCESS** | Is opening the enclosure acceptable for inhalation exposure? | Mist-clearance timer, LEV request, flow alarm | Actual capture/clearance and breathing-zone assessment by competent hygienist; source- and task-specific control |
| **FLUID-CONTACT** | Is handling fluid/swarf controlled for skin/biological hazards? | Fluid-service log, pH/concentration trend, alarms | Supplier-specific chemistry, microbial-quality program, PPE/task controls and worker-health assessment |
| **SERVICE-ENERGY** | Can I clean inside, open a sump or maintain LEV safely? | CNC OFF and status | Task-specific physical isolation, residual-energy verification and restraint; qualified service procedure |
| **FRESH-START** | After clearing the fault/door, can the machine unexpectedly move? | Ordinary cycle-ready bit | Independent safeguard reset + fresh intentional ordinary motion command; actual validation |

## Adversarial combined timeline — PAPER ONLY
1. Spindle is commanded to stop. **UNKNOWN:** coast/guard-lock safety state; ordinary command alone is not motion-safe evidence.
2. Coolant spray stops, but a visible plume persists. **DOC-CONFIRMED** by HSE MW1 as a possible failure mode; a timed delay is only credible for inhalation after machine-specific verification.
3. Extraction indicator remains ON while a duct has detached. **INFERENCE:** a fan-run bit cannot prove capture. A qualified assessment must determine whether to prevent exposure, suspend work or repair.
4. Operator tries compressed-air cleaning to recover throughput. **DOC-CONFIRMED** HSE identifies added aerosol, swarf and noise; give vacuum/extracted cleaning as an easy alternative.
5. Worker discovers fluid contamination, opens the sump and wears gloves. **DOC-CONFIRMED** HSE MW2/MW5 support chemical/biological management and entanglement warning; independent stopped/isolated machinery is still required.
6. Extraction and fluid service finish. Reset of an alarm or reopening a door does not itself authorize fresh hazardous motion. **INFERENCE:** preserve separate stop, exposure and maintenance sign-offs and a new deliberate start.

## Release logic: do not combine into one 'all green' signal
A selected machine might need different mechanisms for mechanical guard locking, aerosol clearance and process management. A design can use ordinary software for an **exposure delay** where justified by a qualified risk assessment; it must not promote that software to a **personnel-safety function** merely because both affect a door. Conversely, safety-rated standstill monitoring cannot establish acceptable air quality. The designer must identify which failures are personnel-safety critical and select appropriate independent functions; this review does not prescribe a universal safety architecture.

**Low-friction design:** put extraction status and service instruction at the operator's natural task point, give clear *why wait* feedback instead of an unexplained nuisance delay, provide an easy swarf vacuum and sump sample port, make guarding easy to reinstall, and let workers report symptoms/odors without losing a whole shift to a poorly designed maintenance process. No bypass of the motion safeguard to shorten a mist wait.

**Change invalidation:** new fluid/biocide, high-pressure coolant nozzle, cutting speed, enclosure leak, door geometry, fan/duct/filter, recirculation path, sampler location, workpiece alloy, cleaning method or maintenance procedure can invalidate relevant mist/skin evidence. A guard/drive/motion change separately invalidates motion safety proof. Shared changes may affect both; record both impact paths.

**Status:** all actual selected-machine parameters, exposures, independent physical motion/guard/energy witnesses and external competency score **UNKNOWN/NOT RUN**. No physical test, no new LinuxCNC SOURCE-CONFIRMED finding, no compute. **G0/G1 HOLD; no personnel-exposed hazardous operation.**
