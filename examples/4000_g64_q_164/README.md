# G64-Q-164 minimal comparison — disconnected LinuxCNC simulation ONLY

The two NGC files differ only in the naive-CAM Q tolerance. They contain **G0 and G1 motion commands**; do **not** execute on a physical machine or OpenPressBrake. They are not production programs. Use only a disconnected, isolated LinuxCNC simulator under the repository's compute and evidence rules.

- `path_q05.ngc`: `G64 P0.01 Q0.5` — source predicts a canonical single feed A→C, bypassing B by ~0.19996 mm.
- `path_q0.ngc`: `G64 P0.01 Q0` — source predicts two separate feed segments A→B and B→C.
- `arc_q05.ngc` / `arc_q0.ngc`: G17 clockwise 0.25 mm-radius semicircle with explicit G91.1 center offsets. Source predicts Q0.5 converts and merges it into one straight feed, while Q0 retains a canonical circular move; both **NOT RUN**.
- `chord_preflight.py`: stdlib-only geometry check; **not** a LinuxCNC runtime or canonical trace.

Both paths use mm (`G21`), absolute (`G90`), XY (`G17`), feed per minute (`G94`) and the same F600. Source revisions and A–H oracle are in the [guide](../../guides/3300-4000-linuxcnc-g64-p-q-cam-geometry-preflight-2026-11-02.md). Count only *canonical feed moves*, not the initial traverse. Capture actual Task/canonical evidence before claiming runtime confirmation. No tests have been run.
