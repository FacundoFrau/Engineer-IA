# Decision Log

## Schema Entry
- Date:
- Owner:
- Decision ID:
- Context:
- Options Considered:
- Decision:
- Rationale:
- Impact:
- Risks:
- Follow-up:

## Entries
<!-- Inserire nuove decisioni in testa, formato schema obbligatorio -->

- Date: 2026-05-05
- Owner: AI Engineer / Principal Agent Architect
- Decision ID: DEC-2026-05-05-02
- Context: baseline governance commit and branch naming standardization
- Options Considered: keep master / rename to main
- Decision: rename branch to main (no remote configured)
- Rationale: align with modern default branch standards
- Impact: standard branch naming for future integration
- Risks: low; remote tracking to be set when remote is added
- Follow-up: set upstream once remote exists

- Date: 2026-05-05
- Owner: AI Engineer / Principal Agent Architect
- Decision ID: DEC-2026-05-05-03
- Context: verify validator robustness against negative cases
- Options Considered: skip negative tests / execute controlled failures
- Decision: execute controlled negative tests on temporary branch
- Rationale: confirm P0/P1 blocking behavior and log dependency enforcement
- Impact: validator confidence increased
- Risks: none after restore and branch cleanup
- Follow-up: schedule periodic negative-test review

- Date: 2026-05-05
- Owner: AI Engineer / Principal Agent Architect
- Decision ID: DEC-2026-05-05-04
- Context: governance/validator maintenance cadence
- Options Considered: ad-hoc review / fixed cadence
- Decision: propose weekly review cadence
- Rationale: prevent policy drift and weakening of validation checks
- Impact: sustained governance quality
- Risks: discipline required to maintain cadence
- Follow-up: execute weekly review and log outcomes

- Date: 2026-05-05
- Owner: AI Engineer / Principal Agent Architect
- Decision ID: DEC-2026-05-05-05
- Context: remote Git non configurato e target potenziale GitHub Free
- Options Considered: nessun remoto / remoto privato GitHub Free come backup-audit
- Decision: raccomandare remoto privato GitHub Free come backup/audit remoto, non come enforcement enterprise completo
- Rationale: preservare tracciabilita off-machine senza sovrastimare i controlli disponibili su piano Free
- Impact: migliora resilienza e audit remoto; enforcement avanzato resta in governance locale/processo
- Risks: assenza temporanea di backup remoto finche URL non disponibile
- Follow-up: quando disponibile URL, eseguire `git remote add origin <REMOTE_URL>` e `git push -u origin main`

- Date: 2026-05-05
- Owner: AI Engineer / Principal Agent Architect
- Decision ID: DEC-2026-05-05-06
- Context: riallineare il repository al modello operativo corretto
- Options Considered: mantenere agent design factory / migrare ad audit hub single-architect
- Decision: migrare a `single IA Engineer Architect audit-only hub` per audit e miglioramento di progetti target esterni
- Rationale: allineare missione, workflow e validator al reale uso operativo, riducendo ambiguita e regressioni di governance
- Impact: nuovo percorso core basato su protocolli/template audit; `01_AGENT_DESIGN` deprecato come legacy/reference
- Risks: necessita disciplina nel mantenere coerenza tra governance core e validator
- Follow-up: audit periodico del validator e dei protocolli review
