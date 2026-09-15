# 4000 safety relay / contactor feedback modeling evidence — 2026-09-15

Session start: 2026-09-15T21:34:25Z

Status: SOURCE / DOC research. No simulation compute consumed.

## Question

What physical distinctions must a Safety Sandbox relay/contactor model preserve so that welded-contact and external-device-monitoring exercises do not teach false equivalence between coil command, auxiliary feedback, and actual removal of hazardous energy?

## Evidence

### Power contactor mirror contact

**DOC-CONFIRMED — Schneider Electric.** Schneider's published explanation of IEC 60947-4-1 mirror contacts says the NC auxiliary mirror contact will not close when one of the contactor power contacts remains closed. Schneider identifies TeSys D products with NC mirror contacts suitable for connection to a safety monitoring relay. A separate Schneider explanation distinguishes a mirror contact on a power contactor from mechanically linked auxiliary contacts: mirror contact semantics relate the NC auxiliary to the NO main power poles; mechanically linked semantics apply between auxiliary NO/NC contacts.

Sources:
- https://www.se.com/uk/en/faqs/FA136111/
- https://www.se.com/es/es/faqs/FA29178/
- https://www.se.com/us/en/faqs/FA126437/

### Forcibly guided relay contacts

**DOC-CONFIRMED — Omron.** Omron documents forcibly guided relay behavior: if an NO contact welds, the NC contacts maintain at least 0.5 mm gap when the coil is de-energized; conversely, if an NC contact welds, the NO contacts maintain at least 0.5 mm gap when energized. Omron identifies this mechanism as a requirement associated with EN 50205 and publishes current G7SA products as relays with forcibly guided contacts.

Sources:
- https://www.ia.omron.com/support/faq/answer/16/faq02481/
- https://www.ia.omron.com/products/family/386/
- https://www.ia.omron.com/data_pdf/guide/4/safetycompo_tg_e_1_2.pdf

### Feedback loop / EDM purpose

**DOC-CONFIRMED — Pilz.** Pilz defines the feedback loop as monitoring externally connected contactors or relays. NC contacts are used to check that the external devices have assumed their safe state before they are operated again.

Source:
- https://www.pilz.com/en-GB/support/lexicon/articles/074070

## Modeling consequence

The simulator MUST NOT collapse these into one Boolean `relay_on` state:

1. coil command / coil electrical state;
2. armature or mechanical state;
3. each main power pole continuity;
4. each auxiliary contact continuity;
5. whether an auxiliary is ordinary, mechanically linked/forcibly guided, or a documented mirror contact;
6. EDM/feedback observation;
7. permission to rearm;
8. actual hazardous-energy path state.

A welded main pole therefore remains conducting after coil removal. Whether feedback exposes that failure depends on the modeled device relationship. An arbitrary auxiliary contact MUST NOT be treated as proof that every main pole opened. A documented mirror-contact model may provide the specific relationship stated by the device evidence. A forcibly guided relay model may provide the documented linked-contact relationship, but the model must not silently generalize that relationship to external power poles it does not mechanically represent.

## Safety Sandbox V1 fault cases

For a two-interruption-device exercise, preserve at minimum:

- normal stop: both interruption paths open; feedback permits rearm only after safe-state witnesses return;
- K1 main pole welded: K1 coil releases but selected main pole remains conducting; second independent interruption path determines whether hazardous energy is actually removed;
- K1 feedback ordinary auxiliary: no assumed main-pole proof; result must be labeled insufficient/unknown unless device-specific relation is supplied;
- K1 documented mirror feedback: welded main pole prevents the mirror NC from falsely indicating the documented safe state;
- feedback contact stuck/welded fault: diagnostics may fail or inhibit rearm depending on topology; do not infer hazard removal from diagnostic state;
- power loss/recovery: output authority must not automatically rearm solely because normal control command returns.

## Teaching rule

Report two separate outcomes after every injected fault:

- **Physical outcome:** did the modeled hazardous-energy path actually reach its defined safe state?
- **Diagnostic outcome:** what did the monitoring architecture know, and did it correctly inhibit restart/rearm?

This distinction is the core lesson. A design can remove the hazard yet fail to diagnose a latent fault, or diagnose a fault while a separate physical path still leaves hazardous energy available.

## Claim discipline

- No PL, SIL, category, diagnostic-coverage percentage, stopping distance, or machine-specific safe-state claim is assigned by this artifact.
- Component-level contact behavior does not establish system-level safety performance.
- Actual machine hazard removal remains machine-specific and must be modeled separately from the relay logic.

## Next work

Use these semantics to define a minimal simulator component contract and a truth-table fixture for the first welded-contact + EDM exercise. Before implementing manufacturer-specific blocks, trace the exact device manual/certification for every relationship represented. Keep ordinary LinuxCNC/FPGA control outside personnel-safety authority; the sandbox may observe normal-control state but must model independent safety authority explicitly.
