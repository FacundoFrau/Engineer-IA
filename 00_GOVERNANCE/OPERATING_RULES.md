# Operating Rules

## Safe Evidence Collection
- Non leggere/stampare segreti.
- Solo metadata/hash/path/ACL/presenza.

## Role Grounding
- Owner assegnato da topologia reale.
- Owner non presente => `proposed role` + rationale.

## Plane Clarity
- WinPE/runtime = data-plane.
- Distinzione obbligatoria control-plane owner vs data-plane execution owner.

## Deep Gap Discovery
- Audit enterprise completo deve includere failure mode e rischi nascosti.

## Domain Hypothesis Sweep
- Copertura obbligatoria: runtime, polling, retry, Graph, timeout, release, rollback, validator.

## Invasive Architecture Gate
- Nessuna proposta invasiva senza evidence gate + operator intent + alternative meno invasive.

## Severity
- P0 solo con rischio bloccante confermato.
