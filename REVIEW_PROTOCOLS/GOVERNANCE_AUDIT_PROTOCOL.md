# Governance Audit Protocol

## Objective
Verificare governance target con Owner Routing enforcement e Operator Intent/Operational Continuity gate.

## Mandatory Checks
1. Owner Routing Gate presente.
2. Operator Intent & Operational Continuity Gate presente.
3. operator_intent_required e operator_intent_question presenti.
4. risk_if_unchanged e risk_if_removed presenti.
5. preserve_operability e safe_alternatives presenti.
6. fallback_rollback presente per remediation impattante.
7. P0 usato solo con blocking risk confermato.

## Output
- Findings con severita P0/P1/P2.
- Remediation plan e prompt operativi ownership-correct con continuita operativa preservata.
