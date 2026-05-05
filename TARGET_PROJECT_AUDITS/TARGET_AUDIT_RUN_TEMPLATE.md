# Target Audit Run Template

## Safe Evidence Collection
- allowed_evidence: metadata/hash/path/ACL/presenza
- forbidden_secret_read_commands: Get-Content secrets*/*.pfx/*.key/token*

## Role Grounding
- detected_owner:
- proposed_role (if needed):
- role_rationale:

## Plane Clarity
- control_plane_owner:
- data_plane_execution_owner:
- winpe_runtime_classification: data-plane

## Deep Gap Discovery
- hidden_failure_modes_found:
- deep_gaps_found:

## Domain Hypothesis Sweep
- runtime hypothesis:
- polling hypothesis:
- retry hypothesis:
- graph hypothesis:
- timeout hypothesis:
- release hypothesis:
- rollback hypothesis:
- validator hypothesis:

## Invasive Architecture Gate
- invasive_proposal_present: yes/no
- evidence_gate:
- operator_intent:
- less_invasive_alternatives:
