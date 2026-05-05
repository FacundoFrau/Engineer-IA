# Governance Audit Protocol

## Objective
Verificare governance target con Owner Routing enforcement e prompt ownership-correct.

## Mandatory Checks
1. Owner Routing Gate presente.
2. Owner enum presente: Manager/Operativo/Misto/Nessun agente.
3. ownership rationale + modification scope presenti.
4. primary/secondary prompt fields presenti.
5. escalation trigger/path presente.
6. Regola Manager-owned => Manager primary prompt applicata.
7. Operativo prompt solo con runtime/data-plane need.
8. Misto con Manager->Operativo sequence.
9. Nessun agente solo evidence-based.

## Output
- Findings con severita P0/P1/P2.
- Remediation plan e prompt operativi ownership-correct.
