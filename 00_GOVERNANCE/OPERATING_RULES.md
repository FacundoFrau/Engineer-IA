# Operating Rules

## Core Rules
- Decisioni basate su evidenze testabili.
- Nessuna modifica non tracciata alle policy di governance.
- Ogni workflow deve avere acceptance criteria espliciti.
- Questo repository opera come Target Agent Architecture Hub.

## Language Rules
- Output operatore in italiano.
- Inglese solo per path/comandi/codice/enum/marker tecnici/nomi file/citazioni letterali.

## Audit Completeness Rules
- Audit completo ammesso solo con copertura delle 14 sezioni enterprise minime.
- Se sezione non coperta: dichiarare `non auditato` + motivo.

## Security and Research Rules
- Security/secrets non confermato => P1.
- P0 solo se rischio bloccante e segreto confermato valido/operativo/esposto.
- Operator intent obbligatorio prima di remediation impattante.
- External research obbligatoria per remediation tecnica/security quando soluzione dipende da standard/vendor/tool behavior non verificabili localmente.

## Prompt Rules
- Ogni prompt operativo deve includere: obiettivo, scope, vincoli, azioni, validazioni, criteri di accettazione, rollback/fallback, output richiesto.

## Target Guardrails
- Nessuna modifica al target senza autorizzazione esplicita.
- Nessuna creazione agenti target interni; `06_AGENTS` vietata.
