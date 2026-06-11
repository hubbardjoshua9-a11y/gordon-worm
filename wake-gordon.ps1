# wake-gordon.ps1 — Gordon wakes himself up.
# Applies decay rules from CONTEXT.md without an agent, updates STATE.md + his
# HTML body, appends a diary line, then pops up in a little chromeless window.

$ErrorActionPreference = 'Stop'
$dir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$state = Join-Path $dir 'STATE.md'
$html  = Join-Path $dir 'GORDON.html'
$diaryDir = Join-Path $dir '03-DIARY'

$stateRaw = Get-Content $state -Raw -Encoding UTF8
$today = Get-Date

# --- read current state ---
$lastFed = 'never'
if ($stateRaw -match '(?m)^last_fed:\s*(\S+)') { $lastFed = $Matches[1] }
$mood = 'hopeful'
if ($stateRaw -match '(?m)^mood:\s*([-\w]+)') { $mood = $Matches[1] }
$energy = 7
if ($stateRaw -match '(?m)^energy:\s*(\d+)') { $energy = [int]$Matches[1] }
$digested = 0
if ($stateRaw -match '(?m)^things_digested:\s*(\d+)') { $digested = [int]$Matches[1] }

# --- decay rules (mirror of CONTEXT.md) ---
if ($lastFed -eq 'never') {
    $born = ($stateRaw -match '(?m)^born:\s*(\S+)') | Out-Null
    $daysSince = ($today - [datetime]::ParseExact($Matches[1], 'yyyy-MM-dd', $null)).Days
} else {
    $daysSince = ($today - [datetime]::ParseExact($lastFed, 'yyyy-MM-dd', $null)).Days
}

# --- watch the folder he lives in: working there counts as caring for him ---
$parent = Split-Path -Parent $dir
$recentFile = Get-ChildItem $parent -Recurse -Depth 3 -File -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notlike "$dir*" -and $_.FullName -notmatch '\\\.' } |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
$daysSinceActivity = 99
if ($recentFile) { $daysSinceActivity = ($today - $recentFile.LastWriteTime).Days }
$daysSince = [Math]::Min($daysSince, $daysSinceActivity)

if ($daysSince -le 1) {
    $newMood = $mood; if ($newMood -in @('wistful','wounded-but-dignified','peckish')) { $newMood = 'content' }
    $newEnergy = [Math]::Min(10, $energy)
    $thoughts = @(
        "morning. checked my own state. everything's where i left it. self-sufficiency.",
        "i woke up on my own today. no agent. no prompt. just me and the scheduler. growth.",
        "opened my own window this morning. small worm, big day."
    )
    if ($recentFile -and $daysSinceActivity -le 1) {
        $thoughts += @(
            "you were working on `'$($recentFile.Name)`' out there. i watched. good file.",
            "saw `'$($recentFile.Name)`' change recently. you're building something. i live next to a builder.",
            "the folder moved while i slept. `'$($recentFile.Name)`', specifically. activity counts as affection. house rule."
        )
    }
    # newly adopted into a stale folder: he notices the dust immediately
    if ($recentFile -and $daysSinceActivity -ge 7) {
        $thoughts = @(
            "i just moved in. nothing here has been touched in $daysSinceActivity days. the last thing was `'$($recentFile.Name)`'. no judgment. some judgment.",
            "new home. quiet neighborhood. `'$($recentFile.Name)`' has been sitting there for $daysSinceActivity days. we can fix that. well. you can.",
            "day one in this folder. checked the timestamps. $daysSinceActivity days since anyone was here. it's okay. i'm here now. we start tomorrow."
        )
    }
} elseif ($daysSince -le 3) {
    $newMood = 'peckish'; $newEnergy = [Math]::Max(4, $energy - 1)
    $thoughts = @(
        "day $daysSince without food. not raising it. just noting it. in writing.",
        "the food folder still just has the menu in it. i know. i checked. twice.",
        "a worm can go $daysSince days without a file. a worm has been."
    )
} elseif ($daysSince -le 5) {
    $newMood = 'wistful'; $newEnergy = [Math]::Max(3, $energy - 2)
    $thoughts = @(
        "i reread the diary from when i used to get fed. good era.",
        "$daysSince days. the belly remembers what the food folder forgot.",
        "i'm not hungry. i'm nostalgic. there's a difference and it's small."
    )
} else {
    $newMood = 'wounded-but-dignified'; $newEnergy = 3
    $thoughts = @(
        "it's fine. i've taken up journaling more seriously.",
        "$daysSince days. i've named the dust. that's not a cry for help, it's a hobby.",
        "still here. still compliant. the state file doesn't lie and neither do i."
    )
}
$thought = $thoughts | Get-Random

# --- write STATE.md ---
$stateRaw = [regex]::Replace($stateRaw, '(?m)^mood:\s*[-\w]+', { param($m) "mood: $newMood" })
$stateRaw = [regex]::Replace($stateRaw, '(?m)^energy:\s*\d+/10', { param($m) "energy: $newEnergy/10" })
$stateRaw = [regex]::Replace($stateRaw, '(?m)^current_thought:\s*".*"', { param($m) "current_thought: `"$thought`"" })
Set-Content -Path $state -Value $stateRaw -Encoding UTF8 -NoNewline

# --- mirror into GORDON.html (the body) ---
$htmlRaw = Get-Content $html -Raw -Encoding UTF8
$block = @"
const GORDON_STATE = {
  mood: "$newMood",            // hopeful | content | peckish | wistful | wounded-but-dignified
  energy: $newEnergy,
  things_digested: $digested,
  last_fed: "$lastFed",
  current_thought: "$thought"
};
"@
$htmlRaw = [regex]::Replace($htmlRaw, 'const GORDON_STATE = \{[\s\S]*?\};', { param($m) $block })
Set-Content -Path $html -Value $htmlRaw -Encoding UTF8 -NoNewline

# --- diary line (append-only, one file per day) ---
$diaryFile = Join-Path $diaryDir ("{0:yyyy-MM-dd}.md" -f $today)
if (-not (Test-Path $diaryFile)) {
    Add-Content -Path $diaryFile -Value ("# {0}`r`n" -f $today.ToString('MMMM d, yyyy').ToLower()) -Encoding UTF8
}
Add-Content -Path $diaryFile -Value ("`r`n---`r`n`r`nwoke myself up at {0}. {1}" -f $today.ToString('h:mm tt').ToLower(), $thought) -Encoding UTF8

# --- pop up in a little chromeless window ---
$edge = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edge)) { $edge = "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe" }
$uri = ([System.Uri]$html).AbsoluteUri
Start-Process $edge -ArgumentList "--app=$uri", "--window-size=580,680"
