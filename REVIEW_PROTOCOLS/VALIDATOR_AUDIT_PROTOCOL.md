# Validator Audit Protocol

## Objective
Verificare che il validator del target rilevi failure critici topologici e riduca falsi positivi.

## Mandatory Checks
1. Severita P0/P1 bloccanti, P2 warn (o strict bloccante).
2. Copertura marker topology discovery (`0/1/2/3+`, single/multi data-plane).
3. Copertura marker source-of-truth chain, authority boundaries, handoff/escalation, proportionality.
4. Nessun fail su esempi legittimi (es. Manager+Operativo citato come esempio non obbligatorio).
5. Report finale con summary severita e risultato PASS/FAIL.

## Output
- Esito validazione.
- Gap di copertura e remediation.
