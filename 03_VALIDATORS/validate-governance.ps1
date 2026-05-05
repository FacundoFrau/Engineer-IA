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

$gitOk = $false
try { if ((git rev-parse --is-inside-work-tree 2>$null) -eq 'true') { $gitOk = $true } } catch {}
if (-not $gitOk) { Add-Finding 'P0' 'Repository Git assente.' } else { Pass 'Repository Git rilevato.' }

if (Test-Path -Path '06_AGENTS' -PathType Container) { Add-Finding 'P0' 'Directory proibita rilevata: 06_AGENTS' } else { Pass 'Directory proibita 06_AGENTS assente.' }

$requiredFiles = @(
    'AGENTS.md','README.md',
    '00_GOVERNANCE/PROJECT_CHARTER.md','00_GOVERNANCE/OPERATING_RULES.md','00_GOVERNANCE/QUALITY_BAR.md','00_GOVERNANCE/DECISION_LOG.md',
    '03_VALIDATORS/validate-governance.ps1','03_VALIDATORS/test-validate-governance-negative.ps1',
    '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md','04_SESSION_LOGS/session-2026-05-05.md',
    'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md',
    'REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md',
    'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md','TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md'
)
foreach ($f in $requiredFiles) { [void](Require-File $f) }

$requiredDirs = @('04_SESSION_LOGS','TARGET_PROJECT_AUDITS','REVIEW_PROTOCOLS','OUTPUT_TEMPLATES','TARGET_HANDOFFS')
foreach ($d in $requiredDirs) { [void](Require-Dir $d) }

Require-Markers 'AGENTS.md' @('Operator Intent & Operational Continuity Gate (Binding)','operator_intent_required','risk_if_unchanged','risk_if_removed','preserve_operability','safe_alternatives','fallback_rollback','P0 consentito solo con rischio bloccante confermato')
Require-Markers '00_GOVERNANCE/OPERATING_RULES.md' @('Operator Intent & Operational Continuity Rules','operator_intent_required','risk_if_unchanged','risk_if_removed','preserve_operability','safe_alternatives','Fallback/rollback obbligatorio')
Require-Markers '00_GOVERNANCE/QUALITY_BAR.md' @('Operator Intent & Operational Continuity','risk_if_unchanged vs risk_if_removed','preserve_operability','fallback_rollback obbligatorio','P0 ammesso solo con rischio bloccante confermato')

$intentMarkers = @('operator_intent_required: yes/no','operator_intent_question:','risk_if_unchanged:','risk_if_removed:','preserve_operability: yes/no','safe_alternatives:','recommended_remediation:','fallback_rollback:')
Require-Markers 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' $intentMarkers
Require-Markers 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md' $intentMarkers
Require-Markers 'TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md' $intentMarkers
Require-Markers '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md' $intentMarkers

Require-Markers 'REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md' @('Operator Intent & Operational Continuity Gate presente','risk_if_unchanged e risk_if_removed presenti','preserve_operability e safe_alternatives presenti','fallback_rollback presente per remediation impattante','P0 usato solo con blocking risk confermato')
Require-Markers 'REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md' @('Operator Intent Gate eseguito prima di remediation distruttive/impattanti','risk_if_unchanged vs risk_if_removed valutati','preserve_operability e safe_alternatives presenti','fallback_rollback presente per remediation impattante','P0 solo con blocking risk confermato')
Require-Markers 'REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md' @('FAIL se manca Operator Intent Gate','FAIL se template consente remediation distruttiva senza operator intent check','FAIL se manca risk_if_unchanged o risk_if_removed','FAIL se manca preserve_operability o safe_alternatives','FAIL se manca fallback_rollback su remediation impattante','FAIL se P0 non richiede blocking risk confermato')

Require-Markers '04_SESSION_LOGS/session-2026-05-05.md' @('Operator Intent & Operational Continuity Gate Update - 2026-05-05','operator_intent_gate: introduced and mandatory','p0_rule: blocking risk confirmed required')

Write-Host "SUMMARY P0=$p0 P1=$p1 P2=$p2 Strict=$Strict"
if ($hasBlocking) { Write-Host 'RESULT: FAIL'; exit 1 } else { Write-Host 'RESULT: PASS'; exit 0 }
