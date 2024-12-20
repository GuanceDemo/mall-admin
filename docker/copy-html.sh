#!/bin/sh

# 复制项目的文件到对应docker路径，便于一键生成镜像。
usage() {
	echo "Usage: sh copy-html.sh"
	exit 1
}

# copy html
echo "begin copy html to ack "
cp -r ../dist ./ack/

find ./ack/dist -type f -name "index.html" |xargs sed -i "s#datakit_env#prod#g"
find ./ack/dist -type f -name "index.html" |xargs sed -i "s#datakit_service#mall-admin-app#g"
echo 'ls ./ack'
ls ./ack

echo "begin copy html to vke "
cp -r ../dist ./vke/
find ./vke/dist -type f -name "index.html" |xargs sed -i "s#datakit_env#test#g"
find ./vke/dist -type f -name "index.html" |xargs sed -i "s#datakit_service#mall-admin-app#g"
echo 'ls ./vke'
ls ./vke
