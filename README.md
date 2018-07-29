# Gerrit

本文参考[https://github.com/openfrontier/docker-gerrit](https://github.com/openfrontier/docker-gerrit)进行编写，以gerrit-2.14.9版本为例，请注意修改对应版本。

## 一、镜像构建：
1. 执行以下脚本，下载gerrit.war、lib依赖包、plugin插件、容器僵尸进程处理文件(、hooks、mail邮件模板)：`./docker/download.sh`
**注意：**
  - 下载网站不稳定，可能下载失败，重复执行脚本即可。
  - 若你有自己的`hooks`钩子或`etc/mail`邮件模板，请修改脚本对应的代码。
  - 下载war包可能较慢，你可以参考脚本中的地址，提前下载到当前目录。
2. 执行构建命令：`cd docker && sudo docker build -t gerrit:2.14.9 .`（不要漏了后面的点）

## 二、启动容器：
1. 创建数据库容器：使用[官方Mysql镜像](https://hub.docker.com/_/mysql/)即可，启动命令参考如下`docker/mysql_run.sh`脚本（注意配置数据卷、gerrit数据库、sql安全模式）：
```
sudo docker run\
 --name gerrit-mysql\
 -p 3306:3306\
 -v /home/yourname/gerrit-mysql:/var/lib/mysql\
 -e MYSQL_ROOT_PASSWORD=root@mysql\
 -e MYSQL_DATABASE=reviewdb\
 -e MYSQL_USER=gerrit\
 -e MYSQL_PASSWORD=gerrit@mysql\
 -d mysql:5.7\
 --sql_mode=''
```
2. 启动gerrit容器：参考如下`docker/run.sh`脚本（注意配置映射端口/数据卷/域名/数据库）
参数可见： https://github.com/openfrontier/docker-gerrit/tree/2.14.9-slim（支持gerrit.config所有配置）
```
sudo docker run\
 --name gerrit\
 -p 8090:8080\
 -p 29418:29418\
 -v /home/yourname/gerrit-review_site:/home/gerrit/review_site\
 -e WEBURL=http://localhost:8090/gerrit/\
 -e HOOKCOMMANDURL=localhost:8090/gerrit\
 -e GITWEB_TYPE=gitiles\
 -e DATABASE_TYPE=mysql\
 -e DB_PORT_3306_TCP_ADDR=localhost\
 -e DB_PORT_3306_TCP_PORT=3306\
 -e DB_ENV_MYSQL_DB=reviewdb\
 -e DB_ENV_MYSQL_USER=gerrit\
 -e DB_ENV_MYSQL_PASSWORD=gerrit@mysql\
 -d gerrit:2.14.9
```
3. 备注：
  - a. 若挂载空目录时报空指针错误，则可能是连接了有数据的数据库，请确保数据库也为空；
  - b. 若想拷贝etc/mail邮件模板目录，修改`docker/download.sh`脚本，且`docker/run.sh`脚本中配置【-e COPY_MAILS=true】；
  - c. 若想拷贝器钩子脚本，修改`docker/download.sh`脚本，且`docker/run.sh`脚本中配置【-e COPY_HOOKS=true】；

## 三、k8s部署
见`k8s`文件夹下的部署文件