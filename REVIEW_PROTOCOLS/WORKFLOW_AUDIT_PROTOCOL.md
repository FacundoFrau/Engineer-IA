# Workflow Audit Protocol

## Objective
Verificare workflow target con routing ownership-correct e continuita operativa prima della remediation impattante.

## Mandatory Checks
1. Owner Routing Gate eseguito prima dei prompt.
2. Operator Intent Gate eseguito prima di remediation distruttive/impattanti.
3. risk_if_unchanged vs risk_if_removed valutati.
4. preserve_operability e safe_alternatives presenti.
5. fallback_rollback presente per remediation impattante.
6. P0 solo con blocking risk confermato.

## Output
- Findings con evidenze.
- Azioni correttive ordinate per priorita.
- Prompt/piani operativi ownership-correct.
