# Validator Audit Protocol

## Objective
Verificare che il validator enforcement controlli marker/sezioni obbligatorie di Owner Routing e Operator Intent Gate.

## Mandatory Checks
1. FAIL se manca Operator Intent Gate.
2. FAIL se template consente remediation distruttiva senza operator intent check.
3. FAIL se manca risk_if_unchanged o risk_if_removed.
4. FAIL se manca preserve_operability o safe_alternatives.
5. FAIL se manca fallback_rollback su remediation impattante.
6. FAIL se P0 non richiede blocking risk confermato.
7. P0/P1 bloccanti, P2 warn salvo strict.

## Output
- Esito validazione.
- Gap di copertura e remediation.
