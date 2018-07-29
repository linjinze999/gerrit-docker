# https://github.com/openfrontier/docker-gerrit/tree/2.14.9-slim
# Support all gerrit.config setting.
sudo docker run\
 --name gerrit\
 -p 8090:8080\
 -p 29418:29418\
 -v /home/yourname/gerrit-review_site:/home/gerrit/review_site\
 -e WEBURL=http://localhost:8090/gerrit/\
 -e HOOKCOMMANDURL=localhost:8090/gerrit\
 -e GITWEB_TYPE=gitiles\
 -e DATABASE_TYPE=mysql \
 -e DB_PORT_3306_TCP_ADDR=localhost\
 -e DB_PORT_3306_TCP_PORT=3306\
 -e DB_ENV_MYSQL_DB=reviewdb\
 -e DB_ENV_MYSQL_USER=gerrit\
 -e DB_ENV_MYSQL_PASSWORD=gerrit@mysql\
 -d gerrit:2.14.9
