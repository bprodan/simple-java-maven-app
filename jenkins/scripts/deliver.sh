#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
echo 'mvn jar:jar install:install help:evaluate -Dexpression=project.name'
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'The following complex command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
NAME=`mvn help:evaluate -Dexpression=project.name | grep "^[^\[]"`
set +x

echo 'The following complex command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
VERSION=`mvn help:evaluate -Dexpression=project.version | grep "^[^\[]"`
set +x

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
set -x
echo 'java -jar target/${NAME}-${VERSION}.jar'
java -jar target/${NAME}-${VERSION}.jar

echo 'The following command copy jar to artifactory'
set -x
curl -sSf -u "admin:password" -X PUT -T target/${NAME}-${VERSION}.jar 'http://172.18.0.4:8080/artifactory/simple/ext-release-local/b/b/b/vvv.jar'
