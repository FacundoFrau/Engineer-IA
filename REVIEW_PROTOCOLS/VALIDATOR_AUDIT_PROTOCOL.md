# Validator Audit Protocol

## Objective
Verificare che il validator enforcement controlli marker/sezioni obbligatorie del modello Target Agent Architecture Hub.

## Mandatory Checks
1. FAIL se il repository e descritto solo come audit-only.
2. FAIL se manca framing Target Agent Architecture Hub.
3. FAIL se manca distinzione metodo vs soluzione.
4. FAIL se mancano guardrail autorizzativi.
5. FAIL se i template non supportano topologie 0/1/2/3+/altro.
6. FAIL se mancano topology options e architecture alternatives.
7. FAIL se manca target-fit rationale.
8. FAIL se manca no-framework-leakage check.
9. FAIL se manca evidence taxonomy.
10. FAIL se manca structural-change evidence gate.
11. FAIL se mancano output operativi per agenti target.
12. P0/P1 bloccanti, P2 warn salvo strict.

## Output
- Esito validazione.
- Gap di copertura e remediation.
