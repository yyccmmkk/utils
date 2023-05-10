const fs = require('node:fs');
const path = require('node:path');
const filePath = path.resolve('./dist');
const indexPath = path.resolve('../app/left.html');
const ignorePathRegExp = /node_modules/;
const needCheckFileRegExp = /(app|chunk-vendors)\.([^.]+)\.(js|css)$/;
const regExp = {
  jsApp: /app\.([^.]{8})\.js/g,
  jsVendor: /chunk-vendors\.([^.]{8})\.js/g,
  cssApp: /app\.([^.]{8})\.css/g,
  cssVendor: /chunk-vendors\.([^.]{8})\.css/g
};

function main (filePath, result) {
  const files = fs.readdirSync(filePath);
  for (const file of files) {
    if (ignorePathRegExp.test(file)) {
      continue;
    }
    const _path = path.join(filePath, file);
    const stat = fs.statSync(_path);
    if (stat.isFile()) {
      if (!needCheckFileRegExp.test(_path)) {
        continue;
      }
      result.push(file);
    } else if (stat.isDirectory()) {
      main(_path, result);
    }
  }
  return result;
}

const result = main(filePath, []);
console.log(result);

let text = fs.readFileSync(indexPath).toString();
const regExps = Object.values(regExp);
for (const v of result) {
  for (const vv of regExps) {
    if (vv.test(v)) {
      text = text.replace(vv, v);
    }
  }
}
fs.writeFileSync(indexPath, text);
console.log('首页更新完成!');
