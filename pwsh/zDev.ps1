git add .;
git commit -m 'debug';

$b= git branch --show-current;
git checkout dev;
git pull origin dev;
git merge $b;
git push origin dev
. ./deploy.ps1
git checkout $b;