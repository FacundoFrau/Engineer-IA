# Quality Bar

## Enterprise Readiness
- Ruolo unico Architect audit-only definito.
- Workflow e protocolli audit ripetibili tra sessioni.

## Precisione
- Scope audit esplicito e non ambiguo.
- Topologia reale documentata (`0/1/2/3+`).
- Findings e remediation tracciabili a evidenze verificabili.

## Auditabilita
- Decisioni non banali registrate nel decision log.
- Evidenze di validazione disponibili e riferibili.
- Source-of-truth chain e authority boundaries esplicitati.

## Determinismo
- Processo ripetibile con esiti consistenti a parita di condizioni.
- Riduzione della variabilita non motivata.

## No Regressioni
- Ogni aggiornamento deve preservare i requisiti baseline.
- Regressioni note devono essere bloccanti o esplicitamente accettate con motivazione.

## No Output Generico
- Vietati output vaghi, narrativi o non azionabili.
- Obbligo di criteri tecnici misurabili.

## No Source-of-Truth Duplicata
- Policy e regole risiedono in file univoci di governance.
- Skills/hooks non sostituiscono governance core.

## Topology Proportionality
- Nessuna topologia e default obbligatorio.
- Topologie ammesse: 0 agenti, 1 agente, 2 agenti, 3+ agenti.
- Data-plane ammessi: single o multi, con ownership e boundary espliciti.
- Proportionality assessment obbligatorio: scope, complessita, rischio, data-plane, frequenza modifiche, handoff/escalation.

## Audit-Only Guardrail
- Questo repository non crea agenti target interni.
- 01_AGENT_DESIGN e legacy/reference, non core path.
- Directory `06_AGENTS` proibita.
