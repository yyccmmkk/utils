const fs = require('node:fs');
const path = require('node:path');
const filePath = path.resolve('./project-root');
const ignorePathRegExp = /node_modules/;
const needCheckFileRegExp = /\.(vue|jsx?|tsx?|)$/;
const keywords = ['101.10.12.65','cs.']
let count = 0;

function main(filePath){
    const files = fs.readdirSync(filePath);
    for(let file of files){
        if(ignorePathRegExp.test(file)){
            continue;
        }
        const _path = path.join(filePath,file);
        const stat = fs.statSync(_path);
        if(stat.isFile()){
            if(!needCheckFileRegExp.test(_path)){
                continue
            }
            const text = fs.readFileSync(_path).toString();
            for(let v of keywords){
                if(text.includes(v)){
                    console.log(_path,': 包含非法关键词-->',v);
                    count++;
                }
            }
          continue
        }
        if(stat.isDirectory()){
            main(_path);
        }
    }
}
main(filePath);
if(count!==0){
    console.warn('未通过安全检测：共有'+count+'文件包含测试环境API信息，请认真检查代码！')
    throw new Error('API 接口检查未通过！')
}
