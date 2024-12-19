#!/bin/sh

# 复制项目的文件到对应docker路径，便于一键生成镜像。
usage() {
	echo "Usage: sh copy-html.sh"
	exit 1
}

# copy html
echo "begin copy html to ack "
cp -r ./dist/** ./docker/ack/dist

find ./docker/ack/dist -type f -name "index.html" |xargs sed -i "s#datakit_env#prod#g"
find ./docker/ack/dist -type f -name "index.html" |xargs sed -i "s#datakit_service#mall-admin-app-ack#g"

echo "begin copy html to vke "
cp -r ./dist/** ./docker/vke/dist
find ./docker/vke/dist -type f -name "index.html" |xargs sed -i "s#datakit_env#test#g"
find ./docker/vke/dist -type f -name "index.html" |xargs sed -i "s#datakit_service#mall-admin-app-vke#g"