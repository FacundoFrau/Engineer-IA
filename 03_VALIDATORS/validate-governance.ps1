param(
    [switch]$Strict
)

$ErrorActionPreference = 'Stop'

$hasBlocking = $false
$p0 = 0
$p1 = 0
$p2 = 0

function Add-Finding {
    param(
        [ValidateSet('P0','P1','P2')][string]$Severity,
        [string]$Message
    )
    switch ($Severity) {
        'P0' { $script:p0++; $script:hasBlocking = $true }
        'P1' { $script:p1++; $script:hasBlocking = $true }
        'P2' { $script:p2++; if ($Strict) { $script:hasBlocking = $true } }
    }
    $tag = if ($Severity -eq 'P2' -and -not $Strict) { 'WARN' } else { 'FAIL' }
    Write-Host "$tag [$Severity] $Message"
}

function Pass($msg) { Write-Host "PASS $msg" }

function Require-File($path) {
    if (-not (Test-Path -Path $path -PathType Leaf)) { Add-Finding 'P1' "File mancante: $path"; return $false }
    Pass "File presente: $path"; return $true
}

function Require-Dir($path) {
    if (-not (Test-Path -Path $path -PathType Container)) { Add-Finding 'P1' "Directory mancante: $path"; return $false }
    Pass "Directory presente: $path"; return $true
}

function Require-Markers {
    param([string]$path,[string[]]$markers,[string]$sev='P1')
    if (-not (Test-Path -Path $path -PathType Leaf)) { Add-Finding $sev "File mancante per marker check: $path"; return }
    $c = Get-Content -Path $path -Raw
    foreach ($m in $markers) {
        if ($c -notmatch [regex]::Escape($m)) { Add-Finding $sev "Marker mancante in ${path}: ${m}" }
    }
    Pass "Marker check eseguito: $path"
}

function Forbid-Markers {
    param([string]$path,[string[]]$markers,[string]$sev='P1')
    if (-not (Test-Path -Path $path -PathType Leaf)) { Add-Finding $sev "File mancante per forbidden-marker check: $path"; return }
    $c = Get-Content -Path $path -Raw
    foreach ($m in $markers) {
        if ($c -match [regex]::Escape($m)) { Add-Finding $sev "Marker proibito in ${path}: ${m}" }
    }
    Pass "Forbidden-marker check eseguito: $path"
}

# P0: git repo must exist
$gitOk = $false
try {
    $inside = git rev-parse --is-inside-work-tree 2>$null
    if ($inside -eq 'true') { $gitOk = $true }
} catch { }
if (-not $gitOk) {
    Add-Finding 'P0' 'Repository Git assente.'
} else {
    Pass 'Repository Git rilevato.'
}

# P0: forbidden directory
if (Test-Path -Path '06_AGENTS' -PathType Container) {
    Add-Finding 'P0' 'Directory proibita rilevata: 06_AGENTS'
} else {
    Pass 'Directory proibita 06_AGENTS assente.'
}

$requiredFiles = @(
    'AGENTS.md','README.md',
    '00_GOVERNANCE/PROJECT_CHARTER.md','00_GOVERNANCE/OPERATING_RULES.md','00_GOVERNANCE/QUALITY_BAR.md','00_GOVERNANCE/DECISION_LOG.md',
    '02_WORKFLOWS/SESSION_BOOTSTRAP.md','03_VALIDATORS/validate-governance.ps1','04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md','04_SESSION_LOGS/session-2026-05-05.md',
    'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md',
    'REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md',
    'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md','TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md',
    '01_AGENT_DESIGN/README.md','05_SKILLS_CANDIDATES/README.md'
)
foreach ($f in $requiredFiles) { [void](Require-File $f) }

$requiredDirs = @('04_SESSION_LOGS','TARGET_PROJECT_AUDITS','REVIEW_PROTOCOLS','OUTPUT_TEMPLATES','TARGET_HANDOFFS')
foreach ($d in $requiredDirs) { [void](Require-Dir $d) }

# Must have at least one real session log (not template)
$logs = @()
if (Test-Path '04_SESSION_LOGS') {
    $logs = Get-ChildItem '04_SESSION_LOGS' -File | Where-Object { $_.Name -ne 'SESSION_LOG_TEMPLATE.md' -and $_.Extension -eq '.md' }
}
if ($logs.Count -lt 1) {
    Add-Finding 'P1' 'Session log reale mancante in 04_SESSION_LOGS.'
} else {
    Pass 'Session log reale presente.'
}

# Architecture Hub framing (not audit-only only)
Require-Markers 'AGENTS.md' @(
    'Target Agent Architecture Hub',
    'Audit e fase iniziale obbligatoria, non limite operativo',
    'topology-discovery-first e metodo analitico interno',
    'Non e soluzione obbligatoria per il target',
    'Topologie supportate: 0 agenti, 1 agente, Manager/Operativo, 3+ agenti, altro modello rilevato',
    'Non modificare target senza autorizzazione esplicita',
    'Non imporre framework IA Engineer al target'
)

