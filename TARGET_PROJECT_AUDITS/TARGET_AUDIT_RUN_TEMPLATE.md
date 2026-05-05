# Target Audit Run Template

## Session Metadata
- Session ID:
- Date:
- Architect:
- Session state:

## Target Context
- Target audit esplicito: yes/no
- target_project (required if yes, else N/A):
- target_workdir (required if yes, else N/A):
- target mutation authorized: yes/no

## Audit Scope
- In scope:
- Out of scope:

## Owner Routing Gate
- owner: Manager / Operativo / Misto / Nessun agente
- ownership rationale:
- modification scope:
- primary prompt:
- secondary prompt (if applicable):
- escalation trigger/path:
- Manager-owned => Manager primary prompt check: pass/fail
- Operativo prompt only with runtime/data-plane need check: pass/fail
- Misto Manager->Operativo sequence check: pass/fail

## Method vs Solution Guardrail
- topology-discovery-first used as internal method: yes/no
- topology-discovery-first imposed as target solution: forbidden
- No-framework-leakage check: pass/fail + evidence

## Evidence Taxonomy
- Evidence:
- Inference:
- Assumption:
- External research:
- Mitigated risk:

## Discovered Topology
- Discovered topology class: 0 agenti / 1 agente / Manager+Operativo / 3+ agenti / altro modello rilevato
- Topology evidence:

## Topology Options
- Option A (keep current):
- Option B (reduce):
- Option C (expand):
- Option D (refactor to alternative model):

## Architecture Alternatives
- Recommended architecture:
- Alternative architecture 1:
- Alternative architecture 2:
- Trade-off summary:

## Target-Fit Rationale
- Why recommendation is target-fit:
- Operational impact:

## Structural-Change Evidence Gate
- Structural change proposed: yes/no
- If yes, evidence in target files:
- Acceptance criteria:

## Operational Prompt(s) for Target Agents
- Manager prompt (if Manager exists):
- Operativo prompt (if Operativo exists):
- Single-agent prompt (if only one agent exists):
- Governance/agentic introduction plan (if 0 agents and needed):

## Findings
- Finding ID:
- Severity (P0/P1/P2):
- P0 blocking risk demonstrated (required if P0):
- Evidence:
- Impact:
- Recommended remediation:
- Acceptance check:

## Risks
- Residual risks:

## Next Action
- 
