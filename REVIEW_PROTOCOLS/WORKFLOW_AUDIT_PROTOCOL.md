# Workflow Audit Protocol

## Objective
Verificare workflow target con routing ownership-correct prima della generazione prompt.

## Mandatory Checks
1. Owner Routing Gate eseguito prima dei prompt.
2. Manager-owned produce Manager primary prompt.
3. Operativo-owned produce Operativo primary prompt solo con runtime/data-plane scope.
4. Misto include sequenza Manager->Operativo.
5. Finding senza owner/rationale/scope e bloccante.
6. escalation trigger/path presente.

## Output
- Findings con evidenze.
- Azioni correttive ordinate per priorita.
- Prompt/piani operativi ownership-correct.
