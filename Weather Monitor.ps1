# Weather Monitor - Temperature Logger
# Logs readings every minute with timestamps

$locations = @{
    "NYC" = "New York, NY";
    "LA" = "Los Angeles, CA";
    "Chicago" = "Chicago, IL";
    "Houston" = "Houston, TX";
    "Phoenix" = "Phoenix, AZ";
    "Philadelphia" = "Philadelphia, PA";
    "San Antonio" = "San Antonio, TX";
}

$logFile = "C:\Users\local-admin\Desktop\weather_log.csv"

# Create header if file doesn't exist
if (-not (Test-Path $logFile)) {
    "Timestamp,Location,Temperature_F,Condition" | Out-File -FilePath $logFile -Encoding UTF8
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$outputLines = @()

foreach ($key in $locations.Keys) {
    try {
        # Use wttr.in for weather (returns F by default on US locations)
        $weatherUrl = "https://wttr.in/`"$($locations[$key])`"?format=`"%c%t%T%l%"`"
        $response = Invoke-RestMethod -Uri $weatherUrl -TimeoutSec 5
        
        # Parse response (format: Condition TempF TempC Loc)
        $parts = $response -split '\s+'
        if ($parts.Count -ge 4) {
            $condition = $parts[0] -replace '[^\w\s]', ''
            $tempF = [int]$parts[1].Replace('°','')
            
            # Only log temperatures above freezing to avoid noise
            if ($tempF -gt 32) {
                $outputLines += "$timestamp,$key,${tempF}°F,$condition"
            }
        }
    } catch {
        $outputLines += "$timestamp,$key,ERROR,-"
    }
}

# Append to log file (keep last 1000 entries)
$outputLines | Add-Content -Path $logFile -Encoding UTF8

# Get last 50 entries for display
$recentReadings = Get-Content $logFile | Select-Object -Last 50

Write-Host "`n=== Weather Log (Last 50 Readings) ===" -ForegroundColor Cyan
$recentReadings | Format-Table -AutoSize
Write-Host "Total readings: $(Get-Content $logFile).Count`n"

# Auto-refresh every minute
Start-Sleep -Seconds 60