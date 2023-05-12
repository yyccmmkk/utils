cd D:/github/pwsh/
git checkout dev;
$ids = @(get-content id.txt);
$watchlist = @(Get-Content setting/watchList.zv);
$today = "{0:yyyy-MM-dd}" -f (get-date);
$list = $ids + $watchlist;


foreach ($id in $ids)
{
    set-content ./logs/$id.txt -value (@("-------------- $today -------------") + (get-content "./logs/$id.txt"));
}
foreach ($wid in $watchlist)
{
    if($wid -notin $ids){
        set-content ./logs/$wid.txt -value (@("-------------- $today -------------") + (get-content "./logs/$wid.txt"));
    }
}



ac ./scheduledJob/log.txt  -value "$today summary done";
git add .
git commit -m $today;
Get-Job | Remove-Job;

git pull z dev;
git push z dev;
git pull origin dev;
git push origin dev;
