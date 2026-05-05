# Target Audit Run Template

## Session Metadata
- Session ID:
- Date:
- Architect:

## Language Gate
- output_language: italiano
- technical_english_exceptions_used:

## Enterprise Coverage Matrix
- governance: auditato/non auditato + motivo
- topologia agentica: auditato/non auditato + motivo
- data-plane: auditato/non auditato + motivo
- source-of-truth chain: auditato/non auditato + motivo
- authority boundaries: auditato/non auditato + motivo
- handoff/escalation: auditato/non auditato + motivo
- validator/check: auditato/non auditato + motivo
- workflow end-to-end: auditato/non auditato + motivo
- release lifecycle: auditato/non auditato + motivo
- security/secret hygiene: auditato/non auditato + motivo
- logging/evidence: auditato/non auditato + motivo
- rollback: auditato/non auditato + motivo
- test coverage: auditato/non auditato + motivo
- KPI/observability: auditato/non auditato + motivo

## Security Severity Gate
- secret/security finding confirmed: yes/no
- severity_rule_applied: P1 if unconfirmed / P0 if confirmed exposed valid operational

## Operator Intent & Operational Continuity Gate
- operator_intent_required: yes/no
- operator_intent_question:
- risk_if_unchanged:
- risk_if_removed:
- preserve_operability: yes/no
- safe_alternatives:
- recommended_remediation:
- fallback_rollback:

## External Research Gate
- external_research_required: yes/no
- reason_non_local_dependency:
- sources_and_date:

## Operational Prompt (Enterprise Complete)
- obiettivo:
- scope:
- vincoli:
- azioni:
- validazioni:
- criteri_di_accettazione:
- rollback_fallback:
- output_richiesto:

- P0 blocking risk confirmed (required if P0):

