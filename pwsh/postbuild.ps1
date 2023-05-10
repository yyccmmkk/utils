cp -r ./build/*  ../deploy/deploy/h5-gqgl/build
ac ../deploy/deploy/local.ps1 '#h5-gqgl'
ac ../deploy/deploy/local.ps1 (gc pro.ps1)
