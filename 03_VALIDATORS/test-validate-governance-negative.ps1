[CmdletBinding()]
param()
Set-StrictMode -Version 2
$ErrorActionPreference='Stop'
$root=Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$tmp=Join-Path $env:TEMP ("iaeng_grounded_recovery_tests_"+[DateTime]::UtcNow.ToString('yyyyMMddHHmmss'))
New-Item -ItemType Directory -Path $tmp -Force|Out-Null
$failed=$false
function C([string]$r){$s=Join-Path $root $r; $d=Join-Path $tmp $r; New-Item -ItemType Directory -Path (Split-Path -Parent $d) -Force|Out-Null; Copy-Item $s $d -Force}
$files=@('AGENTS.md','00_GOVERNANCE/OPERATING_RULES.md','00_GOVERNANCE/QUALITY_BAR.md','TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md','OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md','REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md','04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md','03_VALIDATORS/validate-governance.ps1','03_VALIDATORS/test-validate-governance-negative.ps1')
foreach($f in $files){C $f}
Push-Location $tmp; try{git init -q|Out-Null}finally{Pop-Location}
function E([string]$l,[bool]$p){Push-Location $tmp; try{ & powershell -File .\03_VALIDATORS\validate-governance.ps1 *> $null; $ok=($LASTEXITCODE -eq 0); if($ok -ne $p){Write-Host "[FAIL] $l" -ForegroundColor Red; $script:failed=$true}else{Write-Host "[PASS] $l"}} finally{Pop-Location}}

#1 secret read command present
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; Add-Content $f "`nGet-Content secrets.txt"; E 'NEG1 secret read command => FAIL' $false; C 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'

#2 invented owner without proposed role+rationale
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; $r=Get-Content -Raw $f; $r=$r.Replace('proposed_role (if needed):',''); $r=$r.Replace('role_rationale:',''); Set-Content $f $r; E 'NEG2 invented owner without proposed role+rationale => FAIL' $false; C 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'

#3 missing control/data plane distinction
$f=Join-Path $tmp 'TARGET_PROJECT_AUDIT_RUN_TEMPLATE.md'
if(Test-Path $f){Remove-Item $f -Force}
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; $r=Get-Content -Raw $f; $r=$r.Replace('control_plane_owner:',''); $r=$r.Replace('data_plane_execution_owner:',''); Set-Content $f $r; E 'NEG3 missing control/data plane distinction => FAIL' $false; C 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'

#4 missing WinPE/runtime = data-plane
$f=Join-Path $tmp '00_GOVERNANCE/OPERATING_RULES.md'; (Get-Content -Raw $f).Replace('WinPE/runtime = data-plane','') | Set-Content $f; E 'NEG4 missing WinPE/runtime=data-plane rule => FAIL' $false; C '00_GOVERNANCE/OPERATING_RULES.md'

#5 missing Domain Hypothesis Sweep
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; (Get-Content -Raw $f).Replace('## Domain Hypothesis Sweep','') | Set-Content $f; E 'NEG5 missing Domain Hypothesis Sweep => FAIL' $false; C 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'

#6 invasive without evidence+intent+alternatives
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; $r=Get-Content -Raw $f; $r=$r.Replace('evidence_gate:',''); $r=$r.Replace('operator_intent:',''); $r=$r.Replace('less_invasive_alternatives:',''); Set-Content $f $r; E 'NEG6 invasive without evidence+intent+alternatives => FAIL' $false; C 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'

#7 valid case
E 'POS1 valid safe-evidence+grounded-owner+hypothesis-sweep => PASS' $true

if($failed){throw 'Grounded enterprise recovery negative tests failed.'}
Write-Host '[TEST] Grounded enterprise recovery negative/positive tests passed.'
