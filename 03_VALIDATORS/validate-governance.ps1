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

function Require-Regex {
    param([string]$path,[string[]]$patterns,[string]$sev='P1')
    if (-not (Test-Path -Path $path -PathType Leaf)) { Add-Finding $sev "File mancante per regex check: $path"; return }
    $c = Get-Content -Path $path -Raw
    foreach ($p in $patterns) {
        if ($c -notmatch $p) { Add-Finding $sev "Pattern mancante in ${path}: ${p}" }
    }
    Pass "Regex check eseguito: $path"
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

# Core discovery markers
Require-Markers 'AGENTS.md' @('audit-only','0 agenti','1 agente','2 agenti','3+ agenti','Manager+Operativo','non default obbligatorio')
Require-Markers '00_GOVERNANCE/PROJECT_CHARTER.md' @('topology discovery','proporzionalita','Non-Objectives')
Require-Markers '00_GOVERNANCE/OPERATING_RULES.md' @('0/1/2/3+ agenti','scope, complessita, rischio, data-plane, frequenza modifiche, handoff/escalation','N/A')
Require-Markers '00_GOVERNANCE/QUALITY_BAR.md' @('Topologie ammesse: 0 agenti, 1 agente, 2 agenti, 3+ agenti','Data-plane ammessi: single o multi','Proportionality assessment obbligatorio','source-of-truth chain','authority boundaries')
Require-Markers '02_WORKFLOWS/SESSION_BOOTSTRAP.md' @('target_project','target_workdir','N/A','Topology discovery fields')
Require-Markers 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' @('Discovered topology class','0 agenti / 1 agente / 2 agenti / 3+ agenti','Data-plane type: single / multi','Source-of-Truth Chain','Authority Boundaries','Handoff / Escalation','Proportionality Assessment','Frequenza modifiche fit')
Require-Markers 'REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md' @('0/1/2/3+ agenti','single/multi','Source-of-truth chain','Authority boundaries','Proportionality assessment')
Require-Markers 'REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md' @('Topology discovery esplicito','Handoff/escalation','authority boundaries','proportionality')
Require-Markers 'REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md' @('0/1/2/3+','single/multi data-plane','source-of-truth chain','authority boundaries','handoff/escalation','non obbligatorio')
Require-Markers 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md' @('Discovered topology class','Data-plane type','Authority boundary changes','Handoff/escalation changes','frequenza modifiche')
Require-Markers 'TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md' @('Topology Context','Source-of-truth chain status','Authority Boundaries','Handoff / Escalation')
Require-Markers '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md' @('target_project (required only if target audit esplicito; else N/A)','target_workdir (required only if target audit esplicito; else N/A)','Topology Discovery','Data-plane type: single / multi','Source-of-truth chain status','Authority boundaries status','Frequenza modifiche')

# Fail on fixed-topology obligation
$fixedForbidden = @(
    'default obbligatorio: Manager\+Operativo',
    'Manager\+Operativo obbligatorio',
    'topologia fissa obbligatoria',
    'topologia predefinita obbligatoria'
)
Require-Regex 'AGENTS.md' @('Manager\+Operativo.*non default obbligatorio')
Forbid-Markers 'AGENTS.md' $fixedForbidden
Forbid-Markers '00_GOVERNANCE/PROJECT_CHARTER.md' @('topologia predefinita come obbligatoria')
Forbid-Markers '00_GOVERNANCE/OPERATING_RULES.md' @('Manager\+Operativo obbligatorio','topologia fissa obbligatoria')
Forbid-Markers '00_GOVERNANCE/QUALITY_BAR.md' @('Manager\+Operativo obbligatorio','topologia fissa obbligatoria')

# Current session log markers
Require-Markers '04_SESSION_LOGS/session-2026-05-05.md' @('Topology Discovery Realignment Update - 2026-05-05','target_project: N/A','target_workdir: N/A','proportionality_assessment','next_action') 'P1'

Write-Host "SUMMARY P0=$p0 P1=$p1 P2=$p2 Strict=$Strict"
if ($hasBlocking) {
    Write-Host 'RESULT: FAIL'
    exit 1
} else {
    Write-Host 'RESULT: PASS'
    exit 0
}
