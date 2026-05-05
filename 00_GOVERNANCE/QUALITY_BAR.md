# Quality Bar

## Language Gate
- Output verso operatore in italiano con eccezioni tecniche ammesse.

## Enterprise Complete Audit Gate
- Audit completo solo con copertura delle 14 sezioni minime.
- Sezioni non coperte marcate `non auditato` + motivo.

## Security Severity Gate
- Finding security/secrets non confermato => P1.
- P0 solo con rischio bloccante confermato e segreto valido/operativo/esposto.

## Operator Intent and Continuity
- Operator intent obbligatorio prima di remediation impattante.
- Preserve operability, safe alternatives e rollback/fallback obbligatori.

## External Research Gate
- Obbligatoria per remediation tecnica/security dipendente da standard/vendor/tool behavior non verificabile localmente.

## Operational Prompt Completeness
- Prompt operativo completo con 8 blocchi obbligatori.

## Authorization Guardrail
- Vietata modifica target senza autorizzazione esplicita.
- Vietata creazione agenti target nel repository IA Engineer.
