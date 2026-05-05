# Validator Audit Protocol

## Objective
Verificare che il validator enforcement controlli marker/sezioni obbligatorie di Owner Routing.

## Mandatory Checks
1. FAIL se manca Owner Routing section.
2. FAIL se manca owner enum (Manager/Operativo/Misto/Nessun agente).
3. FAIL se mancano ownership rationale/modification scope/prompt/escalation fields.
4. FAIL se manca regola Manager-owned => Manager primary prompt.
5. FAIL se manca regola Operativo prompt solo con runtime/data-plane need.
6. FAIL se manca regola Misto Manager->Operativo sequence.
7. FAIL se manca regola Nessun agente evidence-based.
8. P0/P1 bloccanti, P2 warn salvo strict.

## Output
- Esito validazione.
- Gap di copertura e remediation.
