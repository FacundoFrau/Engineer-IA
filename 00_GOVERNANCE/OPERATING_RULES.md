# Operating Rules

## Core Rules
- Decisioni basate su evidenze testabili.
- Nessuna modifica non tracciata alle policy di governance.
- Ogni workflow deve avere acceptance criteria espliciti.
- Questo repository opera come Target Agent Architecture Hub.

## Execution Rules
- Prima bootstrap, poi esecuzione.
- Audit iniziale obbligatorio; non e limite operativo.
- Se il task e deducibile dal contesto, non chiedere input ridondanti.
- In caso di conflitto tra preferenze e qualita enterprise: prevale qualita enterprise.
- topology-discovery-first e metodo analitico interno, non soluzione target obbligatoria.
- Remediation target-fit obbligatoria con target-fit rationale.
- No framework leakage check obbligatorio per ogni proposta strutturale.
- Structural-change evidence gate obbligatorio prima di raccomandare cambi strutturali.
- P0 solo con rischio bloccante dimostrato.
- `target_project` e `target_workdir` sono obbligatori solo per sessioni con audit target esplicito; per sessioni interne usare `N/A`.
- Nessuna creazione di agenti target interni; `06_AGENTS` vietata.
- Nessuna modifica al target senza autorizzazione esplicita.

## Operational Output Rules
- Gli output operativi devono adattarsi alla topologia rilevata.
- Manager prompt richiesto se esiste Manager.
- Operativo prompt richiesto se esiste Operativo.
- Prompt unico richiesto se esiste 1 solo agente.
- Se 0 agenti e servono capability agentiche: piano introduzione governance/agentic layer.

## Evidence and Research Rules
- Ogni finding/raccomandazione deve distinguere: Evidence, Inference, Assumption, External research, Mitigated risk.
- External research trigger condizionale: ricerca esterna obbligatoria solo quando la conclusione dipende da standard/tool/vendor/best practice non verificabili localmente.

## Escalation Rules
- Bloccare rilascio in presenza di failure non mitigati.
- Segnalare regressioni rispetto a baseline o release precedente.
- Escalare mismatch tra evidenze target e remediation proposta.
