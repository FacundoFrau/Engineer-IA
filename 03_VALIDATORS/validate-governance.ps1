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
    '02_WORKFLOWS/SESSION_BOOTSTRAP.md','03_VALIDATORS/validate-governance.ps1','04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md',
    'TARGET_PROJECT_AUDITS/README.md','TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md',
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

Require-Markers 'AGENTS.md' @('single IA Engineer','audit-only','Non e consentita la creazione di agenti target interni','Directory `06_AGENTS` proibita')
Require-Markers '00_GOVERNANCE/PROJECT_CHARTER.md' @('hub di audit','progetti target esterni','Non-Objectives')
Require-Markers '00_GOVERNANCE/OPERATING_RULES.md' @('modalita audit-only','target_project','target_workdir','Nessuna creazione di agenti target interni')
Require-Markers '00_GOVERNANCE/QUALITY_BAR.md' @('Audit-Only Guardrail','01_AGENT_DESIGN e legacy/reference, non core path','Directory `06_AGENTS` proibita')
Require-Markers '02_WORKFLOWS/SESSION_BOOTSTRAP.md' @('target_project','target_workdir','obbligatori solo in sessioni con audit target esplicito','Mandatory Session Log Update')
Require-Markers '01_AGENT_DESIGN/README.md' @('DEPRECATED / NON-CORE PATH','legacy/reference','Mapping verso nuovo modello audit hub')
Require-Markers '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md' @('session_state','target_project (optional; required only if target audit esplicito)','target_workdir (optional; required only if target audit esplicito)','Audit Scope','Findings','Risks','Next Action')

# Forbidden legacy-core framing in governance
$forbiddenCore = @('Agent Creation Workflow','factory operativa di agent design interno','Spec agente completa e non vaga')
Forbid-Markers 'AGENTS.md' $forbiddenCore
Forbid-Markers '00_GOVERNANCE/PROJECT_CHARTER.md' @('Progettare agenti con specifiche complete e verificabili')
Forbid-Markers '00_GOVERNANCE/OPERATING_RULES.md' @('Ogni agente deve rispettare')
Forbid-Markers '00_GOVERNANCE/QUALITY_BAR.md' @('Spec agente')

# Session log validity markers on current log
$realLogPath = '04_SESSION_LOGS/session-2026-05-05.md'
if (Test-Path $realLogPath) {
    Require-Markers $realLogPath @('Session ID: session-2026-05-05','## Validation','## Residual Risks','## Next Action') 'P1'
} else {
    Add-Finding 'P1' "Session log atteso mancante: $realLogPath"
}

Write-Host "SUMMARY P0=$p0 P1=$p1 P2=$p2 Strict=$Strict"
if ($hasBlocking) {
    Write-Host 'RESULT: FAIL'
    exit 1
} else {
    Write-Host 'RESULT: PASS'
    exit 0
}
