# 4400-STD-6909-02 — Press-brake standards transition and safety-software change review

**2026-10-28 | One-pass qualified reviewer card | Documentary only / NON-GRADUATED**

Use alongside the existing [Stage A A–G one-page request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md), [OPB-D01/D08 restricted card](4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md) and [original official-source audit](../research/4400_STD_6909_02_EU2027_SUBSTANTIAL_MODIFICATION_SAFETY_SOFTWARE_PROVENANCE_SOURCE_AUDIT_2026-10-28.md). **Do not request another owner packet.**

## Six discriminators — mark UNKNOWN rather than guessing

| Question | Evidence a qualified reviewer needs | What it cannot prove |
|---|---|---|
| **1. What machine and date?** | Actual machine identity, original manufacture/put-into-service date, technology, country, retrofit scope, cell/loading attachments. | A new standard number does not retroactively certify an old machine. |
| **2. What regime/edition?** | Applicable ANSI B11.3, legacy EN 12622, ISO/EN ISO 6909 edition, jurisdiction and effective date; if EU after 2027-01-20, check **Regulation** citation list, not only Directive summary. | `20.01.2027` in the Directive summary is **not** by itself withdrawal of the technical standard. |
| **3. Is the change substantial?** | For EU Regulation 2023/1230 applicability: planned vs unplanned modification; new/increased hazard; whether changed safety control or mechanical stability protection is required; affected machine(s) in assembly; qualified conclusion. | `Retrofitted` alone neither triggers nor avoids Article 3(16)/18. |
| **4. What software is active?** | Authorized read-only installed Pilz/AKAS identity, model/firmware, safety project/version/CRC **category where supported**, change history and authorized tool. Keep LinuxCNC/FPGA ordinary software separately identified. | Matching offline project or five-year software log does not prove active application, safe output, or machine stopping. |
| **5. Who owns safety?** | Retained independent safety program and protective final elements, 11K2, wire 75, Y1/Y2 hydraulic stop/hold, pressure zones, guards/muting and restart. | FPGA watchdog, normal driver ENABLE, HMI READY and SPI CRC cannot replace independent safety. |
| **6. What physically happened?** | Qualified STOP/HOLD/ACCESS/ENERGY/RESTART validation, residual risk, change-triggered revalidation and accessible safeguards. | No paper standard, signature or output LED alone proves ram holding or no hazardous restart. |

## Three critical no-shortcut rules

- **Directive vs Regulation:** The European Commission explicitly warns that `20 January 2027` in Directive-era harmonised-standard summaries may denote the **Directive's repeal**, not the withdrawal of an individual technical standard. The new Machinery Regulation generally applies from that date and requires its own OJ citation check.
- **Digital changes count in change review:** Regulation 2023/1230 Article 3(16) can encompass a digital modification when **all** defined criteria apply; Article 18 then assigns obligations to the substantial modifier within its defined scope. Do not automatically classify every firmware update as substantial or assume this EU law governs a U.S. machine.
- **Software identity is not physical proof:** Annex III 1.1.9 and 1.2.1(f) provide a useful model for protecting/identifying safety software and preserving specified change evidence. Their regulatory five-year trace is **not** a blanket rule for normal CNC logs or proof of hydraulic final elements.

**Practical human factors:** keep correctly specified guards, service access and diagnostic evidence convenient; avoid workflows that invite removing guards or leaving bypasses installed. If minimum independent stopping/holding/access protection cannot be demonstrated, **do not operate with people exposed**. Any experimental work must be separately qualified and isolated/remote with residual risk recorded.

**Current selected OpenPressBrake evidence:** Stage A A/F, OPB-D01/D08, actual active program, physical Y1/Y2 stop/hold, guard/restart and qualified jurisdiction decision **UNKNOWN**. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** Independent 2520–25F0 evaluation **NOT RUN**. No machine tests, PLC downloads, lab compute or release credit.

**Provenance:** Commission [Machinery harmonised standards page](https://single-market-economy.ec.europa.eu/single-market/goods/european-standards/harmonised-standards/machinery-md_en) directly inspected; [Regulation 2023/1230](https://eur-lex.europa.eu/eli/reg/2023/1230/2026-07-27/eng) and [Decision 2026/2015](https://eur-lex.europa.eu/eli/dec_impl/2026/2015/oj) official indexed text (direct EUR-Lex full-text fetch blocked); [ISO 6909:2026](https://www.iso.org/standard/83403.html) publisher scope. Full normative clauses not read. See source audit for exact evidence classifications.
