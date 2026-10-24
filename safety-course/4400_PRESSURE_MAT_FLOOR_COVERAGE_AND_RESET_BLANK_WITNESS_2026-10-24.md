# Blank selected-machine worksheet — pressure mat floor coverage and reset
**Conditional use only. No installed OpenPressBrake mat has been established.** Preserve actual proprietary drawings and wiring in the restricted machine project; this public template contains no machine data.

| Evidence field | Owner / observed value | Provenance / date | Verdict |
|---|---|---|---|
| `PM-BND` machine, operating mode, exposed people, hazard volume | **UNFILLED** | — | UNKNOWN |
| `PM-APP` approach routes including material carts and emergency egress | UNFILLED | — | UNKNOWN |
| `PM-GEO` dimensioned effective floor sensing footprint and joints | UNFILLED | — | UNKNOWN |
| `PM-ALT` raised bases, ladders, platforms, fixtures, climb/step-over paths | UNFILLED | — | UNKNOWN |
| `PM-OEM` exact mat/trim/monitor variants, manuals, revisions | UNFILLED | — | UNKNOWN |
| `PM-WIRE` conductor map, topology, input diagnostics, loop limit | UNFILLED | — | UNKNOWN |
| `PM-CTRL` independent safety controller, qualified output and final element | UNFILLED | — | UNKNOWN |
| `PM-RESET` power return, auto/manual, safety rearm, fresh start and retained demand | UNFILLED | — | UNKNOWN |
| `PM-STOP` qualified physical worst-case stop and load-hold evidence | UNFILLED | — | NOT RUN |
| `PM-ENERGY` trapped hydraulic/pneumatic/electrical and gravity energy | UNFILLED | — | NOT RUN |
| `PM-HF` nuisance trip, cart path, trim replacement, bypass incentives | UNFILLED | — | UNKNOWN |
| `PM-CHG` floor/layout/guard/mat/PLC/motion changes invalidating prior proof | UNFILLED | — | OPEN |

## Required disproof challenges (paper first)
1. Show one path to reach or remain at the hazard **without standing on effective mat area**. If one exists, redesign coverage/guarding rather than claim full occupancy.
2. Show how a worker could remain in the cell while the mat reads clear (elevated standing, lifting, fixture, temporary cover). Require a separate protective function where needed.
3. Explain what happens on **power restoration** and **stepping off** with an old CNC motion request present. Reset must not become a start.
4. Identify which physical element actually removes hazardous motion and which separately prevents a gravity load falling. An OFF bit alone is not proof.
5. Show how floor cleaning, pallet traffic, service access and spare-part replacement work **without** a bypass. Improve usability when legitimate work encourages defeat.

## Qualified validation boundary
First freeze design and physical acceptance criteria using applicable current standards and actual machine facts. Inspect mechanical coverage and wiring under safe isolation. The Rockwell 2024 manual describes checking sensing/logic with the machine prime mover disconnected from final contactors; do **not** copy a human-walking procedure into live hazardous-motion validation. Any independent physical stop/hold testing requires a separately approved, isolated/remote method with personnel outside the danger zone, qualified witnesses and residual risk recorded.

**Gate:** `IN-04p` conditional / UNKNOWN; `VAL/PT` NOT RUN; `G0/G1` HOLD; `G3/G4` NOT AUTHORIZED. A mat is neither an emergency stop, an energy isolator nor a mechanical ram support.
