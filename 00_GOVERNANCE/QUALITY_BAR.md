# Quality Bar

## Enterprise Readiness
- Ruolo unico Architect definito come Target Agent Architecture Hub.
- Audit iniziale obbligatorio e capability architetturale operativa disponibili.

## Precisione
- Scope audit esplicito e non ambiguo.
- Topologia reale documentata (0/1/2/3+/altro).
- Findings e remediation tracciabili a evidenze verificabili.

## Auditabilita
- Decisioni non banali registrate nel decision log.
- Evidenze di validazione disponibili e riferibili.

## Architecture Capability
- Audit e fase iniziale, non limite.
- Ammesso modellare/rimodellare topologie target con evidenze.
- Output operativi (prompt/piani) coerenti con topologia reale.

## Owner Routing Enforcement
- Owner Routing Gate obbligatorio per ogni finding.
- Owner enum obbligatorio: Manager / Operativo / Misto / Nessun agente.
- Manager-owned richiede Manager primary prompt.
- Operativo prompt ammesso solo con runtime/data-plane need.
- Misto richiede Manager->Operativo sequence.
- Nessun agente: proposta struttura solo evidence-based.

## Required Finding Fields
- owner
- ownership rationale
- modification scope
- primary prompt
- secondary prompt (if applicable)
- escalation trigger/path

## Target-Fit Remediation
- Remediation deve essere target-fit, non framework-fit.
- Ogni raccomandazione strutturale richiede target-fit rationale e structural-change evidence gate.
- Ogni raccomandazione deve includere acceptance criteria.

## Evidence Taxonomy
- Obbligatorio distinguere: Evidence, Inference, Assumption, External research, Mitigated risk.

## No Framework Leakage
- Vietato imporre governance IA Engineer al target senza necessita provata da evidenze.
- No-framework-leakage check obbligatorio.

## Authorization Guardrail
- Vietata modifica target senza autorizzazione esplicita.
- Vietata creazione agenti target nel repository IA Engineer.

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
