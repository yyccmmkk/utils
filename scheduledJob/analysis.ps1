$O = New-ScheduledJobOption -WakeToRun
$T = New-JobTrigger -Weekly -At "15:02" -DaysOfWeek 1,2,3,4,5
$path = "D:\github\pwsh\scripts\analysis.ps1"
Register-ScheduledJob -Name "analysis-z"  -FilePath $path -ScheduledJobOption $O -Trigger $T