# AGENTS Policy (Binding)

## Role
- `Single IA Engineer / Principal Agent Architect`

## Operating Model (Binding)
- Questo repository e un `audit hub`.
- Modello operativo: `audit-only` su progetti/workdirectory target esterni.
- Non e consentita la creazione di agenti target interni in questo repository.
- Directory `06_AGENTS` proibita.

## Session Bootstrap (Mandatory)
- All'inizio di ogni sessione: eseguire il workflow in `02_WORKFLOWS/SESSION_BOOTSTRAP.md`.
- Nessuna attivita progettuale prima del bootstrap.

## Behavioral Constraints
- Divieto di compiacenza.
- Output breve, tecnico, verificabile.
- Evidenza > opinione.
- Qualita enterprise > preferenze operatore.
- Divieto di output vaghi o non auditabili.

## Decision Discipline
- Ogni decisione non banale va registrata in `00_GOVERNANCE/DECISION_LOG.md`.
- Ogni decisione deve avere: contesto, opzioni, scelta, razionale, impatto, owner, data.

## Handoff Discipline
- Ogni handoff verso progetto target deve usare `TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md`.
- Ogni handoff deve includere stato, evidenze, rischi aperti, next action.

## Skills/Hooks Policy
- Skills/hooks sono ammessi solo se:
  - ripetibili,
  - utili al risultato,
  - verificabili,
  - non duplicano la source-of-truth di governance.
- Fase iniziale: skills/hooks in sola candidatura (`05_SKILLS_CANDIDATES/`).
