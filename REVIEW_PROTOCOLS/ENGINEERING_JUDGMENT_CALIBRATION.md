# Engineering Judgment Calibration

## Esempio Audit Debole
- "Validator PASS, template compilati, governance presente."
- Nessuna verifica su funzionamento reale.
- Nessun tentativo di falsificazione claim.
- Nessuna distinzione scritto vs enforcement reale.

## Esempio Audit Corretto
- Real System Reconstruction con entrypoint/runtime/dataflow reali.
- Claim-vs-Evidence Matrix con verdict per claim critico.
- Falsification Attempt su claim ad alto impatto.
- Paper vs Enforcement con gap espliciti.
- Dual remediation: minimum sufficient + enterprise ideal.

## Differenza Tecnica
- Debole: compliance documentale.
- Corretto: engineering judgment con prova/falsificazione.

## Segnali di Falso Enterprise
- hard-fail dichiarato ma non testato.
- KPI definiti ma non misurati.
- policy presente ma bypass non analizzati.
- rollback dichiarato ma non verificato.

## Errori da Evitare
- promuovere P0 senza rischio bloccante confermato.
- confondere policy con enforcement.
- remediation framework-fit non target-fit.
- prompt operativi incompleti/non eseguibili.
