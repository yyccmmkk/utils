[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

function notify
{
    param(
        [string]
        [Parameter(Mandatory, Position = 0)]
        $type,
        [string]
        [Parameter(Mandatory, Position = 1)]
        $volume,
        [string]
        [Parameter(Mandatory, Position = 2)]
        $ids
    )


    Start-ThreadJob {
        $objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon
        $objNotifyIcon.Icon = "$pwd\favicon.ico"
        $objNotifyIcon.BalloonTipIcon = ($using:type -eq "B") ? "Info" :"Error"
        $objNotifyIcon.BalloonTipText = "Erorr Code [$using:type]x$using:volume"
        $objNotifyIcon.BalloonTipTitle = "Memory exception at 0x$using:ids"
        $objNotifyIcon.Visible = $True
        $objNotifyIcon.ShowBalloonTip(2000)
        $objNotifyIcon.dispose()

    } | Wait-Job | Receive-Job| Remove-Job


}
