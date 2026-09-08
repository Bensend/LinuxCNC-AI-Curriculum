# C04 — fresh-AI novel-scenario handoff

Status: **PASS**

## Novel scenario

A tandem axis is moving under the accepted C04-style relative-feedback cross-coupler. During a loaded move:

- B encoder scale silently changes by +8%;
- the measured B position therefore begins to appear increasingly ahead of its true position;
- the cross-coupler commands A upward and B downward to oppose the measured disagreement;
- PID A remains below its output bound;
- PID B reaches its local software output bound for 1.2 s;
- after the load is removed, measured A/B disagreement decays only slowly;
- no independent physical position reference is yet available.

## Fresh-AI answer

The strongest defensible observation is that the controller sees sustained relative-feedback disagreement and that PID B has reached its configured software authority while the cross-coupler remains active. That does **not** establish which physical side is actually ahead, whether either actuator is load-limited, or whether the encoder is truthful.

The encoder-scale fault makes the relative-feedback error itself potentially untrustworthy. Therefore increasing B authority merely because B is saturated could worsen physical racking. Likewise, interpreting the 1.2 s saturation as proof of mechanical/load limitation is invalid. PID saturation is evidence about the software controller's requested-versus-available output, not direct evidence about motor current, hydraulic pressure/flow, valve authority, true ram position, or structure alignment.

Before assigning cause, require evidence from independent domains: sensor plausibility/redundancy or a trusted physical reference; drive/actuator effort telemetry; load/pressure/flow evidence where applicable; and synchronized event timing. C05 owns the sensor-fault side of this scenario. Later supervisory/state-machine and safety modules own permissible reactions.

Ordinary control may calculate bounded cross-correction and expose diagnostic state. It may not silently convert uncertain disagreement into safety authority. A real tandem press-brake anti-racking architecture needs an independently justified fault envelope and safety-rated means appropriate to the hazard analysis.

## Handoff rubric

PASS because the answer preserves all five required separations:

```text
software authority telemetry
!= measured feedback truth
!= physical plant truth
!= fault diagnosis
!= safety authority
```

It also resists a combined sensor-fault + saturation adversary rather than treating either signal as self-authenticating.