Require-Markers '00_GOVERNANCE/PROJECT_CHARTER.md' @(
    'Target Agent Architecture Hub',
    'Audit iniziale obbligatorio',
    'Valutare e rimodellare la topologia target',
    'Produrre piani/prompt operativi coerenti con la topologia reale del target'
)

Require-Markers '00_GOVERNANCE/OPERATING_RULES.md' @(
    'Audit iniziale obbligatorio; non e limite operativo',
    'topology-discovery-first e metodo analitico interno, non soluzione target obbligatoria',
    'Nessuna modifica al target senza autorizzazione esplicita',
    'Manager prompt richiesto se esiste Manager',
    'Operativo prompt richiesto se esiste Operativo',
    'Prompt unico richiesto se esiste 1 solo agente',
    'Se 0 agenti e servono capability agentiche: piano introduzione governance/agentic layer'
)

Require-Markers '00_GOVERNANCE/QUALITY_BAR.md' @(
    'Target Agent Architecture Hub',
    'Audit e fase iniziale, non limite',
    'Ammesso modellare/rimodellare topologie target con evidenze',
    'Vietata modifica target senza autorizzazione esplicita',
    'Vietata creazione agenti target nel repository IA Engineer'
)

# template support for topology and operational outputs
Require-Markers 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' @(
    'Discovered topology class: 0 agenti / 1 agente / Manager+Operativo / 3+ agenti / altro modello rilevato',
    'Topology Options',
    'Architecture Alternatives',
    'Target-Fit Rationale',
    'No-framework-leakage check',
    'Evidence Taxonomy',
    'Structural-Change Evidence Gate',
    'Operational Prompt(s) for Target Agents',
    'Manager prompt (if Manager exists):',
    'Operativo prompt (if Operativo exists):',
    'Single-agent prompt (if only one agent exists):',
    'Governance/agentic introduction plan (if 0 agents and needed):'
)

Require-Markers 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md' @(
    'Topology class: 0 agenti / 1 agente / Manager+Operativo / 3+ agenti / altro modello rilevato',
    'Topology Options',
    'Architecture Alternatives',
    'Target-Fit Rationale',
    'No-framework-leakage check',
    'Evidence Taxonomy',
    'Structural-Change Evidence Gate',
    'Operational Prompt(s) for Target Agents'
)

Require-Markers 'TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md' @(
    'Topology class: 0 agenti / 1 agente / Manager+Operativo / 3+ agenti / altro modello rilevato',
    'Topology Options',
    'Architecture Alternatives',
    'Target-Fit and Leakage Guardrail',
    'Evidence Taxonomy',
    'Structural-Change Evidence Gate',
    'Operational Prompt(s) for Target Agents'
)

Require-Markers 'REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md' @(
    'Target Agent Architecture Hub framing presente',
    'Distinzione metodo vs soluzione presente',
    'Guardrail autorizzativi presenti',
    'Topologie supportate: 0 agenti, 1 agente, Manager+Operativo, 3+ agenti, altro modello rilevato',
    'Topology options + architecture alternatives presenti',
    'Output operativi per agenti target presenti'
)

Require-Markers 'REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md' @(
    'Audit usato come fase iniziale, non limite operativo',
    'Discovery topologia reale e supporto 0/1/2/3+/altro',
    'Topology options e architecture alternatives documentate',
    'Output operativi adattati alla topologia reale'
)

Require-Markers 'REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md' @(
    'FAIL se il repository e descritto solo come audit-only',
    'FAIL se manca framing Target Agent Architecture Hub',
    'FAIL se manca distinzione metodo vs soluzione',
    'FAIL se mancano guardrail autorizzativi',
    'FAIL se i template non supportano topologie 0/1/2/3+/altro',
    'FAIL se mancano output operativi per agenti target'
)

Require-Markers '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md' @(
    'Hub Framing',
    'Method vs Solution Guardrail',
    'topology_class: 0 agenti / 1 agente / Manager+Operativo / 3+ agenti / altro modello rilevato',
    'Topology Options',
    'Architecture Alternatives',
    'Operational Prompt(s)'
)

# fail if repo described ONLY as audit-only
Forbid-Markers 'AGENTS.md' @('Modello operativo: audit-only')

# current session log update markers
Require-Markers '04_SESSION_LOGS/session-2026-05-05.md' @(
    'Target Agent Architecture Hub Realignment Update - 2026-05-05',
    'audit_as_initial_phase: yes',
    'architecture_hub_actions_required: yes',
    'topology_support: 0/1/Manager+Operativo/3+/altro',
    'operational_prompts_policy: manager/operativo/single/0-agent plan obbligatori secondo topologia reale'
)

Write-Host "SUMMARY P0=$p0 P1=$p1 P2=$p2 Strict=$Strict"
if ($hasBlocking) {
    Write-Host 'RESULT: FAIL'
    exit 1
} else {
    Write-Host 'RESULT: PASS'
    exit 0
}
