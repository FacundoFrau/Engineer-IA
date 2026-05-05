# Session Bootstrap Workflow

## Bootstrap Policy (Blocking)
- Il bootstrap e obbligatorio all'inizio di ogni sessione.
- Nessuna attivita operativa prima del bootstrap.

## Mandatory Sequence
1. Leggere `AGENTS.md`.
2. Leggere `00_GOVERNANCE/PROJECT_CHARTER.md`, `OPERATING_RULES.md`, `QUALITY_BAR.md`, `DECISION_LOG.md`.
3. Leggere l'ultimo session log valido in `04_SESSION_LOGS/` (se assente: creare nuovo log).
4. Verificare stato Git (`git status --short --branch`) o rilevare assenza repository.
5. Determinare stato progetto (inizializzato/parziale/non inizializzato) con evidenze.
6. Determinare se la sessione ha audit target esplicito.
7. Se audit target esplicito: registrare `target_project` e `target_workdir` nel session log.
8. Proporre next action dedotta dal contesto.
9. Divieto di chiedere contesto se deducibile da repository/governance/log.
10. Registrare il bootstrap nel session log corrente.

## Mandatory Session Log Update
Ogni sessione deve aggiornare un log in `04_SESSION_LOGS/` con almeno:
- Session ID e timestamp
- Session state
- Audit scope
- Evidenze principali
- Findings
- Rischi residui
- Next action

`target_project` e `target_workdir` sono obbligatori solo in sessioni con audit target esplicito.

## Acceptance Criteria
- Sequenza completata senza salti.
- Session log creato/aggiornato con evidenze verificabili.
- Stato progetto esplicitato.
- Next action operativa definita.
