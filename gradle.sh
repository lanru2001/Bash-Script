#Bash script to install gradle:

# !/bin/bash
# installs to /opt/gradle
# existing versions are not overwritten/deleted
# seamless upgrades/downgrades
# $GRADLE_HOME points to latest *installed* (not released)
gradle_version=7.0
if [ ! -d "/opt/gradle" ];then
mkdir /opt/gradle
fi
if [ ! -f "./gradle-${gradle_version}-all.zip" ];then
wget -N http://services.gradle.org/distributions/gradle-${gradle_version}-all.zip
fi
unzip -oq ./gradle-${gradle_version}-all.zip -d /opt/gradle
ln -sfnv gradle-${gradle_version} /opt/gradle/latest
printf "export GRADLE_HOME=/opt/gradle/latest\nexport PATH=\$PATH:\$GRADLE_HOME/bin" > /etc/profile.d/gradle.sh
. /etc/profile.d/gradle.sh
hash -r ; sync
# check installation
gradle -v
