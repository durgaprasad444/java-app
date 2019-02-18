# Pull base image
From tomcat:8-jre8

# Maintainer
MAINTAINER "xxx <xxx@gmail.com">

# Copy to images tomcat path
ADD /var/lib/jenkins/workspace/maaa/target/hello-world-war-1.0.0.war  /usr/local/tomcat/webapps/
