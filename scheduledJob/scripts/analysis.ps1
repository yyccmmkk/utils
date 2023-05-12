$basepath = "D:\github\pwsh";
. "$basepath\idMap.ps1";
$date = "{0:yyyy-MM-dd}" -f  (get-date);

add-content "$basepath\scheduledJob\log.txt"  -value "$date analysis job done"


if (!(Test-Path -path "$basepath\analysis"))
{
    mkdir "$basepath\analysis";
}
$watchlist = @(gc "$basepath\setting\watchList.zv");
$mainid = @(Get-Content "$basepath\id.txt");
$ids =  $mainid + $watchlist;
$p = gc "$basepath\setting\p.sz"
$word =  gc "$basepath\setting\s.zv"
$w = ConvertTo-SecureString -String $word -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $p, $w

$pic='';

foreach($zid in $ids){
    $text = @();
    if(!(test-path "$basepath\logs\$zid.txt")){
        continue
    }
    $logs = @(Get-Content "$basepath\logs\$zid.txt");
    $start = 0;
    $end = 0;
    $i = 0;
    $name = $idMap[$zid];
    foreach($item in $logs){

        if(!($item  -match "-{4,}|15:00:00") -and $start -eq 0){
            $start = $i;
        }
        if($item  -match "-{4,}|09:25:00" -and $i -ne 0){
            $end = $i;
            break
        }
        $i++;
    }
    if($start -ne 0 -and $end -ne 1){
        $list = $logs[$start..$end];
        $sCount = 0;
        $bCount = 0;
        $B = 0;
        $S = 0
        $bc = 0;
        $sc = 0;
        $width = 40;
        $length = 0;

        foreach ($log in $list)
        {
            $temp = 0;
            if ($log -match '\d{3,}$')
            {
                $temp = $matches[0];
            }
            if ($log -eq '')
            {
                continue
            }
            if ($log -match 'B')
            {
                $bCount++;
                $B++;
                $bc += $temp;
                $length++
            }
            if ($log -match 'S')
            {
                $sCount++;
                $S++;
                $sc += $temp;
                $length++
            }

        }

        $bStr = '';
        $sStr = '';

        $boStr = '';
        $soStr = '';

        if ($list.length -gt $width * 2)
        {
            $bCount = $bCount / $length * $width;
            $sCount = $sCount / $length * $width;
        }

        for($i = 0; $i -lt $bCount; $i++){
            $bStr += '=';
        }

        for($i = 0; $i -lt $sCount; $i++){
            $sStr += '=';
        }

        for($i = 0; $i -lt $bc/($bc + $sc)*$width; $i++){
            $boStr += '=';
        }

        for($i = 0; $i -lt $sc/($bc + $sc)*$width; $i++){
            $soStr += '=';
        }

        $pic += "<span foreground=`"white`" background=`"black`">$zid  </span><span foreground=`"white`" background=`"black`"> 笔： $B/$S     </span>\n<span foreground=`"red`" background=`"red`">$bStr</span><span foreground=`"green`" background=`"green`">$sStr</span>\n\n<span foreground=`"white`" background=`"black`">$zid  </span><span foreground=`"white`" background=`"black`"> 手： $bc/$sc       </span>\n<span foreground=`"red`" background=`"red`">$boStr</span><span foreground=`"green`" background=`"green`">$soStr</span>\n\n"

        $text +="------------------ $name $zid --------------------"
        $text += "$name 买：$B 笔|" + ("{0:p2}" -f ($B / $list.length)) + " 卖：$S 笔|" + ("{0:p2}" -f ($S / $list.length)) ;
        $text += "$name 买：$bc 手|" + ("{0:p2}" -f ($bc / ($bc + $sc))) + " 卖：$sc 手|" + ("{0:p2}" -f ($sc / ($bc + $sc)));
        ac  "$basepath\analysis\$date.txt" -value ($text -join "`n");
    }

}
set-content "$basepath\src\str.js" ('exports.str =`\n' + $pic + '`;'+'exports.date = "'+ $date +'";');
cd "$basepath\src";
node main.js;

if (Test-Path -path "$basepath\analysis\$date.txt")
{
    Send-MailMessage -From 'pwsh <xxxx@163.com>' -To xxxxxxxx@163.com -Subject "$date " -Body "result" -Attachments "$basepath\analysis\$date.txt","$basepath\analysis\$date.png"  -Priority High  -SmtpServer 'smtp.163.com' -Credential $Credential -UseSsl  -WarningAction:SilentlyContinue -Encoding utf8
}else{
    Send-MailMessage -From 'pwsh <xxxx@163.com>' -To xxxxxxxx@163.com -Subject "$date " -Body "nothing"  -Priority High  -SmtpServer 'smtp.163.com' -Credential $Credential -UseSsl  -WarningAction:SilentlyContinue -Encoding utf8
}
