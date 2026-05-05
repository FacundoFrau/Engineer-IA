[CmdletBinding()]
param()

Set-StrictMode -Version 2
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$tmp = Join-Path $env:TEMP ("iaeng_operator_intent_tests_" + [DateTime]::UtcNow.ToString('yyyyMMddHHmmss'))
New-Item -ItemType Directory -Path $tmp -Force | Out-Null

$failed = $false

function Copy-RepoFile {
    param([string]$RelativePath)
    $src = Join-Path $root $RelativePath
    $dst = Join-Path $tmp $RelativePath
    $dir = Split-Path -Parent $dst
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Copy-Item -LiteralPath $src -Destination $dst -Force
}

function Build-Fixture {
    $files = @(
        'AGENTS.md','README.md',
        '00_GOVERNANCE/PROJECT_CHARTER.md','00_GOVERNANCE/OPERATING_RULES.md','00_GOVERNANCE/QUALITY_BAR.md','00_GOVERNANCE/DECISION_LOG.md',
        '03_VALIDATORS/validate-governance.ps1','03_VALIDATORS/test-validate-governance-negative.ps1',
        '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md','04_SESSION_LOGS/session-2026-05-05.md',
        'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md',
        'REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md',
        'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md','TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md'
    )
    foreach ($f in $files) { Copy-RepoFile -RelativePath $f }
    Push-Location $tmp
    try { git init -q | Out-Null } finally { Pop-Location }
}

function Expect-Validation {
    param([string]$Label,[bool]$Pass)
    Push-Location $tmp
    try {
        & powershell -File .\03_VALIDATORS\validate-governance.ps1 *> $null
        $ok = ($LASTEXITCODE -eq 0)
        if ($ok -ne $Pass) { Write-Host "[FAIL] $Label" -ForegroundColor Red; $script:failed = $true }
        else { Write-Host "[PASS] $Label" }
    } finally { Pop-Location }
}

Build-Fixture

# NEG1 missing operator_intent_required
$f = Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'
(Get-Content -Raw $f).Replace('operator_intent_required: yes/no','') | Set-Content $f
Expect-Validation -Label 'NEG1 missing operator_intent_required => FAIL' -Pass:$false
Copy-RepoFile -RelativePath 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'

# NEG2 missing risk_if_unchanged / risk_if_removed
$f = Join-Path $tmp 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md'
$raw = Get-Content -Raw $f
$raw = $raw.Replace('risk_if_unchanged:','').Replace('risk_if_removed:','')
Set-Content $f $raw
Expect-Validation -Label 'NEG2 missing risk_if_unchanged/risk_if_removed => FAIL' -Pass:$false
Copy-RepoFile -RelativePath 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md'

# NEG3 missing safe_alternatives / preserve_operability
$f = Join-Path $tmp 'TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md'
$raw = Get-Content -Raw $f
$raw = $raw.Replace('preserve_operability: yes/no','').Replace('safe_alternatives:','')
Set-Content $f $raw
Expect-Validation -Label 'NEG3 missing safe_alternatives/preserve_operability => FAIL' -Pass:$false
Copy-RepoFile -RelativePath 'TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md'

# NEG4 missing fallback_rollback on impactful remediation
$f = Join-Path $tmp '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md'
(Get-Content -Raw $f).Replace('fallback_rollback:','') | Set-Content $f
Expect-Validation -Label 'NEG4 missing fallback_rollback => FAIL' -Pass:$false
Copy-RepoFile -RelativePath '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md'

# NEG5 P0 without confirmed blocking risk
$f = Join-Path $tmp 'AGENTS.md'
$raw = Get-Content -Raw $f
$raw = [regex]::Replace($raw, '(?m)^.*P0 consentito solo con rischio bloccante confermato.*\r?\n', '')
Set-Content $f $raw
Expect-Validation -Label 'NEG5 P0 without confirmed blocking risk marker => FAIL' -Pass:$false
Copy-RepoFile -RelativePath 'AGENTS.md'

# POS1 valid operator intent + safe alternative + rollback => PASS
Expect-Validation -Label 'POS1 valid operator intent + safe alternative + rollback => PASS' -Pass:$true

if ($failed) { throw 'Operator intent negative tests failed.' }
Write-Host '[TEST] Operator intent negative/positive validator tests passed.'
