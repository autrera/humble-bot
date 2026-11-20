param(
    [Parameter(Mandatory = $true)][string] $Time,
    [Parameter(Mandatory = $true)][string] $Message
)

$bot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\.."))
$dir = Join-Path $bot "reminders"
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$dt = Get-Date $Time
if ($dt -lt (Get-Date)) {
    Write-Error "That time is already past: $($dt.ToString('yyyy-MM-dd HH:mm'))"
    exit 1
}

$slug = ($Message -replace '[^a-zA-Z0-9]+', ' ').Trim().Replace(' ', '-')
if ($slug.Length -gt 40) { $slug = $slug.Substring(0, 40) }
if (-not $slug) { $slug = "note" }

$file = Join-Path $dir ("{0:yyyyMMddHHmm}_{1}.txt" -f $dt, $slug)
Set-Content -Path $file -Value $Message
Write-Host "Reminder set: $Message for $($dt.ToString('yyyy-MM-dd HH:mm')) ($file)"

$task = "BotNotify"
$exists = $false
$null = schtasks /Query /TN $task 2>$null
if ($LASTEXITCODE -eq 0) { $exists = $true }
if (-not $exists) {
    $checker = 'powershell -NoProfile -ExecutionPolicy Bypass -File "' + (Join-Path $PSScriptRoot 'check-notify.ps1') + '"'
    schtasks /Create /TN $task /TR $checker /SC MINUTE /MO 1 | Out-Null
    Write-Host "Scheduled the BotNotify checker (runs every minute)."
}
