# Governance Audit Protocol

## Objective
Verificare governance target con audit iniziale obbligatorio e capability di architecture modeling/remodeling target-fit.

## Mandatory Checks
1. Target Agent Architecture Hub framing presente (non solo audit-only).
2. Distinzione metodo vs soluzione presente (`topology-discovery-first` metodo interno).
3. Guardrail autorizzativi presenti (no target mutation without explicit authorization; no local target-agent creation).
4. Topologie supportate: 0 agenti, 1 agente, Manager+Operativo, 3+ agenti, altro modello rilevato.
5. Topology options + architecture alternatives presenti.
6. Target-fit rationale + no-framework-leakage check presenti.
7. Evidence taxonomy completa.
8. Structural-change evidence gate + acceptance criteria presenti.
9. Output operativi per agenti target presenti.

## Output
- Findings con severita P0/P1/P2.
- Remediation plan e prompt operativi target-fit.
