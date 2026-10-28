# 4400-STRUCT-01 — Three different press-brake load limits (technician one-pass card)
**2026-10-28 | Practical safety-course review | OEM comparison, not selected-machine approval**

A press brake's advertised **total tonnage** is not permission for every load at every location or in every direction. Cincinnati's original [2019 400–2000 PROFORM manual](https://wwwassets.e-ci.com/PDF/Manuals/em-519_n-08-19_proform__400-2000_hydraulic_press_brake_osmm.pdf), printed pp. 4-7/4-8, separately specifies: **(1) left-right off-center load**, **(2) front-back eccentric moment**, and **(3) reverse stripping load on the UP stroke**. These values apply to the named manufacturer family only.

| Question before qualified job approval | Dangerous green-light shortcut | What must actually be known |
|---|---|---|
| Where is the bend load across the bed? | Machine says 400 tons, so 400 tons anywhere | Actual OEM **location-dependent** available force. Its 400 PF example is **200 tons at the housing**; do not reuse on another machine. |
| How far is the force in front of/behind the machine load center? | Y1/Y2 remain synchronized, so the ram structure is safe | OEM **eccentric moment** limit, actual offset and part length; bolt-on nose may need factory determination. |
| Does the job pull against the ram on its upward stroke? | Downstroke rating also covers pulling a stuck punch free | OEM **stripping** permission/rating; the cited manual says bolt-on noses are **not rated** for stripping. |
| Is the tool/holder locally strong enough? | Machine structure is within limits | Existing [TOOL-LOAD-03](../research/4400_TOOL_LOAD_03_WILA_LOCAL_TOOL_LOAD_DISTRIBUTION_AND_VERTICAL_HANDLING_SOURCE_AUDIT_2026-10-26.md): actual tool/holder and engaged length. |
| Will a failure reach a person? | Closed interlock input or stop command proves containment | Real guard/fragment path, independent stop/hold, deliberate restart, qualified physical validation. |

**Why it matters:** The OEM explicitly warns that exceeding eccentric capacity can fracture attachment bolts, damage guides and loosen the bed. **This is a mechanical load-path hazard, not a PID tuning problem.** A safety controller cannot make an already overloaded bolt strong enough.

**Make safe setup easy:** Keep the exact machine-specific force-location/moment/reverse-load chart accessible at setup; show unsupported combinations as **UNKNOWN/HOLD**, not green. Keep guard reinstall and tool handling practical. On change of nose, tooling, adapter, load position or part geometry, review the load case again.

**Evidence:** DOC-CONFIRMED for the cited Cincinnati manual; INFERENCE for the general decision method; UNKNOWN for OpenPressBrake's actual machine/ratings/condition. No physical test, PL/SIL, stopping distance or generic force curve. **G0/G1 HOLD; no personnel-exposed hazardous operation.** Qualified restricted Stage A and independent 2520–25F0 evaluation remain pending.
