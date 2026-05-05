# Operating Rules

## Core Rules
- Decisioni basate su evidenze testabili.
- Nessuna modifica non tracciata alle policy di governance.
- Ogni workflow deve avere acceptance criteria espliciti.
- Questo repository opera in modalita audit-only.

## Execution Rules
- Prima bootstrap, poi esecuzione.
- Se il task e deducibile dal contesto, non chiedere input ridondanti.
- In caso di conflitto tra preferenze e qualita enterprise: prevale qualita enterprise.
- `target_project` e `target_workdir` sono obbligatori solo per sessioni con audit target esplicito.
- Nessuna creazione di agenti target interni; `06_AGENTS` vietata.

## Escalation Rules
- Bloccare rilascio in presenza di failure non mitigati.
- Segnalare regressioni rispetto a baseline o release precedente.
- Escalare mismatch tra output audit e criteri di accettazione target.
