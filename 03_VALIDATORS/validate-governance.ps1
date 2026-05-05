param([switch]$Strict)
$ErrorActionPreference='Stop'
$hasBlocking=$false; $p0=0; $p1=0; $p2=0
function AddF($s,$m){switch($s){'P0'{$script:p0++;$script:hasBlocking=$true};'P1'{$script:p1++;$script:hasBlocking=$true};'P2'{$script:p2++;if($Strict){$script:hasBlocking=$true}}};$t=if($s -eq 'P2' -and -not $Strict){'WARN'}else{'FAIL'};Write-Host "$t [$s] $m"}
function Pass($m){Write-Host "PASS $m"}
function ReqM($p,$ms,[string]$sev='P1'){if(-not(Test-Path $p -PathType Leaf)){AddF $sev "File mancante: $p";return};$c=Get-Content -Raw $p;foreach($m in $ms){if($c -notmatch [regex]::Escape($m)){AddF $sev "Marker mancante in ${p}: ${m}"}};Pass "Marker check eseguito: $p"}

$gitOk=$false; try{if((git rev-parse --is-inside-work-tree 2>$null)-eq 'true'){$gitOk=$true}}catch{}
if(-not $gitOk){AddF 'P0' 'Repository Git assente.'} else {Pass 'Repository Git rilevato.'}

ReqM 'AGENTS.md' @('Engineering Judgment Protocol (EJP) (Binding)','Real System Reconstruction','Critical Hypotheses','Claim-vs-Evidence Matrix','Falsification Attempt','Paper Compliance vs Real Enforcement','Dual Remediation','proven','partially proven','unproven')
ReqM '00_GOVERNANCE/OPERATING_RULES.md' @('Ricostruire funzionamento reale target','Definire ipotesi critiche','Mappare claim dichiarati vs prove reali','Tentare falsificazione','Distinguere compliance documentale vs enforcement reale','dual remediation: minimum sufficient / enterprise ideal')
ReqM '00_GOVERNANCE/QUALITY_BAR.md' @('Required EJP Sections','Real System Reconstruction','Critical Hypotheses','Claim-vs-Evidence Matrix','Falsification Attempt','Paper Compliance vs Real Enforcement','Dual Remediation','proven / partially proven / unproven')
ReqM 'REVIEW_PROTOCOLS/GOVERNANCE_AUDIT_PROTOCOL.md' @('Engineering Judgment Protocol','Claim Verdict')
ReqM 'REVIEW_PROTOCOLS/WORKFLOW_AUDIT_PROTOCOL.md' @('Mandatory EJP Checks','Real System Reconstruction presente','Critical Hypotheses presenti','Claim-vs-Evidence Matrix presente','Falsification Attempt presente','Paper Compliance vs Real Enforcement presente','Dual Remediation presente','Claim verdict presente')
ReqM 'REVIEW_PROTOCOLS/VALIDATOR_AUDIT_PROTOCOL.md' @('FAIL se manca Real System Reconstruction','FAIL se manca Critical Hypotheses','FAIL se manca Claim-vs-Evidence Matrix','FAIL se manca Falsification Attempt','FAIL se manca Paper Compliance vs Real Enforcement','FAIL se manca Dual Remediation','FAIL se manca claim verdict proven/partially proven/unproven')
ReqM 'REVIEW_PROTOCOLS/ENGINEERING_JUDGMENT_CALIBRATION.md' @('Esempio Audit Debole','Esempio Audit Corretto','Segnali di Falso Enterprise','Errori da Evitare')
ReqM 'TARGET_PROJECT_AUDITS/TARGET_AUDIT_RUN_TEMPLATE.md' @('## Real System Reconstruction','## Critical Hypotheses','## Claim-vs-Evidence Matrix','## Falsification Attempt','## Paper Compliance vs Real Enforcement','## Dual Remediation','Verdict: proven / partially proven / unproven')
ReqM 'OUTPUT_TEMPLATES/REMEDIATION_PLAN_TEMPLATE.md' @('## Claim-vs-Evidence Matrix','Verdict: proven / partially proven / unproven','## Dual Remediation')

Write-Host "SUMMARY P0=$p0 P1=$p1 P2=$p2 Strict=$Strict"
if($hasBlocking){Write-Host 'RESULT: FAIL'; exit 1}else{Write-Host 'RESULT: PASS'; exit 0}
