# AI Engineer Governance Project

Sistema di governance per progettazione, modellazione, validazione e miglioramento di agenti IA enterprise-grade.

## Avvio rapido
1. Leggere [AGENTS.md](./AGENTS.md).
2. Eseguire bootstrap sessione: [02_WORKFLOWS/SESSION_BOOTSTRAP.md](./02_WORKFLOWS/SESSION_BOOTSTRAP.md).
3. Compilare template agente in [01_AGENT_DESIGN/AGENT_SPEC_TEMPLATE.md](./01_AGENT_DESIGN/AGENT_SPEC_TEMPLATE.md).
4. Eseguire validator: `powershell -ExecutionPolicy Bypass -File .\03_VALIDATORS\validate-governance.ps1`.

## Source of truth
- Policy operative: `AGENTS.md` + `00_GOVERNANCE/*`
- Workflow: `02_WORKFLOWS/*`
- Validazione minima: `03_VALIDATORS/validate-governance.ps1`
- Skills/hooks: solo candidati in `05_SKILLS_CANDIDATES/`
