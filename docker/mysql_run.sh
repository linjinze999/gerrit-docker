#https://hub.docker.com/_/mysql/
sudo docker run\
 --name mysql\
 -p 3306:3306\
 -v /home/yourname/gerrit-mysql:/var/lib/mysql\
 -e MYSQL_ROOT_PASSWORD=root@mysql\
 -e MYSQL_DATABASE=reviewdb\
 -e MYSQL_USER=gerrit\
 -e MYSQL_PASSWORD=gerrit@mysql\
 -d mysql:5.7.22\
 --sql_mode=''
