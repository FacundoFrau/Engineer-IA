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

function Require-NotVague {
    param([string]$path,[string[]]$sections)
    if (-not (Test-Path -Path $path -PathType Leaf)) { Add-Finding 'P1' "File mancante per vague check: $path"; return }
    $c = Get-Content -Path $path -Raw
    foreach ($s in $sections) {
        if ($c -notmatch [regex]::Escape($s)) { Add-Finding 'P1' "Sezione mancante in ${path}: ${s}" }
    }
    $bad = @('TODO','TBD','da definire')
    foreach ($b in $bad) {
        if ($c -match [regex]::Escape($b)) { Add-Finding 'P2' "Placeholder vago trovato in ${path}: ${b}" }
    }
    Pass "Vagueness check eseguito: $path"
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

# Required structure
$requiredFiles = @(
    'AGENTS.md','README.md',
    '00_GOVERNANCE/PROJECT_CHARTER.md','00_GOVERNANCE/OPERATING_RULES.md','00_GOVERNANCE/QUALITY_BAR.md','00_GOVERNANCE/DECISION_LOG.md',
    '01_AGENT_DESIGN/AGENT_SPEC_TEMPLATE.md','01_AGENT_DESIGN/TASK_MODEL_TEMPLATE.md','01_AGENT_DESIGN/EVALUATION_TEMPLATE.md','01_AGENT_DESIGN/HANDOFF_TEMPLATE.md',
    '02_WORKFLOWS/SESSION_BOOTSTRAP.md','02_WORKFLOWS/AGENT_CREATION_WORKFLOW.md','02_WORKFLOWS/AGENT_REVIEW_WORKFLOW.md','02_WORKFLOWS/RELEASE_CHECKLIST.md',
    '03_VALIDATORS/validate-governance.ps1','04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md','05_SKILLS_CANDIDATES/README.md'
)
foreach ($f in $requiredFiles) { [void](Require-File $f) }
[void](Require-Dir '04_SESSION_LOGS')

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

# Cross-doc common markers
Require-Markers 'AGENTS.md' @('AI Engineer / Principal Agent Architect','Divieto di compiacenza','Evidenza > opinione','Qualità enterprise > preferenze operatore')
Require-Markers '00_GOVERNANCE/QUALITY_BAR.md' @('No Regressioni','No Output Generico','No Source-of-Truth Duplicata')
Require-Markers '02_WORKFLOWS/SESSION_BOOTSTRAP.md' @('bootstrap e obbligatorio','Divieto di chiedere contesto se deducibile','Mandatory Session Log Update')

# Agent template minimum required fields and anti-vagueness
Require-NotVague '01_AGENT_DESIGN/AGENT_SPEC_TEMPLATE.md' @(
    '## Scope','## Non-scope','## Inputs','## Outputs','## Tools','Allowed:','Disallowed:','Tool policy',
    '## Failure modes','## Validation protocol','Metrics and thresholds','Evidence required','Pass/Fail gates','## Acceptance criteria'
)

# Session log validity markers
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

