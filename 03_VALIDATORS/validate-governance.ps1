param(
    [switch]$Strict
)
$ErrorActionPreference = 'Stop'
$hasBlocking = $false; $p0=0; $p1=0; $p2=0
function Add-Finding { param([ValidateSet('P0','P1','P2')][string]$Severity,[string]$Message)
 switch($Severity){'P0'{$script:p0++;$script:hasBlocking=$true};'P1'{$script:p1++;$script:hasBlocking=$true};'P2'{$script:p2++;if($Strict){$script:hasBlocking=$true}}}
 $tag=if($Severity -eq 'P2' -and -not $Strict){'WARN'}else{'FAIL'}; Write-Host "$tag [$Severity] $Message" }
function Pass($m){Write-Host "PASS $m"}
function Require-File($p){if(-not(Test-Path $p -PathType Leaf)){Add-Finding 'P1' "File mancante: $p";return $false};Pass "File presente: $p";return $true}
function Require-Markers { param([string]$path,[string[]]$markers,[string]$sev='P1'); if(-not(Test-Path $path -PathType Leaf)){Add-Finding $sev "File mancante per marker check: $path";return}; $c=Get-Content -Raw $path; foreach($m in $markers){ if($c -notmatch [regex]::Escape($m)){ Add-Finding $sev "Marker mancante in ${path}: ${m}"}}; Pass "Marker check eseguito: $path"}

$gitOk=$false; try{ if((git rev-parse --is-inside-work-tree 2>$null)-eq 'true'){$gitOk=$true}}catch{}
if(-not $gitOk){Add-Finding 'P0' 'Repository Git assente.'} else {Pass 'Repository Git rilevato.'}
if(Test-Path '06_AGENTS' -PathType Container){Add-Finding 'P0' 'Directory proibita rilevata: 06_AGENTS'} else {Pass 'Directory proibita 06_AGENTS assente.'}

$files=@('AGENTS.md','00_GOVERNANCE/OPERATING_RULES.md','00_GOVERNANCE/QUALITY_BAR.md','TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md','OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md','TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md','REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md','REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md','04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md','04_SESSION_LOGS/session-2026-05-05.md','03_VALIDATORS/test-validate-governance-negative.ps1')
foreach($f in $files){[void](Require-File $f)}

Require-Markers 'AGENTS.md' @('Language Gate (Binding)','Enterprise Complete Audit Gate (Binding)','Security Severity Gate (Binding)','External Research Gate (Binding)','Operational Prompt Completeness Gate (Binding)')
Require-Markers '00_GOVERNANCE/OPERATING_RULES.md' @('Output operatore in italiano','Audit completo ammesso solo con copertura delle 14 sezioni enterprise minime','non auditato','Security/secrets non confermato => P1','P0 solo se rischio bloccante e segreto confermato valido/operativo/esposto','Operator intent obbligatorio','External research obbligatoria','obiettivo, scope, vincoli, azioni, validazioni, criteri di accettazione, rollback/fallback, output richiesto')
Require-Markers '00_GOVERNANCE/QUALITY_BAR.md' @('Language Gate','Enterprise Complete Audit Gate','Security Severity Gate','Operator Intent and Continuity','External Research Gate','Operational Prompt Completeness')

$cov=@('governance: auditato/non auditato + motivo','topologia agentica: auditato/non auditato + motivo','data-plane: auditato/non auditato + motivo','source-of-truth chain: auditato/non auditato + motivo','authority boundaries: auditato/non auditato + motivo','handoff/escalation: auditato/non auditato + motivo','validator/check: auditato/non auditato + motivo','workflow end-to-end: auditato/non auditato + motivo','release lifecycle: auditato/non auditato + motivo','security/secret hygiene: auditato/non auditato + motivo','logging/evidence: auditato/non auditato + motivo','rollback: auditato/non auditato + motivo','test coverage: auditato/non auditato + motivo','KPI/observability: auditato/non auditato + motivo')
Require-Markers 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' $cov
Require-Markers '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md' $cov

$prompt8=@('obiettivo:','scope:','vincoli:','azioni:','validazioni:','criteri_di_accettazione:','rollback_fallback:','output_richiesto:')
Require-Markers 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' $prompt8
Require-Markers 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md' $prompt8
Require-Markers 'TARGET_HANDOFFS/TARGET_HANDOFF_TEMPLATE.md' $prompt8

Require-Markers 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' @('operator_intent_required: yes/no','risk_if_unchanged:','risk_if_removed:','preserve_operability: yes/no','safe_alternatives:','fallback_rollback:','external_research_required: yes/no','severity_rule_applied: P1 if unconfirmed / P0 if confirmed exposed valid operational','P0 blocking risk confirmed (required if P0):')
Require-Markers 'REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md' @('FAIL se manca Language Gate','FAIL se manca Enterprise Complete Audit coverage','FAIL se manca non auditato + motivo','FAIL se prompt operativo non ha 8 blocchi','FAIL se manca security severity rule P1/P0','FAIL se remediation tecnica/security manca external research trigger')
Require-Markers '04_SESSION_LOGS/session-2026-05-05.md' @('Enterprise Coverage + Language + Security Hardening Update - 2026-05-05')

Write-Host "SUMMARY P0=$p0 P1=$p1 P2=$p2 Strict=$Strict"
if($hasBlocking){Write-Host 'RESULT: FAIL'; exit 1}else{Write-Host 'RESULT: PASS'; exit 0}
