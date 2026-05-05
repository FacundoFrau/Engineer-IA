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
6. Proporre next action dedotta dal contesto.
7. Divieto di chiedere contesto se deducibile da repository/governance/log.
8. Registrare il bootstrap nel session log corrente.

## Mandatory Session Log Update
Ogni sessione deve aggiornare un log in `04_SESSION_LOGS/` con almeno:
- Session ID e timestamp
- Stato progetto
- Evidenze principali
- Decisioni
- Rischi residui
- Next action

## Acceptance Criteria
- Sequenza completata senza salti.
- Session log creato/aggiornato con evidenze verificabili.
- Stato progetto esplicitato.
- Next action operativa definita.
