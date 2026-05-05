# Validator Audit Protocol

## Mandatory Checks
1. FAIL se manca Safe Evidence Collection.
2. FAIL se template/protocollo permette `Get-Content` su `secrets*`/`*.pfx`/`*.key`/`token*`.
3. FAIL se owner inventato senza `proposed role` + rationale.
4. FAIL se manca distinzione control-plane owner / data-plane execution owner.
5. FAIL se manca regola WinPE/runtime = data-plane.
6. FAIL se manca Domain Hypothesis Sweep.
7. FAIL se proposta invasiva senza evidence gate + operator intent + alternative meno invasive.
