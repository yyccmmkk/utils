git add .
git commit -m 'release before'
npm run release
git add .
git commit -m release

$b = git branch --show-current;

git checkout dev;
git pull origin dev;
git merge $b;
git checkout master;
git pull origin master;
git merge $b;

git push origin --all
git push origin --tags
git checkout $b