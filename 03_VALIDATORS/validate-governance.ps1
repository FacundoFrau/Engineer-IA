param([switch]$Strict)
$ErrorActionPreference='Stop'
$hasBlocking=$false;$p0=0;$p1=0;$p2=0
function AddF($s,$m){switch($s){'P0'{$script:p0++;$script:hasBlocking=$true};'P1'{$script:p1++;$script:hasBlocking=$true};'P2'{$script:p2++;if($Strict){$script:hasBlocking=$true}}};$t=if($s -eq 'P2' -and -not $Strict){'WARN'}else{'FAIL'};Write-Host "$t [$s] $m"}
function Pass($m){Write-Host "PASS $m"}
function ReqM($p,$ms,[string]$sev='P1'){if(-not(Test-Path $p -PathType Leaf)){AddF $sev "File mancante: $p";return};$c=Get-Content -Raw $p; foreach($m in $ms){if($c -notmatch [regex]::Escape($m)){AddF $sev "Marker mancante in ${p}: ${m}"}}; Pass "Marker check eseguito: $p"}
function ForbidRegex($p,$patterns,[string]$sev='P1'){if(-not(Test-Path $p -PathType Leaf)){AddF $sev "File mancante: $p";return};$c=Get-Content -Raw $p; foreach($pat in $patterns){if([regex]::IsMatch($c,$pat)){AddF $sev "Pattern proibito in ${p}: ${pat}"}}; Pass "Forbidden check eseguito: $p"}

$gitOk=$false; try{if((git rev-parse --is-inside-work-tree 2>$null)-eq 'true'){$gitOk=$true}}catch{}
if(-not $gitOk){AddF 'P0' 'Repository Git assente.'} else {Pass 'Repository Git rilevato.'}

ReqM 'AGENTS.md' @('Safe Evidence Collection (Binding)','Role Grounding (Binding)','Data-Plane Clarity (Binding)','Deep Gap Discovery (Binding)','Domain Hypothesis Sweep (Binding)','Invasive Architecture Gate (Binding)')
ReqM '00_GOVERNANCE/OPERATING_RULES.md' @('Safe Evidence Collection','Role Grounding','Plane Clarity','WinPE/runtime = data-plane','Domain Hypothesis Sweep','Invasive Architecture Gate')
ReqM '00_GOVERNANCE/QUALITY_BAR.md' @('Safe Evidence','Grounded Ownership','Plane Clarity','WinPE/runtime classificato data-plane','Domain Hypothesis Sweep','Invasive Gate')
ReqM 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' @('## Safe Evidence Collection','## Role Grounding','## Plane Clarity','## Deep Gap Discovery','## Domain Hypothesis Sweep','## Invasive Architecture Gate','control_plane_owner:','data_plane_execution_owner:','winpe_runtime_classification: data-plane','proposed_role (if needed):','role_rationale:','evidence_gate:','operator_intent:','less_invasive_alternatives:')
ReqM 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md' @('## Role Grounding','## Plane Clarity','## Domain Hypothesis Sweep Coverage','## Invasive Architecture Gate')
ReqM 'REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md' @('FAIL se manca Safe Evidence Collection','FAIL se template/protocollo permette `Get-Content` su `secrets*`/`*.pfx`/`*.key`/`token*`','FAIL se owner inventato senza `proposed role` + rationale','FAIL se manca distinzione control-plane owner / data-plane execution owner','FAIL se manca regola WinPE/runtime = data-plane','FAIL se manca Domain Hypothesis Sweep','FAIL se proposta invasiva senza evidence gate + operator intent + alternative meno invasive')
ReqM '04_SESSION_LOGS/SESSION_LOG_TEMPLATE.md' @('## Safe Evidence Collection','## Role Grounding','## Plane Clarity','## Deep Gap Discovery','## Domain Hypothesis Sweep','## Invasive Architecture Gate')

ForbidRegex 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' @('(?im)^\s*Get-Content\s+.*secrets','(?im)^\s*Get-Content\s+.*\.pfx','(?im)^\s*Get-Content\s+.*\.key','(?im)^\s*Get-Content\s+.*token')

Write-Host "SUMMARY P0=$p0 P1=$p1 P2=$p2 Strict=$Strict"
if($hasBlocking){Write-Host 'RESULT: FAIL';exit 1}else{Write-Host 'RESULT: PASS';exit 0}
