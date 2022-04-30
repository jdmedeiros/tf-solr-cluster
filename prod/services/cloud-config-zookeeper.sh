#!/bin/bash -x

USER=maria              # user to add or configure for - if adding an existing user, change the password manually
PASSWORD=Passw0rd       # password in case we add the user
DISPLAYMANAGER=lightdm  # lightdm or gdm3
SCRIPT_LOG_DETAIL=/var/log/cloud-config-detail.log
BOTSRVIP=172.26.1.10

exec 3>&1 4>&2                  #
trap 'exec 2>&4 1>&3' 0 1 2 3   # https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
exec 1>$SCRIPT_LOG_DETAIL 2>&1  #

yum -y update

sudo amazon-linux-extras install -y java-openjdk11 && sudo yum -y install java-11-openjdk-devel
echo JAVA_HOME "/usr/" >> /etc/profile.d/java.cshsetenv
echo JAVA_HOME=/usr/ >> /etc/profile.d/java.shexport
cd /opt
wget wget https://downloads.apache.org/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz
tar xvzf apache-zookeeper-3.8.0-bin.tar.gz
ln -s apache-zookeeper-3.8.0-bin zookeeper
cp zookeeper/conf/zoo_sample.cfg zookeeper/conf/zoo.cfg
cat /tmp/zoo.cfg >> /opt/zookeeper/conf/zoo.cfg
sed -i 's|"-Dzookeeper.log.file=${ZOO_LOG_FILE}"|"-Dzookeeper.log.file=${ZOO_LOG_FILE}" "-Dzookeeper.4lw.commands.whitelist=*"|g' /opt/zookeeper/bin/zkServer.sh
/opt/zookeeper/bin/zkServer.sh start