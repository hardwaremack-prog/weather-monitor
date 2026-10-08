# Weather Monitor

A simple weather board for seven US cities that refreshes every minute and keeps a log of the readings.

![Weather Monitor screenshot](<Weather Monitor - screenshot.png>)

## What it does

- Shows the current temperature (°F) for New York, Los Angeles, Chicago, Houston, Phoenix, Philadelphia and San Antonio
- Shows how much each city went up or down since the last check
- Keeps a temperature log table, with **Refresh Now** and **Clear Log** buttons
- Updates on its own every 60 seconds using wttr.in

## Run it

**Browser:** download `Weather Monitor.html` and open it in your web browser. It needs an internet connection.

**PowerShell:** `Weather Monitor.ps1` logs the same seven cities every minute to `weather_log.csv` from a PowerShell window. Change the `$logFile` path near the top to a folder on your PC.

---
Made by hardwaremack.
