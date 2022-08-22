#!/usr/bin/env bash

set -e

run() {
  echo "runner_ver=$(/app/bin/jenkinsfile-runner-launcher --version)"
  runner_ver=$(/app/bin/jenkinsfile-runner-launcher --version)
  echo "jenkins-plugin-manager: ${plugin_manager_ver}"
  echo "java -jar /app/bin/jenkins-plugin-manager.jar --help"
  java -jar /app/bin/jenkins-plugin-manager.jar --help

  echo
  rm -rf /usr/share/jenkins/ref/plugins
  rm -rf /app/jenkins

  echo "wget http://ftp.halifax.rwth-aachen.de/jenkins/war/2.308/jenkins.war"
  wget http://ftp.halifax.rwth-aachen.de/jenkins/war/2.308/jenkins.war
  echo
  echo "Exploding ./jenkins-${JENKINS_VERSION}.war to /app/jenkins-${JENKINS_VERSION}"
  unzip ./jenkins-${JENKINS_VERSION}.war -d ./jenkins-${JENKINS_VERSION}
  

  echo
  echo "java -jar /app/bin/jenkins-plugin-manager.jar --war ./jenkins-${JENKINS_VERSION}.war --plugin-file /app/setup/plugins.txt --plugin-download-directory=/usr/share/jenkins/ref/plugins"
  java -jar /app/bin/jenkins-plugin-manager.jar --war ./jenkins-${JENKINS_VERSION}.war --plugin-file /app/setup/plugins.txt --plugin-download-directory=/usr/share/jenkins/ref/plugins

  echo
  ls -lrt /usr/share/jenkins/ref/plugins

  echo
  echo "/app/bin/jenkinsfile-runner-launcher lint --jenkins-war=./jenkins-${JENKINS_VERSION} --file=/app/setup/Jenkinsfile-helloworld --plugins=/usr/share/jenkins/ref/plugins"
  /app/bin/jenkinsfile-runner-launcher lint --jenkins-war=./jenkins-${JENKINS_VERSION} --file=/app/setup/Jenkinsfile-helloworld --plugins=/usr/share/jenkins/ref/plugins

  echo
  echo "/app/bin/jenkinsfile-runner-launcher run --jenkins-war=./jenkins-${JENKINS_VERSION} --file=/app/setup/Jenkinsfile-helloworld --plugins=/usr/share/jenkins/ref/plugins"
  /app/bin/jenkinsfile-runner-launcher run --jenkins-war=./jenkins-${JENKINS_VERSION} --file=/app/setup/Jenkinsfile-helloworld --plugins=/usr/share/jenkins/ref/plugins
}

run "${1}" "${2}"
