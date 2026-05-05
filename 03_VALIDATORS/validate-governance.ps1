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

$gitOk = $false
try {
    $inside = git rev-parse --is-inside-work-tree 2>$null
    if ($inside -eq 'true') { $gitOk = $true }
} catch { }
if (-not $gitOk) { Add-Finding 'P0' 'Repository Git assente.' } else { Pass 'Repository Git rilevato.' }

if (Test-Path -Path '06_AGENTS' -PathType Container) {
    Add-Finding 'P0' 'Directory proibita rilevata: 06_AGENTS'
} else {
    Pass 'Directory proibita 06_AGENTS assente.'
}

$requiredFiles = @(
    'AGENTS.md','README.md',
    '00_GOVERNANCE/PROJECT_CHARTER.md','00_GOVERNANCE/OPERATING_RULES.md','00_GOVERNANCE/QUALITY_BAR.md','00_GOVERNANCE/DECISION_LOG.md',
    '03_VALIDATORS/validate-governance.ps1','03_VALIDATORS/test-validate-governance-negative.ps1',
    '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md','04_SESSION_LOGS/session-2026-05-05.md',
    'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md',
    'REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md',
    'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md','TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md',
    '01_AGENT_DESIGN/README.md','05_SKILLS_CANDIDATES/README.md'
)
foreach ($f in $requiredFiles) { [void](Require-File $f) }

$requiredDirs = @('04_SESSION_LOGS','TARGET_PROJECT_AUDITS','REVIEW_PROTOCOLS','OUTPUT_TEMPLATES','TARGET_HANDOFFS')
foreach ($d in $requiredDirs) { [void](Require-Dir $d) }

$logs = @()
if (Test-Path '04_SESSION_LOGS') {
    $logs = Get-ChildItem '04_SESSION_LOGS' -File | Where-Object { $_.Name -ne 'SESSION_LOG_TEMPLATE.md' -and $_.Extension -eq '.md' }
}
if ($logs.Count -lt 1) { Add-Finding 'P1' 'Session log reale mancante in 04_SESSION_LOGS.' } else { Pass 'Session log reale presente.' }

Require-Markers 'AGENTS.md' @(
    'Owner Routing Gate (Binding)',
    'Owner enum obbligatorio: `Manager` / `Operativo` / `Misto` / `Nessun agente`',
    'Manager-owned => Manager primary prompt',
    'Operativo prompt solo se il fix richiede runtime/data-plane changes',
    'Misto => Manager prima definisce piano/autorita, Operativo dopo autorizzazione',
    'Vietato Operativo primary prompt come default solo per esistenza Operativo'
)

Require-Markers '00_GOVERNANCE/OPERATING_RULES.md' @(
    'Owner Routing Gate obbligatorio prima della generazione prompt',
    'Owner enum: Manager / Operativo / Misto / Nessun agente',
    'Manager-owned => Manager primary prompt',
    'Operativo prompt solo con runtime/data-plane need esplicito',
    'Misto => Manager->Operativo sequence obbligatoria',
    'Vietato default Operativo primary prompt per sola presenza Operativo'
)

Require-Markers '00_GOVERNANCE/QUALITY_BAR.md' @(
    'Owner Routing Enforcement',
    'Owner enum obbligatorio: Manager / Operativo / Misto / Nessun agente',
    'Manager-owned richiede Manager primary prompt',
    'Operativo prompt ammesso solo con runtime/data-plane need',
    'Misto richiede Manager->Operativo sequence',
    'Required Finding Fields'
)

$ownerMarkers = @(
    'owner: Manager / Operativo / Misto / Nessun agente',
    'ownership rationale:',
    'modification scope:',
    'primary prompt:',
    'secondary prompt (if applicable):',
    'escalation trigger/path:'
)
Require-Markers 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' $ownerMarkers
Require-Markers 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md' $ownerMarkers
Require-Markers 'TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md' $ownerMarkers
Require-Markers '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md' $ownerMarkers

Require-Markers 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' @('Manager-owned => Manager primary prompt check: pass/fail','Operativo prompt only with runtime/data-plane need check: pass/fail','Misto Manager->Operativo sequence check: pass/fail')
Require-Markers 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md' @('Manager-owned => Manager primary prompt check: pass/fail','Operativo prompt only with runtime/data-plane need check: pass/fail','Misto Manager->Operativo sequence check: pass/fail')
Require-Markers 'TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md' @('Manager-owned => Manager primary prompt check: pass/fail','Operativo prompt only with runtime/data-plane need check: pass/fail','Misto Manager->Operativo sequence check: pass/fail')

Require-Markers 'REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md' @('Owner Routing Gate presente','Owner enum presente','Manager-owned => Manager primary prompt applicata','Operativo prompt solo con runtime/data-plane need','Misto con Manager->Operativo sequence')
Require-Markers 'REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md' @('Owner Routing Gate eseguito prima dei prompt','Manager-owned produce Manager primary prompt','Operativo-owned produce Operativo primary prompt solo con runtime/data-plane scope','Misto include sequenza Manager->Operativo','Finding senza owner/rationale/scope e bloccante')
Require-Markers 'REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md' @('FAIL se manca Owner Routing section','FAIL se manca owner enum','FAIL se mancano ownership rationale/modification scope/prompt/escalation fields','FAIL se manca regola Manager-owned => Manager primary prompt','FAIL se manca regola Operativo prompt solo con runtime/data-plane need','FAIL se manca regola Misto Manager->Operativo sequence','FAIL se manca regola Nessun agente evidence-based')

Forbid-Markers 'AGENTS.md' @('Operativo primary prompt di default')

Require-Markers '04_SESSION_LOGS/session-2026-05-05.md' @('Owner Routing Enforcement Update - 2026-05-05','owner_routing_gate: introduced and mandatory','manager_primary_rule: enforced','operativo_scope_rule: runtime/data-plane required','misto_sequence_rule: Manager->Operativo enforced')

Write-Host "SUMMARY P0=$p0 P1=$p1 P2=$p2 Strict=$Strict"
if ($hasBlocking) {
    Write-Host 'RESULT: FAIL'
    exit 1
} else {
    Write-Host 'RESULT: PASS'
    exit 0
}
