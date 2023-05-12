$O = New-ScheduledJobOption -WakeToRun
$T = New-JobTrigger -Weekly -At "15:01" -DaysOfWeek 1,2,3,4,5
$path = "D:\github\pwsh\scripts\summary.ps1"
Register-ScheduledJob -Name "summary-z"  -FilePath $path -ScheduledJobOption $O -Trigger $T
