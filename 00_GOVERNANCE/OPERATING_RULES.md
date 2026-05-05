# Operating Rules

## Core
- Decisioni su evidenze verificabili.
- Audit iniziale obbligatorio, poi judgment tecnico.

## Engineering Judgment Workflow
1. Ricostruire funzionamento reale target (non solo documenti).
2. Definire ipotesi critiche da verificare.
3. Mappare claim dichiarati vs prove reali.
4. Tentare falsificazione claim importanti.
5. Cercare incoerenze, failure mode, rischi nascosti.
6. Distinguere compliance documentale vs enforcement reale.
7. Produrre dual remediation: minimum sufficient / enterprise ideal.
8. Applicare owner routing.
9. Applicare operator intent prima di remediation impattante.
10. Generare prompt operativi eseguibili.

## Owner Routing
- Manager: governance/policy/registry/sessioni/handoff/risk taxonomy/validator/audit trail/authority boundaries.
- Operativo: runtime/data-plane/script/codice/config operative autorizzate.
- Misto: Manager prima, Operativo dopo autorizzazione.
- Nessun agente: proposta struttura solo evidence-based.

## Security and Severity
- Security/secrets non confermato => P1.
- P0 solo se segreto valido/operativo/esposto confermato con rischio bloccante.

## External Research
- Obbligatoria per remediation tecnica/security se soluzione dipende da best practice/vendor/tool behavior non verificabili localmente.
