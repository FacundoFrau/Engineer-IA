[CmdletBinding()]
param()

Set-StrictMode -Version 2
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$tmp = Join-Path $env:TEMP ("iaeng_owner_routing_tests_" + [DateTime]::UtcNow.ToString('yyyyMMddHHmmss'))
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

function Build-MinimumFixture {
    $files = @(
        'AGENTS.md','README.md',
        '00_GOVERNANCE/PROJECT_CHARTER.md','00_GOVERNANCE/OPERATING_RULES.md','00_GOVERNANCE/QUALITY_BAR.md','00_GOVERNANCE/DECISION_LOG.md',
        '03_VALIDATORS/validate-governance.ps1','03_VALIDATORS/test-validate-governance-negative.ps1',
        '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md','04_SESSION_LOGS/session-2026-05-05.md',
        'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md',
        'REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md',
        'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md','TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md',
        '01_AGENT_DESIGN/README.md','05_SKILLS_CANDIDATES/README.md'
    )
    foreach ($f in $files) { Copy-RepoFile -RelativePath $f }
    $dirs = @('TARGET_PROJECT_AUDITS','REVIEW_PROTOCOLS','OUTPUT_TEMPLATES','TARGET_HANDOFFS','04_SESSION_LOGS','00_GOVERNANCE','01_AGENT_DESIGN','05_SKILLS_CANDIDATES','03_VALIDATORS')
    foreach ($d in $dirs) { New-Item -ItemType Directory -Path (Join-Path $tmp $d) -Force | Out-Null }
    # ensure .git exists for rev-parse in temp
    Push-Location $tmp
    try { git init -q | Out-Null } finally { Pop-Location }
}

function Run-ValidatorExpect {
    param([string]$Label,[bool]$ExpectPass)
    Push-Location $tmp
    try {
        & powershell -File .\03_VALIDATORS\validate-governance.ps1 *> $null
        $ok = ($LASTEXITCODE -eq 0)
        if ($ok -ne $ExpectPass) {
            Write-Host "[FAIL] $Label" -ForegroundColor Red
            $script:failed = $true
        } else {
            Write-Host "[PASS] $Label"
        }
    } finally { Pop-Location }
}

Build-MinimumFixture

# Negative 1: Manager-owned + Operativo primary => FAIL (remove manager-primary marker)
$f1 = Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'
(Get-Content -Raw $f1).Replace('Manager-owned => Manager primary prompt check: pass/fail','') | Set-Content $f1
Run-ValidatorExpect -Label 'NEG1 Manager-owned + Operativo primary marker missing => FAIL' -ExpectPass:$false
Copy-RepoFile -RelativePath 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'

# Negative 2: Operativo-owned without runtime/data-plane scope => FAIL
$f2 = Join-Path $tmp 'TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md'
(Get-Content -Raw $f2).Replace('Operativo prompt only with runtime/data-plane need check: pass/fail','') | Set-Content $f2
Run-ValidatorExpect -Label 'NEG2 Operativo-owned without runtime/data-plane scope marker => FAIL' -ExpectPass:$false
Copy-RepoFile -RelativePath 'TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md'

# Negative 3: Misto without Manager->Operativo sequence => FAIL
$f3 = Join-Path $tmp 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md'
(Get-Content -Raw $f3).Replace('Misto Manager->Operativo sequence check: pass/fail','') | Set-Content $f3
Run-ValidatorExpect -Label 'NEG3 Misto without Manager->Operativo sequence marker => FAIL' -ExpectPass:$false
Copy-RepoFile -RelativePath 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md'

# Negative 4: finding without owner/rationale/scope => FAIL
$f4 = Join-Path $tmp '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md'
$raw4 = Get-Content -Raw $f4
$raw4 = $raw4.Replace('owner: Manager / Operativo / Misto / Nessun agente','')
$raw4 = $raw4.Replace('ownership rationale:','')
$raw4 = $raw4.Replace('modification scope:','')
Set-Content $f4 $raw4
Run-ValidatorExpect -Label 'NEG4 Missing owner/rationale/scope => FAIL' -ExpectPass:$false
Copy-RepoFile -RelativePath '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md'

# Positive 1: Manager-owned + Manager primary + governance scope => PASS
Run-ValidatorExpect -Label 'POS1 Manager-owned + Manager primary + governance scope => PASS' -ExpectPass:$true

# Positive 2: Operativo-owned + Operativo primary + runtime/data-plane scope => PASS
Run-ValidatorExpect -Label 'POS2 Operativo-owned + Operativo primary + runtime/data-plane scope => PASS' -ExpectPass:$true

# Positive 3: Misto + Manager->Operativo sequence => PASS
Run-ValidatorExpect -Label 'POS3 Misto + Manager->Operativo sequence => PASS' -ExpectPass:$true

if ($failed) {
    throw 'Negative/positive ownership validation tests failed.'
}

Write-Host '[TEST] Owner routing negative/positive validator tests passed.'
