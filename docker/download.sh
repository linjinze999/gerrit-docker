# Download gerrit.war, libs, plugins(, hooks, mail) and tini(adopt container zombie processes).
# This script is unstable, you can try again when download fail.

cd `dirname $0`

##############################################################################
#                             Download gerrit.war                            #
#              https://gerrit-releases.storage.googleapis.com/               #
##############################################################################

echo "1. Download gerrit.war:"
GERRIT_VERSION=2.14.9
if [ -e "./gerrit-${GERRIT_VERSION}.war" ];then
  echo "      Already exist: gerrit-${GERRIT_VERSION}.war"
else
  echo "      Download gerrit-${GERRIT_VERSION}.war ..."
  curl https://gerrit-releases.storage.googleapis.com/gerrit-${GERRIT_VERSION}.war -o ./gerrit-${GERRIT_VERSION}.war --progress
fi

##############################################################################
#                                Download libs                               #
#                         http://mvnrepository.com/                          #
##############################################################################

echo ""
echo "2. Download libs:"
if [ ! -d "./lib_download/" ];then
  mkdir "./lib_download/"
fi

download_libs(){
  if [ -e "./lib_download/$2-$3.jar" ];then
    echo "      Already exist: $2-$3.jar"
  else
    echo "      Download $1/$2-$3.jar ..."
    curl http://central.maven.org/maven2/"$1"/"$2"/"$3"/"$2"-"$3".jar -o ./lib_download/"$2"-"$3".jar --progress
  fi
}

# 2.1 System Required
echo "  2.1 Download System Required."
# mysql/mysql-connector-java
download_libs "mysql" "mysql-connector-java" "5.1.41"

# 2.2 Running Required
echo "  2.2 Download Running Required."
# org.bouncycastle/bcpkix-jdk15on
download_libs "org/bouncycastle" "bcpkix-jdk15on" "1.58"
# org.bouncycastle/bcprov-jdk14
download_libs "org/bouncycastle" "bcprov-jdk14" "1.58"
# org.jrobin/jrobin
download_libs "org/jrobin" "jrobin" "1.5.9"

# 2.3 Plugin Required
echo "  2.3 Download Plugin Required."
# net.bull.javamelody/javamelody-core
download_libs "net/bull/javamelody" "javamelody-core" "1.65.0"


##############################################################################
#                              Download plugins                              #
#                   https://gerrit-ci.gerritforge.com/                       #
##############################################################################

echo ""
echo "3. Download plugins:"
if [ ! -d "./plugins_download/" ];then
  mkdir "./plugins_download/"
fi

PLUGIN_VERSION=bazel-stable-2.14
GERRITFORGE_URL=https://gerrit-ci.gerritforge.com/
GERRITFORGE_ARTIFACT_DIR=lastSuccessfulBuild/artifact/bazel-genfiles/plugins
GERRITFORGE_ARTIFACT_DIR_APP=lastSuccessfulBuild/artifact/gerrit/bazel-genfiles/plugins

# Download system plugins
echo "  3.1 Download system plugins."
download_system_plugin(){
  if [ -e "./plugins_download/$1.jar" ];then
    echo "      Already exist: $1.jar"
  else
    echo "      Download "$1".jar ..."
    curl ${GERRITFORGE_URL}/job/Gerrit-${PLUGIN_VERSION}/${GERRITFORGE_ARTIFACT_DIR_APP}/"$1"/"$1".jar -o ./plugins_download/"$1".jar --progress
  fi
}

system_plugins=(commit-message-length-validator download-commands hooks replication reviewnotes singleusergroup)
for plugin in ${system_plugins[@]}
do
  download_system_plugin ${plugin}
done


# Download extend plugins
echo "  3.2 Download extend plugins."
download_extend_plugin(){
  if [ -e "./plugins_download/$1.jar" ];then
    echo "      Already exist: $1.jar"
  else
    echo "      Download "$1".jar ..."
    curl ${GERRITFORGE_URL}/job/plugin-"$1"-${PLUGIN_VERSION}/${GERRITFORGE_ARTIFACT_DIR}/"$1"/"$1".jar -o ./plugins_download/"$1".jar --progress
  fi
}

extend_plugins=(admin-console delete-project force-draft importer javamelody serviceuser uploadvalidator gitiles its-bugzilla lfs reviewers-by-blame reviewers) 
for plugin in ${extend_plugins[@]}
do
  download_extend_plugin ${plugin}
done


##############################################################################
#                        Download tini-static-amd64                          #
#                      https://github.com/krallin/tini                       #
##############################################################################

echo ""
echo "4. Download tini:"
TINI_VERSION=0.18.0
if [ -e "./tini-static-amd64" ];then
  echo "      Already exist: tini-static-amd64"
else
  echo "      Download tini-static-amd64 ..."
  curl https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o ./tini-static-amd64 --progress
fi


##############################################################################
#                               Download hooks                               #
#                   copy your hooks to ./hooks_download                      #
##############################################################################

echo ""
echo "5. Download hooks:"
if [ -e "./hooks_download" ];then
  echo "      Already exist: hooks_download"
else
  echo "      Download hooks ..."
  # todo: copy your hooks to ./hooks_download
  mkdir ./hooks_download
fi


##############################################################################
#                                 Rsync mail                                 #
#              copy /etc/mail/ if you have your mail template                #
##############################################################################

echo ""
echo "6. Rsync mail:"
if [ -e "./etc_download/mail" ];then
  echo "      Already exist: etc_download/mail"
else
  echo "      Copy mail ..."
  # todo: copy /etc/mail/ if you have your mail template
  mkdir ./etc_download/
fi
