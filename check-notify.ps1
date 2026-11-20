$dir = Join-Path $PSScriptRoot "reminders"
if (-not (Test-Path $dir)) { exit 0 }

Add-Type -AssemblyName System.Windows.Forms
$now = [datetime]::Now

foreach ($f in @(Get-ChildItem "$dir\*.txt" -ErrorAction SilentlyContinue)) {
    if ($f.BaseName -match '^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})_(.*)$') {
        $ts = $Matches[1] + $Matches[2] + $Matches[3] + $Matches[4] + $Matches[5]
        $fire = [datetime]::ParseExact($ts, 'yyyyMMddHHmm', $null)
        if ($fire -le $now) {
            $msg = ((Get-Content $f.FullName) -join "`n").Trim()
            [System.Windows.Forms.MessageBox]::Show($msg, "Bot: $($Matches[6])")
            Remove-Item $f.FullName -Force -ErrorAction SilentlyContinue
        }
    } else {
        Remove-Item $f.FullName -Force -ErrorAction SilentlyContinue
    }
}
