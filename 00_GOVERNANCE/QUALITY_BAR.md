# Quality Bar

## Enterprise Readiness
- Ruolo unico Architect audit-only definito.
- Workflow e protocolli audit ripetibili tra sessioni.

## Precisione
- Scope audit esplicito e non ambiguo.
- Findings e remediation tracciabili a evidenze verificabili.

## Auditabilita
- Decisioni non banali registrate nel decision log.
- Evidenze di validazione disponibili e riferibili.

## Determinismo
- Processo ripetibile con esiti consistenti a parita di condizioni.
- Riduzione della variabilita non motivata.

## Target-Fit Remediation
- Remediation deve essere target-fit, non framework-fit.
- Ogni raccomandazione strutturale richiede target-fit rationale e structural-change evidence gate.
- Ogni raccomandazione deve includere acceptance criteria verificabile.

## Evidence Taxonomy
- Obbligatorio distinguere: Evidence, Inference, Assumption, External research, Mitigated risk.

## No Framework Leakage
- Vietato imporre governance IA Engineer al target senza necessita provata da evidenze.
- No-framework-leakage check obbligatorio.

## P0 Gate
- P0 ammesso solo con rischio bloccante dimostrato.

## External Research Trigger
- Ricerca esterna obbligatoria solo se la conclusione dipende da standard/tool/vendor/best practice non verificabili localmente.

## No Regressioni
- Ogni aggiornamento deve preservare i requisiti baseline.
- Regressioni note devono essere bloccanti o esplicitamente accettate con motivazione.

## No Output Generico
- Vietati output vaghi, narrativi o non azionabili.
- Obbligo di criteri tecnici misurabili.

## No Source-of-Truth Duplicata
- Policy e regole risiedono in file univoci di governance.
- Skills/hooks non sostituiscono governance core.

## Audit-Only Guardrail
- Questo repository non crea agenti target interni.
- 01_AGENT_DESIGN e legacy/reference, non core path.
- Directory `06_AGENTS` proibita.
