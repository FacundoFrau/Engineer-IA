[CmdletBinding()]
param()
Set-StrictMode -Version 2
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$tmp = Join-Path $env:TEMP ("iaeng_cov_lang_sec_tests_" + [DateTime]::UtcNow.ToString('yyyyMMddHHmmss'))
New-Item -ItemType Directory -Path $tmp -Force | Out-Null
$failed=$false
function CopyF([string]$r){$s=Join-Path $root $r; $d=Join-Path $tmp $r; New-Item -ItemType Directory -Path (Split-Path -Parent $d) -Force | Out-Null; Copy-Item $s $d -Force}
$files=@('AGENTS.md','00_GOVERNANCE/OPERATING_RULES.md','00_GOVERNANCE/QUALITY_BAR.md','TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md','OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md','TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md','REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md','04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md','04_SESSION_LOGS/session-2026-05-05.md','03_VALIDATORS/validate-governance.ps1','03_VALIDATORS/test-validate-governance-negative.ps1','README.md')
foreach($f in $files){CopyF $f}
Push-Location $tmp; try{git init -q|Out-Null}finally{Pop-Location}
function ExpectV([string]$label,[bool]$pass){Push-Location $tmp; try{ & powershell -File .\03_VALIDATORS\validate-governance.ps1 *> $null; $ok=($LASTEXITCODE -eq 0); if($ok -ne $pass){Write-Host "[FAIL] $label" -ForegroundColor Red; $script:failed=$true}else{Write-Host "[PASS] $label"}} finally{Pop-Location}}

#1 missing Language Gate
$f=Join-Path $tmp 'AGENTS.md'; (Get-Content -Raw $f).Replace('## Language Gate (Binding)','## Language Gate (REMOVED)') | Set-Content $f
ExpectV 'NEG1 missing Language Gate => FAIL' $false
CopyF 'AGENTS.md'

#2 audit completo without full sections/non-auditato reason
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; (Get-Content -Raw $f).Replace('KPI/observability: auditato/non auditato + motivo','KPI/observability:') | Set-Content $f
ExpectV 'NEG2 incomplete audit coverage/non-auditato reason => FAIL' $false
CopyF 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'

#3 prompt without 8 blocks
$f=Join-Path $tmp 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md'; (Get-Content -Raw $f).Replace('rollback_fallback:','') | Set-Content $f
ExpectV 'NEG3 prompt missing one of 8 blocks => FAIL' $false
CopyF 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md'

#4 security finding without P1/P0 rule
$f=Join-Path $tmp '00_GOVERNANCE/OPERATING_RULES.md'; $r=Get-Content -Raw $f; $r=$r.Replace('Security/secrets non confermato => P1.',''); $r=$r.Replace('P0 solo se rischio bloccante e segreto confermato valido/operativo/esposto.',''); Set-Content $f $r
ExpectV 'NEG4 security finding without P1/P0 rule => FAIL' $false
CopyF '00_GOVERNANCE/OPERATING_RULES.md'

#5 remediation technical/security without external research trigger
$f=Join-Path $tmp 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'; (Get-Content -Raw $f).Replace('external_research_required: yes/no','') | Set-Content $f
ExpectV 'NEG5 missing external research trigger => FAIL' $false
CopyF 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md'

#6 valid case
ExpectV 'POS1 valid complete case => PASS' $true

if($failed){ throw 'Coverage/language/security negative tests failed.' }
Write-Host '[TEST] Coverage/language/security negative/positive validator tests passed.'
