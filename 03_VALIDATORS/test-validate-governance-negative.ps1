[CmdletBinding()]
param()
Set-StrictMode -Version 2
$ErrorActionPreference='Stop'
$root=Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$tmp=Join-Path $env:TEMP ("iaeng_ejp_tests_"+[DateTime]::UtcNow.ToString('yyyyMMddHHmmss'))
New-Item -ItemType Directory -Path $tmp -Force|Out-Null
$failed=$false
function C([string]$r){$s=Join-Path $root $r; $d=Join-Path $tmp $r; New-Item -ItemType Directory -Path (Split-Path -Parent $d) -Force|Out-Null; Copy-Item $s $d -Force}
$files=@('AGENTS.md','00_GOVERNANCE/OPERATING_RULES.md','00_GOVERNANCE/QUALITY_BAR.md','REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/ENGINEERING_JUDGMENT_CALIBRATION.md','TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md','OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md','03_VALIDATORS/validate-governance.ps1','03_VALIDATORS/test-validate-governance-negative.ps1')
foreach($f in $files){C $f}
Push-Location $tmp; try{git init -q|Out-Null}finally{Pop-Location}
function E([string]$l,[bool]$p){Push-Location $tmp; try{ & powershell -File .\03_VALIDATORS\validate-governance.ps1 *> $null; $ok=($LASTEXITCODE -eq 0); if($ok -ne $p){Write-Host "[FAIL] $l" -ForegroundColor Red; $script:failed=$true}else{Write-Host "[PASS] $l"}} finally{Pop-Location}}

$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; (Get-Content -Raw $f).Replace('## Real System Reconstruction','')|Set-Content $f; E 'NEG1 missing Real System Reconstruction => FAIL' $false; C 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; (Get-Content -Raw $f).Replace('## Critical Hypotheses','')|Set-Content $f; E 'NEG2 missing Critical Hypotheses => FAIL' $false; C 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; (Get-Content -Raw $f).Replace('## Claim-vs-Evidence Matrix','')|Set-Content $f; E 'NEG3 missing Claim-vs-Evidence Matrix => FAIL' $false; C 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; (Get-Content -Raw $f).Replace('## Falsification Attempt','')|Set-Content $f; E 'NEG4 missing Falsification Attempt => FAIL' $false; C 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; (Get-Content -Raw $f).Replace('## Paper Compliance vs Real Enforcement','')|Set-Content $f; E 'NEG5 missing Paper vs Enforcement => FAIL' $false; C 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; (Get-Content -Raw $f).Replace('## Dual Remediation','')|Set-Content $f; E 'NEG6 missing Dual Remediation => FAIL' $false; C 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'
$f=Join-Path $tmp 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md'; (Get-Content -Raw $f).Replace('Verdict: proven / partially proven / unproven','Verdict:')|Set-Content $f; E 'NEG7 claim without verdict => FAIL' $false; C 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md'
E 'POS1 complete EJP case => PASS' $true
if($failed){throw 'EJP negative tests failed.'}
Write-Host '[TEST] EJP negative/positive validator tests passed.'

