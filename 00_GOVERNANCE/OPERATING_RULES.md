# Operating Rules

## Core Rules
- Decisioni basate su evidenze testabili.
- Nessuna modifica non tracciata alle policy di governance.
- Ogni workflow deve avere acceptance criteria espliciti.
- Questo repository opera in modalita audit-only.

## Execution Rules
- Prima bootstrap, poi esecuzione.
- Se il task e deducibile dal contesto, non chiedere input ridondanti.
- In caso di conflitto tra preferenze e qualita enterprise: prevale qualita enterprise.
- `topology-discovery-first` e metodo interno di analisi, non soluzione target obbligatoria.
- Remediation target-fit obbligatoria con target-fit rationale.
- No framework leakage check obbligatorio per ogni proposta strutturale.
- Structural-change evidence gate obbligatorio prima di raccomandare cambi strutturali.
- P0 solo con rischio bloccante dimostrato.
- `target_project` e `target_workdir` sono obbligatori solo per sessioni con audit target esplicito; per sessioni interne usare `N/A`.
- Nessuna creazione di agenti target interni; `06_AGENTS` vietata.

## Evidence and Research Rules
- Ogni finding/raccomandazione deve distinguere: Evidence, Inference, Assumption, External research, Mitigated risk.
- External research trigger condizionale: ricerca esterna obbligatoria solo quando la conclusione dipende da standard/tool/vendor/best practice non verificabili localmente.

## Escalation Rules
- Bloccare rilascio in presenza di failure non mitigati.
- Segnalare regressioni rispetto a baseline o release precedente.
- Escalare mismatch tra evidenze target e remediation proposta.
