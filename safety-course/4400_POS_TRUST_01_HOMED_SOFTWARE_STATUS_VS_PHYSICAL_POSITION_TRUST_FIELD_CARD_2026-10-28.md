# 4400-POS-TRUST-01 — Homed is a software state, not a ram-holding certificate
**2026-10-28 | no-energy technician/source review**

A machine can say **HOMED** while its physical position reference has become untrustworthy, or say **UNHOMED** while the machine still contains dangerous stored energy. Neither status is a safety function.

Pinned [LinuxCNC v2.9.10 source audit](../research/4400_POS_TRUST_01_LINUXCNC_2910_VOLATILE_HOME_ESTOP_AND_PHYSICAL_REFERENCE_BOUNDARY_SOURCE_AUDIT_2026-10-28.md) shows that Machine OFF and E-stop request `emcJointUnhome(-2)`, which targets **only joints configured `VOLATILE_HOME`**. It also shows an all-or-none precheck: if a joint is still moving/homing, the unhome routine can return without changing flags. That is a conditional source path, not an observed machine failure.

**Desk-review distinctions:** `VOLATILE_HOME` is software reference invalidation; `HOME_ABSOLUTE_ENCODER` is a reference-setting method; `HOME_IS_SHARED` governs shared home-switch behavior; `HOME_IGNORE_LIMITS` governs homing limit exceptions; ordinary jog limit override is another mechanism. None independently proves a stopped and supported ram.

| Question for a qualified reviewer | Evidence needed | Safe default |
|---|---|---|
| Can this joint drift when its drive loses power? | Actual motor/brake/encoder/load architecture and known failure modes. | Treat position as UNKNOWN until independently qualified. |
| Is the `VOLATILE_HOME` configuration appropriate? | Exact INI, active version and physical position-retention evidence. | Do not equate retained software home with physical trust. |
| Does the absolute encoder really retain reference? | Exact sensor/coupling/configuration and independent validation. | Do not assume a homing flag proves it. |
| Can reference be re-established without personnel exposure? | Safe setup mode, guards, physical holding, remote/isolated witness plan. | Keep G0/G1 HOLD, no live jog for this lesson. |
| Is the ram independently held during an E-stop? | Qualified Y1/Y2 hydraulic/mechanical final-element proof. | A LinuxCNC flag or E-stop screen cannot answer. |

**Usability rule:** a repeatable, visible, no-bypass reference-check process is better than teaching operators to guess direction or disable guards. The source trace establishes ordinary LinuxCNC behavior only. No physical test, safety release, or evaluator score was obtained.
