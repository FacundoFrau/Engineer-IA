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

# Enforced markers: target-fit + no-leakage + evidence taxonomy + gates
Require-Markers 'AGENTS.md' @(
    'topology-discovery-first e metodo interno IA Engineer',
    'Non e una soluzione obbligatoria da imporre al target',
    'Target-Fit Remediation (Binding)',
    'No Framework Leakage (Binding)',
    'Evidence Taxonomy (Binding)',
    'External Research Trigger (Binding)',
    'P0 consentito solo con rischio bloccante dimostrato'
)

Require-Markers '00_GOVERNANCE/OPERATING_RULES.md' @(
    'Remediation target-fit obbligatoria',
    'No framework leakage check obbligatorio',
    'Structural-change evidence gate obbligatorio',
    'P0 solo con rischio bloccante dimostrato',
    'Evidence, Inference, Assumption, External research, Mitigated risk',
    'External research trigger condizionale'
)

Require-Markers '00_GOVERNANCE/QUALITY_BAR.md' @(
    'Target-Fit Remediation',
    'No Framework Leakage',
    'Evidence Taxonomy',
    'P0 Gate',
    'External Research Trigger'
)

Require-Markers 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' @(
    'No-framework-leakage check',
    'Evidence Taxonomy',
    'Structural-Change Evidence Gate',
    'Target-fit rationale',
    'Acceptance criteria verificabile',
    'P0 blocking risk demonstrated',
    'External Research Trigger'
)

Require-Markers 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md' @(
    'Target-Fit Rationale',
    'No-framework-leakage check',
    'Evidence Taxonomy',
    'Structural-Change Evidence Gate',
    'Acceptance criteria verificabile',
    'P0 used',
    'blocking risk demonstrated',
    'External Research Trigger'
)

Require-Markers 'TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md' @(
    'Target-Fit and Leakage Guardrail',
    'No-framework-leakage check',
    'Evidence Taxonomy',
    'Structural-Change Evidence Gate',
    'Acceptance criteria verificabile',
    'P0 present',
    'blocking risk demonstrated',
    'External Research Trigger'
)

Require-Markers 'REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md' @(
    'target-fit remediation',
    'no-framework-leakage check',
    'evidence taxonomy',
    'structural-change evidence gate',
    'P0 usato solo con blocking risk dimostrato',
    'external-research trigger condizionale'
)

Require-Markers 'REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md' @(
    'no-framework-leakage check',
    'evidence taxonomy',
    'structural-change evidence gate',
    'P0 solo con blocking risk dimostrato',
    'external-research trigger condizionale',
    'acceptance criteria verificabile'
)

Require-Markers 'REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md' @(
    'FAIL se manca target-fit remediation',
    'FAIL se manca no framework leakage',
    'FAIL se manca evidence taxonomy',
    'FAIL se manca structural-change evidence gate',
    'FAIL se manca regola P0 with blocking risk demonstrated',
    'FAIL se manca external-research trigger condizionale',
    'P0/P1 bloccanti, P2 warn salvo strict'
)

Require-Markers '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md' @(
    'Target-fit rationale',
    'No-framework-leakage check',
    'Evidence Taxonomy',
    'Structural-Change Evidence Gate',
    'Acceptance criteria verificabile',
    'P0 present',
    'blocking risk demonstrated',
    'External Research Trigger'
)

# forbid converting internal method into mandatory target solution
Forbid-Markers 'AGENTS.md' @('topology-discovery-first = soluzione obbligatoria target','topologia obbligatoria target')

# current session log must include update markers
Require-Markers '04_SESSION_LOGS/session-2026-05-05.md' @(
    'Enforced Governance Hardening Update - 2026-05-05',
    'no_framework_leakage_check: pass',
    'evidence_taxonomy: inserita come obbligo trasversale',
    'severity_gate: P0 solo con blocking risk dimostrato',
    'external_research_trigger: condizionale'
)

Write-Host "SUMMARY P0=$p0 P1=$p1 P2=$p2 Strict=$Strict"
if ($hasBlocking) {
    Write-Host 'RESULT: FAIL'
    exit 1
} else {
    Write-Host 'RESULT: PASS'
    exit 0
}
