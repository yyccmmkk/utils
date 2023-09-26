$targePath ='D:/project/wx-app/deploy';
if(!(test-path -path "./deploy")){
    mkdir deploy
}else{
    rm -r ./deploy/*
}
if(test-path -path './deploy.zip'){
    rm deploy.zip
}

$path = @(gc setting.z);

foreach($item in $path){
    cd $item;
    $b= git branch --show-current;
    git checkout master;
    npm run build;
    git checkout $b;
}


cd D:/project/behc-org_collect-front
$b= git branch --show-current;
git checkout main
npm run build-stag
git checkout $b;


cd D:/project/ruoyi-front/ruoyi-ui
$b= git branch --show-current;
git checkout main
npm run build:prod
git checkout $b;


cd $targePath
cp ./deploy.ps1 ./deploy/deploy.ps1
7z.exe a -r ./deploy.zip ./deploy
Compress-Archive ./fe_stage3 ./fe_stage3.zip
git add .
git commit -m 'deploy';
git push origin master;
write-host 'zip压缩完成!' -ForegroundColor green
