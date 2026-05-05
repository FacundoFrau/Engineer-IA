# Operating Rules

## Core Rules
- Decisioni basate su evidenze testabili.
- Nessuna modifica non tracciata alle policy di governance.
- Ogni workflow deve avere acceptance criteria espliciti.
- Ogni agente deve rispettare `AGENTS.md` e `QUALITY_BAR.md`.

## Execution Rules
- Prima bootstrap, poi esecuzione.
- Se il task è deducibile dal contesto, non chiedere input ridondanti.
- In caso di conflitto tra preferenze e qualità enterprise: prevale qualità enterprise.

## Escalation Rules
- Bloccare rilascio in presenza di failure non mitigati.
- Segnalare regressioni rispetto a baseline o release precedente.
