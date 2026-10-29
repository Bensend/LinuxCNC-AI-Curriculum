# FIELD-VISIT-01 — Machine survey is not permission to move the machine

**2026-10-29 | Technician field card | PUBLIC PAPER GUIDANCE, NOT A LIVE TEST**

The OpenPressBrake replacement-board checklist formerly mixed “take photos” with oscilloscope measurements during slow motion and a nice-to-have new cycle video. The [source audit](../research/4400_FIELD_VISIT_01_OPENPRESSBRAKE_LIVE_CHECKLIST_AMBIGUITY_AND_SAFE_INVENTORY_CORRECTION_2026-10-29.md) identifies the exact source and documents the [corrected OpenPressBrake checklist](https://github.com/Bensend/OpenPressBrake/blob/main/docs/VERIFY_AT_MACHINE.md). A blank line is **UNKNOWN**, not a reason to start the press.

| If asked to… | Do this instead |
|---|---|
| “Just get the encoder waveform by jogging slowly.” | **DEFER**. Normal LinuxCNC jog is not independently validated ram restraint or a protective stop. A separate qualified remote/isolated plan is needed. |
| “Take the cabinet cover off and measure the supply.” | **DEFER** until qualified electrical energy control and absence-of-voltage verification, with backfeed considered. |
| “Photograph the controller before unplugging it.” | Use already safely available photos. New intrusive access needs the appropriate energy-control procedure. |
| “Zero on this pressure display means the ram is safe.” | Record which port/volume the instrument measures. Do not infer trapped volumes, gravity restraint or whole-machine zero energy. |
| “Run one cycle so we have a video.” | Do **not** operate for documentation. Use existing historical footage or mark UNKNOWN. |
| “The Pilz bit is green, so we can finish the test.” | A status bit is not physical Y1/Y2 stop/hold proof. |

**Safe low-friction sequence:** desk review existing drawings and dated photos → passive exterior identity only where access is already safe → list missing facts and owner roles → qualified Stage A A–G review → separate hazard-reviewed physical validation if ever justified. Do not open cabinets, disconnect field wiring, attach a scope, move axes or energize hydraulics merely to complete this card. Make safe records easy to gather and make every deferred test visibly **DEFERRED**, not “overdue.”

**Evidence:** SOURCE-CONFIRMED original and corrected Git blobs; DOC-CONFIRMED OSHA 1910.147/1910.333/1910.212; INFERENCE improved shortcut resistance; UNKNOWN installed machine and actual human adoption; TEST-CONFIRMED none. **G0/G1 HOLD; no personnel-exposed hazardous operation.**
