rm -r ../app/vueMixin/dist
rm ../app.zip
cp -r ./dist ../app/vueMixin/
node ./deploy.js
write-host '自动迁移完成!' -ForegroundColor green
7z.exe a  -r ../app.zip ../app
7z.exe d -r ../app.zip  .idea
7z.exe d -r ../app.zip  .git
write-host 'zip压缩完成!' -ForegroundColor green
