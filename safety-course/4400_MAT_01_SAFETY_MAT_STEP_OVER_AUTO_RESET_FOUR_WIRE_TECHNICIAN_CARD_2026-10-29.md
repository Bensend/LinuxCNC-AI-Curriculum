# 4400-MAT-01 — Safety mat clear does not mean the cell is clear

**2026-10-29 | UNSCORED PAPER TRANSFER | DO NOT TEST ON LIVE MACHINERY**

Read [original Banner 122364 Rev F (04-Nov-2025) source audit](../research/4400_MAT_01_BANNER_2025_FOUR_WIRE_AUTO_RESET_STEP_OVER_FALSE_SAFE_ZONE_OEM_AUDIT_2026-10-29.md) after 2590 protective devices, 2530 E-stop and 4400-RST-01 fresh restart.

A pressure-sensitive mat senses pressure **on its sensing surface**. It is not a guard against reach-through, not a volumetric occupancy sensor, not a physical energy isolator, and not proof that a person has left a hazardous cell.

**Case A — a person steps over the mat into the machine and then steps off.** The mat may clear while the person remains exposed. Require supplemental guarding/zone-clear and a deliberate reset and separate fresh start; do not restart from mat-clear alone. Banner Rev F p.3 directly warns of this.

**Case B — a controller is wired for auto reset.** The Banner SM-xA-5A manual says output relays may energize as soon as the mat clears and power returns. This is a **safety-output re-enable**, not authorization to start the machine. Prove independent restart prevention and final-element behavior.

**Case C — someone substitutes a two-wire resistor mat.** The selected Banner four-wire monitor explicitly does not support it. A bench continuity result does not establish diagnostic coverage or safety integrity.

**Case D — a brochure says Category 4.** The module's internal design rating does not make the mat-plus-wiring-plus-final-elements Category 4. Require exact selected sensor/controller compatibility, fault analysis, stopping-distance and physical validation.

**Case E — a builder proposes using the mat as a “stand here to run” pedal.** Banner specifically warns against reverse logic that initiates hazardous motion by stepping onto a mat. Use separately engineered operator controls, never treat the mat as a positive start command.

**No-live-test survey:** Identify selected model/edition, mat footprint and edges from safe existing documents/photos, potential bridging/step-over routes, reset location and wiring schematic. Do not enter a danger zone, lift mat edges, disconnect conductors, walk onto a live mat, or run the machine for this card. Qualified commissioning must separately validate every mat and the complete physical stop/restart path under approved conditions.

**Status:** OEM DOC-CONFIRMED; actual machine and physical stop/hold UNKNOWN; no TEST-CONFIRMED result. **G0/G1 HOLD; external evaluation OPEN.**
